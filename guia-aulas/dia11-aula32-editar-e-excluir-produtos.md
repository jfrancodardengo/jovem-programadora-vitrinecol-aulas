# Aula 32 – Edição e exclusão (UPDATE e DELETE): CRUD completo

**Dia 11 · Qua 21/10/2026** · **Aula 32** · **UC3**

- **Requisitos cobertos:** RF-17 (editar produto), RF-18 (desativar ou excluir produto; excluir só funciona se nunca foi pedido), RN-08 (produto inativo não aparece no catálogo) e RF-21 (mensagens de sucesso e de erro)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** cadastro de loja e de produto gravando no banco como a lojista de teste; errosSupabase.js e produtoServico.js com criarProduto (Aula 31)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai completar o **CRUD** de produtos (Create, Read, Update, Delete): a lista **Meus produtos**, a **edição** do produto, **desativar e reativar** (produto inativo some do catálogo) e **excluir** (só se o produto nunca foi pedido), sempre com mensagens claras de sucesso e de erro.

**Abertura (10 minutos).** Retomada da Aula 31: a lojista consegue **criar** produtos, mas se errou o preço ou acabou o estoque, não tem como corrigir pelo sistema. Hoje ela ganha **editar**, **desativar** e **excluir**. Pense em duas situações: (1) o produto saiu de linha, mas já foi vendido; (2) o produto foi cadastrado por engano. Qual das duas pede "desativar" e qual pede "excluir"?

## O Conceito

**Termos desta aula**

- **`UPDATE` (atualizar)**: `supabase.from("produtos").update({ preco: 99 }).eq("id", id)` muda as colunas indicadas **das linhas que passam no `.eq`**. Sem o `.eq`, mudaria **todas** as linhas: sempre confira o filtro.
- **`DELETE` (apagar)**: `supabase.from("produtos").delete().eq("id", id)` apaga a linha. O Supabase **não avisa** se nenhuma linha foi afetada; por isso pedimos `.select("id")` e conferimos se voltou alguma.
- **`upsert`**: "atualize se existir, insira se não existir". Usado nos tamanhos: ao salvar, os que já existiam são atualizados e os novos, criados.
- **Desativar versus excluir**: **desativar** (`ativo = false`) esconde o produto do catálogo e da loja, mas guarda tudo, inclusive o histórico de pedidos. **Excluir** apaga de verdade, e só pode se o produto **nunca foi pedido** (a regra do banco da Aula 26).

**Analogia:** desativar é **tirar o produto da vitrine** e guardá-lo no estoque; excluir é **jogar fora**. Se o produto já foi vendido, a nota fiscal ainda precisa dele; então só dá para tirá-lo da vitrine.

## Mão na Massa

### Passo 1: as funções de leitura do painel

No `js/servicos/produtoServico.js` cole, **logo antes** da função `normalizarTamanho`, a mensagem usada na exclusão:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta constante (`MENSAGEM_PRODUTO_JA_PEDIDO`) logo antes da função `normalizarTamanho` (junto com os comentários que ficam acima dela):

```js
const MENSAGEM_PRODUTO_JA_PEDIDO = "Este produto já foi pedido; desative-o em vez de excluir.";
```


E, **logo antes** da função `montarLinhas`, as duas funções que leem produtos para o painel:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`listarProdutosDaLoja`) logo antes da função `montarLinhas` (junto com os comentários que ficam acima dela):

```js
// Lista TODOS os produtos da loja, inclusive os inativos (a dona vê os dois pelas regras RLS).
export async function listarProdutosDaLoja(lojaId) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase
      .from("produtos")
      .select("id, nome, preco, ativo, categorias ( nome )")
      .eq("loja_id", lojaId)
      .order("nome");

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar os seus produtos. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`obterProdutoParaEdicao`) logo antes da função `montarLinhas` (junto com os comentários que ficam acima dela):

```js
// Traz um produto da loja (ativo ou não) com todos os tamanhos e as fotos em ordem, para o formulário de edição.
// O filtro por loja_id impede abrir, por engano, o produto de outra loja.
export async function obterProdutoParaEdicao(id, lojaId) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase
      .from("produtos")
      .select(CAMPOS_DO_PRODUTO + ", tamanhos ( tamanho, estoque ), produto_fotos ( id, url, caminho, ordem )")
      .eq("id", id)
      .eq("loja_id", lojaId)
      .order("ordem", { referencedTable: "produto_fotos", ascending: true })
      .maybeSingle();

    // 22P02 = "isso não é um uuid": um endereço como ?id=abc também é "não encontrado"
    if (error && error.code !== "22P02") {
      throw error;
    }
    if (error || !data) {
      throw new ErroApp("produto_nao_encontrado", "Produto não encontrado.");
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 2: as funções que alteram

Cole **no final do arquivo**, nesta ordem:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`atualizarProduto`) no final do arquivo:

```js
// Atualiza o produto e os tamanhos (RF-17). Os dados têm o mesmo formato do criarProduto. As fotos entram na Aula 33.
export async function atualizarProduto(id, dados) {
  try {
    ErroApp.lancarSeHouverErros(validarProduto(dados));
    conferirComOModelo({ ...dados, id });
    const supabase = exigirSupabase();
    const { linhaDoProduto, linhasDeTamanhos } = montarLinhas(dados);

    // Como está hoje no banco: serve para saber o que foi removido
    const { data: atual, error: erroAoLer } = await supabase
      .from("produtos")
      .select("id, tamanhos ( tamanho )")
      .eq("id", id)
      .eq("loja_id", dados.lojaId)
      .maybeSingle();
    if (erroAoLer) {
      throw erroAoLer;
    }
    if (!atual) {
      throw new ErroApp("produto_nao_encontrado", "Produto não encontrado.");
    }

    // 1) Dados do produto. Se a loja não for desta lojista, as regras RLS não alteram nada e não volta linha
    const { data: alterados, error: erroDoProduto } = await supabase.from("produtos").update(linhaDoProduto).eq("id", id).select("id");
    if (erroDoProduto) {
      throw erroDoProduto;
    }
    if (alterados.length === 0) {
      throw new ErroApp("permissao_negada", "Você não tem permissão para alterar este produto.");
    }

    // 2) Tamanhos: grava os atuais (cria ou atualiza) e apaga os que a lojista tirou
    const { error: erroDosTamanhos } = await supabase
      .from("tamanhos")
      .upsert(linhasDeTamanhos.map((linha) => ({ produto_id: id, ...linha })), { onConflict: "produto_id,tamanho" });
    if (erroDosTamanhos) {
      throw erroDosTamanhos;
    }
    const tamanhosNovos = new Set(linhasDeTamanhos.map((linha) => linha.tamanho));
    const tamanhosRemovidos = atual.tamanhos.map((t) => t.tamanho).filter((t) => !tamanhosNovos.has(t));
    if (tamanhosRemovidos.length > 0) {
      const { error } = await supabase.from("tamanhos").delete().eq("produto_id", id).in("tamanho", tamanhosRemovidos);
      if (error) {
        throw error;
      }
    }

    return id;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível salvar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`definirAtivo`) no final do arquivo:

```js
// Ativa ou desativa o produto (RF-18). Produto inativo some do catálogo e da página da loja (RN-08).
export async function definirAtivo(id, ativo) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("produtos").update({ ativo }).eq("id", id).select("id");

    if (error) {
      throw error;
    }
    if (data.length === 0) {
      throw new ErroApp("permissao_negada", "Você não tem permissão para alterar este produto.");
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível alterar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`excluirProduto`) no final do arquivo:

```js
// Exclui o produto (RF-18). Produto que já foi pedido NÃO pode ser excluído: o banco impede, e a mensagem sugere desativar.
// Ordem dos passos: 1) confere se já foi pedido; 2) apaga o produto (o banco apaga em cascata os tamanhos e as fotos).
// As fotos guardadas no Storage passam a ser apagadas junto na Aula 33.
export async function excluirProduto(id) {
  try {
    const supabase = exigirSupabase();

    // As regras RLS deixam a lojista ver os itens dos pedidos da própria loja, e é neles que o produto aparece
    const { count, error: erroDosPedidos } = await supabase
      .from("itens_pedido")
      .select("id", { count: "exact", head: true })
      .eq("produto_id", id);
    if (erroDosPedidos) {
      throw erroDosPedidos;
    }
    if (count > 0) {
      throw new ErroApp("produto_ja_pedido", MENSAGEM_PRODUTO_JA_PEDIDO);
    }

    const { data: apagados, error: erroAoApagar } = await supabase.from("produtos").delete().eq("id", id).select("id");
    if (erroAoApagar) {
      // 23503: alguém fez um pedido deste produto entre a conferência e agora
      if (erroAoApagar.code === "23503") {
        throw new ErroApp("produto_ja_pedido", MENSAGEM_PRODUTO_JA_PEDIDO, erroAoApagar);
      }
      throw erroAoApagar;
    }
    if (apagados.length === 0) {
      throw new ErroApp("permissao_negada", "Você não tem permissão para excluir este produto.");
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível excluir o produto. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 3: a tela Meus produtos

Substitua **todo o conteúdo** do `painel-produtos.html` (a lista agora é desenhada pelo JavaScript):

**Arquivo: `painel-produtos.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Meus produtos – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <nav aria-label="Painel da lojista">
      <ul class="navegacao-painel">
        <li><a href="painel-loja.html">Minha loja</a></li>
        <li><a href="painel-produtos.html" aria-current="page">Meus produtos</a></li>
        <li><a href="painel-pedidos.html">Pedidos recebidos</a></li>
      </ul>
    </nav>

    <h1>Meus produtos</h1>

    <p class="aviso aviso-info" id="aviso-sem-loja" role="status" hidden>
      Cadastre a sua loja antes de cadastrar produtos. <a href="painel-loja.html">Ir para Minha loja</a>
    </p>

    <p class="painel-acoes" id="acoes-produtos" hidden>
      <a class="botao" href="painel-produto-form.html">Cadastrar produto</a>
    </p>

    <p class="aviso aviso-info" id="mensagem-sem-produtos" role="status" hidden>Você ainda não cadastrou nenhum produto.</p>

    <table class="tabela" id="tabela-produtos" role="table" hidden>
      <caption class="visualmente-oculto">Lista dos produtos da loja</caption>
      <thead role="rowgroup">
        <tr role="row">
          <th scope="col" role="columnheader">Produto</th>
          <th scope="col" role="columnheader">Categoria</th>
          <th scope="col" role="columnheader">Preço</th>
          <th scope="col" role="columnheader">Situação</th>
          <th scope="col" role="columnheader">Ações</th>
        </tr>
      </thead>
      <tbody id="lista-produtos-painel" role="rowgroup"></tbody>
    </table>
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

  <script type="module" src="js/paginas/painelProdutos.js"></script>
</body>
</html>
```


Crie `js/paginas/painelProdutos.js`:

**Arquivo: `js/paginas/painelProdutos.js`** (arquivo novo, inteiro)

```js
// Painel da lojista: Meus produtos (RF-16, RF-18). Só a lojista abre esta tela (RF-14).
// Lista os produtos da loja (inclusive os inativos), com Editar, Ativar/Desativar e Excluir.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { formatarPreco } from "../ui/formatadores.js";
import { obterMinhaLoja } from "../servicos/lojaServico.js";
import { listarProdutosDaLoja, definirAtivo, excluirProduto } from "../servicos/produtoServico.js";

// O painel-produto-form.html volta para cá com ?salvo=criado ou ?salvo=editado.
// Um Map (e não um objeto) para o valor vindo do endereço nunca ser confundido com uma propriedade do objeto.
const MENSAGENS_DE_SALVO = new Map([
  ["criado", "Produto cadastrado com sucesso."],
  ["editado", "Produto atualizado com sucesso."],
]);

const avisoSemLoja = document.getElementById("aviso-sem-loja");
const blocoDeAcoes = document.getElementById("acoes-produtos");
const mensagemSemProdutos = document.getElementById("mensagem-sem-produtos");
const tabela = document.getElementById("tabela-produtos");
const corpoDaTabela = document.getElementById("lista-produtos-painel");

let loja = null;

// ---------- Tela ----------

function criarCelula(rotulo, conteudo) {
  const celula = document.createElement("td");
  celula.dataset.rotulo = rotulo; // o CSS usa este rótulo quando a tabela vira blocos no celular
  celula.setAttribute("role", "cell"); // o CSS tira a semântica de tabela no celular; o papel explícito a devolve
  celula.append(conteudo); // texto vira nó de texto (nunca HTML)
  return celula;
}

// Texto só para leitor de tela, para cada botão dizer de qual produto é: "Editar (Vestido midi floral)"
function criarTextoOculto(nomeDoProduto) {
  const oculto = document.createElement("span");
  oculto.className = "visualmente-oculto";
  oculto.textContent = " (" + nomeDoProduto + ")";
  return oculto;
}

function criarBotao(texto, classe, produto, aoClicar) {
  const botao = document.createElement("button");
  botao.type = "button";
  botao.className = "botao botao-pequeno " + classe;
  botao.append(texto, criarTextoOculto(produto.nome));
  botao.addEventListener("click", () => aoClicar(produto, botao));
  return botao;
}

function criarAcoes(produto) {
  const acoes = document.createElement("div");
  acoes.className = "tabela-acoes";

  const editar = document.createElement("a");
  editar.className = "botao botao-secundario botao-pequeno";
  editar.href = "painel-produto-form.html?id=" + encodeURIComponent(produto.id);
  editar.append("Editar", criarTextoOculto(produto.nome));

  acoes.append(
    editar,
    criarBotao(produto.ativo ? "Desativar" : "Ativar", "botao-secundario", produto, alternarAtivo),
    criarBotao("Excluir", "botao-perigo", produto, excluir)
  );
  return acoes;
}

function criarLinha(produto) {
  const selo = document.createElement("span");
  selo.className = "selo " + (produto.ativo ? "selo-confirmado" : "selo-concluido");
  selo.textContent = produto.ativo ? "Ativo" : "Inativo";

  const linha = document.createElement("tr");
  linha.setAttribute("role", "row");
  linha.append(
    criarCelula("Produto", produto.nome),
    criarCelula("Categoria", produto.categorias?.nome ?? ""),
    criarCelula("Preço", formatarPreco(produto.preco)),
    criarCelula("Situação", selo),
    criarCelula("Ações", criarAcoes(produto))
  );
  return linha;
}

function desenharProdutos(produtos) {
  corpoDaTabela.replaceChildren(...produtos.map(criarLinha));

  // Estado vazio: sem produtos, aparece uma mensagem em vez de uma tabela vazia
  tabela.hidden = produtos.length === 0;
  mensagemSemProdutos.hidden = produtos.length > 0;
}

// ---------- Ações ----------

// Busca a lista no banco e redesenha (RF-21: Carregando… e mensagem de erro).
// Se houver "mensagemDeSucesso", ela aparece depois que a lista chegar.
async function carregarProdutos(mensagemDeSucesso) {
  mostrarCarregando();
  try {
    desenharProdutos(await listarProdutosDaLoja(loja.id));
    if (mensagemDeSucesso) {
      mostrarSucesso(mensagemDeSucesso);
    } else {
      limparAvisos();
    }
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}

async function alternarAtivo(produto, botao) {
  botao.disabled = true;
  mostrarCarregando();
  try {
    await definirAtivo(produto.id, !produto.ativo);
    await carregarProdutos(produto.ativo ? "Produto desativado: ele não aparece mais no catálogo." : "Produto ativado: ele voltou ao catálogo.");
  } catch (erro) {
    botao.disabled = false;
    mostrarErro(mensagemDoErro(erro));
  }
}

async function excluir(produto, botao) {
  // Excluir não tem volta; por isso a confirmação antes
  if (!window.confirm('Excluir o produto "' + produto.nome + '"? Esta ação não pode ser desfeita.')) {
    return;
  }

  botao.disabled = true;
  mostrarCarregando("Excluindo…");
  try {
    await excluirProduto(produto.id);
    await carregarProdutos("Produto excluído.");
  } catch (erro) {
    // Produto já pedido: a mensagem sugere desativar em vez de excluir (RF-18)
    botao.disabled = false;
    mostrarErro(mensagemDoErro(erro));
  }
}

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();
  try {
    loja = await obterMinhaLoja();
    if (!loja) {
      limparAvisos();
      avisoSemLoja.hidden = false;
      return;
    }

    blocoDeAcoes.hidden = false;
    const salvo = new URLSearchParams(location.search).get("salvo");
    await carregarProdutos(MENSAGENS_DE_SALVO.get(salvo));
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}

iniciar();
```


### Passo 4: o formulário também edita

No `js/paginas/painelProdutoForm.js`, faça as trocas na ordem. (1) O cabeçalho do arquivo (comentários e importações):

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua o começo do arquivo, até a linha `import { criarProduto, validarProduto } from "../servicos/produtoServico.js";` (inclusive) por:

```js
// Painel da lojista: cadastrar e editar produto, com tamanhos.
// A página só valida, chama os serviços e mostra o resultado.
// Para editar, o endereço traz o id: painel-produto-form.html?id=...
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { obterMinhaLoja } from "../servicos/lojaServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";
import { obterProdutoParaEdicao, criarProduto, atualizarProduto, validarProduto } from "../servicos/produtoServico.js";
```


(2) O id do produto passa a vir do endereço (`?id=...`) quando é uma edição:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua o trecho que começa na linha `// O id do produto nasce AQUI, no navegador, antes de qualquer envio: assim o mesmo id vale para o produto e, depois, para as fotos.` e termina na linha `const produtoId = crypto.randomUUID();` (inclusive) por:

```js
const idNaUrl = new URLSearchParams(location.search).get("id");
const editando = idNaUrl !== null;

// O id do produto novo nasce AQUI, no navegador, antes de qualquer envio: assim o caminho das fotos no Storage
// ({loja_id}/{produto_id}/...) já existe, e o mesmo id é usado ao gravar o produto no banco.
const produtoId = editando ? idNaUrl : crypto.randomUUID();

const titulo = document.getElementById("titulo-pagina");
```


(3) Ao salvar, o formulário cria **ou** atualiza:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua o trecho que começa na linha `await criarProduto(dados);` e termina na linha `location.assign("painel-produtos.html?salvo=criado");` (inclusive) por:

```js
    if (editando) {
      await atualizarProduto(produtoId, dados);
    } else {
      await criarProduto(dados);
    }
    // A lista de produtos mostra a mensagem de sucesso
    location.assign("painel-produtos.html?salvo=" + (editando ? "editado" : "criado"));
```


(4) Cole a função que preenche os campos, **logo antes** de `iniciar`:

**Arquivo: `js/paginas/painelProdutoForm.js`**: adicione esta função (`preencherFormulario`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Ao editar: coloca nos campos o que já está salvo
function preencherFormulario(produto) {
  campoNome.value = produto.nome;
  campoDescricao.value = produto.descricao ?? "";
  campoCategoria.value = String(produto.categoria_id);
  campoPreco.value = produto.preco;
  campoAtivo.checked = produto.ativo;

  produto.tamanhos.forEach((item) => adicionarLinhaDeTamanho(item.tamanho, String(item.estoque)));
  if (produto.tamanhos.length === 0) {
    adicionarLinhaDeTamanho();
  }
}
```


(5) E troque a função `iniciar`:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  if (editando) {
    titulo.textContent = "Editar produto";
  }

  mostrarCarregando();
  try {
    loja = await obterMinhaLoja();
    if (!loja) {
      limparAvisos();
      avisoSemLoja.hidden = false;
      return;
    }

    preencherCategorias(await listarCategorias());

    if (editando) {
      // O serviço só devolve produtos DESTA loja; o de outra lojista vira "Produto não encontrado"
      preencherFormulario(await obterProdutoParaEdicao(idNaUrl, loja.id));
    } else {
      adicionarLinhaDeTamanho();
    }

    formulario.hidden = false;
    limparAvisos();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}
```


### Passo 5: teste o CRUD completo

1. Abra `painel-produtos.html`. Aparece a tabela com os produtos da loja (os 3 de exemplo e o **Short jeans** da aula passada), com a situação **Ativo**. Diminua a janela para 360 px: cada linha vira um bloco.
2. **Editar:** clique em **Editar** no **Short jeans**. O formulário abre com os dados preenchidos e o título **Editar produto**. Mude o preço para `69,90`, tire o tamanho G (**Remover tamanho**) e salve: volta para a lista com **Produto atualizado com sucesso.** No catálogo, o preço novo aparece.
3. **Desativar:** clique em **Desativar** no Short jeans. A situação vira **Inativo** e aparece **Produto desativado: ele não aparece mais no catálogo.** Confira no catálogo: ele sumiu (RN-08). Clique em **Ativar**: volta.
4. **Excluir:** clique em **Excluir** no Short jeans: o navegador pergunta **Excluir o produto "Short jeans"? Esta ação não pode ser desfeita.** Confirme: ele some.
5. **Excluir um produto já pedido (teste do banco):** no **SQL Editor** (em português: **Editor SQL**), grave um pedido de teste (troque os ids pelos seus; consulte `select id from public.perfis;` e `select id, loja_id from public.produtos;`):

```sql
insert into public.pedidos (id, cliente_id, loja_id, total)
values ('11111111-1111-1111-1111-111111111111', 'ID-DE-UM-PERFIL', 'ID-DA-LOJA', 49.90);
insert into public.itens_pedido (pedido_id, produto_id, tamanho, quantidade, preco_unitario)
values ('11111111-1111-1111-1111-111111111111', 'ID-DA-CAMISETA', 'M', 1, 49.90);
```

   Na tela, tente **Excluir** a **Camiseta básica branca**: aparece **Este produto já foi pedido; desative-o em vez de excluir.** Depois apague o pedido de teste: `delete from public.pedidos where id = '11111111-1111-1111-1111-111111111111';` (os itens somem junto).
6. Abra `painel-produto-form.html?id=abc`: aparece **Produto não encontrado.**

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Completa o CRUD de produtos: lista, edição, ativar e excluir"
git push
```

## Explicação do Código

**produtoServico.js**

- `listarProdutosDaLoja(lojaId)`: lista **todos** os produtos da loja, ativos e inativos (a lojista precisa ver os dois), com o nome da categoria (`categorias ( nome )`), ordenados por nome.
- `obterProdutoParaEdicao(id, lojaId)`: traz **um** produto, com todos os tamanhos e fotos (com o `caminho`), **filtrando também pela loja** (`.eq("loja_id", lojaId)`): assim a lojista não abre, por engano, o produto de outra. Um `id` que nem é um UUID (`abc`) gera o erro `22P02`, que também vira "Produto não encontrado".
- `atualizarProduto(id, dados)`: (1) lê como o produto está **hoje** (para saber quais tamanhos foram removidos); (2) `update` dos dados do produto, com `.select("id")`: se não voltou nenhuma linha, a alteração **não** foi permitida (`permissao_negada`); (3) `upsert` dos tamanhos atuais com `{ onConflict: "produto_id,tamanho" }` (a chave que identifica um tamanho) e `delete` dos tamanhos que a lojista tirou, usando `.in("tamanho", lista)`.
- `definirAtivo(id, ativo)`: `update({ ativo })`: liga ou desliga o produto no catálogo (RN-08).
- `excluirProduto(id)`: **antes** de apagar, conta quantos itens de pedido têm esse produto (`select("id", { count: "exact", head: true })` devolve só a **contagem**, sem trazer linhas). Se `count > 0`, lança o erro de "já foi pedido". Depois `delete`; se o banco recusar por chave estrangeira (`23503`, caso alguém peça o produto bem nessa hora), o erro vira a mesma mensagem.

**painelProdutos.js**

- `criarLinha(produto)`: monta uma linha de `<tr>` com `criarCelula`, que coloca `data-rotulo` (o texto que o CSS mostra ao lado do valor no celular) e `role="cell"`. O texto entra pelo DOM (nome do produto **nunca** com `innerHTML`). Os botões têm um texto escondido (`criarTextoOculto`) dizendo de qual produto são ("Editar (Short jeans)"), para o leitor de tela.
- `carregarProdutos(mensagemDeSucesso)`: mostra "Carregando…", desenha a tabela e depois a mensagem de sucesso (se houver).
- `alternarAtivo` e `excluir`: desabilitam o botão durante a chamada; `excluir` usa `window.confirm(...)` antes de apagar (excluir não tem volta). Em erro, o botão é liberado e a mensagem do `ErroApp` aparece.
- `MENSAGENS_DE_SALVO` (um `Map`) traduz o `?salvo=criado` ou `?salvo=editado` do endereço para a mensagem de sucesso mostrada depois de salvar o formulário.

**painelProdutoForm.js**: `idNaUrl` lê `?id=...`; se existir, `editando` é `true`. `preencherFormulario(produto)` põe os dados nos campos e cria uma linha por tamanho. No `submit`, `if (editando) atualizarProduto(...) else criarProduto(...)`.

## Validação

1. A tabela lista os produtos da loja, ativos e inativos, e vira blocos em 360 px.
2. A edição abre com os dados preenchidos, salva e mostra a mudança no catálogo.
3. Desativar tira o produto do catálogo; ativar traz de volta.
4. Excluir um produto novo funciona (com confirmação); excluir um produto já pedido mostra a mensagem sugerindo desativar.
5. `painel-produto-form.html?id=abc` mostra "Produto não encontrado."

**Erros comuns**

1. *Sintoma:* ao clicar em **Excluir** nada acontece. *Causa:* o `window.confirm` foi bloqueado ou cancelado, ou há erro no Console. *Correção:* abra o Console e clique de novo, lendo o erro.
2. *Mensagem:* `Você não tem permissão para alterar este produto`. *Causa:* o `update` não alterou linhas (o `id` não existe ou é de outra loja). *Correção:* confira o `id` na URL e se o produto é da loja de teste.
3. *Sintoma:* ao editar, o formulário abre vazio. *Causa:* o `?id=` não está na URL ou o `preencherFormulario` não foi chamado. *Correção:* confira o link **Editar** (`painel-produto-form.html?id=...`) e a função `iniciar`.
4. *Mensagem:* `Este item está ligado a outros dados` ao excluir. *Causa:* o produto está em um pedido e o banco recusou. *Correção:* desative em vez de excluir.

**Se travar**

1. No Console (F12), leia o primeiro erro vermelho; na aba **Network** (em português: **Rede**), clique no pedido que falhou e veja a **Response** (em português: **Resposta**).
2. Compare as funções com as da aula.
3. Se algo quebrou, volte ao último commit com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `painel-produtos.html` + `painelProdutos.js` (lista, ativar/desativar, excluir).
- `produtoServico.js` com `listarProdutosDaLoja`, `obterProdutoParaEdicao`, `atualizarProduto`, `definirAtivo` e `excluirProduto`.
- O formulário de produto cria **e edita**. Ainda **sem fotos**.

**Como saber que deu certo:** você desativa um produto e ele some do catálogo; ativa e ele volta; tenta excluir um produto já pedido e recebe a sugestão de desativar.
