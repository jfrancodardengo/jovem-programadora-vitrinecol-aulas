# Aula 37 – Cadastro e login com Supabase Auth

**Dia 13 · Sex 23/10/2026** · **Aula 37** · **UC3**

- **Requisitos cobertos:** RF-12 (cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional; e-mail repetido ou senha curta mostra erro claro), RF-13 (entrar e sair da conta, mantendo a sessão) e RN-11 (o perfil, cliente ou lojista, é escolhido no cadastro e não muda depois); caso de teste CT-08
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** classes Usuaria, Cliente e Lojista; tabela perfis e o gatilho que cria o perfil no banco; errosSupabase.js; login.html e cadastro.html estáticos; cabecalho.js com o contador da sacola (Aulas 23, 26, 31 e 35)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer a usuária **se cadastrar** (nome, e-mail, senha, perfil e telefone opcional), **entrar**, **sair** e **manter a sessão** com o **Supabase Auth**. O perfil (cliente ou lojista) é criado **pelo banco** e não muda depois. O cabeçalho passa a mostrar o **nome** da usuária e o botão **Sair**.

> **Atenção: este é um dos dias mais cheios do curso.** São três aulas seguidas (37, 38 e 39) e ao fim delas o sistema ganha login, recuperação de senha e segurança de verdade. Siga com calma, na ordem, e **não pule os passos de segurança e de banco** da Aula 39.

**Abertura (10 minutos).** Retomada da Aula 36: a sacola monta os pedidos, mas o painel da lojista usa uma lojista "de teste" fixa e qualquer pessoa pode abrir qualquer tela. Hoje o sistema aprende **quem é quem**. Lembre do gatilho da Aula 26: quando alguém se cadastra, o banco cria a linha em `perfis`, lendo o `nome`, o `tipo` e o `telefone` enviados no cadastro.

## O Conceito

**Termos desta aula**

- **Supabase Auth**: o serviço de **login** do Supabase. Guarda e-mail e senha de forma segura (a equipe **nunca** vê a senha) e entrega ao navegador uma **sessão**.
- **Sessão**: a "prova" de que a pessoa entrou. O `supabase-js` a guarda no próprio navegador, então recarregar a página **não** desloga a usuária.
- **Metadados do cadastro**: dados extras enviados junto (`options: { data: { nome, tipo, telefone } }`). O gatilho do banco os lê para criar o perfil.
- **Confirmação de e-mail**: o Supabase pode exigir que a pessoa clique em um link no e-mail antes de entrar. Durante as aulas vamos **desligar** essa exigência, para testar sem abrir e-mails (ligue de volta se abrir o site para usuárias reais).

**Analogia:** o cadastro é fazer a **carteirinha** do clube; o login é **mostrar a carteirinha** na portaria; a sessão é a **pulseira** que o clube coloca no seu braço, para você entrar e sair sem mostrar a carteirinha toda hora; sair é **tirar a pulseira**.

**Regras desta aula:** RN-11: o perfil escolhido no cadastro não muda depois (o banco recusa a troca, pelo gatilho da Aula 26). Segurança: a senha **nunca** passa pelo nosso código além de ser entregue ao Supabase; nunca a guardamos nem a escrevemos no Console.

## Mão na Massa

### Passo 1: desligue a confirmação de e-mail no painel

1. No painel do Supabase, abra **Authentication** (em português: **Autenticação**) e depois **Providers** (em português: **Provedores**) e **Email** (em português: **E-mail**). Em versões mais novas, o caminho pode ser **Authentication > Sign In / Providers** (em português: **Autenticação > Entrar / Provedores**).
2. Desligue **Confirm email** (em português: **Confirmar e-mail**) e clique em **Save** (em português: **Salvar**).

### Passo 2: o serviço de autenticação

Crie `js/servicos/authServico.js`:

**Arquivo: `js/servicos/authServico.js`** (arquivo novo, inteiro)

```js
// Cadastro, login, logout e "quem está logada". Devolve dados ou lança ErroApp com mensagem em português.
import { exigirSupabase, configuracaoDeExemplo } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Cliente } from "../modelos/Cliente.js";
import { Lojista } from "../modelos/Lojista.js";
import { paraErroApp, erroDeEmailJaCadastrado } from "./errosSupabase.js";
import { normalizarTelefone, telefoneValido } from "../ui/formatadores.js";

const SENHA_MINIMA = 6;
const FORMATO_DE_EMAIL = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// ---------- Validação ----------
// As páginas usam estas funções para mostrar o erro ao lado de cada campo, e os serviços
// usam de novo antes de falar com o Supabase. Assim a regra existe num lugar só.
// Devolvem um objeto { campo: "mensagem" }; objeto vazio quer dizer que está tudo certo.

export function validarCadastro({ nome, email, senha, tipo, telefone }) {
  const erros = {};

  if (String(nome ?? "").trim() === "") {
    erros.nome = "Informe o seu nome.";
  }
  if (!FORMATO_DE_EMAIL.test(String(email ?? "").trim())) {
    erros.email = "Informe um e-mail válido, por exemplo nome@email.com.";
  }
  if (String(senha ?? "").length < SENHA_MINIMA) {
    erros.senha = "A senha deve ter pelo menos " + SENHA_MINIMA + " caracteres.";
  }
  if (tipo !== "cliente" && tipo !== "lojista") {
    erros.tipo = "Escolha se você é cliente ou lojista.";
  }

  // O telefone é opcional; se foi preenchido, precisa ter DDD e número (RN-10)
  const textoDoTelefone = String(telefone ?? "").trim();
  if (textoDoTelefone !== "" && !telefoneValido(normalizarTelefone(textoDoTelefone))) {
    erros.telefone = "Telefone inválido. Informe o DDD e o número, por exemplo 27 99999-9999.";
  }

  return erros;
}

export function validarEntrada({ email, senha }) {
  const erros = {};

  if (!FORMATO_DE_EMAIL.test(String(email ?? "").trim())) {
    erros.email = "Informe um e-mail válido, por exemplo nome@email.com.";
  }
  if (String(senha ?? "") === "") {
    erros.senha = "Informe a sua senha.";
  }

  return erros;
}

// ---------- Cadastro, login e logout ----------

// Cria a conta. O perfil (cliente ou lojista) é gravado pelo gatilho do banco, a partir de "data" (RN-11).
// Devolve { usuaria, precisaConfirmarEmail }:
//  - normalmente a usuária já entra logada e "usuaria" vem preenchida;
//  - se o projeto exigir confirmação de e-mail, "usuaria" é null e "precisaConfirmarEmail" é true.
export async function cadastrar({ nome, email, senha, tipo, telefone = "" }) {
  try {
    ErroApp.lancarSeHouverErros(validarCadastro({ nome, email, senha, tipo, telefone }));
    const supabase = exigirSupabase();

    // O gatilho do banco guarda só os dígitos do telefone; aqui já mandamos com o código 55 (RN-10)
    const dados = { nome: nome.trim(), tipo };
    const telefoneNormalizado = normalizarTelefone(telefone);
    if (telefoneNormalizado !== "") {
      dados.telefone = telefoneNormalizado;
    }

    const { data, error } = await supabase.auth.signUp({
      email: email.trim(),
      password: senha,
      options: { data: dados },
    });
    if (error) {
      throw error;
    }

    // Com a confirmação de e-mail ligada, o Supabase não dá erro para um e-mail repetido:
    // devolve um usuário sem "identities". Tratamos esse caso como e-mail já cadastrado.
    if (data.user && Array.isArray(data.user.identities) && data.user.identities.length === 0) {
      throw erroDeEmailJaCadastrado();
    }

    if (!data.session) {
      return { usuaria: null, precisaConfirmarEmail: true };
    }
    return { usuaria: await usuariaAtual(), precisaConfirmarEmail: false };
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível criar a conta. Tente novamente em instantes.");
  }
}

// Faz o login e devolve a usuária (Cliente ou Lojista).
export async function entrar(email, senha) {
  try {
    ErroApp.lancarSeHouverErros(validarEntrada({ email, senha }));
    const supabase = exigirSupabase();

    const { error } = await supabase.auth.signInWithPassword({ email: email.trim(), password: senha });
    if (error) {
      throw error;
    }
    return await usuariaAtual();
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível entrar. Tente novamente em instantes.");
  }
}

export async function sair() {
  try {
    const supabase = exigirSupabase();
    const { error } = await supabase.auth.signOut();
    if (error) {
      throw error;
    }
    usuariaEmCache = null;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível sair da conta. Tente novamente.");
  }
}

// ---------- Quem está logada ----------

// Guarda a usuária já consultada. Várias partes da mesma página (cabeçalho, proteção) perguntam
// "quem está logada?"; com este cache a tabela perfis é consultada uma vez só por usuária.
let usuariaEmCache = null; // { id, promessa }

// Monta um Cliente ou um Lojista conforme o perfil gravado no banco (polimorfismo).
async function buscarUsuaria(supabase, usuario) {
  const { data, error } = await supabase.from("perfis").select("nome, tipo").eq("id", usuario.id).maybeSingle();
  if (error) {
    throw error;
  }
  if (!data) {
    throw new ErroApp("perfil_nao_encontrado", "Não encontramos o perfil desta conta. Fale com a equipe do projeto.");
  }

  const dadosDaUsuaria = { id: usuario.id, nome: data.nome, email: usuario.email };
  return data.tipo === "lojista" ? new Lojista(dadosDaUsuaria) : new Cliente(dadosDaUsuaria);
}

// Devolve um objeto Cliente ou Lojista, ou null se ninguém estiver logada.
export async function usuariaAtual() {
  try {
    // Sem o Supabase configurado não existe login possível: é como uma visitante
    if (configuracaoDeExemplo) {
      return null;
    }
    const supabase = exigirSupabase();

    // getSession lê a sessão guardada no navegador (não vai à internet)
    const { data, error } = await supabase.auth.getSession();
    if (error) {
      throw error;
    }

    const usuario = data.session?.user;
    if (!usuario) {
      usuariaEmCache = null;
      return null;
    }

    if (!usuariaEmCache || usuariaEmCache.id !== usuario.id) {
      usuariaEmCache = { id: usuario.id, promessa: buscarUsuaria(supabase, usuario) };
    }

    try {
      return await usuariaEmCache.promessa;
    } catch (erro) {
      usuariaEmCache = null; // não guarda a falha: da próxima vez tenta de novo
      throw erro;
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível verificar o seu login. Tente novamente em instantes.");
  }
}

// Avisa (chamando "callback") quando a usuária entra ou sai, inclusive em outra aba do navegador.
// O callback recebe a usuária (Cliente ou Lojista) ou null. Devolve uma função para parar de observar.
export function observarSessao(callback) {
  if (configuracaoDeExemplo) {
    return () => {};
  }

  try {
    const supabase = exigirSupabase();

    const { data } = supabase.auth.onAuthStateChange((evento) => {
      // INITIAL_SESSION e TOKEN_REFRESHED não mudam quem está logada
      if (evento === "INITIAL_SESSION" || evento === "TOKEN_REFRESHED") {
        return;
      }

      // setTimeout: o Supabase pede para não chamá-lo de dentro deste callback, senão pode travar
      setTimeout(async () => {
        try {
          callback(await usuariaAtual());
        } catch (erro) {
          callback(null);
        }
      }, 0);
    });

    return () => data.subscription.unsubscribe();
  } catch (erro) {
    return () => {};
  }
}
```


### Passo 3: o cabeçalho conforme quem está logada

Em `js/ui/cabecalho.js`, faça as trocas na ordem. (1) O começo do arquivo (comentários e importações):

**Arquivo: `js/ui/cabecalho.js`**: substitua o começo do arquivo, até a linha `import { Sacola } from "../modelos/Sacola.js";` (inclusive) por:

```js
// Gera o cabeçalho comum das páginas e mantém o contador de itens da sacola.
// Cada página tem um <header id="cabecalho"> vazio, que este arquivo preenche.
// O menu muda conforme quem está logada: visitante, cliente ou lojista.
import { Sacola } from "../modelos/Sacola.js";
import { Lojista } from "../modelos/Lojista.js";
import { usuariaAtual, sair, observarSessao } from "../servicos/authServico.js";
import { mostrarErro, mensagemDoErro } from "./avisos.js";
```


(2) A função que decide os links da conta:

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
    : [{ texto: "Meus pedidos", arquivo: "meus-pedidos.html" }];
}
```


(3) Cole as duas funções novas **logo antes** de `montarCabecalho` e troque `montarCabecalho`:

**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`criarItensDaUsuaria`) logo antes da função `montarCabecalho` (junto com os comentários que ficam acima dela):

```js
// Nome da usuária (link para Minha conta) e botão Sair: só aparecem para quem está logada.
function criarItensDaUsuaria(usuaria, arquivoAtual) {
  const itemNome = document.createElement("li");
  const nome = document.createElement("a");
  nome.className = "menu-nome";
  nome.href = "minha-conta.html";
  // textContent: o nome vem do banco, então nunca entra como HTML
  nome.textContent = "Olá, " + usuaria.nome;
  nome.title = "Minha conta";
  if (arquivoAtual === "minha-conta.html") {
    nome.setAttribute("aria-current", "page");
  }
  itemNome.append(nome);

  const itemSair = document.createElement("li");
  const botao = document.createElement("button");
  botao.type = "button";
  botao.className = "menu-botao";
  botao.textContent = "Sair";
  botao.addEventListener("click", () => sairDaConta(botao));
  itemSair.append(botao);

  return [itemNome, itemSair];
}
```


**Arquivo: `js/ui/cabecalho.js`**: adicione esta função (`sairDaConta`) logo antes da função `montarCabecalho` (junto com os comentários que ficam acima dela):

```js
async function sairDaConta(botao) {
  botao.disabled = true;
  try {
    await sair();
    location.assign("index.html");
  } catch (erro) {
    botao.disabled = false;
    mostrarErro(mensagemDoErro(erro));
  }
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


No `css/componentes.css`, cole a seção do nome e do botão **Sair** **logo antes do comentário** `/* ---------- Erro ao lado de um campo de formulário ---------- */`:

**Arquivo: `css/componentes.css`**: adicione estas seções logo antes do comentário `/* ---------- Erro ao lado de um campo de formulário ---------- */`:

```css
/* ---------- Menu do cabeçalho: nome da usuária e botão Sair ---------- */
.menu-nome {
  display: inline-block;
  max-width: 12rem;
  padding: var(--espaco-2) var(--espaco-1);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: bottom;
  color: var(--cor-texto-suave);
}

.menu-botao {
  padding: var(--espaco-2) var(--espaco-1);
  font: inherit;
  font-weight: 600;
  color: var(--cor-texto);
  background: none;
  border: 0;
  border-bottom: 3px solid transparent;
  cursor: pointer;
}

.menu-botao:hover {
  color: var(--cor-primaria-escura);
  border-bottom-color: var(--cor-primaria);
}

.menu-botao:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
```


### Passo 4: as páginas de cadastro e de login

Substitua **todo o conteúdo** do `cadastro.html` e do `login.html` (agora com o cabeçalho gerado e o script ligado):

**Arquivo: `cadastro.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cadastrar – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <div class="cartao-formulario">
      <h1>Cadastrar</h1>
      <form class="formulario" id="formulario-cadastro" novalidate>
        <div class="campo">
          <label for="nome">Nome</label>
          <input type="text" id="nome" name="nome" autocomplete="name" required>
        </div>
        <div class="campo">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" autocomplete="email" required>
        </div>
        <div class="campo">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" autocomplete="new-password" minlength="6" required aria-describedby="ajuda-senha">
          <p class="campo-ajuda" id="ajuda-senha">Use pelo menos 6 caracteres.</p>
        </div>
        <div class="campo">
          <label for="telefone">Telefone com DDD (opcional)</label>
          <input type="tel" id="telefone" name="telefone" autocomplete="tel-national" inputmode="numeric" placeholder="27 99999-9999" aria-describedby="ajuda-telefone">
          <p class="campo-ajuda" id="ajuda-telefone">Com DDD, por exemplo 27 99999-9999. A loja usa para avisar você pelo WhatsApp.</p>
        </div>
        <fieldset class="campo">
          <legend>Quero me cadastrar como</legend>
          <div class="opcoes">
            <label class="opcao"><input type="radio" name="perfil" value="cliente" checked> Cliente</label>
            <label class="opcao"><input type="radio" name="perfil" value="lojista"> Lojista</label>
          </div>
          <p class="campo-ajuda">O perfil não pode ser trocado depois.</p>
        </fieldset>
        <button type="submit" class="botao">Criar conta</button>
      </form>
      <p>Já tem conta? <a href="login.html" id="link-login">Entrar</a>.</p>
      <p class="campo-ajuda">Coletamos só nome, e-mail e telefone opcional. Veja o <a href="privacidade.html">aviso de privacidade</a>.</p>
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

  <script type="module" src="js/paginas/cadastro.js"></script>
</body>
</html>
```


**Arquivo: `login.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Entrar – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <div class="cartao-formulario">
      <h1>Entrar</h1>
      <form class="formulario" id="formulario-login" novalidate>
        <div class="campo">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" autocomplete="email" required>
        </div>
        <div class="campo">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" autocomplete="current-password" required>
        </div>
        <button type="submit" class="botao">Entrar</button>
      </form>
      <p><a href="recuperar-senha.html">Esqueci minha senha</a></p>
      <p>Ainda não tem conta? <a href="cadastro.html" id="link-cadastro">Cadastre-se</a>.</p>
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

  <script type="module" src="js/paginas/login.js"></script>
</body>
</html>
```


Crie `js/paginas/cadastro.js` e `js/paginas/login.js`:

**Arquivo: `js/paginas/cadastro.js`** (arquivo novo, inteiro)

```js
// Página de cadastro (RF-12). A página só valida, chama o serviço e mostra o resultado.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { cadastrar, usuariaAtual, validarCadastro } from "../servicos/authServico.js";

const formulario = document.getElementById("formulario-cadastro");
const botao = formulario.querySelector('button[type="submit"]');

// Na ordem em que aparecem na tela; o foco vai para o primeiro que tiver erro
const campos = {
  nome: document.getElementById("nome"),
  email: document.getElementById("email"),
  senha: document.getElementById("senha"),
  telefone: document.getElementById("telefone"),
};

const textoOriginalDoBotao = botao.textContent;
let enviando = false;

function lerDados() {
  return {
    nome: campos.nome.value,
    email: campos.email.value,
    senha: campos.senha.value,
    telefone: campos.telefone.value,
    // O perfil escolhido aqui vira o perfil da usuária e não muda depois (RN-11)
    tipo: formulario.elements["perfil"].value,
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
  if (erros.tipo) {
    mostrarErro(erros.tipo);
  }
  primeiro?.focus();
}

// Alguns erros do servidor pertencem a um campo específico; os outros viram aviso no topo.
function mostrarErroDoServidor(erro) {
  if (erro instanceof ErroApp && erro.codigo === "email_ja_cadastrado") {
    mostrarErroDoCampo(campos.email, erro.mensagemParaUsuaria);
    campos.email.focus();
  } else if (erro instanceof ErroApp && erro.codigo === "senha_fraca") {
    mostrarErroDoCampo(campos.senha, erro.mensagemParaUsuaria);
    campos.senha.focus();
  } else {
    mostrarErro(mensagemDoErro(erro));
  }
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
  const erros = validarCadastro(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDosCampos(erros);
    return;
  }

  enviando = true;
  botao.disabled = true;
  botao.textContent = "Cadastrando…";
  mostrarCarregando("Criando a sua conta…");

  try {
    const resultado = await cadastrar(dados);

    if (resultado.precisaConfirmarEmail) {
      // O projeto exige confirmar o e-mail: ainda não há sessão, então ficamos nesta página
      mostrarSucesso("Conta criada! Enviamos uma mensagem de confirmação para o seu e-mail. Confirme e depois entre na sua conta.");
      formulario.reset();
      enviando = false;
      botao.disabled = false;
      botao.textContent = textoOriginalDoBotao;
      return;
    }

    mostrarSucesso("Conta criada! Redirecionando…");
    // A usuária já está logada: segue para a página inicial do perfil escolhido
    location.assign(resultado.usuaria.rotaInicial());
  } catch (erro) {
    limparAvisos();
    mostrarErroDoServidor(erro);
    enviando = false;
    botao.disabled = false;
    botao.textContent = textoOriginalDoBotao;
  }
});

async function iniciar() {
  montarCabecalho();

  // Quem já está logada não precisa de cadastro
  try {
    const usuaria = await usuariaAtual();
    if (usuaria) {
      location.replace(usuaria.rotaInicial());
    }
  } catch (erro) {
    // Se não deu para verificar, o formulário continua disponível
  }
}

iniciar();
```


**Arquivo: `js/paginas/login.js`** (arquivo novo, inteiro)

```js
// Página de login (RF-13). A página só valida, chama o serviço e mostra o resultado.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { entrar, usuariaAtual, validarEntrada } from "../servicos/authServico.js";

const formulario = document.getElementById("formulario-login");
const campoEmail = document.getElementById("email");
const campoSenha = document.getElementById("senha");
const botao = formulario.querySelector('button[type="submit"]');

const textoOriginalDoBotao = botao.textContent;
let enviando = false;

function mostrarErrosDosCampos(erros) {
  const campos = { email: campoEmail, senha: campoSenha };
  let primeiro = null;

  for (const nome of Object.keys(campos)) {
    if (erros[nome]) {
      mostrarErroDoCampo(campos[nome], erros[nome]);
      primeiro = primeiro ?? campos[nome];
    }
  }
  // O foco vai para o primeiro campo com erro, para a usuária corrigir logo
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

  const dados = { email: campoEmail.value, senha: campoSenha.value };
  const erros = validarEntrada(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDosCampos(erros);
    return;
  }

  enviando = true;
  botao.disabled = true;
  botao.textContent = "Entrando…";
  mostrarCarregando("Entrando…");

  try {
    const usuaria = await entrar(dados.email, dados.senha);
    mostrarSucesso("Login feito! Redirecionando…");
    // Vai para a página inicial do perfil dela (polimorfismo: cada perfil responde rotaInicial() do seu jeito)
    location.assign(usuaria.rotaInicial());
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    enviando = false;
    botao.disabled = false;
    botao.textContent = textoOriginalDoBotao;
  }
});

async function iniciar() {
  montarCabecalho();

  // Quem já está logada não precisa ver o login: segue para a sua página inicial
  try {
    const usuaria = await usuariaAtual();
    if (usuaria) {
      location.replace(usuaria.rotaInicial());
    }
  } catch (erro) {
    // Se não deu para verificar, o formulário continua disponível
  }
}

iniciar();
```


### Passo 5: teste o cadastro e o login (CT-08)

1. Abra `cadastro.html`. Preencha nome, e-mail (um e-mail seu ou de teste), senha com **6 ou mais** caracteres, deixe **Cliente** marcado e clique em **Criar conta**: aparece **Conta criada! Redirecionando…** e você vai para a página inicial. O cabeçalho mostra **Meus pedidos**, **Olá, [seu nome]** e **Sair**.
2. Clique em **Sair**: você volta para a página inicial como visitante, e o cabeçalho mostra **Entrar** e **Cadastrar**.
3. **E-mail repetido (CT-08):** volte a **Cadastrar** e use o **mesmo e-mail**: aparece, logo abaixo do campo, **Este e-mail já está cadastrado. Entre na sua conta ou use outro e-mail.**
4. **Senha curta:** com uma senha de 3 caracteres, aparece **A senha deve ter pelo menos 6 caracteres.** ao lado do campo, sem nem chamar o Supabase. Um telefone inválido (`123`) também mostra o erro.
5. **Perfis:** no **SQL Editor** (em português: **Editor SQL**), rode `select nome, tipo, telefone from public.perfis;`. Cada conta tem o tipo escolhido no cadastro (`cliente` ou `lojista`). Cadastre também uma conta **Lojista** e confirme.
6. **Entrar:** em **Entrar**, use a conta de cliente: você vai para a página inicial. Saia e entre com a **Lojista Teste** (a conta criada na Aula 27): você vai para o **painel** (`painel-loja.html`) e o cabeçalho mostra **Painel**. Digite uma senha errada: **E-mail ou senha incorretos.**
7. **A sessão continua:** com a conta logada, recarregue a página e abra outra: o cabeçalho continua mostrando o seu nome. (Na aba **Application**, em português: **Aplicativo**, do F12, o `localStorage` tem uma chave que começa com `sb-`: é a sessão.)
8. **RN-11:** no **SQL Editor** (em português: **Editor SQL**), tente trocar o tipo de um perfil: `update public.perfis set tipo = 'lojista' where nome = 'SEU NOME';`. O banco responde **O perfil da usuária não pode ser alterado.**

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cadastra, entra e sai da conta com o Supabase Auth"
git push
```

## Explicação do Código

**authServico.js**

- `validarCadastro({ nome, email, senha, tipo, telefone })` e `validarEntrada(...)`: devolvem um objeto de erros (como `validarProduto`). As páginas as usam para mostrar o erro **ao lado de cada campo**, e os serviços as usam de novo antes de chamar o Supabase: a regra vive em **um** lugar. O e-mail é conferido com `FORMATO_DE_EMAIL` (uma expressão regular simples) e a senha tem no mínimo 6 caracteres. O telefone é **opcional**; se vier, passa por `normalizarTelefone` e `telefoneValido` (RN-10).
- `cadastrar(...)`: valida, monta os metadados `{ nome, tipo, telefone }` e chama `supabase.auth.signUp({ email, password, options: { data: dados } })`. Um detalhe de segurança: com a confirmação de e-mail **ligada**, o Supabase não avisa que o e-mail já existe: devolve um usuário sem `identities`; o código trata esse caso como e-mail repetido. Se não houver sessão (confirmação ligada), devolve `precisaConfirmarEmail: true`.
- `entrar(email, senha)`: `signInWithPassword`; em caso de sucesso devolve a usuária (`usuariaAtual()`). `sair()`: `signOut()` e limpa o cache.
- `usuariaAtual()`: lê a sessão com `getSession()` (não vai à internet: lê o navegador), busca o `nome` e o `tipo` na tabela `perfis` (`buscarUsuaria`) e devolve um objeto **`Cliente` ou `Lojista`** (`data.tipo === "lojista" ? new Lojista(...) : new Cliente(...)`): é o polimorfismo funcionando. O resultado fica em um **cache** (`usuariaEmCache`), então várias partes da mesma página perguntando "quem está logada?" consultam o banco **uma vez só**. Sem o Supabase configurado, devolve `null` (visitante).
- `observarSessao(callback)`: `onAuthStateChange` avisa quando a usuária entra ou sai, **inclusive em outra aba**. O `setTimeout(..., 0)` é uma recomendação do Supabase: não chamar o Supabase de dentro do próprio callback.

**cabecalho.js**

- `linksDaConta(usuaria)`: `undefined` = ainda descobrindo (não mostra nada, para "Entrar" não piscar para quem já está logada); `null` = visitante (**Entrar** e **Cadastrar**); objeto = lojista (**Painel**) ou cliente (**Meus pedidos**).
- `criarItensDaUsuaria(usuaria, arquivoAtual)`: o **nome** ("Olá, Marina", sempre com `textContent`) como link para **Minha conta** (a tela chega no Dia 26) e o botão **Sair**.
- `montarCabecalho()` agora é `async`: desenha o menu só com os links fixos, descobre quem está logada (`await usuariaAtual()`) e redesenha; depois `observarSessao(desenharMenu)` mantém o menu atualizado.

**cadastro.js e login.js**: `validar...` → se houver erros, `mostrarErrosDosCampos` (com foco no primeiro); senão, desabilita o botão, mostra "Entrando…" e chama o serviço. Um erro conhecido de campo (`email_ja_cadastrado`, `senha_fraca`) aparece **ao lado do campo**; os demais, em uma caixa de aviso. Depois de entrar: `location.assign(usuaria.rotaInicial())`: **cada perfil vai para a sua página** (polimorfismo da Aula 23).

## Validação

1. Você cria uma conta de cliente e o cabeçalho mostra o seu nome e **Sair**.
2. O e-mail repetido mostra a mensagem ao lado do campo de e-mail (CT-08); a senha curta mostra o erro sem chamar o servidor.
3. A lojista entra e vai para o painel; a cliente vai para a página inicial.
4. A sessão continua depois de recarregar.
5. O banco recusa a troca de perfil (RN-11), e `perfis` tem o tipo certo de cada conta.

**Erros comuns**

1. *Mensagem:* `Database error saving new user` ao cadastrar. *Causa:* o gatilho `ao_criar_usuario` não existe ou falhou. *Correção:* confira se o `01_schema.sql` (Parte 2, Aula 26) foi rodado até o fim.
2. *Sintoma:* "Confirme seu e-mail antes de entrar". *Causa:* a confirmação de e-mail está ligada. *Correção:* repita o Passo 1 (desligue **Confirm email**).
3. *Mensagem:* `Muitas tentativas em pouco tempo`. *Causa:* o plano gratuito limita cadastros e e-mails por hora. *Correção:* espere alguns minutos.
4. *Sintoma:* depois de entrar, o cabeçalho continua mostrando **Entrar**. *Causa:* o `cabecalho.js` não foi atualizado, ou há erro no Console em `usuariaAtual`. *Correção:* abra o Console e leia o erro; confira o Passo 3.

**Se travar**

1. No Console (F12) leia o primeiro erro; na aba **Network** (em português: **Rede**), o pedido ao Supabase (`/auth/v1/...`) mostra, na **Response** (em português: **Resposta**), a mensagem do servidor.
2. Em **Authentication > Users** (em português: **Autenticação > Usuários**) confira se a conta foi criada; no **Table Editor** (em português: **Editor de tabelas**), se a linha existe em `perfis`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe (sem colar senhas nem chaves).

**Seu projeto agora tem**

- `js/servicos/authServico.js`; `cadastro.html` + `cadastro.js` e `login.html` + `login.js` funcionando.
- `cabecalho.js` com o menu de visitante, de cliente e de lojista, o nome e o botão **Sair**.
- No Supabase, a confirmação de e-mail **desligada** (só para as aulas).

**Como saber que deu certo:** você cria uma conta, o cabeçalho mostra o seu nome, e ao tentar cadastrar o mesmo e-mail de novo aparece o erro ao lado do campo.
