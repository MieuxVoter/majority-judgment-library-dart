# Majority Judgment for Dart

[![MIT](https://img.shields.io/github/license/MieuxVoter/majority-judgment-library-dart?style=for-the-badge)](LICENSE)
[![Release](https://img.shields.io/github/v/release/MieuxVoter/majority-judgment-library-dart?include_prereleases&style=for-the-badge)](https://github.com/MieuxVoter/majority-judgment-library-dart/releases)
[![Build Status](https://img.shields.io/github/workflow/status/MieuxVoter/majority-judgment-library-dart/Dart?style=for-the-badge)](https://github.com/MieuxVoter/majority-judgment-library-dart/actions/workflows/dart.yml)
[![Code Quality](https://img.shields.io/codefactor/grade/github/MieuxVoter/majority-judgment-library-dart?style=for-the-badge)](https://www.codefactor.io/repository/github/mieuxvoter/majority-judgment-library-dart)
![LoC](https://img.shields.io/tokei/lines/github/MieuxVoter/majority-judgment-library-dart?style=for-the-badge)
[![Discord Chat](https://img.shields.io/discord/705322981102190593.svg?style=for-the-badge)](https://discord.gg/rAAQG9S)


This Dart package helps to resolve polls using [Majority Judgment](https://fr.wikipedia.org/wiki/Jugement_majoritaire).


## Features

- Efficient Majority Judgment algorithm, scales well to billions of participants
- Configure whether to favor _adhesion_ or _contestation_ (default)
- Balance proposal tallies using a static default grade or the median grade[^median_todo]
- Room for Central Judgment and Usual Judgment

[^median_todo]: TODO, see #1 ; it's a good first issue if you want to contribute

## Get started

``` dart

import 'package:majority_judgment/majority_judgment.dart';

void main() {
    
      final pollTally = PollTally([
        [1, 2, 4, 2, 1], // Proposal A, from "worst" grade to "best" grade
        [1, 2, 4, 1, 2], // Proposal B
        [3, 1, 3, 1, 2], // Proposal C
        [1, 2, 4, 2, 1], // Proposal D (equal to A)
      ]);
      final mj = MajorityJudgmentResolver();
      final result = mj.resolve(pollTally);

      print(result.proposalsResults.map((ProposalResult p) => p.rank));
      //> (2, 1, 4, 2)

      print(result.sortedProposalsResults.map((ProposalResult p) => p.index));
      //> (1, 0, 3, 2)
    
}

```


## Contribute

Usual git flow: clone, tinker, request a merge.


## Authors

This package was made by [MieuxVoter](https://mieuxvoter.fr/), a french nonprofit.
