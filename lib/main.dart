import 'package:crossword_game_widget/crossword_game_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Crossword(
            letters: [
              'BCMOM'.split(''),
              'QAIIS'.split(''),
              'COLOR'.split(''),
              'ZWKLU'.split(''),
              'NLUJX'.split(''),
            ],
            cellSide: 60,
            onLineDrawn: (foundWords) {
              debugPrint('Found words: $foundWords');
            },
            words: const ['BALL', 'MILK', 'OWL', 'MOM', 'COLOR'],
          ),
        ),
      ),
    );
  }
}