import 'package:flutter/material.dart';

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
