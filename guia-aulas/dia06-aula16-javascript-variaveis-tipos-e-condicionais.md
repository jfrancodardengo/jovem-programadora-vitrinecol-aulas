# Aula 16 – JavaScript: variáveis, tipos, operadores e condicionais

**Dia 6 · Qua 14/10/2026** · **Aula 16** · **UC3**

- **Requisitos cobertos:** não se aplica (base de programação; ensaia a regra RN-02: o preço deve ser maior que zero)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** 10 páginas HTML estáticas e 4 arquivos CSS completos, tag v0.1 no Git (Aula 15). O catalogo.html abre pelo Live Server

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai ligar um **script** a uma página como módulo (`type="module"`), usar o **Console** do navegador, criar **variáveis** (`let` e `const`), conhecer os **tipos** básicos, usar **operadores** e escrever as primeiras **condicionais** (`if`/`else`) com preço e estoque.

**Abertura (10 minutos).** Retomada da Aula 15: o front-end estático está pronto e marcado como v0.1. Mas o catálogo só mostra três cards **escritos à mão**. A partir de hoje o navegador passa a **calcular** e **decidir** coisas. Abra o `catalogo.html` no Live Server e aperte F12 > **Console** (em português: **Console**): é a janela onde o JavaScript "fala" com a gente.

## O Conceito

**Termos desta aula**

- **Variável**: uma "caixa com nome" que guarda um valor. `let preco = 129.9;` cria a caixa `preco`. Se o valor **pode mudar**, use `let`; se **nunca** muda, use `const` (padrão do projeto: prefira `const`).
- **Tipo**: o "formato" do valor. `"Vestido"` é texto (*string*), `129.9` é número (*number*), `true`/`false` são verdadeiro/falso (*boolean*).
- **Condicional (`if`/`else`)**: uma decisão: "**se** a condição for verdadeira, faça isto; **senão**, faça aquilo".
- **Módulo (`type="module"`)**: um arquivo JavaScript carregado de um jeito moderno, que permite dividir o código em vários arquivos (`import` e `export`, a partir da Aula 18).

**Operadores que usaremos:** aritméticos (`+`, `-`, `*`, `/`), de comparação (`>`, `<`, `>=`, `<=`, `===` "é exatamente igual", `!==` "é diferente") e lógicos (`&&` "e", `||` "ou", `!` "não").

**Analogia:** o JavaScript é a cozinheira que segue a receita: as **variáveis** são os potes etiquetados, o **if** é "se a massa já cresceu, leve ao forno; senão, espere", e o **Console** é o bilhete que ela deixa na bancada contando o que está fazendo.

**Por que isso importa para o projeto?** Regras como "o preço deve ser maior que zero" e "o produto só pode ser vendido se tiver estoque" (RN-02) são condicionais.

## Mão na Massa

### Passo 1: crie o arquivo de JavaScript

Crie as pastas `js` e, dentro dela, `paginas` (no painel **Explorer**, em português: **Explorador**, use **New Folder**, em português: **Nova Pasta**). Dentro de `js/paginas`, crie o arquivo `catalogo.js`:

**Arquivo: `js/paginas/catalogo.js`** (arquivo novo, inteiro)

```js
// Aula 16: primeiras regras em JavaScript. Abra o Console do navegador (F12) para ver as mensagens.
const nomeDoProduto = "Vestido midi floral";
let preco = 129.9;
const estoque = 3;

console.log("Produto:", nomeDoProduto);
console.log("Preço:", preco);
console.log("Tipo do preço:", typeof preco);

// Condicional: o produto só pode ser vendido se houver estoque
if (estoque > 0) {
  console.log(nomeDoProduto + " está disponível.");
} else {
  console.log(nomeDoProduto + " está esgotado.");
}

// Regra do projeto (RN-02): o preço precisa ser maior que zero
if (preco <= 0) {
  console.log("Preço inválido: ele precisa ser maior que zero.");
} else {
  console.log("Preço válido.");
}

// Operadores: um desconto de 10%
const desconto = 0.1;
const precoComDesconto = preco * (1 - desconto);
console.log("Com 10% de desconto:", precoComDesconto.toFixed(2));
```


### Passo 2: ligue o script à página

No `catalogo.html`, cole a linha do `<script>` **logo antes de `</body>`**:

**Arquivo: `catalogo.html`**: adicione este trecho logo antes da linha `</body>`:

```html
  <script type="module" src="js/paginas/catalogo.js"></script>
```


### Passo 3: leia as mensagens no Console

1. Abra o `catalogo.html` pelo Live Server e aperte F12 > **Console** (em português: **Console**).
2. Você deve ver as mensagens: o nome do produto, o preço, o tipo do preço (`number`), "disponível", "Preço válido." e o preço com desconto (`116.91`).

### Passo 4: exercícios curtos de preço e estoque

Faça um de cada vez, salve e olhe o Console:

1. Troque `const estoque = 3;` por `const estoque = 0;`. A mensagem muda para "esgotado".
2. Troque `let preco = 129.9;` por `let preco = -5;`. Aparece "Preço inválido".
3. Logo abaixo da linha `let preco = 129.9;` (volte o valor!) acrescente `preco = 139.9;` e veja o novo preço no Console. Isso só é permitido porque o preço é `let`.
4. Tente fazer o mesmo com o `estoque` (que é `const`): escreva `estoque = 1;`. O Console mostra um erro vermelho: `Assignment to constant variable.` (em português: "Atribuição a uma variável constante"). **Apague essa linha.**
5. Desafio: escreva uma condicional que mostre "Últimas unidades!" quando o estoque for maior que zero **e** menor que 3 (use `&&`).

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Liga o primeiro script ao catálogo e treina variáveis e condicionais"
git push
```

## Explicação do Código

- `const nomeDoProduto = "Vestido midi floral";`: guarda um texto. As aspas dizem que é *string*. O nome da variável está em **camelCase**: começa com letra minúscula e cada palavra nova começa com maiúscula, **sem acento**. Este é o padrão do projeto.
- `let preco = 129.9;`: guarda um número. Em JavaScript o decimal usa **ponto**, não vírgula.
- `console.log(...)`: escreve no Console. Você pode passar vários valores separados por vírgula.
- `typeof preco`: devolve o **tipo** do valor (aqui, `"number"`).
- `if (estoque > 0) { ... } else { ... }`: se `estoque > 0` for verdadeiro, roda o primeiro bloco; senão, o segundo. As chaves `{ }` delimitam cada bloco.
- `nomeDoProduto + " está disponível."`: o `+` com textos **junta** os textos (concatenação).
- `if (preco <= 0) { ... }`: a regra do projeto. `<=` significa "menor ou igual".
- `preco * (1 - desconto)`: 10% de desconto = pagar 90% do preço. Os parênteses mandam fazer a conta de dentro primeiro.
- `.toFixed(2)`: mostra o número com **2 casas decimais** (como texto). Valores em dinheiro serão mostrados no formato brasileiro (`R$ 116,91`) na Aula 19.
- Os textos que começam com `//` são **comentários**: o computador ignora, e eles explicam o **porquê** do código para quem o ler depois.
- `type="module"` no HTML: diz ao navegador que o arquivo é um módulo. Módulos são executados depois que a página carrega e permitem `import`.

## Validação

1. O Console mostra as 6 mensagens do Passo 3, sem erros em vermelho.
2. Com `estoque = 0` aparece "esgotado"; com `preco = -5` aparece "Preço inválido".
3. A tentativa de mudar uma `const` gerou o erro `Assignment to constant variable.` (e você apagou a linha).
4. Você escreveu a condicional do desafio e viu "Últimas unidades!" com estoque 1 ou 2.

**Erros comuns**

1. *Mensagem:* `Uncaught ReferenceError: estoqe is not defined`. *Causa:* o nome da variável foi digitado diferente de como foi criada. *Correção:* confira a grafia, letra por letra (JavaScript diferencia maiúsculas de minúsculas).
2. *Mensagem:* `Uncaught SyntaxError: Unexpected token ...`. *Causa:* falta uma aspa, um parêntese ou uma chave. *Correção:* o VS Code destaca em vermelho a linha com problema; confira se cada `(`, `{` e `"` tem o seu par.
3. *Sintoma:* nada aparece no Console. *Causa:* o `<script>` não foi ligado, ou o caminho está errado. *Correção:* confira no `catalogo.html` o `src="js/paginas/catalogo.js"` e, no F12 > **Network** (em português: **Rede**), se o arquivo foi carregado sem erro 404.
4. *Mensagem:* `Failed to load module script ... MIME type`. *Causa:* a página foi aberta direto do arquivo (endereço `file://`) e não pelo Live Server. *Correção:* abra sempre com o **Go Live** (em português: **Ir ao vivo**).

**Se travar**

1. Releia a mensagem vermelha do Console: ela mostra o nome do arquivo e o número da linha (`catalogo.js:12`). Clique nela para o navegador mostrar a linha.
2. Compare o seu arquivo com o da aula.
3. Se estragou o arquivo, volte ao último commit com `git restore js/paginas/catalogo.js` (ou volte a colar o código do Passo 1).
4. Só depois peça ajuda à sua equipe, colando a mensagem de erro exata.

**Seu projeto agora tem**

- As 10 páginas HTML estáticas e os 4 arquivos CSS.
- `js/paginas/catalogo.js` ligado a `catalogo.html`, treinando variáveis, tipos, operadores e condicionais no Console.

**Como saber que deu certo:** você troca o valor do estoque ou do preço, salva, e a mensagem do Console muda sozinha.
