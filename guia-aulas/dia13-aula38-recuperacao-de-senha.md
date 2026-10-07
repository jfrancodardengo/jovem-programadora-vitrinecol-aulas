# Aula 38 – Recuperação de senha por e-mail

**Dia 13 · Sex 23/10/2026** · **Aula 38** · **UC3**

- **Requisitos cobertos:** RF-24 (permitir recuperar a senha por e-mail: o sistema envia um link, com a mesma mensagem exista ou não a conta; pelo link a pessoa cria uma senha nova, de 6 ou mais caracteres e repetida, e já fica logada; link vencido ou usado mostra mensagem clara); caso de teste CT-23
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** cadastro e login com Supabase Auth funcionando; login.html com o link "Esqueci minha senha"; authServico.js com cadastrar, entrar, sair e usuariaAtual (Aula 37)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer a recuperação de senha **de ponta a ponta**: a tela **Esqueci minha senha** envia um link por e-mail (com a **mesma mensagem** exista ou não a conta), a pessoa clica no link, cai na tela da **senha nova** (6 ou mais caracteres, digitada duas vezes) e já fica logada. Link vencido ou usado mostra uma mensagem clara. Você também libera o endereço de retorno no painel do Supabase.

**Abertura (10 minutos).** Retomada da Aula 37: o login funciona. O que acontece quando alguém esquece a senha? Sem esta aula, a pessoa teria de pedir à equipe para trocá-la no painel. Pense: se a tela dissesse "este e-mail não tem conta", quem **não** é dona da conta poderia **descobrir** quais e-mails estão cadastrados. É por isso que a mensagem é sempre a mesma.

## O Conceito

**Termos desta aula**

- **Link de recuperação**: um endereço, enviado por e-mail, que leva de volta ao site com uma **sessão especial** só para trocar a senha. Vale por pouco tempo e **uma única vez**.
- **`redirectTo` e URL de retorno**: o endereço para onde o link do e-mail leva (`recuperar-senha.html`). O Supabase **só aceita** endereços que estejam em uma lista de **permitidos** (**Redirect URLs**); isso impede que um link seja desviado para um site falso.
- **Evento `PASSWORD_RECOVERY`**: um aviso que o Supabase dá ao navegador quando a pessoa chega pelo link do e-mail. É a deixa para mostrar o formulário da **senha nova**.
- **Mensagem única (contra enumeração de contas)**: a tela diz sempre "Se existir uma conta com este e-mail, enviamos o link...". Assim ninguém consegue testar e-mails para saber quais têm conta.

**Analogia:** o link é uma **chave descartável** que o chaveiro manda por correio para o endereço cadastrado. Quem **não é** a dona nunca recebe a carta; e, se a carta chegar tarde ou a chave já tiver sido usada, a porta não abre e a tela explica por quê.

## Mão na Massa

### Passo 1: libere o endereço de retorno no painel

1. No painel do Supabase, abra **Authentication** (em português: **Autenticação**) e **URL Configuration** (em português: **Configuração de URL**).
2. Em **Site URL** (em português: **URL do site**), por enquanto escreva `http://127.0.0.1:5500` (é o endereço do Live Server; no Dia 15, quando o site for publicado, você troca por ele).
3. Em **Redirect URLs** (em português: **URLs de redirecionamento**), clique em **Add URL** (em português: **Adicionar URL**) e acrescente os dois endereços de teste (o Live Server usa um ou outro, conforme a configuração):
   - `http://127.0.0.1:5500/recuperar-senha.html`
   - `http://localhost:5500/recuperar-senha.html`
4. Clique em **Save** (em português: **Salvar**).

### Passo 2: o serviço de autenticação ganha a recuperação de senha

Em `js/servicos/authServico.js`, cole as duas validações **logo antes** do comentário `// ---------- Cadastro, login e logout ----------`:

**Arquivo: `js/servicos/authServico.js`**: adicione este trecho logo antes da linha `// ---------- Cadastro, login e logout ----------`:

```js
// RF-24: o e-mail do pedido de redefinição de senha
export function validarEmailDeRecuperacao({ email }) {
  const erros = {};
  if (!FORMATO_DE_EMAIL.test(String(email ?? "").trim())) {
    erros.email = "Informe um e-mail válido, por exemplo nome@email.com.";
  }
  return erros;
}

// RF-24: a nova senha e a confirmação digitada de novo
export function validarNovaSenha({ senha, confirmacao }) {
  const erros = {};
  if (String(senha ?? "").length < SENHA_MINIMA) {
    erros.senha = "A senha deve ter pelo menos " + SENHA_MINIMA + " caracteres.";
  }
  if (String(confirmacao ?? "") !== String(senha ?? "")) {
    erros.confirmacao = "As senhas não são iguais.";
  }
  return erros;
}

```


E cole as três funções da recuperação **no final do arquivo**:

**Arquivo: `js/servicos/authServico.js`**: adicione este trecho no final do arquivo:

```js
// ---------- Esqueci minha senha (RF-24) ----------

// Pede ao Supabase que envie à pessoa um e-mail com o link para criar uma senha nova.
// O link volta para recuperar-senha.html (o endereço precisa estar liberado em Authentication > URL Configuration).
// Por segurança o Supabase não diz se o e-mail tem conta; por isso a tela mostra sempre a mesma mensagem.
export async function pedirRedefinicaoDeSenha(email) {
  try {
    ErroApp.lancarSeHouverErros(validarEmailDeRecuperacao({ email }));
    const supabase = exigirSupabase();

    // new URL(...) descarta o que houver depois do "?" ou do "#" do endereço atual
    const enderecoDeRetorno = new URL("recuperar-senha.html", location.href).href;
    const { error } = await supabase.auth.resetPasswordForEmail(String(email).trim(), { redirectTo: enderecoDeRetorno });
    if (error) {
      throw error;
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível enviar o e-mail agora. Tente novamente em instantes.");
  }
}

// Quem clica no link do e-mail volta ao site já com uma sessão especial de recuperação, e o Supabase
// avisa com o evento PASSWORD_RECOVERY. Chama "callback" nesse caso. Devolve uma função para parar de observar.
export function aoReceberLinkDeRecuperacao(callback) {
  if (configuracaoDeExemplo) {
    return () => {};
  }
  try {
    const { data } = exigirSupabase().auth.onAuthStateChange((evento) => {
      if (evento === "PASSWORD_RECOVERY") {
        callback();
      }
    });
    return () => data.subscription.unsubscribe();
  } catch (erro) {
    return () => {};
  }
}

// Grava a senha nova da pessoa que chegou pelo link do e-mail.
export async function definirNovaSenha({ senha, confirmacao }) {
  try {
    ErroApp.lancarSeHouverErros(validarNovaSenha({ senha, confirmacao }));
    const { error } = await exigirSupabase().auth.updateUser({ password: senha });
    if (error) {
      throw error;
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível trocar a senha. Peça um novo link e tente de novo.");
  }
}

```


### Passo 3: a página de recuperação

Crie `recuperar-senha.html` e `js/paginas/recuperarSenha.js`:

**Arquivo: `recuperar-senha.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Recuperar senha – VitrineCol</title>
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
      <h1>Recuperar senha</h1>

      <!-- Etapa 1: a pessoa informa o e-mail e recebe o link -->
      <section id="etapa-pedido" aria-labelledby="titulo-pedido">
        <h2 id="titulo-pedido" class="visualmente-oculto">Receber o link por e-mail</h2>
        <p>Informe o e-mail da sua conta. Enviaremos um link para você criar uma senha nova.</p>
        <form class="formulario" id="formulario-pedido" novalidate>
          <div class="campo">
            <label for="email">E-mail</label>
            <input type="email" id="email" name="email" autocomplete="email" required>
          </div>
          <button type="submit" class="botao">Enviar link</button>
        </form>
      </section>

      <!-- Etapa 2: aparece quando a pessoa volta pelo link do e-mail -->
      <section id="etapa-nova-senha" aria-labelledby="titulo-nova-senha" hidden>
        <h2 id="titulo-nova-senha" class="visualmente-oculto">Criar uma senha nova</h2>
        <p>Escolha a sua senha nova.</p>
        <form class="formulario" id="formulario-nova-senha" novalidate>
          <!-- Campo escondido só para o gerenciador de senhas do navegador saber de qual conta é a senha nova -->
          <input type="email" id="usuario" name="usuario" autocomplete="username" hidden>
          <div class="campo">
            <label for="senha">Senha nova</label>
            <input type="password" id="senha" name="senha" autocomplete="new-password" aria-describedby="ajuda-senha" required>
            <p class="campo-ajuda" id="ajuda-senha">Use pelo menos 6 caracteres.</p>
          </div>
          <div class="campo">
            <label for="confirmacao">Repita a senha nova</label>
            <input type="password" id="confirmacao" name="confirmacao" autocomplete="new-password" required>
          </div>
          <button type="submit" class="botao">Salvar senha nova</button>
        </form>
      </section>

      <p><a href="login.html">Voltar para o login</a></p>
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

  <script type="module" src="js/paginas/recuperarSenha.js"></script>
</body>
</html>
```


**Arquivo: `js/paginas/recuperarSenha.js`** (arquivo novo, inteiro)

```js
// Recuperar senha (RF-24). Tem duas etapas na mesma página:
//   1) a pessoa informa o e-mail e recebe um link;
//   2) ao voltar pelo link do e-mail, ela escolhe a senha nova.
// A página só valida, chama o serviço e mostra o resultado.
import { montarCabecalho } from "../ui/cabecalho.js";
import {
  mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro,
  mostrarErroDoCampo, limparErrosDosCampos,
} from "../ui/avisos.js";
import {
  pedirRedefinicaoDeSenha, definirNovaSenha, aoReceberLinkDeRecuperacao, usuariaAtual,
  validarEmailDeRecuperacao, validarNovaSenha,
} from "../servicos/authServico.js";

const etapaPedido = document.getElementById("etapa-pedido");
const etapaNovaSenha = document.getElementById("etapa-nova-senha");
const formularioPedido = document.getElementById("formulario-pedido");
const formularioNovaSenha = document.getElementById("formulario-nova-senha");
const campoEmail = document.getElementById("email");
const campoSenha = document.getElementById("senha");
const campoUsuario = document.getElementById("usuario");
const campoConfirmacao = document.getElementById("confirmacao");

// Quanto tempo esperamos o Supabase confirmar o link do e-mail antes de dizer que ele não funcionou
const ESPERA_PELO_LINK_EM_MS = 8000;

let enviando = false;
let temporizadorDoLink = null;

async function mostrarEtapaDaNovaSenha() {
  clearTimeout(temporizadorDoLink);
  limparAvisos();
  etapaPedido.hidden = true;
  etapaNovaSenha.hidden = false;
  campoSenha.focus();

  // O e-mail da conta vai para o campo escondido, para o navegador oferecer salvar a senha nova na conta certa
  try {
    const usuaria = await usuariaAtual();
    campoUsuario.value = usuaria?.email ?? "";
  } catch (erro) {
    // sem o e-mail só se perde a ajuda do gerenciador de senhas; a troca de senha continua funcionando
  }
}

// Mostra os erros ao lado dos campos e leva o foco para o primeiro com erro.
function mostrarErrosDosCampos(erros, campos) {
  let primeiro = null;
  for (const nome of Object.keys(campos)) {
    if (erros[nome]) {
      mostrarErroDoCampo(campos[nome], erros[nome]);
      primeiro = primeiro ?? campos[nome];
    }
  }
  primeiro?.focus();
}

// Roda uma ação do formulário com a trava contra duplo clique e o botão desativado enquanto espera.
async function enviar(formulario, textoEnquantoEspera, acao) {
  if (enviando) {
    return;
  }
  const botao = formulario.querySelector('button[type="submit"]');
  const textoOriginal = botao.textContent;

  enviando = true;
  botao.disabled = true;
  botao.textContent = textoEnquantoEspera;
  mostrarCarregando(textoEnquantoEspera);

  try {
    await acao();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
  } finally {
    enviando = false;
    botao.disabled = false;
    botao.textContent = textoOriginal;
  }
}

formularioPedido.addEventListener("submit", (evento) => {
  evento.preventDefault();
  limparErrosDosCampos(formularioPedido);
  limparAvisos();

  const dados = { email: campoEmail.value };
  const erros = validarEmailDeRecuperacao(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDosCampos(erros, { email: campoEmail });
    return;
  }

  enviar(formularioPedido, "Enviando…", async () => {
    await pedirRedefinicaoDeSenha(dados.email);
    // O Supabase não diz se o e-mail tem conta (por segurança), então a mensagem é sempre esta
    mostrarSucesso("Se existir uma conta com este e-mail, enviamos o link para criar uma senha nova. Confira também a caixa de spam.");
  });
});

formularioNovaSenha.addEventListener("submit", (evento) => {
  evento.preventDefault();
  limparErrosDosCampos(formularioNovaSenha);
  limparAvisos();

  const dados = { senha: campoSenha.value, confirmacao: campoConfirmacao.value };
  const erros = validarNovaSenha(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDosCampos(erros, { senha: campoSenha, confirmacao: campoConfirmacao });
    return;
  }

  enviar(formularioNovaSenha, "Salvando…", async () => {
    await definirNovaSenha(dados);
    mostrarSucesso("Senha alterada! Você já está logada. Redirecionando…");
    // Um instante para ler a mensagem; depois segue para a página inicial do perfil
    const usuaria = await usuariaAtual();
    setTimeout(() => location.assign(usuaria ? usuaria.rotaInicial() : "login.html"), 1500);
  });
});

// Se o aviso do Supabase (PASSWORD_RECOVERY) não chegou a tempo, a sessão de recuperação pode existir mesmo assim:
// se há alguém logada pelo link, segue para a senha nova; se não, o link realmente não funcionou.
async function confirmarOuAvisarErroDoLink() {
  let usuaria = null;
  try {
    usuaria = await usuariaAtual();
  } catch (erro) {
    // sem conseguir verificar, tratamos como link que não funcionou
  }
  if (usuaria) {
    mostrarEtapaDaNovaSenha();
  } else {
    mostrarErro("Não foi possível confirmar o link. Peça um novo link abaixo.");
  }
}

function iniciar() {
  montarCabecalho();

  // O Supabase coloca os dados do link no endereço, depois do "#". Se o link falhou (expirou ou já foi usado), vem um erro.
  const parametros = new URLSearchParams(location.hash.slice(1));
  const veioDoLink = parametros.get("type") === "recovery";
  const linkComErro = Boolean(parametros.get("error") || parametros.get("error_code"));

  aoReceberLinkDeRecuperacao(mostrarEtapaDaNovaSenha);

  if (linkComErro) {
    mostrarErro("Este link não vale mais: ele expirou ou já foi usado. Peça um novo link abaixo.");
  } else if (veioDoLink) {
    mostrarCarregando("Confirmando o link…");
    temporizadorDoLink = setTimeout(confirmarOuAvisarErroDoLink, ESPERA_PELO_LINK_EM_MS);
  }
}

iniciar();
```


### Passo 4: teste a recuperação de ponta a ponta (CT-23)

1. Em **Entrar**, clique em **Esqueci minha senha**: abre `recuperar-senha.html` com o formulário **Enviar link**.
2. Envie um e-mail **inválido** (`abc`): aparece **Informe um e-mail válido** ao lado do campo.
3. Informe o e-mail de uma conta que você criou e clique em **Enviar link**. Aparece **Se existir uma conta com este e-mail, enviamos o link para criar uma senha nova. Confira também a caixa de spam.** Repita com um e-mail que **não** tem conta: a mensagem é **a mesma**.
4. Abra o e-mail recebido (assunto parecido com **Reset Your Password**, em português: **Redefinir sua senha**) e clique no link. O navegador volta ao site, na página `recuperar-senha.html`, agora com o formulário **Senha nova** e **Repita a senha nova**.
5. Digite senhas diferentes: **As senhas não são iguais.** Digite menos de 6 caracteres: **A senha deve ter pelo menos 6 caracteres.** Digite uma senha nova válida nos dois campos e clique em **Salvar senha nova**: aparece **Senha alterada! Você já está logada. Redirecionando…** e você vai para a sua página inicial, logada.
6. Saia e tente entrar com a senha **antiga**: **E-mail ou senha incorretos.** Entre com a **nova**: funciona.
7. **Link usado ou vencido:** volte ao e-mail e clique no **mesmo link** de novo: a tela mostra **Este link não vale mais: ele expirou ou já foi usado. Peça um novo link abaixo.**

**Se o e-mail não chegar:** o plano gratuito do Supabase envia **poucos e-mails por hora** e, sem um servidor de e-mail próprio, pode enviar **só para os membros da organização** do projeto. Teste com o e-mail de quem criou o projeto ou de uma integrante convidada (Aula 25), e espere um pouco se aparecer **Muitas tentativas em pouco tempo**.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria a recuperação de senha por e-mail"
git push
```

## Explicação do Código

**authServico.js (recuperação)**

- `validarEmailDeRecuperacao({ email })` e `validarNovaSenha({ senha, confirmacao })`: devolvem objetos de erros. A nova senha precisa de 6 ou mais caracteres **e** ser igual à confirmação (`erros.confirmacao = "As senhas não são iguais."`).
- `pedirRedefinicaoDeSenha(email)`: calcula o endereço de retorno com `new URL("recuperar-senha.html", location.href).href` (que **descarta** qualquer `?` ou `#` do endereço atual, e funciona no seu computador e no site publicado) e chama `supabase.auth.resetPasswordForEmail(email, { redirectTo: ... })`. O Supabase **não diz** se o e-mail tem conta: por isso a tela mostra sempre a mesma mensagem.
- `aoReceberLinkDeRecuperacao(callback)`: usa `onAuthStateChange` e chama o `callback` quando o evento é `PASSWORD_RECOVERY`. Devolve uma função para parar de observar.
- `definirNovaSenha({ senha, confirmacao })`: valida e chama `supabase.auth.updateUser({ password: senha })`. Como a pessoa chegou pelo link, ela já tem uma sessão, e a troca é permitida.

**recuperarSenha.js**

- A página tem **duas etapas** (`#etapa-pedido` e `#etapa-nova-senha`); a segunda começa escondida (`hidden`). `mostrarEtapaDaNovaSenha()` esconde uma e mostra a outra, coloca o foco no campo da senha e preenche um campo **escondido** com o e-mail da conta, só para o gerenciador de senhas do navegador salvar a senha nova na conta certa.
- `iniciar()`: lê o endereço depois do `#` (`new URLSearchParams(location.hash.slice(1))`): o Supabase coloca ali `type=recovery` quando o link é válido, ou `error`/`error_code` quando falhou (vencido ou já usado). Com erro, mostra **Este link não vale mais...**. Com `type=recovery`, espera até 8 segundos o aviso `PASSWORD_RECOVERY`; se ele não chegar, `confirmarOuAvisarErroDoLink()` confere se existe uma sessão de recuperação (`usuariaAtual()`) antes de dizer que o link não funcionou.
- `enviar(formulario, textoEnquantoEspera, acao)`: uma função **reutilizada** pelos dois formulários: trava contra duplo clique, desabilita o botão, mostra "Enviando…" e trata o erro em um só lugar.
- Depois de salvar a senha nova, mostra o sucesso e, após 1,5 segundo, vai para `usuaria.rotaInicial()` (ou para o login, se algo falhar).

## Validação

1. O e-mail inválido mostra o erro ao lado do campo; um e-mail com conta e outro sem conta mostram **a mesma mensagem**.
2. O link do e-mail abre a etapa da senha nova; senhas diferentes ou curtas mostram erro ao lado do campo.
3. A senha nova vale, a antiga **não** vale mais (CT-23), e a pessoa já fica logada.
4. O mesmo link, usado de novo, mostra **Este link não vale mais...**.

**Erros comuns**

1. *Sintoma:* o link do e-mail abre a página inicial (e não `recuperar-senha.html`). *Causa:* o endereço não está em **Redirect URLs** (em português: **URLs de redirecionamento**), então o Supabase usa o **Site URL** (em português: **URL do site**). *Correção:* repita o Passo 1 com o endereço exato, incluindo `.html`.
2. *Sintoma:* o link abre a página, mas nada acontece e aparece "Não foi possível confirmar o link". *Causa:* o endereço de teste (`127.0.0.1` ou `localhost`) é diferente do liberado. *Correção:* libere **os dois** e abra o site pelo mesmo endereço do link.
3. *Mensagem:* `Muitas tentativas em pouco tempo`. *Causa:* limite de e-mails do plano gratuito. *Correção:* espere uns minutos.
4. *Sintoma:* o e-mail não chega. *Causa:* limite de envio ou restrição de destinatário do plano gratuito (veja a observação do Passo 4). *Correção:* teste com o e-mail de um membro da organização e confira a caixa de spam.

**Se travar**

1. Abra o Console (F12) e a aba **Network** (em português: **Rede**) e filtre por `recover`: o pedido mostra o erro do Supabase.
2. Confira o endereço depois do `#` ao clicar no link: ele deve conter `type=recovery`.
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `recuperar-senha.html` e `js/paginas/recuperarSenha.js`.
- `authServico.js` com as funções de recuperação de senha.
- O endereço de retorno liberado no painel do Supabase.

**Como saber que deu certo:** você troca a senha pelo link do e-mail, entra com a senha nova e a antiga deixa de valer.
