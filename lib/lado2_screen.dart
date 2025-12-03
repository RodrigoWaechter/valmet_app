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
  final double _baseWidthRef = 1000.0;

  final double _calibRatio = 2.80;

  final double _calibScaleX = 0.41;
  final double _calibScaleY = 0.29;
  final double _calibPosX = -20.0;
  final double _calibPosY = 34.39329777801356;

  double _dragX = 0.0;

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
              child: Container(
                color: kValmetBeige,
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
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        boundaryMargin: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: renderedWidth,
                          height: renderedHeight,
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: [
                              Positioned.fill(
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _dragX += details.delta.dx / dynamicFactor;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..translate(
                                                (_calibPosX + _dragX) * dynamicFactor,
                                                _calibPosY * dynamicFactor,
                                              )
                                              ..scale(
                                                _calibScaleX * dynamicFactor,
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
                              ),

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
                      ),
                    );
                  },
                ),
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