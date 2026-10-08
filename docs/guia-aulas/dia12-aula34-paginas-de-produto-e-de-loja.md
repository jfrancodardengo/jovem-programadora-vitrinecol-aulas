# Aula 34 – Páginas de produto e de loja, com parâmetros na URL

**Dia 12 · Qui 22/10/2026** · **Aula 34** · **UC3**

- **Requisitos cobertos:** RF-06 (página da loja com nome, descrição, endereço, WhatsApp e produtos; id inexistente mostra "Loja não encontrada"), RF-07 (botão com o link do mapa), RF-08 (página do produto com galeria de fotos, tamanhos e quantidade), RN-02 (quantidade mínima 1), RN-08 (produto inativo não aparece) e RN-10 (WhatsApp com dígitos e código do país, link https://wa.me/número?text=mensagem)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catálogo com filtros e paginação; produtoServico.js e lojaServico.js com as consultas de listagem; produto.html e loja.html estáticos (Aulas 9 e 30 a 33)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer as páginas **produto** e **loja** funcionarem com dados do banco, lendo o **`id` da URL** (`produto.html?id=...`, `loja.html?id=...`): galeria de fotos com miniaturas (também pelo **teclado**), tamanho sem estoque desabilitado, escolha de quantidade, e a loja com endereço, **WhatsApp**, botão do **mapa** e produtos.

**Abertura (10 minutos).** Retomada da Aula 33: os cards do catálogo já levam a `produto.html?id=...`, mas a página do produto ainda mostra o texto de exemplo da Aula 9. Abra um card do catálogo e olhe a barra de endereço: o `?id=...` é o **código do produto**. Hoje a página usa esse código para buscar o produto certo.

## O Conceito

**Termos desta aula**

- **Parâmetro na URL (query string)**: a parte do endereço depois do `?`, como em `produto.html?id=3f2b...`. Serve para passar uma informação de uma página para outra.
- **`URLSearchParams`**: ferramenta do JavaScript que lê esses parâmetros: `new URLSearchParams(location.search).get("id")`.
- **Galeria acessível**: uma foto grande e miniaturas que são **botões** (`<button>`), então o teclado (Tab, Enter, espaço) funciona sem código extra.
- **Link do WhatsApp (`wa.me`)**: o endereço `https://wa.me/5527999999999?text=Ola` abre uma conversa com aquele número e a mensagem pronta. O número tem **só dígitos**, com o código do país (RN-10). O texto vai **codificado** (`encodeURIComponent`: espaços e acentos viram `%20`, `%C3%A7`...).

**Analogia:** o `?id=...` é o **número da senha** que a cliente leva de uma guichê (o catálogo) para outro (a página do produto). Quem atende lê o número e busca a ficha certa.

**Regras:** produto inativo **não** abre (RN-08); um `id` que não existe ou que nem é um código válido mostra **"Produto não encontrado"** ou **"Loja não encontrada"**, e nunca uma tela em branco (RF-21).

## Mão na Massa

### Passo 1: as consultas de um produto e de uma loja

Em `js/servicos/produtoServico.js`, cole a função `obterProduto` **logo antes do bloco de comentário** que começa com `// ====...` (o do "Painel da lojista"):

**Arquivo: `js/servicos/produtoServico.js`**: adicione este trecho logo antes da linha `// =====================================================================`:

```js
// Página do produto (RF-08): um produto ativo, com TODOS os tamanhos e TODAS as fotos, em ordem.
// Se não existir, ou estiver inativo, lança ErroApp "produto_nao_encontrado".
export async function obterProduto(id) {
  try {
    const supabase = exigirSupabase();

    const { data, error } = await supabase
      .from("produtos")
      .select(CAMPOS_DO_PRODUTO + ", tamanhos ( tamanho, estoque ), " + CAMPOS_DAS_FOTOS)
      .eq("id", id)
      .eq("ativo", true)
      .order("ordem", { referencedTable: "produto_fotos", ascending: true })
      // maybeSingle: devolve um objeto, ou null se não achar (em vez de dar erro)
      .maybeSingle();

    // 22P02 = "isso não é um uuid": um endereço como produto.html?id=abc também é "não encontrado"
    if (error && error.code !== "22P02") {
      throw error;
    }
    if (error || !data) {
      throw new ErroApp("produto_nao_encontrado", "Produto não encontrado.");
    }
    return data;
  } catch (erro) {
    throw erro instanceof ErroApp
      ? erro
      : new ErroApp(
          "erro_ao_obter_produto",
          "Não foi possível carregar o produto. Verifique sua conexão e tente novamente.",
          erro
        );
  }
}

```


Em `js/servicos/lojaServico.js`, cole as funções públicas da loja **logo antes** do comentário `// ---------- Painel da lojista ----------`:

**Arquivo: `js/servicos/lojaServico.js`**: adicione este trecho logo antes da linha `// ---------- Painel da lojista ----------`:

```js
// ---------- Páginas públicas ----------

// Traz uma loja pelo id, para a página da loja (RF-06). Id que não existe (ou que nem é um uuid) vira "Loja não encontrada".
export async function obterLoja(id) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("lojas").select(CAMPOS_DA_LOJA).eq("id", id).maybeSingle();

    // 22P02 = "isso não é um uuid": um endereço como loja.html?id=abc também é "não encontrada"
    if (error && error.code !== "22P02") {
      throw error;
    }
    if (error || !data) {
      throw new ErroApp("loja_nao_encontrada", "Loja não encontrada.");
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar a loja. Verifique sua conexão e tente novamente.");
  }
}

```


### Passo 2: o link do WhatsApp

Em `js/ui/formatadores.js`, cole **no final do arquivo**:

**Arquivo: `js/ui/formatadores.js`**: adicione esta função (`criarLinkDoWhatsapp`) no final do arquivo:

```js
// Monta o link do WhatsApp (RN-10): https://wa.me/<número>?text=<mensagem codificada>.
// O número deve ter só dígitos, com código do país e DDD (12 ou 13 dígitos); senão devolve null (loja sem WhatsApp válido).
// encodeURIComponent transforma espaços, acentos e quebras de linha em %XX, para a mensagem caber no endereço.
export function criarLinkDoWhatsapp(numero, mensagem) {
  const digitos = String(numero ?? "");
  if (!telefoneValido(digitos)) {
    return null;
  }
  return "https://wa.me/" + digitos + "?text=" + encodeURIComponent(mensagem);
}
```


### Passo 3: a página do produto

Substitua **todo o conteúdo** do `produto.html`:

**Arquivo: `produto.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Produto – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <h1 id="titulo-produto">Produto</h1>

    <article class="produto-detalhe" id="produto-detalhe" hidden>
      <section aria-label="Fotos do produto">
        <img class="galeria-principal" id="foto-principal" src="imagens/sem-foto.svg" alt="Foto do produto" width="600" height="750">
        <ul class="galeria-miniaturas" id="miniaturas" hidden></ul>
      </section>

      <section class="produto-info" aria-label="Informações do produto">
        <p class="preco" id="preco-produto"></p>
        <p>Vendido por <a id="link-loja" href="loja.html"></a></p>
        <p id="descricao-produto" hidden></p>

        <form class="produto-compra" id="formulario-compra" novalidate aria-label="Adicionar à sacola">
          <fieldset class="campo" id="campo-tamanho">
            <legend>Tamanho</legend>
            <div class="tamanhos" id="tamanhos"></div>
            <p class="campo-ajuda">Tamanhos riscados estão sem estoque.</p>
          </fieldset>

          <div class="campo">
            <label for="quantidade">Quantidade</label>
            <input type="number" id="quantidade" name="quantidade" min="1" step="1" value="1">
          </div>

          <button type="submit" class="botao" id="botao-adicionar">Adicionar à sacola</button>

          <p class="aviso aviso-sucesso" id="atalho-sacola" role="status" hidden>
            Peça adicionada à sacola. <a href="sacola.html">Ver sacola</a> ou <a href="catalogo.html">continuar comprando</a>.
          </p>
        </form>
      </section>
    </article>

    <p id="voltar-catalogo" hidden><a href="catalogo.html">Voltar ao catálogo</a></p>
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

  <script type="module" src="js/paginas/produto.js"></script>
</body>
</html>
```


Crie `js/paginas/produto.js`:

**Arquivo: `js/paginas/produto.js`** (arquivo novo, inteiro)

```js
// Página pública do produto (produto.html?id=...): galeria, preço, loja, tamanhos e quantidade (RF-08, RN-02, RN-08).
// O botão "Adicionar à sacola" ainda não grava nada: a sacola chega na Aula 35.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarInfo, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Produto } from "../modelos/Produto.js";
import { obterProduto } from "../servicos/produtoServico.js";

const titulo = document.getElementById("titulo-produto");
const detalhe = document.getElementById("produto-detalhe");
const fotoPrincipal = document.getElementById("foto-principal");
const listaMiniaturas = document.getElementById("miniaturas");
const precoProduto = document.getElementById("preco-produto");
const linkLoja = document.getElementById("link-loja");
const descricao = document.getElementById("descricao-produto");
const formulario = document.getElementById("formulario-compra");
const blocoTamanhos = document.getElementById("tamanhos");
const campoQuantidade = document.getElementById("quantidade");
const botaoAdicionar = document.getElementById("botao-adicionar");
const atalhoSacola = document.getElementById("atalho-sacola");
const voltarAoCatalogo = document.getElementById("voltar-catalogo");

let produto = null;

// ---------- Galeria de fotos ----------

// Mostra a foto de posição "indice" (0 é a capa) como foto grande e marca a miniatura correspondente
function mostrarFoto(indice) {
  const fotos = produto.fotos;
  fotoPrincipal.src = fotos[indice];
  fotoPrincipal.alt = "Foto " + (indice + 1) + " de " + fotos.length + ": " + produto.nome;

  listaMiniaturas.querySelectorAll(".miniatura").forEach((botao, posicao) => {
    botao.setAttribute("aria-current", String(posicao === indice));
  });
}

function criarMiniatura(url, indice, total) {
  const item = document.createElement("li");

  // Cada miniatura é um <button>: o teclado (Tab, Enter e espaço) funciona sem nenhum código extra
  const botao = document.createElement("button");
  botao.type = "button";
  botao.className = "miniatura";

  const imagem = document.createElement("img");
  imagem.src = url;
  imagem.alt = "Ver a foto " + (indice + 1) + " de " + total;
  imagem.width = 600;
  imagem.height = 750;

  botao.append(imagem);
  botao.addEventListener("click", () => mostrarFoto(indice));
  item.append(botao);
  return item;
}

function montarGaleria() {
  const fotos = produto.fotos;

  if (fotos.length === 0) {
    // Sem foto: imagem padrão e nenhuma miniatura (RN-12)
    fotoPrincipal.src = produto.fotoCapa();
    fotoPrincipal.alt = "Produto sem foto: " + produto.nome;
    return;
  }

  mostrarFoto(0);

  // Com uma foto só, não há o que escolher: sem miniaturas
  if (fotos.length > 1) {
    listaMiniaturas.replaceChildren(...fotos.map((url, indice) => criarMiniatura(url, indice, fotos.length)));
    listaMiniaturas.hidden = false;
    mostrarFoto(0); // marca a primeira miniatura
  }
}

// ---------- Tamanhos ----------

// Um botão de rádio por tamanho. Tamanho sem estoque fica desabilitado (RF-08).
function montarTamanhos() {
  const opcoes = produto.tamanhos.map((item, indice) => {
    const rotulo = document.createElement("label");
    rotulo.className = "tamanho-opcao";

    const entrada = document.createElement("input");
    entrada.type = "radio";
    entrada.name = "tamanho";
    entrada.id = "tamanho-" + indice;
    entrada.value = item.tamanho;

    const esgotado = !produto.temEstoque(item.tamanho);
    entrada.disabled = esgotado;
    // O texto do rótulo é só o tamanho; o aria-label completa a informação para o leitor de tela
    entrada.setAttribute("aria-label", item.tamanho + (esgotado ? ", sem estoque" : ""));

    const texto = document.createElement("span");
    texto.textContent = item.tamanho;

    rotulo.append(entrada, texto);
    return rotulo;
  });

  blocoTamanhos.replaceChildren(...opcoes);
}

// ---------- Tela ----------

function mostrarProduto() {
  titulo.textContent = produto.nome; // textContent: o nome vem do banco
  document.title = produto.nome + " – VitrineCol";
  precoProduto.textContent = produto.precoFormatado();

  linkLoja.textContent = produto.lojaNome;
  linkLoja.href = "loja.html?id=" + encodeURIComponent(produto.lojaId);

  if (produto.descricao) {
    descricao.textContent = produto.descricao;
    descricao.hidden = false;
  }

  montarGaleria();
  montarTamanhos();

  // Produto sem nenhum tamanho em estoque: nada para comprar
  const temAlgumTamanho = produto.tamanhos.some((item) => produto.temEstoque(item.tamanho));
  if (!temAlgumTamanho) {
    mostrarInfo("Este produto está sem estoque no momento.");
    botaoAdicionar.disabled = true;
    campoQuantidade.disabled = true;
  }

  detalhe.hidden = false;
}

// ---------- Adicionar à sacola ----------

formulario.addEventListener("submit", (evento) => {
  // Sem isto o navegador recarregaria a página
  evento.preventDefault();

  limparErrosDosCampos(formulario);
  limparAvisos();
  atalhoSacola.hidden = true;

  const escolhido = formulario.querySelector('input[name="tamanho"]:checked');
  if (!escolhido) {
    const primeiroDisponivel = formulario.querySelector('input[name="tamanho"]:not(:disabled)');
    mostrarErroDoCampo(primeiroDisponivel, "Escolha um tamanho.");
    primeiroDisponivel.focus();
    return;
  }

  const quantidade = Number(campoQuantidade.value);
  if (!Number.isInteger(quantidade) || quantidade < 1) {
    mostrarErroDoCampo(campoQuantidade, "A quantidade mínima é 1.");
    campoQuantidade.focus();
    return;
  }

  // A sacola chega na próxima aula; por enquanto só confirmamos o que foi escolhido
  mostrarInfo("Você escolheu o tamanho " + escolhido.value + ", quantidade " + quantidade + ". A sacola chega na próxima aula.");
});

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  try {
    const id = new URLSearchParams(location.search).get("id");
    if (!id) {
      throw new ErroApp("produto_nao_encontrado", "Produto não encontrado.");
    }

    produto = Produto.deLinha(await obterProduto(id));
    limparAvisos(); // tira o "Carregando…" ANTES de montar a página, que pode mostrar um aviso próprio (sem estoque)
    mostrarProduto();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    voltarAoCatalogo.hidden = false;
  }
}

iniciar();
```


### Passo 4: a página da loja

Substitua **todo o conteúdo** do `loja.html`:

**Arquivo: `loja.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Loja – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <h1 id="titulo-loja">Loja</h1>

    <section class="loja-resumo" id="resumo-loja" aria-label="Dados da loja" hidden>
      <div>
        <p id="descricao-loja" hidden></p>
        <dl class="loja-dados">
          <dt>Endereço</dt>
          <dd id="endereco-loja"></dd>
        </dl>
        <div class="loja-acoes">
          <a class="botao botao-whatsapp" id="botao-whatsapp" target="_blank" rel="noopener" hidden>Conversar no WhatsApp<span class="visualmente-oculto"> (abre em nova aba)</span></a>
          <a class="botao botao-secundario" id="botao-mapa" target="_blank" rel="noopener" hidden>Ver no mapa<span class="visualmente-oculto"> (abre em nova aba)</span></a>
        </div>
      </div>
    </section>

    <section aria-labelledby="titulo-produtos-loja" id="produtos-loja" hidden>
      <h2 id="titulo-produtos-loja">Produtos da loja</h2>
      <ul class="grade-produtos" id="lista-produtos"></ul>
      <p class="aviso aviso-info" id="mensagem-sem-produtos" role="status" hidden>Esta loja ainda não tem produtos.</p>
    </section>

    <p id="voltar-catalogo" hidden><a href="catalogo.html">Voltar ao catálogo</a></p>
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

  <script type="module" src="js/paginas/loja.js"></script>
</body>
</html>
```


Crie `js/paginas/loja.js`:

**Arquivo: `js/paginas/loja.js`** (arquivo novo, inteiro)

```js
// Página pública da loja (loja.html?id=...): dados da loja, WhatsApp, mapa e produtos ativos (RF-06, RF-07, RN-08).
// A página só chama os serviços e mostra o resultado e os avisos.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { criarCardProduto } from "../ui/cards.js";
import { criarLinkDoWhatsapp } from "../ui/formatadores.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Produto } from "../modelos/Produto.js";
import { obterLoja } from "../servicos/lojaServico.js";
import { listarProdutosAtivos } from "../servicos/produtoServico.js";

const titulo = document.getElementById("titulo-loja");
const resumo = document.getElementById("resumo-loja");
const descricao = document.getElementById("descricao-loja");
const endereco = document.getElementById("endereco-loja");
const botaoWhatsapp = document.getElementById("botao-whatsapp");
const botaoMapa = document.getElementById("botao-mapa");
const blocoDeProdutos = document.getElementById("produtos-loja");
const listaProdutos = document.getElementById("lista-produtos");
const mensagemSemProdutos = document.getElementById("mensagem-sem-produtos");
const voltarAoCatalogo = document.getElementById("voltar-catalogo");

// O link do mapa só vira botão se for http ou https (a loja já valida isso ao salvar; aqui é uma segunda defesa)
function linkDoMapaSeguro(texto) {
  try {
    const protocolo = new URL(texto).protocol;
    return protocolo === "http:" || protocolo === "https:" ? texto : null;
  } catch (erro) {
    return null;
  }
}

function mostrarDadosDaLoja(loja) {
  titulo.textContent = loja.nome; // textContent: o nome vem do banco
  document.title = loja.nome + " – VitrineCol";

  if (loja.descricao) {
    descricao.textContent = loja.descricao;
    descricao.hidden = false;
  }
  endereco.textContent = loja.endereco + ", " + loja.cidade;

  // WhatsApp (RN-10): só aparece se a loja tem um número válido
  const linkDoWhatsapp = criarLinkDoWhatsapp(loja.whatsapp, "Olá, " + loja.nome + "! Vi a sua loja na VitrineCol.");
  if (linkDoWhatsapp) {
    botaoWhatsapp.href = linkDoWhatsapp;
    botaoWhatsapp.hidden = false;
  }

  // RF-07: o botão do mapa só existe se a loja cadastrou o link; abre em nova aba (target + rel="noopener" no HTML)
  const linkDoMapa = loja.link_mapa ? linkDoMapaSeguro(loja.link_mapa) : null;
  if (linkDoMapa) {
    botaoMapa.href = linkDoMapa;
    botaoMapa.hidden = false;
  }

  resumo.hidden = false;
}

function mostrarProdutos(produtos) {
  listaProdutos.replaceChildren(...produtos.map(criarCardProduto));
  mensagemSemProdutos.hidden = produtos.length > 0;
  blocoDeProdutos.hidden = false;
}

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  try {
    const id = new URLSearchParams(location.search).get("id");
    if (!id) {
      throw new ErroApp("loja_nao_encontrada", "Loja não encontrada.");
    }

    const loja = await obterLoja(id);
    // Só os produtos ativos aparecem na página da loja (RN-08)
    const linhas = await listarProdutosAtivos({ lojaId: loja.id });

    mostrarDadosDaLoja(loja);
    mostrarProdutos(linhas.map(Produto.deLinha));
    limparAvisos();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    voltarAoCatalogo.hidden = false;
  }
}

iniciar();
```


### Passo 5: teste as duas páginas

1. No catálogo, clique em um card com **3 fotos** (o **Vestido midi floral**). A página mostra a foto grande, as 3 **miniaturas**, o preço, **Vendido por Loja Exemplo**, a descrição e os tamanhos. O tamanho **G** (estoque 0) aparece **riscado** e **não** pode ser escolhido.
2. Clique em uma miniatura: a foto grande troca. Use **Tab** até uma miniatura e **Enter**: também troca (galeria acessível). O título da aba do navegador passa a ser o nome do produto.
3. Clique em **Adicionar à sacola** sem escolher tamanho: **Escolha um tamanho.** ao lado dos tamanhos. Escolha **M**, coloque a quantidade `0`: **A quantidade mínima é 1.** (RN-02). Com `2`, aparece a mensagem de teste de que a sacola chega na próxima aula.
4. Abra `produto.html?id=abc` (um id inventado): aparece **Produto não encontrado.** e o link **Voltar ao catálogo**. Abra `produto.html` sem id: o mesmo.
5. No Supabase, desative um produto (ou use **Desativar** na lista Meus produtos) e abra o endereço dele: **Produto não encontrado.** (RN-08).
6. Clique em **Loja Exemplo**: a página da loja mostra nome, descrição, endereço, o botão **Conversar no WhatsApp**, o botão **Ver no mapa** (a loja de teste tem um link) e os produtos dela.
7. Clique em **Conversar no WhatsApp** (abre em nova aba): o endereço começa com `https://wa.me/5527999999999?text=...`. Em `loja.html?id=abc` aparece **Loja não encontrada.**
8. Na **Minha loja** (painel), apague o link do mapa, salve e recarregue a página pública da loja: o botão **Ver no mapa** **some** (RF-07).

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria as páginas do produto e da loja com parâmetros na URL"
git push
```

## Explicação do Código

**obterProduto(id)** (`produtoServico.js`)

- Busca **um** produto ativo (`.eq("id", id).eq("ativo", true)`) com **todos** os tamanhos e **todas** as fotos, ordenadas, e usa `.maybeSingle()` (devolve `null` se não achar). O erro `22P02` significa "isso não é um uuid" (um `?id=abc`): também vira **Produto não encontrado**. Qualquer outro erro vira uma mensagem de conexão.

**obterLoja(id)** (`lojaServico.js`): a mesma ideia para a loja. `listarContatosDasLojas` (para o WhatsApp da confirmação do pedido) entra na Aula 36.

**criarLinkDoWhatsapp(numero, mensagem)** (`formatadores.js`): confere o número com `telefoneValido` (se não for válido, devolve `null`: a loja não tem WhatsApp utilizável) e monta `"https://wa.me/" + digitos + "?text=" + encodeURIComponent(mensagem)`.

**produto.js**

- `iniciar()`: lê o `id` com `URLSearchParams`; sem `id`, lança `ErroApp("produto_nao_encontrado")`. Chama `obterProduto`, converte com `Produto.deLinha` e chama `mostrarProduto()`. O `catch` mostra a mensagem e o link **Voltar ao catálogo**.
- `mostrarProduto()`: usa `textContent` para título, preço, nome da loja e descrição (os textos vêm do banco), liga o link da loja (`loja.html?id=...`), monta a galeria e os tamanhos. Se nenhum tamanho tem estoque, mostra "Este produto está sem estoque no momento." e desabilita o botão e o campo de quantidade.
- `mostrarFoto(indice)`: troca `src` e `alt` da foto grande ("Foto 2 de 3: Vestido midi floral") e marca a miniatura atual com `aria-current`.
- `criarMiniatura`: cada miniatura é um `<button class="miniatura">` com a imagem dentro; `addEventListener("click", ...)` funciona com mouse **e** teclado (Enter/espaço), porque é um botão. Com uma foto só, **não há miniaturas**; sem foto, usa a imagem padrão (RN-12).
- `montarTamanhos()`: um `<input type="radio" name="tamanho">` por tamanho dentro de um `label.tamanho-opcao`. Se `!produto.temEstoque(tamanho)`, o radio recebe `disabled` e o `aria-label` diz "G, sem estoque".
- O `submit` valida o tamanho e a quantidade (`Number.isInteger` e `>= 1`), com `mostrarErroDoCampo` ao lado do campo (foco no campo com erro). **A gravação na sacola entra na Aula 35.**

**loja.js**

- `mostrarDadosDaLoja(loja)`: título, descrição (só se existir), endereço ("Rua..., Cidade"), botão do **WhatsApp** (só se `criarLinkDoWhatsapp` devolver um link) e botão do **mapa** (só se existir `link_mapa` **e** for `http`/`https`: `linkDoMapaSeguro` descarta, por exemplo, `javascript:...`). Tudo com `textContent` e `href` montados por código.
- `listarProdutosAtivos({ lojaId: loja.id })` traz só os produtos **ativos** da loja (RN-08), desenhados com `criarCardProduto`.

## Validação

1. A página do produto mostra galeria, preço, loja, descrição e tamanhos, com G riscado e não escolhível.
2. As miniaturas trocam a foto grande com o mouse e com o teclado (Tab + Enter).
3. Tamanho não escolhido e quantidade `0` mostram erro ao lado do campo.
4. `produto.html?id=abc` e `loja.html?id=abc` mostram "não encontrado", sem tela em branco.
5. A página da loja mostra o WhatsApp (link `wa.me`) e o mapa só quando existe link.

**Erros comuns**

1. *Sintoma:* a página do produto mostra "Produto não encontrado" para um produto que existe. *Causa:* o produto está inativo, ou o `id` na URL foi cortado. *Correção:* confira o `?id=` completo e se o produto está **Ativo** em Meus produtos.
2. *Sintoma:* o clique na miniatura não troca a foto. *Causa:* o produto tem só uma foto (não há miniaturas) ou o `addEventListener` não foi ligado. *Correção:* use um produto com 2 ou mais fotos e confira `criarMiniatura`.
3. *Sintoma:* o botão **WhatsApp** não aparece. *Causa:* a loja não tem WhatsApp válido (12 ou 13 dígitos). *Correção:* preencha o WhatsApp em **Minha loja**.
4. *Mensagem:* `Cannot read properties of null (reading 'hidden')`. *Causa:* um `id` do HTML é diferente do usado no JavaScript (por exemplo `produto-detalhe`). *Correção:* use o `produto.html` e o `loja.html` exatos da aula.

**Se travar**

1. No Console (F12) veja o primeiro erro; na aba **Network** (em português: **Rede**) veja se a consulta ao banco falhou.
2. Para depurar, escreva `console.log(produto)` depois de `Produto.deLinha(...)`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `produto.html` + `produto.js` e `loja.html` + `loja.js` dinâmicos; `obterProduto` e `obterLoja` nos serviços; `criarLinkDoWhatsapp` nos formatadores.
- O catálogo, a loja e o produto ligados pelos links com `?id=`.

**Como saber que deu certo:** você abre um produto pelo card, troca de foto pelo teclado, e a página mostra "Produto não encontrado" quando o código do endereço está errado.
