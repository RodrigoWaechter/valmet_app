import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';
import 'lado1_screen.dart';

class Lado2Screen extends StatefulWidget {
  const Lado2Screen({super.key});

  @override
  State<Lado2Screen> createState() => _Lado2ScreenState();
}

class _Lado2ScreenState extends State<Lado2Screen> {
  /// Largura de referência da arte interna (em pixels)
  final double _baseWidthRef = 1000.0;

  /// ratio = largura/altura da arte EXTERNA (fundo fixo)
  final double _calibRatio = 2.80;

  /// EDITÁVEIS
  double scaleX = 0.41;
  double posX = -20.0;
  double posY = 34.39329777801356;

  /// Fixos
  final double _calibScaleY = 0.29;

  /// Pan (arrasto)
  double _dragX = 0.0;

  /// Zoom internal states
  double _initialScaleX = 0.0;
  double _initialDragX = 0.0;
  late Offset _startFocal;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kValmetBeige,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenW = constraints.maxWidth;
                  final double screenH = constraints.maxHeight;
                  final double screenRatio = screenW / screenH;

                  double renderedWidth;
                  double renderedHeight;

                  if (screenRatio > _calibRatio) {
                    renderedHeight = screenH;
                    renderedWidth = screenH * _calibRatio;
                  } else {
                    renderedWidth = screenW;
                    renderedHeight = screenW / _calibRatio;
                  }

                  final double dynamicFactor = renderedWidth / _baseWidthRef;

                  return Center(
                    child: SizedBox(
                      width: renderedWidth,
                      height: renderedHeight,
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          /// AREA INTERNA COM ZOOM + DRAG
                          Positioned.fill(
                            child: GestureDetector(
                              onScaleStart: (details) {
                                _initialScaleX = scaleX;
                                _initialDragX = _dragX;
                                _startFocal = details.focalPoint;
                              },

                              onScaleUpdate: (details) {
                                setState(() {
                                  // Zoom (somente no eixo X)
                                  scaleX = (_initialScaleX * details.scale)
                                      .clamp(0.1, 3.0);

                                  // Pan: deslocamento horizontal
                                  final dx =
                                      details.focalPoint.dx - _startFocal.dx;

                                  _dragX = _initialDragX + dx / dynamicFactor;
                                });
                              },

                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Transform(
                                      transform: Matrix4.identity()
                                        ..translate(
                                          (posX + _dragX) * dynamicFactor,
                                          posY * dynamicFactor,
                                        )
                                        ..scale(
                                          scaleX * dynamicFactor,
                                          _calibScaleY * dynamicFactor,
                                        ),
                                      alignment: Alignment.topLeft,
                                      child: Image.asset(
                                        'assets/interno_001.jpg',
                                        fit: BoxFit.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// CAMADA SUPERIOR — FUNDO EXTERNO FIXO
                          IgnorePointer(
                            child: SizedBox.expand(
                              child: Image.asset(
                                'assets/externo_002.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
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

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: kValmetRed,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Lado1Screen()),
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text("Voltar", style: TextStyle(color: Colors.white)),
          ),

          const Text(
            'Lado 2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 80),
        ],
      ),
    );
  }
}
