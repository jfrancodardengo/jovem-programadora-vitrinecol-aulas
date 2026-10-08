# Aula 31 – Cadastro de lojas e produtos (INSERT)

**Dia 11 · Qua 21/10/2026** · **Aula 31** · **UC3**

- **Requisitos cobertos:** RF-15 (a lojista cria e edita a própria loja), RF-16 (cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque), RN-01 (cada lojista tem no máximo uma loja), RN-02 (preço maior que zero, estoque não negativo) e RN-10 (WhatsApp só com dígitos e código do país)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catálogo lendo do Supabase com filtros e paginação; produtoServico.js e lojaServico.js com as consultas de leitura; painel-loja.html e painel-produto-form.html estáticos; lojista de teste criada no painel (Aulas 21 a 30)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer a lojista **cadastrar a própria loja** (WhatsApp guardado só com dígitos e código do país, uma loja por lojista) e **cadastrar produtos** (categoria, preço e tamanhos com estoque), gravando no Supabase com `INSERT`. Como o login só chega no Dia 13, **por enquanto** as telas trabalham como a **lojista de teste**.

**Abertura (10 minutos).** Retomada da Aula 30: o catálogo **lê** do banco, mas ninguém consegue **cadastrar** nada pelo site. Hoje a lojista passa a cadastrar. Uma decisão importante: ainda não existe login. Então as telas do painel vão usar um **id fixo da lojista de teste** (criada na Aula 27). É um atalho **temporário**: no Dia 13 ele é apagado e entra o login de verdade. **Atenção:** sem RLS, qualquer pessoa com o endereço do site poderia gravar. Use só dados de teste e não divulgue o link.

## O Conceito

**Termos desta aula**

- **`INSERT` pelo site**: `supabase.from("lojas").insert({ ... })` grava uma linha nova, como o `insert into` do SQL.
- **`id` gerado no navegador**: o produto nasce com um `id` criado no próprio navegador por `crypto.randomUUID()`, **antes** de gravar. Assim o mesmo id já vale para as fotos (Aula 33).
- **Desfazer (rollback manual)**: um produto é gravado em **duas** etapas (produto e tamanhos). Se a segunda falhar, o código **apaga** o que gravou, para não sobrar produto pela metade.
- **`errosSupabase.js`**: um arquivo que **traduz** os erros do Supabase (em inglês e em vários formatos) para mensagens em português. É o **único** lugar onde isso é feito.

**Analogia:** gravar um produto é preencher uma ficha com um anexo (a lista de tamanhos). Se o anexo não puder ser arquivado, a ficha principal é rasgada, para ninguém achar uma ficha sem anexo.

**Regras desta aula:** RN-10: a lojista pode digitar `27 99999-9999`, mas o banco guarda `5527999999999` (só dígitos, com `55`). RN-01: o banco recusa uma segunda loja da mesma lojista (a regra `unique` da Aula 26), e a tela avisa de forma amigável.

## Mão na Massa

### Passo 1: a lojista de teste no config.js

No `js/config.js`, cole **no final do arquivo** a constante provisória e **troque o valor** pelo id (UID) da lojista de teste (**Authentication > Users**, em português: **Autenticação > Usuários**, coluna **UID**):

**Arquivo: `js/config.js`**: adicione este trecho no final do arquivo:

```js
// PROVISÓRIO (Dias 11 e 12): o login só chega no Dia 13, então as telas do painel usam a lojista de teste.
// Troque pelo id da lojista de teste (Authentication > Users, coluna UID). Este valor será apagado no Dia 13.
export const LOJISTA_DE_TESTE_ID = "COLE-AQUI-O-ID-DA-LOJISTA-DE-TESTE";
```


### Passo 2: a tradução dos erros do Supabase

Crie `js/servicos/errosSupabase.js`:

**Arquivo: `js/servicos/errosSupabase.js`** (arquivo novo, inteiro)

```js
// Traduz os erros do Supabase (que vêm em inglês e em vários formatos) para ErroApp com mensagem em português.
// Este é o ÚNICO lugar onde as mensagens do Supabase são traduzidas; os serviços só chamam paraErroApp().
import { ErroApp } from "../modelos/ErroApp.js";

const MENSAGEM_DE_CONEXAO = "Não foi possível conectar ao servidor. Verifique sua internet e tente novamente.";
const MENSAGEM_DE_EMAIL_REPETIDO = "Este e-mail já está cadastrado. Entre na sua conta ou use outro e-mail.";

// O Supabase, com a confirmação de e-mail ligada, não avisa que o e-mail já existe (por segurança):
// ele devolve um usuário sem "identities". O authServico usa esta função para criar o mesmo erro nesse caso.
export function erroDeEmailJaCadastrado() {
  return new ErroApp("email_ja_cadastrado", MENSAGEM_DE_EMAIL_REPETIDO);
}

// Recebe qualquer erro e devolve um ErroApp.
// "mensagemPadrao" é usada quando o erro não é nenhum dos conhecidos abaixo.
export function paraErroApp(erro, mensagemPadrao) {
  // Um ErroApp já tem mensagem pronta: passa direto
  if (erro instanceof ErroApp) {
    return erro;
  }

  // Os erros do Supabase têm "code" (ou "error_code") e "message" (ou "msg"); o texto ajuda quando falta o código.
  const codigo = String(erro?.code ?? erro?.error_code ?? "").toLowerCase();
  const texto = String(erro?.message ?? erro?.msg ?? "").toLowerCase();
  const status = Number(erro?.status);

  const criar = (codigoDoErro, mensagem) => new ErroApp(codigoDoErro, mensagem, erro);

  if (codigo === "invalid_credentials" || texto.includes("invalid login credentials")) {
    return criar("credenciais_invalidas", "E-mail ou senha incorretos.");
  }

  if (
    codigo === "user_already_exists" ||
    codigo === "email_exists" ||
    texto.includes("already registered") ||
    texto.includes("already been registered")
  ) {
    return criar("email_ja_cadastrado", MENSAGEM_DE_EMAIL_REPETIDO);
  }

  if (codigo === "weak_password" || texto.includes("password should be") || texto.includes("password is too")) {
    return criar("senha_fraca", "A senha é muito curta ou fraca. Use pelo menos 6 caracteres.");
  }

  if (codigo === "email_not_confirmed" || texto.includes("email not confirmed")) {
    return criar("email_nao_confirmado", "Confirme seu e-mail antes de entrar. Procure a mensagem de confirmação na sua caixa de entrada.");
  }

  if (codigo === "email_address_invalid" || texto.includes("unable to validate email address")) {
    return criar("email_invalido", "Este e-mail não é válido. Confira se digitou corretamente.");
  }

  if (codigo === "signup_disabled") {
    return criar("cadastro_desativado", "Os cadastros estão desativados no momento.");
  }

  if (status === 429 || codigo.includes("rate_limit")) {
    return criar("muitas_tentativas", "Muitas tentativas em pouco tempo. Aguarde alguns minutos e tente de novo.");
  }

  // ----- Erros do banco (PostgREST) e do Storage -----
  // Gatilhos do banco (RAISE EXCEPTION) chegam com o código P0001 e a mensagem já em português
  if (codigo === "p0001" && typeof erro?.message === "string") {
    return criar("regra_do_banco", erro.message);
  }

  // 42501 = as regras RLS recusaram: a pessoa não pode mexer nesse dado
  if (codigo === "42501" || texto.includes("row-level security") || texto.includes("not authorized")) {
    return criar("permissao_negada", "Você não tem permissão para fazer esta alteração.");
  }

  if (codigo === "23505") {
    return criar("registro_duplicado", "Este registro já existe.");
  }

  if (codigo === "23503") {
    return criar("registro_em_uso", "Este item está ligado a outros dados e não pode ser alterado ou removido.");
  }

  if (codigo === "23514") {
    return criar("valor_invalido", "Algum valor não é permitido (por exemplo, preço menor ou igual a zero ou estoque negativo).");
  }

  if (texto.includes("bucket not found")) {
    return criar("armazenamento_indisponivel", "O local de armazenamento das fotos não foi encontrado. Fale com a equipe do projeto.");
  }

  // Falha de rede (sem internet, servidor fora do ar) ou erro do servidor (500 ou mais)
  const semConexao =
    erro?.name === "AuthRetryableFetchError" ||
    status === 0 ||
    status >= 500 ||
    texto.includes("failed to fetch") ||
    texto.includes("networkerror") ||
    texto.includes("load failed");
  if (semConexao) {
    return criar("sem_conexao", MENSAGEM_DE_CONEXAO);
  }

  return criar("erro_desconhecido", mensagemPadrao);
}
```


### Passo 3: o serviço da loja

No `js/servicos/lojaServico.js`, troque o começo do arquivo (do primeiro comentário até a linha do `ErroApp`) pelas novas importações e a constante dos campos da loja:

**Arquivo: `js/servicos/lojaServico.js`**: substitua o começo do arquivo, até a linha `import { ErroApp } from "../modelos/ErroApp.js";` (inclusive) por:

```js
// Fala com o banco sobre lojas. Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Loja } from "../modelos/Loja.js";
import { paraErroApp } from "./errosSupabase.js";
import { normalizarTelefone, telefoneValido } from "../ui/formatadores.js";
import { LOJISTA_DE_TESTE_ID } from "../config.js";

const CAMPOS_DA_LOJA = "id, nome, descricao, endereco, cidade, whatsapp, link_mapa";
```


Cole o bloco do painel **no final do arquivo** (validação, `obterMinhaLoja` e `salvarLoja`):

**Arquivo: `js/servicos/lojaServico.js`**: adicione este trecho no final do arquivo:

```js
// ---------- Painel da lojista ----------

// Valida os dados do formulário da loja. Devolve { campo: "mensagem" } (vazio quando está tudo certo).
// A tela mostra cada mensagem ao lado do campo; salvarLoja valida de novo antes de gravar.
export function validarLoja({ nome, endereco, cidade, whatsapp, linkMapa }) {
  const erros = {};

  if (String(nome ?? "").trim() === "") {
    erros.nome = "Informe o nome da loja.";
  }
  if (String(endereco ?? "").trim() === "") {
    erros.endereco = "Informe o endereço da loja.";
  }
  if (String(cidade ?? "").trim() === "") {
    erros.cidade = "Informe a cidade da loja.";
  }

  // RN-10: o WhatsApp é guardado só com dígitos e código do país. A lojista pode digitar com DDD e máscara.
  if (!telefoneValido(normalizarTelefone(whatsapp))) {
    erros.whatsapp = "WhatsApp inválido. Informe o DDD e o número, por exemplo 27 99999-9999.";
  }

  // O link do mapa é opcional; se existir, precisa ser http ou https
  const textoDoLink = String(linkMapa ?? "").trim();
  if (textoDoLink !== "") {
    try {
      const protocolo = new URL(textoDoLink).protocol;
      if (protocolo !== "http:" && protocolo !== "https:") {
        throw new Error("protocolo");
      }
    } catch (erro) {
      erros.linkMapa = "O link do mapa deve começar com http:// ou https://.";
    }
  }

  return erros;
}

// Texto vazio vira null no banco (colunas opcionais)
function vazioParaNulo(texto) {
  const limpo = String(texto ?? "").trim();
  return limpo === "" ? null : limpo;
}

// Devolve a loja da lojista, ou null se ela ainda não cadastrou (RN-01: no máximo uma loja).
// PROVISÓRIO: até o login existir (Dia 13), a lojista é sempre a lojista de teste.
export async function obterMinhaLoja() {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("lojas").select(CAMPOS_DA_LOJA).eq("dono_id", LOJISTA_DE_TESTE_ID).maybeSingle();
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar a sua loja. Verifique sua conexão e tente novamente.");
  }
}

// Cria a loja (sem "id") ou edita a loja existente (com "id"). Devolve a loja gravada.
export async function salvarLoja({ id, nome, descricao, endereco, cidade, whatsapp, linkMapa }) {
  try {
    ErroApp.lancarSeHouverErros(validarLoja({ nome, endereco, cidade, whatsapp, linkMapa }));

    const linha = {
      nome: nome.trim(),
      descricao: vazioParaNulo(descricao),
      endereco: endereco.trim(),
      cidade: cidade.trim(),
      whatsapp: normalizarTelefone(whatsapp),
      link_mapa: vazioParaNulo(linkMapa),
    };

    // Última defesa: o modelo Loja confere as regras de novo (RN-10) e lança ErroApp se algo escapou
    new Loja({ id, nome: linha.nome, endereco: linha.endereco, cidade: linha.cidade, whatsapp: linha.whatsapp, linkMapa: linha.link_mapa ?? "" });

    const supabase = exigirSupabase();

    if (id) {
      const { data, error } = await supabase.from("lojas").update(linha).eq("id", id).select(CAMPOS_DA_LOJA).maybeSingle();
      if (error) {
        throw error;
      }
      // As regras RLS só deixam a dona alterar; se não voltou nenhuma linha, a loja não é desta lojista
      if (!data) {
        throw new ErroApp("loja_nao_encontrada", "Não foi possível salvar: a loja não foi encontrada ou não é sua.");
      }
      return data;
    }

    const { data, error } = await supabase.from("lojas").insert({ dono_id: LOJISTA_DE_TESTE_ID, ...linha }).select(CAMPOS_DA_LOJA).single();
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    // 23505 = violação de unicidade: o banco só aceita uma loja por lojista (RN-01)
    if (erro?.code === "23505") {
      throw new ErroApp("loja_ja_existe", "Você já tem uma loja cadastrada. Recarregue a página para editá-la.", erro);
    }
    throw paraErroApp(erro, "Não foi possível salvar a loja. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 4: a tela Minha loja

No `painel-loja.html`, a página passa a ser dinâmica: o cabeçalho vira o do JavaScript, o formulário nasce escondido (`hidden`) e aparece depois de carregar, e o script é ligado. Três trocas. O cabeçalho:

**Arquivo: `painel-loja.html`**: substitua o trecho que começa na linha `<header class="cabecalho" id="cabecalho">` e termina na linha `</header>` (inclusive) por:

```html
  <header class="cabecalho" id="cabecalho"></header>
```


O formulário:

**Arquivo: `painel-loja.html`**: substitua a linha `<form class="formulario" id="formulario-loja" novalidate>` por:

```html
      <form class="formulario" id="formulario-loja" novalidate hidden>
```


O script, **logo antes de `</body>`**:

**Arquivo: `painel-loja.html`**: adicione este trecho logo antes da linha `</body>`:

```html
  <script type="module" src="js/paginas/painelLoja.js"></script>
```


Crie `js/paginas/painelLoja.js`:

**Arquivo: `js/paginas/painelLoja.js`** (arquivo novo, inteiro)

```js
// Painel da lojista: Minha loja (RF-15, RN-01). Só a lojista abre esta tela (RF-14).
// A página só valida, chama o serviço e mostra o resultado e os avisos.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarSucesso, mostrarInfo, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { obterMinhaLoja, salvarLoja, validarLoja } from "../servicos/lojaServico.js";

const formulario = document.getElementById("formulario-loja");
const botao = formulario.querySelector('button[type="submit"]');
const textoOriginalDoBotao = botao.textContent;

// Na ordem em que aparecem na tela; o foco vai para o primeiro que tiver erro
const campos = {
  nome: document.getElementById("nome-loja"),
  descricao: document.getElementById("descricao-loja"),
  endereco: document.getElementById("endereco-loja"),
  cidade: document.getElementById("cidade-loja"),
  whatsapp: document.getElementById("whatsapp-loja"),
  linkMapa: document.getElementById("mapa-loja"),
};

// A loja que já existe no banco (ou null se a lojista ainda não criou a dela)
let lojaAtual = null;
let enviando = false;

function preencherFormulario(loja) {
  campos.nome.value = loja.nome;
  campos.descricao.value = loja.descricao ?? "";
  campos.endereco.value = loja.endereco;
  campos.cidade.value = loja.cidade;
  campos.whatsapp.value = loja.whatsapp ?? "";
  campos.linkMapa.value = loja.link_mapa ?? "";
}

function lerDados() {
  return {
    id: lojaAtual?.id,
    nome: campos.nome.value,
    descricao: campos.descricao.value,
    endereco: campos.endereco.value,
    cidade: campos.cidade.value,
    whatsapp: campos.whatsapp.value,
    linkMapa: campos.linkMapa.value,
  };
}

function mostrarErrosDosCampos(erros) {
  let primeiro = null;

  for (const nome of Object.keys(campos)) {
    if (erros[nome]) {
      mostrarErroDoCampo(campos[nome], erros[nome]);
      primeiro = primeiro ?? campos[nome];
    }
  }
  primeiro?.focus();
}

formulario.addEventListener("submit", async (evento) => {
  // Sem isto o navegador recarregaria a página; e "enviando" evita dois envios com cliques seguidos
  evento.preventDefault();
  if (enviando) {
    return;
  }

  limparErrosDosCampos(formulario);
  limparAvisos();

  const dados = lerDados();
  const erros = validarLoja(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDosCampos(erros);
    return;
  }

  enviando = true;
  botao.disabled = true;
  botao.textContent = "Salvando…";
  mostrarCarregando("Salvando a loja…");

  try {
    const eraNova = lojaAtual === null;
    lojaAtual = await salvarLoja(dados);
    preencherFormulario(lojaAtual); // mostra o WhatsApp já no formato guardado (só dígitos, com 55)
    mostrarSucesso(eraNova ? "Loja criada! Agora você já pode cadastrar produtos." : "Loja salva com sucesso.");
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  } finally {
    enviando = false;
    botao.disabled = false;
    botao.textContent = textoOriginalDoBotao;
  }
});

async function iniciar() {
  montarCabecalho();
  mostrarCarregando();
  try {
    lojaAtual = await obterMinhaLoja();
    if (lojaAtual) {
      preencherFormulario(lojaAtual);
      limparAvisos();
    } else {
      mostrarInfo("Você ainda não cadastrou a sua loja. Preencha os dados abaixo.");
    }
    formulario.hidden = false;
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}

iniciar();
```


### Passo 5: teste a loja

1. Abra `painel-loja.html` pelo Live Server (pelo link **Painel da loja** do rodapé). Como a lojista de teste já tem a **Loja Exemplo** (Aula 27), o formulário vem **preenchido**.
2. Mude a descrição, salve: aparece **Loja salva com sucesso.** Recarregue: a descrição nova continua lá.
3. Digite o WhatsApp `27 99999-8888`, salve: o campo passa a mostrar `5527999998888` (só dígitos, com 55).
4. Apague o nome, salve: aparece **Informe o nome da loja.** ao lado do campo. Digite um link do mapa sem `https://`: aparece o erro do link.
5. Confira no **Table Editor** (em português: **Editor de tabelas**) do Supabase, tabela `lojas`: o WhatsApp está só com dígitos.

### Passo 6: o serviço de produtos (criar)

No `js/servicos/produtoServico.js`, troque a importação do `ErroApp` por ela mais duas (o `Produto` e a tradução de erros):

**Arquivo: `js/servicos/produtoServico.js`**: substitua a linha `import { ErroApp } from "../modelos/ErroApp.js";` por:

```js
import { ErroApp } from "../modelos/ErroApp.js";
import { Produto } from "../modelos/Produto.js";
import { paraErroApp } from "./errosSupabase.js";
```


Cole as três funções **no final do arquivo**:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`montarLinhas`) no final do arquivo:

```js
// Monta a linha da tabela produtos e as linhas de tamanhos a partir dos dados do formulário.
function montarLinhas(dados) {
  return {
    linhaDoProduto: {
      loja_id: dados.lojaId,
      categoria_id: Number(dados.categoriaId), // o <select> entrega texto; a coluna é número
      nome: dados.nome.trim(),
      descricao: String(dados.descricao ?? "").trim() === "" ? null : dados.descricao.trim(),
      preco: converterPreco(dados.preco),
      ativo: dados.ativo !== false,
    },
    linhasDeTamanhos: dados.tamanhos.map((linha) => ({
      tamanho: normalizarTamanho(linha.tamanho),
      estoque: Number(linha.estoque),
    })),
  };
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`conferirComOModelo`) no final do arquivo:

```js
// Última defesa: o modelo Produto confere RN-02 e RN-12 de novo e lança ErroApp se algo escapou da tela.
function conferirComOModelo(dados) {
  new Produto({
    id: dados.id,
    nome: dados.nome,
    preco: converterPreco(dados.preco),
    categoria: String(dados.categoriaId),
    lojaId: dados.lojaId,
    tamanhos: dados.tamanhos.map((linha) => ({ tamanho: normalizarTamanho(linha.tamanho), estoque: linha.estoque })),
    fotos: dados.fotos.map((foto) => foto.url ?? "foto-nova"),
  });
}
```


**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`criarProduto`) no final do arquivo:

```js
// Cria o produto e os tamanhos (RF-16). As fotos entram na Aula 33.
// "dados.id" é gerado no navegador (crypto.randomUUID()) ANTES do envio.
// Passos: 1) grava o produto; 2) grava os tamanhos. Se algo falhar, desfaz o que foi feito.
export async function criarProduto(dados) {
  let produtoGravado = false;

  try {
    ErroApp.lancarSeHouverErros(validarProduto(dados));
    conferirComOModelo(dados);
    const supabase = exigirSupabase();
    const { linhaDoProduto, linhasDeTamanhos } = montarLinhas(dados);

    const { error: erroDoProduto } = await supabase.from("produtos").insert({ id: dados.id, ...linhaDoProduto });
    if (erroDoProduto) {
      throw erroDoProduto;
    }
    produtoGravado = true;

    const { error: erroDosTamanhos } = await supabase
      .from("tamanhos")
      .insert(linhasDeTamanhos.map((linha) => ({ produto_id: dados.id, ...linha })));
    if (erroDosTamanhos) {
      throw erroDosTamanhos;
    }

    return dados.id;
  } catch (erro) {
    // Desfaz: sem os tamanhos, é melhor não deixar o produto pela metade
    // (apagar o produto também apaga, em cascata, os tamanhos ligados a ele)
    if (produtoGravado) {
      await exigirSupabase().from("produtos").delete().eq("id", dados.id);
    }
    throw paraErroApp(erro, "Não foi possível salvar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 7: o formulário de produto

Substitua **todo o conteúdo** do `painel-produto-form.html` (agora as linhas de tamanho são criadas pelo JavaScript e o formulário nasce escondido):

**Arquivo: `painel-produto-form.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cadastrar ou editar produto – VitrineCol</title>
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

    <div class="cartao-formulario cartao-formulario-largo">
      <h1 id="titulo-pagina">Cadastrar produto</h1>

      <p class="aviso aviso-info" id="aviso-sem-loja" role="status" hidden>
        Cadastre a sua loja antes de cadastrar produtos. <a href="painel-loja.html">Ir para Minha loja</a>
      </p>

      <form class="formulario" id="formulario-produto" novalidate hidden>
        <div class="campo">
          <label for="nome-produto">Nome</label>
          <input type="text" id="nome-produto" name="nome" required>
        </div>
        <div class="campo">
          <label for="descricao-produto">Descrição (opcional)</label>
          <textarea id="descricao-produto" name="descricao"></textarea>
        </div>
        <div class="campo">
          <label for="categoria-produto">Categoria</label>
          <select id="categoria-produto" name="categoria" required>
            <option value="">Escolha uma categoria</option>
          </select>
        </div>
        <div class="campo">
          <label for="preco-produto">Preço (R$)</label>
          <input type="number" id="preco-produto" name="preco" min="0.01" step="0.01" inputmode="decimal" required>
        </div>

        <fieldset class="campo">
          <legend>Tamanhos e estoque</legend>
          <div id="linhas-tamanhos"></div>
          <button type="button" class="botao botao-secundario botao-pequeno" id="adicionar-tamanho">Adicionar tamanho</button>
          <p class="campo-ajuda">Use estoque 0 para o tamanho que acabou: ele aparece sem estoque para as clientes.</p>
          <datalist id="sugestoes-tamanhos">
            <option value="P"></option>
            <option value="M"></option>
            <option value="G"></option>
            <option value="GG"></option>
            <option value="38"></option>
            <option value="40"></option>
            <option value="42"></option>
          </datalist>
        </fieldset>

        <div class="campo">
          <label class="opcao" for="ativo-produto"><input type="checkbox" id="ativo-produto" name="ativo" checked> Produto ativo (aparece no catálogo)</label>
        </div>

        <div class="acoes-formulario">
          <button type="submit" class="botao">Salvar produto</button>
          <a class="botao botao-secundario" href="painel-produtos.html">Cancelar</a>
        </div>
      </form>
    </div>
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

  <script type="module" src="js/paginas/painelProdutoForm.js"></script>
</body>
</html>
```


E substitua **todo o conteúdo** do `js/paginas/painelProdutoForm.js`:

**Arquivo: `js/paginas/painelProdutoForm.js`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```js
// Painel da lojista: cadastrar produto, com tamanhos.
// A página só valida, chama os serviços e mostra o resultado.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { obterMinhaLoja } from "../servicos/lojaServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";
import { criarProduto, validarProduto } from "../servicos/produtoServico.js";

// O id do produto nasce AQUI, no navegador, antes de qualquer envio: assim o mesmo id vale para o produto e, depois, para as fotos.
const produtoId = crypto.randomUUID();

const avisoSemLoja = document.getElementById("aviso-sem-loja");
const formulario = document.getElementById("formulario-produto");
const botaoSalvar = formulario.querySelector('button[type="submit"]');
const textoOriginalDoBotao = botaoSalvar.textContent;

const campoNome = document.getElementById("nome-produto");
const campoDescricao = document.getElementById("descricao-produto");
const campoCategoria = document.getElementById("categoria-produto");
const campoPreco = document.getElementById("preco-produto");
const campoAtivo = document.getElementById("ativo-produto");
const blocoDeLinhas = document.getElementById("linhas-tamanhos");
const botaoAdicionarTamanho = document.getElementById("adicionar-tamanho");

let loja = null;
let enviando = false;
let contadorDeLinhas = 0; // só serve para dar um id único a cada campo criado

// ---------- Linhas de tamanho (a lojista adiciona e remove) ----------

function criarCampoDaLinha(idDoCampo, rotulo, tipo) {
  const campo = document.createElement("div");
  campo.className = "campo";

  const label = document.createElement("label");
  label.htmlFor = idDoCampo;
  label.textContent = rotulo;

  const entrada = document.createElement("input");
  entrada.id = idDoCampo;
  entrada.type = tipo;
  entrada.required = true;

  campo.append(label, entrada);
  return { campo, entrada };
}

// As linhas são numeradas pela posição atual ("linha 1", "linha 2"): isso muda quando uma linha é removida
function renumerarLinhas() {
  [...blocoDeLinhas.children].forEach((linha, indice) => {
    linha.setAttribute("aria-label", "Tamanho e estoque, linha " + (indice + 1));
  });
}

function adicionarLinhaDeTamanho(tamanho = "", estoque = "0") {
  contadorDeLinhas += 1;

  const linha = document.createElement("div");
  linha.className = "linha-tamanho";
  linha.setAttribute("role", "group");

  const { campo: campoTamanho, entrada: entradaTamanho } = criarCampoDaLinha("tamanho-" + contadorDeLinhas, "Tamanho", "text");
  entradaTamanho.setAttribute("list", "sugestoes-tamanhos");
  entradaTamanho.value = tamanho;

  const { campo: campoEstoque, entrada: entradaEstoque } = criarCampoDaLinha("estoque-" + contadorDeLinhas, "Estoque", "number");
  entradaEstoque.min = "0";
  entradaEstoque.step = "1";
  entradaEstoque.value = estoque;

  const botaoRemover = document.createElement("button");
  botaoRemover.type = "button";
  botaoRemover.className = "botao botao-perigo botao-pequeno";
  botaoRemover.append("Remover tamanho");
  const nomeOculto = document.createElement("span");
  nomeOculto.className = "visualmente-oculto";
  botaoRemover.append(nomeOculto);

  // O texto escondido diz qual tamanho será removido, e acompanha o que a lojista digita
  const atualizarNomeOculto = () => {
    nomeOculto.textContent = " (" + (entradaTamanho.value.trim() || "sem nome") + ")";
  };
  entradaTamanho.addEventListener("input", atualizarNomeOculto);
  atualizarNomeOculto();

  botaoRemover.addEventListener("click", () => removerLinhaDeTamanho(linha));

  linha.append(campoTamanho, campoEstoque, botaoRemover);
  blocoDeLinhas.append(linha);
  renumerarLinhas();
  return entradaTamanho;
}

function removerLinhaDeTamanho(linha) {
  const proxima = linha.nextElementSibling ?? linha.previousElementSibling;
  linha.remove();
  renumerarLinhas();
  // O foco não pode se perder: vai para a linha vizinha, ou para "Adicionar tamanho" se não sobrou nenhuma
  (proxima?.querySelector("button") ?? botaoAdicionarTamanho).focus();
}

function lerTamanhos() {
  return [...blocoDeLinhas.children].map((linha) => {
    const [entradaTamanho, entradaEstoque] = linha.querySelectorAll("input");
    return { tamanho: entradaTamanho.value, estoque: entradaEstoque.value };
  });
}

// ---------- Ler e validar o formulário ----------

function lerDados() {
  return {
    id: produtoId,
    lojaId: loja.id,
    nome: campoNome.value,
    descricao: campoDescricao.value,
    categoriaId: campoCategoria.value,
    preco: campoPreco.value,
    ativo: campoAtivo.checked,
    tamanhos: lerTamanhos(),
    fotos: [],
  };
}

// Descobre qual campo da tela corresponde a cada chave de erro do validarProduto
function acharCampoDoErro(chave) {
  const campos = {
    nome: campoNome,
    categoriaId: campoCategoria,
    preco: campoPreco,
    tamanhos: botaoAdicionarTamanho,
  };
  if (campos[chave]) {
    return campos[chave];
  }

  // "tamanho-2" e "estoque-2" são os campos da linha de posição 2 (a contagem começa em 0)
  const partes = chave.match(/^(tamanho|estoque)-(\d+)$/);
  if (partes) {
    const linha = blocoDeLinhas.children[Number(partes[2])];
    return linha?.querySelector('input[id^="' + partes[1] + '-"]');
  }
  return null;
}

function mostrarErrosDoFormulario(erros) {
  const comErro = [];

  for (const [chave, mensagem] of Object.entries(erros)) {
    const campo = acharCampoDoErro(chave);
    if (campo) {
      mostrarErroDoCampo(campo, mensagem);
      comErro.push(campo);
    }
  }

  // O foco vai para o primeiro campo com erro na ordem da tela, não na ordem em que o erro foi encontrado
  comErro.sort((a, b) => (a.compareDocumentPosition(b) & Node.DOCUMENT_POSITION_FOLLOWING ? -1 : 1));
  comErro[0]?.focus();
}

botaoAdicionarTamanho.addEventListener("click", () => {
  limparErroDoCampo(botaoAdicionarTamanho);
  adicionarLinhaDeTamanho().focus();
});

// ---------- Salvar ----------

formulario.addEventListener("submit", async (evento) => {
  // Sem isto o navegador recarregaria a página; e "enviando" evita dois envios com cliques seguidos
  evento.preventDefault();
  if (enviando) {
    return;
  }

  limparErrosDosCampos(formulario);
  limparAvisos();

  const dados = lerDados();
  const erros = validarProduto(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDoFormulario(erros);
    return;
  }

  enviando = true;
  botaoSalvar.disabled = true;
  botaoSalvar.textContent = "Salvando…";
  mostrarCarregando("Salvando o produto…");

  try {
    await criarProduto(dados);
    // A lista de produtos mostra a mensagem de sucesso
    location.assign("painel-produtos.html?salvo=criado");
  } catch (erro) {
    limparAvisos();
    mostrarErro(mensagemDoErro(erro));

    enviando = false;
    botaoSalvar.disabled = false;
    botaoSalvar.textContent = textoOriginalDoBotao;
  }
});

// ---------- Abrir a tela ----------

function preencherCategorias(categorias) {
  categorias.forEach((categoria) => {
    const opcao = document.createElement("option");
    opcao.value = categoria.id;
    opcao.textContent = categoria.nome;
    campoCategoria.append(opcao);
  });
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

    preencherCategorias(await listarCategorias());

    adicionarLinhaDeTamanho();

    formulario.hidden = false;
    limparAvisos();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  }
}

iniciar();
```


### Passo 8: teste o cadastro

1. Abra `painel-produto-form.html`. O formulário aparece com **uma linha de tamanho** e as 8 categorias vindas do banco.
2. Clique em **Adicionar tamanho** duas vezes e em **Remover tamanho** em uma delas. O foco nunca se perde.
3. Cadastre: nome `Short jeans`, categoria **Shorts**, preço `79,90`, tamanhos `M` (estoque 3) e `G` (estoque 0). Salve: você vai para `painel-produtos.html` (a lista chega na próxima aula; por enquanto a página estática aparece).
4. Abra `catalogo.html`: o **Short jeans** aparece no catálogo (sem foto: aparece a imagem **Sem foto**). Filtre por **G**: ele **não** aparece (estoque 0).
5. **Erros:** tente salvar com tamanho repetido (`M` duas vezes): "Este tamanho já foi adicionado." Tente preço `0`: "O preço deve ser maior que zero."
6. **Segurança:** cadastre um produto com o nome `<img src=x onerror=alert(1)>`. No catálogo, o texto aparece **como texto**, sem nenhum alerta (RNF-06). Depois, apague esse produto no **Table Editor**.

### Passo 9: faça o commit da aula

Atenção: o `config.js` agora tem o id da sua lojista de teste. O id **não** é uma senha, mas é provisório e será apagado no Dia 13.

```bash
git add .
git commit -m "Cadastra loja e produtos pelo painel da lojista de teste"
git push
```

## Explicação do Código

**errosSupabase.js**

- `paraErroApp(erro, mensagemPadrao)`: recebe **qualquer** erro e devolve um `ErroApp`. Olha o `code` e o `message` (o Supabase usa nomes diferentes em lugares diferentes) e escolhe a mensagem em português: credenciais incorretas, e-mail repetido, senha fraca, sem conexão, `42501` ("Você não tem permissão..." quando a RLS recusa), `23505` (registro duplicado), `23503` (item ligado a outros dados), `23514` (valor não permitido pelo `CHECK`) e `P0001` (erro de gatilho, já em português). Se não reconhece, usa a `mensagemPadrao` do serviço. Os serviços só chamam esta função.

**lojaServico.js (painel)**

- `validarLoja({ nome, endereco, cidade, whatsapp, linkMapa })`: devolve um objeto de erros como o `validarProduto`. O WhatsApp passa por `normalizarTelefone` e `telefoneValido` (RN-10). O link do mapa, se existir, precisa começar com `http:` ou `https:`.
- `obterMinhaLoja()`: `.eq("dono_id", LOJISTA_DE_TESTE_ID).maybeSingle()`: `maybeSingle` devolve **um** objeto, ou `null` se não existir (em vez de dar erro).
- `salvarLoja({ id, ... })`: **cria** (sem `id`) ou **edita** (com `id`): confere as regras, depois passa o resultado de novo pelo modelo `Loja` ("última defesa"). Se há `id`, faz `.update(linha).eq("id", id)`; se não, `.insert({ dono_id: ..., ...linha })`. O código `23505` (a regra `unique`) vira "Você já tem uma loja cadastrada". Os textos vazios viram `null` (`vazioParaNulo`).

**painelLoja.js**: `lerDados()` junta os campos; ao enviar, valida (erros ao lado dos campos), mostra "Salvando…", chama `salvarLoja` e mostra sucesso ou erro; a variável `enviando` impede dois envios por cliques seguidos; `preencherFormulario` coloca o WhatsApp já no formato guardado.

**produtoServico.js**

- `montarLinhas(dados)`: monta a linha de `produtos` (`loja_id`, `categoria_id` como número, `nome`, `descricao` ou `null`, `preco` convertido, `ativo`) e as linhas de `tamanhos` (tamanho em maiúsculas, estoque como número).
- `conferirComOModelo(dados)`: cria um `Produto` só para **disparar as regras da classe** (RN-02 e RN-12). Se algo escapou da tela, lança `ErroApp`.
- `criarProduto(dados)`: confere tudo, grava o produto (`insert` com o `id` gerado no navegador), depois os tamanhos. Se a segunda gravação falhar, o `catch` **apaga o produto** (os tamanhos somem em cascata).

**painelProdutoForm.js**: as linhas de tamanho são criadas pelo JavaScript (`adicionarLinhaDeTamanho`, `removerLinhaDeTamanho`), com `id` únicos (`tamanho-1`, `estoque-1`...) por um contador; depois de remover uma linha, o **foco** vai para a vizinha, para a pessoa que usa o teclado nunca se perder. `lerDados()` monta o objeto, `acharCampoDoErro` liga cada chave de erro ao campo da tela e o `submit` valida, grava e vai para a lista.

## Validação

1. A tela **Minha loja** carrega a loja de teste, grava a edição e mostra o WhatsApp só com dígitos (começando por `55`).
2. O produto **Short jeans** foi cadastrado e aparece no catálogo, e **não** aparece no filtro de tamanho **G**.
3. Tamanho repetido e preço zero mostram erros ao lado dos campos.
4. O nome com `<img ...>` aparece como texto, sem alerta.
5. No **Table Editor** (em português: **Editor de tabelas**), `produtos` e `tamanhos` têm as linhas novas.

**Erros comuns**

1. *Sintoma:* a tela mostra "Você ainda não cadastrou a sua loja" apesar de existir. *Causa:* o `LOJISTA_DE_TESTE_ID` do `config.js` ainda é o texto de exemplo ou está errado. *Correção:* copie o **UID** da lojista de teste e troque no `config.js`.
2. *Mensagem:* `Este registro já existe` ou `Você já tem uma loja cadastrada`. *Causa:* a lojista de teste já tem uma loja e a tela tentou criar outra. *Correção:* recarregue a página para ela abrir em modo de edição.
3. *Mensagem:* `Este item está ligado a outros dados...` (23503). *Causa:* a categoria escolhida não existe ou o id da loja está errado. *Correção:* confira as categorias no banco.
4. *Mensagem:* `Você não tem permissão para fazer esta alteração`. *Causa:* a RLS foi ligada antes da hora. *Correção:* no **Table Editor** a tabela deve mostrar **RLS disabled**; se não mostrar, desligue (ou refaça o Passo 4 da Aula 26 sem RLS).

**Se travar**

1. Abra o Console (F12) e a aba **Network** (em português: **Rede**): o pedido que falhou mostra, na aba **Response** (em português: **Resposta**), o erro do banco.
2. Compare o `lojaServico.js` e o `produtoServico.js` com os da aula.
3. Se algo quebrou, volte ao último commit com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata (sem colar chaves).

**Seu projeto agora tem**

- `js/servicos/errosSupabase.js`; `lojaServico.js` com a loja da lojista de teste e `produtoServico.js` com `criarProduto`.
- `painel-loja.html` + `painelLoja.js` e `painel-produto-form.html` + `painelProdutoForm.js` funcionando (sem fotos e sem edição de produto).
- `config.js` com o id provisório da lojista de teste.

**Como saber que deu certo:** você cadastra um produto pelo formulário e o encontra no catálogo, e o produto não aparece quando filtra por um tamanho com estoque zero.
