# Aula 29 – Conectar o front ao Supabase com supabase-js

**Dia 10 · Ter 20/10/2026** · **Aula 29** · **UC3**

- **Requisitos cobertos:** RF-01 (listar os produtos ativos em cards; agora lendo do banco) e RF-21 (aviso claro quando a configuração ainda é de exemplo e em qualquer falha)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catalogo.js assíncrono lendo arquivos JSON; banco do Supabase com a Loja Exemplo, 3 produtos e as 8 categorias; produtoServico.js só com a validação (Aulas 27 e 28)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai ligar o site ao **Supabase**: copiar o **endereço do projeto** e a **chave pública (`anon`)**, criar os arquivos de **configuração** e de **conexão** (biblioteca por CDN), escrever os **serviços** de categorias, lojas e produtos (que devolvem dados ou lançam `ErroApp`) e mostrar no catálogo os produtos que estão no banco.

**Abertura (10 minutos).** Retomada da Aula 28: o catálogo já espera dados de verdade (de um arquivo). Hoje o "arquivo" vira o banco que você criou no Dia 9. Antes de começar, abra o painel do Supabase, o **Table Editor** (em português: **Editor de tabelas**), a tabela `produtos`, e confirme que existem 3 produtos. São eles que vão aparecer no site.

## O Conceito

**Termos desta aula**

- **supabase-js**: a biblioteca oficial que o navegador usa para falar com o Supabase (consultar tabelas, fazer login, enviar arquivos). Carregamos por **CDN** (um endereço na internet de onde o navegador baixa o código), sem instalar nada.
- **URL do projeto e chave `anon`**: o **endereço** do seu projeto (`https://abcdefgh.supabase.co`) e uma **chave pública** que identifica o seu projeto. Ela aparece no código do site e **qualquer pessoa pode vê-la**: isso é normal. Quem protege os dados são as **regras de acesso** (RLS, Dia 13).
- **Chave `service_role`**: uma chave **secreta** que dá acesso total ao banco. **Nunca**, em hipótese nenhuma, ela entra no código do site nem no GitHub.
- **Serviço**: um arquivo de `js/servicos/` que conversa com o Supabase, dentro de `try/catch`, e **devolve dados ou lança `ErroApp`** com mensagem em português. As **páginas** só chamam os serviços e mostram o resultado: nunca falam com o Supabase direto.

**Analogia:** o `config.js` é o **endereço e o crachá** do prédio; o `supabaseClient.js` é a **recepção** (um ponto único de entrada); os serviços são os **atendentes** que sabem pedir cada coisa (produtos, lojas, categorias); a página é o **cliente** que só conversa com os atendentes.

**Regra do projeto:** se o `config.js` ainda tiver os valores de exemplo, o site mostra um **aviso claro** em vez de quebrar.

## Mão na Massa

### Passo 1: copie o endereço e a chave pública do projeto

1. No painel do Supabase, abra **Project Settings** (em português: **Configurações do projeto**), e depois **API**. Em versões mais novas do painel, o caminho pode ser pelo botão **Connect** (em português: **Conectar**) no topo da página.
2. Copie o **Project URL** (em português: **URL do projeto**), algo como `https://abcdefgh.supabase.co`.
3. Copie a chave **anon / public** (em projetos novos pode aparecer como **publishable key**, em português: **chave publicável**).
4. **Não copie** a chave `service_role` (ou `secret`).

### Passo 2: o arquivo de configuração

Crie `js/config.js` com o conteúdo abaixo. **Depois de colar, troque os dois valores de exemplo** pelo **Project URL** e pela chave `anon` do **seu** projeto, mantendo as aspas.

**Arquivo: `js/config.js`** (arquivo novo, inteiro)

```js
// Configuração de conexão com o Supabase.
// Troque os dois valores abaixo pelos do SEU projeto (Project Settings > API no painel do Supabase).
//
// A chave "anon" é PÚBLICA: ela aparece no código do site e qualquer pessoa pode vê-la.
// Por isso ela não é um segredo. Quem protege os dados são as regras RLS do banco (database/02_rls.sql).
// NUNCA coloque aqui a chave "service_role" (ou "secret"): ela dá acesso total ao banco.
//
// Enquanto estes valores forem os de exemplo, o site mostra um aviso em vez de tentar conectar.
export const SUPABASE_URL = "https://SEU-PROJETO.supabase.co";
export const SUPABASE_ANON_KEY = "SUA-CHAVE-ANON-AQUI";
```


### Passo 3: o arquivo de conexão

Crie `js/supabaseClient.js`:

**Arquivo: `js/supabaseClient.js`** (arquivo novo, inteiro)

```js
// Cria o cliente do Supabase, que é quem conversa com o banco, o login e o Storage.
// Os serviços (js/servicos/) usam este arquivo; as páginas nunca falam com o Supabase direto.
import { SUPABASE_URL, SUPABASE_ANON_KEY } from "./config.js";
import { ErroApp } from "./modelos/ErroApp.js";

const ENDERECO_DA_BIBLIOTECA = "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";

// true enquanto o config.js ainda tiver os valores de exemplo (ou estiver vazio)
export const configuracaoDeExemplo = [SUPABASE_URL, SUPABASE_ANON_KEY].some(
  (valor) =>
    typeof valor !== "string" ||
    valor.trim() === "" ||
    valor.includes("SEU-PROJETO") ||
    valor.includes("SUA-CHAVE")
);

// Fica null se a configuração for de exemplo ou se a biblioteca não puder ser carregada.
let cliente = null;

if (!configuracaoDeExemplo) {
  try {
    // import() dinâmico, e não "import ... from" no topo: se a CDN estiver fora do ar ou sem internet,
    // o erro cai neste try/catch e a página consegue mostrar uma mensagem, em vez de ficar em branco (RF-21).
    const { createClient } = await import(ENDERECO_DA_BIBLIOTECA);
    cliente = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  } catch (erro) {
    console.error("Não foi possível carregar a biblioteca do Supabase.", erro);
  }
}

export const supabase = cliente;

// Usada pelos serviços: devolve o cliente, ou lança um ErroApp que explica por que não existe.
export function exigirSupabase() {
  if (configuracaoDeExemplo) {
    throw new ErroApp(
      "configuracao_de_exemplo",
      "O sistema ainda não está conectado ao banco de dados. Preencha a URL e a chave do Supabase no arquivo js/config.js."
    );
  }
  if (!supabase) {
    throw new ErroApp(
      "supabase_indisponivel",
      "Não foi possível carregar o sistema de dados. Verifique sua conexão com a internet e recarregue a página."
    );
  }
  return supabase;
}
```


### Passo 4: os serviços

Crie `js/servicos/categoriaServico.js`:

**Arquivo: `js/servicos/categoriaServico.js`** (arquivo novo, inteiro)

```js
// Fala com o banco sobre categorias (tipos de roupa). Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";

// Devolve [{ id, nome }]. Ordenado pelo id, que é a ordem em que o 03_seed.sql criou as categorias.
export async function listarCategorias() {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("categorias").select("id, nome").order("id");

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    // Um ErroApp já tem mensagem pronta; qualquer outro erro vira um ErroApp em português
    throw erro instanceof ErroApp
      ? erro
      : new ErroApp(
          "erro_ao_listar_categorias",
          "Não foi possível carregar as categorias. Verifique sua conexão e tente novamente.",
          erro
        );
  }
}
```


Crie `js/servicos/lojaServico.js`:

**Arquivo: `js/servicos/lojaServico.js`** (arquivo novo, inteiro)

```js
// Fala com o banco sobre lojas. Devolve dados ou lança ErroApp.
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";

// Devolve [{ id, nome }], em ordem alfabética. Usada no filtro de lojas do catálogo.
export async function listarLojas() {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase.from("lojas").select("id, nome").order("nome");

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    throw erro instanceof ErroApp
      ? erro
      : new ErroApp(
          "erro_ao_listar_lojas",
          "Não foi possível carregar as lojas. Verifique sua conexão e tente novamente.",
          erro
        );
  }
}
```


No `js/servicos/produtoServico.js` (que hoje só tem a validação), troque o **começo do arquivo** (os dois comentários do topo) pelas importações e as constantes:

**Arquivo: `js/servicos/produtoServico.js`**: substitua o começo do arquivo, até a linha `// (Na Aula 21 o arquivo só tem as regras de validação do formulário; as consultas ao banco chegam a partir da Aula 29.)` (inclusive) por:

```js
// Fala com o banco sobre produtos. Devolve as linhas do banco ou lança ErroApp.
// Transformar as linhas em objetos Produto é trabalho da página (veja catalogo.js).
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";

// Colunas do produto e das tabelas relacionadas. Em "categorias ( id, nome )" o Supabase junta,
// em uma só consulta, a categoria do produto (é só uma, então vem como objeto).
const CAMPOS_DO_PRODUTO = "id, nome, descricao, preco, ativo, loja_id, categoria_id, categorias ( id, nome ), lojas ( id, nome )";
const CAMPOS_DAS_FOTOS = "produto_fotos ( id, url, ordem )";
```


E cole a função que lista os produtos **logo antes do bloco de comentário** que começa com `// ====...` (o que fala do "Painel da lojista"):

**Arquivo: `js/servicos/produtoServico.js`**: adicione este trecho logo antes da linha `// =====================================================================`:

```js
// Lista TODOS os produtos ativos (RN-08), cada um com a categoria, a loja, os tamanhos e as fotos já em ordem (a primeira é a capa, RN-12).
// Na Aula 30 esta função ganha filtros e páginas.
export async function listarProdutosAtivos() {
  try {
    const supabase = exigirSupabase();
    const { data, error } = await supabase
      .from("produtos")
      .select(CAMPOS_DO_PRODUTO + ", tamanhos ( tamanho, estoque ), " + CAMPOS_DAS_FOTOS)
      // RN-08: produto inativo não aparece
      .eq("ativo", true)
      .order("nome")
      .order("ordem", { referencedTable: "produto_fotos", ascending: true });

    if (error) {
      throw error;
    }
    return data;
  } catch (erro) {
    // Um ErroApp já tem mensagem pronta; qualquer outro erro vira um ErroApp em português
    throw erro instanceof ErroApp
      ? erro
      : new ErroApp(
          "erro_ao_listar_produtos",
          "Não foi possível carregar os produtos. Verifique sua conexão e tente novamente.",
          erro
        );
  }
}

```


### Passo 5: o Produto aprende a ler uma linha do banco

No `js/modelos/Produto.js`, cole o método estático `deLinha` **logo antes do comentário** `// ---------- Leitura ----------`:

**Arquivo: `js/modelos/Produto.js`**: adicione este trecho logo antes da linha `// ---------- Leitura ----------`:

```js
  // Monta um Produto a partir de uma linha do banco (colunas em snake_case, com as tabelas relacionadas dentro).
  // As fotos são ordenadas pela coluna "ordem": a de menor ordem é a capa (RN-12).
  static deLinha(linha) {
    const fotosEmOrdem = [...(linha.produto_fotos ?? [])].sort((a, b) => a.ordem - b.ordem);

    return new Produto({
      id: linha.id,
      nome: linha.nome,
      descricao: linha.descricao ?? "",
      preco: linha.preco,
      categoria: linha.categorias?.nome ?? "",
      lojaId: linha.loja_id,
      lojaNome: linha.lojas?.nome ?? "",
      ativo: linha.ativo,
      tamanhos: linha.tamanhos ?? [],
      fotos: fotosEmOrdem.map((foto) => foto.url),
    });
  }

```


### Passo 6: o catálogo lê do banco

No `js/paginas/catalogo.js`, faça as trocas na ordem. (1) As importações:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `import { ErroApp } from "../modelos/ErroApp.js";` e termina na linha `import { Loja } from "../modelos/Loja.js";` (inclusive) por:

```js
import { Produto } from "../modelos/Produto.js";
import { listarProdutosAtivos } from "../servicos/produtoServico.js";
import { listarLojas } from "../servicos/lojaServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";
```


(2) Os dados fictícios de lojas e categorias saem, e a página passa a guardar os produtos do banco:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `// Dados fictícios das lojas e dos tipos de roupa (na Aula 29 eles passam a vir do banco)` e termina na linha `const categoriasFicticias = ["Blusas", "Camisetas", "Vestidos", "Calças", "Saias", "Shorts", "Jaquetas", "Acessórios"];` (inclusive) por:

```js
// Os produtos que vieram do banco, já como objetos Produto
let produtos = [];
```


(3) Troque a função `atualizarCatalogo` (a consulta ao banco já traz só os produtos ativos):

**Arquivo: `js/paginas/catalogo.js`**: substitua a função `atualizarCatalogo` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Aplica os filtros atuais e redesenha a lista (a consulta ao banco já traz só os produtos ativos, RN-08)
function atualizarCatalogo() {
  mostrarProdutos(filtrarProdutos(produtos, filtros));
}
```


(4) As categorias agora são objetos (`{ id, nome }`), então troque estas duas linhas dentro de `preencherCategorias`:

**Arquivo: `js/paginas/catalogo.js`**: substitua o trecho que começa na linha `chip.textContent = categoria;` e termina na linha `chip.addEventListener("click", () => escolherCategoria(chip, categoria));` (inclusive) por:

```js
    chip.textContent = categoria.nome;
    chip.addEventListener("click", () => escolherCategoria(chip, categoria.nome));
```


(5) Apague a função que lia os arquivos JSON e troque `iniciar`:

**Arquivo: `js/paginas/catalogo.js`**: apague a função `carregarLojasDoArquivo` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


**Arquivo: `js/paginas/catalogo.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  try {
    // As três consultas não dependem uma da outra, então rodam ao mesmo tempo
    const [categorias, lojas, linhas] = await Promise.all([listarCategorias(), listarLojas(), listarProdutosAtivos()]);

    produtos = linhas.map(Produto.deLinha);
    preencherCategorias(categorias);
    preencherLojas(lojas);
    configurarFiltros();
    atualizarCatalogo();
    limparAvisos();
  } catch (erro) {
    // Falha de conexão, configuração de exemplo ou erro inesperado: mensagem em português em vez de tela em branco (RF-21)
    registrarErro(erro);
    mostrarErro(mensagemDoErro(erro));
  }
}
```


### Passo 7: apague os arquivos de exemplo e teste

Os arquivos JSON provisórios não são mais necessários. Apague:

**Apague** o arquivo `dados-de-exemplo/lojas.json`.


**Apague** o arquivo `dados-de-exemplo/produtos.json`.


Agora teste em duas etapas:

1. **Antes de trocar os valores de exemplo** (se você ainda não os trocou no Passo 2): abra o catálogo. Aparece uma caixa vermelha: **O sistema ainda não está conectado ao banco de dados. Preencha a URL e a chave do Supabase no arquivo js/config.js.** É o aviso claro do RF-21.
2. **Depois de preencher** o `js/config.js` com os valores do seu projeto: recarregue. Devem aparecer os **3 produtos de exemplo** (Calça jeans reta, Camiseta básica branca e Vestido midi floral), as **8 categorias** como chips, a **Loja Exemplo** na lista de lojas, e os filtros continuam funcionando.

### Passo 8: faça o commit da aula

```bash
git add .
git commit -m "Conecta o catálogo ao Supabase com supabase-js"
git push
```

## Explicação do Código

**config.js**

- `export const SUPABASE_URL` e `SUPABASE_ANON_KEY`: as duas informações do projeto, exportadas para outros arquivos. Os comentários lembram que a chave `anon` é pública e que a `service_role` **nunca** entra aqui.

**supabaseClient.js**

- `configuracaoDeExemplo`: um valor `true` ou `false` calculado com `.some(...)`: é `true` se a URL ou a chave estiverem vazias ou ainda contiverem `SEU-PROJETO` ou `SUA-CHAVE`.
- `await import(ENDERECO_DA_BIBLIOTECA)`: um `import()` **dinâmico**: carrega a biblioteca da CDN (`https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm`) durante a execução, dentro de um `try/catch`. Se a CDN estiver fora do ar ou sem internet, o erro cai no `catch` e a página consegue **mostrar uma mensagem** em vez de ficar em branco (RF-21). O `await` solto no topo do arquivo é permitido em módulos.
- `createClient(SUPABASE_URL, SUPABASE_ANON_KEY)`: cria o "cliente": o objeto que fala com o Supabase.
- `exigirSupabase()`: devolve o cliente, **ou lança `ErroApp`** com a mensagem certa (configuração de exemplo, ou biblioteca indisponível). Todo serviço começa chamando esta função.

**categoriaServico.js e lojaServico.js**

- `listarCategorias()`: `supabase.from("categorias").select("id, nome").order("id")`: lê as colunas `id` e `nome` da tabela `categorias`, em ordem. O resultado vem como `{ data, error }`: se `error` existir, `throw error`. O `catch` converte qualquer erro em um `ErroApp` com mensagem em português (um `ErroApp` já pronto passa direto). `listarLojas()` é igual, para `lojas` e ordenada por nome.

**produtoServico.js**

- `CAMPOS_DO_PRODUTO`: o texto do `select` com as colunas do produto **e das tabelas ligadas**: `categorias ( id, nome )` e `lojas ( id, nome )` fazem o Supabase juntar, **em uma só consulta**, a categoria e a loja (o equivalente a um `JOIN`).
- `listarProdutosAtivos()`: `.select(CAMPOS_DO_PRODUTO + ", tamanhos ( tamanho, estoque ), " + CAMPOS_DAS_FOTOS)` pede o produto e suas listas de tamanhos e fotos; `.eq("ativo", true)` traz só os ativos (RN-08); `.order("nome")` e `.order("ordem", { referencedTable: "produto_fotos" })` ordenam os produtos por nome e as fotos pela ordem (a primeira é a capa).

**Produto.deLinha(linha)**: `static` (pertence à classe): recebe a linha do banco (colunas em `snake_case`, com tabelas dentro) e devolve um `Produto`, ordenando as fotos pela coluna `ordem`, pegando o nome da categoria e da loja de dentro dos objetos ligados e passando por todas as regras da classe.

**catalogo.js**

- `await Promise.all([listarCategorias(), listarLojas(), listarProdutosAtivos()])`: as três consultas **ao mesmo tempo**. `linhas.map(Produto.deLinha)` transforma as linhas do banco em objetos `Produto`.
- Em caso de falha, o `catch` mostra a mensagem em português: configuração de exemplo, sem internet, tabela inexistente...
- O filtro ainda roda **no navegador**, sobre a lista que já chegou; na próxima aula ele passa a ser feito **na consulta ao banco**.

## Validação

1. Com os valores de exemplo no `config.js`, o catálogo mostra o aviso para preencher o arquivo.
2. Com os valores certos, o catálogo mostra os 3 produtos do banco, as 8 categorias e a Loja Exemplo.
3. Os filtros continuam funcionando.
4. Nenhum arquivo do projeto contém a chave `service_role`: use Ctrl+Shift+F (Cmd+Shift+F no Mac) e procure `service_role` e `secret`: **0 resultados** no código (só pode haver o comentário do `config.js`, que **não** é uma chave).
5. A pasta `dados-de-exemplo` não existe mais.

**Erros comuns**

1. *Mensagem:* `Invalid API key` ou `No API key found in request`. *Causa:* a chave colada está errada ou incompleta. *Correção:* copie de novo a chave `anon` / `public` inteira (ela é longa, com pontos), sem espaços nem quebras de linha.
2. *Mensagem:* `Failed to fetch` na aba **Network** (em português: **Rede**). *Causa:* a URL está errada (erro de digitação) ou o projeto está pausado. *Correção:* confira a URL e, no painel do Supabase, se o projeto está ativo (um botão **Restore project**, em português: **Restaurar projeto**, aparece se estiver pausado).
3. *Sintoma:* o catálogo mostra "Não foi possível carregar os produtos". *Causa:* o banco está sem os produtos de exemplo, ou a tabela tem outro nome. *Correção:* confira as tabelas no **Table Editor** (em português: **Editor de tabelas**) e repita a Aula 27.
4. *Mensagem:* `permission denied` ou `new row violates row-level security policy`. *Causa:* a RLS foi ligada por engano. *Correção:* até o Dia 13 ela deve ficar **desligada**; no **Table Editor**, a tabela deve mostrar **RLS disabled**.

**Se travar**

1. Abra o Console (F12) e a aba **Network** (em português: **Rede**) e filtre por `supabase`: o status e a resposta de cada pedido mostram o erro.
2. Compare o `config.js` com o do Passo 2, só trocando os dois valores.
3. Se algo quebrou, volte ao último commit com `git restore arquivo` e refaça o passo.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata (**sem** colar a chave).

**Seu projeto agora tem**

- `js/config.js`, `js/supabaseClient.js`, `js/servicos/categoriaServico.js`, `lojaServico.js` (com `listarLojas`) e `produtoServico.js` (com `listarProdutosAtivos` e a validação).
- `Produto.deLinha`, e um `catalogo.js` que lê produtos, categorias e lojas **do banco**.
- Os arquivos JSON de exemplo foram apagados.

**Como saber que deu certo:** você troca o preço de um produto no **Table Editor** (em português: **Editor de tabelas**) do Supabase, recarrega o catálogo e o novo preço aparece.
