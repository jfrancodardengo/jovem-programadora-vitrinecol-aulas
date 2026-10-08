# Aula 9 – Montagem das páginas do projeto em HTML

**Dia 3 · Qui 08/10/2026** · **Aula 9** · **UC3**

- **Requisitos cobertos:** apenas a estrutura de RF-01 (cards de produto), RF-06 (página da loja), RF-08 (página do produto) e RF-13 (login)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** index.html, login.html e catalogo.html estáticas e sem CSS, com cabeçalho e rodapé iguais; imagens/sem-foto.svg (Aulas 7 e 8)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai completar as **quatro páginas** do projeto (`catalogo.html`, `loja.html`, `produto.html` e `login.html`), reaproveitando o cabeçalho e o rodapé, ligá-las por **links** e conferir a estrutura contra o protótipo do Figma.

**Abertura (10 minutos).** Retomada da Aula 8: o catálogo tem os filtros, mas a lista de produtos está vazia, e o login está pronto. Abra o protótipo (Aula 5) e confira a página do produto: foto grande, miniaturas, preço, loja, tamanhos, quantidade e botão. É o que vamos montar. Hoje os dados são todos **fixos** (escritos à mão): mais tarde o JavaScript e o banco os substituem.

## O Conceito

**Termos desta aula**

- **Link relativo**: um endereço que depende do lugar onde o arquivo está, como `produto.html` ou `imagens/exemplo-1.svg`. Funciona no seu computador e depois no site publicado.
- **Card**: um bloco com os dados de um item (aqui: foto, nome, preço e loja de um produto). Os cards do catálogo são uma lista (`ul`) de itens (`li`).
- **Conteúdo de exemplo**: texto e imagens falsos que ocupam o lugar do conteúdo real, só para ver como a página fica.
- **`fieldset` e `legend`**: agrupam campos que pertencem ao mesmo assunto, com um título (aqui, os botões de tamanho).

**Analogia:** montar as páginas agora, com conteúdo fixo, é como montar a vitrine de uma loja com manequins antes da coleção chegar: dá para ver se tudo cabe e fica claro.

## Mão na Massa

### Passo 1: crie as seis imagens de exemplo

Elas são desenhos em formato SVG (texto). Crie cada arquivo dentro da pasta `imagens`. Cada um é só uma "camiseta" em cor diferente:

**Arquivo: `imagens/exemplo-1.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#e8c4d4"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 1</text>
</svg>
```


**Arquivo: `imagens/exemplo-2.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#c9d8e8"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 2</text>
</svg>
```


**Arquivo: `imagens/exemplo-3.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#f2dcc2"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 3</text>
</svg>
```


**Arquivo: `imagens/exemplo-4.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#cfe3d2"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 4</text>
</svg>
```


**Arquivo: `imagens/exemplo-5.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#d9cfe8"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 5</text>
</svg>
```


**Arquivo: `imagens/exemplo-6.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Imagem de exemplo de roupa">
  <rect width="600" height="750" fill="#f0cfc9"/>
  <path d="M220 170 L300 200 L380 170 L470 240 L420 310 L390 290 L390 600 L210 600 L210 290 L180 310 L130 240 Z" fill="#ffffff" fill-opacity="0.75" stroke="#6b1a40" stroke-width="6" stroke-linejoin="round"/>
  <text x="300" y="690" font-family="sans-serif" font-size="28" text-anchor="middle" fill="#2b2230">Foto de exemplo 6</text>
</svg>
```


### Passo 2: coloque três cards de exemplo no catálogo

No `catalogo.html`, a lista de produtos está vazia. Troque-a pela lista com três cards:

**Arquivo: `catalogo.html`**: substitua a linha `<ul class="grade-produtos" id="lista-produtos"></ul>` por:

```html
      <ul class="grade-produtos" id="lista-produtos">
        <li>
          <article class="card-produto">
            <img class="card-produto-imagem" src="imagens/exemplo-1.svg" alt="Foto de Vestido midi floral" width="600" height="750">
            <div class="card-produto-corpo">
              <h3 class="card-produto-titulo"><a href="produto.html">Vestido midi floral</a></h3>
              <p class="preco">R$ 129,90</p>
              <p class="card-produto-loja">Loja Exemplo</p>
            </div>
          </article>
        </li>
        <li>
          <article class="card-produto">
            <img class="card-produto-imagem" src="imagens/exemplo-2.svg" alt="Foto de Camiseta básica branca" width="600" height="750">
            <div class="card-produto-corpo">
              <h3 class="card-produto-titulo"><a href="produto.html">Camiseta básica branca</a></h3>
              <p class="preco">R$ 49,90</p>
              <p class="card-produto-loja">Loja Exemplo</p>
            </div>
          </article>
        </li>
        <li>
          <article class="card-produto">
            <img class="card-produto-imagem" src="imagens/exemplo-3.svg" alt="Foto de Calça jeans reta" width="600" height="750">
            <div class="card-produto-corpo">
              <h3 class="card-produto-titulo"><a href="produto.html">Calça jeans reta</a></h3>
              <p class="preco">R$ 159,90</p>
              <p class="card-produto-loja">Loja do Bairro</p>
            </div>
          </article>
        </li>
      </ul>
```


### Passo 3: crie a página da loja

**Arquivo: `loja.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Loja – VitrineCol</title>
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho">
    <div class="container cabecalho-conteudo">
      <a class="logotipo" href="index.html">VitrineCol</a>
      <nav aria-label="Principal">
        <ul class="menu">
          <li><a href="index.html">Início</a></li>
          <li><a href="catalogo.html">Catálogo</a></li>
          <li><a href="sacola.html">Sacola</a></li>
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <h1 id="titulo-loja">Loja Exemplo</h1>

    <section class="loja-resumo" id="resumo-loja" aria-label="Dados da loja">
      <div>
        <p id="descricao-loja">Moda feminina casual e confortável</p>
        <dl class="loja-dados">
          <dt>Endereço</dt>
          <dd id="endereco-loja">Rua das Flores, 100, Centro, Cidade Exemplo</dd>
        </dl>
        <div class="loja-acoes">
          <a class="botao botao-whatsapp" id="botao-whatsapp" href="https://wa.me/5527999999999" target="_blank" rel="noopener">Conversar no WhatsApp<span class="visualmente-oculto"> (abre em nova aba)</span></a>
          <a class="botao botao-secundario" id="botao-mapa" href="https://www.google.com/maps" target="_blank" rel="noopener">Ver no mapa<span class="visualmente-oculto"> (abre em nova aba)</span></a>
        </div>
      </div>
    </section>

    <section aria-labelledby="titulo-produtos-loja" id="produtos-loja">
      <h2 id="titulo-produtos-loja">Produtos da loja</h2>
      <ul class="grade-produtos" id="lista-produtos">
        <li>
          <article class="card-produto">
            <img class="card-produto-imagem" src="imagens/exemplo-1.svg" alt="Foto de Vestido midi floral" width="600" height="750">
            <div class="card-produto-corpo">
              <h3 class="card-produto-titulo"><a href="produto.html">Vestido midi floral</a></h3>
              <p class="preco">R$ 129,90</p>
              <p class="card-produto-loja">Loja Exemplo</p>
            </div>
          </article>
        </li>
        <li>
          <article class="card-produto">
            <img class="card-produto-imagem" src="imagens/exemplo-2.svg" alt="Foto de Camiseta básica branca" width="600" height="750">
            <div class="card-produto-corpo">
              <h3 class="card-produto-titulo"><a href="produto.html">Camiseta básica branca</a></h3>
              <p class="preco">R$ 49,90</p>
              <p class="card-produto-loja">Loja Exemplo</p>
            </div>
          </article>
        </li>
      </ul>
    </section>

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
</body>
</html>
```


### Passo 4: crie a página do produto

**Arquivo: `produto.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Produto – VitrineCol</title>
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho">
    <div class="container cabecalho-conteudo">
      <a class="logotipo" href="index.html">VitrineCol</a>
      <nav aria-label="Principal">
        <ul class="menu">
          <li><a href="index.html">Início</a></li>
          <li><a href="catalogo.html">Catálogo</a></li>
          <li><a href="sacola.html">Sacola</a></li>
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <h1 id="titulo-produto">Vestido midi floral</h1>

    <article class="produto-detalhe" id="produto-detalhe">
      <section aria-label="Fotos do produto">
        <img class="galeria-principal" id="foto-principal" src="imagens/exemplo-1.svg" alt="Foto 1 de 3: Vestido midi floral" width="600" height="750">
        <ul class="galeria-miniaturas" id="miniaturas">
          <li><button type="button" class="miniatura" aria-current="true"><img src="imagens/exemplo-1.svg" alt="Ver a foto 1 de 3" width="600" height="750"></button></li>
          <li><button type="button" class="miniatura"><img src="imagens/exemplo-2.svg" alt="Ver a foto 2 de 3" width="600" height="750"></button></li>
          <li><button type="button" class="miniatura"><img src="imagens/exemplo-3.svg" alt="Ver a foto 3 de 3" width="600" height="750"></button></li>
        </ul>
      </section>

      <section class="produto-info" aria-label="Informações do produto">
        <p class="preco" id="preco-produto">R$ 129,90</p>
        <p>Vendido por <a id="link-loja" href="loja.html">Loja Exemplo</a></p>
        <p id="descricao-produto">Tecido leve, ideal para o verão</p>

        <form class="produto-compra" id="formulario-compra" novalidate aria-label="Adicionar à sacola">
          <fieldset class="campo" id="campo-tamanho">
            <legend>Tamanho</legend>
            <div class="tamanhos" id="tamanhos">
              <label class="tamanho-opcao"><input type="radio" name="tamanho" id="tamanho-0" value="P" aria-label="P"><span>P</span></label>
              <label class="tamanho-opcao"><input type="radio" name="tamanho" id="tamanho-1" value="M" aria-label="M"><span>M</span></label>
              <label class="tamanho-opcao"><input type="radio" name="tamanho" id="tamanho-2" value="G" disabled aria-label="G, sem estoque"><span>G</span></label>
            </div>
            <p class="campo-ajuda">Tamanhos riscados estão sem estoque.</p>
          </fieldset>

          <div class="campo">
            <label for="quantidade">Quantidade</label>
            <input type="number" id="quantidade" name="quantidade" min="1" step="1" value="1">
          </div>

          <button type="submit" class="botao" id="botao-adicionar">Adicionar à sacola</button>

        </form>
      </section>
    </article>

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
</body>
</html>
```


### Passo 5: percorra o caminho da cliente

Abra o `catalogo.html` no Live Server e siga o caminho, **só com cliques**:

1. No menu, clique em **Catálogo**; clique no nome de um produto: abre `produto.html`.
2. Na página do produto, clique em **Loja Exemplo**: abre `loja.html`.
3. Na página da loja, clique em um produto e depois no logotipo **VitrineCol**: volta ao início.
4. No menu, clique em **Entrar**: abre `login.html`.
5. Os links **Sacola**, **Cadastrar**, **Meus pedidos**, **Aviso de privacidade** e **Painel da loja** ainda levam a páginas que não existem. Isso é esperado.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Monta as páginas de catálogo, loja, produto e login"
git push
```

## Explicação do Código

**Os cards (`catalogo.html` e `loja.html`)**

- `<li>` ... `<article class="card-produto">`: cada produto é um item da lista e um `article` (um bloco que faz sentido sozinho).
- `<img class="card-produto-imagem" src="imagens/exemplo-1.svg" alt="Foto de Vestido midi floral" width="600" height="750">`: foto com `alt` descritivo. `width` e `height` guardam o espaço da imagem.
- `<h3 class="card-produto-titulo"><a href="produto.html">...</a></h3>`: o nome do produto é um título `h3` com um link para a página do produto. Mais tarde cada link terá o `id` do produto.
- `<p class="preco">R$ 129,90</p>` e `<p class="card-produto-loja">`: preço (no formato brasileiro, com vírgula) e nome da loja.

**loja.html**

- `<h1 id="titulo-loja">`: nome da loja. A `section` com `class="loja-resumo"` agrupa descrição, endereço e botões.
- `<dl>`, `<dt>` e `<dd>`: lista de **definições** (termo e valor): aqui, "Endereço" e o endereço.
- `<a class="botao botao-whatsapp" href="https://wa.me/5527999999999" target="_blank" rel="noopener">`: o botão do WhatsApp é um **link** que se parece com um botão. O formato `https://wa.me/número` é o endereço oficial do WhatsApp (o número tem só dígitos, com o código do país, 55). O `span` com `visualmente-oculto` avisa ao leitor de tela que o link abre em outra aba.
- `<a class="botao botao-secundario" ... href="https://www.google.com/maps">`: o botão **Ver no mapa**.

**produto.html**

- `<article class="produto-detalhe">`: o produto inteiro. Dentro, uma `section` das fotos e outra com as informações.
- A **foto grande** (`id="foto-principal"`) e a **lista de miniaturas**: cada miniatura é um `<button class="miniatura">` com uma imagem dentro. Usar `button` faz o teclado funcionar (Tab e Enter) sem código extra.
- `<form class="produto-compra" id="formulario-compra" novalidate>` com um `<fieldset>` e uma `<legend>Tamanho</legend>`: o grupo de tamanhos.
- Cada tamanho é um `<input type="radio" name="tamanho">` dentro de um `label`: "radio" permite escolher **um** só entre vários (todos têm o mesmo `name`). O tamanho G tem o atributo `disabled`: está sem estoque e não pode ser escolhido. O `aria-label` completa a informação para leitores de tela ("G, sem estoque").
- `<input type="number" id="quantidade" min="1" step="1" value="1">`: a quantidade, de no mínimo 1.
- `<button type="submit" class="botao" id="botao-adicionar">`: **Adicionar à sacola**. Ainda não faz nada.

**As imagens `exemplo-N.svg`**: seis desenhos de camiseta em cores diferentes. Servem como "fotos" até termos fotos reais.

## Validação

1. As quatro páginas abrem pelo Live Server.
2. O caminho do Passo 5 funciona só com cliques.
3. O catálogo mostra 3 cards, a loja mostra 2 e o produto mostra 3 miniaturas e 3 tamanhos (G desabilitado).
4. Todas as imagens têm `alt` e todos os campos têm `label` (confira com Ctrl+F procurando `<img` e `<input`).
5. O Outline do VS Code mostra um `h1` em cada página.

**Erros comuns**

1. *Sintoma:* as imagens dos cards aparecem quebradas. *Causa:* as imagens `exemplo-N.svg` não foram criadas, ou o nome da pasta/arquivo está diferente. *Correção:* confira a pasta `imagens` e os seis arquivos, com nomes idênticos aos do HTML.
2. *Sintoma:* ao clicar em um link aparece "Cannot GET /produto.html". *Causa:* o arquivo não foi salvo na raiz do projeto, ou o nome está errado. *Correção:* confira se `produto.html` está na mesma pasta do `index.html`.
3. *Sintoma:* os três tamanhos podem ser marcados juntos. *Causa:* os `input type="radio"` têm `name` diferentes. *Correção:* todos precisam do mesmo `name="tamanho"`.
4. *Sintoma:* o cabeçalho mostra o menu duplicado. *Causa:* o bloco `<header>` foi colado duas vezes. *Correção:* apague a cópia.

**Se travar**

1. Abra o **Console** (F12; em português: **Console**) e a aba **Network** (em português: **Rede**) para ver quais arquivos não foram encontrados (aparecem em vermelho com erro 404).
2. Compare o arquivo com o da aula e procure diferenças de nome em `href` e `src`.
3. Se um arquivo ficou irrecuperável, volte ao último commit com `git restore nome-do-arquivo`.
4. Só depois peça ajuda à sua equipe, informando a página, o link que falha e o que você já tentou.

**Seu projeto agora tem**

- `index.html`, `catalogo.html`, `loja.html`, `produto.html` e `login.html` (estáticas e navegáveis).
- `imagens/sem-foto.svg` e `imagens/exemplo-1.svg` a `exemplo-6.svg`.
- Ainda **sem CSS** e sem JavaScript.

**Como saber que deu certo:** você percorre catálogo, produto, loja e login só clicando, e nenhuma dessas quatro páginas dá erro.
