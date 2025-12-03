import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'exemplos_screen.dart';
import 'introducao_screen.dart';
import 'theme_colors.dart';
import 'funcionamento_screen.dart';
import 'lado2_screen.dart';
import 'lado1_screen.dart';
import 'about_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valmet App',
      theme: ThemeData(
        primaryColor: kValmetRed,
        scaffoldBackgroundColor: kValmetBeige,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(elevation: 0, color: kValmetRed),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0 + topPadding),
        child: _buildCustomAppBar(context, topPadding),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Dimensionadora de Implementos\ne Tratores Agrícolas',
                style: TextStyle(
                  color: kValmetTextDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: kValmetDarkGrey, thickness: 1),
              const SizedBox(height: 100),

              // bloco de botões principais
              _buildMainButton(
                icon: Icons.menu_book,
                text: 'Introdução',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntroductionScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildMainButton(
                icon: Icons.settings,
                text: 'Funcionamento',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FuncionamentoScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildMainButton(
                icon: Icons.assignment,
                text: 'Exemplos',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExamplesScreen(),
                    ),
                  );
                },
              ),

              // empurra o conteúdo um pouco para baixo
              const SizedBox(height: 100),

              const Divider(color: kValmetDarkGrey, thickness: 1),
              const SizedBox(height: 30),
              _buildSecondaryButton(
                text: 'Usar régua',
                color: kValmetRed,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Lado1Screen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSecondaryButton(
                text: 'Sobre',
                color: kValmetDarkGrey,
                icon: Icons.info_outline,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, double topPadding) {
    return Container(
      color: kValmetRed,
      padding: EdgeInsets.only(top: topPadding),
      height: 60.0 + topPadding,
      child: Container(
        height: 60.0,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextButton.icon(
                onPressed: () {
                  SystemNavigator.pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1.5, height: 30, color: Colors.white54),
            const Spacer(),
            const Text(
              'Valmet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kValmetButtonGrey,
        foregroundColor: kValmetTextDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30, color: kValmetTextDark),
          const SizedBox(width: 16),
          Container(width: 1.5, height: 30, color: kValmetDarkGrey),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    IconData? icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
