# Aula 19 – Catálogo renderizado a partir de um array de objetos

**Dia 7 · Qui 15/10/2026** · **Aula 19** · **UC3**

- **Requisitos cobertos:** RF-01 (listar os produtos em cards com foto, nome, preço e loja; aqui com dados fictícios) e RF-21 (nunca deixar a tela em branco)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** js/ui/elementos.js, avisos.js e cabecalho.js; catalogo.js com 6 produtos fictícios e chips que reagem ao clique; catalogo.html com o cabeçalho vazio (Aula 18)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer o JavaScript **desenhar o catálogo**: um card por produto, com `createElement`, o preço em **R$** com `Intl.NumberFormat` e o **estado vazio** ("Nenhum produto encontrado") no lugar de uma tela em branco.

**Abertura (10 minutos).** Retomada da Aula 18: temos o cabeçalho e os avisos gerados pelo JavaScript e uma lista de 6 produtos fictícios guardada no `catalogo.js`. Já os cards do catálogo ainda são 3 pedaços de HTML **escritos à mão**. Hoje o HTML deixa de ter cards: o JavaScript os cria a partir da lista. Se a lista mudar, a página muda sozinha.

## O Conceito

**Termos desta aula**

- **Renderizar**: "desenhar" na página os dados que estão na memória. Aqui: transformar a lista de produtos em cards.
- **`createElement`**: cria um elemento HTML novo, que ainda não está na página. Depois é preciso **encaixá-lo** com `append` ou `replaceChildren`.
- **`Intl.NumberFormat`**: ferramenta do navegador que formata números de acordo com o país. Com `"pt-BR"` e a moeda `"BRL"`, `129.9` vira `R$ 129,90`.
- **Estado vazio**: o que a tela mostra quando não há dados. Em vez de um buraco em branco, uma mensagem clara ("Nenhum produto encontrado").

**Analogia:** o JavaScript agora é uma costureira com um molde (a função que monta o card). Você entrega o tecido (os dados) e ela corta quantos cards forem necessários, todos iguais, sem ninguém desenhar um por um.

**Regras do projeto:** valores em dinheiro sempre em **R$ com vírgula** (`Intl.NumberFormat`); dados dinâmicos entram na página só com `textContent` ou criando elementos (nunca `innerHTML`).

## Mão na Massa

### Passo 1: o formatador de preço

Crie `js/ui/formatadores.js`. Todas as funções de formatação ficam juntas neste arquivo:

**Arquivo: `js/ui/formatadores.js`** (arquivo novo, inteiro)

```js
// Funções que transformam valores em texto no padrão brasileiro (RNF-12).

// Criamos o formatador uma vez só; criar um novo a cada chamada seria desperdício.
const formatadorDeMoeda = new Intl.NumberFormat("pt-BR", {
  style: "currency",
  currency: "BRL",
});

// 189.9 -> "R$ 189,90"
export function formatarPreco(valor) {
  return formatadorDeMoeda.format(Number(valor));
}
```


### Passo 2: as importações do catalogo.js

No `js/paginas/catalogo.js`, troque o começo do arquivo (do primeiro comentário até a última linha de `import`) por:

**Arquivo: `js/paginas/catalogo.js`**: substitua o começo do arquivo, até a linha `import { mostrarCarregando, mostrarSucesso, limparAvisos } from "../ui/avisos.js";` (inclusive) por:

```js
// Página do catálogo: mostra os produtos e aplica os filtros. Por enquanto os produtos são fictícios (escritos neste arquivo).
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, limparAvisos } from "../ui/avisos.js";
import { criarElemento } from "../ui/elementos.js";
import { formatarPreco } from "../ui/formatadores.js";
```


### Passo 3: desenhe os cards

Ainda no `catalogo.js`, **mantenha a lista `produtosFicticios`** e troque **tudo o que vem depois dela** (a partir da linha `const listaChips = ...` até o fim do arquivo) por:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `const listaChips = document.getElementById("chips-categorias");` e termina na linha `FIM` (inclusive) por:

```js
const listaProdutos = document.getElementById("lista-produtos");
const mensagemVazio = document.getElementById("mensagem-vazio");

// Monta o card de UM produto só com o DOM (createElement + textContent), nunca com innerHTML (RNF-06).
// Devolve um <li> pronto para entrar na lista do catálogo.
function criarCardProduto(produto) {
  const item = document.createElement("li");
  const card = criarElemento("article", "card-produto");

  // Sem foto, usa a imagem padrão
  const imagem = criarElemento("img", "card-produto-imagem");
  imagem.src = produto.fotos[0] ?? "imagens/sem-foto.svg";
  imagem.alt = "Foto de " + produto.nome;
  imagem.width = 600;
  imagem.height = 750;
  imagem.loading = "lazy";

  const corpo = criarElemento("div", "card-produto-corpo");

  const titulo = criarElemento("h3", "card-produto-titulo");
  const link = criarElemento("a", "", produto.nome);
  link.href = "produto.html?id=" + encodeURIComponent(produto.id);
  titulo.append(link);

  const preco = criarElemento("p", "preco", formatarPreco(produto.preco));
  const loja = criarElemento("p", "card-produto-loja", produto.lojaNome);

  corpo.append(titulo, preco, loja);
  card.append(imagem, corpo);
  item.append(card);

  return item;
}

// Apaga os cards antigos e desenha os novos.
// Estado vazio: sem produto, aparece o aviso em vez de uma tela em branco.
function mostrarProdutos(produtos) {
  listaProdutos.replaceChildren(...produtos.map(criarCardProduto));
  mensagemVazio.hidden = produtos.length > 0;
}

function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  // O setTimeout finge a espera pelos dados; na Aula 28 ela vira uma espera de verdade
  setTimeout(() => {
    mostrarProdutos(produtosFicticios);
    limparAvisos();
  }, 600);
}

iniciar();
```


### Passo 4: esvazie a lista no HTML

No `catalogo.html`, os cards escritos à mão saem, e entra o aviso de lista vazia:

**Arquivo: `catalogo.html`**: substitua o trecho que começa na linha `<ul class="grade-produtos" id="lista-produtos">` e termina na linha `</ul>` (inclusive) por:

```html
      <ul class="grade-produtos" id="lista-produtos"></ul>
      <p class="aviso aviso-info" id="mensagem-vazio" role="status" hidden>Nenhum produto encontrado.</p>
```


### Passo 5: teste

1. Abra o `catalogo.html`. Aparece **Carregando…** por 0,6 segundo e depois os **6 cards**, com preço no formato `R$ 129,90`.
2. Clique em um card: abre a página do produto (ainda a página estática de exemplo).
3. **Teste do estado vazio:** no Console (F12 > **Console**, em português: **Console**) você não consegue chamar a função (ela é de módulo), então teste editando o código: troque `mostrarProdutos(produtosFicticios);` por `mostrarProdutos([]);`, salve e veja a mensagem **Nenhum produto encontrado.** Volte ao código original.
4. Acrescente um 7º produto à lista `produtosFicticios` e veja o 7º card aparecer sozinho.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Desenha o catálogo a partir de uma lista de produtos fictícios"
git push
```

## Explicação do Código

**formatadores.js**

- `new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" })`: cria o formatador **uma vez** (criar um novo a cada chamada seria desperdício). `style: "currency"` pede formato de dinheiro e `currency: "BRL"` escolhe o real.
- `export function formatarPreco(valor) { return formatadorDeMoeda.format(Number(valor)); }`: recebe um número (ou um texto numérico), converte com `Number(...)` e devolve o texto. O Intl coloca um **espaço não separável** entre `R$` e o número; ele não é visível, mas impede a quebra de linha ali.

**catalogo.js**

- Os `import` trazem `criarElemento` e `formatarPreco`; os de `mostrarSucesso` e das chips saíram porque este arquivo não os usa mais agora.
- `const listaProdutos = document.getElementById("lista-produtos");`: guarda o `ul` onde os cards vão entrar; `mensagemVazio` guarda o parágrafo de "Nenhum produto".
- `criarCardProduto(produto)`: monta o card com `criarElemento`, seguindo **exatamente** o HTML que você escreveu à mão na Aula 9: `li` > `article.card-produto` > `img` + `div.card-produto-corpo` (com `h3` > `a`, `p.preco` e `p.card-produto-loja`). Detalhes:
  - `produto.fotos[0] ?? "imagens/sem-foto.svg"`: o operador `??` ("se for vazio") usa a imagem padrão quando o produto não tem foto.
  - `imagem.alt = "Foto de " + produto.nome;`: todo `img` precisa de `alt`.
  - `imagem.loading = "lazy"`: o navegador só baixa a foto quando ela está perto de aparecer.
  - `"produto.html?id=" + encodeURIComponent(produto.id)`: o `?id=...` leva o código do produto para a página do produto (Aula 34). `encodeURIComponent` protege caracteres especiais.
  - `corpo.append(titulo, preco, loja)`: `append` aceita vários elementos de uma vez.
- `mostrarProdutos(produtos)`: `produtos.map(criarCardProduto)` transforma **cada produto em um card** (devolve uma lista de cards); `...` ("espalhar") entrega os cards um a um para `replaceChildren`, que **troca** tudo o que estava na lista pelos novos. `mensagemVazio.hidden = produtos.length > 0;` esconde a mensagem se houver produtos e mostra se a lista vier vazia.
- `iniciar()`: monta o cabeçalho, mostra "Carregando…" e usa `setTimeout` para **fingir** a espera de dados; depois mostra os produtos e limpa o aviso. Na Aula 28 essa espera será real.

**catalogo.html**: a lista ficou vazia (`<ul ... id="lista-produtos"></ul>`) e ganhou o parágrafo `mensagem-vazio` com o atributo `hidden`, que o JavaScript liga e desliga.

## Validação

1. O catálogo mostra **Carregando…** e depois 6 cards, cada um com foto, nome, preço em R$ com vírgula e loja.
2. Com a lista vazia, aparece "Nenhum produto encontrado." em vez de uma tela em branco.
3. Um 7º produto aparece sozinho.
4. No Console não há erros, e nenhum arquivo do projeto usa `innerHTML`: procure com Ctrl+Shift+F (Cmd+Shift+F no Mac) e confirme **0 resultados** em `js/`.

**Erros comuns**

1. *Mensagem:* `Uncaught TypeError: Cannot read properties of null (reading 'replaceChildren')`. *Causa:* o `id` do `ul` no HTML é diferente do `getElementById`. *Correção:* o HTML precisa ter `id="lista-produtos"`.
2. *Sintoma:* o preço aparece como `129.9`. *Causa:* o valor foi mostrado direto, sem `formatarPreco`. *Correção:* use `formatarPreco(produto.preco)`.
3. *Sintoma:* aparecem os 6 cards **e** os 3 antigos. *Causa:* os cards escritos à mão continuam no HTML. *Correção:* faça o Passo 4 (a lista `ul` deve estar vazia).
4. *Mensagem:* `The requested module ... does not provide an export named 'formatarPreco'`. *Causa:* falta o `export` na frente da função, ou o arquivo `formatadores.js` tem erro. *Correção:* confira a palavra `export` e o nome da função.

**Se travar**

1. Leia o primeiro erro vermelho do Console (F12) e clique no nome do arquivo e linha.
2. Compare `catalogo.js` e `formatadores.js` com os da aula.
3. Volte ao último commit com `git restore js/paginas/catalogo.js catalogo.html` e refaça os Passos 2 a 4.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/ui/formatadores.js` com `formatarPreco`.
- `catalogo.js` desenhando o catálogo a partir de dados fictícios, com estado vazio.
- `catalogo.html` com a lista vazia, que o JavaScript preenche.

**Como saber que deu certo:** você acrescenta um produto à lista, salva, e o novo card aparece com o preço em R$.
