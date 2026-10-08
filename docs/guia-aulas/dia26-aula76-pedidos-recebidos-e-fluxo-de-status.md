# Aula 76 – Pedidos recebidos e fluxo de status (lojista)

**Dia 26 · Qui 12/11/2026** · **Aula 76** · **UC6**

- **Requisitos cobertos:** RF-20 (mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado), RN-05 (o status segue novo, confirmado e concluído; cancelado vale enquanto o pedido não estiver concluído; o banco recusa outras mudanças), RN-09 (só a lojista dona da loja altera o status dos pedidos recebidos) e RN-13 (a lojista não altera valores, itens, cliente nem loja); casos de teste CT-18 e CT-20 pelo console
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** MVP versão 0.9 publicado: login, RLS ligada, pedidos gravados pela função criar_pedidos; classe Pedido sem o acompanhamento (Dias 13 e 15); pelo menos um pedido gravado no banco

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar a tela **Pedidos recebidos**: a lojista vê **só os pedidos da própria loja**, com itens, total e a cliente, e usa **botões que seguem o fluxo** de status (novo → confirmado → concluído, com **cancelado** possível enquanto não for concluído). Cada atualização pode levar um **recado** opcional para a cliente, salvo junto com o status.

**Abertura (10 minutos).** Retomada do Dia 15: o MVP foi publicado e avaliado, e ficaram cartões no Kanban (**RF-11, RF-20, RF-22 e RF-25**). Os pedidos já são **gravados** no banco, mas a lojista só os vê no painel do Supabase. A partir de hoje (Dia 26, **UC6**), o foco é **fechar a versão 1.0**. Confira antes de começar: existe pelo menos um pedido na tabela `pedidos` (se não, faça uma compra como cliente) e a lojista dona dele tem a loja cadastrada.

## O Conceito

**Termos desta aula**

- **Fluxo de status**: a ordem em que um pedido pode andar: `novo` → `confirmado` → `concluido`, e `cancelado` a partir de `novo` ou `confirmado`. `concluido` e `cancelado` são **finais**.
- **Recado**: um texto opcional (até 500 caracteres) que a lojista deixa para a cliente ("Separado, pode retirar amanhã"). É salvo **junto** com o status, na **mesma atualização**.
- **Atualização condicionada**: o `update` só vale se o pedido **ainda está** no status que a tela viu (`.eq("status", atual.status)`). Evita atropelar uma mudança feita em outra aba ou aparelho.
- **Defesa em duas camadas**: o **site** só mostra os botões permitidos (`Pedido.proximosStatus()`), e o **banco** recusa mudanças proibidas (o gatilho da Aula 39). Se alguém burlar a tela pelo console, o banco ainda recusa.

**Analogia:** o pedido é uma **encomenda** que anda por um caminho de mão única: recebida → confirmada → entregue. A lojista só pode apertar o botão da **próxima estação** (ou "cancelar"). O banco é o **fiscal** que, mesmo se alguém forçar a catraca, não deixa passar fora da ordem.

## Mão na Massa

### Passo 1: a classe Pedido completa

Em `js/modelos/Pedido.js` faça as trocas na ordem. (1) Os rótulos que a lojista enxerga, **logo antes** de `export class Pedido {`:

**Arquivo: `js/modelos/Pedido.js`**: adicione este trecho logo antes da linha `export class Pedido {`:

```js
// Textos que a lojista enxerga no painel.
const ROTULOS_PARA_LOJISTA = {
  novo: "Novo",
  confirmado: "Confirmado",
  concluido: "Concluído",
  cancelado: "Cancelado",
};

```


(2) Os campos novos (logo depois de `#itens`):

**Arquivo: `js/modelos/Pedido.js`**: substitua a linha `#itens; // cada item: { produtoId, nome, tamanho, quantidade, precoUnitario }` por:

```js
  #itens; // cada item: { produtoId, nome, tamanho, quantidade, precoUnitario }
  #mensagemLoja; // recado da lojista para a cliente (RN-13)
  #statusVisto; // false = a cliente ainda não viu a novidade (RN-13)
  #criadoEm;
  #clienteNome; // só vem preenchido para a lojista (ela lê o perfil das clientes dos seus pedidos)
  #clienteTelefone;
```


(3) O construtor completo:

**Arquivo: `js/modelos/Pedido.js`**: substitua o método `constructor` inteiro (do comentário acima dela até a chave que a fecha) por:

```js
  constructor({
    id = null,
    grupoId,
    lojaId,
    lojaNome = "",
    status = "novo",
    itens,
    mensagemLoja = "",
    statusVisto = true,
    criadoEm = null,
    clienteNome = "",
    clienteTelefone = "",
  }) {
    if (!grupoId) {
      throw new ErroApp("grupo_invalido", "O pedido precisa de um grupo.");
    }
    if (lojaId === undefined || lojaId === null) {
      throw new ErroApp("loja_invalida", "O pedido precisa de uma loja.");
    }
    if (!Array.isArray(itens) || itens.length === 0) {
      throw new ErroApp("pedido_vazio", "O pedido precisa ter pelo menos um item.");
    }
    if (!(status in FLUXO_DE_STATUS)) {
      throw new ErroApp("status_invalido", "Status de pedido inválido.");
    }

    this.#id = id;
    this.#grupoId = grupoId;
    this.#lojaId = lojaId;
    this.#lojaNome = lojaNome;
    this.#status = status;
    this.#itens = itens.map((item) => ({ ...item }));
    this.#mensagemLoja = String(mensagemLoja ?? "");
    this.#statusVisto = statusVisto !== false;
    this.#criadoEm = criadoEm;
    this.#clienteNome = clienteNome ?? "";
    this.#clienteTelefone = clienteTelefone ?? "";
  }
```


(4) Os leitores novos, **logo antes** de `get grupoId`:

**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`mensagemLoja`) logo antes do método `grupoId` (junto com os comentários que ficam acima dela):

```js
  get mensagemLoja() {
    return this.#mensagemLoja;
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`statusVisto`) logo antes do método `grupoId` (junto com os comentários que ficam acima dela):

```js
  get statusVisto() {
    return this.#statusVisto;
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`criadoEm`) logo antes do método `grupoId` (junto com os comentários que ficam acima dela):

```js
  get criadoEm() {
    return this.#criadoEm;
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`clienteNome`) logo antes do método `grupoId` (junto com os comentários que ficam acima dela):

```js
  get clienteNome() {
    return this.#clienteNome;
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`clienteTelefone`) logo antes do método `grupoId` (junto com os comentários que ficam acima dela):

```js
  get clienteTelefone() {
    return this.#clienteTelefone;
  }
```


(5) Os métodos de status e de leitura, **logo antes** de `codigoCurto`:

**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`deLinha`) logo antes do método `codigoCurto` (junto com os comentários que ficam acima dela):

```js
  // Monta um Pedido a partir de uma linha do banco (colunas em snake_case, com as tabelas relacionadas dentro):
  // lojas, itens_pedido (cada item com o seu produto) e, para a lojista, o perfil da cliente.
  static deLinha(linha) {
    return new Pedido({
      id: linha.id,
      grupoId: linha.grupo_id,
      lojaId: linha.loja_id,
      lojaNome: linha.lojas?.nome ?? "",
      status: linha.status,
      itens: (linha.itens_pedido ?? []).map((item) => ({
        produtoId: item.produto_id,
        // Se o produto saiu do catálogo (foi desativado), a leitura pública não o devolve: usamos um nome neutro
        nome: item.produtos?.nome ?? "Produto indisponível",
        tamanho: item.tamanho,
        quantidade: item.quantidade,
        precoUnitario: Number(item.preco_unitario),
      })),
      mensagemLoja: linha.mensagem_loja ?? "",
      statusVisto: linha.status_visto,
      criadoEm: linha.criado_em,
      clienteNome: linha.perfis?.nome ?? "",
      clienteTelefone: linha.perfis?.telefone ?? "",
    });
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`statusPermitidos`) logo antes do método `codigoCurto` (junto com os comentários que ficam acima dela):

```js
  // RN-05: para quais status um pedido que está em "statusAtual" pode ir. Estático para o serviço
  // conferir a transição sem precisar montar um Pedido inteiro.
  static statusPermitidos(statusAtual) {
    return [...(FLUXO_DE_STATUS[statusAtual] ?? [])];
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`proximosStatus`) logo antes do método `codigoCurto` (junto com os comentários que ficam acima dela):

```js
  // Lista os status para os quais este pedido pode ir agora (RN-05).
  proximosStatus() {
    return Pedido.statusPermitidos(this.#status);
  }
```


**Arquivo: `js/modelos/Pedido.js`**: adicione este método (`alterarStatus`) logo antes do método `codigoCurto` (junto com os comentários que ficam acima dela):

```js
  // Muda o status, mas só se o fluxo permitir; senão lança ErroApp.
  alterarStatus(novoStatus) {
    if (!this.proximosStatus().includes(novoStatus)) {
      throw new ErroApp(
        "status_nao_permitido",
        'Não é possível mudar o pedido de "' +
          ROTULOS_PARA_CLIENTE[this.#status] +
          '" para "' +
          (ROTULOS_PARA_CLIENTE[novoStatus] ?? novoStatus) +
          '".'
      );
    }
    this.#status = novoStatus;
  }
```


(6) O fim da classe: troque do método `rotuloParaCliente` até o final do arquivo por:

**Arquivo: `js/modelos/Pedido.js`**: substitua o trecho que começa na linha `rotuloParaCliente() {` e termina na linha `FIM` (inclusive) por:

```js
  rotuloParaCliente() {
    return ROTULOS_PARA_CLIENTE[this.#status];
  }

  rotuloParaLojista() {
    return ROTULOS_PARA_LOJISTA[this.#status];
  }

  // Aviso que a lojista pode mandar à cliente pelo WhatsApp (RF-22, desejável):
  // "Olá, <nome>! Seu pedido #<código> na <loja> agora está: <rótulo>. <recado, se houver>"
  mensagemDeStatusParaCliente() {
    const recado = this.#mensagemLoja.trim();
    return (
      "Olá, " + this.#clienteNome + "! Seu pedido #" + this.codigoCurto() + " na " + this.#lojaNome +
      " agora está: " + this.rotuloParaCliente() + "." + (recado ? " " + recado : "")
    );
  }
}
```


### Passo 2: as datas em dd/mm/aaaa

Em `js/ui/formatadores.js`, cole o formatador de data **logo antes** de `formatarPreco` e a função `formatarData` **logo antes** de `normalizarTelefone`:

**Arquivo: `js/ui/formatadores.js`**: adicione esta constante (`formatadorDeData`) logo antes da função `formatarPreco` (junto com os comentários que ficam acima dela):

```js
const formatadorDeData = new Intl.DateTimeFormat("pt-BR", {
  day: "2-digit",
  month: "2-digit",
  year: "numeric",
});
```


**Arquivo: `js/ui/formatadores.js`**: adicione esta função (`formatarData`) logo antes da função `normalizarTelefone` (junto com os comentários que ficam acima dela):

```js
// Aceita um Date ou um texto de data (por exemplo o criado_em do banco).
// "2026-11-05T14:30:00Z" -> "05/11/2026"
export function formatarData(data) {
  return formatadorDeData.format(new Date(data));
}
```


### Passo 3: o serviço de pedidos recebidos

No `js/servicos/pedidoServico.js`, cole **no final do arquivo** o bloco de comentário, as constantes e as duas funções. (O comentário diz "Fase 8", uma anotação de um roteiro antigo que você pode ignorar.)

**Arquivo: `js/servicos/pedidoServico.js`**: adicione este trecho no final do arquivo:

```js
// =====================================================================
// Acompanhamento do pedido (Fase 8): Meus pedidos, pedidos recebidos e aviso de novidades
// (RF-11, RF-20, RF-22, RN-13). Quem pode ler ou alterar o quê é decidido pelas regras RLS do banco.
// =====================================================================

// Colunas do pedido, com a loja e os itens (cada item com o nome do produto).
const CAMPOS_DO_PEDIDO =
  "id, grupo_id, loja_id, cliente_id, status, total, mensagem_loja, status_visto, atualizado_em, criado_em, " +
  "lojas ( id, nome ), " +
  "itens_pedido ( id, produto_id, tamanho, quantidade, preco_unitario, produtos ( nome ) )";

// Para a lojista, o pedido vem também com o nome e o telefone da cliente (as regras RLS liberam só as clientes dos pedidos dela)
const CAMPOS_DO_PEDIDO_COM_CLIENTE = CAMPOS_DO_PEDIDO + ", perfis ( nome, telefone )";

const TAMANHO_MAXIMO_DO_RECADO = 500;

```


**Arquivo: `js/servicos/pedidoServico.js`**: adicione esta função (`listarPedidosDaMinhaLoja`) no final do arquivo:

```js
// RF-20: os pedidos recebidos pela loja da lojista, do mais recente ao mais antigo, com o nome e o telefone da cliente.
export async function listarPedidosDaMinhaLoja(lojaId) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase
      .from("pedidos")
      .select(CAMPOS_DO_PEDIDO_COM_CLIENTE)
      .eq("loja_id", lojaId)
      .order("criado_em", { ascending: false });

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar os pedidos recebidos. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/pedidoServico.js`**: adicione esta função (`atualizarPedido`) no final do arquivo:

```js
// RF-20, RN-05, RN-13: a lojista muda o status e/ou deixa um recado, numa ÚNICA atualização.
// Os dois campos são opcionais: só o recado ({ mensagemLoja }) ou só o status ({ status }) também valem.
// Um recado vazio apaga o recado. Devolve o pedido já atualizado (mesmo formato de listarPedidosDaMinhaLoja).
//
// O banco só deixa mudar status e recado (um gatilho recusa o resto) e marca o pedido como novidade para a cliente.
// Mas o banco NÃO confere o fluxo da RN-05; quem impede, por exemplo, "cancelado" voltar para "confirmado" é este código.
export async function atualizarPedido(id, { status, mensagemLoja } = {}) {
  try {
    const mudancas = {};

    if (mensagemLoja !== undefined) {
      const recado = String(mensagemLoja ?? "").trim();
      if (recado.length > TAMANHO_MAXIMO_DO_RECADO) {
        throw new ErroApp("recado_longo", "O recado deve ter no máximo " + TAMANHO_MAXIMO_DO_RECADO + " caracteres.");
      }
      mudancas.mensagem_loja = recado === "" ? null : recado;
    }

    const supabase = exigirSupabase();

    // Como o pedido está agora: serve para conferir a transição de status
    const { data: atual, error: erroAoLer } = await supabase.from("pedidos").select("id, status").eq("id", id).maybeSingle();
    if (erroAoLer) {
      throw erroAoLer;
    }
    if (!atual) {
      throw new ErroApp("pedido_nao_encontrado", "Pedido não encontrado.");
    }

    if (status !== undefined && status !== atual.status) {
      if (!Pedido.statusPermitidos(atual.status).includes(status)) {
        throw new ErroApp("status_nao_permitido", "Esta mudança de status não é permitida para este pedido.");
      }
      mudancas.status = status;
    }

    if (Object.keys(mudancas).length === 0) {
      throw new ErroApp("nada_a_salvar", "Não há nenhuma mudança para salvar.");
    }

    // O filtro por status evita atropelar uma mudança feita em outra aba ou aparelho
    const { data: alterados, error: erroAoAtualizar } = await supabase
      .from("pedidos")
      .update(mudancas)
      .eq("id", id)
      .eq("status", atual.status)
      .select(CAMPOS_DO_PEDIDO_COM_CLIENTE);

    if (erroAoAtualizar) {
      throw erroAoAtualizar;
    }
    if (alterados.length === 0) {
      throw new ErroApp("pedido_nao_atualizado", "O pedido mudou em outro lugar ou não é da sua loja. Recarregue a página.");
    }
    return alterados[0];
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível atualizar o pedido. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 4: a tela Pedidos recebidos

Crie `painel-pedidos.html` e `js/paginas/painelPedidos.js`:

**Arquivo: `painel-pedidos.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pedidos recebidos – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container" hidden>
    <nav aria-label="Painel da lojista">
      <ul class="navegacao-painel">
        <li><a href="painel-loja.html">Minha loja</a></li>
        <li><a href="painel-produtos.html">Meus produtos</a></li>
        <li><a href="painel-pedidos.html" aria-current="page">Pedidos recebidos</a></li>
      </ul>
    </nav>

    <h1>Pedidos recebidos</h1>
    <p class="visualmente-oculto" id="anuncio-pedidos" role="status" aria-live="polite"></p>

    <p class="aviso aviso-info" id="aviso-sem-loja" role="status" hidden>
      Cadastre a sua loja para receber pedidos. <a href="painel-loja.html">Ir para Minha loja</a>
    </p>

    <p class="aviso aviso-info" id="mensagem-sem-pedidos" role="status" hidden>Sua loja ainda não recebeu nenhum pedido.</p>

    <div id="lista-pedidos"></div>
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

  <script type="module" src="js/paginas/painelPedidos.js"></script>
</body>
</html>
```


**Arquivo: `js/paginas/painelPedidos.js`** (arquivo novo, inteiro)

```js
// Painel da lojista: Pedidos recebidos (RF-20, RF-22, RN-05, RN-13). Só a lojista abre esta tela (RF-14).
// A lojista muda o status do pedido e/ou deixa um recado; a cliente é avisada em Meus pedidos.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { exigirPerfil } from "../ui/protecao.js";
import { formatarPreco, formatarData, criarLinkDoWhatsapp } from "../ui/formatadores.js";
import { Pedido } from "../modelos/Pedido.js";
import { obterMinhaLoja } from "../servicos/lojaServico.js";
import { listarPedidosDaMinhaLoja, atualizarPedido } from "../servicos/pedidoServico.js";
import { criarElemento } from "../ui/elementos.js";

const anuncio = document.getElementById("anuncio-pedidos");
const avisoSemLoja = document.getElementById("aviso-sem-loja");
const mensagemSemPedidos = document.getElementById("mensagem-sem-pedidos");
const listaDePedidos = document.getElementById("lista-pedidos");

// Texto do botão de cada status de destino. Só aparecem os que Pedido.proximosStatus() permite (RN-05).
const TEXTO_DOS_BOTOES = {
  confirmado: "Confirmar reserva",
  concluido: "Marcar como concluído",
  cancelado: "Cancelar pedido",
};

const TEXTO_DE_SUCESSO = {
  confirmado: "reserva confirmada",
  concluido: "marcado como concluído",
  cancelado: "cancelado",
};

// Texto só para leitor de tela: diz de qual pedido é o botão
function criarTextoOculto(pedido) {
  return criarElemento("span", "visualmente-oculto", " (pedido #" + pedido.codigoCurto() + ")");
}

function criarBotao(texto, classe, pedido, aoClicar) {
  const botao = criarElemento("button", "botao botao-pequeno " + classe);
  botao.type = "button";
  botao.append(texto, criarTextoOculto(pedido));
  botao.addEventListener("click", () => aoClicar(botao));
  return botao;
}

// ---------- Cartão de um pedido ----------

function criarCartao(pedido) {
  const cartao = criarElemento("article", "compra");
  cartao.id = "cartao-" + pedido.id;
  const idDoTitulo = "titulo-" + pedido.id;
  cartao.setAttribute("aria-labelledby", idDoTitulo);

  const topo = criarElemento("div", "pedido-loja-topo");
  const titulo = criarElemento("h2", "", "Pedido #" + pedido.codigoCurto() + " – " + formatarData(pedido.criadoEm));
  titulo.id = idDoTitulo;
  topo.append(titulo, criarElemento("span", "selo selo-" + pedido.status, pedido.rotuloParaLojista()));

  const itens = criarElemento("ul", "pedido-itens");
  pedido.itens.forEach((item) => {
    itens.append(
      criarElemento("li", "", item.quantidade + "x " + item.nome + " (tamanho " + item.tamanho + ") – " + formatarPreco(item.precoUnitario) + " cada")
    );
  });

  cartao.append(
    topo,
    criarElemento("p", "", "Cliente: " + (pedido.clienteNome || "não informado")),
    itens,
    criarElemento("p", "", "Total do pedido: " + formatarPreco(pedido.total))
  );

  if (pedido.mensagemLoja.trim() !== "") {
    const recado = criarElemento("p", "recado-loja");
    recado.append(criarElemento("strong", "", "Recado atual para a cliente: "), pedido.mensagemLoja);
    cartao.append(recado);
  }

  cartao.append(criarFormularioDeAtualizacao(pedido));

  // RF-22 (desejável): se a cliente tem telefone, a lojista pode avisá-la pelo WhatsApp (RN-10)
  const linkDoWhatsapp = criarLinkDoWhatsapp(pedido.clienteTelefone, pedido.mensagemDeStatusParaCliente());
  if (linkDoWhatsapp) {
    const botao = criarElemento("a", "botao botao-whatsapp botao-pequeno", "Avisar a cliente pelo WhatsApp");
    botao.href = linkDoWhatsapp;
    botao.target = "_blank";
    botao.rel = "noopener";
    botao.append(criarElemento("span", "visualmente-oculto", " (abre em nova aba)"));
    cartao.append(botao);
  }

  return cartao;
}

// Recado + botões de status. Os botões de status salvam o status E o recado juntos, numa só atualização.
function criarFormularioDeAtualizacao(pedido) {
  const bloco = criarElemento("div", "pedido-atualizar");

  const campo = criarElemento("div", "campo");
  const rotulo = criarElemento("label", "", "Recado para a cliente (opcional)");
  rotulo.htmlFor = "recado-" + pedido.id;
  const recado = criarElemento("textarea");
  recado.id = "recado-" + pedido.id;
  recado.maxLength = 500;
  recado.value = pedido.mensagemLoja;
  campo.append(rotulo, recado);

  const acoes = criarElemento("div", "acoes-formulario");

  // Só as transições permitidas (RN-05), inclusive cancelar enquanto não estiver concluído
  pedido.proximosStatus().forEach((status) => {
    const classe = status === "cancelado" ? "botao-perigo" : "";
    acoes.append(criarBotao(TEXTO_DOS_BOTOES[status], classe, pedido, (botao) => salvar(pedido, { status }, recado, botao)));
  });
  acoes.append(criarBotao("Salvar só o recado", "botao-secundario", pedido, (botao) => salvar(pedido, {}, recado, botao)));

  bloco.append(campo, acoes);
  return bloco;
}

// ---------- Salvar ----------

async function salvar(pedido, mudanca, campoDoRecado, botao) {
  // Cancelar não tem volta: confirma antes
  if (mudanca.status === "cancelado" && !window.confirm("Cancelar este pedido? A cliente será avisada em Meus pedidos.")) {
    return;
  }

  const cartao = document.getElementById("cartao-" + pedido.id);
  const botoes = cartao.querySelectorAll("button");
  botoes.forEach((b) => (b.disabled = true));
  limparAvisos();
  mostrarCarregando("Salvando…");

  try {
    // Uma única atualização: status (se houver) e recado juntos
    const linha = await atualizarPedido(pedido.id, { ...mudanca, mensagemLoja: campoDoRecado.value });
    const atualizado = Pedido.deLinha(linha);

    // Troca só este cartão, sem mexer nos recados que a lojista esteja escrevendo nos outros
    const novoCartao = criarCartao(atualizado);
    cartao.replaceWith(novoCartao);

    const mensagem = mudanca.status
      ? "Pedido #" + atualizado.codigoCurto() + ": " + TEXTO_DE_SUCESSO[mudanca.status] + ". A cliente será avisada em Meus pedidos."
      : "Recado salvo. A cliente será avisada em Meus pedidos.";
    mostrarSucesso(mensagem);
    anuncio.textContent = mensagem;
    novoCartao.querySelector("textarea").focus();
  } catch (erro) {
    // Ex.: o banco recusou a mudança (gatilho da RN-13) ou o fluxo de status não permite
    limparAvisos();
    mostrarErro(mensagemDoErro(erro));
    botoes.forEach((b) => (b.disabled = false));
  }
}

// ---------- Abrir a tela ----------

function desenhar(pedidos) {
  listaDePedidos.replaceChildren(...pedidos.map(criarCartao));
  mensagemSemPedidos.hidden = pedidos.length > 0;
}

async function iniciar() {
  montarCabecalho();
  const usuaria = await exigirPerfil("lojista");
  if (!usuaria) {
    return;
  }

  mostrarCarregando();
  try {
    const loja = await obterMinhaLoja();
    if (!loja) {
      limparAvisos();
      avisoSemLoja.hidden = false;
      return;
    }

    const linhas = await listarPedidosDaMinhaLoja(loja.id);
    // Pedido sem itens ficou pela metade (falha ao gravar os itens): não há o que mostrar
    desenhar(linhas.filter((linha) => (linha.itens_pedido ?? []).length > 0).map(Pedido.deLinha));
    limparAvisos();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}

iniciar();
```


No `css/paginas.css`, cole a seção do botão de aviso **logo antes** do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

```css
/* ---------- Pedidos recebidos: botão de aviso pelo WhatsApp ---------- */
.pedido-atualizar + .botao-whatsapp {
  margin-top: var(--espaco-3);
}
```


### Passo 5: teste o fluxo de status (CT-17 parte da lojista)

1. Entre como a **lojista dona** de um pedido e abra **Painel** > **Pedidos recebidos** (em português, o menu do painel: **Minha loja**, **Meus produtos** e **Pedidos recebidos**). Cada pedido é um cartão com **código** (`#xxxxxxxx`), data, selo de status (**Novo**), o nome da **cliente**, os itens, o **Total do pedido**, um campo **Recado para a cliente (opcional)** e botões.
2. Num pedido **novo**, só aparecem **Confirmar reserva**, **Cancelar pedido** e **Salvar só o recado**. Escreva o recado `Separado, pode retirar amanhã` e clique em **Confirmar reserva**: aparece **Pedido #...: reserva confirmada. A cliente será avisada em Meus pedidos.** O cartão mostra o selo **Confirmado** e **Recado atual para a cliente**.
3. Agora, no pedido **confirmado**, aparecem **Marcar como concluído**, **Cancelar pedido** e **Salvar só o recado**. Clique em **Marcar como concluído**: o selo vira **Concluído** e só resta **Salvar só o recado**.
4. Em outro pedido novo, clique em **Cancelar pedido**: o navegador pergunta **Cancelar este pedido? A cliente será avisada em Meus pedidos.** Confirme: selo **Cancelado**.
5. Se a cliente tem telefone cadastrado, aparece o botão **Avisar a cliente pelo WhatsApp**, com a mensagem pronta ("Olá, Marina! Seu pedido #... na Loja Exemplo agora está: Reserva confirmada. ..."). Sem telefone, o botão não aparece.
6. Entre como **outra lojista**: ela **não** vê esses pedidos (RN-09): só os da loja dela, e se a loja dela ainda não recebeu nada aparece **Sua loja ainda não recebeu nenhum pedido.**
7. Confira no **SQL Editor** (em português: **Editor SQL**): `select status, mensagem_loja, status_visto, atualizado_em from public.pedidos;`. Os pedidos mexidos têm `status_visto = false` (a cliente ainda não viu a novidade).

### Passo 6: teste a defesa do banco pelo console (CT-18 e CT-20)

Entre como **lojista**, abra qualquer página e o Console (F12 > **Console**, em português: **Console**). Troque `ID-DO-PEDIDO` por um pedido **da sua loja** (`select id, status from public.pedidos;`).

**CT-18 (alterar o total):**

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
console.log(await supabase.from("pedidos").update({ total: 1 }).eq("id", "ID-DO-PEDIDO").select("id"));
```

Esperado: `error` com a mensagem **"Só o status e o recado do pedido podem ser alterados."**. Repita com a conta da **outra** lojista: `data: []` (nenhuma linha afetada, RN-09).

**CT-20 (pular etapa e mexer no aviso).** Use um pedido que esteja **novo** e rode:

```js
const id = "ID-DO-PEDIDO";
console.log("pular etapa  ->", (await supabase.from("pedidos").update({ status: "concluido" }).eq("id", id)).error?.message);
console.log("mexer no aviso ->", (await supabase.from("pedidos").update({ status_visto: true }).eq("id", id)).error?.message);
```

Esperado: **"Esta mudança de status não é permitida para este pedido."** para o primeiro. O segundo só é recusado quando o pedido já tem uma novidade (por exemplo, depois de confirmar); então a mensagem é **"Só o status e o recado do pedido podem ser alterados."**.

### Passo 7: faça o commit da aula

```bash
git switch -c pedidos-recebidos
git add .
git commit -m "Cria a tela de pedidos recebidos com o fluxo de status e o recado"
git push -u origin pedidos-recebidos
```

Abra um pull request e peça a revisão de outra integrante (como na Aula 42). Depois do merge, volte para a `main` com `git switch main` e `git pull`.

## Explicação do Código

**Pedido.js (completa)**

- `ROTULOS_PARA_LOJISTA`: os nomes dos status no painel (Novo, Confirmado, Concluído, Cancelado); a cliente vê outros (Enviado à loja, Reserva confirmada...).
- O construtor agora recebe também `mensagemLoja`, `statusVisto`, `criadoEm`, `clienteNome` e `clienteTelefone` (só vêm preenchidos para a lojista).
- `static deLinha(linha)`: monta um `Pedido` a partir de uma linha do banco (com `lojas`, `itens_pedido` e, para a lojista, `perfis`). Se o produto de um item saiu do catálogo (foi desativado), o nome vira "Produto indisponível".
- `static statusPermitidos(statusAtual)`: devolve a lista de status de destino permitidos (do `FLUXO_DE_STATUS`). É estático para o serviço conferir a mudança **sem montar um Pedido inteiro**. `proximosStatus()` usa o status do próprio pedido. `alterarStatus(novo)` só muda se o fluxo permitir; senão lança `ErroApp("status_nao_permitido", ...)`.
- `mensagemDeStatusParaCliente()`: o texto do aviso por WhatsApp.

**pedidoServico.js**

- `CAMPOS_DO_PEDIDO` e `CAMPOS_DO_PEDIDO_COM_CLIENTE`: o texto do `select` com o pedido, a loja (`lojas ( id, nome )`), os itens (`itens_pedido ( ... produtos ( nome ) )`) e, para a lojista, o `perfis ( nome, telefone )` da cliente (a RLS libera só as clientes dos pedidos dela).
- `listarPedidosDaMinhaLoja(lojaId)`: `.eq("loja_id", lojaId)` e `.order("criado_em", { ascending: false })`: do mais recente ao mais antigo.
- `atualizarPedido(id, { status, mensagemLoja })`: (1) valida o recado (até 500 caracteres; vazio apaga o recado); (2) lê o status **atual**; (3) se o status mudou, confere `Pedido.statusPermitidos(atual.status).includes(status)` (senão "Esta mudança de status não é permitida para este pedido."); (4) se não há **nada** para salvar, avisa; (5) faz **um único `update`** com as mudanças, condicionado a `.eq("status", atual.status)`, e devolve o pedido atualizado. Se nenhuma linha voltar, o pedido mudou em outro lugar ou não é da loja dela.

**painelPedidos.js**

- `criarCartao(pedido)`: monta o cartão com `criarElemento` (tudo com `textContent`: o nome da cliente e o recado vêm de fora). `criarFormularioDeAtualizacao(pedido)`: o campo de recado (um `textarea` com `maxLength = 500`) e os botões: **só** os status de `pedido.proximosStatus()`, com o texto de `TEXTO_DOS_BOTOES`, mais **Salvar só o recado**. O botão **Cancelar pedido** usa `botao-perigo`.
- `salvar(pedido, mudanca, campoDoRecado, botao)`: pede confirmação ao cancelar, desabilita os botões do cartão, chama `atualizarPedido` com status **e** recado juntos e troca **só aquele cartão** pelo novo (`cartao.replaceWith(...)`), para não perder os recados que a lojista esteja escrevendo nos outros. A mensagem de sucesso vai também para uma região `aria-live` escondida (`#anuncio-pedidos`).
- `iniciar()`: protege a tela (`exigirPerfil("lojista")`), busca a loja e os pedidos (filtrando pedidos sem itens, que ficaram pela metade) e desenha.

## Validação

1. A lojista vê **só** os pedidos da própria loja, com itens, total e cliente.
2. Os botões seguem o fluxo: em pedido novo, **Confirmar reserva** e **Cancelar**; em confirmado, **Marcar como concluído** e **Cancelar**; nos finais, só o recado.
3. Status e recado são salvos juntos; o pedido fica com `status_visto = false`.
4. Pelo console, o banco recusa mudar o total (CT-18), pular de **novo** para **concluído** e mexer em `status_visto` (CT-20).
5. Outra lojista não vê nem altera esses pedidos.

**Erros comuns**

1. *Sintoma:* "Sua loja ainda não recebeu nenhum pedido", mas existem pedidos. *Causa:* você entrou com a lojista que **não** é dona da loja do pedido. *Correção:* entre com a dona (`select l.nome, p.id from pedidos p join lojas l on l.id = p.loja_id;`).
2. *Mensagem:* `Esta mudança de status não é permitida para este pedido.` ao clicar. *Causa:* o pedido já está em um status final ou a tela está desatualizada. *Correção:* recarregue a página e use os botões que aparecem.
3. *Mensagem:* `O pedido mudou em outro lugar ou não é da sua loja. Recarregue a página.` *Causa:* o pedido foi alterado em outra aba depois que a tela carregou. *Correção:* recarregue.
4. *Sintoma:* o nome da cliente não aparece ("Cliente: não informado"). *Causa:* a política de RLS que deixa a lojista ler o perfil das clientes dos seus pedidos não existe. *Correção:* rode o `02_rls.sql` de novo (Aula 39).

**Se travar**

1. No Console (F12) e na aba **Network** (em português: **Rede**), veja a **Response** (em português: **Resposta**) do `update`: o banco diz o motivo.
2. Teste a transição pelo SQL (`update public.pedidos set status = 'confirmado' where id = '...';`) para ver se o gatilho aceita.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `painel-pedidos.html` e `js/paginas/painelPedidos.js`.
- `Pedido.js` completo (fluxo de status, rótulos e leitura do banco); `pedidoServico.js` com `listarPedidosDaMinhaLoja` e `atualizarPedido`; `formatarData` nos formatadores.
- A lojista atualizando status e recado, com a defesa do banco testada.

**Como saber que deu certo:** a lojista confirma um pedido com um recado, o selo muda, e o banco recusa, pelo console, mudar o total ou pular uma etapa.
