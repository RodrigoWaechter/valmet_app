import 'package:flutter/material.dart';
import 'theme_colors.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  PreferredSizeWidget _buildIntroAppBar(
      BuildContext context, double topPadding) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0 + topPadding),
      child: Container(
        color: kValmetRed,
        padding: EdgeInsets.only(top: topPadding),
        height: 60.0 + topPadding,
        child: Container(
          height: 60.0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _buildIntroAppBar(context, topPadding),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introdução',
              style: TextStyle(
                color: kValmetTextDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: kValmetDarkGrey, thickness: 1),
            const SizedBox(height: 20),
            Text(
              'Esta régua é construída com escalas logarítmicas estrategicamente posicionadas, de forma que à coincidência de um valor numa determinada escala, fornece um resultado em outra.\n\nSeu funcionamento é similar ao de uma calculadora programável ou dedicada. Assim, os botões, geralmente codificados das calculadoras, foram substituídos por escalas com nomes; o apertar de botões, que realizam as operações, foram substituídos por movimentos de vai-e-vem entre as escalas e a leitura dos valores no visor da calculadora, é feita diretamente em determinados pontos das respectivas escalas.\n\nPara seu manejo, estas instruções, ao mesmo tempo em que procuram ensinar a utilização da régua, conceituam alguns parâmetros que o auxiliarão no entendimento de cada resultado encontrado e ou que se deseja encontrar.\n\nEla se presta ao planejamento das operações agrícolas, bem como para sua avaliação, a partir de alguns dados relativivos a uma operação que se está realizando e que podem ser obtidos no campo.\n\nParalelamente, facilita a escolha de implementos adequados aos tratores, levando-se em conta as variáveis de potência, solo, velocidade etc.',
              style: TextStyle(
                color: kValmetTextDark,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}