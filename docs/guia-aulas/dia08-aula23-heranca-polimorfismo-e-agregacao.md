# Aula 23 – Herança, polimorfismo e agregação: Usuaria, Cliente e Lojista

**Dia 8 · Sex 16/10/2026** · **Aula 23** · **UC3**

- **Requisitos cobertos:** RN-01 (cada lojista tem no máximo uma loja), RN-08 (produto inativo não aparece no catálogo) e RN-11 (o perfil, cliente ou lojista, é escolhido no cadastro e não muda depois)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** classes ErroApp, Produto e Loja; catalogo.js usando objetos Produto e Loja (Aula 22)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai usar **herança** (`Cliente` e `Lojista` vindos de `Usuaria`), **polimorfismo** (cada perfil responde a sua página inicial com o mesmo método, `rotaInicial()`) e **agregação** (a `Loja` guarda uma lista de `Produto`, e o catálogo usa isso).

**Abertura (10 minutos).** Retomada da Aula 22: as classes `Produto` e `Loja` guardam as regras dos seus dados. A `Loja` já tem uma lista de produtos (`#produtos`) que você escreveu sem usar. Hoje vamos usá-la. E vamos criar quem usa o sistema: a cliente e a lojista. Antes de começar, responda em voz alta: o que uma cliente e uma lojista têm em **comum** (nome, e-mail) e o que elas têm de **diferente** (a tela que abrem ao entrar)?

## O Conceito

**Termos desta aula**

- **Herança (`extends`)**: uma classe "filha" **herda** tudo da classe "mãe" e só acrescenta o que é diferente. `Cliente` e `Lojista` herdam de `Usuaria` o `id`, o `nome` e o `email`, sem repetir código.
- **Polimorfismo**: "muitas formas". Vários objetos respondem à **mesma chamada** (`rotaInicial()`), cada um do seu jeito: a cliente vai para `index.html`, a lojista para `painel-loja.html`. Quem chama não precisa saber quem é quem.
- **Agregação**: a relação "**tem**". A `Loja` **tem** `Produto`s: ela os guarda em uma lista, mas cada produto continua sendo um objeto independente, com as suas regras.
- **`instanceof`**: pergunta se um objeto foi criado a partir de uma classe (ou de uma classe filha dela): `marina instanceof Usuaria` é `true`.

**Analogia:** a herança é a "família": todos os filhos herdam o sobrenome, mas cada um tem o seu jeito. O polimorfismo é você gritar "**hora do almoço!**" e cada pessoa ir para um lugar diferente. A agregação é a **estante** da loja: ela tem livros, mas se a estante for desmontada, os livros continuam existindo.

**Regras do projeto:** RN-11: o perfil é escolhido no cadastro e **não muda depois**. No código, o perfil é a própria classe (`Cliente` ou `Lojista`), e nenhum método permite transformar uma em outra.

## Mão na Massa

### Passo 1: a classe Usuaria e as duas filhas

Crie, em `js/modelos`, os três arquivos:

**Arquivo: `js/modelos/Usuaria.js`** (arquivo novo, inteiro)

```js
// Classe base de quem usa o sistema. Cliente e Lojista herdam dela (herança).
import { ErroApp } from "./ErroApp.js";

export class Usuaria {
  // Campos privados (#): só o código desta classe enxerga. Quem está de fora lê pelos getters.
  #id;
  #nome;
  #email;

  constructor({ id, nome, email }) {
    if (typeof nome !== "string" || nome.trim() === "") {
      throw new ErroApp("nome_invalido", "Informe o nome.");
    }

    this.#id = id;
    this.#nome = nome.trim();
    this.#email = email;
  }

  get id() {
    return this.#id;
  }

  get nome() {
    return this.#nome;
  }

  get email() {
    return this.#email;
  }

  // Polimorfismo: toda usuária tem uma página inicial, mas cada perfil escolhe a sua.
  // Aqui na base não existe resposta certa, então as filhas precisam sobrescrever este método.
  rotaInicial() {
    throw new ErroApp(
      "metodo_nao_implementado",
      "Este perfil ainda não definiu a sua página inicial."
    );
  }
}
```


**Arquivo: `js/modelos/Cliente.js`** (arquivo novo, inteiro)

```js
// Cliente é uma Usuaria (herança): já ganha id, nome, email e os getters, sem repetir código.
import { Usuaria } from "./Usuaria.js";

export class Cliente extends Usuaria {
  // Polimorfismo: sobrescreve o método da classe base com a resposta da cliente.
  rotaInicial() {
    return "index.html";
  }
}
```


**Arquivo: `js/modelos/Lojista.js`** (arquivo novo, inteiro)

```js
// Lojista também é uma Usuaria (herança), mas a sua página inicial é o painel.
import { Usuaria } from "./Usuaria.js";

export class Lojista extends Usuaria {
  // Mesmo nome de método do Cliente, resposta diferente: isso é polimorfismo.
  rotaInicial() {
    return "painel-loja.html";
  }
}
```


### Passo 2: veja a herança e o polimorfismo no Console

Abra o `catalogo.html` pelo Live Server, aperte F12 > **Console** (em português: **Console**) e cole:

```js
const { Usuaria } = await import("/js/modelos/Usuaria.js");
const { Cliente } = await import("/js/modelos/Cliente.js");
const { Lojista } = await import("/js/modelos/Lojista.js");

const marina = new Cliente({ id: "1", nome: "Marina", email: "marina@exemplo.com" });
const celia = new Lojista({ id: "2", nome: "Célia", email: "celia@exemplo.com" });

console.log(marina.nome, "->", marina.rotaInicial());
console.log(celia.nome, "->", celia.rotaInicial());
console.log(marina instanceof Usuaria, marina instanceof Cliente, marina instanceof Lojista);

try {
  new Usuaria({ id: "3", nome: "Sem perfil" }).rotaInicial();
} catch (erro) {
  console.log(erro.codigo);
}
```

Devem aparecer `Marina -> index.html`, `Célia -> painel-loja.html`, `true true false` e `metodo_nao_implementado`.

### Passo 3: use a agregação no catálogo

No `js/paginas/catalogo.js`, faça duas trocas. Primeiro, **depois** de criar os produtos, cada um entra na lista da sua loja:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `const produtos = produtosFicticios.map((dados) => new Produto(dados));` por:

```js
const produtos = produtosFicticios.map((dados) => new Produto(dados));

// Agregação: cada produto entra na lista da sua loja (a Loja TEM Produtos)
produtos.forEach((produto) => {
  const loja = lojas.find((outra) => outra.id === produto.lojaId);
  loja.adicionarProduto(produto);
});
```


Segundo, o catálogo passa a listar só os produtos **ativos** de cada loja. Troque a função `atualizarCatalogo`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a função `atualizarCatalogo` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Aplica os filtros atuais e redesenha a lista. Só os produtos ATIVOS de cada loja entram (RN-08)
function atualizarCatalogo() {
  const produtosAtivos = lojas.flatMap((loja) => loja.produtosAtivos());
  mostrarProdutos(filtrarProdutos(produtosAtivos, filtros));
}
```


### Passo 4: teste a regra do produto inativo (RN-08)

1. Abra o catálogo: tudo deve funcionar como antes.
2. No `produtosFicticios`, acrescente `ativo: false,` logo abaixo de `fotos: [...]` do produto **Saia plissada**. Salve: a saia **some** do catálogo (produto inativo não aparece). Tire a linha e ela volta.
3. Tente criar um produto de uma loja que não existe: em `lojaId: "l9"` troque o `lojaId` de um produto. Recarregue: o Console mostra um erro (a busca pela loja devolve `undefined`). Desfaça.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria Usuaria, Cliente e Lojista e usa a agregação loja-produtos no catálogo"
git push
```

## Explicação do Código

**Usuaria.js**

- `class Usuaria` com os campos privados `#id`, `#nome` e `#email` e os getters que os expõem. O construtor recebe `{ id, nome, email }` e confere o nome (`ErroApp("nome_invalido", ...)`).
- `rotaInicial()` na classe base **lança um erro**: "Este perfil ainda não definiu a sua página inicial." Quer dizer: "toda usuária tem uma página inicial, mas só as filhas sabem qual". A classe base obriga as filhas a **sobrescrever** o método.

**Cliente.js e Lojista.js**

- `class Cliente extends Usuaria { rotaInicial() { return "index.html"; } }`: `extends` faz `Cliente` herdar `id`, `nome`, `email` e o construtor de `Usuaria`, sem repetir nenhuma linha. A filha só **sobrescreve** `rotaInicial()` com a sua resposta (polimorfismo). `Lojista` faz o mesmo, devolvendo `painel-loja.html`.
- Nenhuma das duas permite trocar de perfil: o perfil **é** a classe (RN-11).
- Mais tarde (Dia 13), depois do login, o sistema saberá ir para a página certa com uma linha só: `location.assign(usuaria.rotaInicial())`, sem `if` para cada perfil.

**catalogo.js**

- `lojas.find((outra) => outra.id === produto.lojaId)`: acha a loja do produto pelo id. `loja.adicionarProduto(produto)` confere (dentro da `Loja`) que é um `Produto` e **da mesma loja**; se não for, lança `ErroApp`.
- `lojas.flatMap((loja) => loja.produtosAtivos())`: para cada loja, pega a lista de produtos ativos, e `flatMap` "achata" tudo em **uma só lista**. É a RN-08: produto inativo não aparece no catálogo.
- `filtrarProdutos(produtosAtivos, filtros)` continua igual: a agregação só mudou **de onde** vem a lista.

## Validação

1. No Console, `marina.rotaInicial()` devolve `index.html` e `celia.rotaInicial()` devolve `painel-loja.html`.
2. `marina instanceof Usuaria` é `true` e `marina instanceof Lojista` é `false`.
3. Chamar `rotaInicial()` em uma `Usuaria` pura mostra o erro `metodo_nao_implementado`.
4. O catálogo funciona como antes, e um produto com `ativo: false` não aparece.

**Erros comuns**

1. *Mensagem:* `Must call super constructor in derived class before accessing 'this'`. *Causa:* você escreveu um construtor na classe filha e não chamou `super(...)`. *Correção:* nas filhas deste projeto **não há** construtor; elas usam o da mãe automaticamente.
2. *Mensagem:* `The requested module './Usuaria.js' does not provide an export named 'Usuaria'`. *Causa:* falta o `export` em `class Usuaria`. *Correção:* `export class Usuaria`.
3. *Mensagem:* `Cannot read properties of undefined (reading 'adicionarProduto')`. *Causa:* o `lojaId` do produto não existe na lista de lojas. *Correção:* confira se o `lojaId` do produto é `l1` ou `l2`.
4. *Sintoma:* a lista do catálogo fica vazia. *Causa:* esqueceu de adicionar os produtos às lojas (o trecho do `forEach`). *Correção:* confira o Passo 3.

**Se travar**

1. Leia o primeiro erro vermelho do Console, com arquivo e linha.
2. Teste cada classe separadamente no Console, como no Passo 2, antes de ligar tudo.
3. Compare com a aula e, se preciso, volte com `git restore js/paginas/catalogo.js`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/modelos/Usuaria.js`, `Cliente.js` e `Lojista.js` (herança e polimorfismo).
- `catalogo.js` usando a agregação: `Loja` guarda `Produto`s, e só os ativos aparecem.

**Como saber que deu certo:** `marina.rotaInicial()` e `celia.rotaInicial()` respondem páginas diferentes **com a mesma chamada**, e o produto marcado como inativo some do catálogo.
