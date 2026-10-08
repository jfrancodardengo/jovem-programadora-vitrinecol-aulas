# Aula 30 – Catálogo e filtros consultando o banco

**Dia 10 · Ter 20/10/2026** · **Aula 30** · **UC3**

- **Requisitos cobertos:** RF-01 (listar os produtos ativos em cards, 12 por página, com o botão "Carregar mais produtos"), RF-02 (filtro por tipo de roupa), RF-03 (filtro por loja), RF-04 (filtro por tamanho, só com estoque), RF-05 (busca pelo nome sem diferenciar maiúsculas) e RF-21
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catálogo lendo produtos, categorias e lojas do Supabase, com os filtros ainda feitos no navegador (Aula 29)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai passar os **filtros** (tipo, loja, tamanho com estoque e busca pelo nome) para a **consulta ao banco** e criar a **paginação**: o catálogo mostra **12 produtos** por vez e o botão **Carregar mais produtos** traz os próximos.

**Abertura (10 minutos).** Retomada da Aula 29: o catálogo baixa **todos** os produtos e filtra no navegador. Com 3 produtos isso funciona; com 3 mil seria lento e gastaria internet da cliente. A boa prática é **pedir ao banco só o que a tela precisa**. Pense: se a loja tem 200 produtos, quantos você quer baixar para mostrar a primeira tela?

## O Conceito

**Termos desta aula**

- **Filtro na consulta**: em vez de baixar tudo e filtrar depois, o código **acrescenta condições ao pedido**: `.eq("loja_id", id)` (igual a), `.ilike("nome", "%vestido%")` (contém, sem diferenciar maiúsculas), `.gt("estoque", 0)` (maior que zero).
- **Paginação**: mostrar os resultados **por partes** (páginas). Pedimos "da linha 0 à 12" com `.range(0, 12)`; depois "da 12 à 24", e assim por diante.
- **Debounce (esperar a pessoa parar de digitar)**: em vez de consultar o banco a cada letra, o código **espera 300 milissegundos** sem digitação e só então pede os resultados.
- **Resposta velha**: se a pessoa mudar o filtro duas vezes seguidas, a resposta da primeira pode chegar **depois** da segunda e aparecer por cima. O catálogo numera cada pedido e **ignora as respostas antigas**.

**Analogia:** é como pedir em um restaurante: em vez de trazer o cardápio inteiro para a mesa e você escolher, você diz "só vegetarianos, até 40 reais" e o garçom traz **só isso**. E "Carregar mais" é pedir "traga mais 12 opções".

**Como o filtro de tamanho funciona (RF-04):** o produto só entra se tiver o tamanho escolhido **e estoque maior que zero**. O Supabase faz isso com um `!inner` (um `JOIN` que só aceita produtos que tenham pelo menos um tamanho que passe nas condições).

## Mão na Massa

### Passo 1: as funções de consulta com filtros

No `js/servicos/produtoServico.js` você vai (a) acrescentar três funções de apoio **logo antes** de `listarProdutosAtivos`, (b) trocar `listarProdutosAtivos` pela versão com filtros e (c) acrescentar a função da paginação. Primeiro as de apoio, nesta ordem:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`escaparCuringas`) logo antes da função `listarProdutosAtivos` (junto com os comentários que ficam acima dela):

```js
// Um "%" ou "_" digitado na busca valeria como curinga do LIKE; a barra invertida faz valer como letra comum.
function escaparCuringas(texto) {
  return texto.replace(/[\\%_]/g, "\\$&");
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`montarConsultaDosProdutosAtivos`) logo antes da função `listarProdutosAtivos` (junto com os comentários que ficam acima dela):

```js
// Monta a consulta dos produtos ATIVOS (RN-08) com os filtros opcionais { categoriaId, lojaId, tamanho, busca }.
// Cada linha traz: categorias, lojas, tamanhos e produto_fotos (as fotos já ordenadas, a primeira é a capa).
// Atenção: com o filtro de tamanho, "tamanhos" traz só o tamanho filtrado. Para ver todos use obterProduto.
function montarConsultaDosProdutosAtivos(supabase, { categoriaId, lojaId, tamanho, busca }) {
  const filtrandoPorTamanho = Boolean(tamanho);

  // "!inner" faz um JOIN de verdade: só entram os produtos que TÊM um tamanho que passe nos filtros abaixo.
  // Sem ele, o produto entraria na lista mesmo sem o tamanho, só com a lista de tamanhos vazia.
  const relacaoDosTamanhos = filtrandoPorTamanho
    ? "tamanhos!inner ( tamanho, estoque )"
    : "tamanhos ( tamanho, estoque )";

  let consulta = supabase
    .from("produtos")
    .select(CAMPOS_DO_PRODUTO + ", " + relacaoDosTamanhos + ", " + CAMPOS_DAS_FOTOS)
    // RN-08: produto inativo não aparece. Este filtro é necessário mesmo com a RLS, porque
    // a dona da loja enxerga os próprios produtos inativos.
    .eq("ativo", true)
    // O "id" desempata nomes iguais: sem ele, a ordem poderia mudar entre uma página e outra
    .order("nome")
    .order("id")
    // RN-12: as fotos de cada produto vêm pela ordem; a de menor ordem é a capa
    .order("ordem", { referencedTable: "produto_fotos", ascending: true });

  if (categoriaId) {
    consulta = consulta.eq("categoria_id", categoriaId);
  }
  if (lojaId) {
    consulta = consulta.eq("loja_id", lojaId);
  }
  if (filtrandoPorTamanho) {
    // RF-04: o tamanho escolhido E com estoque maior que zero
    consulta = consulta.eq("tamanhos.tamanho", tamanho).gt("tamanhos.estoque", 0);
  }

  const textoDaBusca = (busca ?? "").trim();
  if (textoDaBusca) {
    // ilike não diferencia maiúsculas de minúsculas (RF-05); "%" nas pontas = "contém"
    consulta = consulta.ilike("nome", "%" + escaparCuringas(textoDaBusca) + "%");
  }

  return consulta;
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`erroAoListarProdutos`) logo antes da função `listarProdutosAtivos` (junto com os comentários que ficam acima dela):

```js
function erroAoListarProdutos(erro) {
  return erro instanceof ErroApp
    ? erro
    : new ErroApp(
        "erro_ao_listar_produtos",
        "Não foi possível carregar os produtos. Verifique sua conexão e tente novamente.",
        erro
      );
}
```


Agora troque `listarProdutosAtivos` (a versão nova aceita filtros):

**Arquivo: `js/servicos/produtoServico.js`**: substitua a função `listarProdutosAtivos` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// RF-01 a RF-05: lista TODOS os produtos ativos que passam nos filtros (usado na página da loja).
export async function listarProdutosAtivos(filtros = {}) {
  try {
    const { data, error } = await montarConsultaDosProdutosAtivos(exigirSupabase(), filtros);
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw erroAoListarProdutos(erro);
  }
}
```


E cole a função da paginação **logo antes do bloco de comentário** que começa com `// ====...` (o do "Painel da lojista"):

**Arquivo: `js/servicos/produtoServico.js`**: adicione este trecho logo antes da linha `// =====================================================================`:

```js
// RF-01: o catálogo mostra os produtos por páginas, para não baixar a vitrine inteira de uma vez.
// "pagina" começa em 0. Devolve { linhas, temMais }: pedimos UMA linha a mais do que cabe na página;
// se ela veio, existe próxima página (e ela é descartada daqui).
export async function listarPaginaDeProdutos({ pagina = 0, porPagina = 12, ...filtros } = {}) {
  try {
    const inicio = pagina * porPagina;
    const { data, error } = await montarConsultaDosProdutosAtivos(exigirSupabase(), filtros).range(inicio, inicio + porPagina);
    if (error) {
      throw error;
    }
    return { linhas: data.slice(0, porPagina), temMais: data.length > porPagina };
  } catch (erro) {
    throw erroAoListarProdutos(erro);
  }
}

```


### Passo 2: o HTML e o CSS do botão

No `catalogo.html`, cole o botão **Carregar mais produtos** **logo antes** da linha `</section>` (no fim da lista de produtos):

**Arquivo: `catalogo.html`**: adicione este trecho logo antes da linha `</section>`:

```html
      <p class="paginacao">
        <button type="button" class="botao botao-secundario" id="carregar-mais" hidden>Carregar mais produtos</button>
      </p>
```


No `css/paginas.css`, cole **no final do arquivo**:

**Arquivo: `css/paginas.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Botão "Carregar mais" do catálogo ---------- */
.paginacao {
  margin-top: var(--espaco-5);
  text-align: center;
}
```


### Passo 3: o catálogo consulta o banco a cada filtro

Substitua **todo o conteúdo** do `js/paginas/catalogo.js` pelo arquivo abaixo (vários pedaços mudam de uma vez: o estado dos filtros, a consulta com paginação, a busca com espera e a leitura do endereço):

**Arquivo: `js/paginas/catalogo.js`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```js
// Página do catálogo (catalogo.html): mostra os produtos do banco, por páginas, e aplica os filtros (RF-01 a RF-05).
// A página inicial e a página da loja podem abrir o catálogo já filtrado: catalogo.html?categoria=3&loja=...&busca=...
// A página só chama os serviços e mostra o resultado e os avisos; quem fala com o Supabase são os serviços.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, registrarErro } from "../ui/avisos.js";
import { criarCardProduto } from "../ui/cards.js";
import { Produto } from "../modelos/Produto.js";
import { listarPaginaDeProdutos } from "../servicos/produtoServico.js";
import { listarLojas } from "../servicos/lojaServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";

// Valor atual de cada filtro. Texto vazio ("") significa "sem filtro".
const filtros = {
  busca: "",
  categoriaId: "",
  lojaId: "",
  tamanho: "",
};

// O catálogo mostra os produtos por páginas; "Carregar mais" busca a próxima (começa em 0).
const PRODUTOS_POR_PAGINA = 12;
let paginaAtual = 0;
let carregandoMais = false;

// Cada atualização do catálogo recebe um número. Se o filtro mudar de novo antes da resposta chegar,
// a resposta velha é ignorada; senão ela poderia aparecer por cima da mais nova.
let numeroDaAtualizacao = 0;

// Espera a pessoa parar de digitar antes de buscar, para não fazer uma consulta por letra.
let temporizadorDaBusca = null;
const ESPERA_DA_BUSCA_EM_MS = 300;

const listaProdutos = document.getElementById("lista-produtos");
const mensagemVazio = document.getElementById("mensagem-vazio");
const botaoCarregarMais = document.getElementById("carregar-mais");
const campoBusca = document.getElementById("busca");
const selectLoja = document.getElementById("filtro-loja");
const selectTamanho = document.getElementById("filtro-tamanho");
const formularioFiltros = document.querySelector(".filtros");
const listaChips = document.getElementById("chips-categorias");

// ---------- Conversão e tela ----------

// Apaga os cards antigos e desenha os novos.
function mostrarProdutos(produtos) {
  listaProdutos.replaceChildren(...produtos.map(criarCardProduto));

  // Estado vazio: sem resultado, aparece o aviso em vez de uma tela em branco
  mensagemVazio.hidden = produtos.length > 0;
}

// "Carregar mais" acrescenta os cards da próxima página no fim da lista, sem apagar os que já estão lá.
function acrescentarProdutos(produtos) {
  listaProdutos.append(...produtos.map(criarCardProduto));
}

// Busca no banco com os filtros atuais e redesenha a lista (RF-21: Carregando… e mensagem de erro).
async function atualizarCatalogo() {
  numeroDaAtualizacao += 1;
  const meuNumero = numeroDaAtualizacao;
  paginaAtual = 0;
  botaoCarregarMais.hidden = true;

  mostrarCarregando();

  try {
    const { linhas, temMais } = await listarPaginaDeProdutos({ ...filtros, pagina: 0, porPagina: PRODUTOS_POR_PAGINA });
    const produtos = linhas.map(Produto.deLinha);

    if (meuNumero !== numeroDaAtualizacao) {
      return; // chegou uma resposta de uma busca antiga: descarta
    }
    mostrarProdutos(produtos);
    botaoCarregarMais.hidden = !temMais;
    limparAvisos();
  } catch (erro) {
    if (meuNumero !== numeroDaAtualizacao) {
      return;
    }
    registrarErro(erro);
    // Na falha, a lista antiga sai da tela para não parecer que ela ainda vale para o filtro atual
    listaProdutos.replaceChildren();
    mensagemVazio.hidden = true;
    mostrarErro(mensagemDoErro(erro));
  }
}

// Busca a próxima página com os mesmos filtros e acrescenta os produtos (RF-01).
async function carregarMais() {
  // O botão escondido quer dizer "não há próxima página": nenhuma consulta a mais
  if (carregandoMais || botaoCarregarMais.hidden) {
    return;
  }
  carregandoMais = true;
  botaoCarregarMais.disabled = true;
  const meuNumero = numeroDaAtualizacao;

  mostrarCarregando();

  try {
    const { linhas, temMais } = await listarPaginaDeProdutos({
      ...filtros,
      pagina: paginaAtual + 1,
      porPagina: PRODUTOS_POR_PAGINA,
    });

    if (meuNumero !== numeroDaAtualizacao) {
      return; // os filtros mudaram enquanto a página vinha: ela não vale mais
    }
    paginaAtual += 1;
    acrescentarProdutos(linhas.map(Produto.deLinha));
    botaoCarregarMais.hidden = !temMais;
    limparAvisos();
  } catch (erro) {
    if (meuNumero === numeroDaAtualizacao) {
      registrarErro(erro);
      // A lista que já estava na tela continua valendo; a pessoa pode tentar de novo
      mostrarErro(mensagemDoErro(erro));
    }
  } finally {
    carregandoMais = false;
    botaoCarregarMais.disabled = false;
  }
}

// ---------- Filtros ----------

// Cria um chip de categoria para cada categoria do banco, depois do chip "Todas".
function preencherCategorias(categorias) {
  categorias.forEach((categoria) => {
    const item = document.createElement("li");
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = "chip";
    chip.setAttribute("aria-pressed", "false");
    chip.textContent = categoria.nome;
    chip.dataset.categoriaId = String(categoria.id);
    chip.addEventListener("click", () => escolherCategoria(chip, categoria.id));

    item.append(chip);
    listaChips.append(item);
  });
}

// Cria uma opção para cada loja do banco.
function preencherLojas(lojas) {
  lojas.forEach((loja) => {
    const opcao = document.createElement("option");
    opcao.value = loja.id;
    opcao.textContent = loja.nome;
    selectLoja.append(opcao);
  });
}

function escolherCategoria(chipEscolhido, categoriaId) {
  // Só o chip escolhido fica "pressionado"; "Todas" limpa o filtro (RF-02)
  listaChips.querySelectorAll(".chip").forEach((chip) => {
    chip.setAttribute("aria-pressed", String(chip === chipEscolhido));
  });

  filtros.categoriaId = categoriaId;
  atualizarCatalogo();
}

function configurarFiltros() {
  // O chip "Todas" já está no HTML; os outros chips são criados por preencherCategorias()
  const chipTodas = listaChips.querySelector(".chip");
  chipTodas.addEventListener("click", () => escolherCategoria(chipTodas, ""));

  campoBusca.addEventListener("input", () => {
    clearTimeout(temporizadorDaBusca);
    temporizadorDaBusca = setTimeout(() => {
      filtros.busca = campoBusca.value;
      atualizarCatalogo();
    }, ESPERA_DA_BUSCA_EM_MS);
  });

  selectLoja.addEventListener("change", () => {
    filtros.lojaId = selectLoja.value;
    atualizarCatalogo();
  });

  selectTamanho.addEventListener("change", () => {
    filtros.tamanho = selectTamanho.value;
    atualizarCatalogo();
  });

  botaoCarregarMais.addEventListener("click", carregarMais);

  // Apertar Enter na busca enviaria o formulário e recarregaria a página; aqui isso não é preciso
  formularioFiltros.addEventListener("submit", (evento) => evento.preventDefault());
}

// Lê os filtros que vieram no endereço (por exemplo, de um clique na página inicial) e marca os campos.
// Valores que não existem no banco (um id inventado na mão) são ignorados.
function aplicarFiltrosDoEndereco() {
  const parametros = new URLSearchParams(location.search);

  const busca = (parametros.get("busca") ?? "").trim();
  if (busca) {
    filtros.busca = busca;
    campoBusca.value = busca;
  }

  const lojaId = parametros.get("loja") ?? "";
  if ([...selectLoja.options].some((opcao) => opcao.value === lojaId && lojaId !== "")) {
    filtros.lojaId = lojaId;
    selectLoja.value = lojaId;
  }

  const tamanho = parametros.get("tamanho") ?? "";
  if ([...selectTamanho.options].some((opcao) => opcao.value === tamanho && tamanho !== "")) {
    filtros.tamanho = tamanho;
    selectTamanho.value = tamanho;
  }

  const chipDaCategoria = [...listaChips.querySelectorAll(".chip")].find(
    (chip) => chip.dataset.categoriaId !== undefined && chip.dataset.categoriaId === parametros.get("categoria")
  );
  if (chipDaCategoria) {
    filtros.categoriaId = chipDaCategoria.dataset.categoriaId;
    listaChips.querySelectorAll(".chip").forEach((chip) => {
      chip.setAttribute("aria-pressed", String(chip === chipDaCategoria));
    });
  }
}

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  try {
    // As duas consultas não dependem uma da outra, então rodam ao mesmo tempo
    const [categorias, lojas] = await Promise.all([listarCategorias(), listarLojas()]);

    preencherCategorias(categorias);
    preencherLojas(lojas);
    configurarFiltros();
    aplicarFiltrosDoEndereco();
  } catch (erro) {
    registrarErro(erro);
    mostrarErro(mensagemDoErro(erro));
    return;
  }

  await atualizarCatalogo();
}

iniciar();
```


### Passo 4: teste os filtros e a paginação

1. Abra o catálogo: aparecem os 3 produtos e **não** aparece o botão (há menos de 13).
2. **Filtro de tipo:** clique em **Vestidos**: só o vestido. **Todas** volta tudo. **Filtro de loja:** escolha a **Loja Exemplo**. **Filtro de tamanho:** escolha **G**: o vestido **não** aparece (estoque 0 no G).
3. **Busca:** digite `CAMISETA` (maiúsculas): a camiseta aparece. Digite `zzz`: aparece **Nenhum produto encontrado.**
4. **Paginação:** para ver o botão com poucos produtos, troque **temporariamente** `const PRODUTOS_POR_PAGINA = 12;` por `const PRODUTOS_POR_PAGINA = 2;`, salve e recarregue: aparecem 2 produtos e o botão **Carregar mais produtos**. Clique nele: entra o terceiro, **sem repetir** nenhum, e o botão some. Escolha um filtro: a lista volta à primeira página. **Volte o valor para 12.**
5. **Filtro pelo endereço:** abra `catalogo.html?categoria=3` na barra de endereço (o número é o `id` da categoria Vestidos): o chip **Vestidos** já vem marcado e só o vestido aparece. É assim que a página inicial vai levar a cliente a um tipo de roupa (Dia 14).
6. Na aba **Network** (em português: **Rede**) do F12, filtre por `produtos` e veja que cada filtro dispara **uma** consulta com os parâmetros na URL.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Filtra e pagina o catálogo direto na consulta ao banco"
git push
```

## Explicação do Código

**produtoServico.js**

- `escaparCuringas(texto)`: no `LIKE` do banco, `%` e `_` são "curingas". Se a cliente digitar `50%`, queremos procurar o texto "50%" e não "qualquer coisa". A função põe uma barra invertida antes desses caracteres.
- `montarConsultaDosProdutosAtivos(supabase, { categoriaId, lojaId, tamanho, busca })`: monta o **pedido**, passo a passo (o Supabase permite **encadear** condições):
  - a base: produtos `.eq("ativo", true)` (RN-08), `.order("nome")` e `.order("id")` (o `id` desempata nomes iguais: sem ele, a ordem poderia mudar entre uma página e outra e repetir produtos) e as fotos `.order("ordem", { referencedTable: "produto_fotos" })`.
  - **só se o filtro estiver ligado**, acrescenta a condição: `.eq("categoria_id", categoriaId)`, `.eq("loja_id", lojaId)`.
  - tamanho: troca `tamanhos ( ... )` por `tamanhos!inner ( ... )` e acrescenta `.eq("tamanhos.tamanho", tamanho).gt("tamanhos.estoque", 0)`: só entram produtos que **têm** o tamanho **e** estoque maior que zero.
  - busca: `.ilike("nome", "%" + texto + "%")`: o `%` nas pontas quer dizer "contém" e o `ilike` ignora maiúsculas e minúsculas.
- `erroAoListarProdutos(erro)`: devolve o erro como `ErroApp` com mensagem em português (usada por todas as funções de lista).
- `listarProdutosAtivos(filtros)`: devolve **todos** os produtos que passam nos filtros (será usada na página da loja).
- `listarPaginaDeProdutos({ pagina, porPagina, ...filtros })`: `.range(inicio, inicio + porPagina)` pede **uma linha a mais** do que cabe na página. Se essa linha extra veio, **existe próxima página** (`temMais`), e ela é descartada com `slice(0, porPagina)`. O resultado é `{ linhas, temMais }`.

**catalogo.js**

- `filtros`: o objeto com os valores atuais (agora com `categoriaId`). `paginaAtual`, `carregandoMais` e `numeroDaAtualizacao` controlam a paginação e as respostas velhas.
- `atualizarCatalogo()`: numera o pedido (`numeroDaAtualizacao += 1`), volta para a página 0, mostra "Carregando…", pede a primeira página e, **se a resposta ainda vale** (`meuNumero === numeroDaAtualizacao`), desenha os produtos e mostra ou esconde o botão conforme `temMais`. Em caso de erro, limpa a lista e mostra a mensagem.
- `carregarMais()`: pede a **próxima** página com os **mesmos filtros** e **acrescenta** (`append`) os cards no fim da lista. `carregandoMais` evita dois cliques simultâneos.
- `configurarFiltros()`: a busca usa `setTimeout` de 300 ms e `clearTimeout` a cada letra (o debounce); os chips e selects chamam `atualizarCatalogo()` direto.
- `aplicarFiltrosDoEndereco()`: `new URLSearchParams(location.search)` lê `?categoria=...&loja=...&busca=...&tamanho=...`. Valores que não existem (um id inventado) são **ignorados**.
- `iniciar()`: carrega categorias e lojas ao mesmo tempo, monta os filtros, aplica os do endereço e chama `atualizarCatalogo()`.

**paginas.css**: `.paginacao` centraliza o botão e dá espaço em cima.

## Validação

1. Cada filtro (tipo, loja, tamanho e busca) funciona sozinho e combinado, e **Todas** limpa o de tipo.
2. O filtro de tamanho **G** não mostra o produto sem estoque nesse tamanho.
3. Com `PRODUTOS_POR_PAGINA = 2`, o botão aparece, traz o produto seguinte **sem repetir** e some no fim; ao mudar o filtro, volta à primeira página. Depois do teste, o valor voltou para 12.
4. `catalogo.html?categoria=3` abre já filtrado.
5. Sem internet (**Offline** na aba **Network**, em português: **Rede**), aparece uma mensagem em português.

**Erros comuns**

1. *Mensagem:* `Could not find a relationship between 'produtos' and 'tamanhos'` ou erro `PGRST...`. *Causa:* a tabela `tamanhos` não existe ou o `select` tem erro de digitação. *Correção:* confira as tabelas e o texto do `select`, que precisa ser igual ao da aula.
2. *Sintoma:* o botão **Carregar mais** não aparece nunca. *Causa:* o `catalogo.html` não tem o `<p class="paginacao">` (Passo 2) ou `temMais` está sempre falso. *Correção:* confira o HTML e se `PRODUTOS_POR_PAGINA` é menor que o número de produtos para o teste.
3. *Sintoma:* produtos repetidos ao carregar mais. *Causa:* faltou o `.order("id")` de desempate. *Correção:* confira a função `montarConsultaDosProdutosAtivos`.
4. *Sintoma:* a busca faz uma consulta por letra. *Causa:* o debounce não foi copiado. *Correção:* confira o `setTimeout` e `clearTimeout` em `configurarFiltros`.

**Se travar**

1. Na aba **Network** (em português: **Rede**) filtre por `produtos`, clique no pedido e veja a aba **Response** (em português: **Resposta**): ela mostra a mensagem do banco.
2. Compare as funções com as da aula.
3. Se algo quebrou, volte com `git restore arquivo` e repita o passo.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `produtoServico.js` com `listarProdutosAtivos` (com filtros), `listarPaginaDeProdutos` e funções de apoio.
- `catalogo.html` com o botão "Carregar mais produtos" e `catalogo.js` completo (filtros no banco, paginação, busca com espera, filtros pelo endereço).
- `paginas.css` com a seção do botão.

**Como saber que deu certo:** com 13 ou mais produtos o catálogo mostra 12 e o botão traz os próximos sem repetir nenhum.
