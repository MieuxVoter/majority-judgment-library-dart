import 'package:majority_judgment/majority_judgment.dart';
import 'package:test/test.dart';

void main() {
  test('README example', () {
    final pollTally = PollTally([
      [1, 2, 4, 2, 1], // Proposal A
      [1, 2, 4, 1, 2], // Proposal B
      [3, 1, 3, 1, 2], // Proposal C
      [1, 2, 4, 2, 1], // Proposal D (equal to A)
    ]);
    final mj = MajorityJudgmentResolver();
    final result = mj.resolve(pollTally);

    // print(result.proposalsResults.map((ProposalResult p) => p.rank));
    // >>> (2, 1, 4, 2)
    // that is:
    expect(result.proposalsResults.map((ProposalResult p) => p.rank),
        equals([2, 1, 4, 2]));

    // print(result.sortedProposalsResults.map((ProposalResult p) => p.index));
    // >>> (1, 0, 3, 2)
    // that is:
    expect(result.sortedProposalsResults.map((ProposalResult p) => p.index),
        equals([1, 0, 3, 2]));
  });
}
