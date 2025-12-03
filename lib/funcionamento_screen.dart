import 'package:flutter/material.dart';
import 'theme_colors.dart';

class FuncionamentoScreen extends StatelessWidget {
  const FuncionamentoScreen({super.key});

  PreferredSizeWidget _buildIntroAppBar(
    BuildContext context,
    double topPadding,
  ) {
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
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
              'Funcionamento',
              style: TextStyle(
                color: kValmetTextDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: kValmetDarkGrey, thickness: 1),
            const SizedBox(height: 20),

            _buildSectionTitle('Lado 1: Seleção de Implementos e Velocidades'),
            _buildFunctionItem(
              'Capacidade de Campo Efetiva (CE)',
              'É a relação entre a área trabalhada (ou a trabalhar) e o total de horas disponíveis no período.',
            ),
            _buildFunctionItem(
              'Velocidade de Operação (V)',
              'Velocidade do conjunto tratorizado (km/h).',
            ),
            _buildFunctionItem(
              'Capacidade de Campo Teórica (CT)',
              'É o resultado da multiplicação da largura de corte do implemento (Lc) pela velocidade de operação (V), considerando uma eficiência de 100%.',
            ),
            _buildFunctionItem(
              'Eficiência (E)',
              'É a relação entre a Capacidade de Campo Efetiva (CE) e a Teórica (CT). Representa a porcentagem do tempo que foi realmente transformada em trabalho.',
            ),
            _buildFunctionItem(
              'Largura de Corte (Lc) vs. Velocidade (V)',
              'Permite determinar a Largura de Corte (Lc) necessária com base na Velocidade (V) e CT. Inversamente, determina a Velocidade (V) necessária com base na Lc e CT.',
            ),
            _buildFunctionItem(
              'Área (ha) vs. Tempo (h)',
              'Permite calcular a Área a ser trabalhada (partindo da CT, Eficiência e Tempo disponível) ou o Tempo necessário (partindo da Área, CT e Eficiência).',
            ),
            _buildFunctionItem(
              'Conversão (cv/kW)',
              'Facilita a conversão direta da potência em cv para kW ou vice-versa.',
            ),

            const SizedBox(height: 30),

            _buildSectionTitle('Lado 2: Dimensionamento de Implementos'),
            _buildFunctionItem(
              'Potência Exigida na Barra de Tração (PBTex)',
              'Calcula a potência exigida pelo implemento, com base na Força de Tração Exigida (FTex) por ele e na Velocidade de operação (V).',
            ),
            _buildFunctionItem(
              'Potência Disponível na Barra de Tração (PBT)',
              'Calcula a potência que o trator pode fornecer, com base na Potência Máxima (Pmax) do motor e no Tipo de Solo (Firme, Cultivado, Fofo/Solto).',
            ),
            _buildFunctionItem(
              'Força de Tração Exigida (FTex)',
              'Facilita o cálculo estimado da força que o implemento exigirá do trator, com base no Tipo de Implemento (Arado, Grade, Subsolador) e na Textura do Solo.',
            ),
            _buildFunctionItem(
              'Pré-seleção de Implementos',
              'Facilita a especificação e escolha de implementos que sejam compatíveis com a potência disponível do trator.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: kValmetRed,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFunctionItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 10.0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: kValmetTextDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: kValmetTextDark.withOpacity(0.9),
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
