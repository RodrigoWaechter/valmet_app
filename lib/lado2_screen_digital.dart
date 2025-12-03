import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'lado1_screen.dart';
import 'theme_colors.dart';
import 'ruler_log_painter.dart';

// ============================================================================
// CONSTANTES DE LAYOUT E CONFIGURAÇÃO
// ============================================================================

const double kFixedVelocityWidth = 150.0;     // largura fixa para a caixa de texto de velocidade, impedindo que ela se expanda
const double kPowerBoxGap = 16.0;             // espaçamento horizontal entre a régua e a caixa de velocidade
const double kLineHeight = 20.0;              // altura da linha vertical dos marcadores (TDP, Motor, Solos)
const double kMaxPowerLabelSpace = 25.0;      // espaço reservado acima da barra preta para o label "Potência Máxima"
const double kBarHeight = 50.0;               // altura da barra preta (recorte visual da régua)
const double kBarTopY = kMaxPowerLabelSpace;  // posição Y (topo) onde a barra preta começa dentro do stack
const double kRulerTotalWidth = 2000.0;       // largura total virtual da régua desenhada
const double kRuleInitialOffset = 15.0;       // espaço na lateral esquerda para evitar que o primeiro número seja cortado

/// mapa de configuração dos marcadores sobre a régua de potência
/// contém a razão (0.0 a 1.0) da posição horizontal, a cor e o estilo do texto
const Map<String, ({double ratio, Color color, FontStyle style})> kPowerPositions = {
  'Fofo/Solto': (ratio: 0.05, color: kValmetTextDark, style: FontStyle.normal),
  'Cultivado': (ratio: 0.11, color: kValmetTextDark, style: FontStyle.normal),
  'Firme': (ratio: 0.18, color: kValmetTextDark, style: FontStyle.normal),
  'TDP': (ratio: 0.50, color: kValmetRed, style: FontStyle.italic),
  'Motor': (ratio: 0.60, color: kValmetRed, style: FontStyle.italic),
};

// ============================================================================
// DADOS DOS IMPLEMENTOS
// ============================================================================

// mapa com as informações estáticas para cada tipo de implemento
const Map<String, Map<String, String>> kImplementData = {
  'Subsolador': {
    'textura': 'Massapé (2050), Argiloso (1600), Misto (1400), Arenoso (1100)',
    'esforco': 'kgf/m de largura de corte',
    'velocidade': '5,0 a 8,0',
  },
  'Grade de Disco': {
    'textura': ' Argiloso firme (1,4) \n Misto firme, Argiloso cultivado ou arenoso (1,2) \n Misto cultivado (1,0)',
    'esforco': 'kgf/kg de peso da grade\n\n',
    'velocidade': 'Aradora (5,0 a 7,0)  Intermediária (6,0 a 9,0)  Niveladora (8,0 a 12,0)',
  },
  'Arado': {
    'textura': 'Argiloso (23), Misto (15)',
    'esforco': 'kgf/cm de profundidade/haste',
    'velocidade': '4,0 a 6,0'
  },
};

// ============================================================================
// TELA LADO 2
// ============================================================================

class Lado2Screen extends StatefulWidget {
  const Lado2Screen({super.key});

  @override
  State<Lado2Screen> createState() => _Lado2ScreenState();
}

class _Lado2ScreenState extends State<Lado2Screen> {
  /// variável de estado que armazena a posição atual da régua (scroll horizontal)
  /// 0.0 representa o início da régua (esquerda)
  double _scrollOffset = 0.0;

  /// limite máximo de scroll calculado com base na largura da régua
  final double _maxScrollExtent = kRulerTotalWidth - 400.0;
  String _selectedImplement = 'Subsolador';

  bool _isLandscapeMode = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // restaura a orientação do dispositivo para vertical/livre ao sair desta tela
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  /// lógica central de sincronização
  /// atualiza o [_scrollOffset] baseado no movimento horizontal do user
  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {

      if (!_isLandscapeMode) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        _isLandscapeMode = true;
      }

      _scrollOffset -= details.primaryDelta!;

      // aplica limites para não sair da área da régua
      if (_scrollOffset < 0) _scrollOffset = 0;
      if (_scrollOffset > _maxScrollExtent) _scrollOffset = _maxScrollExtent;
    });
  }

  void _onImplementSelected(String implementName) {
    setState(() {
      _selectedImplement = implementName;
    });
  }

  /// constrói uma linha vertical fina usada nos marcadores
  Widget _buildVerticalLine({required double height, required Color color}) {
    return CustomPaint(
      size: Size(1.0, height),
      painter: _LinePainter(color: color),
    );
  }

  /// constrói a "Janela da Régua"
  /// este widget cria um recorte visual que exibe apenas a porção relevante da régua
  /// baseada no [_scrollOffset] atual
  Widget _buildRulerWindow(
      double width, {
        required double minVal,
        required double maxVal,
        required List<double> majorLabels,
        required List<TickRange> ranges,
      }) {

    // instância da régua logarítmica (CustomPainter)
    final ruler = LogRuler(
      minVal: minVal,
      maxVal: maxVal,
      majorLabels: majorLabels,
      ranges: ranges,
      rulerWidth: kRulerTotalWidth,
    );

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2), // borda preta do recorte
      ),

      child: ClipRect(
        child: Transform.translate(
          // a régua é movida inteira para a esquerda
          offset: Offset(kRuleInitialOffset - _scrollOffset, 0),
          child: OverflowBox(
            // alinhamento inferior para garantir que os tracinhos apareçam
            alignment: Alignment.bottomLeft,
            // permite que o filho (a régua de 5000px) seja maior que o pai (o recorte)
            maxWidth: kRulerTotalWidth + kRuleInitialOffset,
            minWidth: kRulerTotalWidth + kRuleInitialOffset,
            maxHeight: 70, // altura real do desenho da régua (maior que o recorte para caber labels)
            minHeight: 70,
            child: Padding(
                padding: const EdgeInsets.only(left: kRuleInitialOffset),
                  child: ruler,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kValmetBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),

            // area principal expansível
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // cálculos de layout responsivo
                  const double contentPadding = 8.0;
                  const double boxInternalPadding = 12.0;

                  final double availableWidth = constraints.maxWidth - 2 * contentPadding;
                  final double fullRulerWidth = availableWidth - 2 * boxInternalPadding;

                  // divide a largura total em 10 segmentos para proporção
                  const int totalSegments = 10;
                  final double segmentWidth = fullRulerWidth / totalSegments;

                  // larguras proporcionais para os recortes
                  final double widthFor7_0 = 4 * segmentWidth; // 40%
                  final double widthFor4_0 = 7 * segmentWidth; // 70%

                  return GestureDetector(
                    onHorizontalDragUpdate: _handleDragUpdate,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(contentPadding),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildImplementTypeBox(),
                          const SizedBox(height: 8),
                          _buildSummaryBox(),
                          const SizedBox(height: 8),

                          // --- box 1: escala superior (Potência CV) ---
                          _buildPotenciaBox(widthFor4_0),
                          const SizedBox(height: 8),

                          // --- box 2: escala central (Barra de Tração) ---
                          _buildPowerBox(widthFor7_0),
                          const SizedBox(height: 8),

                          // --- box 3: escala inferior (Força de Tração) ---
                          _buildTractionForceBox(fullRulerWidth),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDGETS DE COMPONENTES DE UI
  // ==========================================================================

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: kValmetRed,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              // ao voltar, libera a orientação
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            label: const Text('Página inicial', style: TextStyle(color: Colors.white, fontSize: 14)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
          const Text(
            'Lado 2',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
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

  /// container padrão com estilo (sombra e borda) usado para agrupar seções
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
          _buildTypeButton('Subsolador'),
          const SizedBox(width: 4),
          _buildTypeButton('Grade de Disco'),
          const SizedBox(width: 4),
          _buildTypeButton('Arado'),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String text) {
    final bool isSelected = _selectedImplement == text;

    return GestureDetector(
      onTap: () => _onImplementSelected(text),
      child: Container(
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
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBox() {
    // busca os dados do mapa com base no implemento selecionado
    final data = kImplementData[_selectedImplement]!;

    return _buildBox(
      title: 'Resumo do tipo de implemento selecionado:',
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildInfoDisplay(
              label: 'Textura do solo:',
              text: data['textura']!,
              isBlackBox: true,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInfoDisplay(
              label: 'Esforço requerido em:',
              text: data['esforco']!,
              isBlackBox: true,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  /// constrói o box de Potência (cv) contendo a escala superior e os marcadores de solo
  Widget _buildPotenciaBox(double targetWidth) {
    // configuração da escala superior: 10 a 350
    final List<double> labels = [10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 150, 200, 250, 300, 350];
    final List<TickRange> ranges = [
      TickRange(10, 30, 1),
      TickRange(30, 100, 5),
      TickRange(100, 350, 10),
    ];

    // calcula altura total para acomodar labels, barra e marcadores sem corte
    const double totalStackHeight = kMaxPowerLabelSpace + kBarHeight + kLineHeight + 25;

    return _buildBox(
      title: "Tipos de Solo:",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Potência (cv)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // coluna da esquerda (régua e marcadores)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: totalStackHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // label 'Potência Máxima' no topo
                          _buildPowerRangeLabel(targetWidth),

                          // janela da régua (recorte central)
                          Positioned(
                            left: 0,
                            top: kBarTopY,
                            child: _buildRulerWindow(
                              targetWidth,
                              minVal: 10,
                              maxVal: 350,
                              majorLabels: labels,
                              ranges: ranges,
                            ),
                          ),

                          // linhas e labels verticais (TDP, Motor, Solos)
                          ..._buildPowerBarMarkers(targetWidth),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // texto DITA lateral
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

  /// constrói o box de "Potência na Barra" contendo a escala central.
  Widget _buildPowerBox(double targetWidth) {

    // busca a velocidade do mapa de dados
    final data = kImplementData[_selectedImplement]!;

    // configuração da escala central: 10 a 150
    final List<double> labels = [10, 15, 20, 25, 30, 40, 50, 60, 70, 80, 90, 100, 150];
    final List<TickRange> ranges = [
      TickRange(10, 30, 1),
      TickRange(30, 100, 5),
      TickRange(100, 150, 5),
    ];

    return _buildBox(
      title: 'Potência na Barra de Tração (cv)',
      content: Row(
        children: [
          // stack para sobreposição da linha de orientação
          Stack(
            alignment: Alignment.center, // centraliza a linha vermelha
            clipBehavior: Clip.none,
            children: [
              // 1. a régua em si
              _buildRulerWindow(
                targetWidth,
                minVal: 10,
                maxVal: 150,
                majorLabels: labels,
                ranges: ranges,
              ),

              // 2. a linha vermelha
              Container(
                width: 2.0,
                height: 70.0,
                color: kValmetRed,
              )
            ],
          ),
          // janela da Régua


          const SizedBox(width: kPowerBoxGap),

          // display de "Velocidade Típica"
          Container(
            width: kFixedVelocityWidth,
            child: _buildInfoDisplay(
              label: 'Velocidade típica (km/h)',
              text: data['velocidade']!,
              isBlackBox: true,
              height: 50,
              flex: 0,
            ),
          ),
        ],
      ),
    );
  }

  /// constrói o box de "Força de Tração" contendo a escala inferior.
  Widget _buildTractionForceBox(double fullWidth) {
    // configuração da escala inferior: 300 a 10.000
    final List<double> labels = [300, 400, 500, 600, 700, 800, 900, 1000, 1500, 2000, 2500, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000];
    final List<TickRange> ranges = [
      TickRange(300, 400, 10),
      TickRange(400, 600, 10),
      TickRange(600, 1000, 10),
      TickRange(1000, 2000, 100),
      TickRange(2000, 5000, 100),
      TickRange(5000, 10000, 100),
    ];

    return _buildBox(
      title: 'Força de Tração Total (kgf)',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // janela da régua
          _buildRulerWindow(
            fullWidth,
            minVal: 300,
            maxVal: 10000,
            majorLabels: labels,
            ranges: ranges,
          ),
          const SizedBox(height: 5),
          const Text('Velocidade (km/h)', style: TextStyle(fontSize: 12, color: kValmetTextDark)),

          // labels estáticos de velocidade (fixos na máscara)
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

  // --- MÉTODOS DE BUILD AUXILIARES (labels especiais) ---

  /// posiciona o label "Potência Máxima" centralizado na faixa entre TDP e Motor
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
        // centraliza o texto
        offset: const Offset(-50, 0),
        child: const Text(
          'Potência Máxima',
          style: TextStyle(color: kValmetRed, fontSize: 10, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  /// gera a lista de widgets para os marcadores (linha + texto) de solo e potência.
  List<Widget> _buildPowerBarMarkers(double containerWidth) {
    const double barY = kBarTopY;
    const double barHeight = kBarHeight;
    const double lineHeight = kLineHeight;
    const double topLabelY = 0;
    const double bottomLineStart = barY + barHeight;
    const double bottomLabelY = bottomLineStart + lineHeight + 2;

    List<Widget> markers = [];

    kPowerPositions.forEach((label, config) {
      final double xPosition = containerWidth * config.ratio;
      final bool isCultivado = label == 'Cultivado';

      double lineStart;
      double labelY;
      double lineLength;
      double labelOffsetX = -20; // default para centralizar labels curtas

      if (isCultivado) {
        // 'Cultivado' fica ACIMA da barra
        lineLength = lineHeight * 0.7;
        lineStart = barY - lineLength;
        labelY = topLabelY;
        labelOffsetX = -25;
      } else {
        // outros labels ficam ABAIXO da barra
        lineStart = bottomLineStart;
        labelY = bottomLabelY;
        lineLength = lineHeight;

        // ajustes finos de offset baseados no tamanho do texto
        if (label == 'Fofo/Solto') labelOffsetX = -30;
        else if (label == 'TDP') labelOffsetX = -10;
        else if (label == 'Motor') labelOffsetX = -15;
        else if (label == 'Firme') labelOffsetX = -15;
      }

      // 1. linha vertical
      markers.add(
        Positioned(
          left: xPosition,
          top: lineStart,
          child: _buildVerticalLine(height: lineLength, color: config.color),
        ),
      );

      // 2. texto do marcador
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

  /// cria caixas de exibição de informação
  Widget _buildInfoDisplay({required String label, required String text, double height = 50, double width = double.infinity, int flex = 1, bool isBlackBox = false}) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(color: isBlackBox ? Colors.white70 : kValmetTextDark, fontSize: 10)),
        ),
        Text(text, style: TextStyle(color: isBlackBox ? Colors.white : kValmetTextDark, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );

    final box = Container(
      constraints: BoxConstraints(minHeight: height),
      width: width,
      decoration: BoxDecoration(
        color: isBlackBox ? Colors.black : kValmetButtonGrey,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kValmetDarkGrey, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: content,
    );

    // se flex > 0, expande o widget; caso contrário, usa tamanho fixo
    return flex > 0 ? Expanded(flex: flex, child: box) : box;
  }
}

// ============================================================================
// PAINTER AUXILIAR
// ============================================================================

/// customPainter simples para desenhar linhas verticais
class _LinePainter extends CustomPainter {
  final Color color;
  _LinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2.0..strokeCap = StrokeCap.butt;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}