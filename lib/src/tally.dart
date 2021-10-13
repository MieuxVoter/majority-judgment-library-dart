import 'dart:math' show max;

// Tally of a single proposal, that is the amount of judgments they received
// for each grade.  This class is basically a wrapper around a list of ints.
class ProposalTally {
  // For each grade from "worst" to "best", the amount of judgments received.
  List<int> gradesTallies;

  ProposalTally(this.gradesTallies);

  ProposalTally clone() {
    return ProposalTally(List.from(gradesTallies));
  }

  // Count all the judgments received by the proposal, across all grades.
  int countJudgments() {
    return gradesTallies
        .reduce((total, gradeJudgments) => total + gradeJudgments);
  }

  // Count the available grades in the grading scale.  Usually around 7.
  int countAvailableGrades() {
    return gradesTallies.length;
  }

  // This mutates the tally.  Used in score calculus.
  ProposalTally regradeJudgments(int fromGrade, int intoGrade) {
    gradesTallies[intoGrade] += gradesTallies[fromGrade];
    gradesTallies[fromGrade] = 0;
    return this;
  }
}

// The main input of this package.
// This holds the amounts of judgments received for each grade,
// (from "worst" grade to "best" grade), for each proposal.
// Create an instance of this and provide it to the Deliberator.
class PollTally {
  // Amount of judgments received for each grade, for each proposal.
  // Grades are expected to be tallied from "worst" grade to "best" grade.
  // Example value:
  // [
  //   [1, 4, 5, 2, 4, 4, 2],  // Proposal A
  //   [0, 1, 4, 5, 3, 4, 1],  // Proposal B
  //   …
  // ]
  List<ProposalTally> proposals = [];

  PollTally(dynamic proposals) {
    if (proposals is Iterable) {
      for (final proposal in proposals) {
        if (proposal is ProposalTally) {
          this.proposals.add(proposal);
        } else if (proposal is List<int>) {
          this.proposals.add(ProposalTally(proposal));
        } else if (proposal is List<num>) {
          this.proposals.add(ProposalTally(proposal as List<int>));
        } else {
          throw Exception('PollTally expects a List<ProposalTally>.');
        }
      }
    } else {
      throw Exception('PollTally expects a List<List<int>>.');
    }
  }

  // Balance your proposal tallies
  // so that they all hold the same total amount of judgments.
  // This adds judgments of the specified grade (default: "worst" grade),
  // as many as needed (if any) to each proposal to balance the tallies.
  PollTally balanceWithGrade({int grade = 0}) {
    final amountOfProposals = proposals.length;
    final amountsOfParticipants = List.filled(amountOfProposals, 0);
    var maxAmountOfParticipants = 0;
    for (var i = 0; i < amountOfProposals; i++) {
      final proposalTally = proposals[i];
      final amountOfParticipants = proposalTally.countJudgments();
      amountsOfParticipants[i] = amountOfParticipants;
      maxAmountOfParticipants = max(
        amountOfParticipants,
        maxAmountOfParticipants,
      );
    }
    for (var i = 0; i < amountOfProposals; i++) {
      final proposalTally = proposals[i];
      final missingAmount = maxAmountOfParticipants - amountsOfParticipants[i];
      proposalTally.gradesTallies[grade] += missingAmount;
    }

    return this;
  }

  @Deprecated('Use balanceWithGrade() instead')
  PollTally normalizeWithStaticDefault({int grade = 0}) {
    return balanceWithGrade(grade: grade);
  }
}
