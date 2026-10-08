# Aula 17 – Funções, arrays e objetos

**Dia 6 · Qua 14/10/2026** · **Aula 17** · **UC3**

- **Requisitos cobertos:** não se aplica (dados fictícios que a Aula 19 desenha como catálogo; ensaia RN-02)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** js/paginas/catalogo.js ligado ao catalogo.html como módulo, treinando variáveis e condicionais no Console (Aula 16)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai escrever **funções** pequenas (com parâmetros e retorno), representar um **produto como objeto** e uma lista de produtos como **array**, e percorrê-la com `for...of`.

**Abertura (10 minutos).** Retomada da Aula 16: variáveis e condicionais já funcionam, mas cada produto exigiria uma variável nova para nome, preço, estoque... Imagine 6 produtos: 6 variáveis para cada dado. Hoje aprendemos a **juntar** os dados de um produto em **um** objeto e os produtos em **uma** lista. Abra o `catalogo.js` e confirme que ele ainda mostra as mensagens no Console.

## O Conceito

**Termos desta aula**

- **Função**: um bloco de código com nome, que faz uma tarefa e pode ser **chamado** quantas vezes quiser. Recebe **parâmetros** (valores de entrada) e devolve um resultado com **`return`**.
- **Objeto**: um conjunto de dados de uma "coisa", escrito entre chaves, em pares `nome: valor`. Ex.: `{ nome: "Vestido midi floral", preco: 129.9 }`. Para ler um dado: `produto.nome`.
- **Array**: uma **lista** de valores, entre colchetes, separados por vírgula. Cada posição tem um número, **começando em 0**: `lista[0]` é o primeiro.
- **Laço (`for...of`)**: repete um bloco de código **para cada item** de uma lista.

**Analogia:** o objeto é uma **ficha** de cadastro de um produto (campos nomeados); o array é a **gaveta** com todas as fichas; a função é um **funcionário** que você chama pelo nome ("some o estoque desta ficha") e que devolve a resposta; o `for...of` é "pegue ficha por ficha".

**Regra do projeto:** funções **pequenas**, uma tarefa cada, com nome que diz o que fazem (`temEstoque`, `somarEstoque`), em camelCase e sem acento.

## Mão na Massa

### Passo 1: substitua o conteúdo do catalogo.js

A lista de produtos fictícios usa as mesmas propriedades que a classe `Produto` terá na Aula 22: `id`, `nome`, `descricao`, `preco`, `categoria`, `lojaId`, `lojaNome`, `tamanhos` e `fotos`. Troque todo o conteúdo do `js/paginas/catalogo.js` por:

**Arquivo: `js/paginas/catalogo.js`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```js
// Aula 17: funções, arrays e objetos. Os produtos são dados fictícios, só para treinar.
// Cada produto é um objeto com as mesmas propriedades que a classe Produto terá (Aula 22).
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

// Uma função pequena: recebe um produto e um tamanho e devolve true ou false
function temEstoque(produto, tamanho) {
  const item = produto.tamanhos.find((t) => t.tamanho === tamanho);
  return item !== undefined && item.estoque > 0;
}

// Soma o estoque de todos os tamanhos de um produto
function somarEstoque(produto) {
  let total = 0;
  for (const item of produto.tamanhos) {
    total += item.estoque;
  }
  return total;
}

// Subtotal de uma linha da sacola (preço vezes quantidade)
function calcularSubtotal(preco, quantidade) {
  return preco * quantidade;
}

// Percorre a lista com for...of e mostra um resumo de cada produto no Console
for (const produto of produtosFicticios) {
  console.log(produto.nome + " (" + produto.lojaNome + "): estoque total " + somarEstoque(produto));
}

console.log("Vestido tem estoque no G?", temEstoque(produtosFicticios[0], "G"));
console.log("Duas camisetas custam", calcularSubtotal(produtosFicticios[1].preco, 2).toFixed(2));
```


### Passo 2: leia o resultado no Console

Abra o `catalogo.html` pelo Live Server e veja o Console (F12 > **Console**, em português: **Console**). Devem aparecer 6 linhas, uma por produto (com o estoque total), e depois duas respostas: se o vestido tem estoque no tamanho G (`false`) e o subtotal de duas camisetas (`99.80`).

### Passo 3: exercícios

1. Em `produtosFicticios[0]`, mude o `estoque` de G para `2`. A resposta "Vestido tem estoque no G?" passa a ser `true`.
2. Escreva uma função `calcularDesconto(preco, percentual)` que devolva o preço com desconto (por exemplo, `calcularDesconto(100, 10)` devolve `90`). Chame-a no Console com `console.log(calcularDesconto(129.9, 20))`.
3. Acrescente um **7º produto** à lista, com os mesmos campos (use `exemplo-1.svg` como foto) e veja que o laço o mostra sozinho, sem você mudar o código do laço.
4. Mostre no Console só o nome da **última** peça: `console.log(produtosFicticios[produtosFicticios.length - 1].nome)`.

### Passo 4: faça o commit da aula

```bash
git add .
git commit -m "Cria a lista de produtos fictícios e as primeiras funções"
git push
```

## Explicação do Código

- `const produtosFicticios = [ { ... }, { ... } ];`: um **array de objetos**. Os colchetes `[ ]` formam a lista; cada `{ ... }` é um produto. Os produtos são separados por vírgula.
- Dentro de cada produto: `tamanhos: [ { tamanho: "P", estoque: 3 }, ... ]` é uma lista **dentro** do objeto: cada tamanho é um pequeno objeto com o nome e o estoque. `fotos: ["imagens/exemplo-1.svg"]` é uma lista de textos.
- `function temEstoque(produto, tamanho) { ... }`: define a função. `produto` e `tamanho` são os **parâmetros**.
- `produto.tamanhos.find((t) => t.tamanho === tamanho)`: `find` percorre a lista e devolve o **primeiro** item que satisfaz a condição, ou `undefined` se nenhum satisfaz. `(t) => ...` é uma **função seta** (uma função curta, sem nome): para cada `t` (cada tamanho), testa se o nome dele é o procurado.
- `return item !== undefined && item.estoque > 0;`: devolve `true` só se o tamanho existe **e** tem estoque. É a regra "o tamanho só serve se existir E tiver estoque".
- `function somarEstoque(produto) { let total = 0; for (const item of produto.tamanhos) { total += item.estoque; } return total; }`: começa com 0, passa por cada tamanho (`for...of`) e acumula o estoque (`total += x` é o mesmo que `total = total + x`).
- `function calcularSubtotal(preco, quantidade) { return preco * quantidade; }`: o exemplo mais simples de função com retorno.
- `for (const produto of produtosFicticios) { ... }`: "para cada produto da lista, faça". Aqui chama `somarEstoque(produto)` e escreve no Console.
- `produtosFicticios[0]`: o primeiro produto (a posição começa em 0). `produtosFicticios[1].preco` é o preço do segundo.

## Validação

1. O Console mostra 6 linhas de resumo, `false` para o vestido no G e `99.80` para as duas camisetas.
2. A sua função `calcularDesconto(100, 10)` devolve `90`.
3. O 7º produto aparece no laço sem mudar o laço.
4. Não há erros em vermelho no Console.

**Erros comuns**

1. *Mensagem:* `Uncaught TypeError: Cannot read properties of undefined (reading 'nome')`. *Causa:* você pediu uma posição que não existe (por exemplo `produtosFicticios[6]` quando a lista tem 6 itens, pois a última posição é a 5). *Correção:* lembre que a contagem começa em 0.
2. *Mensagem:* `Uncaught SyntaxError: Unexpected token '}'`. *Causa:* faltou uma vírgula entre dois objetos da lista, ou sobrou/faltou uma chave. *Correção:* cada objeto termina com `},` (menos o último, onde a vírgula é opcional).
3. *Sintoma:* a função "não devolve nada" (`undefined` no Console). *Causa:* faltou o `return`. *Correção:* a função precisa devolver o resultado com `return`.
4. *Mensagem:* `temEstoque is not a function`. *Causa:* o nome foi escrito de outro jeito ao chamar. *Correção:* confira a grafia, com atenção às maiúsculas.

**Se travar**

1. Leia a mensagem vermelha do Console, com o arquivo e a linha, e vá até lá.
2. Compare o arquivo com o da aula, principalmente as vírgulas, chaves e colchetes.
3. Volte ao último commit com `git restore js/paginas/catalogo.js` e repita o Passo 1.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata.

**Seu projeto agora tem**

- `js/paginas/catalogo.js` com 6 produtos fictícios (array de objetos) e 3 funções pequenas que os percorrem.
- Todo o resto como na Aula 16 (HTML e CSS).

**Como saber que deu certo:** você acrescenta um produto à lista, salva, e o Console o mostra sem que você mude o laço.
