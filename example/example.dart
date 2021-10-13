// ignore_for_file: avoid_print

import 'package:majority_judgment/majority_judgment.dart';

void main() {
  final pollTally = PollTally([
    [1, 2, 4, 2, 1], // Proposal A, from "worst" grade to "best" grade
    [1, 2, 4, 1, 2], // Proposal B
    [3, 1, 3, 1, 2], // Proposal C
    [1, 2, 4, 2, 1], // Proposal D (equal to A)
  ]);
  //pollTally.balanceWithStaticDefault(); // use a balancer if necessary
  final mj = MajorityJudgmentResolver();
  final result = mj.resolve(pollTally);

  print(result.proposalsResults.map((ProposalResult p) => p.rank));
  //> (2, 1, 4, 2)

  print(result.sortedProposalsResults.map((ProposalResult p) => p.index));
  //> (1, 0, 3, 2)
}
