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
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
      ..strokeWidth = 1.0;

    final Paint majorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    final double w = size.width;
    final double h = size.height;

    // a régua está dentro de um recorte, então não desenhamos a linha base.
    // o recorte da barra preta do Lado 2 será o que define a linha base visualmente.

    // 1. gerar e desenhar ticks menores (ranges)
    for (var range in ranges) {
      // floor evita problemas de ponto flutuante no loop
      int steps = ((range.end - range.start) / range.step).floor();
      for (int i = 0; i <= steps; i++) {
        double val = range.start + (i * range.step);

        // garante que o valor esteja dentro do range principal [minVal, maxVal]
        if (val < minVal || val > maxVal) continue;

        double x = _getX(val, w);
        // desenha traço curto (tick nenor) - altura 1/6 da régua
        canvas.drawLine(Offset(x, h), Offset(x, h - (h / 6)), linePaint);
      }
    }

    // 2. desenhar labels principais (texto e traço longo)
    final textStyle = const TextStyle(color: Colors.black, fontSize: 10);

    for (var label in majorLabels) {
      if (label < minVal || label > maxVal) continue;

      double x = _getX(label, w);

      // traço longo (tick maior) - altura 1/3 da régua
      canvas.drawLine(Offset(x, h), Offset(x, h - (h / 3)), majorPaint);

      // desenhar Texto
      final TextSpan textSpan = TextSpan(
        text: label.toStringAsFixed(label % 1 == 0 ? 0 : 1), // remove casas decimais se for inteiro
        style: textStyle,
      );
      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // centralizar texto no tick e posicionar acima da régua
      textPainter.paint(canvas, Offset(x - (textPainter.width / 2), h - (h / 3) - textPainter.height - 5));
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