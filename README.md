# Majority Judgment for Dart

This package helps to resolve polls using [Majority Judgment](https://fr.wikipedia.org/wiki/Jugement_majoritaire).


## Features

- Efficient algorithm, scales well to billions of participants
- Configure whether to favor _adhesion_ or _contestation_ (default)
- Balance proposal tallies using a static default grade or the median grade
- Room for Central Judgment and Usual Judgment


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

Usual git flow: clone, branch, merge request.


## Authors

This package was made by [MieuxVoter](https://mieuxvoter.fr/), a french nonprofit.
