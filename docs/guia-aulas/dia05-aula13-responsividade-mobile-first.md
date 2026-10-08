# Aula 13 – Responsividade mobile-first e media queries

**Dia 5 · Ter 13/10/2026** · **Aula 13** · **UC3**

- **Requisitos cobertos:** não se aplica (tela funcionando de 360 px a 1280 px de largura, sem rolagem horizontal)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** css/variaveis.css, css/base.css, css/componentes.css e css/paginas.css ligados às cinco páginas; card de produto e filtros do catálogo estilizados (Aulas 10 a 12)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai tornar as quatro páginas **responsivas**: começando pelo celular (**mobile-first**) e usando **media queries** em **768 px** e **1024 px**, e vai testar em 360, 768 e 1280 px sem rolagem horizontal.

**Abertura (10 minutos).** Retomada da Aula 12: o catálogo tem uma coluna de cards, que é ótima no celular, mas em um monitor largo deixa a tela vazia dos lados. Abra o `catalogo.html` e arraste a borda da janela do navegador para mais larga e mais estreita: veja o que acontece com os cards e com o menu.

## O Conceito

**Termos desta aula**

- **Responsivo**: uma página que se adapta ao tamanho da tela (celular, tablet, computador), sem precisar de versões diferentes.
- **Mobile-first**: escrever primeiro o CSS para a tela pequena e só depois acrescentar regras para telas maiores.
- **Media query**: uma regra condicional, escrita como `@media (min-width: 768px) { ... }`, que só vale quando a tela tem **pelo menos** aquela largura.
- **Breakpoint (ponto de quebra)**: a largura em que o layout muda. Neste projeto: **768 px** (tablet) e **1024 px** (computador).
- **Viewport**: a área visível da página. A linha `<meta name="viewport" content="width=device-width, initial-scale=1">` do HTML faz o celular usar a largura real da tela em vez de fingir que é um monitor.

**Analogia:** é como uma mochila com compartimentos: no celular a mochila é pequena e tudo vai em uma fila; no computador ela é grande e os itens se espalham em colunas. O conteúdo é o mesmo; o arranjo muda.

**Por que mobile-first?** Porque a maioria das clientes abre o site no celular, e porque é mais fácil **acrescentar** colunas quando há espaço do que **espremer** um layout largo em uma tela pequena.

## Mão na Massa

### Passo 1: aprenda a testar em tamanhos diferentes

1. Abra o `catalogo.html` pelo Live Server e aperte F12.
2. Clique no ícone de celular e tablet, **Toggle device toolbar** (em português: **Alternar barra de ferramentas do dispositivo**), ou use Ctrl+Shift+M (no Mac, Cmd+Shift+M).
3. No topo da página aparece uma barra com **Dimensions** (em português: **Dimensões**; ou **Responsive**, em português: **Responsivo**). Digite as larguras nas caixinhas: `360` (celular), `768` (tablet) e `1280` (computador).

### Passo 2: acrescente os estilos da loja, do produto e do login

Vamos escrever, em `css/paginas.css`, os estilos específicos das páginas da loja, do produto e do login. Cole **no final** do arquivo:

**Arquivo: `css/paginas.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Página da loja (loja.html) ---------- */
.loja-resumo {
  display: grid;
  gap: var(--espaco-4);
  margin-bottom: var(--espaco-6);
  padding: var(--espaco-4);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.loja-imagem {
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
  border-radius: var(--raio-pequeno);
}

.loja-dados {
  margin: 0 0 var(--espaco-4);
}

.loja-dados dt {
  font-weight: 700;
}

.loja-dados dd {
  margin: 0 0 var(--espaco-2);
}

.loja-acoes {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
}

/* ---------- Página do produto (produto.html) ---------- */
.produto-detalhe {
  display: grid;
  gap: var(--espaco-5);
}

.galeria-principal {
  width: 100%;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.galeria-miniaturas {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
  margin-top: var(--espaco-3);
  list-style: none;
}

.miniatura {
  width: 4.5rem;
  padding: 0;
  overflow: hidden;
  background: none;
  border: 3px solid transparent;
  border-radius: var(--raio-pequeno);
  cursor: pointer;
}

.miniatura[aria-current="true"] {
  border-color: var(--cor-primaria);
}

.miniatura img {
  width: 100%;
  aspect-ratio: 4 / 5;
  object-fit: cover;
}

.produto-info .preco {
  margin-bottom: var(--espaco-4);
  font-size: var(--tamanho-grande);
}

.produto-compra {
  display: grid;
  gap: var(--espaco-4);
  max-width: 24rem;
}

/* ---------- Login e cadastro ---------- */
.cartao-formulario {
  max-width: 28rem;
  margin-inline: auto;
  padding: var(--espaco-5);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
  box-shadow: var(--sombra-leve);
}

.cartao-formulario p:last-child {
  margin-bottom: 0;
}
```


Resultado: a página da loja ganha a caixa de dados, o produto ganha a galeria de fotos com miniaturas e o login vira um cartão centralizado.

### Passo 3: acrescente as media queries de componentes.css

**No final** do `css/componentes.css`:

**Arquivo: `css/componentes.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Tablet ---------- */
@media (min-width: 768px) {
  .grade-produtos {
    grid-template-columns: repeat(2, 1fr);
  }

  .tabela thead {
    position: static;
    width: auto;
    height: auto;
    overflow: visible;
    clip: auto;
  }

  .tabela tr {
    display: table-row;
    margin: 0;
    border: 0;
  }

  .tabela th,
  .tabela td {
    padding: var(--espaco-3);
    border-bottom: 1px solid var(--cor-borda);
    text-align: left;
  }

  .tabela th {
    background-color: var(--cor-primaria-clara);
  }

  .tabela td {
    display: table-cell;
  }

  .tabela td::before {
    content: none;
  }

  .tabela-acoes {
    justify-content: flex-start;
  }
}

/* ---------- Desktop ---------- */
@media (min-width: 1024px) {
  /* Quantas colunas cabem: 3 em telas menores do desktop, 4 nas largas */
  .grade-produtos {
    grid-template-columns: repeat(auto-fill, minmax(15rem, 1fr));
  }
}
```


Resultado: a 768 px o catálogo passa para **2 colunas**; a 1024 px ele usa **quantas colunas couberem** (3 ou 4).

### Passo 4: acrescente as media queries de paginas.css

**No final** do `css/paginas.css`:

**Arquivo: `css/paginas.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Tablet ---------- */
@media (min-width: 768px) {
  .filtros-campos {
    grid-template-columns: repeat(3, 1fr);
  }

  .produto-detalhe {
    grid-template-columns: 1fr 1fr;
    align-items: start;
  }

  .pedido-atualizar {
    grid-template-columns: 1fr 2fr;
    align-items: start;
  }

  .tamanhos-estoque {
    grid-template-columns: repeat(4, 1fr);
  }
}

/* ---------- Desktop ---------- */
@media (min-width: 1024px) {
  main {
    padding-block: var(--espaco-6);
  }

  .produto-detalhe {
    gap: var(--espaco-6);
  }

  .sacola-layout {
    max-width: 52rem;
  }
}
```


Resultado: a 768 px os filtros do catálogo ficam em 3 colunas e a página do produto passa a ter a foto de um lado e as informações do outro.

### Passo 5: teste as quatro páginas em três larguras

Para cada uma das páginas `catalogo.html`, `loja.html`, `produto.html` e `login.html`, use o Passo 1 e confira em **360**, **768** e **1280** px:

| Largura | O que deve acontecer |
| --- | --- |
| 360 px | uma coluna; menu quebra de linha; nada passa da largura da tela |
| 768 px | catálogo em 2 colunas; produto com foto ao lado das informações; filtros em 3 colunas |
| 1280 px | catálogo em 3 ou 4 colunas; conteúdo centralizado com largura máxima |

Em nenhuma largura pode aparecer a **barra de rolagem horizontal**.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Torna as páginas responsivas com media queries de 768px e 1024px"
git push
```

## Explicação do Código

- `@media (min-width: 768px) { ... }`: "a partir de 768 px de largura, aplique estas regras". Como as regras de fora das media queries são as do **celular** (mobile-first), as de dentro só **acrescentam ou trocam** o que muda em telas maiores.
- Em `componentes.css`, **Tablet**: `.grade-produtos { grid-template-columns: repeat(2, 1fr); }` (2 colunas iguais). **Desktop** (a partir de 1024 px): `repeat(auto-fill, minmax(15rem, 1fr))` quer dizer "encaixe quantas colunas de **pelo menos 15 rem** couberem, e divida o espaço que sobrar igualmente". Em um monitor médio saem 3 colunas, em um largo, 4.
- A seção **Tablet** de `componentes.css` também traz regras da **tabela** (que você vai usar na Aula 15): no celular cada linha vira um bloco, e a partir de 768 px a tabela volta a ter linhas e colunas. Hoje elas ainda não têm efeito, porque a tabela só aparece mais tarde.
- Em `paginas.css`, **Tablet**: `.filtros-campos` (os filtros do catálogo) vira uma grade de 3 colunas; `.produto-detalhe` vira `1fr 1fr` (foto de um lado, informações do outro) com `align-items: start` (alinhados ao topo). Outras regras da seção (pedidos e painel) também só terão efeito nas próximas aulas. **Desktop**: mais espaço vertical e a largura máxima da sacola.
- **Página da loja**: `.loja-resumo` (a caixa), `.loja-dados dt/dd` (os pares "termo e valor") e `.loja-acoes` (os botões lado a lado, com `flex-wrap`).
- **Página do produto**: `.galeria-principal` (foto grande em 4/5, com `object-fit: cover`), `.galeria-miniaturas` (lista flex), `.miniatura` (botão com a imagem; `[aria-current="true"]` marca a escolhida) e `.produto-compra` (o formulário com largura máxima).
- **Login e cadastro**: `.cartao-formulario` é a caixa centralizada com largura máxima de 28 rem; `margin-inline: auto` centraliza.

## Validação

1. Em 360, 768 e 1280 px, **nenhuma** das quatro páginas tem rolagem horizontal.
2. O catálogo tem 1 coluna (360 px), 2 colunas (768 px) e 3 ou 4 colunas (1280 px).
3. A página do produto tem foto e informações lado a lado a partir de 768 px.
4. O login aparece como um cartão centralizado.

**Erros comuns**

1. *Sintoma:* as media queries não funcionam. *Causa:* faltou fechar uma chave `}` antes do `@media`, ou o texto `@media` tem erro de digitação. *Correção:* o VS Code destaca chaves desencontradas; confira.
2. *Sintoma:* no celular de verdade a página parece a versão de computador, bem pequena. *Causa:* falta o `<meta name="viewport" ...>` no `<head>`. *Correção:* confira se as cinco páginas têm essa linha.
3. *Sintoma:* aparece a barra de rolagem horizontal em 360 px. *Causa:* alguma coisa tem largura fixa maior que a tela (por exemplo, `width: 400px`). *Correção:* na aba **Elements** (em português: **Elementos**), passe o mouse pelos elementos até achar o que passa da borda, e troque a largura fixa por `max-width: 100%`.
4. *Sintoma:* o catálogo continua em 1 coluna em 1280 px. *Causa:* a seção `Tablet` ou `Desktop` do `componentes.css` não foi colada, ou foi colada antes do `.grade-produtos`. *Correção:* as media queries vão **depois** das regras que elas modificam.

**Se travar**

1. No DevTools, selecione a `ul` do catálogo e veja, no painel **Styles** (em português: **Estilos**), qual regra de `grid-template-columns` está valendo; as riscadas foram sobrescritas.
2. Compare os arquivos com os da aula. A **ordem** das seções importa: o que vem depois vence.
3. Desfaça com `git status` e `git restore css/componentes.css css/paginas.css`.
4. Só depois peça ajuda à sua equipe, dizendo em que largura o problema acontece.

**Seu projeto agora tem**

- Os quatro arquivos CSS (`variaveis`, `base`, `componentes` e `paginas`) com media queries de 768 px e 1024 px.
- As páginas catálogo, loja, produto e login responsivas.

**Como saber que deu certo:** você arrasta a largura do navegador de 360 px até 1280 px e a página se reorganiza sem nunca criar rolagem horizontal.
