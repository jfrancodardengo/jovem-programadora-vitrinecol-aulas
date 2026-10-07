# Aula 10 – CSS: seletores, cores, tipografia e modelo de caixa

**Dia 4 · Sex 09/10/2026** · **Aula 10** · **UC3**

- **Requisitos cobertos:** não se aplica (identidade visual das telas; cores e tipografia do guia de estilo)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** cinco páginas HTML estáticas e sem CSS (index, catalogo, loja, produto e login), com cabeçalho e rodapé iguais, e as imagens de exemplo (Aulas 7 a 9); o guia de estilo com a paleta (Aula 6)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **ligar um arquivo CSS** às páginas, usar **seletores** de elemento e de classe, aplicar as **cores e a tipografia** do guia de estilo e entender o **modelo de caixa** (`margin`, `padding`, `border`).

**Abertura (10 minutos).** Retomada da Aula 9: as páginas existem e se navegam, mas estão "peladas". Abra a página do produto no Live Server e anote três coisas que você mudaria agora (cor, tamanho de letra, espaço). Hoje começamos a mudar. Deixe o guia de estilo da Aula 6 aberto: a paleta dele é o que vamos escrever.

## O Conceito

**Termos desta aula**

- **CSS**: a linguagem que descreve **como** a página parece (cores, fontes, espaços). O HTML diz "o que é", o CSS diz "como fica".
- **Seletor**: a parte do CSS que escolhe **quais elementos** recebem o estilo. `p` escolhe todos os parágrafos; `.botao` escolhe os que têm `class="botao"`.
- **Propriedade e valor**: o que muda e para quê, no formato `propriedade: valor;`. Exemplo: `color: red;`.
- **Modelo de caixa**: todo elemento é uma caixa com quatro camadas, de dentro para fora: o conteúdo, o `padding` (espaço **dentro**, entre o conteúdo e a borda), a `border` (a linha) e a `margin` (espaço **fora**, entre esta caixa e as vizinhas).
- **Variável CSS (custom property)**: um nome guardado para reaproveitar um valor, escrito com dois hífens: `--cor-primaria: #8a2252;`. Usa-se com `var(--cor-primaria)`.

**Analogia:** o modelo de caixa é um quadro na parede: a foto é o conteúdo, o espaço branco ao redor da foto dentro da moldura é o `padding`, a moldura é a `border` e a distância até o quadro do lado é a `margin`.

**Por que variáveis já hoje?** O guia de estilo da Aula 6 definiu nomes para cada cor (`--cor-primaria` e outras). Se escrevermos o código com esses nomes desde o começo, trocar uma cor do site inteiro é mudar **uma linha**. Na Aula 14 voltamos a elas com mais calma.

## Mão na Massa

### Passo 1: crie a pasta css e o arquivo de variáveis

Na raiz do projeto crie a pasta `css`. Dentro dela crie o arquivo `variaveis.css`. É o guia de estilo escrito em código: cores, fontes, espaços, bordas arredondadas e sombras.

**Arquivo: `css/variaveis.css`** (arquivo novo, inteiro)

```css
/* Variáveis globais do site. Mudar uma cor ou espaçamento aqui muda o site todo.
   Paleta provisória: todos os pares texto/fundo usados têm contraste mínimo de 4,5:1 (AA). */
:root {
  /* Cores principais */
  --cor-primaria: #8a2252;
  --cor-primaria-escura: #6b1a40;
  --cor-primaria-clara: #f7e6ee;
  --cor-fundo: #fbf8f6;
  --cor-superficie: #ffffff;
  --cor-texto: #2b2230;
  --cor-texto-suave: #5d5365;
  --cor-texto-sobre-primaria: #ffffff;

  /* Bordas: a de campos é mais escura para ter contraste de 3:1 com o fundo (AA para componentes) */
  --cor-borda: #ddd5da;
  --cor-borda-campo: #7a6f82;

  /* Estados */
  --cor-erro: #b3261e;
  --cor-erro-fundo: #fde8e6;
  --cor-sucesso: #1b6b3a;
  --cor-sucesso-fundo: #e6f4ea;
  --cor-info: #1d4e89;
  --cor-info-fundo: #e3eefb;
  --cor-neutro: #3d3a40;
  --cor-neutro-fundo: #ececee;
  --cor-foco: #1a5fb4;

  /* Tipografia: fonte do sistema, sem baixar nada */
  --fonte-base: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  --tamanho-pequeno: 0.875rem;
  --tamanho-base: 1rem;
  --tamanho-medio: 1.125rem;
  --tamanho-grande: 1.5rem;
  --tamanho-titulo: 1.75rem;
  --altura-linha: 1.5;

  /* Espaçamentos */
  --espaco-1: 0.25rem;
  --espaco-2: 0.5rem;
  --espaco-3: 0.75rem;
  --espaco-4: 1rem;
  --espaco-5: 1.5rem;
  --espaco-6: 2rem;
  --espaco-7: 3rem;

  /* Raios e sombras leves */
  --raio-pequeno: 0.375rem;
  --raio-medio: 0.75rem;
  --raio-pilula: 999px;
  --sombra-leve: 0 1px 3px rgba(43, 34, 48, 0.12);
  --sombra-media: 0 4px 12px rgba(43, 34, 48, 0.12);

  /* Largura máxima do conteúdo */
  --largura-maxima: 72rem;
}
```


### Passo 2: crie o base.css

O `base.css` guarda o que vale para a página toda: o "reset", a tipografia, os links, as imagens e o contêiner central. Crie `css/base.css` com este conteúdo:

**Arquivo: `css/base.css`** (arquivo novo):

```css
/* Reset leve, tipografia e utilitários básicos. Mobile-first. */
*,
*::before,
*::after {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  font-family: var(--fonte-base);
  font-size: var(--tamanho-base);
  line-height: var(--altura-linha);
  color: var(--cor-texto);
  background-color: var(--cor-fundo);
}

main {
  flex: 1;
  padding-block: var(--espaco-5);
}

h1,
h2,
h3 {
  line-height: 1.25;
  margin: 0 0 var(--espaco-3);
}

h1 {
  font-size: var(--tamanho-titulo);
}

h2 {
  font-size: var(--tamanho-grande);
}

h3 {
  font-size: var(--tamanho-medio);
}

p {
  margin: 0 0 var(--espaco-3);
}

ul,
ol {
  margin: 0;
  padding: 0;
}

a {
  color: var(--cor-primaria-escura);
}

a:hover {
  color: var(--cor-primaria);
}

img {
  display: block;
  max-width: 100%;
  height: auto;
}

/* Contêiner central; o padding lateral evita texto colado na borda do celular */
.container {
  width: 100%;
  max-width: var(--largura-maxima);
  margin-inline: auto;
  padding-inline: var(--espaco-4);
}

```


### Passo 3: ligue os dois arquivos às páginas

Em cada uma destas cinco páginas: `index.html`, `catalogo.html`, `loja.html`, `produto.html` e `login.html`, cole as duas linhas abaixo **dentro do `<head>`, logo antes da linha `</head>`**:

```html
<link rel="stylesheet" href="css/variaveis.css">
<link rel="stylesheet" href="css/base.css">
```


A **ordem** importa: primeiro as variáveis, depois o resto (um arquivo só enxerga as variáveis se elas já foram carregadas).

### Passo 4: veja o resultado e mexa na paleta

1. Abra o `catalogo.html` no Live Server. A página já tem fonte do sistema, cores do guia de estilo, imagens que não estouram a largura e conteúdo centralizado com margem nas laterais.
2. Aperte F12 e na aba **Elements** (em português: **Elementos**) clique no título "Catálogo". No painel da direita procure o diagrama do **modelo de caixa**, na aba **Computed** (em português: **Calculado**, o nome pode variar com a versão do navegador). Você vê o conteúdo no centro e `padding`, `border` e `margin` em volta.
3. Experimento com as variáveis: no `css/variaveis.css`, troque `--cor-fundo: #fbf8f6;` por `--cor-fundo: #ffe9f1;`, salve e veja o fundo de todas as páginas mudar de uma vez. Depois volte ao valor original.
4. Experimento com o seletor: no `css/base.css`, na regra `h1 { ... }`, troque `var(--tamanho-titulo)` por `3rem` e veja todos os títulos `h1` crescerem. Desfaça (Ctrl+Z, ou Cmd+Z no Mac).

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria as variáveis de estilo e o CSS base ligados às páginas"
git push
```

## Explicação do Código

**variaveis.css**

- `:root { ... }`: o seletor `:root` é a "raiz" do documento (o elemento `html`). Variáveis declaradas aqui valem para a página toda.
- `--cor-primaria: #8a2252;`: o nome (com `--` na frente) e o valor. `#8a2252` é uma cor em hexadecimal.
- As variáveis de cor seguem o guia de estilo. `--fonte-base` usa a **fonte do sistema**. Os tamanhos de letra usam `rem`: 1 rem é o tamanho de letra padrão do navegador (normalmente 16 px), então `1.5rem` é uma vez e meia isso. O `rem` respeita quem aumenta a letra do navegador.
- `--espaco-1` a `--espaco-7`: a escala de espaços (0,25 rem a 3 rem). `--raio-*`: cantos arredondados. `--sombra-*`: sombras leves. `--largura-maxima`: a largura máxima do conteúdo.

**base.css**

- `*, *::before, *::after { box-sizing: border-box; }`: o `*` escolhe **todos** os elementos. `border-box` faz com que a largura de uma caixa **inclua** `padding` e borda; sem isso, uma caixa de largura 100% com `padding` estouraria a tela.
- `body { margin: 0; min-height: 100vh; display: flex; flex-direction: column; ... }`: tira a margem padrão do navegador, faz a página ter pelo menos a altura da janela (`100vh`) e, com `flex-direction: column`, empilha cabeçalho, conteúdo e rodapé. Os valores `font-family`, `font-size`, `line-height`, `color` e `background-color` usam as variáveis (`var(--...)`). `line-height` é a altura da linha.
- `main { flex: 1; padding-block: ... }`: o conteúdo cresce para ocupar o espaço livre (empurrando o rodapé para baixo); `padding-block` é o espaço em cima e embaixo.
- `h1, h2, h3 { ... }`: seletor de **lista** (a vírgula separa elementos que recebem o mesmo estilo). `h1`, `h2` e `h3` têm cada um o seu tamanho em regras próprias.
- `p { margin: 0 0 var(--espaco-3); }`: `margin` com três valores = em cima, nos lados e embaixo.
- `ul, ol { margin: 0; padding: 0; }`: tira o recuo padrão das listas (os itens do menu serão alinhados no CSS do Dia 4).
- `a { color: ...}` e `a:hover { ... }`: `:hover` é um **estado**: vale quando o mouse está sobre o link.
- `img { display: block; max-width: 100%; height: auto; }`: a imagem nunca passa da largura do espaço dela e mantém a proporção.
- `.container { width: 100%; max-width: ...; margin-inline: auto; padding-inline: ... }`: o seletor `.container` escolhe elementos com `class="container"`. `margin-inline: auto` **centraliza** a caixa; `padding-inline` afasta o texto da borda da tela do celular.

## Validação

1. As cinco páginas carregam sem erro. Abra o **Console** (F12 > **Console**, em português: **Console**): não pode haver erros de arquivo CSS não encontrado.
2. O fundo da página é um tom quente claro (`#fbf8f6`), o texto é escuro, os títulos têm tamanhos diferentes e as imagens respeitam a largura da tela.
3. A página está centralizada, com margens, em uma janela larga.
4. A experiência de trocar `--cor-fundo` mudou todas as páginas de uma vez.

**Erros comuns**

1. *Sintoma:* nada muda ao salvar o CSS. *Causa:* o `<link>` está errado (caminho ou nome do arquivo) ou foi colado fora do `<head>`. *Correção:* o caminho deve ser `css/base.css`, e a pasta se chama `css`, minúscula e sem acento.
2. *Sintoma:* as cores não aparecem, mas os tamanhos funcionam. *Causa:* `base.css` foi ligado antes de `variaveis.css`, ou o nome da variável tem um erro de digitação. *Correção:* confira a ordem dos dois `<link>` e a grafia (`--cor-texto`, não `--cor_texto`).
3. *Sintoma:* uma regra não faz efeito. *Causa:* faltou o `;` no fim de uma linha ou a `}` de uma regra. *Correção:* cada declaração termina com `;` e cada regra com `}`; o VS Code destaca o erro com um sublinhado.
4. *Sintoma:* a página fica toda colada na borda esquerda. *Causa:* a classe `container` não está no `<main>` ou no `<div>` do cabeçalho. *Correção:* confira o `class="container"` nos elementos do HTML da Aula 7.

**Se travar**

1. Aperte F12 e na aba **Elements** (em português: **Elementos**) clique no elemento que não ficou certo; no painel **Styles** (em português: **Estilos**) as regras que o atingem aparecem, e as riscadas foram sobrescritas.
2. Compare os seus dois arquivos CSS com os da aula, linha por linha.
3. Veja o que mudou com `git status` e `git diff`; volte ao último commit com `git restore css/base.css`, se precisar.
4. Só depois peça ajuda à sua equipe, dizendo o arquivo e a regra que não funciona.

**Seu projeto agora tem**

- As páginas `index.html`, `catalogo.html`, `loja.html`, `produto.html` e `login.html`, agora ligadas a `css/variaveis.css` e `css/base.css`.
- Tipografia, cores, links, imagens e o contêiner central já com o visual do guia de estilo.
- Ainda faltam o cabeçalho, os botões, os campos e os cards estilizados (próximas aulas).

**Como saber que deu certo:** ao trocar `--cor-fundo` em `variaveis.css`, o fundo de **todas** as páginas muda ao mesmo tempo.
