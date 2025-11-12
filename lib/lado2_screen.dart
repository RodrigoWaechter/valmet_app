import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'lado1_screen.dart';
import 'theme_colors.dart';

class Lado2Screen extends StatelessWidget {
  const Lado2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    // força a orientação para o modo paisagem (Landscape)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // troca para o modo paisagem
    return Scaffold(
      backgroundColor: kValmetBeige,
      body: SafeArea(
        child: Column(
          children: [
            // botões e título
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildImplementTypeBox(),
                    const SizedBox(height: 8),
                    _buildSummaryBox(),
                    const SizedBox(height: 8),
                    _buildSoilTypeBox(),
                    const SizedBox(height: 8),
                    _buildPowerBox(),
                    const SizedBox(height: 8),
                    _buildTractionForceBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------- Widgets de Componentes ------

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: kValmetRed,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // botão da página inicial (voltar)
          TextButton.icon(
            onPressed: () {
              //volta pra tela inicial e remove a restrição de orientação
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            label: const Text('Página inicial', style: TextStyle(color: Colors.white, fontSize: 14)),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          // título da página
          const Text(
            'Lado 2',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          // botão de trocar de lado (lado 1)
          ElevatedButton(
            onPressed: () {
              // vai para a tela Lado 1 (que deve estar em modo paisagem)
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
          _buildTypeButton('Subsolador', false),
          const SizedBox(width: 4),
          _buildTypeButton('Grade de Disco', false),
          const SizedBox(width: 4),
          _buildTypeButton('Arado', true), // selecionado por padrão para teste
        ],
      ),
    );
  }

  Widget _buildTypeButton(String text, bool isSelected) {
    return Container(
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
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSummaryBox() {
    return _buildBox(
      title: 'Resumo do tipo de implemento selecionado',
      content: Row(
        children: [
          // textura do solo
          Expanded(
            child: _buildInfoDisplay(
              label: 'Textura do solo:',
              text: 'informações tiradas da régua sobreposta',
              isBlackBox: true, // simula o recorte
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          // esforço requerido
          Expanded(
            child: _buildInfoDisplay(
              label: 'Esforço requerido em:',
              text: 'kgf/m de ...',
              isBlackBox: true, // simula o recorte
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoilTypeBox() {
    return _buildBox(
      title: 'Tipos de Solo:',
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // texto fixo
          const Text(
            'Potência (cv)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),

          // área de seleção/visualização principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // rótulos originais
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fofo/Solto', style: TextStyle(fontSize: 12)),
                    Text('Cultivado', style: TextStyle(fontSize: 12)),
                    Text('Firme', style: TextStyle(fontSize: 12)),
                    Text('Potência Máxima', style: TextStyle(fontSize: 12, color: kValmetRed)),
                    Text('TDP', style: TextStyle(fontSize: 12, color: kValmetRed)),
                    Text('Motor', style: TextStyle(fontSize: 12, color: kValmetRed)),
                  ],
                ),
                const SizedBox(height: 5),
                // área de recorte da régua
                Container(
                  height: 50,
                  color: Colors.black, // simula o recorte
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // texto 'DITA' como no design
          const Text(
            'DITA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: kValmetRed,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerBox() {
    return _buildBox(
      title: 'Potência na Barra de Tração (cv)',
      content: Row(
        children: [
          // área de recorte da régua
          Expanded(
            child: Container(
              height: 50,
              color: Colors.black, // simula o recorte
            ),
          ),
          const SizedBox(width: 10),
          // velocidade típica (área de texto)
          _buildInfoDisplay(
            label: 'Vel. típica (km/h)',
            text: '0,0',
            isBlackBox: true, // simula o recorte
            height: 50,
            flex: 0,
            width: 150,
          ),
        ],
      ),
    );
  }

  Widget _buildTractionForceBox() {
    return _buildBox(
      title: 'Força de Tração Total (kgf)',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // área de recorte da régua
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.black, // simula o recorte
          ),
          const SizedBox(height: 5),
          // velocidade (km/h)
          const Text(
            'Velocidade (km/h)',
            style: TextStyle(fontSize: 12, color: kValmetTextDark),
          ),
          // eixos de régua
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

  Widget _buildInfoDisplay({
    required String label,
    required String text,
    double height = 50,
    double width = double.infinity,
    int flex = 1,
    bool isBlackBox = false,
  }) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBlackBox ? Colors.white70 : kValmetTextDark,
            fontSize: 10,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: isBlackBox ? Colors.white : kValmetTextDark,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );

    final box = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: isBlackBox ? Colors.black : kValmetButtonGrey,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: kValmetDarkGrey, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: content,
    );

    return flex > 0 ? Expanded(flex: flex, child: box) : box;
  }
}