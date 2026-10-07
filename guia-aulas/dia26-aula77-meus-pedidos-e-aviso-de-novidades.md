# Aula 77 – Meus pedidos e aviso de mudança de status (cliente)

**Dia 26 · Qui 12/11/2026** · **Aula 77** · **UC6**

- **Requisitos cobertos:** RF-11 (mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja), RF-22 (avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado; aviso pelo WhatsApp é desejável) e RN-13 (o pedido fica marcado como novidade até a cliente abrir Meus pedidos); caso de teste CT-17
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** tela Pedidos recebidos da lojista, com status e recado; classe Pedido completa; cabeçalho com o menu por perfil e o contador da sacola (Aula 76)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fechar o ciclo do pedido do lado da **cliente**: a tela **Meus pedidos** (pedidos **agrupados por compra**, do mais recente ao mais antigo, com o **status em linguagem simples** e o **recado da loja**), o **contador de novidades** no cabeçalho (atualizado de tempos em tempos), o selo **Atualizado** nos pedidos com novidade e a **marcação como visto** quando a cliente abre a tela.

**Abertura (10 minutos).** Retomada da Aula 76: a lojista já confirma pedidos e deixa recados, mas a cliente só saberia **perguntando pelo WhatsApp**. Hoje o sistema **avisa**. Pense: se a lojista confirmar o pedido agora, como a cliente, que está na página inicial, fica sabendo? E quando ela já viu a novidade, como o aviso some?

## O Conceito

**Termos desta aula**

- **Compra**: o conjunto dos pedidos criados **na mesma finalização** da sacola (o mesmo `grupo_id`). Uma compra com peças de 2 lojas tem 2 pedidos, cada um com o seu status.
- **Novidade (`status_visto`)**: uma marca no pedido. Quando a lojista muda o status ou o recado, o banco põe `status_visto = false` ("a cliente ainda não viu"). Quando a cliente abre **Meus pedidos**, a marca volta para `true`.
- **Consulta periódica**: o cabeçalho pergunta ao banco "quantos pedidos têm novidade?" **a cada 60 segundos**, com `setInterval`, para o contador aparecer **sem a cliente recarregar** a página.
- **Chamar uma função do banco (`rpc`)**: a cliente **não** pode alterar a coluna `status_visto` diretamente (o banco proíbe). Ela chama a função `marcar_pedidos_como_vistos()`, que só mexe nos pedidos **dela** e só nessa coluna.

**Analogia:** o contador é o **número vermelho** no ícone de um aplicativo de mensagens: mostra quantas novidades esperam. Abrir a conversa o apaga. O selo **Atualizado** é o "novo" colado na conversa que mudou.

**Regras:** RN-13 (a marca some quando a cliente abre **Meus pedidos**; a lojista não altera valores, itens, cliente nem loja); o selo usa **texto** ("Atualizado"), e não só cor, para quem não distingue cores; para o leitor de tela, o contador diz a frase completa ("2 pedidos com novidades").

## Mão na Massa

### Passo 1: as funções do serviço

Em `js/servicos/pedidoServico.js`, cole a função da cliente **logo antes** de `listarPedidosDaMinhaLoja`:

**Arquivo: `js/servicos/pedidoServico.js`**: adicione esta função (`listarMeusPedidos`) logo antes da função `listarPedidosDaMinhaLoja` (junto com os comentários que ficam acima dela):

```js
// RF-11: os pedidos da cliente logada, do mais recente ao mais antigo (a página agrupa por compra, usando o grupo_id).
// Devolve as linhas do banco; a página transforma cada uma em Pedido com Pedido.deLinha().
export async function listarMeusPedidos() {
  try {
    const usuaria = await usuariaAtual();
    if (!(usuaria instanceof Cliente)) {
      throw new ErroApp("exige_cliente", "Entre com uma conta de cliente para ver os seus pedidos.");
    }

    const supabase = exigirSupabase();
    const { data, error } = await supabase
      .from("pedidos")
      .select(CAMPOS_DO_PEDIDO)
      .eq("cliente_id", usuaria.id)
      .order("criado_em", { ascending: false });

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar os seus pedidos. Verifique sua conexão e tente novamente.");
  }
}
```


E cole as duas funções do aviso **no final do arquivo**:

**Arquivo: `js/servicos/pedidoServico.js`**: adicione esta função (`contarNovidades`) no final do arquivo:

```js
// RF-22: quantos pedidos da cliente têm novidade (status_visto = false). Para quem não é cliente, zero.
export async function contarNovidades() {
  try {
    const usuaria = await usuariaAtual();
    if (!(usuaria instanceof Cliente)) {
      return 0;
    }

    const supabase = exigirSupabase();
    // head: true devolve só a contagem, sem trazer os pedidos
    const { count, error } = await supabase
      .from("pedidos")
      .select("id", { count: "exact", head: true })
      .eq("cliente_id", usuaria.id)
      .eq("status_visto", false);

    if (error) {
      throw error;
    }
    return count ?? 0;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível verificar as novidades dos pedidos.");
  }
}
```


**Arquivo: `js/servicos/pedidoServico.js`**: adicione esta função (`marcarComoVistos`) no final do arquivo:

```js
// RN-13: a cliente abriu Meus pedidos, então as novidades passam a "vistas".
// É uma função do banco (e não um update direto) para a cliente não poder alterar nenhuma outra coluna.
export async function marcarComoVistos() {
  try {
    const supabase = exigirSupabase();
    const { error } = await supabase.rpc("marcar_pedidos_como_vistos");

    if (error) {
      throw error;
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível marcar os pedidos como vistos.");
  }
}
```


### Passo 2: o contador no cabeçalho

Em `js/ui/cabecalho.js`, faça as trocas na ordem. (1) O começo do arquivo (importações e o intervalo de consulta):

**Arquivo: `js/ui/cabecalho.js`**: substitua o começo do arquivo, até a linha `import { mostrarErro, mensagemDoErro } from "./avisos.js";` (inclusive) por:

```js
// Gera o cabeçalho comum das páginas e mantém o contador de itens da sacola.
// Cada página tem um <header id="cabecalho"> vazio, que este arquivo preenche.
// O menu muda conforme quem está logada: visitante, cliente ou lojista.
import { Sacola } from "../modelos/Sacola.js";
import { Lojista } from "../modelos/Lojista.js";
import { Cliente } from "../modelos/Cliente.js";
import { usuariaAtual, sair, observarSessao } from "../servicos/authServico.js";
import { contarNovidades } from "../servicos/pedidoServico.js";
import { mostrarErro, mensagemDoErro } from "./avisos.js";

// De quanto em quanto tempo o contador de novidades dos pedidos é consultado de novo (RF-22)
export const INTERVALO_DAS_NOVIDADES_EM_MS = 60000;
let temporizadorDasNovidades = null;
```


(2) O link **Meus pedidos** passa a ter o contador:

**Arquivo: `js/ui/cabecalho.js`**: substitua a função `linksDaConta` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Links que dependem de quem está logada.
// usuaria === undefined: ainda estamos descobrindo; null: visitante; objeto: Cliente ou Lojista.
function linksDaConta(usuaria) {
  if (usuaria === undefined) {
    return [];
  }
  if (usuaria === null) {
    return [
      { texto: "Entrar", arquivo: "login.html" },
      { texto: "Cadastrar", arquivo: "cadastro.html" },
    ];
  }
  // A lojista tem o painel; a cliente tem Meus pedidos
  return usuaria instanceof Lojista
    ? [{ texto: "Painel", arquivo: "painel-loja.html" }]
    : [{ texto: "Meus pedidos", arquivo: "meus-pedidos.html", comNovidades: true }];
}
```


(3) Cole as três funções do contador **logo antes** de `atualizarContadorSacola`:

**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`atualizarContadorDeNovidades`) logo antes da função `atualizarContadorSacola` (junto com os comentários que ficam acima dela):

```js
// Atualiza o contador de pedidos com novidades (RF-22) no link "Meus pedidos".
// Se a consulta falhar, o contador fica como estava: um aviso secundário nunca pode derrubar a página.
export async function atualizarContadorDeNovidades() {
  const numero = document.getElementById("contador-novidades");
  const texto = document.getElementById("contador-novidades-texto");
  if (!numero || !texto) {
    return;
  }

  let total;
  try {
    total = await contarNovidades();
  } catch (erro) {
    console.warn(erro.codigo, erro.cause ?? "");
    return;
  }

  numero.textContent = String(total);
  // O número visível some para o leitor de tela (aria-hidden no HTML criado abaixo); o texto escondido diz a frase completa
  texto.textContent = " " + total + (total === 1 ? " pedido com novidades" : " pedidos com novidades");
  numero.hidden = total === 0;
  texto.hidden = total === 0;
}
```


**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`pararDeVerNovidades`) logo antes da função `atualizarContadorSacola` (junto com os comentários que ficam acima dela):

```js
function pararDeVerNovidades() {
  clearInterval(temporizadorDasNovidades);
  temporizadorDasNovidades = null;
}
```


**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`comecarAVerNovidades`) logo antes da função `atualizarContadorSacola` (junto com os comentários que ficam acima dela):

```js
// Só a cliente tem novidades nos pedidos: consulta agora e depois de tempos em tempos
function comecarAVerNovidades() {
  pararDeVerNovidades();
  atualizarContadorDeNovidades();
  temporizadorDasNovidades = setInterval(atualizarContadorDeNovidades, INTERVALO_DAS_NOVIDADES_EM_MS);
}
```


(4) Troque `criarLink` e `montarCabecalho`:

**Arquivo: `js/ui/cabecalho.js`**: substitua a função `criarLink` inteira (do comentário acima dela até a chave que a fecha) por:

```js
function criarLink(link, arquivoAtual) {
  const item = document.createElement("li");
  const a = document.createElement("a");
  a.href = link.arquivo;
  a.append(link.texto);

  // Marca a página atual para o estilo e para leitores de tela
  if (link.arquivo === arquivoAtual) {
    a.setAttribute("aria-current", "page");
  }

  if (link.comContador) {
    const numero = document.createElement("span");
    numero.id = "contador-sacola";
    numero.className = "contador-sacola";
    numero.hidden = true;

    // Texto só para leitor de tela, para o número não ficar solto
    const texto = document.createElement("span");
    texto.id = "contador-sacola-texto";
    texto.className = "visualmente-oculto";
    texto.textContent = " itens na sacola";
    texto.hidden = true;

    a.append(numero, texto);
  }

  if (link.comNovidades) {
    // Número visível (escondido do leitor de tela) + frase completa só para o leitor de tela: "2 pedidos com novidades"
    const numero = document.createElement("span");
    numero.id = "contador-novidades";
    numero.className = "contador-sacola";
    numero.setAttribute("aria-hidden", "true");
    numero.hidden = true;

    const texto = document.createElement("span");
    texto.id = "contador-novidades-texto";
    texto.className = "visualmente-oculto";
    texto.hidden = true;

    a.append(numero, texto);
  }

  item.append(a);
  return item;
}
```


**Arquivo: `js/ui/cabecalho.js`**: substitua a função `montarCabecalho` inteira (do comentário acima dela até a chave que a fecha) por:

```js
export async function montarCabecalho() {
  const cabecalho = document.getElementById("cabecalho");
  if (!cabecalho) {
    return;
  }

  // Descobre em qual arquivo estamos; o endereço "/" é o index.html
  const arquivoAtual = location.pathname.split("/").pop() || "index.html";

  const conteudo = document.createElement("div");
  conteudo.className = "container cabecalho-conteudo";

  const logotipo = document.createElement("a");
  logotipo.className = "logotipo";
  logotipo.href = "index.html";
  logotipo.textContent = "VitrineCol";

  const menu = document.createElement("ul");
  menu.className = "menu";

  const navegacao = document.createElement("nav");
  navegacao.setAttribute("aria-label", "Principal");
  navegacao.append(menu);

  conteudo.append(logotipo, navegacao);
  cabecalho.replaceChildren(conteudo);

  // Redesenha o menu para a usuária informada (undefined = ainda descobrindo, null = visitante)
  function desenharMenu(usuaria) {
    const itens = [...LINKS_FIXOS, ...linksDaConta(usuaria)].map((link) => criarLink(link, arquivoAtual));
    if (usuaria) {
      itens.push(...criarItensDaUsuaria(usuaria, arquivoAtual));
    }
    menu.replaceChildren(...itens);
    atualizarContadorSacola();

    // Só a cliente tem o contador de novidades dos pedidos; para as outras, para de consultar
    if (usuaria instanceof Cliente) {
      comecarAVerNovidades();
    } else {
      pararDeVerNovidades();
    }
  }

  // Primeiro só os links fixos: assim a visitante não vê "Entrar" piscar quando já está logada
  desenharMenu(undefined);

  let usuaria = null;
  try {
    usuaria = await usuariaAtual();
  } catch (erro) {
    // Sem conseguir saber quem está logada, mostramos o menu de visitante; o detalhe vai para o console
    console.warn(erro.codigo, erro.cause ?? "");
  }
  desenharMenu(usuaria);

  // Se ela entrar ou sair (inclusive em outra aba), o menu acompanha
  observarSessao(desenharMenu);

  // Se a sacola mudar em outra aba, o contador acompanha
  window.addEventListener("storage", atualizarContadorSacola);
}
```


### Passo 3: a tela Meus pedidos

Crie `meus-pedidos.html` e `js/paginas/meusPedidos.js`:

**Arquivo: `meus-pedidos.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Meus pedidos – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container" hidden>
    <h1>Meus pedidos</h1>

    <p class="aviso aviso-info" id="mensagem-sem-pedidos" role="status" hidden>
      Você ainda não fez nenhum pedido. <a href="catalogo.html">Ver o catálogo</a>
    </p>

    <div id="lista-compras"></div>
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

  <script type="module" src="js/paginas/meusPedidos.js"></script>
</body>
</html>
```


**Arquivo: `js/paginas/meusPedidos.js`** (arquivo novo, inteiro)

```js
// Meus pedidos (RF-11, RF-22, RN-13): os pedidos da cliente, agrupados por compra, com o status, o recado da loja
// e o destaque "Atualizado" nos pedidos com novidade. Só a cliente abre esta tela (RF-14).
import { montarCabecalho, atualizarContadorDeNovidades } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { exigirPerfil } from "../ui/protecao.js";
import { formatarPreco, formatarData } from "../ui/formatadores.js";
import { Pedido } from "../modelos/Pedido.js";
import { listarMeusPedidos, marcarComoVistos } from "../servicos/pedidoServico.js";
import { criarElemento } from "../ui/elementos.js";

const listaDeCompras = document.getElementById("lista-compras");
const mensagemSemPedidos = document.getElementById("mensagem-sem-pedidos");

// Pedidos da mesma finalização da sacola têm o mesmo grupo_id (RN-03): viram uma "compra".
// A lista já vem do mais recente ao mais antigo, e as compras seguem essa ordem.
function agruparPorCompra(pedidos) {
  const compras = new Map();

  pedidos.forEach((pedido) => {
    if (!compras.has(pedido.grupoId)) {
      compras.set(pedido.grupoId, []);
    }
    compras.get(pedido.grupoId).push(pedido);
  });
  return [...compras.values()];
}

// O cartão de uma loja dentro da compra: loja, status, itens, total e o recado.
function criarCartaoDoPedido(pedido) {
  const cartao = criarElemento("article", "pedido-loja");
  const idDoTitulo = "pedido-" + pedido.id;
  cartao.setAttribute("aria-labelledby", idDoTitulo);

  const topo = criarElemento("div", "pedido-loja-topo");
  const titulo = criarElemento("h3", "", pedido.lojaNome);
  titulo.id = idDoTitulo;

  const selos = criarElemento("span");
  // RF-22: "Atualizado" é TEXTO (não só cor) e aparece enquanto a cliente não tinha visto a novidade
  if (!pedido.statusVisto) {
    cartao.classList.add("pedido-novidade");
    selos.append(criarElemento("span", "selo selo-atualizado", "Atualizado"), " ");
  }
  selos.append(criarElemento("span", "selo selo-" + pedido.status, pedido.rotuloParaCliente()));
  topo.append(titulo, selos);

  const codigo = criarElemento("p", "", "Pedido ");
  codigo.append(criarElemento("strong", "", "#" + pedido.codigoCurto()));

  const itens = criarElemento("ul", "pedido-itens");
  pedido.itens.forEach((item) => {
    itens.append(
      criarElemento("li", "", item.quantidade + "x " + item.nome + " (tamanho " + item.tamanho + ") – " + formatarPreco(item.precoUnitario) + " cada")
    );
  });

  cartao.append(topo, codigo, itens, criarElemento("p", "", "Total do pedido: " + formatarPreco(pedido.total)));

  // O recado da loja (RN-13), quando houver
  if (pedido.mensagemLoja.trim() !== "") {
    const recado = criarElemento("p", "recado-loja");
    recado.append(criarElemento("strong", "", "Recado da loja: "), pedido.mensagemLoja);
    cartao.append(recado);
  }

  return cartao;
}

function criarCompra(pedidos, indice) {
  const compra = criarElemento("section", "compra");
  const idDoTitulo = "compra-" + indice;
  compra.setAttribute("aria-labelledby", idDoTitulo);

  const titulo = criarElemento("h2", "", "Compra de " + formatarData(pedidos[0].criadoEm));
  titulo.id = idDoTitulo;

  // Soma em centavos, para não aparecer 0,30000000000000004
  const centavos = pedidos.reduce((soma, pedido) => soma + Math.round(pedido.total * 100), 0);
  const resumo = criarElemento(
    "p",
    "compra-cabecalho",
    "Total da compra: " + formatarPreco(centavos / 100) + " (" + pedidos.length + (pedidos.length === 1 ? " pedido" : " pedidos, um por loja") + ")"
  );

  compra.append(titulo, resumo, ...pedidos.map(criarCartaoDoPedido));
  return compra;
}

function desenhar(pedidos) {
  listaDeCompras.replaceChildren(...agruparPorCompra(pedidos).map(criarCompra));
  mensagemSemPedidos.hidden = pedidos.length > 0;
}

async function iniciar() {
  montarCabecalho();
  const usuaria = await exigirPerfil("cliente");
  if (!usuaria) {
    return;
  }

  mostrarCarregando();

  let linhas;
  try {
    linhas = await listarMeusPedidos();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    return;
  }

  // Um pedido sem itens ficou pela metade (falha ao gravar os itens, veja pedidoServico.criarPedidos): não há o que mostrar
  const pedidos = linhas.filter((linha) => (linha.itens_pedido ?? []).length > 0).map(Pedido.deLinha);

  // O destaque "Atualizado" vem dos dados que acabaram de chegar (status_visto antes de limpar)
  desenhar(pedidos);
  limparAvisos();

  // RN-13: agora que a lista está na tela, as novidades passam a "vistas" no banco. A tela atual continua
  // mostrando o destaque (foi desenhada antes), e na próxima vez que ela abrir não haverá mais "Atualizado".
  if (linhas.some((linha) => linha.status_visto === false)) {
    try {
      await marcarComoVistos();
    } catch (erro) {
      console.warn(erro.codigo, erro.cause ?? "");
    }
  }
  atualizarContadorDeNovidades(); // o contador do cabeçalho some
}

iniciar();
```


### Passo 4: teste o aviso de ponta a ponta (CT-17)

Use **dois navegadores** (ou uma janela anônima): um com a **lojista** e outro com a **cliente** dona de um pedido **novo**.

1. Como **cliente**, abra qualquer página: o link **Meus pedidos** **não** tem número (nenhuma novidade).
2. Como **lojista**, em **Pedidos recebidos**, escreva o recado `Separado, pode retirar amanhã` e clique em **Confirmar reserva** (Aula 76).
3. Como **cliente**, **espere até 60 segundos** (ou recarregue a página): o link **Meus pedidos** mostra um **número** (por exemplo, `1`).
4. Clique em **Meus pedidos**. Os pedidos aparecem **agrupados por compra** ("Compra de 26/10/2026", com **Total da compra** e "2 pedidos, um por loja"), do mais recente ao mais antigo. O pedido que a lojista mexeu tem borda destacada, o selo **Atualizado**, o status **Reserva confirmada** e **Recado da loja: Separado, pode retirar amanhã**. Os outros mostram **Enviado à loja**.
5. **Logo depois de a tela abrir**, o número do cabeçalho **some**. **Recarregue** a página: o selo **Atualizado** **não** aparece mais (já foi visto).
6. Confira no **SQL Editor** (em português: **Editor SQL**) que o banco registrou (deve voltar `true`): `select status_visto from public.pedidos where status = 'confirmado';`.
7. **Cliente sem pedidos:** entre com uma conta de cliente sem compras: aparece **Você ainda não fez nenhum pedido. Ver o catálogo.**
8. **Proteção:** como **lojista**, tente abrir `meus-pedidos.html`: você volta para o painel. Como **visitante**: vai para `login.html?voltar=meus-pedidos.html`, e depois de entrar como cliente, volta para **Meus pedidos**.

### Passo 5: faça o commit da aula

```bash
git switch -c meus-pedidos
git add .
git commit -m "Cria Meus pedidos e o contador de novidades dos pedidos da cliente"
git push -u origin meus-pedidos
```

Abra o pull request e peça a revisão de outra integrante.

## Explicação do Código

**pedidoServico.js**

- `listarMeusPedidos()`: confere que quem está logada é uma `Cliente` (`usuaria instanceof Cliente`) e busca os pedidos com `.eq("cliente_id", usuaria.id)`, do mais recente ao mais antigo. A RLS já limitaria a leitura, mas filtramos também no código.
- `contarNovidades()`: para quem **não** é cliente devolve `0`. Para a cliente, faz uma consulta só de **contagem** (`select("id", { count: "exact", head: true })`: `head: true` traz só o número, sem as linhas) filtrando `status_visto = false`.
- `marcarComoVistos()`: `supabase.rpc("marcar_pedidos_como_vistos")` chama a função do banco criada no `01_schema.sql`: `update public.pedidos set status_visto = true where cliente_id = auth.uid() and status_visto = false;`. Ela roda com os direitos do dono (`security definer`) e só pode ser chamada por quem está logada (`grant execute ... to authenticated`).

**cabecalho.js**

- `linksDaConta`: o link da cliente, **Meus pedidos**, agora tem `comNovidades: true`.
- `criarLink`: cria os dois `<span>` do contador: o **número visível** (`aria-hidden="true"`, escondido do leitor de tela) e a **frase completa** só para o leitor de tela (`visualmente-oculto`: "2 pedidos com novidades"). Os dois começam com `hidden`.
- `atualizarContadorDeNovidades()`: chama `contarNovidades()`; **se a consulta falhar, o contador fica como estava** (um aviso secundário nunca derruba a página); escreve o número, a frase (com "pedido" no singular quando é 1) e esconde os dois quando for zero.
- `comecarAVerNovidades()` / `pararDeVerNovidades()`: ligam e desligam o `setInterval` (a cada `INTERVALO_DAS_NOVIDADES_EM_MS` = 60000 ms). Só a **cliente** tem o contador: ao redesenhar o menu, `if (usuaria instanceof Cliente)` começa a consultar; para outros perfis, para.

**meusPedidos.js**

- `agruparPorCompra(pedidos)`: usa um `Map` com o `grupoId` como chave: cada pedido entra na lista da sua compra. Como a lista já vem do mais recente ao mais antigo, as compras seguem essa ordem.
- `criarCompra(pedidos, indice)`: um `<section>` com o título "Compra de dd/mm/aaaa" (`formatarData`), o total da compra (soma em **centavos** para não aparecer `0,30000000000000004`) e um cartão por pedido.
- `criarCartaoDoPedido(pedido)`: loja, **selos** (`Atualizado` se `!pedido.statusVisto`, e o status com `rotuloParaCliente()`), código, itens, total e, se houver, o **recado da loja**. O destaque usa a classe `pedido-novidade` **e** o texto "Atualizado".
- `iniciar()`: protege a tela com `exigirPerfil("cliente")`, busca os pedidos, desenha (com o destaque, que vem de `status_visto` **antes** de limpar) e **só depois** chama `marcarComoVistos()` e `atualizarContadorDeNovidades()` (o número do cabeçalho some). Por isso a tela atual ainda mostra "Atualizado", e **na próxima vez** não mostra mais.

## Validação

1. Depois de a lojista confirmar um pedido, o link **Meus pedidos** mostra o contador (em até 60 segundos).
2. **Meus pedidos** mostra as compras agrupadas, do mais recente ao mais antigo, com **Atualizado**, o status **Reserva confirmada** e o recado.
3. Depois de aberta, o contador **some** e o selo não aparece mais ao recarregar (CT-17).
4. Cliente sem pedidos vê a mensagem de lista vazia; lojista e visitante são redirecionadas.

**Erros comuns**

1. *Sintoma:* o contador nunca aparece. *Causa:* o pedido não tem `status_visto = false` (a lojista não mudou status nem recado depois da criação). *Correção:* na tela da lojista, mude o status ou salve um recado.
2. *Mensagem:* `permission denied for function marcar_pedidos_como_vistos`. *Causa:* o `grant` da função não foi rodado. *Correção:* rode a Parte 2 do `01_schema.sql` (Aula 26) até o fim.
3. *Sintoma:* o selo **Atualizado** aparece sempre. *Causa:* a chamada `marcarComoVistos()` falha (veja o Console). *Correção:* corrija o erro da função do banco ou da sessão.
4. *Sintoma:* o número do contador não atualiza sozinho. *Causa:* o `setInterval` não foi iniciado (o menu foi desenhado antes de saber que é cliente). *Correção:* confira `desenharMenu` e `comecarAVerNovidades` no `montarCabecalho`.

**Se travar**

1. No Console (F12) leia o erro; na aba **Network** (em português: **Rede**) procure o pedido a `marcar_pedidos_como_vistos` e veja a **Response** (em português: **Resposta**).
2. Confira no **SQL Editor** (em português: **Editor SQL**): `select id, status, status_visto from public.pedidos;`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `meus-pedidos.html` e `js/paginas/meusPedidos.js`.
- `pedidoServico.js` com `listarMeusPedidos`, `contarNovidades` e `marcarComoVistos`.
- `cabecalho.js` completo, com o contador de novidades e a consulta de 60 em 60 segundos.

**Como saber que deu certo:** a lojista confirma um pedido, a cliente vê o número no cabeçalho, abre **Meus pedidos**, vê **Atualizado**, o status e o recado, e o número some.
