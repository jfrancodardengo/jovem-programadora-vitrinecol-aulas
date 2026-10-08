# Aula 12 – Layout com Grid e o componente card de produto

**Dia 4 · Sex 09/10/2026** · **Aula 12** · **UC3**

- **Requisitos cobertos:** apresentação visual de RF-01 (listar os produtos em cards com foto, nome, preço e loja)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** css/variaveis.css, css/base.css e css/componentes.css (cabeçalho, botões, campos, avisos e chips) ligados às páginas; catalogo.html com 3 cards de exemplo (Aulas 9 a 11)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai usar o **CSS Grid** para organizar o catálogo em colunas e construir o **componente card de produto** (foto, nome, preço e loja), aplicando a grade ao catálogo e criando o arquivo `css/paginas.css`.

**Abertura (10 minutos).** Retomada da Aula 11: o Flexbox organizou itens em **uma** direção (linha ou coluna). Para uma vitrine com várias linhas **e** várias colunas, o Grid é a ferramenta certa. Abra o `catalogo.html` no Live Server: os 3 cards de exemplo estão um embaixo do outro, sem estilo. Hoje eles viram cards.

## O Conceito

**Termos desta aula**

- **Grid**: organiza elementos em uma **tabela invisível** de linhas e colunas. Liga-se com `display: grid` no pai.
- **`grid-template-columns`**: define as colunas. `1fr` é uma "fração" do espaço livre: `repeat(3, 1fr)` cria 3 colunas iguais.
- **Card**: a "ficha" de um produto, com foto, nome, preço e loja, dentro de uma caixa com borda e sombra.
- **Proporção (`aspect-ratio`)**: a relação entre largura e altura. `4 / 5` quer dizer 4 de largura para 5 de altura, que é o formato "retrato" de foto de roupa.

**Flexbox ou Grid?** Flexbox para **uma fileira** (menu, chips, botões). Grid para uma **grade** (catálogo, filtros).

**Analogia:** o Grid é uma cartela de ovos: cada ovo tem o seu lugar, as colunas são do mesmo tamanho, e você não precisa calcular a posição de cada um.

## Mão na Massa

### Passo 1: adicione a seção do card ao componentes.css

Cole as regras do card **antes** da seção `Campos de formulário`, ou seja, **logo antes do comentário** `/* ---------- Campos de formulário ---------- */`:

**Arquivo: `css/componentes.css`**: adicione estas seções logo antes do comentário `/* ---------- Campos de formulário ---------- */`:

```css
/* ---------- Card de produto (grade: 1 coluna no celular, 2 no tablet, 3 a 4 no desktop) ---------- */
.grade-produtos {
  display: grid;
  gap: var(--espaco-4);
  grid-template-columns: 1fr;
  list-style: none;
}

.card-produto {
  display: flex;
  flex-direction: column;
  height: 100%;
  overflow: hidden;
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
  box-shadow: var(--sombra-leve);
}

.card-produto-imagem {
  width: 100%;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  background-color: var(--cor-neutro-fundo);
}

.card-produto-corpo {
  display: flex;
  flex-direction: column;
  gap: var(--espaco-1);
  padding: var(--espaco-4);
}

.card-produto-titulo {
  margin: 0;
  font-size: var(--tamanho-medio);
}

.card-produto-titulo a {
  color: var(--cor-texto);
  text-decoration: none;
}

/* O link do título cobre o card inteiro, assim o card todo é clicável */
.card-produto {
  position: relative;
}

.card-produto-titulo a::after {
  content: "";
  position: absolute;
  inset: 0;
}

.card-produto-titulo a:hover {
  text-decoration: underline;
}

.card-produto:focus-within {
  outline: 3px solid var(--cor-foco);
  outline-offset: 2px;
}

.card-produto-titulo a:focus-visible {
  outline: none;
}

.preco {
  margin: 0;
  font-size: var(--tamanho-medio);
  font-weight: 700;
  color: var(--cor-primaria-escura);
}

.card-produto-loja {
  margin: 0;
  font-size: var(--tamanho-pequeno);
  color: var(--cor-texto-suave);
}
```


Resultado: os cards ficam com foto no formato retrato, cantos arredondados e sombra, um embaixo do outro (uma coluna: no celular é assim mesmo).

### Passo 2: veja a grade funcionando (experimento)

Para enxergar as colunas, **teste temporariamente**: na regra `.grade-produtos`, troque `grid-template-columns: 1fr;` por `grid-template-columns: repeat(3, 1fr);`, salve e veja os 3 cards lado a lado. **Volte para `1fr`** no final: a aula do Dia 5 fará as colunas mudarem sozinhas conforme a largura da tela.

### Passo 3: crie o paginas.css com os filtros do catálogo

O `paginas.css` guarda o que é específico de cada página. Crie `css/paginas.css` com:

**Arquivo: `css/paginas.css`** (arquivo novo):

```css
/* Ajustes específicos de cada página. Componentes genéricos ficam em componentes.css. */

/* ---------- Catálogo (index.html) ---------- */
.filtros {
  display: grid;
  gap: var(--espaco-4);
  margin-bottom: var(--espaco-5);
  padding: var(--espaco-4);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.filtros-campos {
  display: grid;
  gap: var(--espaco-3);
}
```


Ligue o arquivo às cinco páginas, colando esta linha **dentro do `<head>`, logo antes de `</head>`**:

```html
<link rel="stylesheet" href="css/paginas.css">
```


Resultado: o formulário de filtros do catálogo vira uma caixa branca com borda, e os campos de loja e tamanho ficam um embaixo do outro (também uma coluna no celular).

### Passo 4: confira o card inteiro

1. Passe o mouse sobre um card: o nome ganha sublinhado.
2. Aperte **Tab** até o nome de um produto: aparece um contorno azul em volta do **card inteiro**.
3. Clique em qualquer ponto do card (foto, preço, loja): a página do produto abre. O card todo é clicável.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria o card de produto e a grade do catálogo"
git push
```

## Explicação do Código

**Seção "Card de produto" (componentes.css)**

- `.grade-produtos { display: grid; gap: var(--espaco-4); grid-template-columns: 1fr; list-style: none; }`: a lista `ul` vira uma grade com uma coluna de largura total (`1fr`) e espaço entre os cards. `list-style: none` tira os marcadores.
- `.card-produto { display: flex; flex-direction: column; height: 100%; overflow: hidden; background-color; border; border-radius; box-shadow }`: o card é uma coluna flex (foto em cima, texto embaixo). `overflow: hidden` corta qualquer coisa que passe das bordas arredondadas (por exemplo, os cantos da foto). `height: 100%` faz os cards de uma mesma linha terem a mesma altura.
- `.card-produto-imagem { width: 100%; aspect-ratio: 4 / 5; object-fit: cover; background-color }`: a foto ocupa a largura do card em formato retrato. `object-fit: cover` recorta a foto para **preencher** o espaço sem deformar. O fundo cinza aparece enquanto a imagem carrega.
- `.card-produto-corpo { display: flex; flex-direction: column; gap; padding }`: a parte de texto, também em coluna.
- `.card-produto-titulo` e `.card-produto-titulo a`: tamanho do título e cor do link sem sublinhado; `:hover` sublinha.
- `.card-produto { position: relative; }` e `.card-produto-titulo a::after { content: ""; position: absolute; inset: 0; }`: um truque para o **card inteiro** ser clicável. O `::after` é um elemento invisível criado pelo CSS, que cobre toda a área do card (`inset: 0` = colado nas quatro bordas do pai posicionado) e pertence ao link do título. Assim, só existe **um** link (bom para o leitor de tela), mas qualquer ponto do card o aciona.
- `.card-produto:focus-within { outline }` e `.card-produto-titulo a:focus-visible { outline: none }`: quando o link recebe o foco do teclado, o contorno aparece em volta do card inteiro (e não só no texto).
- `.preco` e `.card-produto-loja`: o preço em negrito na cor primária escura; o nome da loja menor e cinza.

**paginas.css, seção "Catálogo"**

- `.filtros { display: grid; gap; margin-bottom; padding; background-color; border; border-radius }`: o formulário de filtros é uma grade de uma coluna dentro de uma caixa.
- `.filtros-campos { display: grid; gap }`: os campos de loja e de tamanho também.

## Validação

1. O catálogo mostra os 3 cards com foto em formato retrato, nome, preço e loja.
2. O card todo é clicável e o foco do teclado desenha um contorno em volta dele.
3. O experimento com `repeat(3, 1fr)` mostrou 3 colunas, e você voltou para `1fr`.
4. O formulário de filtros está dentro de uma caixa branca com borda.
5. Todas as cinco páginas continuam abrindo sem erros no Console.

**Erros comuns**

1. *Sintoma:* os cards continuam sem estilo. *Causa:* a seção do card foi colada **depois** do final ou fora de um arquivo ligado à página. *Correção:* confira se está no `css/componentes.css` e se o `<link>` da página existe.
2. *Sintoma:* a foto aparece achatada ou esticada. *Causa:* faltou `object-fit: cover` ou `aspect-ratio`. *Correção:* confira as duas linhas em `.card-produto-imagem`.
3. *Sintoma:* os cards têm alturas diferentes. *Causa:* faltou `height: 100%` em `.card-produto`. *Correção:* confira essa linha.
4. *Sintoma:* o clique no card não abre a página, só o clique no nome. *Causa:* faltou a regra `.card-produto { position: relative; }` ou a do `::after`. *Correção:* confira as duas regras da seção.

**Se travar**

1. Use F12 > **Elements** (em português: **Elementos**), selecione a `ul` da lista de produtos e veja se `display: grid` aparece em **Styles** (em português: **Estilos**). Se o navegador mostrar um ícone de grade ao lado, o Grid está ligado.
2. Compare as regras com as da aula, uma por uma.
3. Desfaça com `git status` e `git restore css/componentes.css`, se algo quebrou.
4. Só depois peça ajuda à sua equipe, dizendo qual regra não surtiu efeito.

**Seu projeto agora tem**

- `css/variaveis.css`, `css/base.css`, `css/componentes.css` (com cabeçalho, rodapé, botões, **card**, campos, avisos e chips) e `css/paginas.css` (filtros do catálogo), ligados às cinco páginas.
- Um catálogo com cards estilizados e clicáveis (ainda em uma coluna).

**Como saber que deu certo:** cada card tem a mesma altura que os vizinhos, o card inteiro abre a página do produto, e com `repeat(3, 1fr)` aparecem 3 colunas.
