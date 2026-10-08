# Aula 78 – Minha conta, exclusão da própria conta, conteúdo real e ajustes

**Dia 26 · Qui 12/11/2026** · **Aula 78** · **UC6**

- **Requisitos cobertos:** RF-25 (permitir à usuária excluir a própria conta; digitar EXCLUIR apaga a conta e os dados dela e a pessoa volta à página inicial como visitante), RN-14 (a exclusão apaga perfil, pedidos, loja, produtos, tamanhos e fotos, de forma definitiva) e RN-12 (de 0 a 5 fotos por produto; a primeira é a capa); caso de teste CT-24
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** Pedidos recebidos e Meus pedidos funcionando, com contador de novidades; função excluir_minha_conta() criada no banco (Aulas 39, 76 e 77); fotos e conteúdo da UC4 (fotos tratadas e descrições) disponíveis para a equipe

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar a tela **Minha conta**, em que a usuária vê os seus dados e pode **excluir a própria conta** digitando **EXCLUIR**: o site apaga antes os **arquivos de foto** do Storage e depois chama a função do banco, que apaga o resto. Também vai **carregar o conteúdo real** (lojas, produtos e fotos) pelo próprio sistema e **ajustar a interface** com esse conteúdo.

**Abertura (10 minutos).** Retomada da Aula 77: o ciclo do pedido está fechado. Faltam duas coisas: (1) a **LGPD** garante a toda pessoa o direito de **apagar os próprios dados**; (2) o catálogo ainda tem só produtos de teste. Combinem a divisão: duas pessoas ficam com a **Minha conta** e as outras com a **carga de conteúdo**. Confira que as fotos e os textos da UC4 estão em uma pasta compartilhada, com nomes organizados (por loja e produto).

## O Conceito

**Termos desta aula**

- **Exclusão da conta (RN-14)**: é **definitiva**. Apaga o perfil, os pedidos (os feitos por ela e, se for lojista, os recebidos pela loja dela), a loja, os produtos, os tamanhos e as fotos.
- **Confirmação digitada**: uma ação perigosa pede que a pessoa **digite uma palavra** (`EXCLUIR`), para não ser feita por engano com um clique.
- **Apagar em cascata**: apagar a "linha mãe" (o perfil) apaga sozinhas as "filhas" (loja, produtos, tamanhos, fotos) por causa do `on delete cascade` da Aula 26.
- **Arquivos fora do banco**: as **fotos** ficam no **Storage**, que o banco **não alcança**. Por isso o **site** apaga os arquivos **antes** de chamar a função do banco.

**Analogia:** excluir a conta é **fechar a loja de vez**: antes de entregar as chaves, a lojista **leva embora os produtos do depósito** (os arquivos de foto) e só então o contador **encerra o cadastro** (a função do banco). Se tentasse fechar o cadastro antes, o depósito ficaria cheio de coisas sem dono.

**Regras:** depois de excluir, a pessoa volta à página inicial **como visitante**; a conta não existe mais e não dá para entrar de novo (CT-24). **Use só contas de teste** nos testes de exclusão.

## Mão na Massa

### Passo 1: o serviço que exclui a conta

Em `js/servicos/authServico.js`, a importação do apoio ao Storage entra **logo depois** da linha das funções de formatação:

**Arquivo: `js/servicos/authServico.js`**: substitua a linha `import { normalizarTelefone, telefoneValido } from "../ui/formatadores.js";` por:

```js
import { normalizarTelefone, telefoneValido } from "../ui/formatadores.js";
import { tentarRemoverFotos } from "./storageServico.js";
```


E cole **no final do arquivo** a seção da exclusão de conta:

**Arquivo: `js/servicos/authServico.js`**: adicione este trecho no final do arquivo:

```js
// ---------- Excluir a própria conta (RF-25) ----------

// Apaga os arquivos de foto da loja da lojista (o banco não alcança o Storage) e depois chama a função
// excluir_minha_conta() do banco (database/04_melhorias.sql), que apaga pedidos, loja, produtos, perfil e a conta.
// Se alguma foto não puder ser apagada, a exclusão da conta continua: foto sobrando é só espaço ocupado.
export async function excluirMinhaConta() {
  try {
    const usuaria = await usuariaAtual();
    if (!usuaria) {
      throw new ErroApp("exige_login", "Entre na sua conta para excluí-la.");
    }
    const supabase = exigirSupabase();

    if (usuaria instanceof Lojista) {
      const { data: fotos, error: erroDasFotos } = await supabase
        .from("produto_fotos")
        .select("caminho, produtos!inner ( loja_id, lojas!inner ( dono_id ) )")
        .eq("produtos.lojas.dono_id", usuaria.id)
        .not("caminho", "is", null);
      if (erroDasFotos) {
        throw erroDasFotos;
      }
      await tentarRemoverFotos(fotos.map((foto) => foto.caminho));
    }

    const { error } = await supabase.rpc("excluir_minha_conta");
    if (error) {
      throw error;
    }

    // A conta já não existe: só falta descartar a sessão guardada no navegador
    usuariaEmCache = null;
    try {
      await supabase.auth.signOut({ scope: "local" });
    } catch (erroAoSair) {
      console.warn("Conta excluída; a sessão local será descartada.", erroAoSair);
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível excluir a conta. Tente novamente em instantes.");
  }
}
```


### Passo 2: a tela Minha conta

Crie `minha-conta.html` e `js/paginas/minhaConta.js`:

**Arquivo: `minha-conta.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Minha conta – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container" hidden>
    <h1>Minha conta</h1>

    <section class="cartao-formulario cartao-formulario-largo" aria-labelledby="titulo-dados">
      <h2 id="titulo-dados">Meus dados</h2>
      <dl class="dados-da-conta">
        <dt>Nome</dt>
        <dd id="conta-nome"></dd>
        <dt>E-mail</dt>
        <dd id="conta-email"></dd>
        <dt>Tipo de conta</dt>
        <dd id="conta-tipo"></dd>
      </dl>
    </section>

    <section class="cartao-formulario cartao-formulario-largo zona-de-perigo" aria-labelledby="titulo-excluir">
      <h2 id="titulo-excluir">Excluir minha conta</h2>
      <p>Esta ação é definitiva e não pode ser desfeita. Ao excluir:</p>
      <ul id="lista-do-que-some">
        <li>seus dados de cadastro e o seu acesso ao site são apagados;</li>
        <li>os seus pedidos e o histórico deles são apagados.</li>
      </ul>
      <form class="formulario" id="formulario-excluir" novalidate>
        <div class="campo">
          <label for="confirmacao">Para confirmar, digite EXCLUIR</label>
          <input type="text" id="confirmacao" name="confirmacao" autocomplete="off" autocapitalize="characters" required>
        </div>
        <button type="submit" class="botao botao-perigo">Excluir minha conta</button>
      </form>
    </section>
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

  <script type="module" src="js/paginas/minhaConta.js"></script>
</body>
</html>
```


**Arquivo: `js/paginas/minhaConta.js`** (arquivo novo, inteiro)

```js
// Minha conta (RF-25): mostra os dados da usuária e permite excluir a própria conta.
// Cliente e lojista abrem esta tela (RF-14: só quem está logada).
import { montarCabecalho } from "../ui/cabecalho.js";
import {
  mostrarCarregando, mostrarErro, mostrarSucesso, limparAvisos, mensagemDoErro,
  mostrarErroDoCampo, limparErrosDosCampos,
} from "../ui/avisos.js";
import { exigirLogin } from "../ui/protecao.js";
import { excluirMinhaConta } from "../servicos/authServico.js";
import { Lojista } from "../modelos/Lojista.js";
import { criarElemento } from "../ui/elementos.js";

const PALAVRA_DE_CONFIRMACAO = "EXCLUIR";

const formulario = document.getElementById("formulario-excluir");
const campoConfirmacao = document.getElementById("confirmacao");
const botao = formulario.querySelector('button[type="submit"]');
const listaDoQueSome = document.getElementById("lista-do-que-some");

let enviando = false;

function mostrarDadosDaConta(usuaria) {
  // textContent: o nome vem do banco, então nunca entra como HTML
  document.getElementById("conta-nome").textContent = usuaria.nome;
  document.getElementById("conta-email").textContent = usuaria.email ?? "";
  document.getElementById("conta-tipo").textContent = usuaria instanceof Lojista ? "Lojista" : "Cliente";

  // A lojista perde também a loja; o aviso só aparece para quem tem loja
  if (usuaria instanceof Lojista) {
    listaDoQueSome.append(
      criarElemento("li", "", "a sua loja, os seus produtos e as fotos deles saem do catálogo e são apagados;"),
      criarElemento("li", "", "os pedidos que a sua loja recebeu também são apagados.")
    );
  }
}

formulario.addEventListener("submit", async (evento) => {
  evento.preventDefault();
  if (enviando) {
    return;
  }
  limparErrosDosCampos(formulario);
  limparAvisos();

  // Digitar a palavra evita excluir a conta por engano, com um clique sem querer
  if (campoConfirmacao.value.trim().toUpperCase() !== PALAVRA_DE_CONFIRMACAO) {
    mostrarErroDoCampo(campoConfirmacao, "Digite " + PALAVRA_DE_CONFIRMACAO + " para confirmar.");
    campoConfirmacao.focus();
    return;
  }

  enviando = true;
  botao.disabled = true;
  mostrarCarregando("Excluindo a conta…");

  try {
    await excluirMinhaConta();
    mostrarSucesso("Conta excluída. Obrigada por ter usado a VitrineCol. Redirecionando…");
    setTimeout(() => location.assign("index.html"), 2000);
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    enviando = false;
    botao.disabled = false;
  }
});

async function iniciar() {
  montarCabecalho();

  const usuaria = await exigirLogin();
  if (usuaria) {
    mostrarDadosDaConta(usuaria);
  }
}

iniciar();
```


No `css/paginas.css`, cole a seção **logo antes** do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Botão "Carregar mais" do catálogo ---------- */`:

```css
/* ---------- Minha conta ---------- */
.cartao-formulario + .cartao-formulario {
  margin-top: var(--espaco-5);
}

.dados-da-conta {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: var(--espaco-2) var(--espaco-4);
  margin: 0;
}

.dados-da-conta dt {
  font-weight: 600;
}

.dados-da-conta dd {
  margin: 0;
  overflow-wrap: anywhere;
}

.zona-de-perigo {
  border-color: var(--cor-erro);
}

.zona-de-perigo ul {
  margin: 0 0 var(--espaco-4) var(--espaco-5);
}
```


### Passo 3: teste a exclusão da conta (CT-24)

1. Crie uma conta **só para o teste**: cadastre uma **lojista de teste** em **Cadastrar**, crie a loja dela em **Minha loja** e um produto com **uma foto** (assim a exclusão apaga loja, produto e arquivo).
2. Clique no seu **nome** no cabeçalho (**Olá, ...**): abre **Minha conta**, com **Meus dados** (nome, e-mail e tipo de conta) e a área **Excluir minha conta** (borda vermelha), que lista o que vai sumir: para a lojista, também a loja, os produtos, as fotos e os pedidos recebidos.
3. Clique em **Excluir minha conta** com o campo **vazio**: **Digite EXCLUIR para confirmar.** ao lado do campo. Digite `excluir` ou `EXCLUIR` (a comparação ignora maiúsculas) e confirme: aparece **Excluindo a conta…**, depois **Conta excluída. Obrigada por ter usado a VitrineCol. Redirecionando…** e, em 2 segundos, você volta à página inicial **como visitante**.
4. **Confira que sumiu tudo:**
   - **Authentication > Users** (em português: **Autenticação > Usuários**): a conta não existe mais.
   - No **SQL Editor** (em português: **Editor SQL**): `select count(*) from public.perfis where nome = 'NOME DA CONTA';` deve voltar `0`, e a loja e os produtos dela também sumiram (`select nome from public.lojas;`).
   - **Storage** > **produtos** (em português: **Armazenamento**): a pasta da loja e as fotos **não existem mais**.
5. Tente **entrar** com o e-mail e a senha dessa conta: **E-mail ou senha incorretos.**
6. **Visitante e proteção:** sem login, abra `minha-conta.html`: você vai para `login.html?voltar=minha-conta.html`.

### Passo 4: carregue o conteúdo real pelo próprio sistema

A meta é **pelo menos 3 lojas e 12 produtos, com 2 fotos cada** (e, para o **CT-22**, 13 ou mais produtos ativos no total). Divida entre as integrantes:

1. **Uma conta de lojista por loja** (use e-mails reais da equipe ou de lojistas parceiras, com o consentimento delas). Cada lojista: **Cadastrar** (perfil **Lojista**) > **Minha loja** (nome real, descrição, endereço, cidade, WhatsApp com DDD e, se possível, o link do mapa).
2. Em **Meus produtos** e depois **Cadastrar produto**: nome claro, **categoria certa**, preço real, **tamanhos com estoque** e **2 ou mais fotos** (a primeira é a capa: escolha a mais bonita). Use as fotos e os textos que a equipe produziu na UC4. **Só use imagens com autorização de uso** (nada tirado da internet sem permissão e nada com rosto de pessoas sem consentimento).
3. Mantenha **um padrão**: nomes de produto sem abreviações, descrição em 1 ou 2 frases, fotos na vertical (4:5), fundo limpo.
4. **Remova os dados de teste** que ficaram (produtos como "Teste", lojas de exemplo com endereço fictício), desativando ou excluindo pelo painel.

Depois de cadastrar, confira no catálogo: cada loja tem **pelo menos 4 produtos**, cada produto tem a **capa** certa e todos os tipos de roupa que existem aparecem nos filtros.

### Passo 5: ajuste a interface com o conteúdo real (responsividade e acessibilidade)

Com o conteúdo real, **repita rapidamente** estes testes em **360 px** e **1280 px** nas telas principais (início, catálogo, produto, sacola, painel) e anote cada problema em um cartão do Kanban:

- [ ] Nomes de produto **longos** quebram em duas linhas sem estourar o card.
- [ ] Fotos de proporções diferentes **não deformam** (o CSS recorta com `object-fit: cover`).
- [ ] O texto das descrições e dos recados cabe nas telas pequenas.
- [ ] O foco do teclado aparece em todos os botões e links; o fluxo de pedido funciona **só com o teclado** (CT-14).
- [ ] Os preços estão em R$ com vírgula e as datas em dd/mm/aaaa.
- [ ] As imagens têm `alt` (o nome do produto) e as páginas têm um só `h1`.

Corrija os itens **críticos** agora (cada correção em uma branch, como na Aula 42) e deixe os **desejáveis** para o backlog. **Itens pendentes do backlog:** priorize os cartões **críticos** e **importantes**; os **desejáveis** só entram se sobrar tempo.

### Passo 6: faça o commit da aula

```bash
git switch -c minha-conta
git add .
git commit -m "Cria a tela Minha conta com a exclusão da própria conta"
git push -u origin minha-conta
```

Abra o pull request e peça a revisão de outra integrante. (O conteúdo real fica no Supabase, não no repositório.)

## Explicação do Código

**authServico.js, `excluirMinhaConta()`**

1. Descobre quem está logada (`usuariaAtual()`); se ninguém, lança "Entre na sua conta para excluí-la.".
2. **Se for lojista**, busca os `caminho` de **todas as fotos de todos os produtos da loja dela** em `produto_fotos`, com a consulta `.select("caminho, produtos!inner ( loja_id, lojas!inner ( dono_id ) )").eq("produtos.lojas.dono_id", usuaria.id).not("caminho", "is", null)` e chama `tentarRemoverFotos(...)` para apagar os arquivos do **Storage**. É "melhor esforço": se alguma foto não for apagada, a exclusão da conta **continua** (foto sobrando é só espaço ocupado).
3. Chama a função do banco: `supabase.rpc("excluir_minha_conta")`. Ela apaga os **pedidos** da conta e a **usuária** (`auth.users`); o resto some em **cascata**.
4. Limpa o cache da usuária e descarta a sessão guardada no navegador (`signOut({ scope: "local" })`), porque a conta já não existe.

**minhaConta.js**

- `iniciar()`: `const usuaria = await exigirLogin();` (qualquer perfil logado abre esta tela) e `mostrarDadosDaConta(usuaria)`: coloca nome, e-mail e tipo de conta com `textContent` (o nome vem do banco). Para a lojista, acrescenta à lista "o que some" os itens da loja e dos pedidos recebidos.
- `submit`: confere a palavra (`campoConfirmacao.value.trim().toUpperCase() !== "EXCLUIR"` mostra o erro ao lado do campo), trava o botão, mostra "Excluindo a conta…", chama `excluirMinhaConta()` e, se der certo, mostra o sucesso e, depois de 2 segundos (`setTimeout`), vai para `index.html`. Em caso de erro, mostra a mensagem e libera o botão.

**minha-conta.html**: duas `section`: **Meus dados** (uma lista de definição `dl` com os campos `conta-nome`, `conta-email` e `conta-tipo`) e **Excluir minha conta** (com a classe `zona-de-perigo`, o formulário com o campo de confirmação e o botão `botao-perigo`).

**Por que o site apaga as fotos antes da função do banco?** Depois que a função apaga a conta, a lojista **já não está mais logada**, e a regra do Storage (só a dona da loja apaga na pasta da loja) **não deixaria** apagar os arquivos. Então os arquivos saem **primeiro**, enquanto ela ainda tem permissão.

## Validação

1. **Minha conta** mostra os dados e a área de exclusão; sem digitar `EXCLUIR`, não exclui.
2. Excluir uma conta de teste de lojista apaga a conta, o perfil, a loja, os produtos, as fotos (inclusive os arquivos no Storage) e os pedidos recebidos; depois a pessoa volta ao início como visitante e **não consegue entrar** (CT-24).
3. O catálogo tem **pelo menos 3 lojas e 12 produtos**, com 2 fotos cada (e 13 ou mais para o CT-22).
4. As telas principais funcionam em 360 e 1280 px com o conteúdo real, e a lista de ajustes tem cartões com prioridade.

**Erros comuns**

1. *Sintoma:* "Digite EXCLUIR para confirmar" mesmo digitando. *Causa:* espaços extras ou outra palavra. *Correção:* digite exatamente `EXCLUIR` (com ou sem maiúsculas, mas sem espaços).
2. *Mensagem:* `permission denied for function excluir_minha_conta`. *Causa:* o `04_melhorias.sql` não foi rodado (Aula 39). *Correção:* rode o `04_melhorias.sql`.
3. *Sintoma:* a conta foi excluída, mas as fotos ficaram no Storage. *Causa:* a remoção "melhor esforço" falhou (por exemplo, as fotos eram links externos, sem `caminho`). *Correção:* apague a pasta da loja pelo painel do Supabase (**Storage**, em português: **Armazenamento**); fotos por endereço (URL) não ocupam o Storage.
4. *Mensagem:* `Este item está ligado a outros dados...` ao excluir pelo painel **Authentication** (em português: **Autenticação**). *Causa:* o painel não apaga contas que têm pedidos ligados. *Correção:* use a tela **Minha conta**, que chama a função do banco.

**Se travar**

1. No Console (F12) e na aba **Network** (em português: **Rede**), veja a **Response** (em português: **Resposta**) do pedido `excluir_minha_conta`.
2. Confira se a conta de teste é lojista e se tem a loja cadastrada (para o teste completo).
3. Compare os arquivos com os da aula; se preciso, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `minha-conta.html` e `js/paginas/minhaConta.js`; `authServico.js` com `excluirMinhaConta`; a seção **Minha conta** em `paginas.css`.
- As **15 páginas HTML** do projeto, os **5 arquivos CSS**, todos os módulos de `js/` e os **4 scripts SQL**.
- No Supabase: o catálogo com conteúdo real (3 lojas, 12 ou mais produtos, 2 fotos cada).

**Como saber que deu certo:** você exclui uma conta de teste digitando `EXCLUIR` e a conta, a loja, os produtos e as fotos somem, e o catálogo real aparece completo e bem diagramado.
