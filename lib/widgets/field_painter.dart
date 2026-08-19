import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/set_data.dart';

class FieldPainter extends CustomPainter {
  final SetData? currentSet;
  final List<Player> players;
  final String? selectedPlayerId;
  final double progress; // 0.0 to 1.0 for animation between sets
  final SetData? nextSet;

  FieldPainter({
    this.currentSet,
    required this.players,
    this.selectedPlayerId,
    this.progress = 0.0,
    this.nextSet,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke;

    // Green field
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF2E7D32),
    );

    // Field dimensions (high school)
    // x: -50 to +50 yards, y: 0 (back) to 53.333 (front)
    final fieldWidth = size.width * 0.92;
    final fieldHeight = size.height * 0.85;
    final left = (size.width - fieldWidth) / 2;
    final top = (size.height - fieldHeight) / 2;

    // White lines
    paint
      ..color = Colors.white
      ..strokeWidth = 1.5;

    // Outer border
    canvas.drawRect(Rect.fromLTWH(left, top, fieldWidth, fieldHeight), paint);

    // Yard lines every 5 yards
    for (int y = -50; y <= 50; y += 5) {
      final x = left + ((y + 50) / 100) * fieldWidth;
      paint.strokeWidth = (y % 10 == 0) ? 2.0 : 1.0;
      canvas.drawLine(Offset(x, top), Offset(x, top + fieldHeight), paint);
    }

    // Hash marks (high school: 53'4" from sidelines ≈ 0.333 of width from each side)
    final hashInset = fieldHeight * 0.333;
    paint.strokeWidth = 1.5;
    for (int y = -45; y <= 45; y += 5) {
      final x = left + ((y + 50) / 100) * fieldWidth;
      // Front hash
      canvas.drawLine(
        Offset(x, top + hashInset - 4),
        Offset(x, top + hashInset + 4),
        paint,
      );
      // Back hash
      canvas.drawLine(
        Offset(x, top + fieldHeight - hashInset - 4),
        Offset(x, top + fieldHeight - hashInset + 4),
        paint,
      );
    }

    // 50 yard line thicker
    final midX = left + fieldWidth / 2;
    paint.strokeWidth = 3;
    canvas.drawLine(Offset(midX, top), Offset(midX, top + fieldHeight), paint);

    // Draw players
    if (currentSet != null) {
      for (final player in players) {
        Offset? pos = currentSet!.positions[player.id];
        if (pos == null) continue;

        // Animate if nextSet exists
        if (nextSet != null && nextSet!.positions.containsKey(player.id)) {
          final nextPos = nextSet!.positions[player.id]!;
          pos = Offset.lerp(pos, nextPos, progress)!;
        }

        final screenPos = _toScreen(pos, left, top, fieldWidth, fieldHeight);

        // Dot
        canvas.drawCircle(
          screenPos,
          selectedPlayerId == player.id ? 14 : 11,
          Paint()..color = player.color,
        );
        canvas.drawCircle(
          screenPos,
          selectedPlayerId == player.id ? 14 : 11,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );

        // Number
        final textPainter = TextPainter(
          text: TextSpan(
            text: player.number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(
          canvas,
          screenPos - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  Offset _toScreen(Offset fieldPos, double left, double top, double w, double h) {
    // fieldPos.dx: -50 → 50, fieldPos.dy: 0 (back) → 53.333 (front)
    final x = left + ((fieldPos.dx + 50) / 100) * w;
    final y = top + (1 - (fieldPos.dy / 53.333)) * h;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant FieldPainter oldDelegate) => true;
}
