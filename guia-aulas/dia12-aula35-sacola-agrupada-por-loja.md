# Aula 35 – Sacola de compras com localStorage, agrupada por loja

**Dia 12 · Qui 22/10/2026** · **Aula 35** · **UC3**

- **Requisitos cobertos:** RF-09 (sacola com peças de várias lojas: adicionar, mudar quantidade, remover, subtotal por loja e total), RN-02 (a quantidade mínima de um item é 1) e RN-03 (a sacola mistura lojas); casos de teste CT-04 e CT-05
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** páginas produto.html e loja.html dinâmicas, com tamanho e quantidade validados mas sem sacola; sacola.html estática (Aulas 15 e 34)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar a **classe `Sacola`** (adicionar, mudar a quantidade e remover), guardá-la no **localStorage** para sobreviver a um recarregamento, mostrar os itens **agrupados por loja** com **subtotal por loja e total**, e exibir o **contador de itens** no cabeçalho.

**Abertura (10 minutos).** Retomada da Aula 34: a página do produto já valida o tamanho e a quantidade, mas "Adicionar à sacola" só mostra uma mensagem de teste. Pense: a cliente adiciona uma peça, abre outra página, **recarrega**, e a peça ainda precisa estar lá. Onde guardar isso, se a sacola não é do banco? A resposta é o **navegador**.

## O Conceito

**Termos desta aula**

- **`localStorage`**: uma pequena "gaveta" do navegador onde o site guarda **texto** (em pares nome e valor) que **continua lá** mesmo depois de fechar a aba. Cada site tem a sua gaveta. A sacola fica aqui, com o nome `sacola`.
- **JSON (`JSON.stringify` e `JSON.parse`)**: o `localStorage` só guarda texto. `JSON.stringify(objeto)` transforma uma lista de itens em texto; `JSON.parse(texto)` transforma de volta. Se o texto estiver estragado, o `parse` falha: a classe trata isso devolvendo uma sacola vazia.
- **Agrupar por loja**: percorrer os itens e juntá-los por `lojaId`. Usamos um `Map` (um dicionário: chave `lojaId`, valor = grupo da loja). Cada grupo vira, na Aula 36, **um pedido**.
- **Soma em centavos**: somar decimais direto dá erros como `0.1 + 0.2 = 0.30000000000000004`. A classe multiplica o preço por 100, arredonda e soma números **inteiros**, e divide por 100 no fim.

**Analogia:** a sacola é a **sacola de papel** que a cliente carrega no shopping: ela vai pondo peças de várias lojas, e só na hora de pagar a loja separa o que é dela. O `localStorage` é a **mão da cliente**, que continua segurando a sacola ao ir de uma loja para outra.

**Regras:** RN-03: a sacola aceita peças de **várias lojas** (nada é perguntado ao misturar). RN-02: a quantidade mínima de um item é 1 (para tirar da sacola existe o botão **Remover**). O mesmo produto no mesmo tamanho vira **uma linha só**, com a quantidade somada.

## Mão na Massa

### Passo 1: a classe Sacola

Crie `js/modelos/Sacola.js`:

**Arquivo: `js/modelos/Sacola.js`** (arquivo novo, inteiro)

```js
// Sacola de compras. Aceita peças de VÁRIAS lojas (RN-03) e fica guardada no navegador (localStorage).
// Cada item guarda uma "foto" dos dados do produto no momento em que foi adicionado
// (nome, preço, loja), para a sacola poder ser mostrada sem consultar o banco.
import { ErroApp } from "./ErroApp.js";
import { Produto } from "./Produto.js";

// Nome da gaveta do localStorage onde a sacola fica guardada.
export const CHAVE_SACOLA = "sacola";

export class Sacola {
  // Cada item: { produtoId, nome, preco, tamanho, quantidade, lojaId, lojaNome, foto }
  #itens = [];

  constructor(itens = []) {
    // Itens com formato estranho (localStorage antigo ou mexido à mão) são descartados.
    itens.filter(Sacola.#itemValido).forEach((item) => this.#itens.push({ ...item }));
  }

  // ---------- Leitura ----------

  // Cópia dos itens; quem está de fora não altera a lista original.
  get itens() {
    return this.#itens.map((item) => ({ ...item }));
  }

  estaVazia() {
    return this.#itens.length === 0;
  }

  // Soma das quantidades (o número que aparece no cabeçalho).
  quantidadeTotal() {
    return this.#itens.reduce((soma, item) => soma + item.quantidade, 0);
  }

  total() {
    return Sacola.#somar(this.#itens);
  }

  // Agrupa os itens por loja, na ordem em que cada loja apareceu.
  // Cada grupo vira um pedido na hora de finalizar (RN-03).
  itensPorLoja() {
    // O Map guarda um grupo por lojaId
    const grupos = new Map();

    for (const item of this.#itens) {
      if (!grupos.has(item.lojaId)) {
        grupos.set(item.lojaId, { lojaId: item.lojaId, lojaNome: item.lojaNome, itens: [] });
      }
      grupos.get(item.lojaId).itens.push({ ...item });
    }

    return [...grupos.values()].map((grupo) => ({
      ...grupo,
      subtotal: Sacola.#somar(grupo.itens),
    }));
  }

  // ---------- Alterações ----------

  adicionar(produto, tamanho, quantidade = 1) {
    if (!(produto instanceof Produto)) {
      throw new ErroApp("produto_invalido", "Produto inválido.");
    }
    const quantidadeValida = Sacola.#validarQuantidade(quantidade);

    // RF-08: tamanho sem estoque não pode ser escolhido
    if (!produto.temEstoque(tamanho)) {
      throw new ErroApp("tamanho_indisponivel", "Este tamanho está sem estoque.");
    }

    // O mesmo produto no mesmo tamanho vira uma linha só, com a quantidade somada
    const existente = this.#buscar(produto.id, tamanho);
    if (existente) {
      existente.quantidade += quantidadeValida;
      return;
    }

    this.#itens.push({
      produtoId: produto.id,
      nome: produto.nome,
      preco: produto.preco,
      tamanho,
      quantidade: quantidadeValida,
      lojaId: produto.lojaId,
      lojaNome: produto.lojaNome,
      foto: produto.fotoCapa(),
    });
  }

  // RN-02: a quantidade mínima de um item é 1 (para tirar da sacola existe o remover).
  alterarQuantidade(produtoId, tamanho, quantidade) {
    const quantidadeValida = Sacola.#validarQuantidade(quantidade);
    this.#buscarOuFalhar(produtoId, tamanho).quantidade = quantidadeValida;
  }

  remover(produtoId, tamanho) {
    const item = this.#buscarOuFalhar(produtoId, tamanho);
    this.#itens = this.#itens.filter((outro) => outro !== item);
  }

  // Troca o preço dos itens pelo preço atual do produto (precosPorProduto é um Map: id do produto -> preço).
  // Usada ao finalizar, quando o lojista mudou um preço depois que a peça entrou na sacola.
  // Devolve a lista do que mudou: [{ nome, de, para }].
  atualizarPrecos(precosPorProduto) {
    const alterados = [];

    for (const item of this.#itens) {
      const novoPreco = precosPorProduto.get(item.produtoId);
      if (Number.isFinite(novoPreco) && novoPreco > 0 && novoPreco !== item.preco) {
        alterados.push({ nome: item.nome, de: item.preco, para: novoPreco });
        item.preco = novoPreco;
      }
    }
    return alterados;
  }

  // Esvazia a sacola (usado depois de finalizar o pedido).
  limpar() {
    this.#itens = [];
  }

  // ---------- localStorage ----------

  salvar() {
    try {
      localStorage.setItem(CHAVE_SACOLA, JSON.stringify(this.#itens));
    } catch (erro) {
      throw new ErroApp("sacola_nao_salva", "Não foi possível guardar a sacola neste navegador.", erro);
    }
  }

  // Método estático: não precisa de uma sacola pronta, ele devolve uma.
  // Se não houver nada guardado, ou o conteúdo estiver estragado, devolve uma sacola vazia.
  static carregar() {
    try {
      const itens = JSON.parse(localStorage.getItem(CHAVE_SACOLA));
      return new Sacola(Array.isArray(itens) ? itens : []);
    } catch (erro) {
      return new Sacola();
    }
  }

  // ---------- Apoio interno (privado) ----------

  #buscar(produtoId, tamanho) {
    return this.#itens.find((item) => item.produtoId === produtoId && item.tamanho === tamanho);
  }

  #buscarOuFalhar(produtoId, tamanho) {
    const item = this.#buscar(produtoId, tamanho);
    if (!item) {
      throw new ErroApp("item_nao_encontrado", "Este item não está na sacola.");
    }
    return item;
  }

  static #validarQuantidade(valor) {
    const quantidade = Number(valor);
    if (!Number.isInteger(quantidade) || quantidade < 1) {
      throw new ErroApp("quantidade_invalida", "A quantidade mínima é 1.");
    }
    return quantidade;
  }

  static #itemValido(item) {
    return (
      item !== null &&
      typeof item === "object" &&
      item.produtoId !== undefined &&
      item.lojaId !== undefined &&
      typeof item.nome === "string" &&
      typeof item.tamanho === "string" &&
      Number.isFinite(item.preco) &&
      item.preco > 0 &&
      Number.isInteger(item.quantidade) &&
      item.quantidade >= 1
    );
  }

  // Soma em centavos (números inteiros): somar decimais direto dá erros como 0.1 + 0.2 = 0.30000000000000004
  static #somar(itens) {
    const centavos = itens.reduce(
      (soma, item) => soma + Math.round(item.preco * 100) * item.quantidade,
      0
    );
    return centavos / 100;
  }
}
```


### Passo 2: o contador no cabeçalho (JavaScript e CSS)

Em `js/ui/cabecalho.js`, faça as trocas na ordem. (1) O começo do arquivo (comentário e importação da `Sacola`):

**Arquivo: `js/ui/cabecalho.js`**: substitua o trecho que começa na linha `// Gera o cabeçalho comum das páginas.` e termina na linha `// Cada página tem um <header id="cabecalho"> vazio, que este arquivo preenche.` (inclusive) por:

```js
// Gera o cabeçalho comum das páginas e mantém o contador de itens da sacola.
// Cada página tem um <header id="cabecalho"> vazio, que este arquivo preenche.
import { Sacola } from "../modelos/Sacola.js";
```


(2) O link da sacola passa a pedir o contador:

**Arquivo: `js/ui/cabecalho.js`**: substitua o trecho que começa na linha `// Links que todo mundo vê.` e termina na linha `{ texto: "Sacola", arquivo: "sacola.html" },` (inclusive) por:

```js
// Links que todo mundo vê. O contador só aparece no link da sacola.
const LINKS_FIXOS = [
  { texto: "Início", arquivo: "index.html" },
  { texto: "Catálogo", arquivo: "catalogo.html" },
  { texto: "Sacola", arquivo: "sacola.html", comContador: true },
```


(3) Cole a função que atualiza o contador **logo antes** de `criarLink`, e troque `criarLink` e `montarCabecalho`:

**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`atualizarContadorSacola`) logo antes da função `criarLink` (junto com os comentários que ficam acima dela):

```js
// Atualiza o número no cabeçalho; as outras partes do site chamam isto depois de mudar a sacola.
export function atualizarContadorSacola() {
  // Sacola.carregar() devolve uma sacola vazia se o localStorage estiver bloqueado ou estragado
  const total = Sacola.carregar().quantidadeTotal();
  const numero = document.getElementById("contador-sacola");
  const aviso = document.getElementById("contador-sacola-texto");

  if (!numero || !aviso) {
    return;
  }

  numero.textContent = String(total);
  numero.hidden = total === 0;
  aviso.hidden = total === 0;
}
```


**Arquivo: `js/ui/cabecalho.js`**: substitua a função `criarLink` inteira (do comentário acima dela até a chave que a fecha) por:

```js
function criarLink(link, arquivoAtual) {
  const item = document.createElement("li");
  const a = document.createElement("a");
  a.href = link.arquivo;
  a.append(link.texto);

  // Marca a página atual para o estilo e para leitores de tela
  if (link.arquivo === arquivoAtual) {
    a.setAttribute("aria-current", "page");
  }

  if (link.comContador) {
    const numero = document.createElement("span");
    numero.id = "contador-sacola";
    numero.className = "contador-sacola";
    numero.hidden = true;

    // Texto só para leitor de tela, para o número não ficar solto
    const texto = document.createElement("span");
    texto.id = "contador-sacola-texto";
    texto.className = "visualmente-oculto";
    texto.textContent = " itens na sacola";
    texto.hidden = true;

    a.append(numero, texto);
  }

  item.append(a);
  return item;
}
```


**Arquivo: `js/ui/cabecalho.js`**: substitua a função `montarCabecalho` inteira (do comentário acima dela até a chave que a fecha) por:

```js
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

  atualizarContadorSacola();

  // Se a sacola mudar em outra aba, o contador acompanha
  window.addEventListener("storage", atualizarContadorSacola);
}
```


No `css/componentes.css`, cole a seção do contador **logo antes do comentário** `/* ---------- Erro ao lado de um campo de formulário ---------- */`:

**Arquivo: `css/componentes.css`**: adicione estas seções logo antes do comentário `/* ---------- Erro ao lado de um campo de formulário ---------- */`:

```css
/* ---------- Contador de itens da sacola (no cabeçalho) ---------- */
.contador-sacola {
  display: inline-block;
  min-width: 1.5rem;
  margin-left: var(--espaco-1);
  padding: 0 var(--espaco-2);
  font-size: var(--tamanho-pequeno);
  line-height: 1.5rem;
  text-align: center;
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
  border-radius: var(--raio-pilula);
}
```


### Passo 3: o botão "Adicionar à sacola" funciona

No `js/paginas/produto.js`, faça as trocas. (1) O comentário do começo do arquivo:

**Arquivo: `js/paginas/produto.js`**: substitua o começo do arquivo, até a linha `// O botão "Adicionar à sacola" ainda não grava nada: a sacola chega na Aula 35.` (inclusive) por:

```js
// Página pública do produto (produto.html?id=...): galeria, preço, loja, tamanhos e "Adicionar à sacola" (RF-08, RF-09, RN-03).
// A sacola aceita peças de qualquer loja: nada é perguntado ao adicionar uma peça de outra loja.
```


(2) As importações:

**Arquivo: `js/paginas/produto.js`**: substitua a linha `import { montarCabecalho } from "../ui/cabecalho.js";` por:

```js
import { montarCabecalho, atualizarContadorSacola } from "../ui/cabecalho.js";
```


**Arquivo: `js/paginas/produto.js`**: substitua a linha `import { Produto } from "../modelos/Produto.js";` por:

```js
import { Produto } from "../modelos/Produto.js";
import { Sacola } from "../modelos/Sacola.js";
```


(3) No final do `submit`, a mensagem de teste dá lugar à gravação na sacola:

**Arquivo: `js/paginas/produto.js`**: substitua o trecho que começa na linha `// A sacola chega na próxima aula; por enquanto só confirmamos o que foi escolhido` e termina na linha `mostrarInfo("Você escolheu o tamanho " + escolhido.value + ", quantidade " + quantidade + ". A sacola chega na próxima aula.");` (inclusive) por:

```js
  try {
    // A sacola vem do navegador, recebe a peça (de qualquer loja, RN-03) e é guardada de novo
    const sacola = Sacola.carregar();
    sacola.adicionar(produto, escolhido.value, quantidade);
    sacola.salvar();

    atualizarContadorSacola();
    atalhoSacola.hidden = false;
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
```


### Passo 4: a página da sacola

Substitua **todo o conteúdo** do `sacola.html` (a lista de peças agora é desenhada pelo JavaScript):

**Arquivo: `sacola.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sacola – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <div class="sacola-layout">
      <h1 id="titulo-sacola" tabindex="-1">Sacola</h1>
      <p class="visualmente-oculto" id="anuncio-sacola" role="status" aria-live="polite"></p>

      <!-- A sacola em si: itens por loja, total e o botão de finalizar -->
      <section id="sacola-conteudo" aria-label="Itens da sacola">
        <p class="texto-suave" id="explicacao-sacola">Cada loja recebe um pedido separado. O combinado de pagamento e entrega é feito pelo WhatsApp da loja.</p>
        <div id="grupos-sacola"></div>

        <p class="aviso aviso-info" id="sacola-vazia" role="status" hidden>Sua sacola está vazia. <a href="catalogo.html">Ver o catálogo</a></p>

        <div id="rodape-sacola" hidden>
          <p class="sacola-total" id="total-sacola"></p>
          <button type="button" class="botao botao-largo" id="botao-finalizar">Finalizar sacola</button>
        </div>
      </section>

      <!-- Depois de finalizar, esta seção aparece no lugar da sacola -->
      <section id="confirmacao" aria-label="Pedidos enviados" hidden>
        <p class="aviso aviso-sucesso" role="status">Pedidos gravados! Agora envie o resumo de cada um pelo WhatsApp da loja, para combinar pagamento e entrega.</p>
        <div id="cartoes-pedidos"></div>
        <p class="acoes-formulario">
          <a class="botao botao-secundario" href="meus-pedidos.html">Acompanhar em Meus pedidos</a>
          <a class="botao botao-secundario" href="catalogo.html">Voltar ao catálogo</a>
        </p>
      </section>
    </div>
  </main>

  <footer class="rodape">
    <div class="container">
      <ul class="rodape-links">
        <li><a href="privacidade.html">Aviso de privacidade</a></li>
        <li><a href="meus-pedidos.html">Meus pedidos</a></li>
        <li><a href="painel-loja.html">Painel da loja</a></li>
      </ul>
      <p>Projeto integrador – Jovem Programadora (Senac). Pagamento e entrega são combinados direto com a loja.</p>
    </div>
  </footer>

  <script type="module" src="js/paginas/sacola.js"></script>
</body>
</html>
```


Crie `js/paginas/sacola.js`:

**Arquivo: `js/paginas/sacola.js`** (arquivo novo, inteiro)

```js
// Página da sacola: itens por loja, quantidades e total (RF-09, RN-02, RN-03).
// A sacola fica no navegador (localStorage). A finalização do pedido entra na Aula 36.
import { montarCabecalho, atualizarContadorSacola } from "../ui/cabecalho.js";
import { mostrarErro, mostrarInfo, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { formatarPreco } from "../ui/formatadores.js";
import { Sacola } from "../modelos/Sacola.js";
import { criarElemento } from "../ui/elementos.js";

const anuncio = document.getElementById("anuncio-sacola");
const explicacao = document.getElementById("explicacao-sacola");
const blocoDosGrupos = document.getElementById("grupos-sacola");
const mensagemVazia = document.getElementById("sacola-vazia");
const rodape = document.getElementById("rodape-sacola");
const textoDoTotal = document.getElementById("total-sacola");
const botaoFinalizar = document.getElementById("botao-finalizar");

let sacola = Sacola.carregar();
let enviando = false;
let contadorDeCampos = 0; // só para dar um id único a cada campo de quantidade

function anunciar(texto) {
  anuncio.textContent = texto;
}

// Texto só para leitor de tela: diz de qual peça é o botão ("Remover (Vestido midi, tamanho M)")
function criarTextoOculto(item) {
  return criarElemento("span", "visualmente-oculto", " (" + item.nome + ", tamanho " + item.tamanho + ")");
}

// ---------- Sacola na tela ----------

function textoDoBotaoFinalizar(totalDePedidos) {
  return "Finalizar sacola (" + totalDePedidos + (totalDePedidos === 1 ? " pedido" : " pedidos") + ")";
}

// Atualiza só os números (subtotais e total), sem redesenhar a lista: assim o foco do teclado não se perde
function atualizarTotais() {
  const grupos = sacola.itensPorLoja();

  grupos.forEach((grupo) => {
    const subtotal = document.getElementById("subtotal-" + grupo.lojaId);
    if (subtotal) {
      subtotal.textContent = "Subtotal da loja: " + formatarPreco(grupo.subtotal);
    }
  });

  textoDoTotal.textContent = "Total: " + formatarPreco(sacola.total());
  if (!enviando) {
    botaoFinalizar.textContent = textoDoBotaoFinalizar(grupos.length);
  }
}

function alterarQuantidade(item, entrada) {
  limparAvisos();
  try {
    sacola.alterarQuantidade(item.produtoId, item.tamanho, entrada.value);
    sacola.salvar();
    atualizarContadorSacola();
    atualizarTotais();
    anunciar("Quantidade atualizada. Total: " + formatarPreco(sacola.total()) + ".");
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    // Volta o campo para a quantidade que vale (a mínima é 1, RN-02)
    const atual = sacola.itens.find((outro) => outro.produtoId === item.produtoId && outro.tamanho === item.tamanho);
    entrada.value = atual ? atual.quantidade : 1;
  }
}

function remover(item) {
  limparAvisos();
  try {
    sacola.remover(item.produtoId, item.tamanho);
    sacola.salvar();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    return;
  }

  atualizarContadorSacola();
  desenhar();
  anunciar("Item removido. Total: " + formatarPreco(sacola.total()) + ".");

  // O foco não pode se perder: vai para o próximo "Remover", ou para o link do catálogo se a sacola ficou vazia
  const proximo = blocoDosGrupos.querySelector("button");
  (proximo ?? mensagemVazia.querySelector("a")).focus();
}

function criarItem(item) {
  contadorDeCampos += 1;
  const idDaQuantidade = "quantidade-" + contadorDeCampos;

  const linha = criarElemento("li", "sacola-item");

  const imagem = criarElemento("img");
  imagem.src = item.foto;
  imagem.alt = "Foto de " + item.nome;
  imagem.width = 600;
  imagem.height = 750;

  const corpo = criarElemento("div");
  corpo.append(
    criarElemento("p", "sacola-item-nome", item.nome + " – tamanho " + item.tamanho),
    criarElemento("p", "", formatarPreco(item.preco) + " cada")
  );

  const controles = criarElemento("div", "sacola-item-controles");
  const rotulo = criarElemento("label", "", "Quantidade");
  rotulo.htmlFor = idDaQuantidade;
  rotulo.append(criarTextoOculto(item));

  const entrada = criarElemento("input");
  entrada.id = idDaQuantidade;
  entrada.type = "number";
  entrada.min = "1";
  entrada.step = "1";
  entrada.value = item.quantidade;
  entrada.addEventListener("change", () => alterarQuantidade(item, entrada));

  const botaoRemover = criarElemento("button", "botao botao-perigo botao-pequeno", "Remover");
  botaoRemover.type = "button";
  botaoRemover.append(criarTextoOculto(item));
  botaoRemover.addEventListener("click", () => remover(item));

  controles.append(rotulo, entrada, botaoRemover);
  corpo.append(controles);
  linha.append(imagem, corpo);
  return linha;
}

// Um bloco por loja (RN-03): nome da loja (com link), itens e subtotal
function criarGrupo(grupo) {
  const secao = criarElemento("section", "sacola-loja");
  secao.setAttribute("aria-labelledby", "loja-" + grupo.lojaId);

  const cabecalho = criarElemento("h2");
  cabecalho.id = "loja-" + grupo.lojaId;
  const link = criarElemento("a", "", grupo.lojaNome);
  link.href = "loja.html?id=" + encodeURIComponent(grupo.lojaId);
  cabecalho.append(link);

  const lista = criarElemento("ul", "sacola-itens");
  lista.append(...grupo.itens.map(criarItem));

  const subtotal = criarElemento("p", "sacola-subtotal");
  subtotal.id = "subtotal-" + grupo.lojaId;

  secao.append(cabecalho, lista, subtotal);
  return secao;
}

function desenhar() {
  const grupos = sacola.itensPorLoja();
  blocoDosGrupos.replaceChildren(...grupos.map(criarGrupo));

  const vazia = grupos.length === 0;
  mensagemVazia.hidden = !vazia;
  rodape.hidden = vazia;
  explicacao.hidden = vazia;
  atualizarTotais();
}

// A finalização do pedido entra na Aula 36
botaoFinalizar.addEventListener("click", () => mostrarInfo("Finalizar a sacola chega na próxima aula."));

montarCabecalho();
desenhar();
```


### Passo 5: teste a sacola (CT-04 e CT-05)

1. Abra um produto da **Loja Exemplo**, escolha um tamanho e clique em **Adicionar à sacola**: aparece **Peça adicionada à sacola. Ver sacola ou continuar comprando.** e o **contador** no menu passa a mostrar `1`.
2. Abra um produto da **Loja do Bairro** (ou de outra loja cadastrada por você em **Minha loja**: faça duas lojas de teste, se preciso) e adicione. O site **não pergunta nada** ao misturar as lojas (**CT-04**).
3. Abra **Sacola**: os itens aparecem **agrupados por loja**, cada bloco com o **subtotal da loja** e, no fim, o **Total**. O botão diz **Finalizar sacola (2 pedidos)**. (Se as duas peças forem da mesma loja, será `1 pedido`.)
4. Mude a **Quantidade** de um item para `3`: subtotal e total se atualizam sem a página recarregar. Digite `0`: aparece o erro **A quantidade mínima é 1.** e o campo volta ao valor anterior.
5. Clique em **Remover**: o item some, o contador do cabeçalho diminui e o foco vai para o próximo botão. Remova todos: aparece **Sua sacola está vazia. Ver o catálogo.**
6. Adicione de novo **o mesmo produto no mesmo tamanho** duas vezes: vira uma linha só com a quantidade `2`.
7. **Recarregue a página** (F5) com itens na sacola: os itens, os subtotais e o total **continuam** iguais (**CT-05**). Abra outra página: o contador continua.
8. Na aba **Application** (em português: **Aplicativo**) do F12, abra **Local Storage** (em português: **Armazenamento local**): existe a chave `sacola` com o texto JSON dos itens.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria a sacola no localStorage, agrupada por loja, com contador no cabeçalho"
git push
```

## Explicação do Código

**Sacola.js**

- `CHAVE_SACOLA = "sacola"`: o nome da "gaveta" do `localStorage`, exportado para o resto do código.
- `#itens`: campo **privado** com a lista de itens `{ produtoId, nome, preco, tamanho, quantidade, lojaId, lojaNome, foto }`. Cada item guarda uma **cópia dos dados** do produto (nome, preço, loja), para a sacola ser mostrada sem consultar o banco.
- O construtor recebe uma lista e **descarta** itens com formato estranho (`#itemValido`): protege contra um `localStorage` antigo ou mexido à mão.
- `get itens()` devolve uma **cópia** (ninguém de fora altera a lista sem passar pelas regras). `estaVazia()`, `quantidadeTotal()` (o número do cabeçalho) e `total()` (soma em centavos, `#somar`).
- `itensPorLoja()`: percorre os itens e usa um `Map` para agrupar por `lojaId`; devolve uma lista de grupos `{ lojaId, lojaNome, itens, subtotal }`, na ordem em que cada loja apareceu. Cada grupo será um pedido (RN-03).
- `adicionar(produto, tamanho, quantidade)`: confere que é um `Produto`, valida a quantidade (inteira e maior ou igual a 1: `#validarQuantidade`) e que o tamanho tem estoque (`temEstoque`, RF-08). Se o mesmo produto no mesmo tamanho já está na sacola, **soma** a quantidade; senão, acrescenta uma linha.
- `alterarQuantidade` e `remover`: acham o item (`#buscarOuFalhar`, que lança `ErroApp` se não existir) e mudam a lista. `atualizarPrecos` (usada na Aula 36) troca os preços pelos atuais e devolve o que mudou. `limpar()` esvazia.
- `salvar()`: `localStorage.setItem(CHAVE_SACOLA, JSON.stringify(this.#itens))`, dentro de `try/catch` (se o navegador bloquear o armazenamento, lança `ErroApp`).
- `static carregar()`: método **da classe**: `JSON.parse(localStorage.getItem(...))` e devolve uma `Sacola`; se não houver nada guardado, ou o texto estiver estragado, devolve uma sacola **vazia** (nunca quebra a página).

**cabecalho.js**

- `atualizarContadorSacola()`: `Sacola.carregar().quantidadeTotal()` e escreve o número no `<span id="contador-sacola">`, escondendo-o (`hidden`) quando for zero. Há também um texto escondido (`visualmente-oculto`) dizendo " itens na sacola" para o leitor de tela. As outras páginas chamam esta função depois de mudar a sacola.
- `criarLink` ganhou o bloco `if (link.comContador)`, que cria os dois `<span>` do contador. `montarCabecalho` chama `atualizarContadorSacola()` e escuta o evento `storage` (disparado quando **outra aba** muda o `localStorage`), para o contador acompanhar.

**produto.js**: ao enviar, `Sacola.carregar()` → `sacola.adicionar(produto, escolhido.value, quantidade)` → `sacola.salvar()` → `atualizarContadorSacola()` e mostra o atalho "Ver sacola" (`atalhoSacola.hidden = false`). Erros (tamanho sem estoque etc.) viram `mostrarErro(mensagemDoErro(erro))`.

**sacola.js**

- `desenhar()` monta um bloco por loja (`criarGrupo`: título com link para a loja, lista de itens e subtotal) e mostra ou esconde a mensagem de sacola vazia e o rodapé com o total.
- `criarItem`: foto, nome com tamanho, preço unitário, o campo **Quantidade** (com `label` ligado por um `id` único) e o botão **Remover**, com texto escondido dizendo de qual peça é.
- `alterarQuantidade` e `remover`: mudam a `sacola`, salvam, atualizam o contador e os totais. `atualizarTotais()` muda só os textos (sem redesenhar a lista), para o foco do teclado não se perder; `anunciar()` escreve em uma região `aria-live` ("Quantidade atualizada. Total: R$ 289,80.").

## Validação

1. Peças de duas lojas ficam na mesma sacola, agrupadas por loja, com subtotal de cada uma e total (CT-04).
2. Recarregar a página mantém os itens, subtotais e total (CT-05).
3. O contador do cabeçalho acompanha: soma ao adicionar, diminui ao remover, some em zero.
4. Quantidade `0` mostra o erro e volta ao valor anterior; o mesmo produto e tamanho vira uma linha só.
5. Na aba **Application** (em português: **Aplicativo**) existe a chave `sacola` no `localStorage`.

**Erros comuns**

1. *Sintoma:* a sacola esvazia a cada recarregamento. *Causa:* esqueceu o `sacola.salvar()` depois de mudar. *Correção:* toda alteração termina com `sacola.salvar()`.
2. *Sintoma:* o contador do cabeçalho não aparece. *Causa:* o link da sacola não tem `comContador: true` ou o CSS do contador não foi colado. *Correção:* confira o Passo 2.
3. *Mensagem:* `Este tamanho está sem estoque.` ao adicionar. *Causa:* o tamanho escolhido tem estoque zero. *Correção:* escolha um tamanho com estoque.
4. *Mensagem:* `Cannot read properties of null (reading 'hidden')` em `sacola.js`. *Causa:* o `sacola.html` é o antigo, sem os `id` novos. *Correção:* substitua o conteúdo pelo `sacola.html` do Passo 4.

**Se travar**

1. No F12 > **Application** (em português: **Aplicativo**) > **Local Storage**, veja o texto guardado; se estiver estragado, clique com o botão direito na chave `sacola` e apague (**Delete**, em português: **Excluir**).
2. Veja o Console para a primeira mensagem de erro.
3. Compare `Sacola.js` e `sacola.js` com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/modelos/Sacola.js`, `sacola.html` e `js/paginas/sacola.js` (itens por loja, quantidades, totais).
- O contador de itens da sacola no cabeçalho de todas as páginas, e o botão **Adicionar à sacola** funcionando.
- O botão **Finalizar sacola** ainda não faz nada (próxima aula).

**Como saber que deu certo:** você adiciona peças de duas lojas, recarrega a página e a sacola mostra os dois blocos com subtotal e total, com o contador no cabeçalho.
