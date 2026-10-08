# Aula 36 – Finalizar a sacola: um pedido por loja e WhatsApp por loja

**Dia 12 · Qui 22/10/2026** · **Aula 36** · **UC3**

- **Requisitos cobertos:** RF-10 (parte: um pedido por loja e um botão de WhatsApp por loja; a gravação no banco e o login chegam no Dia 13), RN-03 (um pedido por loja, todos com o mesmo grupo_id), RN-06 (a cliente só paga o preço que viu) e RN-10 (link https://wa.me/número?text=mensagem)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** sacola funcionando (itens por loja, quantidades, totais, contador no cabeçalho); sacola.html com a seção de confirmação (Aula 35)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar a **classe `Pedido`** (um pedido para **cada loja**, todos com o mesmo código de compra, o **`grupo_id`**), **conferir o preço atual** antes de finalizar (e avisar se mudou) e mostrar a tela **Pedidos enviados** com **um botão de WhatsApp por loja**, com o resumo só daquela loja. **Ainda não grava no banco:** a gravação (e o login) entra no Dia 13.

**Abertura (10 minutos).** Retomada da Aula 35: a sacola mostra as peças por loja com subtotal e total, mas o botão **Finalizar sacola** não faz nada. Pense na lojista: a Loja Exemplo só pode receber **o que é dela**, não a sacola inteira, e a Loja do Bairro também. Hoje a sacola é "cortada" em um pedido por loja.

> **Atenção, uma decisão do curso:** o plano original previa gravar os pedidos já hoje. Mas o banco só aceita gravar pedidos pela função `criar_pedidos()`, que depende do **login** (só a cliente logada faz pedido) e das regras de acesso (Dia 13). Por isso, **hoje o pedido é montado na memória** (e a tela de confirmação funciona), e **a gravação entra no Dia 13**. O texto "Pedidos gravados!" da confirmação ainda não é verdade nesta etapa.

## O Conceito

**Termos desta aula**

- **Pedido por loja**: cada loja da sacola vira **um** pedido, com os itens só dela, o seu total e o seu status. Uma sacola com peças de 3 lojas gera 3 pedidos (RN-03).
- **`grupo_id`**: um código que **todos** os pedidos da mesma finalização compartilham (é a "compra"). Depois, a cliente verá os pedidos juntos, por compra.
- **Conferência de preço (RN-06)**: a lojista pode mudar o preço **depois** que a peça entrou na sacola. Antes de finalizar, o sistema compara o preço guardado com o do banco: se mudou, **não grava**, atualiza a sacola e avisa a cliente. Assim ela nunca paga um valor que não viu.
- **Link do WhatsApp por loja**: cada pedido tem o seu botão, com `https://wa.me/número-da-loja?text=resumo` e o texto codificado, trazendo **só os itens daquela loja**.

**Analogia:** é a hora de pagar no shopping: a atendente de cada loja só vê as peças da loja dela. E, se o preço de uma peça subiu enquanto você estava com ela na sacola, a atendente **avisa antes de passar no caixa**.

## Mão na Massa

### Passo 1: a classe Pedido

Crie `js/modelos/Pedido.js`:

**Arquivo: `js/modelos/Pedido.js`** (arquivo novo, inteiro)

```js
// Pedido de UMA loja (RN-03). Uma sacola com peças de 2 lojas gera 2 pedidos,
// cada um com o seu status, todos com o mesmo grupoId.
import { ErroApp } from "./ErroApp.js";
import { Sacola } from "./Sacola.js";
import { formatarPreco } from "../ui/formatadores.js";

// RN-05: de cada status, para quais outros é permitido ir.
// O pedido avança na ordem e pode ser cancelado até ser concluído.
const FLUXO_DE_STATUS = {
  novo: ["confirmado", "cancelado"],
  confirmado: ["concluido", "cancelado"],
  concluido: [],
  cancelado: [],
};

// RN-05: textos que a cliente enxerga.
const ROTULOS_PARA_CLIENTE = {
  novo: "Enviado à loja",
  confirmado: "Reserva confirmada",
  concluido: "Concluído",
  cancelado: "Cancelado",
};

export class Pedido {
  #id; // fica vazio até o pedido ser gravado no banco
  #grupoId;
  #lojaId;
  #lojaNome;
  #status;
  #itens; // cada item: { produtoId, nome, tamanho, quantidade, precoUnitario }

  constructor({
    id = null,
    grupoId,
    lojaId,
    lojaNome = "",
    status = "novo",
    itens,
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
  }

  get id() {
    return this.#id;
  }

  get grupoId() {
    return this.#grupoId;
  }

  get lojaId() {
    return this.#lojaId;
  }

  get lojaNome() {
    return this.#lojaNome;
  }

  get status() {
    return this.#status;
  }

  get itens() {
    return this.#itens.map((item) => ({ ...item }));
  }

  // O total é calculado a partir dos itens, então nunca fica diferente deles.
  // Soma em centavos para evitar erro de arredondamento.
  get total() {
    const centavos = this.#itens.reduce(
      (soma, item) => soma + Math.round(item.precoUnitario * 100) * item.quantidade,
      0
    );
    return centavos / 100;
  }

  // Método estático: pertence à classe, não a um pedido específico.
  // Recebe a sacola e devolve UM pedido por loja, todos com o mesmo grupoId e cada um com o seu id.
  static criarPorLoja(sacola) {
    if (!(sacola instanceof Sacola)) {
      throw new ErroApp("sacola_invalida", "Sacola inválida.");
    }
    if (sacola.estaVazia()) {
      throw new ErroApp("sacola_vazia", "A sacola está vazia.");
    }

    const grupoId = crypto.randomUUID();

    return sacola.itensPorLoja().map(
      (grupo) =>
        new Pedido({
          // O id nasce aqui, no navegador, para os itens poderem apontar para o pedido já no mesmo envio
          id: crypto.randomUUID(),
          grupoId,
          lojaId: grupo.lojaId,
          lojaNome: grupo.lojaNome,
          // RN-06: o preço da sacola é copiado para o pedido e não muda mais
          itens: grupo.itens.map((item) => ({
            produtoId: item.produtoId,
            nome: item.nome,
            tamanho: item.tamanho,
            quantidade: item.quantidade,
            precoUnitario: item.preco,
          })),
        })
    );
  }

  // Código curto para a cliente e a loja se referirem ao pedido: os 8 primeiros caracteres do id.
  codigoCurto() {
    return String(this.#id ?? "").slice(0, 8);
  }

  // Texto que a cliente envia à loja pelo WhatsApp (RF-10): saudação, código, SÓ os itens deste pedido e o total dele.
  mensagemParaWhatsapp() {
    // O Intl usa um espaço "não separável" no preço; no texto da mensagem um espaço comum fica melhor
    const preco = (valor) => formatarPreco(valor).replace(/\u00a0/g, " ");

    const itens = this.#itens.map(
      (item) => "- " + item.quantidade + "x " + item.nome + " (tamanho " + item.tamanho + ") - " + preco(item.precoUnitario) + " cada"
    );

    return [
      "Olá" + (this.#lojaNome ? ", " + this.#lojaNome : "") + "! Fiz um pedido pela VitrineCol.",
      "Pedido #" + this.codigoCurto(),
      "",
      ...itens,
      "",
      "Total: " + preco(this.total),
    ].join("\n");
  }

  rotuloParaCliente() {
    return ROTULOS_PARA_CLIENTE[this.#status];
  }

}
```


### Passo 2: o serviço que confere o preço e monta os pedidos

Em `js/servicos/lojaServico.js`, cole a função dos contatos **logo antes** do comentário `// ---------- Painel da lojista ----------`:

**Arquivo: `js/servicos/lojaServico.js`**: adicione este trecho logo antes da linha `// ---------- Painel da lojista ----------`:

```js
// Nome e WhatsApp das lojas indicadas, para montar os links do WhatsApp na confirmação do pedido (RF-10).
export async function listarContatosDasLojas(ids) {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("lojas").select("id, nome, whatsapp").in("id", ids);

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar o contato das lojas. Verifique sua conexão e tente novamente.");
  }
}

```


Crie `js/servicos/pedidoServico.js`:

**Arquivo: `js/servicos/pedidoServico.js`** (arquivo novo, inteiro)

```js
// Cria os pedidos da cliente (RF-10, RN-03, RN-06). Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Sacola } from "../modelos/Sacola.js";
import { Pedido } from "../modelos/Pedido.js";
import { paraErroApp } from "./errosSupabase.js";
import { formatarPreco } from "../ui/formatadores.js";

// Antes de gravar, confere no banco se cada produto continua à venda e se o preço é o mesmo da sacola.
// O preço da sacola foi guardado quando a peça entrou nela; a lojista pode ter mudado o preço desde então.
// Se mudou, NÃO gravamos o pedido: atualizamos a sacola e pedimos para a cliente conferir o total.
// Assim ela nunca paga um valor que não viu (RN-06: o preço entra no pedido no momento da compra).
async function conferirProdutosDaSacola(supabase, sacola) {
  const itens = sacola.itens;
  const ids = [...new Set(itens.map((item) => item.produtoId))];

  const { data, error } = await supabase.from("produtos").select("id, nome, preco, ativo").in("id", ids);
  if (error) {
    throw error;
  }

  // As regras RLS só mostram produtos ativos para quem não é a dona; produto que não veio está inativo ou foi excluído (RN-08)
  const produtosPorId = new Map(data.map((produto) => [produto.id, produto]));

  const indisponiveis = itens.filter((item) => !produtosPorId.get(item.produtoId)?.ativo);
  if (indisponiveis.length > 0) {
    const nomes = [...new Set(indisponiveis.map((item) => item.nome))].join(", ");
    throw new ErroApp(
      "produto_indisponivel",
      "Estes produtos não estão mais disponíveis: " + nomes + ". Remova-os da sacola para continuar."
    );
  }

  const precosAtuais = new Map(data.map((produto) => [produto.id, Number(produto.preco)]));
  const alterados = sacola.atualizarPrecos(precosAtuais);
  if (alterados.length > 0) {
    sacola.salvar(); // a sacola guardada já fica com os preços novos
    const detalhes = alterados.map((a) => a.nome + " (de " + formatarPreco(a.de) + " para " + formatarPreco(a.para) + ")").join("; ");
    throw new ErroApp(
      "preco_mudou",
      "O preço mudou: " + detalhes + ". Atualizamos a sacola; confira o novo total e finalize de novo."
    );
  }
}

// Monta um pedido por loja a partir da sacola e devolve a lista de objetos Pedido (cada um com o seu id).
//
// PROVISÓRIO (Dia 12): por enquanto os pedidos só são montados na memória, para a tela mostrar os botões de WhatsApp.
// Quem GRAVA os pedidos no banco é a função criar_pedidos(), que entra no Dia 13, junto com o login (só uma cliente logada faz pedido).
export async function criarPedidos(sacola) {
  try {
    if (!(sacola instanceof Sacola) || sacola.estaVazia()) {
      throw new ErroApp("sacola_vazia", "A sacola está vazia.");
    }

    const supabase = exigirSupabase();
    await conferirProdutosDaSacola(supabase, sacola);

    // Um Pedido por loja, todos com o mesmo grupoId (RN-03)
    return Pedido.criarPorLoja(sacola);
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível enviar o pedido. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 3: a sacola finaliza

No `js/paginas/sacola.js`, faça as trocas na ordem. (1) O comentário do começo do arquivo:

**Arquivo: `js/paginas/sacola.js`**: substitua o começo do arquivo, até a linha `// A sacola fica no navegador (localStorage). A finalização do pedido entra na Aula 36.` (inclusive) por:

```js
// Página da sacola: itens por loja, quantidades, total e "Finalizar" (RF-09, RF-10, RN-03, RN-10).
// A sacola fica no navegador (localStorage). Nesta etapa (Aula 36) a finalização monta os pedidos e os botões de WhatsApp,
// mas ainda não grava nada no banco e não exige login: isso entra no Dia 13.
```


(2) As importações:

**Arquivo: `js/paginas/sacola.js`**: substitua o trecho que começa na linha `import { mostrarErro, mostrarInfo, limparAvisos, mensagemDoErro } from "../ui/avisos.js";` e termina na linha `import { criarElemento } from "../ui/elementos.js";` (inclusive) por:

```js
import { mostrarCarregando, mostrarErro, mostrarInfo, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { formatarPreco, criarLinkDoWhatsapp } from "../ui/formatadores.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Sacola } from "../modelos/Sacola.js";
import { criarPedidos } from "../servicos/pedidoServico.js";
import { listarContatosDasLojas } from "../servicos/lojaServico.js";
import { criarElemento } from "../ui/elementos.js";
```


(3) Os elementos da tela, agora incluindo o título e a confirmação:

**Arquivo: `js/paginas/sacola.js`**: substitua o trecho que começa na linha `const anuncio = document.getElementById("anuncio-sacola");` e termina na linha `const botaoFinalizar = document.getElementById("botao-finalizar");` (inclusive) por:

```js
const titulo = document.getElementById("titulo-sacola");
const anuncio = document.getElementById("anuncio-sacola");
const blocoDaSacola = document.getElementById("sacola-conteudo");
const explicacao = document.getElementById("explicacao-sacola");
const blocoDosGrupos = document.getElementById("grupos-sacola");
const mensagemVazia = document.getElementById("sacola-vazia");
const rodape = document.getElementById("rodape-sacola");
const textoDoTotal = document.getElementById("total-sacola");
const botaoFinalizar = document.getElementById("botao-finalizar");
const blocoDaConfirmacao = document.getElementById("confirmacao");
const blocoDosCartoes = document.getElementById("cartoes-pedidos");
```


(4) O botão de teste dá lugar ao código de finalização (cartões de pedido, WhatsApp, confirmação e a função `finalizar`):

**Arquivo: `js/paginas/sacola.js`**: substitua o trecho que começa na linha `// A finalização do pedido entra na Aula 36` e termina na linha `botaoFinalizar.addEventListener("click", () => mostrarInfo("Finalizar a sacola chega na próxima aula."));` (inclusive) por:

```js
// ---------- Finalizar ----------

// Um cartão por loja, com o código do pedido, os itens, o total e o botão do WhatsApp (RF-10, RN-10)
function criarCartaoDoPedido(pedido, whatsapp) {
  const cartao = criarElemento("article", "pedido-loja");
  cartao.setAttribute("aria-label", "Pedido para " + pedido.lojaNome);

  const topo = criarElemento("div", "pedido-loja-topo");
  topo.append(criarElemento("h2", "", pedido.lojaNome), criarElemento("span", "selo selo-novo", pedido.rotuloParaCliente()));

  const codigo = criarElemento("p", "", "Pedido ");
  codigo.append(criarElemento("strong", "", "#" + pedido.codigoCurto()));

  const itens = criarElemento("ul", "pedido-itens");
  pedido.itens.forEach((item) => {
    itens.append(
      criarElemento("li", "", item.quantidade + "x " + item.nome + " (tamanho " + item.tamanho + ") – " + formatarPreco(item.precoUnitario) + " cada")
    );
  });

  cartao.append(topo, codigo, itens, criarElemento("p", "", "Total do pedido: " + formatarPreco(pedido.total)));

  // É um <a> comum (clique da própria usuária), e não um window.open: assim o navegador não bloqueia como pop-up
  const href = criarLinkDoWhatsapp(whatsapp, pedido.mensagemParaWhatsapp());
  if (href) {
    const botao = criarElemento("a", "botao botao-whatsapp", "Enviar pedido para " + pedido.lojaNome + " no WhatsApp");
    botao.href = href;
    botao.target = "_blank";
    botao.rel = "noopener";
    botao.append(criarElemento("span", "visualmente-oculto", " (abre em nova aba)"));
    cartao.append(botao);
  } else {
    cartao.append(
      criarElemento("p", "aviso aviso-info", "Esta loja ainda não cadastrou o WhatsApp. O pedido ficou gravado e a loja o verá no painel.")
    );
  }

  return cartao;
}

// Troca a sacola pela confirmação. Os pedidos JÁ estão gravados; se faltar o WhatsApp de alguma loja, só avisamos.
async function mostrarConfirmacao(pedidos) {
  const contatos = new Map();
  let faltouContato = false;

  try {
    const idsDasLojas = [...new Set(pedidos.map((pedido) => pedido.lojaId))];
    (await listarContatosDasLojas(idsDasLojas)).forEach((loja) => contatos.set(loja.id, loja.whatsapp));
  } catch (erro) {
    console.warn(erro.codigo, erro.cause ?? "");
    faltouContato = true;
  }

  blocoDosCartoes.replaceChildren(...pedidos.map((pedido) => criarCartaoDoPedido(pedido, contatos.get(pedido.lojaId))));

  titulo.textContent = "Pedidos enviados";
  document.title = "Pedidos enviados – VitrineCol";
  blocoDaSacola.hidden = true;
  blocoDaConfirmacao.hidden = false;
  limparAvisos();
  if (faltouContato) {
    mostrarInfo("Os pedidos foram gravados, mas não foi possível carregar o WhatsApp das lojas. Acompanhe tudo em Meus pedidos.");
  }
  titulo.focus(); // leva o foco (e o leitor de tela) para o título da confirmação
}

// Libera o botão de novo (quando a finalização não aconteceu ou falhou)
function liberarBotao() {
  enviando = false;
  botaoFinalizar.disabled = false;
  atualizarTotais();
}

async function finalizar() {
  // A trava liga JÁ no primeiro clique, antes de qualquer espera: cliques seguidos não podem criar o pedido várias vezes.
  if (enviando) {
    return;
  }
  enviando = true;
  botaoFinalizar.disabled = true;
  limparAvisos();

  botaoFinalizar.textContent = "Enviando pedidos…";
  mostrarCarregando("Montando os pedidos…");

  let pedidos;
  try {
    pedidos = await criarPedidos(sacola);
  } catch (erro) {
    // Falhou: a sacola NÃO é limpa, para a cliente poder tentar de novo sem perder nada
    limparAvisos();
    mostrarErro(mensagemDoErro(erro));
    if (erro instanceof ErroApp && erro.codigo === "preco_mudou") {
      desenhar(); // o serviço atualizou os preços da sacola
    }
    liberarBotao();
    return;
  }

  // Gravou: agora sim esvazia a sacola
  sacola.limpar();
  try {
    sacola.salvar();
  } catch (erro) {
    console.warn(erro.codigo, erro.cause ?? "");
  }
  atualizarContadorSacola();
  await mostrarConfirmacao(pedidos);
}

botaoFinalizar.addEventListener("click", finalizar);
```


### Passo 4: o visual dos cartões de pedido

No `css/paginas.css`, cole a seção dos cartões **logo antes** do comentário `/* ---------- Painel da lojista ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Painel da lojista ---------- */`:

```css
/* ---------- Meus pedidos e pedidos recebidos ---------- */
.compra {
  margin-bottom: var(--espaco-5);
  padding: var(--espaco-4);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.compra-cabecalho {
  margin-bottom: var(--espaco-3);
  color: var(--cor-texto-suave);
}

.pedido-loja {
  margin-top: var(--espaco-3);
  padding: var(--espaco-3);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-pequeno);
}

.pedido-loja-topo {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--espaco-2);
  margin-bottom: var(--espaco-2);
}

.pedido-loja-topo h3 {
  margin: 0;
}

.pedido-itens {
  margin: 0 0 var(--espaco-2) var(--espaco-5);
}

.recado-loja {
  margin: var(--espaco-2) 0 0;
  padding: var(--espaco-2) var(--espaco-3);
  background-color: var(--cor-primaria-clara);
  border-radius: var(--raio-pequeno);
}

.pedido-novidade {
  border-color: var(--cor-primaria);
  border-width: 2px;
}
```


E a seção da confirmação **logo antes** do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

```css
/* ---------- Sacola: confirmação do pedido ---------- */
#confirmacao .acoes-formulario {
  margin-top: var(--espaco-4);
}

/* O título da confirmação recebe o foco por script (para o leitor de tela começar nele); não é um controle, então sem contorno */
h1[tabindex="-1"]:focus {
  outline: none;
}
```


### Passo 5: teste o fluxo

1. Para o teste, use **duas lojas** com produtos ativos e **WhatsApp cadastrado** (use a **Loja Exemplo** e uma segunda loja que você cadastrou na Aula 31).
2. Adicione uma peça de cada loja à sacola e abra **Sacola**: o botão diz **Finalizar sacola (2 pedidos)**.
3. Clique em **Finalizar sacola**: o botão muda para **Enviando pedidos…**, aparece **Montando os pedidos…** e então a tela **Pedidos enviados** mostra **um cartão por loja**: nome da loja, o selo **Enviado à loja**, o código `#xxxxxxxx` do pedido, os itens, o **Total do pedido** e o botão **Enviar pedido para [loja] no WhatsApp**. A sacola fica vazia e o contador do cabeçalho some.
4. Clique no botão de uma loja (abre em nova aba): o WhatsApp abre com a mensagem pronta: **só** os itens daquela loja e o total dela. Confira que o endereço começa com `https://wa.me/` e o número da loja.
5. **Preço que mudou (RN-06):** adicione uma peça à sacola; em **Meus produtos**, edite o preço dessa peça e salve; volte à sacola e clique em **Finalizar sacola**: **não finaliza**, aparece **O preço mudou: ... (de R$ X para R$ Y). Atualizamos a sacola; confira o novo total e finalize de novo.** e a sacola já mostra o preço novo. Clique de novo: agora finaliza.
6. **Produto desativado:** coloque uma peça na sacola, desative-a em **Meus produtos** e finalize: **Estes produtos não estão mais disponíveis: ... Remova-os da sacola para continuar.**
7. **Loja sem WhatsApp:** a tela **Minha loja** exige o WhatsApp, então, para o teste, apague o valor da coluna `whatsapp` de uma loja direto no **Table Editor** (em português: **Editor de tabelas**) do Supabase e finalize de novo: o cartão dela mostra **Esta loja ainda não cadastrou o WhatsApp...** e o botão não aparece.
8. **Lembrete:** nada foi gravado nas tabelas `pedidos` e `itens_pedido` ainda (confira no **Table Editor**, em português: **Editor de tabelas**). Isso é esperado.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Monta um pedido por loja e os botões de WhatsApp na finalização da sacola"
git push
```

## Explicação do Código

**Pedido.js**

- `FLUXO_DE_STATUS` e `ROTULOS_PARA_CLIENTE`: o fluxo de status (RN-05) e os textos que a cliente enxerga (`novo` = "Enviado à loja", `confirmado` = "Reserva confirmada"...). O fluxo será usado a fundo no Dia 26.
- O construtor confere o grupo, a loja, a lista de itens (não pode ser vazia) e o status, e guarda uma **cópia** dos itens. `get total` soma em centavos (`Math.round(preço * 100) * quantidade`), então o total **nunca** fica diferente dos itens.
- `static criarPorLoja(sacola)`: um método **da classe**. Gera **um `grupoId`** (`crypto.randomUUID()`) e, para cada grupo de `sacola.itensPorLoja()`, cria um `Pedido` com um `id` novo e os itens daquela loja (copiando o preço da sacola para o item, RN-06). O `id` nasce **no navegador** para os itens poderem apontar para o pedido já no mesmo envio.
- `codigoCurto()`: os 8 primeiros caracteres do `id`, que a cliente e a loja usam para se referir ao pedido.
- `mensagemParaWhatsapp()`: monta o texto: "Olá, [loja]! Fiz um pedido pela VitrineCol.", "Pedido #código", uma linha por item ("- 2x Vestido (tamanho M) - R$ 129,90 cada") e "Total: R$ ...". Troca o espaço "não separável" do `Intl` por um espaço comum.

**pedidoServico.js**

- `conferirProdutosDaSacola(supabase, sacola)`: busca no banco os produtos da sacola (`.in("id", ids)`). Se algum não veio ou está inativo (RN-08), lança "Estes produtos não estão mais disponíveis...". Depois chama `sacola.atualizarPrecos(...)` com os preços atuais: se **algum mudou**, a sacola é **salva já com os preços novos** e é lançado o erro `preco_mudou` com o resumo ("de R$ X para R$ Y"). A tela **não grava** e a cliente confere o novo total.
- `criarPedidos(sacola)` (**provisório**): confere os produtos e devolve `Pedido.criarPorLoja(sacola)`. No Dia 13 ela passa a chamar o banco para gravar (função `criar_pedidos`).

**lojaServico.js**: `listarContatosDasLojas(ids)` busca `id`, `nome` e `whatsapp` das lojas indicadas (`.in("id", ids)`).

**sacola.js**

- `finalizar()`: a "trava" `enviando` liga **no primeiro clique** (cliques seguidos não podem criar vários pedidos); chama `criarPedidos`; se falhar, mostra a mensagem, **não limpa a sacola** (a cliente não perde nada) e, se foi `preco_mudou`, redesenha a sacola. Se der certo, esvazia a sacola (`sacola.limpar()` + `salvar()`) e chama `mostrarConfirmacao(pedidos)`.
- `mostrarConfirmacao(pedidos)`: busca o WhatsApp das lojas (`listarContatosDasLojas`; se falhar, só avisa), desenha um cartão por pedido, troca o título para "Pedidos enviados", esconde a sacola, mostra a confirmação e leva o foco ao título (`titulo.focus()`), para o leitor de tela começar nele.
- `criarCartaoDoPedido(pedido, whatsapp)`: o cartão (título, selo, código, itens, total). O botão é um `<a class="botao botao-whatsapp">` com `href = criarLinkDoWhatsapp(whatsapp, pedido.mensagemParaWhatsapp())`: é um **link** (clique da própria cliente), e não um `window.open`, para o navegador **não bloquear** como pop-up. `target="_blank"` e `rel="noopener"` abrem em nova aba com segurança. Sem WhatsApp válido, o cartão mostra o aviso no lugar do botão.

## Validação

1. Com peças de duas lojas, **Finalizar** mostra **Pedidos enviados** com dois cartões, cada um com os itens e o total da sua loja.
2. Cada botão de WhatsApp abre `https://wa.me/...` com a mensagem só dos itens daquela loja.
3. A sacola fica vazia depois de finalizar, e o contador some.
4. Com preço mudado, **não finaliza**, avisa a diferença e atualiza a sacola; na segunda tentativa finaliza.
5. As tabelas `pedidos` e `itens_pedido` continuam **vazias** (a gravação entra no Dia 13).

**Erros comuns**

1. *Sintoma:* o botão **Finalizar sacola** não faz nada. *Causa:* a troca do Passo 3 (4) não foi feita (ainda mostra a mensagem de teste). *Correção:* refaça o item 4 do Passo 3.
2. *Sintoma:* o botão de WhatsApp não aparece. *Causa:* a loja não tem WhatsApp válido. *Correção:* cadastre o WhatsApp em **Minha loja** (12 ou 13 dígitos).
3. *Mensagem:* `Cannot read properties of null (reading 'hidden')` em `sacola.js`. *Causa:* o `sacola.html` está desatualizado. *Correção:* use o `sacola.html` da Aula 35 (com a seção `confirmacao`).
4. *Sintoma:* o aviso "O preço mudou" aparece sem a cliente ter mexido em nada. *Causa:* a sacola guardou o preço antigo de um produto que você editou. *Correção:* é o comportamento correto; finalize de novo.

**Se travar**

1. No Console (F12) veja o primeiro erro; teste `criarLinkDoWhatsapp("5527999999999", "teste")` importando o módulo no Console.
2. Se o botão de WhatsApp abrir com o texto estranho, confira se `encodeURIComponent` está no `criarLinkDoWhatsapp`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/modelos/Pedido.js`, `js/servicos/pedidoServico.js` (provisório, ainda sem gravar) e `listarContatosDasLojas`.
- Uma sacola que finaliza em **um pedido por loja** e mostra os botões de **WhatsApp por loja**.
- As seções de CSS dos cartões de pedido e da confirmação.

**Como saber que deu certo:** você finaliza uma sacola com peças de duas lojas e vê dois cartões, cada um com o seu botão de WhatsApp trazendo só os itens daquela loja.
