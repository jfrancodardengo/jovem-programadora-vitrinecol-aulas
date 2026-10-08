# Aula 28 – JavaScript assíncrono: promises, async/await e fetch

**Dia 10 · Ter 20/10/2026** · **Aula 28** · **UC3**

- **Requisitos cobertos:** RF-21 (mostrar "Carregando…" enquanto os dados não chegam e uma mensagem clara quando falham)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catalogo.js com dados fictícios dentro do código, filtros, agregação loja-produtos e tratamento de erros; banco do Supabase populado (Aulas 24 a 27)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai entender por que o navegador **não espera** certas tarefas, usar **`async`/`await`** e **`fetch`** com `try/catch` e `Promise.all`, e fazer o catálogo buscar os dados de **arquivos JSON**, mostrando "Carregando…" e o erro.

**Abertura (10 minutos).** Retomada da Aula 24: o `setTimeout(..., 600)` do catálogo **finge** a espera pelos dados, que na vida real vêm de um servidor e demoram um tempo imprevisível (e às vezes falham). Se o código simplesmente seguisse adiante, tentaria desenhar os produtos **antes** de eles chegarem. Hoje ensinamos o JavaScript a **esperar de verdade**, sem travar a página.

## O Conceito

**Termos desta aula**

- **Assíncrono**: algo que **demora** e termina depois (buscar dados na internet). Enquanto espera, o navegador continua a mexer na página; quando a resposta chega, ele volta ao ponto onde parou.
- **Promise (promessa)**: um objeto que representa "um resultado que ainda vai chegar". Ela pode terminar bem (**resolvida**) ou mal (**rejeitada**).
- **`async` e `await`**: `async function` declara uma função que pode esperar; `await` **pausa essa função** até a promessa terminar e entrega o resultado. É uma forma simples de escrever código que espera, lendo de cima para baixo.
- **`fetch`**: função do navegador que busca um endereço (um arquivo, uma página, uma API) e devolve uma promessa com a resposta. **JSON** é um formato de texto para guardar dados, muito parecido com os objetos do JavaScript.

**Analogia:** é como pedir uma pizza. Você faz o pedido (`fetch`), e a pizzaria dá um **comprovante** (a promise): "vai chegar". Você não fica parado na porta: arruma a mesa. Quando a pizza chega (resolvida), você come. Se a pizzaria avisa que acabou o forno (rejeitada), você decide o que fazer. O `await` é ficar na porta **só dentro desta tarefa**, enquanto o resto da casa continua funcionando.

**`Promise.all`**: pede **várias** pizzas ao mesmo tempo e só continua quando **todas** chegarem (ou falha se uma falhar). É mais rápido do que pedir uma depois da outra.

## Mão na Massa

### Passo 1: crie os arquivos de dados de exemplo

Crie a pasta `dados-de-exemplo` na raiz do projeto. Esta pasta é **provisória** (você a apaga na próxima aula). Crie `lojas.json`:

**Arquivo: `dados-de-exemplo/lojas.json`** (arquivo novo, inteiro)

```json
[
  {
    "id": "l1",
    "nome": "Loja Exemplo",
    "descricao": "Moda feminina casual e confortável",
    "endereco": "Rua das Flores, 100, Centro",
    "cidade": "Cidade Exemplo",
    "whatsapp": "5527999999999"
  },
  {
    "id": "l2",
    "nome": "Loja do Bairro",
    "endereco": "Avenida Central, 250",
    "cidade": "Cidade Exemplo",
    "whatsapp": "5527988888888"
  }
]
```


Os produtos são mais longos, então estão em um **material**: o arquivo é criado a partir dele.

**Material:** `docs/guia-aulas/materiais/dados-de-exemplo-produtos.json` (150 linhas). Abra esse arquivo, selecione tudo (Ctrl+A no Windows, Cmd+A no Mac), copie (Ctrl+C / Cmd+C) e cole tudo em um arquivo novo chamado `dados-de-exemplo/produtos.json`.


### Passo 2: o catálogo passa a buscar os arquivos

No `js/paginas/catalogo.js`, faça as trocas na ordem. (1) Importe o `ErroApp` (o catálogo vai lançar um erro se o arquivo não for encontrado):

**Arquivo: `js/paginas/catalogo.js`**: substitua a linha `import { criarCardProduto } from "../ui/cards.js";` por:

```js
import { criarCardProduto } from "../ui/cards.js";
import { ErroApp } from "../modelos/ErroApp.js";
```


(2) Os produtos fictícios saem do código (agora vêm do arquivo JSON):

**Arquivo: `js/paginas/catalogo.js`**: apague a constante `produtosFicticios` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


(3) A função antiga de criar os dados dá lugar à que **busca** os arquivos:

**Arquivo: `js/paginas/catalogo.js`**: apague a função `carregarLojasFicticias` inteira (do comentário que fica acima dela até a chave `}` que a fecha).


**Arquivo: `js/paginas/catalogo.js`**: adicione esta função (`carregarLojasDoArquivo`) logo antes da função `iniciar` (junto com os comentários que ficam acima dela):

```js
// Lê os dois arquivos JSON ao mesmo tempo (Promise.all) e monta as lojas já com os seus produtos.
// fetch devolve uma promessa: o navegador não fica parado esperando, e o await só pausa ESTA função até a resposta chegar.
async function carregarLojasDoArquivo() {
  const [respostaLojas, respostaProdutos] = await Promise.all([
    fetch("dados-de-exemplo/lojas.json"),
    fetch("dados-de-exemplo/produtos.json"),
  ]);

  // fetch NÃO dá erro quando o arquivo não existe (404): é preciso conferir o .ok
  if (!respostaLojas.ok || !respostaProdutos.ok) {
    throw new ErroApp("arquivo_nao_encontrado", "Não foi possível carregar os dados de exemplo.");
  }

  const dadosDasLojas = await respostaLojas.json();
  const dadosDosProdutos = await respostaProdutos.json();

  const lojasCriadas = dadosDasLojas.map((dados) => new Loja(dados));
  dadosDosProdutos.forEach((dados) => {
    const loja = lojasCriadas.find((outra) => outra.id === dados.lojaId);
    loja.adicionarProduto(new Produto(dados));
  });

  return lojasCriadas;
}
```


(4) Troque a função `iniciar` pela versão assíncrona:

**Arquivo: `js/paginas/catalogo.js`**: substitua a função `iniciar` inteira (do comentário acima dela até a chave que a fecha) por:

```js
async function iniciar() {
  montarCabecalho();
  mostrarCarregando();

  try {
    lojas = await carregarLojasDoArquivo();
    preencherCategorias(categoriasFicticias);
    preencherLojas(lojas);
    configurarFiltros();
    atualizarCatalogo();
    limparAvisos();
  } catch (erro) {
    // Um dado inválido (ErroApp), uma falha de conexão ou um erro inesperado: mensagem em português em vez de tela em branco (RF-21)
    registrarErro(erro);
    mostrarErro(mensagemDoErro(erro));
  }
}
```


### Passo 3: veja o carregamento e o erro

1. Abra o catálogo pelo Live Server: ele deve funcionar como antes, mas agora os dados vêm dos arquivos JSON.
2. **Veja o "Carregando…" de verdade:** aperte F12, abra a aba **Network** (em português: **Rede**) e, na lista que diz **No throttling** (em português: **Sem limitação**), escolha **Slow 3G** (em português: **3G lento**; o nome pode variar). Recarregue (F5): o aviso azul **Carregando…** fica visível por mais tempo, até os arquivos chegarem. Volte para **No throttling**.
3. **Provoque um erro 404:** troque `dados-de-exemplo/lojas.json` por `dados-de-exemplo/loja.json` no código. Recarregue: a caixa vermelha mostra **Não foi possível carregar os dados de exemplo.** Desfaça.
4. **Provoque uma falha de conexão:** na aba **Network** (em português: **Rede**), mude **No throttling** para **Offline** (em português: **Offline**) e recarregue: aparece a mensagem de erro em português, sem tela em branco. Volte para **No throttling**.

### Passo 4: faça o commit da aula

```bash
git add .
git commit -m "Busca os dados de exemplo em arquivos JSON com fetch e async/await"
git push
```

## Explicação do Código

- `async function carregarLojasDoArquivo() { ... }`: a palavra **`async`** avisa que dentro da função existe `await` e que ela **devolve uma promessa** (quem a chamar também precisa usar `await`).
- `await Promise.all([ fetch(...), fetch(...) ])`: dispara os dois pedidos **ao mesmo tempo** e espera os dois chegarem. O resultado é uma lista com as duas respostas, que `const [respostaLojas, respostaProdutos] = ...` "desmonta" em duas variáveis.
- `if (!respostaLojas.ok || !respostaProdutos.ok) { throw new ErroApp(...); }`: o `fetch` **não** dá erro quando o arquivo não existe; ele devolve uma resposta com `ok = false` (por exemplo, erro 404). Por isso conferimos `.ok` e lançamos o nosso `ErroApp`. Já uma **falha de conexão** (sem internet) faz o `fetch` rejeitar a promessa por conta própria.
- `await respostaLojas.json()`: lê o corpo da resposta e o converte de texto JSON em objetos JavaScript (também é assíncrono, por isso o `await`).
- `dadosDasLojas.map((dados) => new Loja(dados))`: cada objeto do JSON vira uma `Loja`. O JSON tem os mesmos campos que os objetos fictícios da Aula 17, então as classes funcionam sem mudança.
- `async function iniciar()`: com `try { lojas = await carregarLojasDoArquivo(); ... } catch (erro) { ... }`, o `await` **pausa** `iniciar` até os dados chegarem; se a promessa for rejeitada (ou se um `throw` acontecer), o fluxo cai no `catch`, que registra o detalhe e mostra a mensagem. Antes do `await`, `mostrarCarregando()` já pôs o aviso na tela: isso cumpre o **RF-21**.
- O `setTimeout` que **fingia** a espera saiu: a espera agora é real.
- **JSON**: repare que as chaves e os textos usam aspas duplas (`"nome": "Loja Exemplo"`), e que **não pode haver vírgula depois do último item**. O JSON é mais rígido que um objeto JavaScript.

## Validação

1. O catálogo mostra os 6 produtos vindos dos arquivos JSON.
2. Com **Slow 3G** (em português: **3G lento**) o aviso **Carregando…** fica visível por mais tempo.
3. Com o nome do arquivo errado aparece **Não foi possível carregar os dados de exemplo.**
4. Com **Offline** aparece uma mensagem em português; nunca uma tela em branco.

**Erros comuns**

1. *Mensagem:* `Uncaught SyntaxError: Unexpected token ... in JSON at position ...`. *Causa:* o arquivo JSON tem um erro (vírgula sobrando, aspa simples, comentário). *Correção:* JSON só aceita aspas duplas e não tem comentários nem vírgula depois do último item.
2. *Sintoma:* os produtos não aparecem e não há erro. *Causa:* esqueceu o `await` (a promessa é usada antes de terminar). *Correção:* use `await` na frente de `fetch(...)`, de `Promise.all(...)` e de `.json()`.
3. *Mensagem:* `await is only valid in async functions`. *Causa:* a função que usa `await` não é `async`. *Correção:* escreva `async function ...`.
4. *Mensagem:* `Failed to fetch` ou erro 404 no Console. *Causa:* o caminho do arquivo está errado, ou a página foi aberta sem o Live Server. *Correção:* o caminho é `dados-de-exemplo/lojas.json` e a página precisa estar em `http://127.0.0.1:5500`.

**Se travar**

1. Na aba **Network** (em português: **Rede**) do F12, veja se os arquivos `.json` aparecem com status 200 (verde) ou 404 (vermelho).
2. Clique no arquivo na aba **Network** e veja a aba **Response** (em português: **Resposta**) para conferir o conteúdo.
3. Compare o código com o da aula; se preciso, volte com `git restore js/paginas/catalogo.js`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `dados-de-exemplo/lojas.json` e `produtos.json` (provisórios).
- `catalogo.js` assíncrono, com "Carregando…", erro e `Promise.all`.

**Como saber que deu certo:** com a rede lenta você vê **Carregando…** e depois os produtos; com o arquivo errado você vê a mensagem de erro em português.
