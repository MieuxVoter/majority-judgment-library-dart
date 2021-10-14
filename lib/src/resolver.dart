import 'package:majority_judgment/src/analysis.dart';
import 'package:majority_judgment/src/result.dart';
import 'package:majority_judgment/src/tally.dart';

/// Interface for the various Resolvers.  Maybe over-engineering.
abstract class Resolver {
  PollResult resolve(PollTally tally);
}

/// See https://en.wikipedia.org/wiki/Majority_judgment
class MajorityJudgmentResolver implements Resolver {
  /// When both adhesion and contestation groups are of equal size,
  /// which one will define the second median grade ?
  /// We favor contestation by default, for a bunch of reasons: precaution,
  /// conservatism, emotional investment, default grade as the "worst" grade…
  /// Set this to false to favor adhesion instead.
  /// Note that this rule is important in low-participation polls, [cit. needed]
  /// but quickly wanes as participation rises.
  bool favorContestation = true;

  @override
  PollResult resolve(PollTally tally) {
    final amountOfProposals = tally.proposals.length;
    final proposalsResults = <ProposalResult>[];
    final sortedProposalsResults = <ProposalResult>[];

    if (0 == amountOfProposals) {
      return PollResult(proposalsResults, sortedProposalsResults);
    }

    final amountOfJudges = tally.proposals[0].countJudgments();
    for (final proposal in tally.proposals) {
      if (proposal.countJudgments() != amountOfJudges) {
        throw Exception('''
Some proposals hold more judgments than others.  
Balance your tally first, perhaps using a PollTally#balanceWith…() method?''');
      }
    }

    var index = 0;
    for (final proposal in tally.proposals) {
      final analysis = Analysis();
      const rank = 1; // We'll set the actual rank later, after the score sort
      final score = computeScore(proposal);
      analysis.run(proposal, favorContestation);
      final result = ProposalResult(index, rank, score, analysis);
      proposalsResults.add(result);
      sortedProposalsResults.add(result);
      index++;
    }

    sortedProposalsResults.sort((a, b) => b.score.compareTo(a.score));

    var rank = 1;
    for (var curr = 0; curr < amountOfProposals; curr++) {
      if ((curr > 0) &&
          (sortedProposalsResults[curr - 1].score !=
              sortedProposalsResults[curr].score)) {
        rank = curr + 1;
      }
      sortedProposalsResults[curr].rank = rank;
    }

    return PollResult(proposalsResults, sortedProposalsResults);
  }

  /// Score = Complete Majority Value
  String computeScore(ProposalTally tally) {
    var score = StringBuffer();

    final analysis = Analysis();
    final amountOfGrades = tally.countAvailableGrades();
    final amountOfJudgments = tally.countJudgments();
    final amountOfDigitsForGrade = countDigits(amountOfGrades);
    final amountOfDigitsForAdhesionScore = countDigits(amountOfJudgments * 2);

    final mutatedTally = tally.clone();
    for (var i = 0; i < amountOfGrades; i++) {
      analysis.run(mutatedTally, favorContestation);

      score.write(
          analysis.medianGrade.toString().padLeft(amountOfDigitsForGrade, '0'));

      final adhesionScore = amountOfJudgments +
          analysis.secondGroupSize * analysis.secondGroupSign;

      score.write(adhesionScore
          .toString()
          .padLeft(amountOfDigitsForAdhesionScore, '0'));

      mutatedTally.regradeJudgments(
        analysis.medianGrade,
        analysis.secondMedianGrade,
      );
    }

    return score.toString();
  }

  /// Count the digits (base 10) of the provided integer.
  int countDigits(int amount) {
    if (0 == amount) {
      return 1;
    }
    // if (0 > amount) return countDigits(-1 * amount);
    assert(0 < amount); // we prefer above, but linter complains
    var count = 0;
    while (amount > 0) {
      amount = amount ~/ 10;
      count++;
    }
    return count;
  }
}
