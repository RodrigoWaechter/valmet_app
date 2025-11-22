import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme_colors.dart';

class Lado1Screen extends StatefulWidget {
  const Lado1Screen({super.key});

  @override
  State<Lado1Screen> createState() => _Lado1ScreenState();
}

class _Lado1ScreenState extends State<Lado1Screen> {
  final double _fixedScale = 0.31485;
  final double _fixedY = 29.20;

  double _currentX = 55.90;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _currentX += details.delta.dx;
                });
              },
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(_currentX, _fixedY)
                          ..scale(_fixedScale),
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

          Positioned.fill(
            child: IgnorePointer(

              child: Center(
                child: Image.asset(
                  'assets/externo_001.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: kValmetRed.withOpacity(0.9),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}