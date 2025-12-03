import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';
import 'lado2_screen.dart';

class Lado1Screen extends StatefulWidget {
  const Lado1Screen({super.key});

  @override
  State<Lado1Screen> createState() => _Lado1ScreenState();
}

class _Lado1ScreenState extends State<Lado1Screen> {
  final double _baseWidthRef = 1000.0;

  final double _calibRatio = 2.1497;
  final double _calibScaleX = 0.4145;
  final double _calibScaleY = 0.3663;
  final double _calibPosX = -1.3309;
  final double _calibPosY = 33.7976;

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
                    double screenW = constraints.maxWidth;
                    double screenH = constraints.maxHeight;
                    double screenRatio = screenW / screenH;

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
                                                  _calibPosY * dynamicFactor
                                              )
                                              ..scale(
                                                  _calibScaleX * dynamicFactor,
                                                  _calibScaleY * dynamicFactor
                                              ),
                                            alignment: Alignment.topLeft,
                                            child: Image.asset(
                                              'assets/interno_002.jpg',
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
                                    'assets/externo_001.png',
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
              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            label: const Text('Página inicial', style: TextStyle(color: Colors.white, fontSize: 14)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          const Text(
            'Lado 1',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Lado2Screen()),
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
}