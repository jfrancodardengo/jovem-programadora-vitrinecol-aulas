# Aula 3 – HTML: estrutura da página, textos, links e imagens, com o Live Server

**Dia 1 · Ter 06/10/2026** · **Aula 3** · **UC3**

- **Requisitos cobertos:** não se aplica (base de todas as telas)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** pasta vitrine-col aberta no VS Code, com README.md e .gitignore versionados, repositório no GitHub e a extensão Live Server instalada (Aula 2)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai escrever a sua primeira página em **HTML**, com título, parágrafos, um link e uma imagem com texto alternativo, abri-la com o **Live Server** e versioná-la com um commit.

**Abertura (10 minutos).** Retomada da Aula 2: a pasta `vitrine-col` já é um repositório. Abra o VS Code, abra a pasta e rode `git status` no terminal: a mensagem deve dizer `nothing to commit, working tree clean` (nada para enviar). Hoje o repositório ganha as primeiras páginas do sistema.

## O Conceito

**Termos desta aula**

- **HTML**: a linguagem que descreve **o que** existe em uma página (títulos, textos, imagens, links). Não é programação: é uma marcação.
- **Tag**: uma "etiqueta" entre `<` e `>` que diz o que o conteúdo é. Quase sempre vem em par: `<p>` abre um parágrafo e `</p>` fecha.
- **Atributo**: uma informação extra dentro da tag, no formato `nome="valor"`, como o `src="foto.jpg"` de uma imagem.
- **Live Server**: extensão do VS Code que abre a página em um endereço local (`http://127.0.0.1:5500`) e **atualiza o navegador sozinho** toda vez que você salva o arquivo.

**Analogia:** uma página HTML é como um documento do Word em que, em vez de clicar em "título" ou "negrito", você escreve etiquetas ao redor do texto. O navegador lê as etiquetas e desenha a página.

**O esqueleto de toda página** tem sempre as mesmas partes: `<!DOCTYPE html>` (avisa que é HTML moderno), `<html lang="pt-BR">` (a página é em português do Brasil, o que ajuda leitores de tela), `<head>` (informações que não aparecem na página, como a codificação e o título da aba) e `<body>` (tudo o que aparece).

## Mão na Massa

### Passo 1: crie a imagem de exemplo

A imagem abaixo é um arquivo de texto (um SVG, que é um desenho descrito em código). Crie a pasta `imagens` na raiz do projeto: no painel **Explorer** (em português: **Explorador**), clique em **New Folder** (em português: **Nova Pasta**) e digite `imagens`. Dentro dela crie o arquivo `sem-foto.svg` com este conteúdo:

**Arquivo: `imagens/sem-foto.svg`** (arquivo novo, inteiro)

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 750" role="img" aria-label="Produto sem foto">
  <rect width="600" height="750" fill="#ece7ea"/>
  <rect x="150" y="250" width="300" height="220" rx="16" fill="none" stroke="#5d5365" stroke-width="8"/>
  <circle cx="230" cy="320" r="28" fill="#5d5365"/>
  <path d="M170 450 L260 360 L330 420 L380 370 L430 450 Z" fill="#5d5365"/>
  <text x="300" y="560" font-family="sans-serif" font-size="32" text-anchor="middle" fill="#2b2230">Sem foto</text>
</svg>
```


### Passo 2: crie a primeira página

Na raiz do projeto crie o arquivo `index.html` e cole o conteúdo abaixo. Salve com Ctrl+S (no Mac, Cmd+S).

**Arquivo: `index.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>VitrineCol</title>
</head>
<body>
  <h1>VitrineCol</h1>
  <p>Roupas das lojas do seu bairro, num só lugar.</p>
  <p>Aqui você vai poder escolher peças de várias lojas e combinar cada pedido pelo WhatsApp.</p>

  <img src="imagens/sem-foto.svg" alt="Ilustração de uma foto de produto que ainda não existe" width="300" height="375">

  <p><a href="https://github.com" target="_blank" rel="noopener">Conheça o GitHub, onde guardamos o código</a></p>
</body>
</html>
```


### Passo 3: abra com o Live Server

1. Com o `index.html` aberto no editor, clique no botão **Go Live** (em português: **Ir ao vivo**) no canto inferior direito do VS Code. Se preferir, clique com o botão direito no arquivo e escolha **Open with Live Server** (em português: **Abrir com Live Server**).
2. O navegador abre em um endereço parecido com `http://127.0.0.1:5500/index.html` e mostra a página.
3. **Teste a atualização automática:** volte ao VS Code, troque o texto de um parágrafo, salve e olhe o navegador: ele atualiza sozinho.

### Passo 4: faça experimentos curtos

Faça uma mudança de cada vez e observe o resultado no navegador:

1. Troque `<h1>` por `<h2>` (e o `</h1>` por `</h2>`): o título fica menor. Volte para `h1`.
2. Apague o valor do `alt` da imagem e salve. Nada muda na tela, mas um leitor de tela deixaria de descrever a imagem. Coloque o texto de volta.
3. Troque o endereço do `src` por `imagens/nao-existe.svg`: a imagem quebra e aparece o texto do `alt`. Volte para `imagens/sem-foto.svg`.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria a primeira página e a imagem de exemplo"
git push
```

## Explicação do Código

**index.html**

- `<!DOCTYPE html>`: primeira linha de toda página. Diz ao navegador que o arquivo usa o HTML atual.
- `<html lang="pt-BR">`: abre o documento e declara o idioma. Fecha na última linha (`</html>`).
- `<head>` ... `</head>`: parte "de bastidores".
- `<meta charset="UTF-8">`: define a codificação dos caracteres. Sem ela, acentos como "ã" e "ç" podem aparecer errados.
- `<meta name="viewport" content="width=device-width, initial-scale=1">`: faz a página se ajustar à largura do celular. Vamos usar isso no Dia 5.
- `<title>VitrineCol</title>`: texto que aparece na aba do navegador.
- `<body>` ... `</body>`: tudo o que a pessoa vê.
- `<h1>`: o título principal. Cada página deve ter **um único** `h1`.
- `<p>`: um parágrafo.
- `<img src="..." alt="..." width="300" height="375">`: uma imagem. `src` é o caminho do arquivo, **`alt`** é o texto que descreve a imagem (para quem não enxerga e para quando a imagem não carrega), `width` e `height` reservam o espaço da imagem para a página não "pular" ao carregar. A tag `img` não tem fechamento.
- `<a href="..." target="_blank" rel="noopener">`: um link. `href` é o destino; `target="_blank"` abre em uma nova aba; `rel="noopener"` é uma proteção de segurança para links que abrem em nova aba.

**sem-foto.svg**: um desenho feito com retângulo, círculo e um caminho (`path`), mais o texto "Sem foto". Será a imagem mostrada quando um produto não tiver foto.

## Validação

1. A página abre pelo Live Server, com título, dois parágrafos, a imagem e o link.
2. A aba do navegador mostra o texto "VitrineCol".
3. Ao salvar uma mudança no arquivo, o navegador atualiza sozinho.
4. `git log --oneline` mostra o novo commit, e o GitHub mostra `index.html` e a pasta `imagens`.

**Erros comuns**

1. *Sintoma:* acentos aparecem estranhos (por exemplo `Ã§`). *Causa:* faltou a linha `<meta charset="UTF-8">` ou o arquivo foi salvo em outra codificação. *Correção:* confira a linha e salve como UTF-8 (no canto inferior direito do VS Code aparece **UTF-8**).
2. *Sintoma:* a imagem aparece quebrada, com um ícone de página rasgada. *Causa:* o caminho do `src` está errado ou a pasta/arquivo tem outro nome. *Correção:* confira se a pasta se chama `imagens` e o arquivo `sem-foto.svg`, tudo em minúsculas, sem espaços.
3. *Sintoma:* parte da página sumiu ou ficou toda em negrito. *Causa:* uma tag foi aberta e não foi fechada (por exemplo `<p>` sem `</p>`). *Correção:* confira se cada tag que abre tem a sua que fecha.
4. *Sintoma:* o botão **Go Live** (em português: **Ir ao vivo**) não aparece. *Causa:* a extensão Live Server não está instalada ou nenhuma pasta está aberta. *Correção:* refaça o Passo 1 da Aula 2 e abra a pasta `vitrine-col`.

**Se travar**

1. Aperte F12 no navegador e olhe a aba **Console** (em português: **Console**): erros de arquivo não encontrado aparecem lá em vermelho.
2. Compare o seu `index.html` com o da aula, linha por linha.
3. Veja o que mudou com `git status`; se estragou o arquivo, volte ao último commit com `git restore index.html`.
4. Só depois peça ajuda à sua equipe, dizendo o arquivo, a linha e o que você já tentou.

**Seu projeto agora tem**

- `README.md`, `.gitignore` (Aula 2).
- `index.html`: uma página simples (será reescrita nas próximas aulas).
- `imagens/sem-foto.svg`: a imagem padrão de produto sem foto.
- O Live Server abrindo a página e atualizando ao salvar.

**Como saber que deu certo:** você troca um texto no `index.html`, salva, e o navegador mostra a mudança sem você apertar nada.
