import 'dart:math';

import 'package:flutter/material.dart';

class Crossword extends StatefulWidget {
  final List<List<String>> letters;
  final double cellSide;
  final Function(List<String> words) onLineDrawn;
  final List<String> words;

  const Crossword({
    super.key,
    required this.letters,
    required this.cellSide,
    required this.onLineDrawn,
    required this.words,
  });

  @override
  CrosswordState createState() => CrosswordState();
}

class CrosswordState extends State<Crossword> {
  final markedCells = <(int, int)>[];
  // a map to represent words and their corresponding answer path. null means the words anre not answered (traced) yet
  late final Map<String, ((int n, int m), (int n, int m))?> wordToPath;

  GlobalKey gridKey = GlobalKey();

  (int, int) identifyCell(Offset offset) {
    return (offset.dx ~/ widget.cellSide, offset.dy ~/ widget.cellSide);
  }

  bool checkCellCenterHit(Offset pointerPosition, (int, int) currentCell) {
    var cellCenter = Offset(
      widget.cellSide * currentCell.$1 + widget.cellSide / 2,
      widget.cellSide * currentCell.$2 + widget.cellSide / 2,
    );

    var distance = sqrt(pow(cellCenter.dx - pointerPosition.dx, 2) +
        pow(cellCenter.dy - pointerPosition.dy, 2));

    return distance <= widget.cellSide * 0.5;
  }

  bool hitTheGridTest(Offset pointer) {
    // perform a hit test to check if the pan is inside the GestureDetector (in the crossword grid)
    var box = gridKey.currentContext!.findRenderObject() as RenderBox;
    if (pointer.dx >= 0 &&
        pointer.dx <= box.size.width &&
        pointer.dy >= 0 &&
        pointer.dy <= box.size.height) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    wordToPath = {for (var word in widget.words) word: null};
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.cellSide * widget.letters.length,
      height: widget.cellSide * widget.letters[0].length,
      child: Stack(
        children: [
          CustomPaint(
            foregroundPainter: CrosswordPainter(
              cellSide: widget.cellSide,
              selectedLine: markedCells.length >= 2 ? (markedCells.first, markedCells.last) : null,
              answeredLines: [for(var val in wordToPath.values) val].nonNulls.toList(),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[400],
              ),
              width: widget.cellSide * widget.letters.length,
              height: widget.cellSide * widget.letters[0].length,
              child: Column(
                children: [
                  for (int i = 0; i < widget.letters.length; i++)
                    Row(
                      children: [
                        for (int j = 0; j < widget.letters[i].length; j++)
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
                                      widget.cellSide * 0.1),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.letters[i][j],
                                    style: TextStyle(
                                        fontSize: widget.cellSide * 0.3),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                ],
              ),
            ),
          ),
          Builder(builder: (context) {
            return GestureDetector(
              key:
                  gridKey, // the GestureDetector has a the same size as the entire crossword grid.
              onPanUpdate: (details) {
                // perform a hit test to make sure the pan is in the GestureDetector
                if (!hitTheGridTest(details.localPosition)) return;
                // find the current cell in which the pan lays
                var currentCell = identifyCell(details.localPosition);
                // check if pointer (finger position) is within some distance of the center of the cell
                if (!checkCellCenterHit(details.localPosition, currentCell))
                  return;
                if (markedCells.contains(currentCell)) return;
                // check if we're marking cells on a consistent line
                if (markedCells.length >= 2) {
                  var dx = markedCells[markedCells.length - 2].$1 -
                      markedCells[markedCells.length - 1].$1;
                  var dy = markedCells[markedCells.length - 2].$2 -
                      markedCells[markedCells.length - 1].$2;

                  if (dx !=
                          markedCells[markedCells.length - 1].$1 -
                              currentCell.$1 ||
                      dy !=
                          markedCells[markedCells.length - 1].$2 -
                              currentCell.$2) {
                    return;
                  }
                }

                // if all is good, we add the cell to the list of marked cells
                markedCells.add(currentCell);
                // and call setState for the customPaint to repaint.
                setState(() {});
              },
              onPanEnd: (details) {
                // check if the marked cells represent a correct answer
                // first construct the string from the row and col values of the marked cells
                var selection = '';
                for (var cell in markedCells) {
                  // remember: cell.$1 counts columns while cell.$2 counts rows
                  selection += widget.letters[cell.$2][cell.$1];
                }
                // and check if the string is in the list of answer words
                if (widget.words.contains(selection)) {
                  wordToPath[selection] =
                      (markedCells[0], markedCells[markedCells.length - 1]);
                }
                // finally clear the list of marked cells.
                markedCells.clear();
                setState(() {});
              },
            );
          })
        ],
      ),
    );
  }
}

class CrosswordPainter extends CustomPainter {
  double cellSide;
  ((int n, int m), (int n, int m))? selectedLine;
  List<((int n, int m), (int n, int m))> answeredLines;

  CrosswordPainter(
      {this.selectedLine, required this.cellSide, required this.answeredLines});

  /// paints the line spanning across the letters the user is currenly selecting (when the user is actively tracing)
  void paintSelectedLine(Canvas canvas) {
    if (selectedLine == null) return;
    var paint = Paint()
      ..strokeWidth = cellSide * 0.5
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromARGB(95, 36, 186, 250)
      ..style = PaintingStyle.stroke; 
    
    canvas.drawLine(
        Offset(
          (selectedLine!.$1.$1 * cellSide) + cellSide / 2,
          (selectedLine!.$1.$2 * cellSide) + cellSide / 2,
        ),
        Offset(
          (selectedLine!.$2.$1 * cellSide) + cellSide / 2,
          (selectedLine!.$2.$2 * cellSide) + cellSide / 2,
        ),
        paint);
  }

  void paintOverCorrectlyAnsweredWords(Canvas canvas) {
    var paint = Paint()
      ..strokeWidth = cellSide * 0.5
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromARGB(95, 36, 71, 250)
      ..style = PaintingStyle.stroke;

    for (var line in answeredLines) {
      canvas.drawLine(
          Offset(
            (line.$1.$1 * cellSide) + cellSide / 2,
            (line.$1.$2 * cellSide) + cellSide / 2,
          ),
          Offset(
            (line.$2.$1 * cellSide) + cellSide / 2,
            (line.$2.$2 * cellSide) + cellSide / 2,
          ),
          paint);
    }
  }

  @override
  void paint(canvas, size) {
    paintSelectedLine(canvas);
    paintOverCorrectlyAnsweredWords(canvas);
  }

  @override
  bool shouldRepaint(oldDelegate) {
    return true;
  }
}
