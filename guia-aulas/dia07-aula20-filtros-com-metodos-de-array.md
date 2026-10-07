# Aula 20 – Filtros por tipo, tamanho e loja com métodos de array

**Dia 7 · Qui 15/10/2026** · **Aula 20** · **UC3**

- **Requisitos cobertos:** RF-02 (filtrar por tipo de roupa), RF-03 (filtrar por loja), RF-04 (filtrar por tamanho, só com estoque), com dados fictícios; também ensaia RF-05 (busca pelo nome)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catalogo.js desenhando os 6 cards a partir da lista fictícia, com preço em R$ e estado vazio; catalogo.html com a lista vazia (Aula 19)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer o catálogo **filtrar** por tipo de roupa (chips), loja e tamanho, e por nome, usando os métodos de array `filter`, `find` e `includes`, e **combinando** os filtros.

**Abertura (10 minutos).** Retomada da Aula 19: o catálogo desenha os 6 produtos a partir de uma lista. Mas os chips e os campos de filtro do HTML ainda não fazem nada de verdade. Escolha um dos chips agora: nada acontece (ou só aparece a mensagem da Aula 18, que já saiu). Hoje o catálogo passa a "obedecer" os filtros. Pense: se a cliente escolher **Vestidos** e a **Loja Exemplo**, quais produtos devem aparecer?

## O Conceito

**Termos desta aula**

- **`filter`**: método de array que devolve uma **nova lista** só com os itens que passam em um teste (os que o teste responde `true`).
- **`find`**: devolve o **primeiro** item que passa no teste (ou `undefined`).
- **`includes`**: no texto, responde `true` se ele **contém** um pedaço (por exemplo, `"vestido midi".includes("midi")`).
- **Estado dos filtros**: um objeto que guarda a escolha atual de cada filtro, sempre que a pessoa mexe em um deles. Texto vazio (`""`) quer dizer "sem filtro".

**Analogia:** é como o filtro de um site de passagens: você marca "só voos de manhã" **e** "só sem escala". Um voo só aparece se passar em **todos** os filtros marcados. No código, cada filtro é uma pergunta, e o produto tem que responder "sim" a todas.

**Combinar filtros:** cada filtro é um `if` que **elimina** o produto (`return false`). Se o produto sobreviver a todos, `return true`.

## Mão na Massa

### Passo 1: deixe o HTML só com o essencial

Agora os chips de tipo de roupa e as lojas serão criados pelo JavaScript. No `catalogo.html`, troque o formulário de filtros inteiro (do `<form class="filtros"...>` até o `</form>`) por esta versão, que traz só o chip **Todas** e a opção **Todas**:

**Arquivo: `catalogo.html`**: substitua o trecho que começa na linha `<form class="filtros" aria-label="Filtros do catálogo">` e termina na linha `</form>` (inclusive) por:

```html
    <form class="filtros" aria-label="Filtros do catálogo">
      <div class="campo">
        <label for="busca">Buscar pelo nome</label>
        <input type="search" id="busca" name="busca" placeholder="Ex.: vestido">
      </div>

      <div class="filtros-campos">
        <div class="campo">
          <label for="filtro-loja">Loja</label>
          <select id="filtro-loja" name="loja">
            <option value="">Todas</option>
          </select>
        </div>
        <div class="campo">
          <label for="filtro-tamanho">Tamanho</label>
          <select id="filtro-tamanho" name="tamanho">
            <option value="">Todos</option>
            <option>P</option>
            <option>M</option>
            <option>G</option>
            <option>GG</option>
            <option>38</option>
            <option>40</option>
            <option>42</option>
          </select>
        </div>
      </div>

      <div>
        <p class="legenda" id="rotulo-categorias">Tipo de roupa</p>
        <ul class="chips" id="chips-categorias" aria-labelledby="rotulo-categorias">
          <li><button type="button" class="chip" aria-pressed="true">Todas</button></li>
        </ul>
      </div>
    </form>
```


### Passo 2: as referências, os dados e o estado dos filtros

No `js/paginas/catalogo.js`, troque as duas linhas `const listaProdutos...` e `const mensagemVazio...` por este bloco (as novas constantes buscam os campos do formulário e guardam os dados fictícios de lojas e tipos de roupa, além do objeto `filtros`):

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `const listaProdutos = document.getElementById("lista-produtos");` e termina na linha `const mensagemVazio = document.getElementById("mensagem-vazio");` (inclusive) por:

```js
const listaProdutos = document.getElementById("lista-produtos");
const mensagemVazio = document.getElementById("mensagem-vazio");
const campoBusca = document.getElementById("busca");
const selectLoja = document.getElementById("filtro-loja");
const selectTamanho = document.getElementById("filtro-tamanho");
const formularioFiltros = document.querySelector(".filtros");
const listaChips = document.getElementById("chips-categorias");

// Dados fictícios das lojas e dos tipos de roupa (na Aula 29 eles passam a vir do banco)
const lojasFicticias = [
  { id: "l1", nome: "Loja Exemplo" },
  { id: "l2", nome: "Loja do Bairro" },
];
const categoriasFicticias = ["Blusas", "Camisetas", "Vestidos", "Calças", "Saias", "Shorts", "Jaquetas", "Acessórios"];

// Valor atual de cada filtro. Texto vazio ("") significa "sem filtro".
const filtros = {
  busca: "",
  categoria: "",
  lojaId: "",
  tamanho: "",
};
```


### Passo 3: as funções que filtram

Cole as duas funções **logo antes** da função `criarCardProduto` (e dos comentários que ficam acima dela), primeiro `temEstoque` e depois `filtrarProdutos`:

**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`temEstoque`) logo antes da função `criarCardProduto` (junto com os comentários que ficam acima dela):

```js
// RF-04: o tamanho só serve se existir E tiver estoque maior que zero
function temEstoque(produto, tamanho) {
  const item = produto.tamanhos.find((t) => t.tamanho === tamanho);
  return item !== undefined && item.estoque > 0;
}
```


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`filtrarProdutos`) logo antes da função `criarCardProduto` (junto com os comentários que ficam acima dela):

```js
// Devolve só os produtos que passam em TODOS os filtros que estão ligados (RF-02, RF-03, RF-04 e a busca pelo nome)
function filtrarProdutos(produtos, filtros) {
  return produtos.filter((produto) => {
    if (filtros.categoria && produto.categoria !== filtros.categoria) {
      return false;
    }
    if (filtros.lojaId && produto.lojaId !== filtros.lojaId) {
      return false;
    }
    if (filtros.tamanho && !temEstoque(produto, filtros.tamanho)) {
      return false;
    }
    // includes: o nome contém o texto digitado; toLowerCase ignora maiúsculas e minúsculas
    if (filtros.busca && !produto.nome.toLowerCase().includes(filtros.busca.trim().toLowerCase())) {
      return false;
    }
    return true;
  });
}
```


### Passo 4: troque a função iniciar

Substitua a função `iniciar` e a chamada `iniciar();` do final do arquivo. Primeiro a função:

**Arquivo: `js/paginas/catalogo.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  // O setTimeout finge a espera pelos dados; na Aula 28 ela vira uma espera de verdade
  setTimeout(() => {
    preencherCategorias(categoriasFicticias);
    preencherLojas(lojasFicticias);
    configurarFiltros();
    atualizarCatalogo();
    limparAvisos();
  }, 600);
}
```


### Passo 5: as funções de tela e de eventos

Cole estas cinco funções **logo antes** da função `iniciar` (nesta ordem, uma depois da outra):

**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`atualizarCatalogo`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Aplica os filtros atuais e redesenha a lista
function atualizarCatalogo() {
  mostrarProdutos(filtrarProdutos(produtosFicticios, filtros));
}
```


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`preencherCategorias`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Cria um chip para cada tipo de roupa, depois do chip "Todas" (que já está no HTML)
function preencherCategorias(categorias) {
  categorias.forEach((categoria) => {
    const item = document.createElement("li");
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "chip";
    chip.setAttribute("aria-pressed", "false");
    chip.textContent = categoria;
    chip.addEventListener("click", () => escolherCategoria(chip, categoria));

    item.append(chip);
    listaChips.append(item);
  });
}
```


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`preencherLojas`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Cria uma opção para cada loja
function preencherLojas(lojas) {
  lojas.forEach((loja) => {
    const opcao = document.createElement("option");
    opcao.value = loja.id;
    opcao.textContent = loja.nome;
    selectLoja.append(opcao);
  });
}
```


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`escolherCategoria`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
function escolherCategoria(chipEscolhido, categoria) {
  // Só o chip escolhido fica "pressionado"; "Todas" limpa o filtro (RF-02)
  listaChips.querySelectorAll(".chip").forEach((chip) => {
    chip.setAttribute("aria-pressed", String(chip === chipEscolhido));
  });

  filtros.categoria = categoria;
  atualizarCatalogo();
}
```


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`configurarFiltros`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
function configurarFiltros() {
  // O chip "Todas" já está no HTML; os outros foram criados por preencherCategorias()
  const chipTodas = listaChips.querySelector(".chip");
  chipTodas.addEventListener("click", () => escolherCategoria(chipTodas, ""));

  campoBusca.addEventListener("input", () => {
    filtros.busca = campoBusca.value;
    atualizarCatalogo();
  });

  selectLoja.addEventListener("change", () => {
    filtros.lojaId = selectLoja.value;
    atualizarCatalogo();
  });

  selectTamanho.addEventListener("change", () => {
    filtros.tamanho = selectTamanho.value;
    atualizarCatalogo();
  });

  // Apertar Enter na busca enviaria o formulário e recarregaria a página; aqui isso não é preciso
  formularioFiltros.addEventListener("submit", (evento) => evento.preventDefault());
}
```


### Passo 6: teste e faça o commit

1. Abra o catálogo. Depois do "Carregando…", aparecem os chips dos 8 tipos de roupa, as duas lojas na lista **Loja** e os 6 produtos.
2. Clique em **Vestidos**: só o vestido aparece. Clique em **Todas**: os 6 voltam.
3. Escolha a **Loja do Bairro**: só os produtos dela aparecem. Com **Vestidos** + **Loja do Bairro** marcados: nenhum produto aparece e a mensagem **Nenhum produto encontrado.** surge (os filtros se combinam).
4. No filtro **Tamanho**, escolha **G**: o vestido **não** aparece (o estoque dele no G é 0); as camisetas aparecem.
5. Digite `calça` no campo de busca: só a calça jeans aparece. Digite `CAMISETA`: a camiseta aparece (a busca não diferencia maiúsculas de minúsculas).

```bash
git add .
git commit -m "Filtra o catálogo por tipo, loja, tamanho e nome com dados fictícios"
git push
```

## Explicação do Código

- `const filtros = { busca: "", categoria: "", lojaId: "", tamanho: "" };`: o **estado** dos filtros. Cada vez que a pessoa mexe em um campo, só a propriedade correspondente muda.
- `temEstoque(produto, tamanho)`: usa `find` para achar o tamanho pedido na lista de tamanhos do produto e devolve `true` somente se ele existe **e** tem estoque (`item !== undefined && item.estoque > 0`). É a regra do RF-04.
- `filtrarProdutos(produtos, filtros)`: usa `produtos.filter((produto) => { ... })`. Para cada produto, a função de dentro devolve `true` (fica) ou `false` (sai). Cada `if` descarta o produto que não combina com **um** filtro ligado:
  - `filtros.categoria && produto.categoria !== filtros.categoria`: só testa se o filtro está ligado (texto vazio é "falso" para o JavaScript) **e** se o produto é de outra categoria.
  - `filtros.busca && !produto.nome.toLowerCase().includes(filtros.busca.trim().toLowerCase())`: converte nome e busca para minúsculas antes de comparar, e `trim()` tira espaços das pontas.
- `atualizarCatalogo()`: o "botão central": aplica os filtros e redesenha a lista. Toda mudança de filtro chama esta função.
- `preencherCategorias(categorias)`: cria, para cada tipo de roupa, um `<li>` com um `<button class="chip" aria-pressed="false">` e liga o clique a `escolherCategoria`. O chip "Todas" já estava no HTML.
- `preencherLojas(lojas)`: cria uma `<option>` para cada loja, com o `value` igual ao id (o que o filtro compara) e o nome visível.
- `escolherCategoria(chipEscolhido, categoria)`: marca só o chip clicado como pressionado, guarda a categoria no estado e atualiza. O chip **Todas** chama a função com `""` (sem filtro).
- `configurarFiltros()`: liga os eventos: `input` na busca (dispara a cada letra digitada), `change` nos dois `select` (dispara quando a escolha muda) e, no formulário, `submit` com `evento.preventDefault()` para o Enter na busca não recarregar a página.
- `iniciar()`: monta o cabeçalho, mostra "Carregando…" e, depois de 0,6 segundo, cria os chips e as opções, liga os eventos, mostra os produtos e limpa o aviso.

## Validação

1. Os chips (8 tipos de roupa) e as 2 lojas aparecem sozinhos; o chip **Todas** vem marcado.
2. Cada filtro funciona sozinho e **combinado** com os outros; **Todas** limpa o filtro de tipo.
3. O filtro de tamanho **G** esconde o produto que tem estoque 0 em G.
4. A busca por nome funciona com letras maiúsculas e minúsculas.
5. Sem produtos para a combinação escolhida, aparece "Nenhum produto encontrado."

**Erros comuns**

1. *Mensagem:* `Cannot read properties of null (reading 'addEventListener')`. *Causa:* o `id` de um campo no HTML é diferente do usado no `getElementById` (por exemplo `filtro-loja`). *Correção:* confira os `id` do HTML: `busca`, `filtro-loja`, `filtro-tamanho` e `chips-categorias`.
2. *Sintoma:* os chips aparecem duplicados. *Causa:* o HTML ainda tem os 8 chips escritos à mão. *Correção:* faça o Passo 1: só o chip **Todas** deve ficar no HTML.
3. *Sintoma:* o filtro de loja não mostra nada. *Causa:* o `value` da `<option>` ficou como o **nome** da loja, mas o produto guarda o **id**. *Correção:* use `opcao.value = loja.id`.
4. *Sintoma:* o filtro de tamanho não filtra. *Causa:* `filtros.tamanho` não é atualizado (esqueceu o evento `change`). *Correção:* confira se `configurarFiltros` liga o `change` do `selectTamanho`.

**Se travar**

1. Abra o Console (F12 > **Console**, em português: **Console**) e leia o primeiro erro.
2. Para investigar um filtro, escreva temporariamente `console.log(filtros);` dentro de `atualizarCatalogo` e veja como o estado muda.
3. Compare com o código da aula; se precisar, volte ao último commit com `git restore js/paginas/catalogo.js catalogo.html`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `catalogo.js` com o filtro por tipo de roupa, loja, tamanho (só com estoque) e nome, combinando todos, usando dados fictícios.
- `catalogo.html` com o chip "Todas" e a opção "Todas"; o resto vem do JavaScript.

**Como saber que deu certo:** você marca **Vestidos** e o tamanho **G** juntos e vê a mensagem de "Nenhum produto encontrado.", e ao clicar em **Todas** a lista volta.
