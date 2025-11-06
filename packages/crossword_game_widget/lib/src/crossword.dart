import 'dart:math';

import 'package:flutter/material.dart';

import 'crossword_painter.dart';

typedef CrosswordSelectionCallback = void Function(List<String> words);

/// Displays an interactive crossword grid and handles user selections.
class Crossword extends StatefulWidget {
  const Crossword({
    super.key,
    required this.letters,
    required this.cellSide,
    required this.onLineDrawn,
    required this.words,
  });

  /// Matrix of characters to render within the crossword grid.
  final List<List<String>> letters;

  /// Visual size of each square cell in logical pixels.
  final double cellSide;

  /// Callback invoked when the user successfully traces a word.
  final CrosswordSelectionCallback onLineDrawn;

  /// List of valid words that can be discovered in the grid.
  final List<String> words;

  @override
  State<Crossword> createState() => _CrosswordState();
}

class _CrosswordState extends State<Crossword> {
  final GlobalKey _gridKey = GlobalKey();
  final List<CellCoordinate> _markedCells = <CellCoordinate>[];
  late final Map<String, (CellCoordinate start, CellCoordinate end)?> _wordToPath;

  @override
  void initState() {
    super.initState();
    _wordToPath = {for (final word in widget.words) word: null};
  }

  CellCoordinate _identifyCell(Offset offset) {
    return (offset.dx ~/ widget.cellSide, offset.dy ~/ widget.cellSide);
  }

  bool _checkCellCenterHit(Offset pointerPosition, CellCoordinate currentCell) {
    final cellCenter = Offset(
      widget.cellSide * currentCell.$1 + widget.cellSide / 2,
      widget.cellSide * currentCell.$2 + widget.cellSide / 2,
    );

    final distance = sqrt(pow(cellCenter.dx - pointerPosition.dx, 2) +
        pow(cellCenter.dy - pointerPosition.dy, 2));

    return distance <= widget.cellSide * 0.5;
  }

  bool _isPointerInsideGrid(Offset pointer) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    return pointer.dx >= 0 &&
        pointer.dx <= box.size.width &&
        pointer.dy >= 0 &&
        pointer.dy <= box.size.height;
  }

  bool _isConsistentLine(CellCoordinate cell) {
    if (_markedCells.length < 2) return true;

    final previousDelta = (
      _markedCells[_markedCells.length - 2].$1 -
          _markedCells[_markedCells.length - 1].$1,
      _markedCells[_markedCells.length - 2].$2 -
          _markedCells[_markedCells.length - 1].$2,
    );

    final newDelta = (
      _markedCells[_markedCells.length - 1].$1 - cell.$1,
      _markedCells[_markedCells.length - 1].$2 - cell.$2,
    );

    return previousDelta == newDelta;
  }

  void _handleSelectionEnd() {
    if (_markedCells.isEmpty) {
      setState(() {});
      return;
    }

    final buffer = StringBuffer();
    for (final cell in _markedCells) {
      buffer.write(widget.letters[cell.$2][cell.$1]);
    }

    final selection = buffer.toString();
    if (widget.words.contains(selection)) {
      _wordToPath[selection] = (_markedCells.first, _markedCells.last);
      widget.onLineDrawn([selection]);
    }

    _markedCells.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final crossedWords = _wordToPath.values.whereType<(
      CellCoordinate start,
      CellCoordinate end,
    )>().toList();

    return SizedBox(
      width: widget.cellSide * widget.letters.length,
      height: widget.cellSide * widget.letters.first.length,
      child: Stack(
        children: [
          CustomPaint(
            foregroundPainter: CrosswordPainter(
              cellSide: widget.cellSide,
              selectedLine: _markedCells.length >= 2
                  ? (_markedCells.first, _markedCells.last)
                  : null,
              answeredLines: crossedWords,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[400],
              ),
              width: widget.cellSide * widget.letters.length,
              height: widget.cellSide * widget.letters.first.length,
              child: Column(
                children: [
                  for (var i = 0; i < widget.letters.length; i++)
                    Row(
                      children: [
                        for (var j = 0; j < widget.letters[i].length; j++)
                          Container(
                            width: widget.cellSide,
                            height: widget.cellSide,
                            padding: EdgeInsets.all(widget.cellSide * 0.1),
                            child: Center(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    widget.cellSide * 0.1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.letters[i][j],
                                    style: TextStyle(
                                      fontSize: widget.cellSide * 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            key: _gridKey,
            onPanUpdate: (details) {
              if (!_isPointerInsideGrid(details.localPosition)) return;

              final currentCell = _identifyCell(details.localPosition);

              if (!_checkCellCenterHit(details.localPosition, currentCell)) {
                return;
              }

              if (_markedCells.contains(currentCell)) return;
              if (!_isConsistentLine(currentCell)) return;

              _markedCells.add(currentCell);
              setState(() {});
            },
            onPanEnd: (_) => _handleSelectionEnd(),
            onPanCancel: _handleSelectionEnd,
          ),
        ],
      ),
    );
  }
}
