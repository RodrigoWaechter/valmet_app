import 'package:flutter/material.dart';
import 'theme_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  final TextStyle _titleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black45,
        offset: Offset(4.0, 4.0),
      ),
    ],
  );

  final TextStyle _bodyStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kValmetDarkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      Text('Sobre o projeto:', style: _titleStyle),
                      const SizedBox(height: 20),

                      RichText(
                        text: TextSpan(
                          style: _bodyStyle,
                          children: const [
                            TextSpan(
                              text: 'Projeto desenvolvido por ',
                            ),
                            TextSpan(
                              text: 'Lucas Souza da Silva',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' e ',
                            ),
                            TextSpan(
                              text: 'Rodrigo Hammes Waechter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ', como trabalho para a disciplina de ',
                            ),
                            TextSpan(
                              text: 'Programação para Dispositivos Móveis',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ', lecionada pelo docente ',
                            ),
                            TextSpan(
                              text: 'Gilson Helfer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      RichText(
                        text: TextSpan(
                          style: _bodyStyle,
                          children: const [
                            TextSpan(
                              text: 'O objetivo era criar um aplicativo para a utilização de uma ',
                            ),
                            TextSpan(
                              text: 'régua Dimensionadora de Implementos e Tratores Agrícolas',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ', neste caso, da marca ',
                            ),
                            TextSpan(
                              text: 'Valmet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '.',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      const Divider(
                        color: kValmetSubtleDivider,
                        thickness: 2.0,
                      ),
                      const SizedBox(height: 30),

                      Text('Links úteis:', style: _titleStyle),
                      const SizedBox(height: 20),

                      const Text(
                        'Repositório do projeto:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        'https://github.com/RodrigoWaechter/valmet_app',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        '\nEmail para contato:\nwaechter@mx2.unisc.br\nlucassouza2@mx2.unisc.br',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

           Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: kValmetTextDark),
                label: const Text(
                  'Voltar para a página inicial',
                  style: TextStyle(
                    color: kValmetTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}