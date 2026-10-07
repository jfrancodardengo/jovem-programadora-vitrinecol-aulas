# Aula 24 – Tratamento de erros (try/catch) e módulos

**Dia 8 · Sex 16/10/2026** · **Aula 24** · **UC3**

- **Requisitos cobertos:** RF-21 (avisar o erro com mensagem em português e nunca deixar a tela em branco)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** ErroApp, Produto, Loja, Usuaria, Cliente e Lojista; catalogo.js com filtros fictícios e agregação loja-produtos (Aulas 22 e 23)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **tratar erros com `try/catch`** usando o `ErroApp` e mostrar uma mensagem clara em português na tela (em vez de uma tela em branco), e vai **reorganizar o código em módulos** (`import`/`export`), com um arquivo por responsabilidade nas pastas `modelos`, `ui` e `paginas`.

**Abertura (10 minutos).** Retomada da Aula 23: se você trocar o preço de um produto por `0`, as classes recusam, mas o catálogo fica **em branco** e só o Console conta o motivo. A cliente nunca abre o Console. Abra o `catalogo.js` e conte quantas responsabilidades ele tem hoje (dados, filtros, desenhar o card, eventos...). Hoje o card vai para um arquivo próprio e os erros ganham tratamento.

## O Conceito

**Termos desta aula**

- **`try/catch`**: "**tente** isto; se der erro, **pegue** o erro e faça aquilo". O erro lançado com `throw` dentro do `try` cai no `catch`, e o programa **continua** (em vez de parar).
- **Módulo**: um arquivo JavaScript que **exporta** (`export`) o que outros podem usar e **importa** (`import`) o que precisa de outros. Cada módulo cuida de **uma responsabilidade**.
- **Exportação nomeada**: `export function criarCardProduto() {}` e, em outro arquivo, `import { criarCardProduto } from "../ui/cards.js";`. O nome entre chaves tem de ser igual.

**Analogia:** o `try/catch` é a **rede de proteção** de um circo: o trapezista (o código) pode errar, mas a rede evita o desastre e o espetáculo continua. Os módulos são as **gavetas de uma cozinha**: talheres em uma, panelas em outra. Para achar a concha, você sabe qual gaveta abrir.

**Onde cada coisa mora no projeto:**

| Pasta | O que guarda | Exemplos |
| --- | --- | --- |
| `js/modelos/` | classes com os dados e as regras | `Produto`, `Loja`, `ErroApp` |
| `js/ui/` | peças de tela reaproveitadas | `cabecalho`, `avisos`, `cards`, `elementos`, `formatadores` |
| `js/paginas/` | um arquivo por tela, só "liga" as peças | `catalogo.js` |
| `js/servicos/` | conversa com o banco (a partir da Aula 29) | `produtoServico.js` |

## Mão na Massa

### Passo 1: o card ganha o seu próprio arquivo

Crie `js/ui/cards.js`. A função é a mesma `criarCardProduto` que estava no `catalogo.js`, agora com `export`:

**Arquivo: `js/ui/cards.js`** (arquivo novo, inteiro)

```js
// Monta o card de um produto usando só o DOM (createElement + textContent), sem montar HTML em texto (RNF-06).
// Recebe um objeto Produto (js/modelos/Produto.js): ele já sabe formatar o preço e escolher a capa.
import { criarElemento } from "./elementos.js";

// Devolve um <li> pronto para ser colocado dentro da lista do catálogo.
export function criarCardProduto(produto) {
  const item = document.createElement("li");
  const card = criarElemento("article", "card-produto");

  // fotoCapa() devolve a primeira foto, ou a imagem padrão quando o produto não tem foto
  const imagem = criarElemento("img", "card-produto-imagem");
  imagem.src = produto.fotoCapa();
  imagem.alt = "Foto de " + produto.nome;
  imagem.width = 600;
  imagem.height = 750;
  imagem.loading = "lazy";

  const corpo = criarElemento("div", "card-produto-corpo");

  const titulo = criarElemento("h3", "card-produto-titulo");
  const link = criarElemento("a", "", produto.nome);
  link.href = "produto.html?id=" + encodeURIComponent(produto.id);
  titulo.append(link);

  const preco = criarElemento("p", "preco", produto.precoFormatado());
  const loja = criarElemento("p", "card-produto-loja", produto.lojaNome);

  corpo.append(titulo, preco, loja);
  card.append(imagem, corpo);
  item.append(card);

  return item;
}
```


### Passo 2: avisos mais completos

Em `js/ui/avisos.js`, a primeira linha do arquivo passa a ser seguida pelo `import` do `ErroApp`:

**Arquivo: `js/ui/avisos.js`**: substitua a linha `// Avisos de carregamento, erro e sucesso (RF-21).` por:

```js
// Avisos de carregamento, erro e sucesso (RF-21).
import { ErroApp } from "../modelos/ErroApp.js";
```


E, **logo antes** da linha `// ---------- Erros ao lado de cada campo de formulário ----------`, cole as duas funções novas:

**Arquivo: `js/ui/avisos.js`**: adicione este trecho logo antes da linha `// ---------- Erros ao lado de cada campo de formulário ----------`:

```js
// O ErroApp já vira mensagem na tela, então só o detalhe técnico (a causa) vai para o console, para quem depura.
// Um erro inesperado (que não é ErroApp) sempre vai para o console como erro.
export function registrarErro(erro) {
  if (!(erro instanceof ErroApp)) {
    console.error(erro);
  } else if (erro.cause) {
    console.warn(erro.codigo, erro.cause);
  }
}

// Mostra a mensagem pronta do ErroApp; qualquer outro erro inesperado recebe uma mensagem geral.
export function mensagemDoErro(erro) {
  return erro instanceof ErroApp
    ? erro.mensagemParaUsuaria
    : "Algo deu errado. Recarregue a página e tente novamente.";
}

```


### Passo 3: o catálogo trata os erros

No `js/paginas/catalogo.js`, faça as trocas na ordem. (1) As importações: o catálogo agora importa o card de `cards.js` e as funções de erro de `avisos.js`:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `import { mostrarCarregando, limparAvisos } from "../ui/avisos.js";` e termina na linha `import { criarElemento } from "../ui/elementos.js";` (inclusive) por:

```js
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, registrarErro } from "../ui/avisos.js";
import { criarCardProduto } from "../ui/cards.js";
```


(2) A criação das lojas e dos produtos sai do corpo do arquivo (ela vai para uma função, no item 4):

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `const lojas = [` e termina na linha `});` (inclusive) por:

```js
// As lojas (cada uma com os seus produtos) são criadas dentro de iniciar(), para um erro nos dados poder ser tratado
let lojas = [];
```


(3) O card saiu para `cards.js`: apague a função `criarCardProduto` daqui.

**Arquivo: `js/paginas/catalogo.js`**: apague a função `criarCardProduto` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


(4) Cole a função que cria os dados **logo antes** da função `iniciar`:

**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`carregarLojasFicticias`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Os dados continuam fictícios. Devolve as lojas já com os seus produtos; se algum dado for inválido,
// o Produto ou a Loja lançam um ErroApp, e quem chamou decide o que mostrar na tela.
function carregarLojasFicticias() {
  const lojasCriadas = [
    new Loja({
      id: "l1",
      nome: "Loja Exemplo",
      descricao: "Moda feminina casual e confortável",
      endereco: "Rua das Flores, 100, Centro",
      cidade: "Cidade Exemplo",
      whatsapp: "5527999999999",
    }),
    new Loja({
      id: "l2",
      nome: "Loja do Bairro",
      endereco: "Avenida Central, 250",
      cidade: "Cidade Exemplo",
      whatsapp: "5527988888888",
    }),
  ];

  // Cada produto fictício vira um objeto Produto: as regras de preço e estoque ficam dentro da classe
  const produtos = produtosFicticios.map((dados) => new Produto(dados));

  // Agregação: cada produto entra na lista da sua loja (a Loja TEM Produtos)
  produtos.forEach((produto) => {
    const loja = lojasCriadas.find((outra) => outra.id === produto.lojaId);
    loja.adicionarProduto(produto);
  });

  return lojasCriadas;
}
```


(5) Troque a função `iniciar` pela versão com `try/catch`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  // O setTimeout finge a espera pelos dados; na Aula 28 ela vira uma espera de verdade
  setTimeout(() => {
    try {
      lojas = carregarLojasFicticias();
      preencherCategorias(categoriasFicticias);
      preencherLojas(lojas);
      configurarFiltros();
      atualizarCatalogo();
      limparAvisos();
    } catch (erro) {
      // Um dado inválido (ErroApp) ou um erro inesperado: mensagem em português em vez de tela em branco (RF-21)
      registrarErro(erro);
      mostrarErro(mensagemDoErro(erro));
    }
  }, 600);
}
```


### Passo 4: teste os erros

1. Abra o catálogo: funciona como antes.
2. **Provoque um erro:** em `produtosFicticios`, troque o preço do primeiro produto por `0`. Recarregue: aparece uma **caixa vermelha** com `O preço deve ser maior que zero.` em vez de uma tela em branco. O Console não mostra mais nada (o `ErroApp` já virou mensagem na tela). Volte o preço para `129.9`.
3. **Provoque um erro inesperado:** troque `lojas.find(...)` por `lojasX.find(...)` dentro de `carregarLojasFicticias` (um nome que não existe). Recarregue: aparece a caixa vermelha **"Algo deu errado. Recarregue a página e tente novamente."** e o Console mostra o erro técnico para quem depura. Desfaça.
4. Confira a organização: `js/modelos`, `js/ui` e `js/paginas` (e nenhuma função de card dentro de `catalogo.js`).

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Trata erros com try/catch e move o card para o módulo cards.js"
git push
```

## Explicação do Código

**cards.js**

- `import { criarElemento } from "./elementos.js";`: o `./` quer dizer "na mesma pasta" (`js/ui`).
- `export function criarCardProduto(produto)`: o mesmo código da Aula 19/22, mas num arquivo que **só** cuida de montar o card. A partir daqui, qualquer página (o catálogo, a loja, a página inicial) o reutiliza com um `import`.

**avisos.js**

- `registrarErro(erro)`: decide o que vai para o **Console**. Um `ErroApp` já vira mensagem na tela, então só o detalhe técnico (`erro.cause`, o erro original) é registrado com `console.warn`. Um erro **inesperado** (que não é `ErroApp`) vai sempre para o Console como `console.error`. `instanceof ErroApp` pergunta se o erro é do nosso tipo.
- `mensagemDoErro(erro)`: devolve a `mensagemParaUsuaria` se for um `ErroApp`; para qualquer outro erro devolve a frase geral "Algo deu errado. Recarregue a página e tente novamente." A cliente nunca vê uma mensagem técnica em inglês.

**catalogo.js**

- `carregarLojasFicticias()`: agora cria as lojas e os produtos **dentro de uma função**. Se um dado for inválido, o `ErroApp` é lançado **de dentro** dela.
- Em `iniciar()`: `try { ... } catch (erro) { registrarErro(erro); mostrarErro(mensagemDoErro(erro)); }`. O bloco `try` roda o fluxo normal (criar dados, preencher filtros, mostrar produtos). Se qualquer linha lançar um erro, o programa **pula** para o `catch`, que registra o detalhe no Console e mostra a mensagem na tela. Assim cumpre o **RF-21**: o erro é avisado em português e a tela não fica em branco.
- `let lojas = [];`: com `let` porque o valor é trocado dentro de `iniciar()` (`lojas = carregarLojasFicticias();`).

## Validação

1. O catálogo continua funcionando (filtros, preços, estado vazio).
2. Com preço `0`, aparece uma caixa vermelha com a mensagem em português, e a tela **não** fica em branco.
3. Com um erro de programação, aparece a mensagem geral e o Console mostra o detalhe técnico.
4. `catalogo.js` não tem mais a função do card; `cards.js` existe em `js/ui`.
5. A busca por `innerHTML` em `js/` (Ctrl+Shift+F, ou Cmd+Shift+F no Mac) tem **0 resultados**.

**Erros comuns**

1. *Mensagem:* `The requested module '../ui/cards.js' does not provide an export named 'criarCardProduto'`. *Causa:* falta o `export` na função. *Correção:* `export function criarCardProduto`.
2. *Sintoma:* o erro não é capturado, o catálogo fica em branco. *Causa:* a criação dos dados ficou **fora** do `try` (por exemplo, ainda no topo do arquivo). *Correção:* faça o item 2 do Passo 3: a criação fica dentro de `carregarLojasFicticias()`, chamada **dentro** do `try`.
3. *Mensagem:* `Cannot access 'lojas' before initialization`. *Causa:* `lojas` foi declarada com `const` e atribuída de novo. *Correção:* use `let lojas = [];`.
4. *Sintoma:* a mensagem do erro aparece em inglês. *Causa:* o erro não é um `ErroApp` e a mensagem foi mostrada direto, sem `mensagemDoErro`. *Correção:* sempre use `mostrarErro(mensagemDoErro(erro))`.

**Se travar**

1. Leia a mensagem do Console com arquivo e linha e confira se o `import` e o `export` têm o mesmo nome.
2. Faça uma troca do Passo 3 de cada vez e recarregue entre elas.
3. Compare com a aula; se preciso, volte com `git restore js/paginas/catalogo.js js/ui/avisos.js`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/modelos/` (`ErroApp`, `Produto`, `Loja`, `Usuaria`, `Cliente`, `Lojista`), `js/ui/` (`elementos`, `avisos`, `cabecalho`, `formatadores`, `cards`) e `js/paginas/` (`catalogo.js`, `painelProdutoForm.js`) e `js/servicos/produtoServico.js` (só a validação).
- Catálogo com dados fictícios, filtros, tratamento de erros e mensagem em português. Com isso termina o **Módulo 2** (JavaScript e orientação a objetos).

**Como saber que deu certo:** você coloca um preço inválido, recarrega e vê a **mensagem vermelha em português** na tela, em vez de uma página em branco.
