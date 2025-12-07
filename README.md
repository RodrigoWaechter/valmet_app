# Régua Digital Valmet (DITA)

**Dimensionadora de Implementos e Tratores Agrícolas**

Este aplicativo é uma reprodução digital da régua de cálculo DITA, desenvolvida originalmente pela Valmet. A ferramenta funciona de forma similar a uma calculadora dedicada, mas utiliza escalas logarítmicas deslizantes para realizar cálculos complexos de planejamento agrícola e dimensionamento de máquinas.

O objetivo é auxiliar no planejamento das operações de campo e facilitar a escolha correta de implementos adequados aos tratores, ou vice-versa, considerando variáveis fundamentais como tipo de solo e velocidade de operação.

<img width="1283" height="750" alt="2025-12-07 17-31-15" src="https://github.com/user-attachments/assets/0872b443-9851-482d-be1d-90d61c43ef0f" />

## Funcionalidades

O aplicativo reproduz as duas faces da régua original, cada uma com finalidades específicas de cálculo:

### Lado 1: Dimensionamento das Operações de Campo

Utilizado para planejar o rendimento do trabalho e avaliar operações em andamento.

<img width="1285" height="754" alt="2025-12-07 17-31-23" src="https://github.com/user-attachments/assets/c0955e5e-6c2c-4114-953d-f9da5e47b80b" />

* **Capacidade de Campo Efetiva (CE):** Calcula o rendimento em hectares por hora (ha/h) relacionando a **Área (ha)** total a ser trabalhada com as **Horas (h)** disponíveis para o serviço.
* **Eficiência (E):** Determina a porcentagem do tempo realmente transformada em trabalho produtivo, descontando perdas por manobras, abastecimento e manutenção.
* **Capacidade de Campo Teórica (CT):** Relaciona a **Largura de Corte (m)** do implemento com a **Velocidade (km/h)** de operação, assumindo 100% de eficiência.
* **Cálculo de Velocidade Real:** Permite descobrir a velocidade exata do trator cronometrando o **Tempo (s)** necessário para percorrer uma **Distância (m)** conhecida (ex: 300 metros).
* **Conversão de Potência:** Escala auxiliar para conversão direta e rápida entre **cv** e **kW**.

### Lado 2: Seleção de Implementos e Tratores

Utilizado para adequar o trator ao implemento, garantindo que a potência do motor seja suficiente para o esforço exigido pelo solo e pelo equipamento.

<img width="1279" height="753" alt="2025-12-07 17-31-34" src="https://github.com/user-attachments/assets/460952c0-c1ae-4bad-abaf-5e4769069bd1" />

* **Tipos de Implemento:** Seleção específica para **Arado**, **Grade de Disco** e **Subsolador**.
* **Influência do Solo:** O cálculo considera a textura do solo (Massapé, Argiloso, Misto, Arenoso) e sua condição (Firme, Cultivado, Fofo/Solto) para determinar o esforço necessário.
* **Força de Tração (kgf):** Calcula a força total exigida pelo implemento baseada na sua largura, peso ou número de hastes.
* **Potência (cv):** Indica a **Potência na Barra de Tração** necessária e a **Potência Máxima no Motor** recomendada para realizar a operação com segurança.

## Como Executar o Projeto (IDE)

Siga os passos abaixo para rodar o aplicativo em seu ambiente de desenvolvimento (VS Code, Android Studio ou IntelliJ):

### Pré-requisitos

* Tenha o **Flutter SDK** instalado e configurado corretamente no seu sistema.
* Um emulador (Android/iOS) configurado ou um dispositivo físico conectado via USB.

### Passo a Passo

1.  **Abra o projeto:** Abra a pasta raiz deste projeto na sua IDE de preferência.
2.  **Instale as dependências:** Abra o terminal integrado da IDE e execute o comando abaixo para baixar as bibliotecas necessárias:
    ```bash
    flutter pub get
    ```
3.  **Selecione o Dispositivo:** Certifique-se de que o seu emulador ou celular está reconhecido pela IDE (geralmente aparece no canto inferior direito no VS Code ou na barra superior no Android Studio).
4.  **Execute a aplicação:**
    * **No VS Code:** Pressione `F5` ou vá no menu `Run > Start Debugging`.
    * **No Terminal:** Digite o seguinte comando na raiz do projeto:
        ```bash
        flutter run
        ```
## Autores
- Lucas Souza da Silva
- Rodrigo Hammes Waechter
