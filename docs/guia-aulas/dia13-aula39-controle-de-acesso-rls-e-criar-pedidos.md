# Aula 39 – Controle de acesso: telas protegidas, RLS e a função que grava os pedidos

**Dia 13 · Sex 23/10/2026** · **Aula 39** · **UC3**

- **Requisitos cobertos:** RF-10 (finalizar a sacola de uma cliente logada, gravando um pedido por loja), RF-14 (controle de acesso às telas por perfil), RN-03, RN-04 (só uma cliente logada cria pedido, com status inicial novo), RN-05 (fluxo de status protegido pelo banco), RN-06 (o banco calcula o total e confere o preço) e RN-09 (só a lojista dona altera a loja, os produtos, as fotos e os pedidos); casos de teste CT-06, CT-07, CT-09, CT-11 e CT-21
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** login e recuperação de senha funcionando; painel da lojista usando a lojista de teste (id fixo no config.js); sacola que monta os pedidos sem gravar; RLS desligada e política provisória de envio de fotos (Aulas 31 a 38)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos (e este é o ponto mais pesado do curso: vá no seu ritmo) você vai **proteger as telas por perfil**, exigir **login** para finalizar a sacola, **ligar a RLS** (regras de acesso por linha) nas 8 tabelas, **apagar a política provisória** de fotos, criar a função do banco **`criar_pedidos`** que grava os pedidos e **testar pelo console** que o banco recusa o que é proibido. Também cria a página de **aviso de privacidade** e vê noções de **LGPD**.

**Abertura (10 minutos).** Retomada da Aula 38: o site já sabe quem entrou, mas **nada** impede uma cliente de abrir o painel da lojista, e o painel ainda usa a lojista de teste fixa. Além disso, hoje o banco está **aberto**: qualquer pessoa com a chave pública pode ler e alterar tudo. Lembre: a chave `anon` é pública por natureza; a segurança tem de estar **no banco**. Antes de começar, confira que você tem: (a) uma conta de **cliente**, (b) a **Lojista Teste** e (c) uma **segunda lojista** (cadastre uma nova com perfil **Lojista** e crie a loja dela em **Minha loja**, com um produto).

> **Ordem importante:** primeiro mudamos o **código** (Passos 1 a 6) e **só depois** ligamos a RLS no banco (Passos 7 e 8). Se você ligar a RLS antes, o painel antigo, que usa a lojista de teste, deixa de funcionar.

## O Conceito

**Termos desta aula**

- **RLS (Row Level Security, segurança por linha)**: regras **dentro do banco** que dizem, para cada tabela, **quem** pode ler, inserir, alterar ou apagar **cada linha**. Com a RLS ligada e **sem** regra, ninguém faz nada: cada permissão precisa ser dada por uma **política**.
- **Política (policy)**: uma regra de RLS. Exemplo: "a lojista só altera os produtos cuja loja é dela" (`sou_dono_da_loja(loja_id)`).
- **Função do banco (`criar_pedidos`)**: um programa **dentro do banco** que o site chama com `supabase.rpc(...)`. Grava os pedidos e itens **numa só transação** (ou grava tudo, ou nada), calcula o total e confere o preço e o estoque. É por isso que o site **não** grava mais direto nas tabelas `pedidos` e `itens_pedido`.
- **Tela protegida**: uma tela que só abre para certo perfil. A página começa com o `<main>` **escondido** e só o mostra depois de confirmar quem está logada; assim o conteúdo nunca "pisca" na tela de quem não tem acesso.
- **LGPD**: a Lei Geral de Proteção de Dados. Coletamos **só** o necessário (nome, e-mail e telefone opcional), explicamos para que serve, e a titular pode **apagar** os dados dela (Dia 26).

**Importante:** esconder uma tela no navegador **não é segurança**: quem sabe programar pula essa proteção. A proteção **de verdade** é a RLS e a função do banco. As telas protegidas existem para a experiência (ir para o lugar certo); o banco protege os dados.

**Analogia:** o site é um prédio comercial. As **telas protegidas** são as placas "Só funcionários" nas portas; a **RLS** é a **fechadura de verdade** em cada sala, que só abre com o crachá certo; e a função `criar_pedidos` é o **caixa**, que recebe o pedido, confere os preços **na tabela dele** e só então grava.

## Mão na Massa

### Passo 1: o arquivo de proteção das telas

Crie `js/ui/protecao.js`:

**Arquivo: `js/ui/protecao.js`** (arquivo novo, inteiro)

```js
// Proteção de telas por perfil (RF-14). Cada tela protegida chama exigirLogin() ou exigirPerfil().
// As páginas protegidas começam com o <main> escondido (atributo hidden); ele só aparece quando
// a verificação passa. Assim o conteúdo nunca "pisca" na tela de quem não tem acesso.
import { usuariaAtual } from "../servicos/authServico.js";
import { Cliente } from "../modelos/Cliente.js";
import { Lojista } from "../modelos/Lojista.js";
import { mostrarErro, mensagemDoErro } from "./avisos.js";

const PERFIS = { cliente: Cliente, lojista: Lojista };

// Só aceitamos o nome de uma página do próprio site, como "sacola.html" ou "produto.html?id=3".
// Isso impede o "redirecionamento aberto": alguém mandar a usuária, depois do login, para um site de fora
// (por exemplo login.html?voltar=https://site-falso.com).
const FORMATO_DE_ENDERECO_DO_SITE = /^[A-Za-z0-9_-]+\.html(\?[^#\s]*)?(#\S*)?$/;

// Voltar para o login ou o cadastro depois de entrar faria a usuária ficar andando em círculos
const PAGINAS_DE_ENTRADA = ["login.html", "cadastro.html"];

// Devolve o endereço se for seguro, ou null se não for (ou se faltar).
export function enderecoDeRetornoSeguro(valor) {
  if (typeof valor !== "string") {
    return null;
  }

  const endereco = valor.trim();
  if (!FORMATO_DE_ENDERECO_DO_SITE.test(endereco)) {
    return null;
  }

  const pagina = endereco.split(/[?#]/)[0].toLowerCase();
  if (PAGINAS_DE_ENTRADA.includes(pagina)) {
    return null;
  }

  // Segunda checagem, com o interpretador de endereços do navegador: tem que continuar no mesmo site
  try {
    if (new URL(endereco, location.href).origin !== location.origin) {
      return null;
    }
  } catch (erro) {
    return null;
  }

  return endereco;
}

// A página em que a usuária está agora, no formato "pagina.html?consulta#parte".
function enderecoAtual() {
  const pagina = location.pathname.split("/").pop() || "index.html";
  return pagina + location.search + location.hash;
}

function liberarConteudo() {
  const principal = document.getElementById("conteudo");
  if (principal) {
    principal.hidden = false;
  }
}

// Se não deu para saber quem está logada (ex.: sem internet), mostra o erro no lugar do conteúdo.
function mostrarFalhaNaProtecao(erro) {
  const principal = document.getElementById("conteudo");
  const titulo = document.createElement("h1");
  titulo.textContent = "Não foi possível abrir a página";
  principal.replaceChildren(titulo);
  principal.hidden = false;
  mostrarErro(mensagemDoErro(erro));
}

// Leva para o login e volta para a página atual depois (RF-10: "Finalizar sacola" sem estar logada).
// Usada por botões, onde a pessoa pode querer voltar com o botão "Voltar" do navegador, por isso usa assign.
export function irParaOLogin() {
  location.assign("login.html?voltar=" + encodeURIComponent(enderecoAtual()));
}

// Devolve a usuária logada; se não houver, manda para o login. Não mostra o conteúdo ainda.
async function obterUsuariaOuIrParaLogin() {
  let usuaria;
  try {
    usuaria = await usuariaAtual();
  } catch (erro) {
    mostrarFalhaNaProtecao(erro);
    return null;
  }

  if (!usuaria) {
    // replace (e não assign) para o botão "Voltar" do navegador não cair de novo nesta página protegida
    location.replace("login.html?voltar=" + encodeURIComponent(enderecoAtual()));
    return null;
  }
  return usuaria;
}

// Para telas que qualquer usuária logada pode abrir. Devolve a usuária ou null (e já redirecionou).
export async function exigirLogin() {
  const usuaria = await obterUsuariaOuIrParaLogin();
  if (usuaria) {
    liberarConteudo();
  }
  return usuaria;
}

// Para telas de um perfil só: exigirPerfil("lojista") ou exigirPerfil("cliente").
// Quem tem o outro perfil vai para a própria página inicial (polimorfismo: rotaInicial()).
export async function exigirPerfil(perfil) {
  const ClasseDoPerfil = PERFIS[perfil];
  if (!ClasseDoPerfil) {
    throw new Error('Perfil desconhecido: use "cliente" ou "lojista".');
  }

  const usuaria = await obterUsuariaOuIrParaLogin();
  if (!usuaria) {
    return null;
  }

  if (!(usuaria instanceof ClasseDoPerfil)) {
    location.replace(usuaria.rotaInicial());
    return null;
  }

  liberarConteudo();
  return usuaria;
}
```


### Passo 2: login e cadastro voltam para a página de onde a pessoa veio

Em `js/paginas/login.js`, faça as trocas. (1) A importação, **logo antes** da linha do `authServico`:

**Arquivo: `js/paginas/login.js`**: adicione este trecho logo antes da linha `import { entrar, usuariaAtual, validarEntrada } from "../servicos/authServico.js";`:

```js
import { enderecoDeRetornoSeguro } from "../ui/protecao.js";
```


(2) O link para o cadastro:

**Arquivo: `js/paginas/login.js`**: substitua a linha `const botao = formulario.querySelector('button[type="submit"]');` por:

```js
const botao = formulario.querySelector('button[type="submit"]');
const linkCadastro = document.getElementById("link-cadastro");
```


(3) Cole o trecho do `voltar` **logo antes** da função `mostrarErrosDosCampos`:

**Arquivo: `js/paginas/login.js`**: adicione este trecho logo antes da linha `function mostrarErrosDosCampos(erros) {`:

```js
// "voltar" guarda a página que a usuária queria abrir (veja protecao.js). Só endereços do próprio site valem.
const voltar = enderecoDeRetornoSeguro(new URLSearchParams(location.search).get("voltar"));

// Quem vai se cadastrar também volta para a mesma página depois
if (voltar) {
  linkCadastro.href = "cadastro.html?voltar=" + encodeURIComponent(voltar);
}

```


(4) Os dois lugares que mandam a pessoa para outra página:

**Arquivo: `js/paginas/login.js`**: substitua o trecho que começa na linha `// Vai para a página inicial do perfil dela (polimorfismo: cada perfil responde rotaInicial() do seu jeito)` e termina na linha `location.assign(usuaria.rotaInicial());` (inclusive) por:

```js
    // Volta para onde ela estava indo; se não houver, vai para a página inicial do perfil dela (polimorfismo)
    location.assign(voltar ?? usuaria.rotaInicial());
```


**Arquivo: `js/paginas/login.js`**: substitua a linha `// Quem já está logada não precisa ver o login: segue para a sua página inicial` por:

```js
  // Quem já está logada não precisa ver o login: segue para o destino
```


**Arquivo: `js/paginas/login.js`**: substitua a linha `location.replace(usuaria.rotaInicial());` por:

```js
      location.replace(voltar ?? usuaria.rotaInicial());
```


Em `js/paginas/cadastro.js`, as mesmas ideias. (1) A importação, **logo antes** da linha do `ErroApp`:

**Arquivo: `js/paginas/cadastro.js`**: adicione este trecho logo antes da linha `import { ErroApp } from "../modelos/ErroApp.js";`:

```js
import { enderecoDeRetornoSeguro } from "../ui/protecao.js";
```


(2) O link para o login:

**Arquivo: `js/paginas/cadastro.js`**: substitua a linha `const botao = formulario.querySelector('button[type="submit"]');` por:

```js
const botao = formulario.querySelector('button[type="submit"]');
const linkLogin = document.getElementById("link-login");
```


(3) O trecho do `voltar`, **logo antes** da função `lerDados`:

**Arquivo: `js/paginas/cadastro.js`**: adicione este trecho logo antes da linha `function lerDados() {`:

```js
const voltar = enderecoDeRetornoSeguro(new URLSearchParams(location.search).get("voltar"));

// Quem já tem conta volta para a mesma página depois do login
if (voltar) {
  linkLogin.href = "login.html?voltar=" + encodeURIComponent(voltar);
}

```


(4) Os dois destinos:

**Arquivo: `js/paginas/cadastro.js`**: substitua o trecho que começa na linha `// A usuária já está logada: segue para a página inicial do perfil escolhido` e termina na linha `location.assign(resultado.usuaria.rotaInicial());` (inclusive) por:

```js
    // A usuária já está logada: segue para onde ia, ou para a página inicial do perfil escolhido
    location.assign(voltar ?? resultado.usuaria.rotaInicial());
```


**Arquivo: `js/paginas/cadastro.js`**: substitua a linha `location.replace(usuaria.rotaInicial());` por:

```js
      location.replace(voltar ?? usuaria.rotaInicial());
```


### Passo 3: proteja as telas do painel

Em cada uma das três telas do painel, o `<main>` passa a **nascer escondido** e a página só o mostra depois de conferir o perfil. Primeiro o HTML (uma troca em cada arquivo):

**Arquivo: `painel-loja.html`**: substitua a linha `<main id="conteudo" class="container">` por:

```html
  <main id="conteudo" class="container" hidden>
```


**Arquivo: `painel-produtos.html`**: substitua a linha `<main id="conteudo" class="container">` por:

```html
  <main id="conteudo" class="container" hidden>
```


**Arquivo: `painel-produto-form.html`**: substitua a linha `<main id="conteudo" class="container">` por:

```html
  <main id="conteudo" class="container" hidden>
```


Agora o JavaScript. Em `js/paginas/painelLoja.js`, a importação **logo antes** da linha do `lojaServico` e a função `iniciar`:

**Arquivo: `js/paginas/painelLoja.js`**: adicione este trecho logo antes da linha `import { obterMinhaLoja, salvarLoja, validarLoja } from "../servicos/lojaServico.js";`:

```js
import { exigirPerfil } from "../ui/protecao.js";
```


**Arquivo: `js/paginas/painelLoja.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  const usuaria = await exigirPerfil("lojista");
  if (!usuaria) {
    return;
  }

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
```


Em `js/paginas/painelProdutos.js`:

**Arquivo: `js/paginas/painelProdutos.js`**: adicione este trecho logo antes da linha `import { formatarPreco } from "../ui/formatadores.js";`:

```js
import { exigirPerfil } from "../ui/protecao.js";
```


**Arquivo: `js/paginas/painelProdutos.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  const usuaria = await exigirPerfil("lojista");
  if (!usuaria) {
    return;
  }

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
```


Em `js/paginas/painelProdutoForm.js` (comentário do topo, importação e `iniciar`):

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua o começo do arquivo, até a linha `// A página só valida, chama os serviços e mostra o resultado.` (inclusive) por:

```js
// Painel da lojista: cadastrar e editar produto, com tamanhos e fotos (RF-16, RF-17, RF-19, RN-02, RN-12).
// Só a lojista abre esta tela (RF-14). A página só valida, chama os serviços e mostra o resultado.
```


**Arquivo: `js/paginas/painelProdutoForm.js`**: adicione este trecho logo antes da linha `import { criarListaDeFotos } from "../ui/listaDeFotos.js";`:

```js
import { exigirPerfil } from "../ui/protecao.js";
```


**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  const usuaria = await exigirPerfil("lojista");
  if (!usuaria) {
    return;
  }

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


### Passo 4: o painel passa a usar a lojista que está logada

Em `js/servicos/lojaServico.js`, troque o começo do arquivo (importações) e as duas funções que usavam a lojista de teste:

**Arquivo: `js/servicos/lojaServico.js`**: substitua o começo do arquivo, até a linha `import { LOJISTA_DE_TESTE_ID } from "../config.js";` (inclusive) por:

```js
// Fala com o banco sobre lojas. Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Loja } from "../modelos/Loja.js";
import { Lojista } from "../modelos/Lojista.js";
import { paraErroApp } from "./errosSupabase.js";
import { usuariaAtual } from "./authServico.js";
import { normalizarTelefone, telefoneValido } from "../ui/formatadores.js";
```


**Arquivo: `js/servicos/lojaServico.js`**: substitua a função `obterMinhaLoja` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Devolve a loja da lojista logada, ou null se ela ainda não cadastrou (RN-01: no máximo uma loja).
export async function obterMinhaLoja() {
  try {
    const usuaria = await usuariaAtual();
    if (!(usuaria instanceof Lojista)) {
      throw new ErroApp("sem_permissao", "Só lojistas têm loja.");
    }

    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("lojas").select(CAMPOS_DA_LOJA).eq("dono_id", usuaria.id).maybeSingle();
    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível carregar a sua loja. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/lojaServico.js`**: substitua a função `salvarLoja` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Cria a loja (sem "id") ou edita a loja existente (com "id"). Devolve a loja gravada.
export async function salvarLoja({ id, nome, descricao, endereco, cidade, whatsapp, linkMapa }) {
  try {
    ErroApp.lancarSeHouverErros(validarLoja({ nome, endereco, cidade, whatsapp, linkMapa }));

    const usuaria = await usuariaAtual();
    if (!(usuaria instanceof Lojista)) {
      throw new ErroApp("sem_permissao", "Só lojistas podem cadastrar uma loja.");
    }

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

    const { data, error } = await supabase.from("lojas").insert({ dono_id: usuaria.id, ...linha }).select(CAMPOS_DA_LOJA).single();
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


No `js/config.js`, **apague** a constante provisória da lojista de teste (e os comentários dela) e acrescente o e-mail de contato da equipe:

**Arquivo: `js/config.js`**: apague a constante `LOJISTA_DE_TESTE_ID` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


**Arquivo: `js/config.js`**: adicione este trecho no final do arquivo:

```js
// E-mail de contato da equipe, mostrado na página de privacidade (privacidade.html).
// Troque pelo e-mail real da equipe antes de publicar o site.
export const EMAIL_DE_CONTATO = "EMAIL-DA-EQUIPE@exemplo.com";
```


(Depois de colar, troque `EMAIL-DA-EQUIPE@exemplo.com` pelo e-mail real da equipe.)

### Passo 5: a finalização exige login e grava pelo banco

Em `js/servicos/pedidoServico.js`, troque o começo do arquivo e a função `criarPedidos`:

**Arquivo: `js/servicos/pedidoServico.js`**: substitua o começo do arquivo, até a linha `import { formatarPreco } from "../ui/formatadores.js";` (inclusive) por:

```js
// Grava os pedidos da cliente (RF-10, RN-03, RN-04, RN-06). Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Cliente } from "../modelos/Cliente.js";
import { Sacola } from "../modelos/Sacola.js";
import { Pedido } from "../modelos/Pedido.js";
import { paraErroApp } from "./errosSupabase.js";
import { usuariaAtual } from "./authServico.js";
import { formatarPreco } from "../ui/formatadores.js";
```


**Arquivo: `js/servicos/pedidoServico.js`**: substitua a função `criarPedidos` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Cria um pedido por loja a partir da sacola e devolve a lista de objetos Pedido criados (cada um com o seu id).
//
// Só uma cliente logada faz pedido (RN-04). O status inicial é "novo", e todos os pedidos da mesma finalização
// têm o mesmo grupo_id (RN-03). Os ids dos pedidos nascem no navegador (crypto.randomUUID(), dentro de
// Pedido.criarPorLoja) e tudo é gravado por UMA chamada à função criar_pedidos() do banco (database/04_melhorias.sql),
// que roda numa transação: ou grava todos os pedidos e itens, ou não grava nada.
// O banco também recalcula o total, confere o preço e o estoque e não aceita pedido gravado direto nas tabelas.
export async function criarPedidos(sacola) {
  try {
    const usuaria = await usuariaAtual();
    if (!usuaria) {
      throw new ErroApp("exige_login", "Entre na sua conta para finalizar o pedido.");
    }
    if (!(usuaria instanceof Cliente)) {
      throw new ErroApp("exige_cliente", "Só contas de cliente fazem pedidos. Entre com uma conta de cliente.");
    }
    if (!(sacola instanceof Sacola) || sacola.estaVazia()) {
      throw new ErroApp("sacola_vazia", "A sacola está vazia.");
    }

    const supabase = exigirSupabase();
    await conferirProdutosDaSacola(supabase, sacola);

    // Um Pedido por loja, todos com o mesmo grupoId
    const pedidos = Pedido.criarPorLoja(sacola);

    // O total não vai no envio: quem soma é o banco
    const dadosDosPedidos = pedidos.map((pedido) => ({
      id: pedido.id,
      loja_id: pedido.lojaId,
      itens: pedido.itens.map((item) => ({
        produto_id: item.produtoId,
        tamanho: item.tamanho,
        quantidade: item.quantidade,
        preco_unitario: item.precoUnitario,
      })),
    }));

    const { error } = await supabase.rpc("criar_pedidos", {
      p_grupo_id: pedidos[0].grupoId,
      p_pedidos: dadosDosPedidos,
    });
    if (error) {
      throw error;
    }

    return pedidos;
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível enviar o pedido. Verifique sua conexão e tente novamente.");
  }
}
```


Em `js/paginas/sacola.js`, troque o começo (comentário e importações) e a função `finalizar`:

**Arquivo: `js/paginas/sacola.js`**: substitua o começo do arquivo, até a linha `import { criarElemento } from "../ui/elementos.js";` (inclusive) por:

```js
// Página da sacola: itens por loja, quantidades, total e "Finalizar" (RF-09, RF-10, RN-03, RN-04, RN-10).
// A sacola fica no navegador (localStorage); só ao finalizar ela vira pedidos no banco.
import { montarCabecalho, atualizarContadorSacola } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, mostrarInfo, limparAvisos, mensagemDoErro } from "../ui/avisos.js";
import { irParaOLogin } from "../ui/protecao.js";
import { formatarPreco, criarLinkDoWhatsapp } from "../ui/formatadores.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { Cliente } from "../modelos/Cliente.js";
import { Sacola } from "../modelos/Sacola.js";
import { usuariaAtual } from "../servicos/authServico.js";
import { criarPedidos } from "../servicos/pedidoServico.js";
import { listarContatosDasLojas } from "../servicos/lojaServico.js";
import { criarElemento } from "../ui/elementos.js";
```


**Arquivo: `js/paginas/sacola.js`**: substitua a função `finalizar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function finalizar() {
  // A trava liga JÁ no primeiro clique, antes de qualquer espera. Se ela só ligasse depois de consultar o login,
  // cliques seguidos passariam todos pela checagem e gravariam o pedido várias vezes.
  if (enviando) {
    return;
  }
  enviando = true;
  botaoFinalizar.disabled = true;
  limparAvisos();

  let usuaria;
  try {
    usuaria = await usuariaAtual();
  } catch (erro) {
    mostrarErro(mensagemDoErro(erro));
    liberarBotao();
    return;
  }

  // RN-04: sem login não há pedido. Ela vai entrar e volta para esta página, com a sacola intacta
  if (!usuaria) {
    liberarBotao(); // se ela voltar com o botão "Voltar" do navegador, o botão não pode ficar travado
    irParaOLogin();
    return;
  }
  if (!(usuaria instanceof Cliente)) {
    mostrarErro("Só contas de cliente fazem pedidos. Entre com uma conta de cliente.");
    liberarBotao();
    return;
  }

  botaoFinalizar.textContent = "Enviando pedidos…";
  mostrarCarregando("Gravando os pedidos…");

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
```


### Passo 6: a página de aviso de privacidade

Crie `privacidade.html` e `js/paginas/privacidade.js`:

**Arquivo: `privacidade.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Aviso de privacidade – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho"></header>

  <main id="conteudo" class="container">
    <div class="texto-longo">
      <h1>Aviso de privacidade</h1>
      <p>Aqui explicamos, em poucas palavras, quais dados a VitrineCol guarda, para que usamos cada um e como você pode pedir para apagá-los. Seguimos a Lei Geral de Proteção de Dados (LGPD).</p>
      <p class="aviso aviso-info" role="note">A VitrineCol é um projeto de estudo do curso Jovem Programadora (Senac). Este texto é um modelo e deve ser revisado por uma pessoa especialista antes de qualquer uso comercial.</p>

      <h2>Quais dados coletamos</h2>
      <ul>
        <li><strong>Nome e e-mail:</strong> para criar a sua conta e identificar você no site.</li>
        <li><strong>Senha:</strong> fica guardada de forma protegida pelo serviço de login. Nem a equipe do projeto consegue ler a sua senha.</li>
        <li><strong>Telefone (opcional):</strong> só se você quiser que a loja avise você pelo WhatsApp.</li>
        <li><strong>Tipo de conta:</strong> cliente ou lojista, escolhido no cadastro.</li>
        <li><strong>Pedidos:</strong> as peças, os tamanhos, as quantidades, os valores, o status e os recados da loja.</li>
        <li><strong>Se você é lojista:</strong> os dados da sua loja (nome, descrição, endereço, cidade, WhatsApp e link do mapa), os produtos e as fotos que você cadastrar.</li>
        <li><strong>No seu aparelho:</strong> a sua sacola de compras e a sua sessão de login ficam guardadas no navegador, para você não perdê-las ao recarregar a página.</li>
      </ul>
      <p>Não pedimos CPF, endereço de entrega, dados de cartão nem a sua localização. O pagamento e a entrega são combinados direto com a loja.</p>

      <h2>Para que usamos os seus dados</h2>
      <ul>
        <li>Criar a sua conta e deixar você entrar nela.</li>
        <li>Enviar o seu pedido para a loja e mostrar o andamento em <a href="meus-pedidos.html">Meus pedidos</a>.</li>
        <li>Avisar você, dentro do site, quando a loja mudar o status do pedido ou deixar um recado.</li>
        <li>Permitir que a lojista atenda o pedido e, se você informou o telefone, avise você pelo WhatsApp.</li>
      </ul>
      <p>Não vendemos os seus dados e não mostramos propaganda.</p>

      <h2>Quem pode ver o quê</h2>
      <ul>
        <li><strong>Você</strong> vê os seus dados e os seus pedidos.</li>
        <li><strong>A lojista</strong> vê o nome e o telefone (se você informou) apenas de quem fez pedido na loja dela, e só dos pedidos dessa loja.</li>
        <li><strong>Outras clientes</strong> não veem nada seu.</li>
        <li><strong>Qualquer pessoa</strong>, mesmo sem conta, vê as lojas e os produtos cadastrados.</li>
        <li><strong>A equipe do projeto</strong> tem acesso técnico ao banco de dados para manter o sistema funcionando.</li>
      </ul>

      <h2>Serviços de terceiros que usamos</h2>
      <ul>
        <li><strong>Supabase:</strong> guarda o login, o banco de dados e as fotos dos produtos.</li>
        <li><strong>GitHub Pages:</strong> hospeda as páginas do site.</li>
        <li><strong>jsDelivr:</strong> entrega uma biblioteca de código usada pelo site. Como qualquer servidor da internet, ele pode registrar o endereço IP de quem acessa.</li>
        <li><strong>WhatsApp:</strong> quando você clica em um botão de WhatsApp, o aplicativo abre com a mensagem pronta (que inclui os itens do pedido). A partir daí, valem as regras do WhatsApp.</li>
      </ul>

      <h2>Por quanto tempo guardamos</h2>
      <p>Guardamos os dados enquanto a sua conta existir. Se você pedir a exclusão, apagamos a conta e os dados ligados a ela.</p>

      <h2>Os seus direitos e como pedir a exclusão</h2>
      <p>Você pode, a qualquer momento: saber quais dados temos sobre você, corrigir um dado errado ou apagar a sua conta e os seus dados.</p>
      <p><strong>Apagar a conta:</strong> abra <a href="minha-conta.html">Minha conta</a> e use <em>Excluir minha conta</em>. A exclusão é imediata e definitiva: apaga o seu cadastro e os seus pedidos. Para lojistas, apaga também a loja, os produtos, as fotos e os pedidos que a loja recebeu (a cliente que fez esses pedidos deixa de vê-los).</p>
      <p><strong>Saber ou corrigir os seus dados:</strong> escreva para a equipe do projeto pelo e-mail <span id="email-de-contato">de contato da equipe</span>, usando o mesmo e-mail da sua conta e dizendo o que você precisa. A equipe responde o mais rápido possível.</p>

      <p><a href="catalogo.html">Voltar ao catálogo</a></p>
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

  <script type="module" src="js/paginas/privacidade.js"></script>
</body>
</html>
```


**Arquivo: `js/paginas/privacidade.js`** (arquivo novo, inteiro)

```js
// Página de privacidade: monta o cabeçalho e coloca o e-mail de contato (definido num lugar só, o js/config.js).
import { montarCabecalho } from "../ui/cabecalho.js";
import { EMAIL_DE_CONTATO } from "../config.js";

montarCabecalho();

const lugarDoEmail = document.getElementById("email-de-contato");
if (lugarDoEmail) {
  // O e-mail entra por textContent e pelo href montado aqui; nada é interpretado como HTML
  const link = document.createElement("a");
  link.href = "mailto:" + EMAIL_DE_CONTATO;
  link.textContent = EMAIL_DE_CONTATO;
  lugarDoEmail.replaceChildren(link);
}
```


No `css/paginas.css`, cole a seção **logo antes** do comentário `/* ---------- Tablet ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Tablet ---------- */`:

```css
/* ---------- Privacidade ---------- */
.texto-longo {
  max-width: 45rem;
}

.texto-longo ul {
  margin: 0 0 var(--espaco-3) var(--espaco-5);
}
```


### Passo 7: ligue a RLS (script 02)

Agora o banco. Crie o arquivo `database/02_rls.sql` com o conteúdo abaixo. Ele **apaga a política provisória** de envio de fotos (primeira linha), cria duas funções auxiliares, **liga a RLS nas 8 tabelas**, cria as políticas e as regras do bucket de fotos (só JPG, PNG e WebP, até 2 MB, e só na pasta da própria loja). Pode ser rodado de novo sem erro.

**Arquivo: `database/02_rls.sql`** (arquivo novo, inteiro)

```sql
-- 02_rls.sql — Regras de acesso (Row Level Security) e Storage
-- Rodar só depois que o login funcionar (Fase 5). Pode ser rodado mais de uma vez: cada política
-- é apagada e criada de novo. Depois dele, rode o 04_melhorias.sql (gravação de pedidos e conta).
-- Se existir a política provisória de desenvolvimento, apague:
drop policy if exists "dev: envio de fotos" on storage.objects;

-- Funções auxiliares (security definer evita recursão entre políticas)
create or replace function public.sou_dono_da_loja(p_loja_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.lojas where id = p_loja_id and dono_id = auth.uid()
  );
$$;

create or replace function public.sou_dono_do_produto(p_produto_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.produtos pr
    join public.lojas l on l.id = pr.loja_id
    where pr.id = p_produto_id and l.dono_id = auth.uid()
  );
$$;

alter table public.perfis enable row level security;
alter table public.lojas enable row level security;
alter table public.categorias enable row level security;
alter table public.produtos enable row level security;
alter table public.tamanhos enable row level security;
alter table public.produto_fotos enable row level security;
alter table public.pedidos enable row level security;
alter table public.itens_pedido enable row level security;

-- perfis
drop policy if exists "perfis: ler o proprio" on public.perfis;
create policy "perfis: ler o proprio" on public.perfis
  for select to authenticated using (id = auth.uid());
drop policy if exists "perfis: lojista le clientes dos seus pedidos" on public.perfis;
create policy "perfis: lojista le clientes dos seus pedidos" on public.perfis
  for select to authenticated
  using (exists (
    select 1 from public.pedidos p
    where p.cliente_id = perfis.id and public.sou_dono_da_loja(p.loja_id)
  ));
drop policy if exists "perfis: alterar o proprio" on public.perfis;
create policy "perfis: alterar o proprio" on public.perfis
  for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- lojas
drop policy if exists "lojas: todos leem" on public.lojas;
create policy "lojas: todos leem" on public.lojas
  for select to anon, authenticated using (true);
drop policy if exists "lojas: lojista cria a propria" on public.lojas;
create policy "lojas: lojista cria a propria" on public.lojas
  for insert to authenticated
  with check (
    dono_id = auth.uid()
    and exists (select 1 from public.perfis where id = auth.uid() and tipo = 'lojista')
  );
drop policy if exists "lojas: dona altera" on public.lojas;
create policy "lojas: dona altera" on public.lojas
  for update to authenticated using (dono_id = auth.uid()) with check (dono_id = auth.uid());
drop policy if exists "lojas: dona exclui" on public.lojas;
create policy "lojas: dona exclui" on public.lojas
  for delete to authenticated using (dono_id = auth.uid());

-- categorias (somente leitura pelo aplicativo)
drop policy if exists "categorias: todos leem" on public.categorias;
create policy "categorias: todos leem" on public.categorias
  for select to anon, authenticated using (true);

-- produtos
drop policy if exists "produtos: todos leem os ativos" on public.produtos;
create policy "produtos: todos leem os ativos" on public.produtos
  for select to anon, authenticated using (ativo = true);
drop policy if exists "produtos: dona le todos os da loja" on public.produtos;
create policy "produtos: dona le todos os da loja" on public.produtos
  for select to authenticated using (public.sou_dono_da_loja(loja_id));
drop policy if exists "produtos: dona cria" on public.produtos;
create policy "produtos: dona cria" on public.produtos
  for insert to authenticated with check (public.sou_dono_da_loja(loja_id));
drop policy if exists "produtos: dona altera" on public.produtos;
create policy "produtos: dona altera" on public.produtos
  for update to authenticated
  using (public.sou_dono_da_loja(loja_id)) with check (public.sou_dono_da_loja(loja_id));
drop policy if exists "produtos: dona exclui" on public.produtos;
create policy "produtos: dona exclui" on public.produtos
  for delete to authenticated using (public.sou_dono_da_loja(loja_id));

-- tamanhos
drop policy if exists "tamanhos: todos leem" on public.tamanhos;
create policy "tamanhos: todos leem" on public.tamanhos
  for select to anon, authenticated using (true);
drop policy if exists "tamanhos: dona cria" on public.tamanhos;
create policy "tamanhos: dona cria" on public.tamanhos
  for insert to authenticated with check (public.sou_dono_do_produto(produto_id));
drop policy if exists "tamanhos: dona altera" on public.tamanhos;
create policy "tamanhos: dona altera" on public.tamanhos
  for update to authenticated
  using (public.sou_dono_do_produto(produto_id)) with check (public.sou_dono_do_produto(produto_id));
drop policy if exists "tamanhos: dona exclui" on public.tamanhos;
create policy "tamanhos: dona exclui" on public.tamanhos
  for delete to authenticated using (public.sou_dono_do_produto(produto_id));

-- produto_fotos (o limite de 5 fotos é garantido pelo gatilho do 01_schema.sql)
drop policy if exists "fotos: todos leem" on public.produto_fotos;
create policy "fotos: todos leem" on public.produto_fotos
  for select to anon, authenticated using (true);
drop policy if exists "fotos: dona cria" on public.produto_fotos;
create policy "fotos: dona cria" on public.produto_fotos
  for insert to authenticated with check (public.sou_dono_do_produto(produto_id));
drop policy if exists "fotos: dona altera" on public.produto_fotos;
create policy "fotos: dona altera" on public.produto_fotos
  for update to authenticated
  using (public.sou_dono_do_produto(produto_id)) with check (public.sou_dono_do_produto(produto_id));
drop policy if exists "fotos: dona exclui" on public.produto_fotos;
create policy "fotos: dona exclui" on public.produto_fotos
  for delete to authenticated using (public.sou_dono_do_produto(produto_id));

-- pedidos
-- Não há política de INSERT: os pedidos e os itens são gravados só pela função criar_pedidos() (04_melhorias.sql).
-- A lojista altera o pedido da própria loja, mas o gatilho "pedidos_protegidos" só deixa mudar
-- status e recado. A cliente marca as novidades como vistas pela função marcar_pedidos_como_vistos().
drop policy if exists "pedidos: cliente e dona da loja leem" on public.pedidos;
create policy "pedidos: cliente e dona da loja leem" on public.pedidos
  for select to authenticated
  using (cliente_id = auth.uid() or public.sou_dono_da_loja(loja_id));
drop policy if exists "pedidos: dona da loja altera o status" on public.pedidos;
create policy "pedidos: dona da loja altera o status" on public.pedidos
  for update to authenticated
  using (public.sou_dono_da_loja(loja_id)) with check (public.sou_dono_da_loja(loja_id));

-- itens_pedido
drop policy if exists "itens: cliente e dona da loja leem" on public.itens_pedido;
create policy "itens: cliente e dona da loja leem" on public.itens_pedido
  for select to authenticated
  using (exists (
    select 1 from public.pedidos p
    where p.id = itens_pedido.pedido_id
      and (p.cliente_id = auth.uid() or public.sou_dono_da_loja(p.loja_id))
  ));

-- Storage: bucket público 'produtos'; fotos em pastas por loja ({loja_id}/{produto_id}/arquivo)
-- O servidor também recusa arquivos que não sejam JPG, PNG ou WebP, ou com mais de 2 MB (RN-12)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('produtos', 'produtos', true, 2097152, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update
set file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "storage: leitura publica" on storage.objects;
create policy "storage: leitura publica" on storage.objects
  for select using (bucket_id = 'produtos');
drop policy if exists "storage: lojista envia na pasta da propria loja" on storage.objects;
create policy "storage: lojista envia na pasta da propria loja" on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'produtos'
    and public.sou_dono_da_loja(((storage.foldername(name))[1])::uuid)
  );
drop policy if exists "storage: lojista altera na pasta da propria loja" on storage.objects;
create policy "storage: lojista altera na pasta da propria loja" on storage.objects
  for update to authenticated
  using (
    bucket_id = 'produtos'
    and public.sou_dono_da_loja(((storage.foldername(name))[1])::uuid)
  );
drop policy if exists "storage: lojista exclui na pasta da propria loja" on storage.objects;
create policy "storage: lojista exclui na pasta da propria loja" on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'produtos'
    and public.sou_dono_da_loja(((storage.foldername(name))[1])::uuid)
  );
```


No **SQL Editor** (em português: **Editor SQL**) do Supabase, abra uma nova consulta, cole **o arquivo inteiro** e clique em **Run** (em português: **Executar**). Confira. Primeiro, as 8 tabelas devem mostrar `true`:

```sql
select tablename, rowsecurity from pg_tables
where schemaname = 'public' order by tablename;
```

Depois, o número de regras por tabela (24 no total em `public`): categorias 1, itens_pedido 1, lojas 4, pedidos 2, perfis 3, produto_fotos 4, produtos 5 e tamanhos 4:

```sql
select tablename, count(*) as regras from pg_policies
where schemaname = 'public' group by tablename order by tablename;
```

E a **política provisória não pode mais existir** (a consulta deve voltar **vazia**):

```sql
select policyname from pg_policies
where schemaname = 'storage' and policyname = 'dev: envio de fotos';
```

### Passo 8: a função que grava os pedidos e as melhorias (script 04)

Crie `database/04_melhorias.sql` com o conteúdo abaixo e rode-o **inteiro** no SQL Editor **depois** do 02. **Sem ele, ninguém consegue gravar pedidos** (o 02 não deixa mais gravar direto nas tabelas). Ele cria a função `criar_pedidos()`, fecha o `INSERT` direto, impõe o fluxo de status, cria `excluir_minha_conta()` (usada no Dia 26) e limita o tamanho e o tipo das fotos no servidor. Pode ser rodado mais de uma vez.

**Arquivo: `database/04_melhorias.sql`** (arquivo novo, inteiro)

```sql
-- 04_melhorias.sql — Melhorias de segurança e de conta (revisão final)
-- Rodar no SQL Editor DEPOIS do 01_schema.sql e do 02_rls.sql. Pode ser rodado mais de uma vez.
--
-- O que este script faz:
--   1) criar_pedidos(): grava os pedidos e os itens numa única transação (ou grava tudo, ou nada),
--      calcula o total no servidor e confere preço e estoque. O INSERT direto em pedidos/itens_pedido é fechado.
--   2) Gatilho dos pedidos: o banco passa a impor o fluxo de status (RN-05) e a proteger status_visto
--      e atualizado_em (RN-13).
--   3) excluir_minha_conta(): a usuária apaga a própria conta e os dados dela, sem SQL manual.
--   4) Limites do bucket "produtos": só JPG, PNG e WebP, até 2 MB (RN-12), também no servidor.

-- =====================================================================
-- 1) Pedido e itens numa transação só (RF-10, RN-03, RN-06)
-- =====================================================================

-- A cliente não insere mais direto nas tabelas: só pela função criar_pedidos() abaixo.
-- (Bancos criados com o 02_rls.sql antigo ainda têm estas duas políticas; aqui elas são apagadas.)
drop policy if exists "pedidos: cliente cria o proprio" on public.pedidos;
drop policy if exists "itens: cliente cria itens do proprio pedido" on public.itens_pedido;

-- Recebe o grupo da compra e um pedido por loja, neste formato:
--   p_pedidos = [ { "id": uuid, "loja_id": uuid,
--                   "itens": [ { "produto_id": uuid, "tamanho": "M", "quantidade": 1, "preco_unitario": 89.90 } ] } ]
-- O total NÃO vem do navegador: é a soma de preço x quantidade calculada aqui.
-- O preço que a cliente viu (preco_unitario) precisa ser o preço atual; se mudou, nada é gravado (RN-06).
-- As mensagens estão em português porque o site as mostra para a cliente como vieram.
create or replace function public.criar_pedidos(p_grupo_id uuid, p_pedidos jsonb)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_cliente uuid := auth.uid();
  v_pedido jsonb;
  v_item jsonb;
  v_produto record;
  v_pedido_id uuid;
  v_loja_id uuid;
  v_quantidade integer;
  v_total numeric(10,2);
begin
  if v_cliente is null then
    raise exception 'Entre na sua conta para finalizar o pedido.';
  end if;
  if not exists (select 1 from public.perfis where id = v_cliente and tipo = 'cliente') then
    raise exception 'Só contas de cliente fazem pedidos.';
  end if;
  if p_grupo_id is null
     or p_pedidos is null
     or jsonb_typeof(p_pedidos) <> 'array'
     or jsonb_array_length(p_pedidos) = 0 then
    raise exception 'A sacola está vazia.';
  end if;
  -- Limite de bom senso: impede um envio gigante feito à mão pelo console
  if jsonb_array_length(p_pedidos) > 20 then
    raise exception 'Muitas lojas em uma só compra. Finalize em partes.';
  end if;

  for v_pedido in select * from jsonb_array_elements(p_pedidos) loop
    v_pedido_id := (v_pedido ->> 'id')::uuid;
    v_loja_id := (v_pedido ->> 'loja_id')::uuid;

    if jsonb_typeof(v_pedido -> 'itens') <> 'array' or jsonb_array_length(v_pedido -> 'itens') = 0 then
      raise exception 'Cada pedido precisa ter pelo menos um item.';
    end if;
    if jsonb_array_length(v_pedido -> 'itens') > 100 then
      raise exception 'Itens demais em um só pedido.';
    end if;

    -- 1ª passada: confere cada item e soma o total. Nada é gravado ainda.
    v_total := 0;
    for v_item in select * from jsonb_array_elements(v_pedido -> 'itens') loop
      v_quantidade := (v_item ->> 'quantidade')::integer;
      if v_quantidade is null or v_quantidade < 1 or v_quantidade > 99 then
        raise exception 'A quantidade de cada peça deve ser de 1 a 99.';
      end if;

      -- O produto precisa estar ativo (RN-08) e ser da loja do pedido
      select pr.id, pr.nome, pr.preco into v_produto
      from public.produtos pr
      where pr.id = (v_item ->> 'produto_id')::uuid and pr.ativo and pr.loja_id = v_loja_id;
      if not found then
        raise exception 'Um dos produtos da sacola não está mais disponível. Atualize a sacola.';
      end if;

      -- RN-07: o estoque não é baixado, mas o tamanho precisa existir e ter estoque
      if not exists (
        select 1 from public.tamanhos t
        where t.produto_id = v_produto.id and t.tamanho = (v_item ->> 'tamanho') and t.estoque > 0
      ) then
        raise exception 'O tamanho % de "%" está sem estoque. Remova a peça da sacola.', (v_item ->> 'tamanho'), v_produto.nome;
      end if;

      -- RN-06: a cliente só paga o preço que viu
      if (v_item ->> 'preco_unitario')::numeric is distinct from v_produto.preco then
        raise exception 'O preço de "%" mudou. Atualize a sacola e confira o novo total.', v_produto.nome;
      end if;

      v_total := v_total + v_produto.preco * v_quantidade;
    end loop;

    -- 2ª passada: grava o pedido (status sempre "novo", RN-04) e os itens com o preço do banco
    insert into public.pedidos (id, cliente_id, loja_id, status, total, grupo_id)
    values (v_pedido_id, v_cliente, v_loja_id, 'novo', v_total, p_grupo_id);

    insert into public.itens_pedido (pedido_id, produto_id, tamanho, quantidade, preco_unitario)
    select v_pedido_id, pr.id, i.tamanho, i.quantidade, pr.preco
    from jsonb_to_recordset(v_pedido -> 'itens') as i(produto_id uuid, tamanho text, quantidade integer)
    join public.produtos pr on pr.id = i.produto_id;
  end loop;
end;
$$;

revoke execute on function public.criar_pedidos(uuid, jsonb) from public, anon;
grant execute on function public.criar_pedidos(uuid, jsonb) to authenticated;

-- =====================================================================
-- 2) Gatilho dos pedidos: fluxo de status (RN-05) e campos de aviso (RN-13)
-- =====================================================================

create or replace function public.proteger_e_marcar_pedido()
returns trigger
language plpgsql
as $$
begin
  if new.cliente_id <> old.cliente_id
     or new.loja_id <> old.loja_id
     or new.total <> old.total
     or new.grupo_id <> old.grupo_id
     or new.criado_em <> old.criado_em
     or new.observacao is distinct from old.observacao then
    raise exception 'Só o status e o recado do pedido podem ser alterados.';
  end if;

  -- status_visto e atualizado_em são controlados pelo banco. Um update vindo do navegador (papel
  -- authenticated ou anon) não pode mexer neles; a cliente usa marcar_pedidos_como_vistos(), que roda
  -- com o papel da dona da função e por isso passa por aqui.
  if current_user in ('authenticated', 'anon')
     and (new.status_visto is distinct from old.status_visto
          or new.atualizado_em is distinct from old.atualizado_em) then
    raise exception 'Só o status e o recado do pedido podem ser alterados.';
  end if;

  -- RN-05: novo -> confirmado ou cancelado; confirmado -> concluido ou cancelado; o resto é final
  if new.status <> old.status and not (
       (old.status = 'novo' and new.status in ('confirmado', 'cancelado'))
    or (old.status = 'confirmado' and new.status in ('concluido', 'cancelado'))
  ) then
    raise exception 'Esta mudança de status não é permitida para este pedido.';
  end if;

  if new.status <> old.status or new.mensagem_loja is distinct from old.mensagem_loja then
    new.status_visto := false;
    new.atualizado_em := now();
  end if;
  return new;
end;
$$;

-- =====================================================================
-- 3) Excluir a própria conta (direito da titular, LGPD)
-- =====================================================================

-- Apaga os pedidos da conta (como cliente e, se for lojista, os recebidos pela loja dela) e depois a
-- usuária. O resto (perfil, loja, produtos, tamanhos, fotos) some em cascata pelas chaves estrangeiras.
-- Os arquivos de foto do Storage são removidos pelo site antes desta chamada (storageServico).
create or replace function public.excluir_minha_conta()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  v_usuaria uuid := auth.uid();
begin
  if v_usuaria is null then
    raise exception 'Entre na sua conta para excluí-la.';
  end if;

  delete from public.pedidos
  where cliente_id = v_usuaria
     or loja_id in (select id from public.lojas where dono_id = v_usuaria);

  delete from auth.users where id = v_usuaria;
end;
$$;

revoke execute on function public.excluir_minha_conta() from public, anon;
grant execute on function public.excluir_minha_conta() to authenticated;

-- =====================================================================
-- 4) Limites do bucket de fotos (RN-12) também no servidor
-- =====================================================================

update storage.buckets
set file_size_limit = 2097152, -- 2 MB
    allowed_mime_types = array['image/jpeg', 'image/png', 'image/webp']
where id = 'produtos';
```


Confira:

```sql
-- as duas funções novas (devem aparecer 2 linhas)
select proname from pg_proc where proname in ('criar_pedidos', 'excluir_minha_conta');

-- nenhuma regra de INSERT em pedidos e itens (deve voltar 0)
select count(*) from pg_policies
where tablename in ('pedidos', 'itens_pedido') and cmd = 'INSERT';

-- limites do bucket (deve voltar 2097152 e os 3 tipos)
select file_size_limit, allowed_mime_types from storage.buckets where id = 'produtos';
```

### Passo 9: teste o acesso e o pedido (CT-09, CT-06 e CT-07)

1. **Visitante no painel (CT-09 parte 1):** sem entrar, digite `painel-loja.html` na barra de endereço: você vai para `login.html?voltar=painel-loja.html`.
2. **Cliente no painel (CT-09):** entre como **cliente** e tente abrir `painel-loja.html`: você volta para a página inicial (a cliente é bloqueada).
3. **Lojista no painel:** entre como **Lojista Teste**: o painel abre e mostra a loja dela. Em **Meus produtos** só aparecem os produtos dela (a RLS filtra).
4. **CT-06:** sem estar logada, monte a sacola com peças de duas lojas e clique em **Finalizar sacola**: você vai para o login. Entre como **cliente**: você **volta para a sacola**, com os mesmos itens.
5. **CT-07:** logada como cliente, clique em **Finalizar sacola**. Aparece **Pedidos enviados** com um botão de WhatsApp por loja. Confira no SQL Editor:

```sql
select p.id, l.nome as loja, p.status, p.total, p.grupo_id
from public.pedidos p join public.lojas l on l.id = p.loja_id
order by p.criado_em desc limit 2;
```

   Os dois pedidos têm **status `novo`** e o **mesmo `grupo_id`**. Os itens, com o preço copiado:

```sql
select p.id, i.tamanho, i.quantidade, i.preco_unitario
from public.itens_pedido i join public.pedidos p on p.id = i.pedido_id
order by p.criado_em desc;
```

6. **Lojista de teste não vê pedidos de outra loja:** como cliente, finalize; como lojista, a lista de pedidos aparece só na Aula 76 (por enquanto confira pelo SQL).

### Passo 10: testes de acesso indevido pelo console (CT-11 e CT-21)

**CT-11 (uma lojista tenta mexer no produto de outra).** Entre como a **segunda lojista**, abra qualquer página do site e o Console (F12 > **Console**, em português: **Console**). Troque `ID-DO-PRODUTO-DA-PRIMEIRA` pelo id de um produto da primeira lojista (`select id, nome from public.produtos;` no SQL Editor) e cole:

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const id = "ID-DO-PRODUTO-DA-PRIMEIRA";
console.log("alterar produto  ->", await supabase.from("produtos").update({ nome: "HACK" }).eq("id", id).select("id"));
console.log("apagar produto   ->", await supabase.from("produtos").delete().eq("id", id).select("id"));
console.log("alterar tamanhos ->", await supabase.from("tamanhos").update({ estoque: 999 }).eq("produto_id", id).select("tamanho"));
console.log("apagar fotos     ->", await supabase.from("produto_fotos").delete().eq("produto_id", id).select("id"));
```

Resultado esperado: cada linha mostra `data: []` (nenhuma linha foi afetada) e **nada** muda no painel da primeira lojista. Para o Storage, troque `ID-DA-LOJA` pelo id da loja da primeira lojista:

```js
const arquivo = new File([new Uint8Array(10)], "hack.png", { type: "image/png" });
console.log(await supabase.storage.from("produtos").upload("ID-DA-LOJA/teste/hack.png", arquivo));
```

Resultado esperado: um `error` com a mensagem `new row violates row-level security policy`.

**CT-21 (a cliente tenta gravar pedido forjado).** Entre como **cliente**, abra o Console e troque `ID-DE-UM-PRODUTO` e `ID-DA-LOJA` pelo id de um produto ativo e da loja dele (`select id, loja_id from public.produtos;`):

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const direto = await supabase.from("pedidos").insert({ cliente_id: crypto.randomUUID(), loja_id: "ID-DA-LOJA", total: 0.01 });
console.log("insert direto ->", direto.error?.message);
const forjado = await supabase.rpc("criar_pedidos", {
  p_grupo_id: crypto.randomUUID(),
  p_pedidos: [{ id: crypto.randomUUID(), loja_id: "ID-DA-LOJA",
    itens: [{ produto_id: "ID-DE-UM-PRODUTO", tamanho: "P", quantidade: 1, preco_unitario: 0.01 }] }],
});
console.log("preço forjado ->", forjado.error?.message);
```

Resultado esperado: o primeiro recusa por **row-level security**; o segundo diz que **o preço mudou**. **Nada** é gravado.

### Passo 11: faça o commit da aula

```bash
git add .
git commit -m "Protege as telas por perfil, liga a RLS e grava os pedidos pela função criar_pedidos"
git push
```

## Explicação do Código

**protecao.js**

- `exigirLogin()` e `exigirPerfil("lojista" | "cliente")`: chamadas no começo de cada tela protegida. Se ninguém está logada, `location.replace("login.html?voltar=" + ...)` (o `replace` evita que o botão "Voltar" do navegador caia de novo na página protegida); se o perfil é outro, `location.replace(usuaria.rotaInicial())` (polimorfismo); se está tudo certo, `liberarConteudo()` tira o `hidden` do `<main>`. Se **não deu para saber** quem está logada (sem internet), mostra um erro no lugar do conteúdo.
- `enderecoDeRetornoSeguro(valor)`: aceita só o nome de uma página **do próprio site** (como `sacola.html` ou `produto.html?id=3`), que não seja `login.html` ou `cadastro.html`. Isso evita o **redirecionamento aberto**: alguém mandar a pessoa, depois do login, para um site falso (`login.html?voltar=https://site-falso.com`). A segunda checagem usa `new URL(...)` e confere a `origin`.
- `irParaOLogin()`: usada pelo botão **Finalizar sacola**: vai ao login e volta para a página atual.

**login.js e cadastro.js**: `voltar` lê `?voltar=...` com `enderecoDeRetornoSeguro`; depois do login, vai para `voltar` ou, se não houver, para `usuaria.rotaInicial()`. O link para o outro formulário carrega o `voltar` adiante.

**Telas do painel**: `const usuaria = await exigirPerfil("lojista"); if (!usuaria) { return; }` no começo de `iniciar()`. O `<main hidden>` só aparece depois.

**lojaServico.js**: `obterMinhaLoja()` usa `usuariaAtual()` (e confere que é `Lojista`) e `.eq("dono_id", usuaria.id)`. `salvarLoja` usa `dono_id: usuaria.id`. O id fixo da lojista de teste sumiu do código e do `config.js`.

**pedidoServico.js, `criarPedidos(sacola)`**: confere que há uma usuária **logada** e que ela é uma **`Cliente`** (RN-04), que a sacola não está vazia, confere os produtos (preço, RN-06), cria os pedidos (`Pedido.criarPorLoja`) e chama **uma** função do banco: `supabase.rpc("criar_pedidos", { p_grupo_id, p_pedidos })`. O **total não vai no envio**: quem soma é o banco.

**sacola.js, `finalizar()`**: a trava `enviando`; confere quem está logada; se **ninguém** (`!usuaria`), `irParaOLogin()` (ela volta para a sacola depois); se não for cliente, avisa; senão, grava e mostra a confirmação.

**02_rls.sql**

- `sou_dono_da_loja(p_loja_id)` e `sou_dono_do_produto(p_produto_id)`: funções auxiliares `security definer` ("rodam com os direitos do dono", evitando que uma política consulte uma tabela protegida por outra política e entre em loop). `auth.uid()` é o id da usuária logada.
- `alter table ... enable row level security;`: liga a RLS. A partir daí, **tudo é negado**, e cada `create policy` **concede** uma permissão: `for select` (ler), `for insert` (inserir), `for update` (alterar), `for delete` (apagar), `to anon, authenticated` (visitantes e logadas) ou só `to authenticated`; `using (...)` é a condição para **ver ou alterar** a linha existente; `with check (...)` é a condição para a linha **nova ou alterada**.
- Resumo: `perfis`: cada uma lê e altera o próprio (e a lojista lê o nome e telefone das clientes dos pedidos dela); `lojas`: todos leem, só a dona escreve; `categorias`: todos leem, ninguém escreve; `produtos`: todos leem os **ativos**, a dona lê e escreve todos os dela; `tamanhos` e `produto_fotos`: todos leem, a dona escreve; `pedidos`: leem a cliente e a dona da loja, a dona altera, **ninguém insere** direto; `itens_pedido`: leem a cliente e a dona, ninguém escreve direto.
- **Storage**: o bucket `produtos` é criado (ou atualizado) com limite de 2 MB e só JPG, PNG e WebP; **leitura pública**; envio, alteração e exclusão só para a lojista logada **na pasta da própria loja** (`storage.foldername(name)[1]` é o id da loja, o primeiro pedaço do caminho).

**04_melhorias.sql**

- `criar_pedidos(p_grupo_id, p_pedidos)`: confere que há usuária logada e que ela é cliente; valida o formato (lista não vazia, até 20 lojas, até 100 itens por pedido, quantidade de 1 a 99); para cada pedido, na **1ª passada**, confere cada item (produto **ativo**, **da loja do pedido**, tamanho **com estoque**, e `preco_unitario` **igual ao preço atual do banco**, senão "O preço de ... mudou") e soma o total no banco; na **2ª passada**, grava o pedido (status sempre `novo`) e os itens com o **preço do banco**. É **uma transação**: se qualquer `raise exception` acontecer, **nada** é gravado. `revoke ... from public, anon` e `grant ... to authenticated` deixam só quem está logada chamar a função.
- O gatilho `proteger_e_marcar_pedido()` é refeito: além de impedir mudar valores, cliente, loja e grupo, agora **impõe o fluxo de status** (novo → confirmado ou cancelado; confirmado → concluído ou cancelado; os outros são finais, RN-05) e impede a lojista de mexer em `status_visto` e `atualizado_em` (só o banco mexe, RN-13).
- `excluir_minha_conta()`: apaga os pedidos da conta e depois a usuária; o resto some em cascata. Será usada no Dia 26.
- Os `update storage.buckets` repetem os limites de 2 MB e os 3 tipos de imagem, para valerem **também no servidor** (RN-12).

**privacidade.html e privacidade.js**: o aviso de privacidade: que dados coletamos (nome, e-mail, senha protegida pelo serviço de login, telefone opcional, tipo de conta, pedidos, dados da loja), para que usamos, quem pode ver o quê, os serviços de terceiros, por quanto tempo guardamos e como pedir a exclusão. O e-mail de contato vem do `config.js` (um lugar só) e entra com `textContent` e `href` montados por código.

## Validação

1. Visitante e cliente são **bloqueadas** nas telas do painel; a lojista entra e só vê o que é dela.
2. **CT-06:** a finalização sem login leva ao login e **volta à sacola** com os itens.
3. **CT-07:** a finalização logada grava **dois pedidos** com status `novo` e o **mesmo `grupo_id`**, e cada botão de WhatsApp traz só os itens da sua loja.
4. As 8 tabelas mostram `rowsecurity = true` (e no **Table Editor**, em português: **Editor de tabelas**, aparece **RLS enabled**); a política `dev: envio de fotos` **não existe mais**.
5. **CT-11:** os testes da lojista de outra loja devolvem `data: []` e erro de RLS no Storage. **CT-21:** o insert direto é recusado e o preço forjado é rejeitado.

**Erros comuns**

1. *Mensagem:* `permission denied for function criar_pedidos` ou `new row violates row-level security policy for table "pedidos"` ao finalizar. *Causa:* o `04_melhorias.sql` não foi rodado. *Correção:* rode o `04_melhorias.sql`.
2. *Sintoma:* o painel abre em branco ou volta para o login. *Causa:* a sessão expirou ou a conta não é lojista. *Correção:* entre de novo com uma conta de **lojista**.
3. *Sintoma:* **Minha loja** mostra "Você ainda não cadastrou a sua loja" para a Lojista Teste. *Causa:* você entrou com **outra** conta. *Correção:* entre com a conta da **Lojista Teste**.
4. *Mensagem:* `O preço de "..." mudou` ao finalizar, mesmo sem mexer. *Causa:* o preço na sacola é antigo. *Correção:* é o comportamento correto; a sacola foi atualizada: finalize de novo.
5. *Mensagem:* `new row violates row-level security policy` ao enviar foto na tela da lojista. *Causa:* a lojista não tem loja ainda, ou o caminho não usa o id da loja dela. *Correção:* cadastre a loja em **Minha loja** antes.
6. *Mensagem:* `policy "..." for table "..." already exists`. *Causa:* o script foi alterado e rodado de novo sem o `drop policy`. *Correção:* rode o `02_rls.sql` exatamente como na aula (ele apaga cada regra antes de criá-la).

**Se travar**

1. Rode as três consultas de conferência do Passo 7 e a do Passo 8: elas mostram até onde o banco foi.
2. No Console (F12) e na aba **Network** (em português: **Rede**), veja a **Response** (em português: **Resposta**) do pedido que falhou: a mensagem diz qual regra recusou.
3. Se o painel parou de funcionar logo depois do `02_rls.sql`, confirme que você fez **primeiro** os Passos 1 a 6 (código) e que está entrando com uma conta de lojista.
4. Compare os arquivos com os da aula; se algum arquivo quebrou, volte com `git restore arquivo`.
5. Só depois peça ajuda à sua equipe, colando a mensagem exata.

**Seu projeto agora tem**

- `js/ui/protecao.js` e as telas do painel protegidas por perfil; `login.js` e `cadastro.js` com o retorno para a página de origem.
- `lojaServico.js` usando a lojista logada (sem o id de teste no `config.js`); `config.js` com `EMAIL_DE_CONTATO`.
- `pedidoServico.js` e `sacola.js` gravando pelo banco, só com login de cliente.
- `privacidade.html` e `js/paginas/privacidade.js`.
- `database/02_rls.sql` e `database/04_melhorias.sql` executados: RLS nas 8 tabelas, política provisória apagada, função `criar_pedidos` e limites do bucket.

**Como saber que deu certo:** uma cliente logada finaliza uma sacola de duas lojas e o banco guarda dois pedidos com o mesmo `grupo_id`; e, pelo console, o banco **recusa** o preço forjado e a alteração de um produto de outra loja.
