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
        for (final YamlList yamlTally in datum['tally']) {
          datumTally.add(ProposalTally(List.from(yamlTally.cast<int>())));
          // datumTally.add(ProposalTally(yamlTally.cast<int>() as List<int>));
        }
        final pollTally = PollTally(datumTally);
        if (datum['default_grade'] != null) {
          if (datum['default_grade'] is int) {
            pollTally.balanceWithGrade(grade: datum['default_grade'] as int);
          } else if (datum['default_grade'] is String) {
            if ('median' == datum['default_grade'] ||
                'majority' == datum['default_grade']) {
              pollTally.balanceWithMedian();
            } else {
              throw Exception('Unrecognized default grade:'
                  ' `${datum['default_grade'] as String}\'.');
            }
          }
        }
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
