// Analysis of the tally of a single proposal (its merit profile)
// Provides everything but the score and rank, and is used to compute them.
import 'package:majority_judgment/majority_judgment.dart';

class Analysis {
  late int totalSize;
  late int medianGrade;
  late int medianGroupSize;
  late int secondMedianGrade;
  late int secondGroupSize;
  late int secondGroupSign;
  late int adhesionGroupGrade;
  late int adhesionGroupSize;
  late int contestationGroupGrade;
  late int contestationGroupSize;

  void reset() {
    totalSize = 0;
    medianGrade = 0;
    medianGroupSize = 0;
    secondMedianGrade = 0;
    secondGroupSize = 0;
    secondGroupSign = 0;
    adhesionGroupGrade = 0;
    adhesionGroupSize = 0;
    contestationGroupGrade = 0;
    contestationGroupSize = 0;
  }

  void run(ProposalTally proposalTally, bool favorContestation) {
    reset();

    totalSize = proposalTally.countJudgments();
    if (0 == totalSize) {
      return;
    }

    final adjustedTotal = (favorContestation) ? totalSize - 1 : totalSize;
    final medianIndex = adjustedTotal ~/ 2; // Euclidean division
    var startIndex = 0;
    var cursorIndex = 0;
    final amountOfGrades = proposalTally.countAvailableGrades();
    for (var gradeIndex = 0; gradeIndex < amountOfGrades; gradeIndex++) {
      final gradeTally = proposalTally.gradesTallies[gradeIndex];
      if (0 == gradeTally) {
        continue;
      }
      startIndex = cursorIndex;
      cursorIndex += gradeTally;

      if ((startIndex < medianIndex) && (cursorIndex <= medianIndex)) {
        contestationGroupSize += gradeTally;
        contestationGroupGrade = gradeIndex;
      } else if ((startIndex <= medianIndex) && (medianIndex < cursorIndex)) {
        medianGroupSize = gradeTally;
        medianGrade = gradeIndex;
      } else if ((startIndex > medianIndex) && (medianIndex < cursorIndex)) {
        adhesionGroupSize += gradeTally;
        if (0 == adhesionGroupGrade) {
          adhesionGroupGrade = gradeIndex;
        }
      }
    }

    final contestationIsBiggest = (favorContestation)
        ? adhesionGroupSize <= contestationGroupSize
        : adhesionGroupSize < contestationGroupSize;
    if (contestationIsBiggest) {
      secondMedianGrade = contestationGroupGrade;
      secondGroupSize = contestationGroupSize;
      if (0 < secondGroupSize) {
        secondGroupSign = -1;
      }
    } else {
      secondMedianGrade = adhesionGroupGrade;
      secondGroupSize = adhesionGroupSize;
      if (0 < secondGroupSize) {
        secondGroupSign = 1;
      }
    }
  }
}
