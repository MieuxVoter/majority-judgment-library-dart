import 'dart:io';

import 'package:majority_judgment/majority_judgment.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Majority Judgment Resolver', () {

    final testFile = File('test/majority-judgment-tests.yml');
    final testYaml = testFile.readAsStringSync();
    final testData = loadYaml(testYaml) as Map;

    for (final datum in testData['tests']) {
      test(datum['name'], () {
        final datumTally = <ProposalTally>[];
        for (final yamlTally in datum['tally']) {
          datumTally.add(ProposalTally(yamlTally.cast<int>() as List<int>));
        }
        final pollTally = PollTally(datumTally);
        final mj = MajorityJudgmentResolver();
        //mj.favorContestation = true;
        final result = mj.resolve(pollTally);
        final ranks = result.proposalsResults.map((e) => e.rank);

        expect(ranks.length, equals((datum['ranks'].cast<int>()).length));
        expect(ranks, equals(datum['ranks'].cast<int>()));
      });
    }
  });
}
