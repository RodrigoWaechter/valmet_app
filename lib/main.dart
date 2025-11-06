import 'package:flutter/material.dart';

const Color kValmetRed = Color(0xFFA62A2A);
const Color kValmetDarkGrey = Color(0xFF5A5A5A);
const Color kValmetBeige = Color(0xFFF5F0E8);
const Color kValmetButtonGrey = Color(0xFFE0E0E0);
const Color kValmetTextDark = Color(0xFF333333);

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
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: kValmetRed,
        ),
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
              const SizedBox(height: 20),

              _buildMainButton(
                icon: Icons.menu_book,
                text: 'Introdução',
                onPressed: () {
                },
              ),
              const SizedBox(height: 16),
              _buildMainButton(
                icon: Icons.settings,
                text: 'Funcionamento',
                onPressed: () {
                },
              ),
              const SizedBox(height: 16),
              _buildMainButton(
                icon: Icons.assignment,
                text: 'Exemplos',
                onPressed: () {
                },
              ),
              const SizedBox(height: 20),
              const Divider(color: kValmetDarkGrey, thickness: 1),
              const SizedBox(height: 30),

              _buildSecondaryButton(
                text: 'Usar régua',
                color: kValmetRed,
                onPressed: () {
                },
              ),
              const SizedBox(height: 12),
              _buildSecondaryButton(
                text: 'Sobre',
                color: kValmetDarkGrey,
                icon: Icons.info_outline,
                onPressed: () {
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
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                label: const Text(
                  'Sair',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1.5,
              height: 30,
              color: Colors.white54,
            ),

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
          Container(
            width: 1.5,
            height: 30,
            color: kValmetDarkGrey,
          ),
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
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}