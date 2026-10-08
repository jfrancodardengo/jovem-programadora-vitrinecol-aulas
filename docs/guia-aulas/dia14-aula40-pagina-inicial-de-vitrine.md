# Aula 40 – Página inicial de vitrine

**Dia 14 · Seg 26/10/2026** · **Aula 40** · **UC3**

- **Requisitos cobertos:** RF-23 (página inicial de vitrine: hero com chamada e busca, carrossel com as peças mais recentes, tipos de roupa, produtos em destaque, lojas parceiras, como funciona e chamada para lojistas; o carrossel troca por setas, pontos, teclado e arraste, para quando o mouse ou o foco estão nele, tem botão de pausa e não troca sozinho para quem pediu menos movimento; se um bloco falhar, os outros continuam) e RF-21; caso de teste CT-19
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** login, recuperação de senha, RLS e pedidos gravados pelo banco; catálogo com filtros pelo endereço (?categoria=, ?busca=); index.html provisório (Aulas 30 a 39)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai transformar o `index.html` provisório na **página inicial de vitrine**: um **hero** com chamada e busca, um **carrossel acessível** de peças recentes, os **tipos de roupa**, os **produtos em destaque** (os 8 ativos mais recentes que têm foto e estoque), as **lojas parceiras**, o "como funciona" e uma chamada para lojistas. Cada bloco **carrega sozinho**: se um falhar, os outros continuam.

> **Dia 14 e esta aula:** é uma aula cheia (muito HTML, CSS e JavaScript). Os blocos são independentes: se o tempo apertar, o **carrossel** é o primeiro item a ficar para depois (o hero e os destaques ficam).

**Abertura (10 minutos).** Retomada da Aula 39: o sistema já protege telas e grava pedidos, mas quem abre o site ainda cai em uma página de texto simples. A página inicial é a **vitrine**: é ali que a cliente decide se fica. Abra o wireframe e o protótipo do catálogo (Aulas 4 e 5) e liste o que uma vitrine precisa mostrar nos primeiros segundos.

## O Conceito

**Termos desta aula**

- **Hero**: a primeira faixa grande da página, com a chamada principal (um título), um texto curto e a ação mais importante (aqui, a **busca** e o botão do catálogo).
- **Carrossel**: uma área que mostra **um destaque por vez** e troca para o próximo. Feito sem pressa para ser **acessível**: setas e pontos, o teclado (← e →), pausa, e respeito a quem pediu "menos movimento" no aparelho (`prefers-reduced-motion`).
- **`Promise.allSettled`**: espera várias promessas **terminarem, dando certo ou errado**, e entrega o resultado de cada uma. Diferente de `Promise.all` (que falha se uma falhar), ele deixa a página mostrar os blocos que deram certo.
- **Região viva (`aria-live`)**: uma área da página que o leitor de tela **anuncia** quando muda. No carrossel, ela só anuncia a troca quando **não** é automática (senão leria um slide novo a cada 6 segundos).

**Analogia:** é a **vitrine de uma loja**: o hero é a faixa grande da porta ("Liquidação!"), o carrossel é o manequim que gira, e cada prateleira (tipos de roupa, destaques, lojas) pode estar vazia sem derrubar a vitrine toda.

**Regras:** um `h1` só (no hero); os destaques são os **8 produtos ativos mais recentes que têm foto e pelo menos um tamanho com estoque**; cada tipo de roupa leva ao catálogo **filtrado** (`catalogo.html?categoria=ID`) e cada loja à sua página.

## Mão na Massa

### Passo 1: as consultas da vitrine

Em `js/servicos/lojaServico.js`, cole a função das lojas da vitrine **logo antes** do comentário `// ---------- Páginas públicas ----------`:

**Arquivo: `js/servicos/lojaServico.js`**: adicione este trecho logo antes da linha `// ---------- Páginas públicas ----------`:

```js
// Devolve [{ id, nome, descricao, cidade }], em ordem alfabética. Usada nos cartões da página inicial (RF-23).
export async function listarLojasParaVitrine() {
  try {
    const { data, error } = await exigirSupabase().from("lojas").select("id, nome, descricao, cidade").order("nome");
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw erro instanceof ErroApp
      ? erro
      : new ErroApp(
          "erro_ao_listar_lojas",
          "Não foi possível carregar as lojas. Verifique sua conexão e tente novamente.",
          erro
        );
  }
}

```


Em `js/servicos/produtoServico.js`, cole a função dos destaques **logo antes** de `obterProduto`:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`listarProdutosEmDestaque`) logo antes da função `obterProduto` (junto com os comentários que ficam acima dela):

```js
// RF-23 (página inicial): os produtos mais recentes que dá para comprar agora, ou seja, ativos, com pelo menos
// uma foto e pelo menos um tamanho com estoque. "!inner" nas duas relações descarta quem não tem nenhuma das duas coisas.
export async function listarProdutosEmDestaque(limite = 8) {
  try {
    const { data, error } = await exigirSupabase()
      .from("produtos")
      .select(CAMPOS_DO_PRODUTO + ", tamanhos!inner ( tamanho, estoque ), produto_fotos!inner ( id, url, ordem )")
      .eq("ativo", true)
      .gt("tamanhos.estoque", 0)
      .order("criado_em", { ascending: false })
      .order("ordem", { referencedTable: "produto_fotos", ascending: true })
      .limit(limite);
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw erroAoListarProdutos(erro);
  }
}
```


### Passo 2: o HTML da vitrine

Substitua **todo o conteúdo** do `index.html`:

**Arquivo: `index.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>VitrineCol – Moda das lojas do seu bairro</title>
  <meta name="description" content="Escolha roupas de várias lojas locais, junte tudo na mesma sacola e combine cada pedido direto com a loja pelo WhatsApp.">
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
  <link rel="stylesheet" href="css/inicio.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="inicio">
    <!-- Seção hero: a primeira coisa que a pessoa vê -->
    <section class="hero" aria-labelledby="titulo-hero">
      <div class="container hero-conteudo">
        <p class="hero-sobretitulo">Moda local, perto de você</p>
        <h1 id="titulo-hero">Roupas das lojas do seu bairro, num só lugar</h1>
        <p class="hero-texto">
          Escolha peças de várias lojas, junte tudo na mesma sacola e combine cada pedido direto com a loja pelo WhatsApp.
        </p>

        <form class="hero-busca" action="catalogo.html" method="get" role="search" aria-label="Buscar roupas">
          <label for="busca-inicio" class="visualmente-oculto">Buscar roupas pelo nome</label>
          <input type="search" id="busca-inicio" name="busca" placeholder="Buscar roupas, por exemplo: vestido">
          <button type="submit" class="botao">Buscar</button>
        </form>

        <p class="hero-acoes">
          <a class="botao botao-claro" href="catalogo.html">Ver o catálogo</a>
          <a class="botao botao-contorno" href="#lojas">Conhecer as lojas</a>
        </p>
      </div>
    </section>

    <!-- Os avisos de carregando e de erro aparecem aqui, logo abaixo do hero -->
    <div class="container area-avisos"></div>

    <!-- Carrossel com as peças mais recentes; é preenchido pelo JavaScript e fica escondido se não houver peças -->
    <section class="secao" id="secao-carrossel" aria-labelledby="titulo-carrossel" hidden>
      <div class="container">
        <h2 id="titulo-carrossel" class="visualmente-oculto">Novidades nas lojas</h2>
        <div id="carrossel"></div>
      </div>
    </section>

    <section class="secao" aria-labelledby="titulo-categorias">
      <div class="container">
        <h2 id="titulo-categorias">Compre por tipo de roupa</h2>
        <ul class="categorias-lista" id="lista-categorias"></ul>
      </div>
    </section>

    <section class="secao secao-destaque" aria-labelledby="titulo-destaques">
      <div class="container">
        <h2 id="titulo-destaques">Produtos em destaque</h2>
        <ul class="grade-produtos" id="lista-destaques"></ul>
        <p class="aviso aviso-info" id="mensagem-sem-destaques" role="status" hidden>
          Ainda não há peças em destaque. Volte em breve!
        </p>
        <p class="secao-acao"><a class="botao botao-secundario" href="catalogo.html">Ver todos os produtos</a></p>
      </div>
    </section>

    <section class="secao" id="lojas" aria-labelledby="titulo-lojas">
      <div class="container">
        <h2 id="titulo-lojas">Lojas parceiras</h2>
        <ul class="grade-lojas" id="lista-lojas"></ul>
        <p class="aviso aviso-info" id="mensagem-sem-lojas" role="status" hidden>
          Ainda não há lojas cadastradas.
        </p>
      </div>
    </section>

    <section class="secao secao-destaque" aria-labelledby="titulo-como-funciona">
      <div class="container">
        <h2 id="titulo-como-funciona">Como funciona</h2>
        <ol class="passos">
          <li>
            <h3>Escolha</h3>
            <p>Veja as peças de várias lojas e filtre por tipo de roupa, tamanho e loja.</p>
          </li>
          <li>
            <h3>Junte na sacola</h3>
            <p>Coloque peças de lojas diferentes na mesma sacola. Cada loja recebe o seu próprio pedido.</p>
          </li>
          <li>
            <h3>Combine pelo WhatsApp</h3>
            <p>Envie o pedido à loja, combine pagamento e entrega e acompanhe o status em Meus pedidos.</p>
          </li>
        </ol>
      </div>
    </section>

    <section class="secao" aria-labelledby="titulo-lojistas">
      <div class="container">
        <div class="chamada-lojista">
          <h2 id="titulo-lojistas">Tem uma loja de roupas?</h2>
          <p>Cadastre a sua loja e os seus produtos, com até 5 fotos cada, e receba os pedidos das clientes do bairro.</p>
          <p><a class="botao" href="cadastro.html">Quero vender na VitrineCol</a></p>
        </div>
      </div>
    </section>
  </main>

  <footer class="rodape">
    <div class="container">
      <ul class="rodape-links">
        <li><a href="catalogo.html">Catálogo</a></li>
        <li><a href="privacidade.html">Aviso de privacidade</a></li>
        <li><a href="meus-pedidos.html">Meus pedidos</a></li>
        <li><a href="painel-loja.html">Painel da loja</a></li>
      </ul>
      <p>Projeto integrador – Jovem Programadora (Senac). Pagamento e entrega são combinados direto com a loja.</p>
    </div>
  </footer>

  <script type="module" src="js/paginas/inicio.js"></script>
</body>
</html>
```


### Passo 3: o CSS da vitrine

Crie `css/inicio.css` por partes. Primeiro, o começo do arquivo e o **hero**:

**Arquivo: `css/inicio.css`** (arquivo novo):

```css
/* Página inicial (index.html): hero, carrossel, categorias, destaques, lojas, passos e chamada para lojistas.
   Mobile-first: o que está fora das media queries vale para o celular; 768px e 1024px acrescentam colunas. */

/* A página inicial não usa o espaçamento padrão do <main>: cada seção cuida do seu próprio espaço */
.inicio {
  padding-block: 0;
}

.secao {
  padding-block: var(--espaco-6);
}

.secao-destaque {
  background-color: var(--cor-primaria-clara);
}

.secao-acao {
  margin: var(--espaco-5) 0 0;
  text-align: center;
}

/* ---------- Hero ---------- */
.hero {
  padding-block: var(--espaco-7);
  color: var(--cor-texto-sobre-primaria);
  background-image: linear-gradient(135deg, var(--cor-primaria-escura), var(--cor-primaria));
  background-color: var(--cor-primaria-escura);
}

/* O contêiner continua alinhado com o resto da página; só o texto do hero fica numa coluna mais estreita */
.hero-conteudo > * {
  max-width: 44rem;
}

.hero-sobretitulo {
  margin-bottom: var(--espaco-2);
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  font-size: var(--tamanho-pequeno);
}

.hero h1 {
  font-size: 2rem;
  line-height: 1.15;
}

.hero-texto {
  margin-bottom: var(--espaco-5);
  font-size: var(--tamanho-medio);
}

.hero-busca {
  display: flex;
  flex-direction: column;
  gap: var(--espaco-2);
  margin-bottom: var(--espaco-4);
}

.hero-busca input {
  width: 100%;
  min-height: 2.75rem;
  padding: var(--espaco-2) var(--espaco-3);
  font: inherit;
  color: var(--cor-texto);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-superficie);
  border-radius: var(--raio-medio);
}

.hero-busca input:focus-visible,
.hero .botao:focus-visible {
  outline: 3px solid var(--cor-superficie);
  outline-offset: 2px;
}

/* O botão "Buscar" fica branco sobre o fundo escuro do hero, como os outros botões dele */
.hero-busca .botao,
.hero .botao-claro {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
  border-color: var(--cor-superficie);
}

.hero-busca .botao:hover,
.hero .botao-claro:hover {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-primaria-clara);
  border-color: var(--cor-primaria-clara);
}

.hero .botao-contorno {
  color: var(--cor-texto-sobre-primaria);
  background-color: transparent;
  border-color: var(--cor-texto-sobre-primaria);
}

.hero .botao-contorno:hover {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
  border-color: var(--cor-superficie);
}

.hero-acoes {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-3);
  margin: 0;
}
```


Depois, o **carrossel** (cole **no final** do arquivo):

**Arquivo: `css/inicio.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Carrossel ---------- */
.carrossel {
  overflow: hidden;
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
  box-shadow: var(--sombra-media);
}

.carrossel-slide {
  display: grid;
  grid-template-columns: 1fr;
  animation: carrossel-aparecer 0.4s ease;
}

@keyframes carrossel-aparecer {
  from {
    opacity: 0;
  }

  to {
    opacity: 1;
  }
}

.slide-imagem {
  width: 100%;
  aspect-ratio: 4 / 3;
  object-fit: cover;
  background-color: var(--cor-neutro-fundo);
}

.slide-texto {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  gap: var(--espaco-2);
  padding: var(--espaco-5);
}

.slide-etiqueta {
  margin: 0;
  font-size: var(--tamanho-pequeno);
  font-weight: 600;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  color: var(--cor-texto-suave);
}

.slide-titulo {
  margin: 0;
  font-size: var(--tamanho-grande);
}

.slide-titulo a {
  color: var(--cor-texto);
  text-decoration: none;
}

.slide-titulo a:hover {
  text-decoration: underline;
}

.slide-loja {
  margin: 0 0 var(--espaco-2);
  color: var(--cor-texto-suave);
}

.carrossel-controles {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--espaco-3);
  padding: var(--espaco-3);
  border-top: 1px solid var(--cor-borda);
}

.carrossel-seta,
.carrossel-pausa {
  width: 2.75rem;
  height: 2.75rem;
  padding: 0;
  font: inherit;
  font-size: 1.5rem;
  line-height: 1;
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-primaria);
  border-radius: var(--raio-pilula);
  cursor: pointer;
}

.carrossel-seta:hover,
.carrossel-pausa:hover {
  background-color: var(--cor-primaria-clara);
}

.carrossel-pontos {
  display: flex;
  gap: var(--espaco-1);
  list-style: none;
}

/* O botão tem 1,5rem (alvo de toque confortável); a bolinha visível é menor e fica no centro */
.carrossel-ponto {
  display: grid;
  place-items: center;
  width: 1.5rem;
  height: 1.5rem;
  padding: 0;
  background: none;
  border: 0;
  cursor: pointer;
}

.carrossel-ponto::before {
  content: "";
  width: 0.75rem;
  height: 0.75rem;
  border: 2px solid var(--cor-primaria);
  border-radius: 50%;
  background-color: var(--cor-superficie);
}

.carrossel-ponto[aria-current="true"]::before {
  background-color: var(--cor-primaria);
}
```


Depois os **tipos de roupa**, as **lojas**, o **como funciona** e a **chamada para lojistas** (também **no final**):

**Arquivo: `css/inicio.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Tipos de roupa ---------- */
.categorias-lista {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-3);
  list-style: none;
}

.categoria-link {
  display: inline-flex;
  align-items: center;
  min-height: 2.75rem;
  padding: var(--espaco-2) var(--espaco-4);
  font-weight: 600;
  text-decoration: none;
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-primaria);
  border-radius: var(--raio-pilula);
}

.categoria-link:hover {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-primaria-clara);
}

.categoria-link-todas {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
}

.categoria-link-todas:hover {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria-escura);
}

/* ---------- Lojas parceiras ---------- */
.grade-lojas {
  display: grid;
  gap: var(--espaco-4);
  grid-template-columns: 1fr;
  list-style: none;
}

.cartao-loja {
  position: relative;
  height: 100%;
  padding: var(--espaco-4);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
  box-shadow: var(--sombra-leve);
}

.cartao-loja-titulo {
  margin: 0 0 var(--espaco-1);
}

.cartao-loja-titulo a {
  color: var(--cor-texto);
  text-decoration: none;
}

/* O link do nome cobre o cartão inteiro, assim ele todo é clicável (como nos cards de produto) */
.cartao-loja-titulo a::after {
  content: "";
  position: absolute;
  inset: 0;
}

.cartao-loja-titulo a:hover {
  text-decoration: underline;
}

.cartao-loja:focus-within {
  outline: 3px solid var(--cor-foco);
  outline-offset: 2px;
}

.cartao-loja-titulo a:focus-visible {
  outline: none;
}

.cartao-loja-cidade {
  margin: 0 0 var(--espaco-2);
  font-size: var(--tamanho-pequeno);
  color: var(--cor-texto-suave);
}

/* Descrições longas são cortadas em 3 linhas para os cartões ficarem do mesmo tamanho */
.cartao-loja-descricao {
  display: -webkit-box;
  margin: 0;
  overflow: hidden;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
}

/* ---------- Como funciona ---------- */
.passos {
  display: grid;
  gap: var(--espaco-4);
  grid-template-columns: 1fr;
  list-style: none;
  counter-reset: passo;
}

.passos li {
  position: relative;
  padding: var(--espaco-4) var(--espaco-4) var(--espaco-4) 4rem;
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
  counter-increment: passo;
}

/* O número do passo é desenhado pelo CSS; a lista numerada (ol) já informa a ordem ao leitor de tela */
.passos li::before {
  content: counter(passo);
  position: absolute;
  top: var(--espaco-4);
  left: var(--espaco-4);
  display: grid;
  place-items: center;
  width: 2.25rem;
  height: 2.25rem;
  font-weight: 700;
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
  border-radius: 50%;
}

.passos h3 {
  margin-bottom: var(--espaco-1);
}

.passos p {
  margin: 0;
}

/* ---------- Chamada para lojistas ---------- */
.chamada-lojista {
  padding: var(--espaco-6) var(--espaco-4);
  text-align: center;
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-primaria);
  border-radius: var(--raio-medio);
}

.chamada-lojista p:last-child {
  margin-bottom: 0;
}
```


E, por fim, as telas maiores (**no final**):

**Arquivo: `css/inicio.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Tablet ---------- */
@media (min-width: 768px) {
  .hero h1 {
    font-size: 2.75rem;
  }

  .hero-busca {
    flex-direction: row;
  }

  .hero-busca input {
    flex: 1;
  }

  .carrossel-slide {
    grid-template-columns: 1fr 1fr;
  }

  .slide-imagem {
    height: 100%;
    min-height: 20rem;
    max-height: 26rem;
    aspect-ratio: auto;
  }

  .slide-titulo {
    font-size: var(--tamanho-titulo);
  }

  .grade-lojas {
    grid-template-columns: repeat(2, 1fr);
  }

  .passos {
    grid-template-columns: repeat(3, 1fr);
  }
}

/* ---------- Desktop ---------- */
@media (min-width: 1024px) {
  .grade-lojas {
    grid-template-columns: repeat(3, 1fr);
  }
}
```


### Passo 4: o carrossel e a página

Crie `js/ui/carrossel.js` e `js/paginas/inicio.js`:

**Arquivo: `js/ui/carrossel.js`** (arquivo novo, inteiro)

```js
// Carrossel de slides feito só com HTML, CSS e JavaScript, acessível pelo teclado e por leitor de tela.
// Recebe uma lista de elementos (cada um é um slide) e devolve o carrossel pronto para colocar na página.
//
// Regras de acessibilidade que ele segue:
// - troca sozinho só se a pessoa NÃO pediu menos movimento (prefers-reduced-motion);
// - a troca automática para quando o mouse ou o foco do teclado estão em cima, e há um botão Pausar/Retomar;
// - setas ← e → trocam de slide quando o foco está dentro dele; no celular, arrastar o dedo também troca;
// - só o slide atual fica visível (atributo hidden), então o leitor de tela não lê os escondidos.
import { criarElemento } from "./elementos.js";

const INTERVALO_DA_TROCA_EM_MS = 6000;
const DISTANCIA_MINIMA_DO_TOQUE_EM_PX = 40;

function criarBotao(classe, rotulo, texto) {
  const botao = criarElemento("button", classe, texto);
  botao.type = "button";
  // aria-label dá o nome completo ao botão; o texto visível (uma seta) sozinho não diz nada ao leitor de tela
  botao.setAttribute("aria-label", rotulo);
  return botao;
}

// "slides" é uma lista de elementos; "rotulo" é o nome do carrossel para o leitor de tela.
export function criarCarrossel(slides, rotulo) {
  const total = slides.length;
  const raiz = criarElemento("div", "carrossel");
  raiz.setAttribute("role", "region");
  raiz.setAttribute("aria-roledescription", "carrossel");
  raiz.setAttribute("aria-label", rotulo);

  // Cada slide vira um "grupo" com o nome "2 de 5"
  const area = criarElemento("div", "carrossel-area");
  slides.forEach((slide, posicao) => {
    slide.classList.add("carrossel-slide");
    slide.setAttribute("role", "group");
    slide.setAttribute("aria-roledescription", "slide");
    slide.setAttribute("aria-label", posicao + 1 + " de " + total);
    area.append(slide);
  });
  raiz.append(area);

  let atual = 0;
  let temporizador = null;
  let pausadaPelaPessoa = false;
  let paradaPeloPonteiro = false; // mouse ou foco em cima do carrossel
  const reduzMovimento = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  const pontos = [];
  const botaoPausa = criarBotao("carrossel-pausa", "Pausar a troca automática de slides", "⏸");

  function mostrar(indice) {
    atual = (indice + total) % total;
    slides.forEach((slide, posicao) => {
      slide.hidden = posicao !== atual;
    });
    pontos.forEach((ponto, posicao) => {
      if (posicao === atual) {
        ponto.setAttribute("aria-current", "true");
      } else {
        ponto.removeAttribute("aria-current");
      }
    });
  }

  function trocaAutomaticaAtiva() {
    return !reduzMovimento && !pausadaPelaPessoa && !paradaPeloPonteiro;
  }

  // A área só anuncia a troca ao leitor de tela quando NÃO é automática; senão ele leria um slide novo a cada 6 s
  function atualizarAnuncio() {
    area.setAttribute("aria-live", trocaAutomaticaAtiva() ? "off" : "polite");
  }

  function pararTemporizador() {
    clearInterval(temporizador);
    temporizador = null;
  }

  function sincronizarTemporizador() {
    pararTemporizador();
    if (total > 1 && trocaAutomaticaAtiva()) {
      temporizador = setInterval(() => mostrar(atual + 1), INTERVALO_DA_TROCA_EM_MS);
    }
    atualizarAnuncio();
  }

  // Com só um slide não há o que navegar: os controles nem aparecem
  if (total > 1) {
    const controles = criarElemento("div", "carrossel-controles");

    const anterior = criarBotao("carrossel-seta", "Slide anterior", "‹");
    const proximo = criarBotao("carrossel-seta", "Próximo slide", "›");
    anterior.addEventListener("click", () => {
      mostrar(atual - 1);
      sincronizarTemporizador(); // recomeça a contagem, para o slide não trocar logo depois do clique
    });
    proximo.addEventListener("click", () => {
      mostrar(atual + 1);
      sincronizarTemporizador();
    });

    const listaDePontos = criarElemento("ul", "carrossel-pontos");
    slides.forEach((slide, posicao) => {
      const item = criarElemento("li");
      const ponto = criarBotao("carrossel-ponto", "Ir para o slide " + (posicao + 1) + " de " + total);
      ponto.addEventListener("click", () => {
        mostrar(posicao);
        sincronizarTemporizador();
      });
      pontos.push(ponto);
      item.append(ponto);
      listaDePontos.append(item);
    });

    controles.append(anterior, listaDePontos, proximo);

    // Quem pediu menos movimento não tem troca automática, então também não precisa do botão de pausa
    if (!reduzMovimento) {
      botaoPausa.addEventListener("click", () => {
        pausadaPelaPessoa = !pausadaPelaPessoa;
        botaoPausa.textContent = pausadaPelaPessoa ? "▶" : "⏸";
        botaoPausa.setAttribute(
          "aria-label",
          pausadaPelaPessoa ? "Retomar a troca automática de slides" : "Pausar a troca automática de slides"
        );
        sincronizarTemporizador();
      });
      controles.append(botaoPausa);
    }
    raiz.append(controles);

    // Mouse ou foco em cima: para a troca, para a pessoa ter tempo de ler
    raiz.addEventListener("mouseenter", () => {
      paradaPeloPonteiro = true;
      sincronizarTemporizador();
    });
    raiz.addEventListener("mouseleave", () => {
      paradaPeloPonteiro = false;
      sincronizarTemporizador();
    });
    raiz.addEventListener("focusin", () => {
      paradaPeloPonteiro = true;
      sincronizarTemporizador();
    });
    raiz.addEventListener("focusout", (evento) => {
      // O foco só "saiu" de verdade se não foi para outro elemento do próprio carrossel
      if (!raiz.contains(evento.relatedTarget)) {
        paradaPeloPonteiro = false;
        sincronizarTemporizador();
      }
    });

    raiz.addEventListener("keydown", (evento) => {
      if (evento.key === "ArrowLeft") {
        mostrar(atual - 1);
      } else if (evento.key === "ArrowRight") {
        mostrar(atual + 1);
      }
    });

    // Arrastar o dedo para o lado troca de slide
    let inicioDoToque = null;
    area.addEventListener("touchstart", (evento) => {
      inicioDoToque = evento.changedTouches[0].clientX;
    }, { passive: true });
    area.addEventListener("touchend", (evento) => {
      if (inicioDoToque === null) {
        return;
      }
      const distancia = evento.changedTouches[0].clientX - inicioDoToque;
      inicioDoToque = null;
      if (Math.abs(distancia) >= DISTANCIA_MINIMA_DO_TOQUE_EM_PX) {
        mostrar(distancia < 0 ? atual + 1 : atual - 1);
        sincronizarTemporizador();
      }
    });
  }

  mostrar(0);
  sincronizarTemporizador();
  return raiz;
}
```


**Arquivo: `js/paginas/inicio.js`** (arquivo novo, inteiro)

```js
// Página inicial (index.html, RF-23): hero, carrossel com as peças mais recentes, tipos de roupa,
// produtos em destaque e lojas parceiras. A página só chama os serviços e mostra o resultado e os avisos.
// Cada bloco é independente: se um deles falhar, os outros continuam aparecendo.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, registrarErro } from "../ui/avisos.js";
import { criarCardProduto } from "../ui/cards.js";
import { criarCarrossel } from "../ui/carrossel.js";
import { criarElemento } from "../ui/elementos.js";
import { Produto } from "../modelos/Produto.js";
import { listarProdutosEmDestaque } from "../servicos/produtoServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";
import { listarLojasParaVitrine } from "../servicos/lojaServico.js";

const QUANTIDADE_DE_DESTAQUES = 8;
const QUANTIDADE_DE_SLIDES = 5; // o carrossel usa as primeiras peças dos destaques

const secaoCarrossel = document.getElementById("secao-carrossel");
const areaDoCarrossel = document.getElementById("carrossel");
const listaCategorias = document.getElementById("lista-categorias");
const listaDestaques = document.getElementById("lista-destaques");
const mensagemSemDestaques = document.getElementById("mensagem-sem-destaques");
const listaLojas = document.getElementById("lista-lojas");
const mensagemSemLojas = document.getElementById("mensagem-sem-lojas");

// ---------- Carrossel ----------

// Um slide: a foto da peça de um lado e, do outro, o nome, o preço, a loja e o link para a página do produto.
function criarSlideDeProduto(produto) {
  const slide = criarElemento("div");
  const endereco = "produto.html?id=" + encodeURIComponent(produto.id);

  const imagem = criarElemento("img", "slide-imagem");
  imagem.src = produto.fotoCapa();
  imagem.alt = "Foto de " + produto.nome;
  imagem.width = 800;
  imagem.height = 600;

  const texto = criarElemento("div", "slide-texto");
  texto.append(criarElemento("p", "slide-etiqueta", "Novidade em " + (produto.categoria || "moda")));

  const titulo = criarElemento("h3", "slide-titulo");
  const link = criarElemento("a", "", produto.nome);
  link.href = endereco;
  titulo.append(link);

  const botao = criarElemento("a", "botao", "Ver esta peça");
  botao.href = endereco;
  // O botão leva ao mesmo lugar que o título; o nome completo no aria-label deixa claro para o leitor de tela qual peça é
  botao.setAttribute("aria-label", "Ver a peça " + produto.nome);

  texto.append(
    titulo,
    criarElemento("p", "preco", produto.precoFormatado()),
    criarElemento("p", "slide-loja", "Vendido por " + produto.lojaNome),
    botao
  );

  slide.append(imagem, texto);
  return slide;
}

function mostrarCarrossel(produtos) {
  if (produtos.length === 0) {
    secaoCarrossel.hidden = true;
    return;
  }
  const slides = produtos.slice(0, QUANTIDADE_DE_SLIDES).map(criarSlideDeProduto);
  areaDoCarrossel.replaceChildren(criarCarrossel(slides, "Novidades nas lojas"));
  secaoCarrossel.hidden = false;
}

// ---------- Destaques ----------

function mostrarDestaques(produtos) {
  listaDestaques.replaceChildren(...produtos.map(criarCardProduto));
  mensagemSemDestaques.hidden = produtos.length > 0;
}

// ---------- Categorias ----------

// Cada tipo de roupa leva ao catálogo já filtrado (catalogo.html?categoria=ID)
function mostrarCategorias(categorias) {
  const itens = categorias.map((categoria) => {
    const item = criarElemento("li");
    const link = criarElemento("a", "categoria-link", categoria.nome);
    link.href = "catalogo.html?categoria=" + encodeURIComponent(categoria.id);
    item.append(link);
    return item;
  });

  const itemDeTodas = criarElemento("li");
  const linkDeTodas = criarElemento("a", "categoria-link categoria-link-todas", "Ver tudo");
  linkDeTodas.href = "catalogo.html";
  itemDeTodas.append(linkDeTodas);

  listaCategorias.replaceChildren(...itens, itemDeTodas);
}

// ---------- Lojas ----------

function mostrarLojas(lojas) {
  const cartoes = lojas.map((loja) => {
    const item = criarElemento("li");
    const cartao = criarElemento("article", "cartao-loja");

    const titulo = criarElemento("h3", "cartao-loja-titulo");
    const link = criarElemento("a", "", loja.nome);
    link.href = "loja.html?id=" + encodeURIComponent(loja.id);
    titulo.append(link);

    cartao.append(titulo, criarElemento("p", "cartao-loja-cidade", loja.cidade));
    if (loja.descricao) {
      cartao.append(criarElemento("p", "cartao-loja-descricao", loja.descricao));
    }

    item.append(cartao);
    return item;
  });

  listaLojas.replaceChildren(...cartoes);
  mensagemSemLojas.hidden = lojas.length > 0;
}

// ---------- Início ----------

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  // As três consultas não dependem uma da outra: rodam juntas, e allSettled espera todas, mesmo que alguma falhe
  const [destaques, categorias, lojas] = await Promise.allSettled([
    listarProdutosEmDestaque(QUANTIDADE_DE_DESTAQUES),
    listarCategorias(),
    listarLojasParaVitrine(),
  ]);

  let primeiroErro = null;

  if (destaques.status === "fulfilled") {
    const produtos = destaques.value.map(Produto.deLinha);
    mostrarCarrossel(produtos);
    mostrarDestaques(produtos);
  } else {
    primeiroErro = destaques.reason;
  }

  if (categorias.status === "fulfilled") {
    mostrarCategorias(categorias.value);
  } else {
    primeiroErro = primeiroErro ?? categorias.reason;
  }

  if (lojas.status === "fulfilled") {
    mostrarLojas(lojas.value);
  } else {
    primeiroErro = primeiroErro ?? lojas.reason;
  }

  if (primeiroErro) {
    [destaques, categorias, lojas].forEach((resultado) => {
      if (resultado.status === "rejected") {
        registrarErro(resultado.reason);
      }
    });
    mostrarErro(mensagemDoErro(primeiroErro));
  } else {
    limparAvisos();
  }
}

iniciar();
```


### Passo 5: teste a vitrine (CT-19)

1. Abra `index.html` (sem estar logada). Aparecem o **hero** (título, busca e dois botões), o **carrossel** com as peças recentes, os **tipos de roupa**, os **produtos em destaque**, as **lojas parceiras**, o **como funciona** e a chamada para lojistas.
2. **Carrossel:** a cada 6 segundos troca o slide. Use as setas **‹** e **›**, os **pontos**, e, com o foco no carrossel (Tab), as teclas **←** e **→**. Passe o mouse (ou o foco) em cima: a troca **para**. Clique no botão **⏸**: a troca para; clique em **▶** e ela volta. No celular (ou no modo de dispositivo do F12), arraste o dedo para o lado.
3. **Menos movimento:** nas configurações do sistema operacional, ative **reduzir movimento** (Windows: **Configurações > Acessibilidade > Efeitos visuais > Efeitos de animação**, em português; no Mac: **Ajustes do Sistema > Acessibilidade > Tela > Reduzir movimento**). Recarregue: o carrossel **não** troca sozinho e o botão de pausa **não** aparece.
4. Clique em um **tipo de roupa** (por exemplo, **Vestidos**): abre o catálogo **já filtrado**. Clique no nome de uma loja: abre a página dela.
5. Digite `vestido` no campo do hero e clique em **Buscar**: abre o catálogo com a busca preenchida.
6. **Um bloco falha, os outros continuam:** na aba **Network** (em português: **Rede**) do F12, clique com o botão direito em um pedido de `lojas` e bloqueie-o (**Block request URL**, em português: **Bloquear URL do pedido**), recarregue: aparece uma mensagem de erro, mas o **carrossel e os destaques** continuam. Desfaça o bloqueio.
7. **Sem produtos:** se nenhum produto tem foto e estoque, o carrossel **some** e a seção de destaques mostra **Ainda não há peças em destaque. Volte em breve!**

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria a página inicial de vitrine com hero, carrossel, destaques e lojas"
git push
```

## Explicação do Código

**listarProdutosEmDestaque(limite = 8)**: usa `tamanhos!inner ( ... )` e `produto_fotos!inner ( ... )`: o `!inner` faz um `JOIN` que **descarta** produtos sem tamanho (com estoque) ou sem foto. `.eq("ativo", true)`, `.gt("tamanhos.estoque", 0)` (estoque maior que zero), `.order("criado_em", { ascending: false })` (os mais recentes primeiro) e `.limit(limite)`.

**listarLojasParaVitrine()**: lojas em ordem alfabética, com nome, descrição e cidade.

**index.html**: o `<h1>` está no hero (`id="titulo-hero"`), o formulário de busca usa `action="catalogo.html" method="get"` e o campo `name="busca"`: ao enviar, o navegador abre `catalogo.html?busca=vestido` **sem JavaScript**, e o catálogo (Aula 30) lê esse parâmetro. O `<div class="container area-avisos">` é onde o "Carregando…" aparece. A seção do carrossel começa com `hidden` e é mostrada só se houver peças. Os destaques e as lojas têm uma mensagem de lista vazia (`hidden`).

**carrossel.js, `criarCarrossel(slides, rotulo)`**

- Recebe uma lista de elementos (cada um é um slide) e devolve o carrossel pronto: `role="region"` e `aria-roledescription="carrossel"` dão o nome ao conjunto, e cada slide é um `role="group"` com o nome "2 de 5".
- `mostrar(indice)`: mostra só o slide atual (`slide.hidden = posicao !== atual`), então o leitor de tela não lê os escondidos; atualiza o ponto atual com `aria-current`.
- A **troca automática** (`setInterval` de 6 segundos) só existe se `trocaAutomaticaAtiva()`: a pessoa **não** pediu menos movimento (`window.matchMedia("(prefers-reduced-motion: reduce)")`), **não** pausou e **não** está com o mouse/foco em cima. `sincronizarTemporizador()` liga ou desliga o temporizador conforme esses três estados e atualiza o `aria-live` ("off" na troca automática, "polite" quando é a pessoa que navega).
- **Controles** (só com mais de um slide): botões anterior/próximo, pontos (cada um um `<button>`) e o botão de pausa (⏸/▶, só se não pediu menos movimento). O mouse (`mouseenter`/`mouseleave`) e o foco (`focusin`/`focusout`) param a troca; `keydown` trata ← e →; `touchstart`/`touchend` medem o arraste (mínimo de 40 px).

**inicio.js**

- `iniciar()`: monta o cabeçalho, mostra "Carregando…" e dispara **as três consultas ao mesmo tempo** com `Promise.allSettled([...])`. Cada resultado tem `status: "fulfilled"` (deu certo, com `value`) ou `"rejected"` (falhou, com `reason`). O código **desenha cada bloco que deu certo** e, se algum falhou, registra e mostra **uma** mensagem de erro, sem derrubar os outros.
- `criarSlideDeProduto(produto)`: foto, etiqueta ("Novidade em Vestidos"), título (link), preço, loja e o botão **Ver esta peça**, com `aria-label` com o nome completo (o leitor de tela entende de qual peça é).
- `mostrarCarrossel(produtos)`: usa as 5 primeiras peças dos destaques; sem peças, esconde a seção. `mostrarDestaques`: os cards de produto (`criarCardProduto`). `mostrarCategorias`: um link por tipo de roupa para `catalogo.html?categoria=ID` e o link **Ver tudo**. `mostrarLojas`: um cartão por loja, com o nome como link para `loja.html?id=...`, a cidade e a descrição.

**inicio.css**: `.hero` com fundo em gradiente das cores da marca; `.carrossel*` (slide em grade, imagem 4:3, controles em flex, pontos); `.categoria-link` (pílulas); `.grade-lojas` e `.cartao-loja` (o link do nome cobre o cartão todo, como nos cards de produto); `.passos` (a lista numerada do "como funciona", com os números desenhados pelo CSS); `.chamada-lojista`. As **media queries** de 768 e 1024 px acrescentam colunas (carrossel com foto ao lado do texto, 2 e 3 colunas de lojas, 3 passos).

## Validação

1. A página inicial mostra todos os blocos, e o carrossel troca por setas, pontos, teclado e arraste, para com o mouse ou o foco e tem pausa (CT-19).
2. Com "menos movimento" ligado, o carrossel não troca sozinho.
3. Cada tipo de roupa abre o catálogo filtrado; cada loja abre a sua página; a busca do hero leva ao catálogo com a busca preenchida.
4. Se um bloco falhar, os outros continuam e aparece uma mensagem de erro.
5. Em 360 e 1280 px, não há rolagem horizontal.

**Erros comuns**

1. *Sintoma:* o carrossel não aparece. *Causa:* não há produtos ativos com foto **e** estoque. *Correção:* cadastre um produto com foto e um tamanho com estoque maior que zero.
2. *Mensagem:* `The requested module ... does not provide an export named 'criarCarrossel'`. *Causa:* o `carrossel.js` não tem o `export` ou foi salvo em outra pasta. *Correção:* ele fica em `js/ui/carrossel.js` e a função é `export function criarCarrossel`.
3. *Sintoma:* o hero fica sem fundo colorido. *Causa:* o `inicio.css` não está ligado ao `index.html`. *Correção:* confira a linha `<link rel="stylesheet" href="css/inicio.css">` no `<head>`, **depois** de `paginas.css`.
4. *Sintoma:* os tipos de roupa levam ao catálogo sem filtrar. *Causa:* o `id` da categoria não foi para o endereço. *Correção:* confira `link.href = "catalogo.html?categoria=" + encodeURIComponent(categoria.id)`.

**Se travar**

1. No Console (F12) leia o primeiro erro; veja a aba **Network** (em português: **Rede**) para saber qual das três consultas falhou.
2. Teste cada bloco separadamente, comentando temporariamente os outros dentro de `iniciar()`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `index.html` (vitrine), `css/inicio.css`, `js/ui/carrossel.js` e `js/paginas/inicio.js`.
- `listarLojasParaVitrine` e `listarProdutosEmDestaque` nos serviços.
- A página inicial completa, ligada ao catálogo e às lojas.

**Como saber que deu certo:** você abre o site, usa o carrossel por setas, pontos e teclado, clica em **Vestidos** e chega ao catálogo já filtrado.
