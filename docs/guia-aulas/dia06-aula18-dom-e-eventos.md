# Aula 18 – DOM e eventos

**Dia 6 · Qua 14/10/2026** · **Aula 18** · **UC3**

- **Requisitos cobertos:** início de RF-21 (avisar carregamento, erro e sucesso, sem deixar a tela em branco)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** js/paginas/catalogo.js com 6 produtos fictícios e funções pequenas, ligado ao catalogo.html (Aula 17)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **selecionar e criar elementos** da página com JavaScript (o **DOM**), mostrar dados com `textContent` (nunca com `innerHTML`), reagir a **cliques** com `addEventListener` e criar a **área de avisos** ("Carregando…", erro e sucesso). O cabeçalho passa a ser desenhado pelo JavaScript.

**Abertura (10 minutos).** Retomada da Aula 17: o JavaScript já sabe guardar produtos e fazer contas, mas só "fala" no Console. Hoje ele passa a **mexer na página**. Olhe o seu `catalogo.html`: o cabeçalho foi escrito à mão (e repetido em todas as páginas!). Hoje ele passa a ser **gerado** por um único arquivo, para qualquer mudança no menu ser feita em um lugar só.

## O Conceito

**Termos desta aula**

- **DOM**: a "árvore" de elementos da página que o navegador monta a partir do HTML e que o JavaScript pode ler e mudar. Cada tag vira um **nó** da árvore.
- **Seletor do DOM**: `document.getElementById("id")` acha um elemento pelo `id`; `document.querySelector(".classe")` acha o primeiro que combina com um seletor de CSS; `querySelectorAll` acha todos.
- **Evento**: algo que acontece (um clique, uma tecla, o envio de um formulário). **`addEventListener`** diz "quando este evento acontecer, rode esta função".
- **`textContent`**: coloca **texto puro** em um elemento. É a forma **segura** de mostrar dados que vêm de fora.

**A regra de segurança do projeto:** nunca use `innerHTML` com dados do banco ou digitados pela usuária (nome de produto, recado, nome de loja...). Se uma pessoa digitar `<img src=x onerror=alert(1)>`, o `innerHTML` **executaria** esse código (é o ataque chamado XSS). Com `textContent` o texto aparece como texto, sem risco. Para criar elementos, usamos `document.createElement`.

**Analogia:** o DOM é a planta do apartamento que o navegador desenhou; o JavaScript é o pedreiro que pode mover móveis, pintar uma parede ou acender uma lâmpada. O evento é a campainha: quando toca, o pedreiro vai atender.

## Mão na Massa

### Passo 1: o utilitário criarElemento

Crie as pastas `js/ui`. Dentro dela, crie `elementos.js`. Todo código repetido do projeto fica **em um lugar só**; esta função é usada em quase todas as telas:

**Arquivo: `js/ui/elementos.js`** (arquivo novo, inteiro)

```js
// Funções pequenas para montar elementos do DOM sem escrever HTML em texto (RNF-06).
// Ficam num arquivo só para as páginas não repetirem o mesmo código.

// Cria um elemento com classe e texto. O texto entra por textContent, então dados vindos do banco
// (nomes, recados) nunca são lidos como HTML.
export function criarElemento(tag, classe, texto) {
  const elemento = document.createElement(tag);
  if (classe) {
    elemento.className = classe;
  }
  if (texto !== undefined) {
    elemento.textContent = texto;
  }
  return elemento;
}
```


### Passo 2: a área de avisos

Crie `js/ui/avisos.js`. Ele mostra, logo abaixo do título (`h1`), uma caixa de **Carregando…**, de erro, de sucesso ou de informação, usando as classes `aviso` do CSS da Aula 11:

**Arquivo: `js/ui/avisos.js`** (arquivo novo, inteiro)

```js
// Avisos de carregamento, erro e sucesso (RF-21).

// Há uma única área de avisos por página, logo abaixo do título (h1), e só um aviso aparece por vez:
// o aviso novo substitui o anterior, assim "Carregando…" some quando o resultado chega.

function obterArea() {
  let area = document.querySelector(".area-avisos");

  if (!area) {
    area = document.createElement("div");
    area.className = "area-avisos";

    const titulo = document.querySelector("main h1");
    if (titulo) {
      titulo.insertAdjacentElement("afterend", area);
    } else {
      document.querySelector("main").prepend(area);
    }
  }

  return area;
}

// "papel" diz ao leitor de tela como anunciar: "status" é educado, "alert" interrompe (erros).
function mostrarAviso(classe, mensagem, papel) {
  const aviso = document.createElement("div");
  aviso.className = "aviso " + classe;
  aviso.setAttribute("role", papel);
  // textContent trata a mensagem como texto puro, nunca como HTML, pois ela pode vir de fora (RNF-06)
  aviso.textContent = mensagem;

  obterArea().replaceChildren(aviso);
}

export function mostrarCarregando(mensagem = "Carregando…") {
  mostrarAviso("aviso-carregando", mensagem, "status");
}

export function mostrarErro(mensagem) {
  mostrarAviso("aviso-erro", mensagem, "alert");
}

export function mostrarSucesso(mensagem) {
  mostrarAviso("aviso-sucesso", mensagem, "status");
}

export function mostrarInfo(mensagem) {
  mostrarAviso("aviso-info", mensagem, "status");
}

export function limparAvisos() {
  const area = document.querySelector(".area-avisos");
  if (area) {
    area.replaceChildren();
  }
}
```


### Passo 3: o cabeçalho gerado pelo JavaScript

Crie `js/ui/cabecalho.js`:

**Arquivo: `js/ui/cabecalho.js`** (arquivo novo, inteiro)

```js
// Gera o cabeçalho comum das páginas.
// Cada página tem um <header id="cabecalho"> vazio, que este arquivo preenche.

// Links que todo mundo vê.
const LINKS_FIXOS = [
  { texto: "Início", arquivo: "index.html" },
  { texto: "Catálogo", arquivo: "catalogo.html" },
  { texto: "Sacola", arquivo: "sacola.html" },
];

// Links da conta. Por enquanto toda pessoa é visitante, porque o login só chega no Dia 13.
function linksDaConta() {
  return [
    { texto: "Entrar", arquivo: "login.html" },
    { texto: "Cadastrar", arquivo: "cadastro.html" },
  ];
}

function criarLink(link, arquivoAtual) {
  const item = document.createElement("li");
  const a = document.createElement("a");
  a.href = link.arquivo;
  a.append(link.texto);

  // Marca a página atual para o estilo e para leitores de tela
  if (link.arquivo === arquivoAtual) {
    a.setAttribute("aria-current", "page");
  }

  item.append(a);
  return item;
}

export function montarCabecalho() {
  const cabecalho = document.getElementById("cabecalho");
  if (!cabecalho) {
    return;
  }

  // Descobre em qual arquivo estamos; o endereço "/" é o index.html
  const arquivoAtual = location.pathname.split("/").pop() || "index.html";

  const conteudo = document.createElement("div");
  conteudo.className = "container cabecalho-conteudo";

  const logotipo = document.createElement("a");
  logotipo.className = "logotipo";
  logotipo.href = "index.html";
  logotipo.textContent = "VitrineCol";

  const menu = document.createElement("ul");
  menu.className = "menu";
  const itens = [...LINKS_FIXOS, ...linksDaConta()].map((link) => criarLink(link, arquivoAtual));
  menu.replaceChildren(...itens);

  const navegacao = document.createElement("nav");
  navegacao.setAttribute("aria-label", "Principal");
  navegacao.append(menu);

  conteudo.append(logotipo, navegacao);
  cabecalho.replaceChildren(conteudo);
}
```


No `catalogo.html`, o cabeçalho deixa de ser escrito à mão. Troque o bloco `<header>` inteiro (do `<header class="cabecalho" id="cabecalho">` até o `</header>`) por esta linha:

**Arquivo: `catalogo.html`**: substitua o trecho que começa na linha `<header class="cabecalho" id="cabecalho">` e termina na linha `</header>` (inclusive) por:

```html
  <header class="cabecalho" id="cabecalho"></header>
```


### Passo 4: o catálogo reage ao clique

Troque o conteúdo do `js/paginas/catalogo.js` por esta versão (ela mantém a lista de produtos fictícios da aula anterior; só os exercícios do Console saem):

**Arquivo: `js/paginas/catalogo.js`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```js
// Página do catálogo (Aula 18): o cabeçalho vem do JavaScript, os avisos aparecem na tela
// e os chips de tipo de roupa reagem ao clique. Os produtos ainda são fictícios.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarSucesso, limparAvisos } from "../ui/avisos.js";

const produtosFicticios = [
  {
    id: "p1",
    nome: "Vestido midi floral",
    descricao: "Tecido leve, ideal para o verão",
    preco: 129.9,
    categoria: "Vestidos",
    lojaId: "l1",
    lojaNome: "Loja Exemplo",
    tamanhos: [
      { tamanho: "P", estoque: 3 },
      { tamanho: "M", estoque: 5 },
      { tamanho: "G", estoque: 0 },
    ],
    fotos: ["imagens/exemplo-1.svg"],
  },
  {
    id: "p2",
    nome: "Camiseta básica branca",
    descricao: "Algodão, corte reto",
    preco: 49.9,
    categoria: "Camisetas",
    lojaId: "l1",
    lojaNome: "Loja Exemplo",
    tamanhos: [
      { tamanho: "P", estoque: 10 },
      { tamanho: "M", estoque: 10 },
      { tamanho: "G", estoque: 6 },
    ],
    fotos: ["imagens/exemplo-2.svg"],
  },
  {
    id: "p3",
    nome: "Calça jeans reta",
    descricao: "Cintura alta, lavagem clara",
    preco: 159.9,
    categoria: "Calças",
    lojaId: "l2",
    lojaNome: "Loja do Bairro",
    tamanhos: [
      { tamanho: "38", estoque: 2 },
      { tamanho: "40", estoque: 4 },
      { tamanho: "42", estoque: 1 },
    ],
    fotos: ["imagens/exemplo-3.svg"],
  },
  {
    id: "p4",
    nome: "Blusa de alça",
    descricao: "Malha macia, ótima para o dia a dia",
    preco: 69.9,
    categoria: "Blusas",
    lojaId: "l2",
    lojaNome: "Loja do Bairro",
    tamanhos: [
      { tamanho: "P", estoque: 2 },
      { tamanho: "M", estoque: 0 },
      { tamanho: "G", estoque: 1 },
    ],
    fotos: ["imagens/exemplo-4.svg"],
  },
  {
    id: "p5",
    nome: "Saia plissada",
    descricao: "Comprimento midi, cintura com elástico",
    preco: 89.9,
    categoria: "Saias",
    lojaId: "l1",
    lojaNome: "Loja Exemplo",
    tamanhos: [
      { tamanho: "P", estoque: 4 },
      { tamanho: "M", estoque: 4 },
    ],
    fotos: ["imagens/exemplo-5.svg"],
  },
  {
    id: "p6",
    nome: "Jaqueta jeans",
    descricao: "Modelo curto, com bolsos frontais",
    preco: 219.9,
    categoria: "Jaquetas",
    lojaId: "l2",
    lojaNome: "Loja do Bairro",
    tamanhos: [
      { tamanho: "M", estoque: 1 },
      { tamanho: "G", estoque: 2 },
    ],
    fotos: ["imagens/exemplo-6.svg"],
  },
];

const listaChips = document.getElementById("chips-categorias");

// Só o chip escolhido fica "pressionado" (aria-pressed="true"); os outros voltam para false
function escolherChip(chipEscolhido) {
  listaChips.querySelectorAll(".chip").forEach((chip) => {
    chip.setAttribute("aria-pressed", String(chip === chipEscolhido));
  });
}

// Um "ouvinte" de clique em cada chip
listaChips.querySelectorAll(".chip").forEach((chip) => {
  chip.addEventListener("click", () => {
    escolherChip(chip);
    mostrarSucesso("Você escolheu: " + chip.textContent);
  });
});

montarCabecalho();
mostrarCarregando();
// Depois de um tempinho o aviso de "Carregando…" some (na Aula 19 isto vira a espera pelos dados)
setTimeout(limparAvisos, 1500);
```


### Passo 5: teste no navegador

1. Abra o `catalogo.html` pelo Live Server. O menu aparece (agora vindo do JavaScript), com **Catálogo** marcado como página atual.
2. Logo abaixo do título aparece **Carregando…** (caixa azul) e some depois de 1,5 segundo.
3. Clique em um chip (por exemplo, **Vestidos**): ele fica "pressionado" (cor cheia) e aparece **Você escolheu: Vestidos** (caixa verde). Clique em outro: o anterior volta ao normal.
4. **Teste de segurança:** no Console (F12 > **Console**, em português: **Console**), digite `document.querySelector("h1").textContent = "<b>teste</b>"` e aperte Enter. O título mostra o texto `<b>teste</b>` literalmente, sem negrito: é o `textContent` protegendo a página. Recarregue para desfazer.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria o cabeçalho, a área de avisos e o utilitário de elementos"
git push
```

## Explicação do Código

**elementos.js**

- `export function criarElemento(tag, classe, texto) { ... }`: `export` deixa outros arquivos usarem a função (com `import`). Ela cria o elemento com `document.createElement(tag)`, põe a classe (se houver) e o texto (se houver) com `textContent`. Os parâmetros `classe` e `texto` são **opcionais**: se não vierem, o valor é `undefined` e o `if` correspondente é pulado.

**avisos.js**

- `obterArea()`: procura o elemento `.area-avisos`. Se não existir, **cria** um `div` e o coloca logo depois do `h1` (`insertAdjacentElement("afterend", ...)`). É uma função **privada** do arquivo (sem `export`).
- `mostrarAviso(classe, mensagem, papel)`: cria a caixa, define o texto com `textContent` e usa `replaceChildren(aviso)` para **trocar** o aviso anterior pelo novo (só um aviso aparece por vez). O atributo `role` ("status" ou "alert") diz ao leitor de tela como anunciar: `alert` interrompe a leitura (erros), `status` espera (avisos comuns).
- `mostrarCarregando`, `mostrarErro`, `mostrarSucesso`, `mostrarInfo` e `limparAvisos` são as funções que as páginas usam. `mostrarCarregando(mensagem = "Carregando…")` tem um valor **padrão**.

**cabecalho.js**

- `LINKS_FIXOS` é um array de objetos com o texto e o arquivo de cada link. `criarLink(link, arquivoAtual)` monta um `<li><a>` e marca com `aria-current="page"` o link da página atual.
- `montarCabecalho()` acha o `<header id="cabecalho">`, descobre a página atual por `location.pathname.split("/").pop()` (o último pedaço do endereço; se vazio, é `index.html`), cria o logotipo, o menu e o `nav`, e coloca tudo com `replaceChildren`. Por enquanto toda pessoa é visitante (links Entrar e Cadastrar); o login chega no Dia 13.

**catalogo.js**

- `import { montarCabecalho } from "../ui/cabecalho.js";`: traz funções de outros arquivos. O caminho começa com `../` ("suba uma pasta"), pois `catalogo.js` está em `js/paginas` e o outro arquivo está em `js/ui`.
- `listaChips.querySelectorAll(".chip").forEach((chip) => { ... })`: para cada chip, `addEventListener("click", () => { ... })` registra o que fazer **quando clicarem**.
- `chip.setAttribute("aria-pressed", String(chip === chipEscolhido))`: marca como "pressionado" só o chip clicado; `String(true)` vira o texto `"true"`, que é o que o atributo aceita.
- `setTimeout(limparAvisos, 1500)`: roda `limparAvisos` depois de 1500 milissegundos. Na próxima aula essa espera vira a espera pelos dados.

## Validação

1. O menu aparece pelo JavaScript e o link **Catálogo** está destacado.
2. **Carregando…** aparece e some sozinho; ao clicar em um chip, aparece **Você escolheu: ...**.
3. O teste de `textContent` mostra `<b>teste</b>` como texto.
4. O Console não mostra erros. Confira também que o `grep` do projeto não encontra `innerHTML` nos seus arquivos: no VS Code, aperte Ctrl+Shift+F (Cmd+Shift+F no Mac), procure `innerHTML` e confira que **não há resultados** em `js/`.

**Erros comuns**

1. *Mensagem:* `Failed to resolve module specifier` ou `404` no `import`. *Causa:* o caminho do `import` está errado. *Correção:* a partir de `js/paginas`, o cabeçalho está em `../ui/cabecalho.js`; confira a pasta e o nome.
2. *Mensagem:* `Uncaught TypeError: Cannot read properties of null (reading 'querySelectorAll')`. *Causa:* o `id` do HTML e o do `getElementById` são diferentes. *Correção:* o HTML tem `id="chips-categorias"`; use o mesmo texto.
3. *Sintoma:* o cabeçalho aparece duplicado (um antigo e um novo). *Causa:* o bloco `<header>` antigo não foi substituído. *Correção:* o `<header>` do HTML deve ficar vazio: `<header class="cabecalho" id="cabecalho"></header>`.
4. *Sintoma:* o aviso "Carregando…" não aparece. *Causa:* a página não tem `<h1>` ou o `<main>` não existe. *Correção:* o `avisos.js` procura o `h1` dentro de `main`; confira o HTML.

**Se travar**

1. Abra F12 > **Console** (em português: **Console**) e leia o primeiro erro vermelho: costuma ser a causa de todos os outros.
2. Na aba **Network** (em português: **Rede**), veja se algum arquivo `.js` aparece com 404.
3. Compare os três arquivos novos com os da aula; se preciso, volte ao último commit com `git restore nome-do-arquivo` (nos arquivos que já existiam) ou apague e cole de novo (nos novos).
4. Só depois peça ajuda à sua equipe, mostrando o erro e o arquivo.

**Seu projeto agora tem**

- `js/ui/elementos.js`, `js/ui/avisos.js` (avisos de carregamento, erro, sucesso e informação) e `js/ui/cabecalho.js` (menu desenhado pelo JavaScript).
- `js/paginas/catalogo.js` com os produtos fictícios e chips que reagem ao clique.
- `catalogo.html` com o `<header>` vazio. As outras páginas ainda têm o cabeçalho escrito à mão.

**Como saber que deu certo:** ao carregar o catálogo você vê o menu criado pelo JavaScript, o aviso **Carregando…** que some sozinho e os chips que mudam de cor ao clicar.
