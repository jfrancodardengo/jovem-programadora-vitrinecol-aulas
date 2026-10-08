# Aula 22 – Classes JavaScript: Produto e Loja

**Dia 8 · Sex 16/10/2026** · **Aula 22** · **UC3**

- **Requisitos cobertos:** RN-02 (o preço deve ser maior que zero e o estoque não pode ser negativo), RN-10 (o WhatsApp tem só dígitos, com código do país e DDD) e RN-12 (de 0 a 5 fotos por produto; a primeira é a capa; sem foto aparece uma imagem padrão)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catalogo.js filtrando 6 produtos fictícios (objetos simples); formatadores.js, avisos.js, cabecalho.js, elementos.js; produtoServico.js com a validação (Aulas 19 a 21)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar as classes **Produto** e **Loja** (com construtor, métodos e **campos privados** com `#`), colocar as **regras de preço e estoque dentro da classe** e fazer o catálogo usar essas classes. Antes, vamos criar o **erro próprio do sistema**, `ErroApp`, que as classes usam para avisar quando uma regra é quebrada.

**Abertura (10 minutos).** Retomada da Aula 21: até agora, um produto era um objeto simples `{ nome, preco, ... }` e a regra "preço maior que zero" só existia no formulário. Mas nada impede outro pedaço do código de criar um produto com preço `-5`. Hoje a **regra passa a morar dentro do produto**: ninguém consegue criar um produto inválido. Explique em uma frase para a sua equipe por que isso é mais seguro.

## O Conceito

**Termos desta aula**

- **Classe**: o "molde" que descreve como é uma coisa (um `Produto`) e o que ela sabe fazer. Cada coisa criada a partir do molde, com `new Produto(...)`, é um **objeto** (ou **instância**).
- **Campo privado (`#`)**: um dado guardado dentro do objeto que **só o código da própria classe** enxerga. `#preco` não pode ser lido nem mudado de fora (encapsulamento). Quem está de fora usa **getters** (para ler) e **setters** (para mudar, com validação).
- **Getter e setter**: `get nome()` permite ler `produto.nome` como se fosse uma propriedade; `set preco(valor)` roda código (a regra) quando alguém escreve `produto.preco = 10`.
- **`ErroApp`**: um tipo de erro **nosso**, que carrega um `codigo` (para o programa) e uma `mensagemParaUsuaria` (para a tela, em português). `throw new ErroApp(...)` interrompe o que estava fazendo e avisa que algo deu errado.

**Analogia:** a classe `Produto` é a **ficha de produto** de uma loja com um carimbo do gerente: ninguém aceita uma ficha com preço zero; o carimbo (a validação) está dentro da ficha, não na boca do caixa.

**Regras do projeto:** classes com **campos privados** (`#`), nomes em português sem acento, comentários que explicam o **porquê**, e erros sempre como `ErroApp` com mensagem em português.

## Mão na Massa

### Passo 1: o erro do sistema

Crie a pasta `js/modelos`. Dentro dela crie `ErroApp.js`:

**Arquivo: `js/modelos/ErroApp.js`** (arquivo novo, inteiro)

```js
// Erro próprio do sistema. Estende (herda de) Error, então funciona com throw e try/catch normais.
// Ele carrega duas informações:
//   - codigo: uma palavra curta para o programa decidir o que fazer (ex.: "preco_invalido");
//   - mensagemParaUsuaria: o texto em português que pode ser mostrado na tela.
// Assim a página mostra a mensagem certa sem precisar adivinhar o que deu errado.
export class ErroApp extends Error {
  #codigo;
  #mensagemParaUsuaria;

  // "causa" é opcional: guarda o erro original (por exemplo, o do Supabase) para ajudar a depurar.
  constructor(codigo, mensagemParaUsuaria, causa) {
    super(mensagemParaUsuaria, causa ? { cause: causa } : undefined);
    this.name = "ErroApp";
    this.#codigo = codigo;
    this.#mensagemParaUsuaria = mensagemParaUsuaria;
  }

  // Atalho para as validações de formulário: recebe um objeto { campo: "mensagem" }
  // (vazio quando está tudo certo) e, se houver erro, lança um ErroApp com a primeira mensagem.
  static lancarSeHouverErros(erros) {
    const primeiraMensagem = Object.values(erros)[0];
    if (primeiraMensagem) {
      throw new ErroApp("dados_invalidos", primeiraMensagem);
    }
  }

  get codigo() {
    return this.#codigo;
  }

  get mensagemParaUsuaria() {
    return this.#mensagemParaUsuaria;
  }
}
```


### Passo 2: a classe Produto

Crie `js/modelos/Produto.js`:

**Arquivo: `js/modelos/Produto.js`** (arquivo novo, inteiro)

```js
// Produto de uma loja. Guarda as regras do produto: preço, estoque e fotos.
// Esta classe não mexe na tela nem no banco; só cuida dos dados e das regras (RN-02 e RN-12).
import { ErroApp } from "./ErroApp.js";
import { formatarPreco } from "../ui/formatadores.js";

const IMAGEM_SEM_FOTO = "imagens/sem-foto.svg";
// RN-12: exportado para a tela e o serviço usarem o mesmo limite
export const MAXIMO_DE_FOTOS = 5;

export class Produto {
  #id;
  #nome;
  #descricao;
  #preco;
  #categoria;
  #lojaId;
  #lojaNome;
  #ativo;
  #tamanhos; // lista de { tamanho, estoque }
  #fotos; // lista de endereços; a primeira é a capa

  constructor({
    id,
    nome,
    descricao = "",
    preco,
    categoria,
    lojaId,
    lojaNome = "",
    ativo = true,
    tamanhos = [],
    fotos = [],
  }) {
    this.#id = id;
    this.#descricao = descricao;
    this.#categoria = categoria;
    this.#lojaId = lojaId;
    this.#lojaNome = lojaNome;
    this.#ativo = ativo;
    this.#tamanhos = [];
    this.#fotos = [];

    // Os setters e métodos abaixo validam; assim a regra vale no construtor e também depois dele.
    this.nome = nome;
    this.preco = preco;
    tamanhos.forEach((item) => this.definirEstoque(item.tamanho, item.estoque));
    fotos.forEach((endereco) => this.adicionarFoto(endereco));
  }

  // ---------- Leitura ----------

  get id() {
    return this.#id;
  }

  get nome() {
    return this.#nome;
  }

  get descricao() {
    return this.#descricao;
  }

  get preco() {
    return this.#preco;
  }

  get categoria() {
    return this.#categoria;
  }

  get lojaId() {
    return this.#lojaId;
  }

  get lojaNome() {
    return this.#lojaNome;
  }

  get ativo() {
    return this.#ativo;
  }

  // Devolvem CÓPIAS. Se devolvessem a lista original, alguém de fora poderia fazer
  // produto.fotos.push(...) e passar de 5 fotos sem a validação rodar (encapsulamento).
  get tamanhos() {
    return this.#tamanhos.map((item) => ({ ...item }));
  }

  get fotos() {
    return [...this.#fotos];
  }

  // ---------- Escrita com validação ----------

  set nome(valor) {
    if (typeof valor !== "string" || valor.trim() === "") {
      throw new ErroApp("nome_invalido", "Informe o nome do produto.");
    }
    this.#nome = valor.trim();
  }

  // RN-02: o preço deve ser maior que zero.
  set preco(valor) {
    const numero = Number(valor);
    if (!Number.isFinite(numero) || numero <= 0) {
      throw new ErroApp("preco_invalido", "O preço deve ser maior que zero.");
    }
    this.#preco = numero;
  }

  // RN-02: o estoque não pode ser negativo (e precisa ser um número inteiro).
  definirEstoque(tamanho, estoque) {
    if (typeof tamanho !== "string" || tamanho.trim() === "") {
      throw new ErroApp("tamanho_invalido", "Informe o tamanho.");
    }

    const quantidade = Number(estoque);
    if (!Number.isInteger(quantidade) || quantidade < 0) {
      throw new ErroApp("estoque_invalido", "O estoque não pode ser negativo.");
    }

    const existente = this.#tamanhos.find((item) => item.tamanho === tamanho);
    if (existente) {
      existente.estoque = quantidade;
    } else {
      this.#tamanhos.push({ tamanho, estoque: quantidade });
    }
  }

  // RN-12: no máximo 5 fotos por produto.
  adicionarFoto(endereco) {
    if (typeof endereco !== "string" || endereco.trim() === "") {
      throw new ErroApp("foto_invalida", "O endereço da foto é inválido.");
    }
    if (this.#fotos.length >= MAXIMO_DE_FOTOS) {
      throw new ErroApp("fotos_demais", "Cada produto pode ter no máximo 5 fotos.");
    }
    this.#fotos.push(endereco);
  }

  // ---------- Comportamentos ----------

  // 189.9 -> "R$ 189,90"
  precoFormatado() {
    return formatarPreco(this.#preco);
  }

  // RF-04: o tamanho só serve se existir E tiver estoque maior que zero.
  temEstoque(tamanho) {
    const item = this.#tamanhos.find((t) => t.tamanho === tamanho);
    return item !== undefined && item.estoque > 0;
  }

  // RN-12: a primeira foto é a capa; sem foto, devolve a imagem padrão.
  fotoCapa() {
    return this.#fotos.length > 0 ? this.#fotos[0] : IMAGEM_SEM_FOTO;
  }
}
```


### Passo 3: a classe Loja

Crie `js/modelos/Loja.js`:

**Arquivo: `js/modelos/Loja.js`** (arquivo novo, inteiro)

```js
// Loja de moda. Ela TEM uma lista de Produtos: isso é agregação (a Loja agrupa produtos,
// mas cada Produto continua sendo um objeto independente, com as suas próprias regras).
import { ErroApp } from "./ErroApp.js";
import { Produto } from "./Produto.js";
import { telefoneValido } from "../ui/formatadores.js";

// Texto obrigatório: usado para nome, endereço e cidade.
function exigirTexto(valor, codigo, mensagem) {
  if (typeof valor !== "string" || valor.trim() === "") {
    throw new ErroApp(codigo, mensagem);
  }
  return valor.trim();
}

// O link do mapa é opcional, mas se existir precisa ser http ou https: um "javascript:..." num link seria perigoso.
function validarLinkDoMapa(valor) {
  const texto = String(valor ?? "").trim();
  if (texto === "") {
    return "";
  }
  try {
    const protocolo = new URL(texto).protocol;
    if (protocolo === "http:" || protocolo === "https:") {
      return texto;
    }
  } catch (erro) {
    // endereço que nem é um link: cai no erro abaixo
  }
  throw new ErroApp("link_mapa_invalido", "O link do mapa deve começar com http:// ou https://.");
}

export class Loja {
  #id;
  #nome;
  #descricao;
  #endereco;
  #cidade;
  #whatsapp;
  #linkMapa;
  #imagemUrl;
  #produtos = []; // a agregação: lista de objetos Produto

  constructor({ id, nome, descricao = "", endereco, cidade, whatsapp, linkMapa = "", imagemUrl = "" }) {
    this.#id = id;
    this.#nome = exigirTexto(nome, "nome_invalido", "Informe o nome da loja.");
    this.#descricao = descricao;
    this.#endereco = exigirTexto(endereco, "endereco_invalido", "Informe o endereço da loja.");
    this.#cidade = exigirTexto(cidade, "cidade_invalida", "Informe a cidade da loja.");
    this.whatsapp = whatsapp;
    this.#linkMapa = validarLinkDoMapa(linkMapa);
    this.#imagemUrl = imagemUrl;
  }

  get id() {
    return this.#id;
  }

  get nome() {
    return this.#nome;
  }

  get descricao() {
    return this.#descricao;
  }

  get endereco() {
    return this.#endereco;
  }

  get cidade() {
    return this.#cidade;
  }

  get whatsapp() {
    return this.#whatsapp;
  }

  get linkMapa() {
    return this.#linkMapa;
  }

  get imagemUrl() {
    return this.#imagemUrl;
  }

  // RN-10: só dígitos, com código do país e DDD. Ex.: 5527999999999 (13) ou 552733334444 (12).
  set whatsapp(valor) {
    const texto = String(valor ?? "");
    if (!telefoneValido(texto)) {
      throw new ErroApp(
        "whatsapp_invalido",
        "O WhatsApp deve ter só números, com código do país e DDD (12 ou 13 dígitos)."
      );
    }
    this.#whatsapp = texto;
  }

  // Devolve uma cópia da lista, para ninguém de fora mexer nela sem passar pelas regras da Loja.
  get produtos() {
    return [...this.#produtos];
  }

  adicionarProduto(produto) {
    if (!(produto instanceof Produto)) {
      throw new ErroApp("produto_invalido", "Só é possível adicionar produtos à loja.");
    }
    if (produto.lojaId !== this.#id) {
      throw new ErroApp("produto_de_outra_loja", "Este produto pertence a outra loja.");
    }
    this.#produtos.push(produto);
  }

  // RN-08: produtos inativos não aparecem na página da loja.
  produtosAtivos() {
    return this.#produtos.filter((produto) => produto.ativo);
  }
}
```


### Passo 4: o catálogo passa a usar as classes

No `js/paginas/catalogo.js`, faça as trocas abaixo, **na ordem**. (1) As importações: troque a linha do `formatarPreco` pelas duas do `Produto` e da `Loja`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `import { formatarPreco } from "../ui/formatadores.js";` por:

```js
import { Produto } from "../modelos/Produto.js";
import { Loja } from "../modelos/Loja.js";
```


(2) As lojas fictícias viram objetos `Loja` e os produtos viram objetos `Produto`:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `const lojasFicticias = [` e termina na linha `];` (inclusive) por:

```js
const lojas = [
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
```


(3) A função `temEstoque` agora é um **método** do `Produto`. Apague a função do catálogo:

**Arquivo: `js/paginas/catalogo.js`**: apague a função `temEstoque` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


(4) Nas funções restantes, troque só estas linhas. Dentro de `filtrarProdutos`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `if (filtros.tamanho && !temEstoque(produto, filtros.tamanho)) {` por:

```js
    if (filtros.tamanho && !produto.temEstoque(filtros.tamanho)) {
```


Dentro de `criarCardProduto` (as linhas do comentário até a foto):

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `// Sem foto, usa a imagem padrão` e termina na linha `imagem.src = produto.fotos[0] ?? "imagens/sem-foto.svg";` (inclusive) por:

```js
  // fotoCapa() devolve a primeira foto, ou a imagem padrão quando o produto não tem foto
  const imagem = criarElemento("img", "card-produto-imagem");
  imagem.src = produto.fotoCapa();
```


E a linha do preço, na mesma função:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `const preco = criarElemento("p", "preco", formatarPreco(produto.preco));` por:

```js
  const preco = criarElemento("p", "preco", produto.precoFormatado());
```


Dentro de `atualizarCatalogo`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `mostrarProdutos(filtrarProdutos(produtosFicticios, filtros));` por:

```js
  mostrarProdutos(filtrarProdutos(produtos, filtros));
```


E dentro de `iniciar`:

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `preencherLojas(lojasFicticias);` por:

```js
    preencherLojas(lojas);
```


### Passo 5: teste no catálogo e no Console

1. Abra o catálogo: ele deve funcionar **igual** à aula anterior (filtros, preços em R$, estado vazio). Quem mudou foi o "motor".
2. **Teste a regra do preço:** em `produtosFicticios`, mude o preço do primeiro produto para `0`. Recarregue: **nenhum** card aparece e o Console mostra um erro em vermelho com a mensagem `O preço deve ser maior que zero.` (o `ErroApp` foi lançado ao criar o produto). Volte o preço para `129.9`. (Na próxima aula você vai mostrar esse erro na tela.)
3. No Console (F12 > **Console**, em português: **Console**), cole:

```js
const { Produto } = await import("/js/modelos/Produto.js");
const p = new Produto({ id: "x", nome: "Teste", preco: 10, categoria: "Blusas", lojaId: "l1", tamanhos: [{ tamanho: "M", estoque: 2 }] });
console.log(p.nome, p.precoFormatado(), p.temEstoque("M"), p.temEstoque("G"), p.fotoCapa());
try { p.preco = -1; } catch (erro) { console.log(erro.codigo, "-", erro.mensagemParaUsuaria); }
console.log(p.preco);
```

   Devem aparecer `Teste R$ 10,00 true false imagens/sem-foto.svg`, depois `preco_invalido - O preço deve ser maior que zero.` e por fim `10` (o preço não foi alterado).

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria as classes Produto, Loja e ErroApp e usa no catálogo"
git push
```

## Explicação do Código

**ErroApp.js**

- `class ErroApp extends Error`: `extends` quer dizer "ErroApp é um tipo de Error": herda tudo dele, então funciona com `throw` e `try/catch`. Os campos `#codigo` e `#mensagemParaUsuaria` são privados; os `get` os expõem só para leitura.
- O `constructor(codigo, mensagemParaUsuaria, causa)` chama `super(...)` (o construtor do `Error`) com a mensagem, e guarda a `causa` (o erro original, por exemplo do Supabase) para ajudar a depurar.
- `static lancarSeHouverErros(erros)`: um método que **pertence à classe**, não a um objeto. Recebe um objeto de erros de formulário (`{ campo: "mensagem" }`) e, se houver algum, lança um `ErroApp` com a **primeira** mensagem. Vamos usá-lo nos serviços (Dia 11).

**Produto.js**

- `export const MAXIMO_DE_FOTOS = 5;`: o limite (RN-12) fica em um lugar só e é exportado para outros arquivos usarem.
- `#id`, `#nome`, `#preco`... : campos privados declarados no topo da classe.
- `constructor({ id, nome, descricao = "", preco, categoria, ... })`: recebe **um objeto** com os dados (por isso as chaves no parâmetro, que "desmontam" o objeto) e os valores `= ""`, `= true`, `= []` são **padrões**. Ele guarda os dados simples e passa `nome` e `preco` pelos **setters** (`this.nome = nome`), os tamanhos por `definirEstoque` e as fotos por `adicionarFoto`: assim as regras valem **também na criação**.
- `set preco(valor)`: converte para número e, se não for um número ou for `<= 0`, **lança** `new ErroApp("preco_invalido", "O preço deve ser maior que zero.")`. É a regra RN-02 dentro da classe.
- `definirEstoque(tamanho, estoque)`: o estoque tem de ser um número **inteiro** `>= 0`; se o tamanho já existe, atualiza; senão, acrescenta.
- `adicionarFoto(endereco)`: recusa texto vazio e **mais de 5 fotos** (RN-12).
- `get tamanhos()` e `get fotos()` devolvem **cópias** (`map(... ({ ...item }))` e `[...this.#fotos]`): se devolvessem a lista original, alguém de fora faria `produto.fotos.push(...)` e passaria de 5 fotos sem a regra rodar.
- `precoFormatado()`: `R$ 129,90`. `temEstoque(tamanho)`: `true` só se o tamanho existe **e** tem estoque (RF-04). `fotoCapa()`: a primeira foto, ou `imagens/sem-foto.svg` quando não há foto (RN-12).

**Loja.js**

- A função `exigirTexto` (fora da classe, privada ao arquivo) confere se nome, endereço e cidade são textos não vazios. `validarLinkDoMapa` aceita só links que começam com `http:` ou `https:`: um link `javascript:...` seria perigoso.
- `set whatsapp(valor)`: usa `telefoneValido` (a regra única da Aula 21): 12 ou 13 dígitos, senão `ErroApp("whatsapp_invalido", ...)` (RN-10).
- `#produtos = []`: a loja **tem** uma lista de produtos. Ela guarda objetos `Produto`, mas cada um continua independente, com as suas regras (isso é **agregação**, tema da próxima aula). `adicionarProduto` confere que o item é um `Produto` e da mesma loja; `produtosAtivos()` filtra os que estão ativos (RN-08).

**catalogo.js**

- `new Produto(dados)` transforma cada objeto simples em um `Produto`. Se **qualquer** dado for inválido, o `ErroApp` interrompe tudo (por isso o teste com preço `0` não mostra nenhum card).
- O card usa os métodos do produto: `produto.fotoCapa()` e `produto.precoFormatado()`. O filtro de tamanho usa `produto.temEstoque(...)`. Quem decide agora é a classe, não o catálogo.

## Validação

1. O catálogo funciona como antes, agora usando objetos `Produto` e `Loja`.
2. Com preço `0` no primeiro produto, o Console mostra `O preço deve ser maior que zero.` e nenhum card aparece (e você voltou o preço para `129.9`).
3. No Console, `p.preco = -1` lança o erro e o preço continua `10`.
4. Tentar ler um campo privado de fora (`p.#preco`) é um erro de sintaxe: o encapsulamento funciona.

**Erros comuns**

1. *Mensagem:* `Uncaught SyntaxError: Private field '#preco' must be declared in an enclosing class`. *Causa:* o `#preco` foi usado fora da classe (ou sem declarar no topo). *Correção:* declare `#preco;` no topo da classe e use `this.#preco` só dentro dela; de fora, use o getter `produto.preco`.
2. *Mensagem:* `Cannot access 'ErroApp' before initialization` ou `The requested module './ErroApp.js' does not provide an export named 'ErroApp'`. *Causa:* falta o `export` na classe ou o caminho do `import` está errado. *Correção:* `export class ErroApp` e `import { ErroApp } from "./ErroApp.js"`.
3. *Mensagem:* `Class constructor Produto cannot be invoked without 'new'`. *Causa:* faltou o `new` ao criar. *Correção:* `new Produto({...})`.
4. *Sintoma:* nenhum card aparece e o Console mostra `O nome do produto...` ou outro `ErroApp`. *Causa:* algum dado fictício viola uma regra (preço zero, estoque negativo, 6 fotos). *Correção:* leia a mensagem: ela diz qual regra falhou.

**Se travar**

1. Leia a mensagem do Console com arquivo e linha; muitas vezes é um `ErroApp` com texto em português que diz o que falta.
2. Compare as três classes com as da aula.
3. Se o catálogo quebrou, volte ao último commit com `git restore js/paginas/catalogo.js` e refaça o Passo 4 uma troca por vez.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata.

**Seu projeto agora tem**

- `js/modelos/ErroApp.js`, `Produto.js` e `Loja.js`.
- `catalogo.js` usando objetos `Produto` e `Loja`, com as regras de preço, estoque, fotos e WhatsApp dentro das classes.

**Como saber que deu certo:** é **impossível** criar um produto com preço zero: o sistema recusa com uma mensagem em português.
