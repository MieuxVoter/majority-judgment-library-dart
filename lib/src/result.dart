import 'package:majority_judgment/src/analysis.dart';

class PollResult {
  /// Results are sorted like the input proposals tallies
  List<ProposalResult> proposalsResults;
  /// Results are sorted by increasing rank, ie. "best" first
  List<ProposalResult> sortedProposalsResults;

  PollResult(
    this.proposalsResults,
    this.sortedProposalsResults,
  );
}

class ProposalResult {
  /// Index of the proposal in the input Tally
  int index;
  /// Computed rank of the proposal, according to MJ rules
  int rank;
  /// aka. Complete Majority Value
  String score;
  /// Detailed analysis of the merit profile
  Analysis analysis;

  ProposalResult(this.index, this.rank, this.score, this.analysis);
}
