import 'package:flutter/material.dart';

import 'theme_colors.dart';

class Lado1Screen extends StatelessWidget {
  const Lado1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kValmetBeige,
      appBar: AppBar(
        title: const Text('Lado 1', style: TextStyle(color: Colors.white)),
        backgroundColor: kValmetRed,
      ),
      body: const Center(
        child: Text(
          'Tela Lado 1 - Implementar aqui',
          style: TextStyle(fontSize: 20, color: kValmetTextDark),
        ),
      ),
    );
  }
}