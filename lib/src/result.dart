// Stores the result of the majority judgment resolution
import 'package:majority_judgment/src/analysis.dart';

class PollResult {
  // Results are sorted like the input proposals tallies
  List<ProposalResult> proposalsResults;
  // Results are sorted by increasing rank, ie. "best" first
  List<ProposalResult> sortedProposalsResults;

  PollResult(
    this.proposalsResults,
    this.sortedProposalsResults,
  );
}

class ProposalResult {
  int index;
  int rank;
  String score;
  Analysis analysis;

  ProposalResult(this.index, this.rank, this.score, this.analysis);
}
