import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lado1_screen.dart';
import 'theme_colors.dart';

const double kFixedVelocityWidth = 150.0;
const double kPowerBoxGap = 16.0;

const double kLineHeight = 20.0;
const double kMaxPowerLabelSpace = 25.0; // espaço para a label Potência Máxima
const double kBarHeight = 50.0; // altura da barra preta
const double kBarTopY = kMaxPowerLabelSpace; //

// mapa de marcadores label
const Map<String, ({double ratio, Color color, FontStyle style})> kPowerPositions = {
  // marcadores de solo (pretos)
  'Fofo/Solto': (ratio: 0.05, color: kValmetTextDark, style: FontStyle.normal),
  'Cultivado': (ratio: 0.11, color: kValmetTextDark, style: FontStyle.normal),
  'Firme': (ratio: 0.18, color: kValmetTextDark, style: FontStyle.normal),

  // marcadores de Potência (vermelhos, itálico)
  'TDP': (ratio: 0.50, color: kValmetRed, style: FontStyle.italic),
  'Motor': (ratio: 0.60, color: kValmetRed, style: FontStyle.italic),
};


class Lado2Screen extends StatelessWidget {
  const Lado2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // força a orientação para o modo paisagem
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // troca para o modo paisagem
    return Scaffold(
      backgroundColor: kValmetBeige,
      body: SafeArea(
        child: Column(
          children: [
            // botões e título
            _buildTopBar(context),

            Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) {

                    // variáveis para o calculo da largura real
                    const double contentPadding = 8.0;
                    const double boxInternalPadding = 12.0;

                    // largura total disponível
                    final double availableWidth = constraints.maxWidth - 2 * contentPadding;

                    // largura do recorte de referência (100% da régua)
                    final double fullRulerWidth = availableWidth - 2 * boxInternalPadding;

                    const int totalSegments = 10;
                    final double segmentWidth = fullRulerWidth / totalSegments;

                    // largura do recorte para "potência na barra de tração" (equivalente a 7,0 = 4 segmentos)
                    final double widthFor7_0 = 4 * segmentWidth;

                    // largura para "potência (cv)" (equivalente a 4,0 = 7 segmentos)
                    final double widthFor4_0 = 7 * segmentWidth;

                    // conteúdo scrollável
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(contentPadding),
                      child: Column(
                        children: [
                          _buildImplementTypeBox(),
                          const SizedBox(height: 8),
                          _buildSummaryBox(),
                          const SizedBox(height: 8),

                          // box 'potência (cv)' - com todos os marcadores
                          _buildPotenciaBox(widthFor4_0),
                          const SizedBox(height: 8),

                          // box 'potência na barra (cv)' - com largura fixa
                          _buildPowerBox(widthFor7_0),
                          const SizedBox(height: 8),

                          // box 'força de tração total' (referência)
                          _buildTractionForceBox(fullRulerWidth),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  // desenha uma linha vertical
  Widget _buildVerticalLine({required double height, required Color color}) {
    return CustomPaint(
      size: Size(1.0, height),
      painter: _LinePainter(color: color),
    );
  }

  // ------- Widgets de Componentes ------

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: kValmetRed,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // botão da página inicial (voltar)
          TextButton.icon(
            onPressed: () {
              //volta pra tela inicial e remove a restrição de orientação
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            label: const Text('Página inicial', style: TextStyle(color: Colors.white, fontSize: 14)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          // título da página
          const Text(
            'Lado 2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // botão de trocar de lado (lado 1)
          ElevatedButton(
            onPressed: () {
              // vai para a tela Lado 1 (que deve estar em modo paisagem)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lado1Screen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kValmetRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            child: const Text('Trocar de lado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildBox({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: kValmetTextDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(color: kValmetButtonGrey, thickness: 1, height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildImplementTypeBox() {
    return _buildBox(
      title: 'Tipo de implemento:',
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTypeButton('Subsolador', false),
          const SizedBox(width: 4),
          _buildTypeButton('Grade de Disco', false),
          const SizedBox(width: 4),
          _buildTypeButton('Arado', true), // selecionado por padrão para teste
        ],
      ),
    );
  }

  Widget _buildTypeButton(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? kValmetRed : kValmetButtonGrey,
        borderRadius: BorderRadius.circular(8),
        border: isSelected ? Border.all(color: kValmetRed, width: 2) : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : kValmetTextDark,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSummaryBox() {
    return _buildBox(
      title: 'Resumo do tipo de implemento selecionado',
      content: Row(
        children: [
          // textura do solo
          Expanded(
            child: _buildInfoDisplay(
              label: 'Textura do solo:',
              text: 'informações tiradas da régua sobreposta',
              isBlackBox: true, // simula o recorte
              height: 50,
              flex: 1,
            ),
          ),
          const SizedBox(width: 10),
          // esforço requerido
          Expanded(
            child: _buildInfoDisplay(
              label: 'Esforço requerido em:',
              text: 'kgf/m de ...',
              isBlackBox: true, // simula o recorte
              height: 50,
              flex: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPotenciaBox(double targetWidth) {
    const double totalStackHeight = kMaxPowerLabelSpace + kBarHeight + kLineHeight + 10;

    return _buildBox(
      title: "Tipos de Solo:",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            'Potência (cv)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // área principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(
                      height: totalStackHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [

                          // label 'Potência Máxima' (acima da barra)
                          _buildPowerRangeLabel(targetWidth),

                          // recorte da régua
                          Positioned(
                            left: 0,
                            top: kBarTopY,
                            child: Container(
                              height: kBarHeight,
                              width: targetWidth,
                              color: Colors.black,
                            ),
                          ),

                          // marcadores de solo, tdp e motor
                          ..._buildPowerBarMarkers(targetWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // texto 'DITA'
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'DITA',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: kValmetRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // função para criar o label "Potência Máxima" no lugar correto
  Widget _buildPowerRangeLabel(double containerWidth) {

    final double startRatio = kPowerPositions['TDP']!.ratio;
    final double endRatio = kPowerPositions['Motor']!.ratio;

    final double startX = containerWidth * startRatio;
    final double rangeWidth = containerWidth * (endRatio - startRatio);
    final double midPoint = startX + (rangeWidth / 2);

    return Positioned(
      left: midPoint,
      top: 0,
      child: Transform.translate(
        // desloca o texto para a esquerda pela metade de sua própria largura
        offset: const Offset(-50, 0),
        child: const Text(
          'Potência Máxima',
          style: TextStyle(
            color: kValmetRed,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1, // garante que o texto fique em uma linha só
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  // função para criar as linhas e as labels de todos os marcadores (Solo, TDP, Motor)
  List<Widget> _buildPowerBarMarkers(double containerWidth) {

    // posições base
    const double barY = kBarTopY;
    const double barHeight = kBarHeight;
    const double lineHeight = kLineHeight;

    // posições Y dos elementos
    const double topLabelY = 0; // para 'Cultivado'
    const double topLineStart = barY - lineHeight;
    const double bottomLineStart = barY + barHeight;
    const double bottomLabelY = bottomLineStart + lineHeight + 2;

    List<Widget> markers = [];

    kPowerPositions.forEach((label, config) {
      final double xPosition = containerWidth * config.ratio;

      final bool isCultivado = label == 'Cultivado';

      double lineStart;
      double labelY;
      double lineLength;
      double labelOffsetX = -20; // offset padrão para centralizar labels de 4-5 caracteres

      if (isCultivado) {

        lineStart = barY - (lineHeight * 0.7); // reduz a linha vertical do "Cultivado"
        labelY = topLabelY;
        lineLength = lineHeight * 0.7; // a linha é mais curta
        labelOffsetX = -25; // ajuste fino
      } else {
        // marcadores Fofo/Solto, Firme, TDP, Motor vão para baixo
        lineStart = bottomLineStart;
        labelY = bottomLabelY;
        lineLength = lineHeight;
        if (label == 'Fofo/Solto') {
          labelOffsetX = -25;
        } else if (label == 'TDP') {
          labelOffsetX = -15;
        } else if (label == 'Motor') {
          labelOffsetX = -18;
        } else if (label == 'Firme') {
          labelOffsetX = -15;
        }
      }

      // linha vertical
      markers.add(
        Positioned(
          left: xPosition,
          top: lineStart,
          child: _buildVerticalLine(height: lineLength, color: config.color),
        ),
      );

      // label de texto
      markers.add(
        Positioned(
          left: xPosition,
          top: labelY,
          child: Transform.translate(
            offset: Offset(labelOffsetX, 0),
            child: Text(
              label,
              style: TextStyle(
                color: config.color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontStyle: config.style,
              ),
            ),
          ),
        ),
      );
    });

    return markers;
  }

  Widget _buildPowerBox(double targetWidth) {
    return _buildBox(
      title: 'Potência na Barra de Tração (cv)',
      content: Row(
        children: [
          // recorte da régua
          Container(
            height: 50,
            width: targetWidth,
            color: Colors.black, // simula o recorte
          ),

          // gap entre os retângulos
          const SizedBox(width: kPowerBoxGap),

          // velocidade Típica (Largura fixa)
          Container(
            width: kFixedVelocityWidth,
            child: _buildInfoDisplay(
              label: 'Velocidade típica (km/h)',
              text: '0,0',
              isBlackBox: true,
              height: 50,
              flex: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTractionForceBox(double fullWidth) {
    // box 'força de tração total (kgf)'

    return _buildBox(
      title: 'Força de Tração Total (kgf)',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // area de recorte da régua - largura total (referência)
          Container(
            height: 50,
            width: fullWidth, // largura total (100% da referência)
            color: Colors.black, // simula o recorte
          ),
          const SizedBox(height: 5),

          // velocidade (km/h)
          const Text(
            'Velocidade (km/h)',
            style: TextStyle(fontSize: 12, color: kValmetTextDark),
          ),

          // eixos de régua
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15,0', style: TextStyle(fontSize: 10)),
              Text('10,0', style: TextStyle(fontSize: 10)),
              Text('9,0', style: TextStyle(fontSize: 10)),
              Text('8,0', style: TextStyle(fontSize: 10)),
              Text('7,0', style: TextStyle(fontSize: 10)),
              Text('6,0', style: TextStyle(fontSize: 10)),
              Text('5,0', style: TextStyle(fontSize: 10)),
              Text('4,0', style: TextStyle(fontSize: 10)),
              Text('3,0', style: TextStyle(fontSize: 10)),
              Text('2,5', style: TextStyle(fontSize: 10)),
              Text('2,0', style: TextStyle(fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDisplay({
    required String label,
    required String text,
    double height = 50,
    double width = double.infinity,
    int flex = 1,
    bool isBlackBox = false,
  }) {

    // widget para exibir informações de resumo
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBlackBox ? Colors.white70 : kValmetTextDark,
            fontSize: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: isBlackBox ? Colors.white : kValmetTextDark,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final box = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isBlackBox ? Colors.black : kValmetButtonGrey,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kValmetDarkGrey, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: content,
    );

    return flex > 0 ? Expanded(flex: flex, child: box) : box;
  }
}

class _LinePainter extends CustomPainter {
  final Color color;

  _LinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.butt;

    // desenha a linha de 0 até a largura total
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}