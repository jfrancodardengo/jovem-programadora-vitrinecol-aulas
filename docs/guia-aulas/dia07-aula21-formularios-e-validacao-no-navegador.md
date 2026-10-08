# Aula 21 – Formulários e validação no navegador

**Dia 7 · Qui 15/10/2026** · **Aula 21** · **UC3**

- **Requisitos cobertos:** RN-02 (o preço deve ser maior que zero, o estoque não pode ser negativo e a quantidade mínima de um item é 1), RN-10 (o telefone tem só dígitos, com código do país e DDD) e RF-21 (avisar erros, sem deixar a tela em branco)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catalogo.js com filtros fictícios; avisos.js, cabecalho.js, elementos.js e formatadores.js; painel-produto-form.html estático com uma linha de tamanho (Aulas 15 a 20)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai tratar o envio de um formulário com o evento **`submit`** e **`preventDefault`**, validar os campos e mostrar a **mensagem de erro ao lado de cada campo** (ligada ao campo para leitores de tela), com as regras de preço, estoque e telefone **escritas uma única vez**.

**Abertura (10 minutos).** Retomada da Aula 20: o catálogo filtra os produtos fictícios. O formulário de cadastro de produto do painel da lojista (`painel-produto-form.html`) é só HTML: se você clicar em **Salvar produto**, o navegador tenta enviá-lo e recarrega a página. Hoje o formulário passa a **conferir os dados** antes. Pense: o que a lojista pode digitar errado? (nome vazio, preço zero, estoque negativo, tamanho repetido...).

## O Conceito

**Termos desta aula**

- **Validação**: conferir se o que a pessoa digitou serve, **antes** de usar. Uma regra de negócio como "preço maior que zero" (RN-02) é uma validação.
- **`submit` e `preventDefault()`**: `submit` é o evento disparado ao enviar o formulário; o comportamento padrão do navegador é recarregar a página. **`evento.preventDefault()`** cancela esse comportamento, para o nosso código decidir o que fazer.
- **`aria-invalid` e `aria-describedby`**: atributos que ligam o **campo** à sua **mensagem de erro**. O leitor de tela lê "Preço, campo inválido: O preço deve ser maior que zero".
- **Regra escrita uma única vez**: cada regra vive em **um** lugar, e todo mundo a usa. Se a regra mudar, muda em um só arquivo.

**Analogia:** o formulário é o balcão de uma agência de correios. Antes de aceitar a encomenda, o atendente confere cada item da lista (endereço, CEP, peso) e, se algo estiver errado, aponta **exatamente onde** ("falta o CEP"), em vez de só dizer "tem um erro".

**Regras do projeto desta aula**

- RN-02: preço maior que zero; estoque inteiro e maior ou igual a zero (a quantidade mínima de um item, 1, é conferida na sacola, na Aula 35).
- RN-10: telefone **só com dígitos**, com código do país e DDD, 12 ou 13 dígitos (por exemplo `5527999999999`). A pessoa digita com máscara (`27 99999-9999`) e o sistema ajeita.

## Mão na Massa

### Passo 1: as regras de telefone (uma única vez)

No `js/ui/formatadores.js`, acrescente duas funções **no final do arquivo**: a que limpa o telefone e a que confere se ele é válido.

**Arquivo: `js/ui/formatadores.js`**: adicione esta função (`normalizarTelefone`) no final do arquivo:

```js
// Deixa só os dígitos de um telefone e, se faltar o código do país, acrescenta o 55 (RN-10).
// "(27) 99999-9999" -> "5527999999999"; "27 3333-4444" -> "552733334444"; "5527999999999" continua igual.
// Com 10 ou 11 dígitos (DDD + número) falta o código do país; com 12 ou 13 já está completo.
// Texto vazio devolve "". A validação (12 ou 13 dígitos) fica por conta de quem chama.
export function normalizarTelefone(texto) {
  const digitos = String(texto ?? "").replace(/\D/g, "");
  return digitos.length === 10 || digitos.length === 11 ? "55" + digitos : digitos;
}
```


**Arquivo: `js/ui/formatadores.js`**: adicione esta função (`telefoneValido`) no final do arquivo:

```js
// RN-10: um telefone válido tem só dígitos, com código do país e DDD (12 ou 13 dígitos). Única regra do projeto para isso.
export function telefoneValido(digitos) {
  return /^\d{12,13}$/.test(String(digitos ?? ""));
}
```


### Passo 2: os erros ao lado dos campos (JavaScript e CSS)

No `js/ui/avisos.js`, cole **no final do arquivo** as funções que mostram e apagam a mensagem de erro de um campo:

**Arquivo: `js/ui/avisos.js`**: adicione este trecho no final do arquivo:

```js
// ---------- Erros ao lado de cada campo de formulário ----------

// Mostra a mensagem logo abaixo do campo e liga a mensagem ao campo (aria-describedby),
// para o leitor de tela ler o erro junto com o nome do campo.
export function mostrarErroDoCampo(campo, mensagem) {
  const idDoErro = "erro-" + campo.id;
  let erro = document.getElementById(idDoErro);

  if (!erro) {
    erro = document.createElement("p");
    erro.id = idDoErro;
    erro.className = "campo-erro";
    campo.closest(".campo").append(erro);
  }
  erro.textContent = mensagem;

  campo.setAttribute("aria-invalid", "true");
  const descricoes = (campo.getAttribute("aria-describedby") ?? "").split(" ").filter(Boolean);
  if (!descricoes.includes(idDoErro)) {
    descricoes.push(idDoErro);
    campo.setAttribute("aria-describedby", descricoes.join(" "));
  }
}

// Apaga todas as mensagens de erro de campo do formulário (chamar antes de validar de novo).
export function limparErrosDosCampos(formulario) {
  formulario.querySelectorAll(".campo-erro").forEach((erro) => erro.remove());

  formulario.querySelectorAll("[aria-invalid]").forEach((campo) => {
    campo.removeAttribute("aria-invalid");

    // Tira só o que era do erro; as dicas fixas (ex.: "Use pelo menos 6 caracteres") continuam
    const restantes = (campo.getAttribute("aria-describedby") ?? "")
      .split(" ")
      .filter((id) => id && !id.startsWith("erro-"));
    if (restantes.length > 0) {
      campo.setAttribute("aria-describedby", restantes.join(" "));
    } else {
      campo.removeAttribute("aria-describedby");
    }
  });
}

// Apaga a mensagem de erro de um campo só (os outros erros continuam na tela).
export function limparErroDoCampo(campo) {
  const idDoErro = "erro-" + campo.id;
  document.getElementById(idDoErro)?.remove();
  campo.removeAttribute("aria-invalid");

  const restantes = (campo.getAttribute("aria-describedby") ?? "").split(" ").filter((id) => id && id !== idDoErro);
  if (restantes.length > 0) {
    campo.setAttribute("aria-describedby", restantes.join(" "));
  } else {
    campo.removeAttribute("aria-describedby");
  }
}
```


No `css/componentes.css`, cole **no final do arquivo**:

**Arquivo: `css/componentes.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Erro ao lado de um campo de formulário ---------- */
.campo-erro {
  margin: 0;
  font-size: var(--tamanho-pequeno);
  font-weight: 600;
  color: var(--cor-erro);
}

.campo input[aria-invalid="true"],
.campo select[aria-invalid="true"],
.campo textarea[aria-invalid="true"] {
  border-color: var(--cor-erro);
}
```


### Passo 3: as regras do produto (uma única vez)

Crie as pastas `js/servicos`. Dentro dela crie `produtoServico.js`. Por enquanto ele só guarda a validação (as consultas ao banco chegam na Aula 29):

**Arquivo: `js/servicos/produtoServico.js`** (arquivo novo, inteiro)

```js
// Fala com o banco sobre produtos. Devolve as linhas do banco ou lança ErroApp.
// (Na Aula 21 o arquivo só tem as regras de validação do formulário; as consultas ao banco chegam a partir da Aula 29.)

// =====================================================================
// Painel da lojista (RF-16 a RF-19): cadastrar, editar, ativar/desativar e excluir produtos.
// A lojista só consegue mexer nos produtos da própria loja: quem garante isso são as regras RLS (RN-09);
// quando o banco recusa, o erro volta como "permissao_negada" ou "produto_nao_encontrado".
// =====================================================================

// "p", " p " e "P" são o mesmo tamanho
function normalizarTamanho(tamanho) {
  return String(tamanho ?? "").trim().toUpperCase();
}

// Aceita "129.9" e "129,90"
function converterPreco(preco) {
  return Number(String(preco ?? "").replace(",", "."));
}

// Valida o formulário do produto. Devolve { campo: "mensagem" } (vazio quando está tudo certo).
// Chaves: nome, categoriaId, preco, tamanhos e, para cada linha de tamanho, "tamanho-0", "estoque-0", "tamanho-1"...
// A tela mostra cada mensagem ao lado do campo; criarProduto e atualizarProduto validam de novo antes de gravar.
export function validarProduto({ nome, categoriaId, preco, tamanhos = [] }) {
  const erros = {};

  if (String(nome ?? "").trim() === "") {
    erros.nome = "Informe o nome do produto.";
  }
  if (!categoriaId) {
    erros.categoriaId = "Escolha a categoria.";
  }

  // RN-02: o preço deve ser maior que zero
  const precoNumerico = converterPreco(preco);
  if (!Number.isFinite(precoNumerico) || precoNumerico <= 0) {
    erros.preco = "O preço deve ser maior que zero.";
  }

  if (tamanhos.length === 0) {
    erros.tamanhos = "Adicione pelo menos um tamanho.";
  }

  const jaVistos = new Set();
  tamanhos.forEach((linha, indice) => {
    const nomeDoTamanho = normalizarTamanho(linha.tamanho);

    if (nomeDoTamanho === "") {
      erros["tamanho-" + indice] = "Informe o tamanho.";
    } else if (jaVistos.has(nomeDoTamanho)) {
      erros["tamanho-" + indice] = "Este tamanho já foi adicionado.";
    }
    jaVistos.add(nomeDoTamanho);

    // RN-02: o estoque não pode ser negativo (e precisa ser um número inteiro)
    const textoDoEstoque = String(linha.estoque ?? "").trim();
    const estoque = Number(textoDoEstoque);
    if (textoDoEstoque === "") {
      erros["estoque-" + indice] = "Informe o estoque (use 0 se acabou).";
    } else if (!Number.isInteger(estoque) || estoque < 0) {
      erros["estoque-" + indice] = "O estoque deve ser um número inteiro, zero ou maior.";
    }
  });

  return erros;
}
```


### Passo 4: a página do formulário

Crie `js/paginas/painelProdutoForm.js`:

**Arquivo: `js/paginas/painelProdutoForm.js`** (arquivo novo, inteiro)

```js
// Painel da lojista: formulário de produto. Nesta etapa (Aula 21) ele só valida e mostra os erros ao lado de cada campo.
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarSucesso, limparAvisos, mostrarErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { validarProduto } from "../servicos/produtoServico.js";

const formulario = document.getElementById("formulario-produto");

const campoNome = document.getElementById("nome-produto");
const campoDescricao = document.getElementById("descricao-produto");
const campoCategoria = document.getElementById("categoria-produto");
const campoPreco = document.getElementById("preco-produto");
const campoAtivo = document.getElementById("ativo-produto");
const blocoDeLinhas = document.getElementById("linhas-tamanhos");
const botaoAdicionarTamanho = document.getElementById("adicionar-tamanho");

// Categorias fictícias (na Aula 29 elas passam a vir do banco)
const categoriasFicticias = [
  { id: 1, nome: "Blusas" },
  { id: 2, nome: "Camisetas" },
  { id: 3, nome: "Vestidos" },
  { id: 4, nome: "Calças" },
  { id: 5, nome: "Saias" },
  { id: 6, nome: "Shorts" },
  { id: 7, nome: "Jaquetas" },
  { id: 8, nome: "Acessórios" },
];

function lerTamanhos() {
  return [...blocoDeLinhas.children].map((linha) => {
    const [entradaTamanho, entradaEstoque] = linha.querySelectorAll("input");
    return { tamanho: entradaTamanho.value, estoque: entradaEstoque.value };
  });
}

function lerDados() {
  return {
    nome: campoNome.value,
    descricao: campoDescricao.value,
    categoriaId: campoCategoria.value,
    preco: campoPreco.value,
    ativo: campoAtivo.checked,
    tamanhos: lerTamanhos(),
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

formulario.addEventListener("submit", (evento) => {
  // Sem isto o navegador recarregaria a página
  evento.preventDefault();

  limparErrosDosCampos(formulario);
  limparAvisos();

  const dados = lerDados();
  const erros = validarProduto(dados);
  if (Object.keys(erros).length > 0) {
    mostrarErrosDoFormulario(erros);
    return;
  }

  mostrarSucesso("Tudo certo! Isto é só uma simulação: o produto ainda não é salvo (isso começa na Aula 31).");
});

function preencherCategorias(categorias) {
  categorias.forEach((categoria) => {
    const opcao = document.createElement("option");
    opcao.value = categoria.id;
    opcao.textContent = categoria.nome;
    campoCategoria.append(opcao);
  });
}

montarCabecalho();
preencherCategorias(categoriasFicticias);
```


No `painel-produto-form.html`, o cabeçalho passa a ser gerado pelo JavaScript. Troque o bloco `<header>` inteiro por:

**Arquivo: `painel-produto-form.html`**: substitua o trecho que começa na linha `<header class="cabecalho" id="cabecalho">` e termina na linha `</header>` (inclusive) por:

```html
  <header class="cabecalho" id="cabecalho"></header>
```


E cole a linha do `<script>` **logo antes de `</body>`**:

**Arquivo: `painel-produto-form.html`**: adicione este trecho logo antes da linha `</body>`:

```html
  <script type="module" src="js/paginas/painelProdutoForm.js"></script>
```


### Passo 5: teste os erros no navegador

1. Abra `painel-produto-form.html` pelo Live Server. A lista **Categoria** já tem os 8 tipos de roupa.
2. Clique em **Salvar produto** **sem preencher nada**. Aparecem mensagens vermelhas **ao lado de cada campo**: "Informe o nome do produto.", "Escolha a categoria.", "O preço deve ser maior que zero." e "Informe o tamanho." (o foco vai para o primeiro campo com erro).
3. Digite o nome, escolha a categoria, preço `-5`, tamanho `M` e estoque `-1`. Clique em salvar: "O preço deve ser maior que zero." e "O estoque deve ser um número inteiro, zero ou maior."
4. Corrija: preço `129,90` (a vírgula também vale), estoque `3`. Clique em salvar: aparece a mensagem verde **Tudo certo!** (é só uma simulação, nada é salvo).
5. Teste o telefone no Console (F12 > **Console**, em português: **Console**). Cole:

```js
const f = await import("/js/ui/formatadores.js");
console.log(f.normalizarTelefone("(27) 99999-9999"));
console.log(f.telefoneValido(f.normalizarTelefone("(27) 99999-9999")));
console.log(f.telefoneValido("12345"));
```

   Devem aparecer `5527999999999`, `true` e `false`.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Valida o formulário de produto no navegador com erros ao lado dos campos"
git push
```

## Explicação do Código

**formatadores.js**

- `normalizarTelefone(texto)`: `String(texto ?? "").replace(/\D/g, "")` apaga tudo o que **não é dígito** (`\D` é "qualquer coisa que não seja número"; o `g` quer dizer "em todo o texto"). Se sobraram 10 ou 11 dígitos (DDD + número), falta o código do país, e a função coloca `55` na frente.
- `telefoneValido(digitos)`: `/^\d{12,13}$/.test(...)` confere se o texto tem **só dígitos** (`^\d...$`), **12 ou 13** deles (`{12,13}`). É a **única** regra do projeto para telefone.

**avisos.js (final do arquivo)**

- `mostrarErroDoCampo(campo, mensagem)`: cria (ou reaproveita) um `<p class="campo-erro" id="erro-IDDOCAMPO">` dentro do `.campo` do campo e coloca a mensagem com `textContent`. Marca o campo com `aria-invalid="true"` e liga o campo ao erro com `aria-describedby`.
- `limparErrosDosCampos(formulario)`: apaga todos os erros do formulário e tira os atributos; mantém as dicas fixas (por exemplo, "Use pelo menos 6 caracteres").
- `limparErroDoCampo(campo)`: apaga o erro de **um** campo só.

**CSS "Erro ao lado"**: `.campo-erro` deixa a mensagem pequena, em negrito e vermelha; `.campo input[aria-invalid="true"]` (e `select`/`textarea`) pinta a **borda** do campo de vermelho.

**produtoServico.js**

- `normalizarTamanho`: "p", " p " e "P" são o mesmo tamanho (corta espaços e põe em maiúsculas). `converterPreco`: aceita `"129.9"` e `"129,90"`.
- `validarProduto({ nome, categoriaId, preco, tamanhos })` **devolve um objeto de erros** `{ campo: "mensagem" }`: vazio quer dizer "tudo certo". Cada `if` confere uma regra e, se falhar, guarda a mensagem com a **chave** do campo (`erros.nome`, `erros.preco`, `erros["tamanho-0"]`, `erros["estoque-0"]`...). Para o preço usa `Number.isFinite(...)` e `<= 0` (RN-02). Para o estoque, `Number.isInteger(estoque) && estoque >= 0`. Um `Set` (`jaVistos`) detecta tamanho repetido.

**painelProdutoForm.js**

- `lerTamanhos()` percorre as linhas de tamanho do HTML e junta os valores digitados. `lerDados()` junta tudo em um objeto.
- `acharCampoDoErro(chave)` descobre qual **campo da tela** corresponde a cada chave de erro (`"tamanho-0"` é o primeiro campo de tamanho). `mostrarErrosDoFormulario(erros)` mostra cada mensagem ao lado do campo e leva o foco ao primeiro campo com erro (na ordem em que aparece na tela).
- `formulario.addEventListener("submit", (evento) => { evento.preventDefault(); ... })`: o fluxo é: cancelar o envio padrão, limpar os erros antigos, ler os dados, validar e, se houver erros, mostrá-los e parar (`return`); se não, mostrar o sucesso.
- `preencherCategorias`: cria uma `<option>` para cada categoria fictícia.

## Validação

1. Salvar o formulário vazio mostra uma mensagem de erro **ao lado de cada campo inválido** e leva o foco ao primeiro.
2. Preço `-5` e estoque `-1` são recusados com mensagens claras; preço `129,90` é aceito.
3. Com tudo certo aparece **Tudo certo!** e a página **não** recarrega.
4. No Console, `telefoneValido(normalizarTelefone("(27) 99999-9999"))` é `true`.
5. Aperte Tab depois de um erro: o leitor de tela (se você tiver um) lê o campo e a mensagem.

**Erros comuns**

1. *Sintoma:* a página recarrega ao clicar em salvar. *Causa:* faltou `evento.preventDefault()` ou o `evento` não foi declarado como parâmetro. *Correção:* a função começa com `(evento) => { evento.preventDefault(); ...`.
2. *Sintoma:* nenhuma mensagem aparece. *Causa:* o `id` de um campo no HTML é diferente do do `getElementById`, ou `limparErrosDosCampos` apagou tudo logo depois. *Correção:* confira os `id` (`nome-produto`, `preco-produto`...) e a ordem: limpar **antes** de validar.
3. *Mensagem:* `The requested module ... does not provide an export named ...`. *Causa:* falta o `export` na frente de uma função (por exemplo, `validarProduto`). *Correção:* confira.
4. *Sintoma:* a mensagem aparece fora do campo. *Causa:* o campo não está dentro de um `<div class="campo">`. *Correção:* `mostrarErroDoCampo` usa `campo.closest(".campo")`; o HTML precisa dessa caixa.

**Se travar**

1. Abra o Console e veja o primeiro erro vermelho; ele mostra arquivo e linha.
2. Use `console.log(erros)` dentro do `submit` para ver o objeto de erros.
3. Compare com o código da aula e, se preciso, desfaça com `git restore nome-do-arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `js/servicos/produtoServico.js` (só a validação do produto), `js/paginas/painelProdutoForm.js` (validação com erros ao lado dos campos, ainda sem salvar).
- `formatadores.js` com as regras de telefone; `avisos.js` com os erros de campo; `componentes.css` com o estilo de campo com erro.
- `painel-produto-form.html` ligado ao script, com o cabeçalho gerado pelo JavaScript.

**Como saber que deu certo:** você salva o formulário com preço zero e vê o erro **ao lado do campo de preço**, não só um aviso solto no topo.
