import 'dart:math';
import 'package:flutter/material.dart';

// estrutura para definir os intervalos
class TickRange {
  final double start;
  final double end;
  final double step;

  TickRange(this.start, this.end, this.step);
}

class LogRuler extends StatelessWidget {
  final double minVal;
  final double maxVal;
  final List<double> majorLabels;
  final List<TickRange> ranges;
  final String title;
  final double rulerWidth; // largura explícita para o CustomPainter

  const LogRuler({
    super.key,
    required this.minVal,
    required this.maxVal,
    required this.majorLabels,
    required this.ranges,
    required this.rulerWidth, // requer a largura
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        SizedBox(
          height: 70, // altura da régua
          width: rulerWidth, // usa a largura explicitamente definida
          child: CustomPaint(
            painter: _RulerPainter(
              minVal: minVal,
              maxVal: maxVal,
              majorLabels: majorLabels,
              ranges: ranges,
            ),
          ),
        ),
      ],
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double minVal;
  final double maxVal;
  final List<double> majorLabels;
  final List<TickRange> ranges;

  _RulerPainter({
    required this.minVal,
    required this.maxVal,
    required this.majorLabels,
    required this.ranges,
  });

  // função auxiliar para mapear valor -> pixel (Logarítmico)
  double _getX(double value, double width) {
    // normalização logarítmica: (log(x) - log(min)) / (log(max) - log(min))
    final logMin = log(minVal);
    final logMax = log(maxVal);

    // evita log(0) ou log de números menores que minVal, o que causaria NaN.
    if (value <= minVal) return 0.0;

    final logVal = log(value);

    final normalized = (logVal - logMin) / (logMax - logMin);
    return normalized * width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    final Paint majorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5;

    final double w = size.width;
    final double h = size.height;

    for (var range in ranges) {
      // Cálculo robusto de steps para evitar imprecisão de ponto flutuante
      double current = range.start;
      while (current <= range.end) {

        if (current >= minVal && current <= maxVal) {
          double x = _getX(current, w);
          // Altura segura: h / 4.0
          canvas.drawLine(Offset(x, h), Offset(x, h - (h / 4.0)), linePaint);
        }

        current += range.step;
        // Arredonda para garantir que o loop termine precisamente no 'end'
        if ((current - range.end).abs() < range.step * 0.001 && current > range.end) {
          break;
        }
      }
    }

    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    for (var label in majorLabels) {
      if (label < minVal || label > maxVal) continue;

      double x = _getX(label, w);

      canvas.drawLine(Offset(x, h), Offset(x, h - (h / 2.5)), majorPaint);

      final TextSpan textSpan = TextSpan(
        text: label.toStringAsFixed(label % 1 == 0 ? 0 : 1),
        style: textStyle,
      );
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - (textPainter.width / 2),
          h - (h / 2.5) - textPainter.height - 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) {
    // repinta apenas se os parâmetros principais mudarem
    return oldDelegate.minVal != minVal ||
        oldDelegate.maxVal != maxVal ||
        oldDelegate.majorLabels.length != majorLabels.length ||
        oldDelegate.ranges.length != ranges.length;
  }
}
