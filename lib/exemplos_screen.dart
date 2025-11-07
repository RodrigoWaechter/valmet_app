import 'package:flutter/material.dart';
import 'theme_colors.dart';

class ExamplesScreen extends StatefulWidget {
  const ExamplesScreen({super.key});

  @override
  State<ExamplesScreen> createState() => _ExamplesScreenState();
}

class _ExamplesScreenState extends State<ExamplesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildExamplesAppBar(
    BuildContext context,
    double topPadding,
    TabController tabController,
  ) {
    const double titleHeight = 60.0;
    const double tabBarHeight = 48.0;
    final double totalHeight = titleHeight + tabBarHeight + topPadding;

    return PreferredSize(
      preferredSize: Size.fromHeight(totalHeight),
      child: Container(
        color: kValmetRed,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: topPadding),
              height: titleHeight + topPadding,
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
            Container(
              height: tabBarHeight,
              color: kValmetRed,
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: const [
                  Tab(text: 'LADO 1'),
                  Tab(text: 'LADO 2'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLado1Examples() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExampleBlock('Lado 1 - Exemplo 1', _lado1Exemplo1Content),
          _buildExampleBlock('Lado 1 - Exemplo 2', _lado1Exemplo2Content),
        ],
      ),
    );
  }

  Widget _buildLado2Examples() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExampleBlock(
            'Lado 2 - I. Estimativa da Força de Tração (FTex)',
            _lado2Exemplo1_3Content,
          ),
          _buildExampleBlock(
            'Lado 2 - II. Cálculo de Potência na Barra de Tração (PBT)',
            _lado2Exemplo4Content,
          ),
          _buildExampleBlock(
            'Lado 2 - III. Cálculo de Potência Exigida (PBTex) e Exemplo 6',
            _lado2Exemplo5_6Content,
          ),
          _buildExampleBlock(
            'Utilizando os Dois Lados da Régua',
            _lado2AmbosLadosContent,
          ),
        ],
      ),
    );
  }

  Widget _buildExampleBlock(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: kValmetTextDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: kValmetDarkGrey, thickness: 1),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(color: kValmetTextDark, fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _buildExamplesAppBar(context, topPadding, _tabController),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLado1Examples(), _buildLado2Examples()],
      ),
    );
  }
}

const String _lado1Exemplo1Content = '''
Que largura de corte deve ter um implemento com o qual o trator opera a 6,5 km/h, para que possamos trabalhar 500 ha em 25 dias úteis de 8 horas, estimando-se uma eficiência de 80%?

1º Passo: Transformar o tempo em horas
25 dias x 8 horas/dia = 200 h

2º Passo: Calcular a Capacidade de Campo Efetiva (CE)
No conjunto de escalas "Dimensionamento das Operações de Campo (A)", faça coincidir a Área (500 ha) com o tempo disponível (200 h) e leia na escala de Capacidade de Campo, na linha de 100%, CE = 2,5 ha/h.

3º Passo: Calcular a Capacidade de Campo Teórica (CT)
Desloque a marca de 2,5 ha/h para a Eficiência estimada (80%) e leia na linha de 100% o valor de CT. O resultado 3,1 ha/h é a capacidade máxima do trator com o implemento.

4º Passo: Calcular a Largura de Corte do Implemento (Lc)
Com a marca de 2,5 ha/h alinhada com 80%, leia na escala da Largura de Corte do Implemento, o valor que corresponde à V = 6,5 km/h (conforme exemplo), ou seja, Lc = 4,8 metros.
''';

const String _lado1Exemplo2Content = '''
Observando um trator em operação, anotei o tempo de 100 segundos (1 minuto e 40 segundos), que levou para percorrer uma distância de 300 metros. Medi uma passada do implemento e verifiquei que a largura de corte era de 2,4 metros. Conversando com o proprietário, este me disse que em 10 dias de 8 horas de trabalho diário, conseguiu preparar 160 ha. Qual foi a eficiência deste conjunto?

1.º Passo: Calcular a Velocidade do Trator
No conjunto de escalas "Determinação da Velocidade (B)", posicione a Distância (d) 300 m com o Tempo (t) 100 s e leia no indicador "D" a Velocidade 10,8 km/h (aprox.).

2º Passo: Calcular a Capacidade de Campo Teórica (CT)
Nas escalas de Velocidade e Largura de Corte faça coincidir 10,8 km/h com 2,4 m (do exemplo) e leia a CT de 2,6 ha/h, no ponto de coincidência com 100%.

3.º Passo: Calcular a Capacidade de Campo Efetiva (CE)
10 dias x 8 horas/dia = 80 h
Faça coincidir a Área (160 ha) com o Tempo (80 h) e leia no ponto de 100% de Eficiência, o valor da CE = 2,0 ha/h.

4.º Passo: Calcular a Eficiência (E)
Desloque a escala de Capacidade de Campo para a esquerda até que o valor da CT de 2,6 ha/h, coincida com o valor de 100% de Eficiência. Em seguida, leia o valor da Eficiência, que coincidiu com a CE = 2,0 ha/h, que é o valor de 77% (aprox.)
''';

const String _lado2Exemplo1_3Content = '''
1. Exemplo (Arado):
Qual é a Força de Tração Exigida por uma arado de 4 discos de 28", com Lc = 1,10m, trabalhando em solo argiloso a 22 cm de profundidade?
Posicione a seta em Arado. Na janela Textura do Solo, lê-se 1.600 kgf de Esforço Requerido / metro.
Logo, FTex = 1.600 kgf/m x 1,10 m = 1.760 kgf

2.º Exemplo (Grade Niveladora):
Qual é a FTex por uma grade niveladora de 36 discos de 20", que pesa 850 kg, trabalhando em solo misto?
Posicione a seta em Grade de Disco. Na janela, lê-se 1,0 kgf de Esforço Requerido / kg de peso.
Logo, FTex = 850 kg x 1,0 kgf/kg = 850 kgf.

3. Exemplo (Subsolador):
Qual é a FTex por um subsolador de 5 hastes, trabalhando em solo argiloso a 40 cm de profundidade?
Posicione a seta em Subsolador. Na janela, lê-se 23 kgf de Esforço Requerido / cm / haste.
Logo, FTex = 23 kgf x 5 hastes x 40 cm = 4.600 kgf
''';

const String _lado2Exemplo4Content = '''
4º Exemplo:
Um trator que tem 100 cv de Potência Máxima (Pmax) no Motor, quanto terá de PBT nos diversos Tipos de Solo?

Na escala de Potência em relação a Tipos de Solo, faça coincidir 100 cv com a linha de Motor.
Pode-se obter a Potência Máxima na TDP de 86 cv e as Potências Úteis:
- Solo Firme: 55 cv
- Solo Cultivado: 47,5 cv
- Solo Fofo/Solto: 41 cv.
''';

const String _lado2Exemplo5_6Content = '''
5. Exemplo:
Qual será a PBTex de um trator, tracionando um implemento com 2.500 kgf de FTex a uma velocidade de 6 km/h?
Passo Único: Na escala de Força de Tração Total (kgf), faça coincidir 2.500 kgf com 6 km/h. Leia na seta "E" o valor da PBTex = 55,5 cv.

6. Exemplo:
Qual a PBTex por uma grade aradora de 12 discos de 30" (peso 1.900 kg), em solo misto e qual a Pmax no motor?
1º Passo: Estimar a FTex e Velocidade.
Posicione Grade de Disco, leia índice para solo misto: 1,2 kgf/kg.
FTex = 1,2 kgf/kg x 1.900 kg = 2.280 kgf
Velocidade Típica: 5,0 a 7,0 km/h. Estimamos V = 6,0 km/h.

2º Passo: Calcular a PBTex
Posicione 2.280 kgf com 6,0 km/h. Leia na seta "E", PBTex = 50,5 cv.

3.º Passo: Calcular a Pmax no Motor
Posicione 50,5 cv na linha de Solo Firme. Na linha "Motor" encontramos Pmax = 92 cv (para 4x2).
Caso 4x4: Pmax(4x4) = 92cv / 1,15 = 80 cv.
''';

const String _lado2AmbosLadosContent = '''
Exemplo:
Um agricultor adquiriu um trator Valmet 980 4x4 Turbo (95 cv) e solicitou um subsolador para trabalhar 150 ha, a 40 cm de profundidade, em 200 horas. O solo é misto. Eficiência estimada: 60%.

1º Passo: Estimar FTex e Velocidade (Lado 2)
Posicione Subsolador. Solo misto: 15 kgf/cm/haste.
FTex = 15 kgf/cm/haste x 40 cm = 600 kgf/haste
Velocidade Típica: 4,0 a 6,0 km/h. Estimamos V = 5,1 km/h (baseado na marcha L3).

2º Passo: Calcular PBT do Trator (Lado 2)
Faça coincidir 95 cv (potência do 980) com a linha Motor.
Leia na linha Solo Firme: PBT = 52 cv.
Como é 4x4: PBT = 52 cv x 1,15 = 60 cv.

3.º Passo: Calcular FT do trator (Lado 2)
Faça coincidir PBT (60cv) com a seta "E". Leia na escala Força de Tração, na Velocidade de 5,1 km/h: FT = 3.200 kgf (aprox.).

4.º Passo: Achar n.º de hastes (Lado 2)
Nº de hastes = 3.200 kgf / 600 kgf/haste = 5,33 hastes => 5 hastes.

5. Passo: Calcular Capacidade de Campo Efetiva (CE) (Lado 1)
Na escala da Área/Horas, coincida 150 ha com 200 h.
Leia na linha 100% de E: CE = 0,75 ha/h.

6. Passo: Calcular CT e Largura de Corte (Lc) (Lado 1)
Desloque até CE (0,75 ha/h) coincidir com 60% (Eficiência).
Leia no indicador 100%: CT = 1,28 ha/h.
Na escala de Largura de Corte, leia o valor que coincide com V = 5,1 km/h: Lc = 2,5m.

Recomendação:
• Subsolador de 5 hastes
• Espaçamento 0,5 m (Lc = 2,5m)
• Profundidade = 40 cm
• Marcha L3 / 2000 rpm
''';
