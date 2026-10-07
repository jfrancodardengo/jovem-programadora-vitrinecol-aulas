# Aula 5 – Protótipo navegável no Figma

**Dia 2 · Qua 07/10/2026** · **Aula 5** · **UC3**

- **Requisitos cobertos:** não se aplica (planejamento das telas)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** wireframes das quatro telas-chave e o caminho da cliente, revisados (Aula 4). Uma conta gratuita no Figma (https://www.figma.com)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai transformar os wireframes em um **protótipo navegável no Figma**: três telas (catálogo, produto e sacola) desenhadas em quadros, com componentes reaproveitados e ligadas por cliques, e vai testá-lo com uma colega.

**Abertura (10 minutos).** Retomada da Aula 4: vocês têm o desenho em papel das 4 telas e o caminho Catálogo → Produto → Sacola. Hoje esse caminho vira algo em que se pode **clicar**. Escolham uma integrante para dividir a tela no projetor ou no computador e as outras acompanham, trocando de "piloto" a cada passo.

> **Sobre o idioma:** o Figma funciona em inglês. Os nomes abaixo aparecem **exatamente como na tela**, seguidos da tradução em português para você entender o que cada item significa. Se um botão estiver em outro lugar na sua versão, use a busca de comandos do Figma (Ctrl+/ no Windows, Cmd+/ no Mac) e digite o nome do comando em inglês.

## O Conceito

**Termos desta aula**

- **Protótipo**: uma simulação do sistema em que dá para clicar e "andar" pelas telas, mas que ainda não tem código nem banco de dados.
- **Frame** (em português: **quadro**): o retângulo que representa uma tela inteira (por exemplo, um celular).
- **Componente**: um elemento desenhado uma vez e reaproveitado em vários lugares (o cabeçalho, o card de produto). Se você muda o componente original, todas as cópias mudam.
- **Interação**: a ligação "ao clicar aqui, vá para aquela tela".

**Analogia:** um protótipo é a maquete de um prédio: você consegue andar pelos cômodos, mas não dá para morar ali. Serve para descobrir problemas antes de construir.

**Por que fazer isso antes de programar?** Mudar um botão de lugar no Figma leva 10 segundos. Mudar a mesma coisa depois de programada leva muito mais tempo.

## Mão na Massa

### Passo 1: crie o arquivo e os quadros (10 minutos)

1. Entre no Figma e crie um arquivo novo: no painel inicial, clique em **New design file** (em português: **Novo arquivo de design**). Dê o nome `VitrineCol – protótipo`.
2. Escolha a ferramenta **Frame** (em português: **Quadro**; atalho: tecla F). No painel da direita, em **Frame**, escolha o tamanho de celular (**Phone**, em português: **Celular**).
3. Crie **três quadros** lado a lado e renomeie-os (dois cliques no nome, na lista de camadas à esquerda): `Catálogo`, `Produto` e `Sacola`.

### Passo 2: crie dois componentes (15 minutos)

1. No quadro **Catálogo**, desenhe o **cabeçalho**: um retângulo (ferramenta **Rectangle**, em português: **Retângulo**; atalho R) no topo com o texto (ferramenta **Text**, em português: **Texto**; atalho T) "VitrineCol" e os links "Início", "Catálogo" e "Sacola".
2. Selecione o cabeçalho e transforme em componente: botão direito > **Create component** (em português: **Criar componente**; atalho Ctrl+Alt+K no Windows, Cmd+Option+K no Mac).
3. Copie o componente (Ctrl+C, Ctrl+V; Cmd+C, Cmd+V no Mac) e cole nos quadros **Produto** e **Sacola**, no topo.
4. Desenhe o **card de produto**: retângulo para a foto (com um X), três linhas de texto (nome, preço e loja). Transforme em componente do mesmo jeito e coloque **quatro cópias** no quadro Catálogo, em duas colunas.

### Passo 3: complete as telas Produto e Sacola (10 minutos)

- **Produto**: foto grande, preço, botões de tamanho (P, M, G), campo de quantidade e o botão **Adicionar à sacola**.
- **Sacola**: o título "Sacola", dois blocos "Loja A" e "Loja B" (cada um com um item e o subtotal), o texto "Total" e o botão **Finalizar sacola**.

### Passo 4: ligue as telas (10 minutos)

1. No painel da direita, clique na aba **Prototype** (em português: **Protótipo**).
2. Selecione o primeiro card do catálogo. Aparece um pequeno círculo na lateral: arraste-o até o quadro **Produto**. Na janelinha que aparece, confirme **On click** (em português: **Ao clicar**) e **Navigate to** (em português: **Navegar para**) o quadro Produto.
3. No quadro Produto, ligue o botão **Adicionar à sacola** ao quadro **Sacola**.
4. No quadro Sacola, ligue o botão **Finalizar sacola** de volta ao quadro **Catálogo** (representa o pedido enviado).
5. Teste: clique no botão **Present** (em português: **Apresentar**; é o triângulo de "play" no canto superior direito). Clique no card, no botão e em **Finalizar sacola**. Aperte Esc para sair.

### Passo 5: teste com uma colega (5 minutos)

Dê o link do protótipo (botão **Share**, em português: **Compartilhar**, com a opção de ver o protótipo) e peça a uma colega, **sem ajudar**, que cumpra a tarefa: "escolha uma peça e finalize a sacola". Anote onde ela hesitou ou clicou no lugar errado e corrija o protótipo.

## Explicação do Código

Também não há código nesta aula. Veja por que cada passo existe:

- **Quadros do tamanho de um celular**: o sistema é mobile-first (Dia 5); desenhar já no tamanho certo evita surpresas.
- **Componentes**: o cabeçalho e o card aparecem em muitas telas. No código, isso vai virar uma coisa só: o cabeçalho será escrito em um único arquivo JavaScript (`cabecalho.js`) e o card em outro (`cards.js`). Pensar em componentes agora ensina a pensar assim no código.
- **Interações simples** (**On click**, em português: **Ao clicar**, e **Navigate to**, em português: **Navegar para**): o protótipo só representa o caminho; os dados são todos de mentira.
- **Teste com uma colega**: a primeira pessoa que usa o protótipo sempre encontra algo que a equipe não viu. É a forma mais barata de achar falhas.

## Validação

1. O arquivo tem 3 quadros nomeados (Catálogo, Produto, Sacola) e pelo menos 2 componentes (cabeçalho e card).
2. No modo **Present** (em português: **Apresentar**), os cliques levam Catálogo → Produto → Sacola → Catálogo.
3. A colega concluiu a tarefa sem ajuda, e vocês anotaram pelo menos um ajuste.
4. O link de visualização do protótipo está colado no `README.md` ou no quadro Kanban, para a equipe achar depois.

**Erros comuns**

1. *Sintoma:* ao apresentar, o clique não leva a lugar nenhum. *Causa:* a interação foi criada no elemento errado (por exemplo, na camada do texto e não no card inteiro). *Correção:* selecione o card inteiro (clique na camada na lista à esquerda) e refaça a ligação.
2. *Sintoma:* ao mudar o card, só uma cópia muda. *Causa:* ela foi desenhada à mão em vez de ser cópia do componente. *Correção:* apague a cópia e cole de novo o componente.
3. *Sintoma:* a colega não consegue abrir o link. *Causa:* o arquivo está privado. *Correção:* em **Share** (em português: **Compartilhar**), permita que "qualquer pessoa com o link" possa **view** (em português: **visualizar**).

**Se travar**

1. Releia o passo em que parou e confira se está na aba certa (**Design** para desenhar, **Prototype**, em português: **Protótipo**, para ligar).
2. Use a busca de comandos (Ctrl+/ ou Cmd+/) para achar a ferramenta pelo nome em inglês.
3. Refaça só aquela parte, em um quadro novo, para não estragar o resto.
4. Só depois peça ajuda à sua equipe, dizendo em que passo parou.

**Seu projeto agora tem**

- Nenhum arquivo novo no repositório; o protótipo vive no Figma.
- Um protótipo navegável com 3 telas, 2 componentes e o link guardado pela equipe.

**Como saber que deu certo:** alguém de fora da equipe usa o protótipo e chega à tela final sem perguntar nada.
