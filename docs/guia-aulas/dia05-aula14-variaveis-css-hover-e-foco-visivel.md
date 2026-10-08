# Aula 14 – Variáveis CSS, estados de hover e refinamento da interface

**Dia 5 · Ter 13/10/2026** · **Aula 14** · **UC3**

- **Requisitos cobertos:** não se aplica (acessibilidade nível AA básico: foco visível, contraste, menos movimento)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** os quatro arquivos CSS ligados às páginas, com media queries; catálogo, loja, produto e login responsivos (Aula 13)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fechar o `css/base.css` (foco visível, texto para leitores de tela, link para pular ao conteúdo), conferir os **estados de hover e foco**, o **contraste** de cores e entender como o CSS está organizado em **arquivos por responsabilidade**.

**Abertura (10 minutos).** Retomada da Aula 13: as páginas se adaptam ao tamanho da tela. Faltam os cuidados com quem usa o **teclado** (sem mouse) e com **leitores de tela**. Teste agora: abra o `catalogo.html`, **não use o mouse** e aperte Tab várias vezes. Dá para saber em que elemento você está? Provavelmente o contorno existe só no padrão do navegador. Hoje deixamos isso consistente.

## O Conceito

**Termos desta aula**

- **Variáveis CSS (custom properties)**: nomes que guardam valores reaproveitáveis, como `--cor-primaria`. Já usamos todas desde a Aula 10: hoje você vê **por que** elas valem a pena e como mexer nelas.
- **Estado**: a situação do elemento. `:hover` = mouse em cima; `:focus-visible` = recebeu foco por teclado; `:disabled` = desabilitado.
- **Foco visível**: o contorno que mostra qual elemento o teclado está controlando. Sem ele, uma pessoa que não usa mouse "se perde" na página.
- **Contraste**: a diferença de claridade entre texto e fundo. O mínimo do nível AA é **4,5:1** para texto normal.

**Analogia:** o foco visível é a lanterna de quem anda no escuro: se ela apagar, a pessoa não sabe onde pisa.

**Organização em arquivos:** cada arquivo CSS tem **uma responsabilidade**.

| Arquivo | O que guarda | Exemplo |
| --- | --- | --- |
| `variaveis.css` | os valores do guia de estilo | `--cor-primaria` |
| `base.css` | o que vale para a página toda | fonte, links, foco, texto oculto |
| `componentes.css` | peças reutilizáveis em várias páginas | botão, card, campo, chip, aviso |
| `paginas.css` | ajustes de uma página específica | galeria do produto, sacola |
| `inicio.css` (Dia 14) | só da página inicial | hero, carrossel |

Regra prática: usado em **mais de uma página** vai para `componentes.css`; de uma página só vai para `paginas.css`.

## Mão na Massa

### Passo 1: complete o base.css

Cole **no final** do `css/base.css` as regras que faltam:

**Arquivo: `css/base.css`**: adicione este trecho no final do arquivo:

```css
/* Foco visível para quem navega pelo teclado */
:focus-visible {
  outline: 3px solid var(--cor-foco);
  outline-offset: 2px;
}

/* O atributo hidden precisa vencer qualquer "display" definido nas classes (ex.: contador da sacola) */
[hidden] {
  display: none !important;
}

/* Texto só para leitores de tela */
.visualmente-oculto {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Link "Ir para o conteúdo": só aparece quando recebe o foco do teclado */
.link-pular {
  position: absolute;
  left: var(--espaco-2);
  top: -4rem;
  z-index: 10;
  padding: var(--espaco-2) var(--espaco-4);
  background-color: var(--cor-superficie);
  border-radius: var(--raio-pequeno);
}

.link-pular:focus {
  top: var(--espaco-2);
}

.texto-suave {
  color: var(--cor-texto-suave);
}

/* Respeita quem prefere menos movimento */
@media (prefers-reduced-motion: reduce) {
  * {
    transition: none !important;
    animation: none !important;
  }
}
```


### Passo 2: teste só com o teclado

1. Abra o `catalogo.html`, clique em uma área em branco da página e aperte Tab. O primeiro foco vai para **Ir para o conteúdo**: o link, que antes ficava solto na página, agora fica escondido acima da tela e **aparece só quando recebe o foco**.
2. Continue apertando Tab: logotipo, itens do menu, campos, chips, cards. Em cada um deve aparecer um contorno **azul de 3 px**.
3. No card de produto o contorno envolve o card inteiro (regra da Aula 12).

### Passo 3: confira o contraste no navegador

1. Aperte F12, escolha a aba **Elements** (em português: **Elementos**) e clique em um parágrafo de texto suave (por exemplo, o nome da loja em um card).
2. No painel **Styles** (em português: **Estilos**), clique no quadradinho colorido ao lado de `color`. Abre o seletor de cores, e no topo dele aparece **Contrast ratio** (em português: **Taxa de contraste**), com uma marca de visto (✓) quando passa de 4,5.
3. Faça o mesmo no texto branco do botão **Entrar** do login. Anote os dois valores.

### Passo 4: mexa nas variáveis (e veja a vantagem)

1. Em `css/variaveis.css`, troque `--cor-primaria: #8a2252;` por `--cor-primaria: #1d4e89;` (um azul) e salve. Botões, chips marcados, contador e preço mudam **ao mesmo tempo**.
2. Volte para `#8a2252`.
3. Troque `--cor-foco: #1a5fb4;` por `--cor-foco: #ff6600;`, aperte Tab na página e veja o contorno laranja. Volte ao valor original.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Completa o CSS base com foco visível, texto para leitores de tela e menos movimento"
git push
```

## Explicação do Código

As regras que você acrescentou ao `base.css`:

- `:focus-visible { outline: 3px solid var(--cor-foco); outline-offset: 2px; }`: quando **qualquer** elemento recebe foco por teclado, desenha um contorno de 3 px, afastado 2 px do elemento. `:focus-visible` (e não `:focus`) evita o contorno quando a pessoa **clica** com o mouse.
- `[hidden] { display: none !important; }`: o atributo HTML `hidden` esconde um elemento. Mas outras regras com `display` (como `display: flex` dos botões) poderiam vencê-lo; o `!important` garante que o `hidden` sempre ganhe. Vamos usar muito `hidden` quando o JavaScript esconder e mostrar partes da página.
- `.visualmente-oculto { position: absolute; width: 1px; height: 1px; ... clip: rect(0,0,0,0); ... }`: esconde o texto **da vista**, mas o deixa para os **leitores de tela**. Não use `display: none` para isso (o leitor de tela também ignoraria).
- `.link-pular { position: absolute; left: ...; top: -4rem; ... }` e `.link-pular:focus { top: ... }`: o link "Ir para o conteúdo" fica fora da tela (`top: -4rem`) e, quando recebe o foco, desce para ser visto.
- `.texto-suave { color: var(--cor-texto-suave); }`: classe utilitária para um texto secundário.
- `@media (prefers-reduced-motion: reduce) { * { transition: none !important; animation: none !important; } }`: uma media query diferente. Ela vale para quem pediu "menos movimento" nas configurações do computador ou do celular (por exemplo, quem sente tontura com animações). Nesses casos desligamos transições e animações.

**Sobre estados**: o `:hover` já aparece nos botões, chips, links do menu e cards; o `:disabled` no botão desabilitado; o `:focus-visible` em tudo.

**Sobre contraste**: a paleta foi testada, com todos os pares de texto e fundo acima de 4,5:1. A única cor abaixo disso é a **borda dos campos** (`--cor-borda-campo`), que precisa só de 3:1, porque componentes visuais de interface têm uma exigência menor que a do texto.

## Validação

1. Com Tab, o primeiro foco mostra "Ir para o conteúdo" e depois todos os elementos interativos mostram um contorno azul.
2. Você anotou o contraste de dois pares de cores, ambos com ✓ (acima de 4,5:1).
3. Trocar `--cor-primaria` mudou todas as peças ao mesmo tempo, e você voltou ao valor original.
4. Os quatro arquivos CSS continuam ligados às cinco páginas, na ordem `variaveis`, `base`, `componentes`, `paginas`.

**Erros comuns**

1. *Sintoma:* o link "Ir para o conteúdo" aparece sempre na tela, no topo. *Causa:* a regra `.link-pular` foi colada sem a `position: absolute` e o `top: -4rem`. *Correção:* confira a regra inteira.
2. *Sintoma:* o foco aparece mesmo ao clicar com o mouse. *Causa:* foi escrito `:focus` em vez de `:focus-visible`. *Correção:* use `:focus-visible`.
3. *Sintoma:* um elemento com o atributo `hidden` continua aparecendo. *Causa:* falta a regra `[hidden]` ou ela foi colada antes de outra que a sobrescreve. *Correção:* confira que `[hidden]` está no `base.css` e tem `!important`.
4. *Sintoma:* o texto "visualmente oculto" aparece na página. *Causa:* a classe `visualmente-oculto` foi digitada diferente no HTML e no CSS. *Correção:* a grafia precisa ser idêntica, em minúsculas e com hífen.

**Se travar**

1. Releia o painel **Styles** (em português: **Estilos**) do DevTools: se uma regra aparece riscada, outra a sobrescreveu.
2. Compare o `base.css` com o da aula.
3. Desfaça com `git restore css/base.css` e cole de novo o bloco do Passo 1.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- `css/variaveis.css`, `css/base.css` (completo), `css/componentes.css` e `css/paginas.css`.
- Foco visível, link para pular o conteúdo, classe de texto só para leitores de tela, atributo `hidden` confiável e respeito a "menos movimento".

**Como saber que deu certo:** você percorre a página toda só com o Tab e sempre sabe em qual elemento está.
