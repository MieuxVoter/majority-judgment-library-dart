
import 'package:majority_judgment/majority_judgment.dart';
import 'package:test/test.dart';

void main() {
  group('PollTally', () {
    test('Create a PollTally', () {
      final tallies = <List<int>>[
        <int>[0, 1, 2, 4, 5],  // Proposal A
        <int>[1, 0, 2, 0, 9],  // Proposal B
      ];
      final tally = PollTally(tallies);
      expect(tally, isNotNull);
    });

    test('Normalize a PollTally with a static default grade', () {
      final tallies = <List<int>>[
        <int>[0, 1, 0, 7, 0],  // Proposal A
        <int>[1, 0, 2, 0, 9],  // Proposal B
      ];
      final tally = PollTally(tallies).normalizeWithStaticDefault();
      // expect(tally.proposals, equals(<List<int>>[
      //   <int>[4, 1, 0, 7, 0],  // Proposal A
      //   <int>[1, 0, 2, 0, 9],  // Proposal B
      // ]));
      expect(tally.proposals[0].gradesTallies, equals(<int>[4, 1, 0, 7, 0]));
      expect(tally.proposals[1].gradesTallies, equals(<int>[1, 0, 2, 0, 9]));
    });

    // test('Fail to create an empty PollTally', () {
    //   expect(
    //     () {
    //       final tally = PollTally();
    //     },
    //     throwsException
    //   );
    // });
  });

}
