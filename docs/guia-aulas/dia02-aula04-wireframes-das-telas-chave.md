# Aula 4 – Wireframes das telas-chave

**Dia 2 · Qua 07/10/2026** · **Aula 4** · **UC3**

- **Requisitos cobertos:** não se aplica (planejamento das telas; prepara RF-01, RF-06, RF-08 e RF-13)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** repositório da equipe no GitHub com README e Kanban; index.html provisório (Aulas 2 e 3). Papel e lápis, ou um aplicativo de desenho simples

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai desenhar, em **baixa fidelidade**, as quatro telas-chave do sistema (catálogo, página da loja, página do produto e login), traçar o **caminho da cliente** do catálogo até o pedido e revisar os rascunhos com outra equipe.

**Abertura (10 minutos).** Retomada: já temos o backlog (Aula 1), o repositório e o Kanban (Aula 2) e uma primeira página em HTML (Aula 3). Antes de escrever mais código, vamos decidir **como as telas devem ser**. Olhe o seu Kanban: quais cartões Essenciais falam de telas? (RF-01 catálogo, RF-06 loja, RF-08 produto e RF-13 login.) Hoje desenhamos exatamente essas.

## O Conceito

**Termos desta aula**

- **Wireframe**: um rascunho da tela feito só com retângulos, linhas e textos simples, sem cores nem fotos bonitas. Mostra **onde** cada coisa fica, não como ela vai parecer.
- **Baixa fidelidade**: rascunho rápido e feio de propósito, para ser fácil de jogar fora e refazer.
- **Mobile-first** (primeiro o celular): desenhar primeiro a tela pequena e só depois a grande. É mais fácil aumentar uma tela do que espremer uma tela grande no celular.
- **Fluxo (ou caminho)**: a sequência de telas que a pessoa percorre para cumprir um objetivo, por exemplo "escolher uma roupa e fazer o pedido".

**Analogia:** o wireframe é a planta baixa de uma casa. Você decide onde ficam a sala e a cozinha antes de escolher cor de parede. Mudar uma parede na planta custa uma borracha; mudar depois de construída custa uma reforma.

## Mão na Massa

### Passo 1: preparem o material (5 minutos)

Cada integrante pega 4 folhas (ou 4 áreas de desenho) e escreve no topo: **Catálogo**, **Loja**, **Produto**, **Login**. Desenhem em formato de celular (retângulo alto, mais ou menos 9 cm por 16 cm). Se preferirem o computador, o Figma (Aula 5) também serve, mas **hoje o papel é mais rápido**.

Convenções para todas desenharem igual:

- retângulo com um "X" dentro = foto;
- linhas onduladas = texto;
- retângulo com texto = botão;
- retângulo vazio = campo de digitar.

### Passo 2: desenhe o Catálogo (10 minutos)

Use esta ideia como ponto de partida. Cada equipe pode mudar, mas **tudo o que está aqui precisa existir**:

```text
+------------------------------+
| VitrineCol   Início Cat.. |   <- cabeçalho: logotipo e menu
+------------------------------+
| Catálogo                     |   <- título da página
| Buscar pelo nome: [_______]  |
| Loja: [Todas v]  Tam.: [v]   |
| (Todas)(Blusas)(Vestidos)... |   <- tipos de roupa (chips)
+------------------------------+
| +--------+  +--------+       |
| |  [X]   |  |  [X]   |       |   <- cards de produto
| | Nome   |  | Nome   |       |      foto, nome, preço e loja
| | R$ 99  |  | R$ 49  |       |
| | Loja A |  | Loja B |       |
| +--------+  +--------+       |
|   [ Carregar mais produtos ] |
+------------------------------+
| Rodapé: privacidade ...      |
+------------------------------+
```

### Passo 3: desenhe a Loja, o Produto e o Login (20 minutos)

**Página da loja** (RF-06 e RF-07): nome da loja no topo; descrição; endereço; botões **Conversar no WhatsApp** e **Ver no mapa**; embaixo, os cards dos produtos da loja.

**Página do produto** (RF-08): foto grande; uma faixa de miniaturas das outras fotos; preço; "Vendido por [loja]" (um link); descrição; botões de **tamanho** (P, M, G...), um deles marcado como "sem estoque"; campo de **quantidade**; botão **Adicionar à sacola**.

**Login** (RF-13): título "Entrar"; campos **E-mail** e **Senha**; botão **Entrar**; links "Esqueci minha senha" e "Ainda não tem conta? Cadastre-se".

Faça um desenho por tela. Use setas para indicar "esta imagem leva a esta tela" (por exemplo, o card leva ao Produto; o nome da loja leva à Loja).

### Passo 4: trace o caminho da cliente (5 minutos)

Em uma folha à parte, desenhe os quadradinhos das telas ligados por setas, do jeito que a Marina percorre:

```text
Catálogo -> Produto -> Sacola -> (se não estiver logada) Login -> Pedidos enviados -> WhatsApp da loja
```

Agora **conte as ações** da cliente, do catálogo ao pedido: (1) clicar em um produto, (2) escolher o tamanho, (3) clicar em **Adicionar à sacola**, (4) abrir a **Sacola**, (5) clicar em **Finalizar sacola**, (6) clicar no botão do WhatsApp. São **6 ações**: essa é a meta do projeto (uma cliente nova chega do catálogo ao pedido em até 6 ações). Se o seu desenho precisar de mais, simplifique.

### Passo 5: revise com outra equipe (10 minutos)

Troquem os rascunhos com outra equipe. Quem recebe responde, em voz alta ou por escrito, estas perguntas e **não explica nada** para quem desenhou (se precisar explicar, o desenho não está claro):

1. Em cada tela, qual é o botão principal?
2. Dá para saber de qual loja é cada produto?
3. Dá para voltar ao catálogo a partir de qualquer tela?
4. O que aconteceria se a lista de produtos estivesse vazia?
5. O caminho tem mais de 6 ações?

Anote as respostas e ajuste os desenhos. Tire uma **foto** de cada wireframe final (com o celular) e guarde na pasta compartilhada da equipe.

## Explicação do Código

Esta aula não tem código, então explicamos as decisões do desenho:

- **Cabeçalho igual em todas as telas** (logotipo e menu): assim a cliente nunca se perde. Mais adiante ele será escrito uma vez só e reaproveitado.
- **Filtros no topo do catálogo**: filtrar é a ação mais usada pela cliente (tipo, tamanho e loja), então fica antes dos produtos.
- **Botão "Carregar mais produtos"** em vez de várias páginas: no celular é mais natural continuar rolando.
- **Tamanho sem estoque aparece, mas desabilitado**: a cliente vê que existe e entende por que não pode escolher.
- **Nome da loja como link**: a cliente pode conhecer a loja e voltar para os outros produtos dela.
- **Login só na hora de finalizar** (e não no começo): a cliente monta a sacola sem barreira e só entra na conta quando precisa. Isso reduz abandono.
- **Contar as ações** é uma forma simples de medir facilidade de uso, e vamos repetir essa conta no teste com usuárias (Dia 27).

## Validação

Confira:

- [ ] Existe um wireframe de cada uma das 4 telas (catálogo, loja, produto, login).
- [ ] Há um desenho do caminho com setas, do catálogo até o WhatsApp, e ele tem no máximo 6 ações da cliente.
- [ ] Outra equipe respondeu às 5 perguntas do Passo 5 e vocês anotaram os ajustes.
- [ ] As fotos dos wireframes estão salvas em um lugar que toda a equipe acessa.

**Erros comuns**

1. *Sintoma:* o desenho ficou parecido com uma tela pronta (cores, fotos reais, fontes). *Causa:* a equipe começou a decorar. *Correção:* volte para retângulos e linhas; as cores entram na Aula 6.
2. *Sintoma:* uma tela tem 12 botões do mesmo tamanho. *Causa:* tudo parece igualmente importante. *Correção:* escolha **um** botão principal por tela e deixe os outros como links ou botões menores.
3. *Sintoma:* a outra equipe não entendeu o desenho. *Causa:* faltam rótulos nos campos. *Correção:* escreva o nome de cada campo e botão; é isso que vira `label` no HTML.

**Se travar**

1. Releia o exemplo do Catálogo e copie a ideia, mudando só o que a sua equipe quer mudar.
2. Pergunte a outra integrante: "o que você esperaria ver aqui?" e desenhe a resposta.
3. Se a dúvida continuar, anote-a no quadro Kanban como um cartão "Dúvida de tela" e siga para o próximo passo. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- Nenhum arquivo novo no repositório (a aula é de desenho).
- Wireframes de 4 telas e o desenho do caminho da cliente, em fotos guardadas pela equipe.
- Uma lista de ajustes vindos da revisão com outra equipe.

**Como saber que deu certo:** uma pessoa de fora, olhando só os seus desenhos, consegue dizer onde clicar para ir do catálogo até o pedido.
