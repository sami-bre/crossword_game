# Crossword Game Widget

`crossword_game_widget` is a reusable Flutter widget that renders an interactive
word-search style crossword puzzle. Embed it inside your Flutter applications to
deliver mini word games with line-tracing mechanics.

## Features

- Render a customizable grid of letters with configurable cell sizes
- Trace words by dragging across the grid; answered words remain highlighted
- Receive callbacks when the user discovers a word

## Getting Started

Add the dependency to your Flutter app:

```yaml
dependencies:
  crossword_game_widget:
    path: packages/crossword_game_widget
```

Import and use the widget:

```dart
import 'package:crossword_game_widget/crossword_game_widget.dart';

Crossword(
  letters: [
    'BCMOM'.split(''),
    'QAIIS'.split(''),
    'COLOR'.split(''),
    'ZWKLU'.split(''),
    'NLUJX'.split(''),
  ],
  words: const ['BALL', 'MILK', 'OWL', 'MOM', 'COLOR'],
  cellSide: 60,
  onLineDrawn: (foundWords) {
    debugPrint('Found: $foundWords');
  },
);
```

See `PUBLISHING_STEPS.md` for guidance on preparing the package for pub.dev.
