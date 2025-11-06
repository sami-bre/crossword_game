import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef CellCoordinate = (int column, int row);

/// Paints the selection and completed word paths for a crossword grid.
class CrosswordPainter extends CustomPainter {
  CrosswordPainter({
    required this.cellSide,
    this.selectedLine,
    required this.answeredLines,
  });

  /// The size of each cell in the crossword grid.
  final double cellSide;

  /// The currently selected path while the user is tracing a word.
  final (CellCoordinate start, CellCoordinate end)? selectedLine;

  /// The set of successfully answered word paths.
  final List<(CellCoordinate start, CellCoordinate end)> answeredLines;

  /// Paints the line spanning across the letters the user is currently selecting.
  void _paintSelectedLine(Canvas canvas) {
    if (selectedLine == null) return;

    final paint = Paint()
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
      paint,
    );
  }

  /// Paints overlays for the words that have already been discovered.
  void _paintAnsweredLines(Canvas canvas) {
    final paint = Paint()
      ..strokeWidth = cellSide * 0.5
      ..strokeCap = StrokeCap.round
      ..color = const Color.fromARGB(95, 36, 71, 250)
      ..style = PaintingStyle.stroke;

    for (final line in answeredLines) {
      canvas.drawLine(
        Offset((line.$1.$1 * cellSide) + cellSide / 2,
            (line.$1.$2 * cellSide) + cellSide / 2),
        Offset((line.$2.$1 * cellSide) + cellSide / 2,
            (line.$2.$2 * cellSide) + cellSide / 2),
        paint,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintSelectedLine(canvas);
    _paintAnsweredLines(canvas);
  }

  @override
  bool shouldRepaint(CrosswordPainter oldDelegate) {
    return selectedLine != oldDelegate.selectedLine ||
        !listEquals(answeredLines, oldDelegate.answeredLines) ||
        cellSide != oldDelegate.cellSide;
  }
}
