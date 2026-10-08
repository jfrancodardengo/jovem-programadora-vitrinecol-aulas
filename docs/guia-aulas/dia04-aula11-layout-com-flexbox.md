# Aula 11 – Layout com Flexbox

**Dia 4 · Sex 09/10/2026** · **Aula 11** · **UC3**

- **Requisitos cobertos:** não se aplica (apresentação visual das telas)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** css/variaveis.css e css/base.css ligados às páginas index, catalogo, loja, produto e login (Aula 10)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai usar o **Flexbox** para diagramar o cabeçalho com menu, o rodapé, os botões, os formulários e os chips de tipo de roupa, criando o arquivo `css/componentes.css`.

**Abertura (10 minutos).** Retomada da Aula 10: as páginas já têm cor e fonte, mas o menu é uma lista vertical e os campos do formulário estão soltos. Abra o `login.html` e o `catalogo.html` e veja o que está "desalinhado". Hoje arrumamos isso. Abra também o wireframe (Aula 4): o logotipo à esquerda e o menu à direita.

## O Conceito

**Termos desta aula**

- **Flexbox**: um jeito de organizar elementos em **linha** ou em **coluna**, com alinhamento e espaçamento automáticos. Liga-se com `display: flex` no elemento **pai**; os filhos obedecem.
- **Eixo principal e eixo cruzado**: em uma linha (`flex-direction: row`, o padrão), o eixo principal é o **horizontal** e o cruzado é o vertical. Em coluna (`flex-direction: column`) é ao contrário.
- **`justify-content`**: alinha os filhos ao longo do eixo principal (`space-between` empurra o primeiro para a esquerda e o último para a direita).
- **`align-items`**: alinha os filhos no eixo cruzado (`center` centraliza na vertical, em uma linha).
- **`gap`**: o espaço entre os filhos. **`flex-wrap: wrap`**: permite quebrar para a linha de baixo quando não cabe.

**Analogia:** o Flexbox é uma prateleira com regras: "arrume os livros em fila, com o mesmo espaço entre eles, e se não couberem, comece outra fila".

## Mão na Massa

Vamos criar o `css/componentes.css` por partes, para você ver o efeito de cada uma. Salve e olhe o navegador depois de cada parte.

### Passo 1: cabeçalho, menu e rodapé

Crie o arquivo `css/componentes.css` com as duas primeiras seções:

**Arquivo: `css/componentes.css`** (arquivo novo):

```css
/* Componentes reutilizáveis: cabeçalho, botões, cards, campos, avisos, chips, tabela. */

/* ---------- Cabeçalho (Flexbox) ---------- */
.cabecalho {
  background-color: var(--cor-superficie);
  border-bottom: 1px solid var(--cor-borda);
  box-shadow: var(--sombra-leve);
}

.cabecalho-conteudo {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--espaco-2) var(--espaco-4);
  padding-block: var(--espaco-3);
}

.logotipo {
  font-size: var(--tamanho-grande);
  font-weight: 700;
  color: var(--cor-primaria-escura);
  text-decoration: none;
}

.menu {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-1) var(--espaco-3);
  list-style: none;
}

.menu a {
  display: inline-block;
  padding: var(--espaco-2) var(--espaco-1);
  color: var(--cor-texto);
  font-weight: 600;
  text-decoration: none;
  border-bottom: 3px solid transparent;
}

.menu a:hover,
.menu a[aria-current="page"] {
  color: var(--cor-primaria-escura);
  border-bottom-color: var(--cor-primaria);
}

/* ---------- Rodapé ---------- */
.rodape {
  padding-block: var(--espaco-5);
  background-color: var(--cor-superficie);
  border-top: 1px solid var(--cor-borda);
  color: var(--cor-texto-suave);
  font-size: var(--tamanho-pequeno);
}

.rodape-links {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-1) var(--espaco-4);
  list-style: none;
  margin-bottom: var(--espaco-3);
}
```


Ligue o novo arquivo às cinco páginas (`index.html`, `catalogo.html`, `loja.html`, `produto.html` e `login.html`), colando esta linha **dentro do `<head>`, logo antes de `</head>`** (depois dos links que já existem):

```html
<link rel="stylesheet" href="css/componentes.css">
```


Resultado: o logotipo fica à esquerda, o menu em linha à direita, e o rodapé com os links lado a lado. Diminua a janela do navegador: o menu quebra para a linha de baixo, em vez de estourar a tela.

### Passo 2: botões

Acrescente **no final** do arquivo `css/componentes.css`:

**Arquivo: `css/componentes.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Botões ---------- */
.botao {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--espaco-2);
  min-height: 2.75rem;
  padding: var(--espaco-2) var(--espaco-5);
  font: inherit;
  font-weight: 600;
  text-decoration: none;
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
  border: 2px solid var(--cor-primaria);
  border-radius: var(--raio-medio);
  cursor: pointer;
}

.botao:hover {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria-escura);
  border-color: var(--cor-primaria-escura);
}

.botao-secundario {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
}

.botao-secundario:hover {
  color: var(--cor-primaria-escura);
  background-color: var(--cor-primaria-clara);
}

.botao-perigo {
  color: var(--cor-erro);
  background-color: var(--cor-superficie);
  border-color: var(--cor-erro);
}

.botao-perigo:hover {
  color: var(--cor-erro);
  background-color: var(--cor-erro-fundo);
  border-color: var(--cor-erro);
}

/* Verde do WhatsApp escurecido para manter contraste AA com texto branco */
.botao-whatsapp {
  background-color: #0b6b3a;
  border-color: #0b6b3a;
}

.botao-whatsapp:hover {
  background-color: #085530;
  border-color: #085530;
}

.botao-pequeno {
  min-height: 2.25rem;
  padding: var(--espaco-1) var(--espaco-3);
  font-size: var(--tamanho-pequeno);
}

.botao-largo {
  width: 100%;
}

.botao:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
```


Resultado: o botão **Entrar** do login e os botões da loja ganham fundo colorido, cantos arredondados e a altura mínima de 44 px. Passe o mouse sobre um botão: a cor escurece.

### Passo 3: campos de formulário

**Arquivo: `css/componentes.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Campos de formulário ---------- */
.formulario {
  display: grid;
  gap: var(--espaco-4);
}

.campo {
  display: flex;
  flex-direction: column;
  gap: var(--espaco-1);
}

.campo label,
.legenda {
  font-weight: 600;
}

.campo input,
.campo select,
.campo textarea {
  width: 100%;
  min-height: 2.75rem;
  padding: var(--espaco-2) var(--espaco-3);
  font: inherit;
  color: var(--cor-texto);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-borda-campo);
  border-radius: var(--raio-pequeno);
}

.campo textarea {
  min-height: 6rem;
  resize: vertical;
}

.campo input:focus-visible,
.campo select:focus-visible,
.campo textarea:focus-visible {
  outline: 3px solid var(--cor-foco);
  outline-offset: 1px;
}

.campo-ajuda {
  margin: 0;
  font-size: var(--tamanho-pequeno);
  color: var(--cor-texto-suave);
}

fieldset.campo {
  min-width: 0;
  margin: 0;
  padding: 0;
  border: 0;
}

fieldset.campo legend {
  padding: 0;
  margin-bottom: var(--espaco-2);
  font-weight: 600;
}

/* Opções de rádio e checkbox: o rótulo envolve o input para aumentar a área de clique */
.opcao {
  display: inline-flex;
  align-items: center;
  gap: var(--espaco-2);
  min-height: 2.75rem;
  font-weight: 400;
  cursor: pointer;
}

.opcao input {
  width: 1.25rem;
  min-height: 0;
  height: 1.25rem;
  accent-color: var(--cor-primaria);
}

.opcoes {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-1) var(--espaco-4);
}

/* Botões de tamanho: radio estilizado como botão, com o input ainda focável pelo teclado */
.tamanhos {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
}

.tamanho-opcao {
  position: relative;
}

.tamanho-opcao input {
  position: absolute;
  opacity: 0;
  width: 100%;
  height: 100%;
  margin: 0;
  cursor: pointer;
}

.tamanho-opcao span {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 2.75rem;
  min-height: 2.75rem;
  padding: var(--espaco-1) var(--espaco-3);
  font-weight: 600;
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-borda-campo);
  border-radius: var(--raio-pequeno);
}

.tamanho-opcao input:checked + span {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
  border-color: var(--cor-primaria);
}

.tamanho-opcao input:focus-visible + span {
  outline: 3px solid var(--cor-foco);
  outline-offset: 2px;
}

.tamanho-opcao input:disabled {
  cursor: not-allowed;
}

.tamanho-opcao input:disabled + span {
  color: var(--cor-texto-suave);
  background-color: var(--cor-neutro-fundo);
  text-decoration: line-through;
}
```


Resultado: em `login.html` e `catalogo.html`, cada rótulo fica acima do seu campo, os campos ocupam a largura toda, com borda visível, e os botões de tamanho do produto parecem botões de escolha.

### Passo 4: avisos e chips

**Arquivo: `css/componentes.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Avisos (carregando, erro, sucesso, informação) ---------- */
.aviso {
  margin-bottom: var(--espaco-4);
  padding: var(--espaco-3) var(--espaco-4);
  border: 1px solid currentColor;
  border-left-width: 6px;
  border-radius: var(--raio-pequeno);
}

.aviso-erro {
  color: var(--cor-erro);
  background-color: var(--cor-erro-fundo);
}

.aviso-sucesso {
  color: var(--cor-sucesso);
  background-color: var(--cor-sucesso-fundo);
}

.aviso-info,
.aviso-carregando {
  color: var(--cor-info);
  background-color: var(--cor-info-fundo);
}

/* ---------- Chips de filtro ---------- */
.chips {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
  list-style: none;
}

.chip {
  min-height: 2.5rem;
  padding: var(--espaco-1) var(--espaco-4);
  font: inherit;
  font-weight: 600;
  color: var(--cor-texto);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-borda-campo);
  border-radius: var(--raio-pilula);
  cursor: pointer;
}

.chip:hover {
  background-color: var(--cor-primaria-clara);
}

.chip[aria-pressed="true"] {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
  border-color: var(--cor-primaria);
}
```


Resultado: os chips de tipo de roupa no catálogo viram "pílulas" em linha, que quebram de linha quando não cabem. Para ver os avisos, cole **temporariamente** abaixo do `<h1>Entrar</h1>` do `login.html`:

```html
<p class="aviso aviso-erro" role="alert">E-mail ou senha incorretos.</p>
```

Veja a caixa vermelha de erro e depois **apague** essa linha.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria os componentes: cabeçalho, botões, campos, avisos e chips com Flexbox"
git push
```

## Explicação do Código

**Cabeçalho**

- `.cabecalho { background-color; border-bottom; box-shadow }`: fundo branco, uma linha embaixo e uma sombra leve.
- `.cabecalho-conteudo { display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: ...; padding-block: ... }`: o pai é um flex. `space-between` empurra o logotipo para a esquerda e o menu para a direita; `align-items: center` os alinha na vertical; `wrap` deixa o menu quebrar de linha no celular; `gap` cria o espaço entre eles.
- `.logotipo`: tamanho, peso (`font-weight: 700` = negrito), cor e `text-decoration: none` (sem sublinhado).
- `.menu { display: flex; flex-wrap: wrap; gap; list-style: none; }`: a lista do menu também é flex, então os `li` ficam em linha. `list-style: none` tira as bolinhas.
- `.menu a { display: inline-block; padding; ... border-bottom: 3px solid transparent; }`: cada link é uma caixa com espaço interno. A borda inferior é transparente para o espaço não "pular" quando ela ganha cor.
- `.menu a:hover, .menu a[aria-current="page"] { ... border-bottom-color: ... }`: o seletor de **atributo** `[aria-current="page"]` escolhe o link da página atual. Ele e o `:hover` ganham a linha colorida embaixo.

**Rodapé**: `.rodape` é um bloco com fundo e linha em cima; `.rodape-links` é um flex com `wrap`, para os links ficarem lado a lado.

**Botões**

- `.botao { display: inline-flex; align-items: center; justify-content: center; ... min-height: 2.75rem; ... }`: o botão é um flex só para centralizar o texto. `min-height: 2.75rem` (44 px) é o tamanho confortável para o dedo. `font: inherit` faz o botão herdar a fonte da página (por padrão botões usam outra). `cursor: pointer` mostra a "mãozinha".
- `.botao:hover`: no estado de mouse em cima, o fundo escurece.
- `.botao-secundario`, `.botao-perigo`, `.botao-whatsapp`, `.botao-pequeno`, `.botao-largo`: **variações**. Na HTML, o botão usa duas classes: `class="botao botao-secundario"` (a segunda muda só o que for diferente). O verde do WhatsApp foi escurecido para ter contraste suficiente com o texto branco.
- `.botao:disabled`: botão desabilitado fica semitransparente e com o cursor de "proibido".

**Campos**

- `.formulario { display: grid; gap }`: o formulário usa Grid (próxima aula) só para empilhar os campos com espaço entre eles.
- `.campo { display: flex; flex-direction: column; gap }`: cada `div.campo` é uma **coluna**: rótulo em cima, campo embaixo.
- `.campo input, .campo select, .campo textarea { width: 100%; min-height: 2.75rem; padding; border: 2px solid ...; }`: seletor **descendente**: escolhe `input` que estejam **dentro** de `.campo`. A borda é mais escura para ter contraste com o fundo.
- `.campo input:focus-visible ... { outline }`: o contorno que aparece quando o campo recebe o foco do teclado.
- `fieldset.campo` e `.opcao`/`.opcoes`: grupo de opções (radio e checkbox) com o rótulo envolvendo o campo, aumentando a área de clique.
- `.tamanho-opcao`: o radio de tamanho vira um botão: o `input` fica invisível e cobre a área (`opacity: 0; position: absolute`), e o `span` ao lado desenha o botão. `input:checked + span` (o `span` logo depois de um radio marcado) ganha a cor primária; `input:disabled + span` fica cinza e **riscado** (`text-decoration: line-through`).

**Avisos**: `.aviso` é a caixa (borda à esquerda mais grossa); `.aviso-erro`, `.aviso-sucesso`, `.aviso-info` e `.aviso-carregando` só trocam as cores (as variáveis do guia de estilo).

**Chips**: `.chips { display: flex; flex-wrap: wrap; gap; list-style: none }` e `.chip` como pílula (`border-radius: var(--raio-pilula)`). `.chip[aria-pressed="true"]` é o chip **escolhido**: usa o atributo de acessibilidade como gancho do estilo, então o visual e o significado nunca saem de sincronia.

## Validação

1. O cabeçalho mostra o logotipo à esquerda e o menu à direita; em janela estreita, o menu quebra de linha sem rolagem horizontal.
2. Os botões têm cor, cantos arredondados e escurecem no mouse.
3. No `login.html`, cada rótulo está acima do seu campo; no `catalogo.html`, os chips ficam em linha e o chip "Todas" está destacado.
4. A caixa de aviso temporária apareceu em vermelho e foi removida.

**Erros comuns**

1. *Sintoma:* o menu continua em coluna. *Causa:* `display: flex` foi colocado no `li` ou no `a`, e não no `ul`. *Correção:* o flex vai no **pai** (`.menu`); os filhos obedecem.
2. *Sintoma:* os estilos novos não aparecem. *Causa:* o `<link>` do `componentes.css` não foi colado em todas as páginas, ou foi colado antes do `base.css`. *Correção:* confira as páginas e a ordem: `variaveis`, `base`, `componentes`.
3. *Sintoma:* o botão do `login.html` ficou sem cor, mas os links da loja têm. *Causa:* o HTML do botão não tem `class="botao"`. *Correção:* confira a classe no `<button>`.
4. *Sintoma:* os radios de tamanho aparecem como bolinhas comuns. *Causa:* faltou colar a seção `Campos de formulário` inteira. *Correção:* cole de novo a seção completa.

**Se travar**

1. Com F12 > **Elements** (em português: **Elementos**), selecione o `ul` do menu e procure `display: flex` no painel **Styles** (em português: **Estilos**). Se não estiver lá, a regra não está chegando.
2. Compare o seu `componentes.css` com o da aula, seção por seção.
3. Se algo quebrou, desfaça com `git status` e `git restore css/componentes.css`.
4. Só depois peça ajuda à sua equipe, dizendo qual parte (cabeçalho, botões, campos) não funciona.

**Seu projeto agora tem**

- `css/variaveis.css`, `css/base.css` e `css/componentes.css`, ligados às cinco páginas.
- Cabeçalho com menu em linha, rodapé, botões, campos de formulário, avisos e chips estilizados.

**Como saber que deu certo:** ao diminuir a janela do navegador, o cabeçalho, o menu e os chips se reorganizam em novas linhas sem criar rolagem horizontal.
