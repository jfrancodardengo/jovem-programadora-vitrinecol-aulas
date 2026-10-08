# Aula 7 – HTML semântico: header, main, section e footer

**Dia 3 · Qui 08/10/2026** · **Aula 7** · **UC3**

- **Requisitos cobertos:** não se aplica (base de acessibilidade de todas as telas; RNF de teclado e leitor de tela)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** index.html simples e imagens/sem-foto.svg, abertos pelo Live Server e versionados (Aula 3); wireframes e protótipo (Aulas 4 a 6)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai reescrever o `index.html` usando **HTML semântico** (`header`, `nav`, `main`, `section`, `footer`), com um único `h1`, texto alternativo em toda imagem e um **cabeçalho e rodapé comuns** que serão copiados para todas as páginas.

**Abertura (10 minutos).** Retomada da Aula 3: a sua primeira página tem só `h1`, `p`, `img` e `a`. Abra-a no Live Server e, com a tecla Tab, navegue por ela. Hoje a página ganha uma **estrutura** com "regiões" (cabeçalho, menu, conteúdo, rodapé) que leitores de tela e o próprio navegador entendem. Antes de começar, dê uma olhada no wireframe da Aula 4: o cabeçalho com o menu aparece em todas as telas.

## O Conceito

**Termos desta aula**

- **HTML semântico**: usar a tag que **significa** o que o conteúdo é (`header` para o cabeçalho, `nav` para o menu), em vez de colocar tudo em caixas sem significado (`div`).
- **Landmark (região)**: uma área da página que leitores de tela reconhecem e deixam a pessoa "pular" para ela: cabeçalho, menu, conteúdo principal e rodapé.
- **Texto alternativo (`alt`)**: o texto que descreve uma imagem para quem não a enxerga.
- **Link para pular ao conteúdo**: o primeiro link da página ("Ir para o conteúdo"). Quem navega só pelo teclado aperta Enter nele e não precisa passar pelo menu de novo em todas as páginas.

**Analogia:** é como a planta de um prédio com as placas "Recepção", "Escada", "Salão" e "Saída". Uma pessoa que não enxerga bem usa as placas para se orientar; sem elas, só existe um corredor enorme.

**Regras do projeto para toda página:** um (e só um) `h1`; as demais partes usam `h2`, `h3` em ordem; toda `img` com `alt`; o idioma declarado em `lang="pt-BR"`.

## Mão na Massa

### Passo 1: substitua o conteúdo do index.html

O arquivo inteiro vira o modelo abaixo. Salve com Ctrl+S (no Mac, Cmd+S).

**Arquivo: `index.html`** (arquivo inteiro: apague todo o conteúdo atual e cole este)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>VitrineCol</title>
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho">
    <div class="container cabecalho-conteudo">
      <a class="logotipo" href="index.html">VitrineCol</a>
      <nav aria-label="Principal">
        <ul class="menu">
          <li><a href="index.html" aria-current="page">Início</a></li>
          <li><a href="catalogo.html">Catálogo</a></li>
          <li><a href="sacola.html">Sacola</a></li>
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <h1>VitrineCol</h1>
    <p>Roupas das lojas do seu bairro, num só lugar.</p>

    <section aria-labelledby="titulo-como">
      <h2 id="titulo-como">Como funciona</h2>
      <p>Escolha peças de várias lojas, junte tudo na mesma sacola e combine cada pedido direto com a loja pelo WhatsApp.</p>
      <img src="imagens/sem-foto.svg" alt="Ilustração de uma foto de produto que ainda não existe" width="300" height="375">
    </section>

    <section aria-labelledby="titulo-lojistas">
      <h2 id="titulo-lojistas">Tem uma loja de roupas?</h2>
      <p>Cadastre a sua loja e os seus produtos, com até 5 fotos cada, e receba os pedidos das clientes do bairro.</p>
      <p><a href="cadastro.html">Quero vender na VitrineCol</a></p>
    </section>
  </main>

  <footer class="rodape">
    <div class="container">
      <ul class="rodape-links">
        <li><a href="catalogo.html">Catálogo</a></li>
        <li><a href="privacidade.html">Aviso de privacidade</a></li>
        <li><a href="meus-pedidos.html">Meus pedidos</a></li>
        <li><a href="painel-loja.html">Painel da loja</a></li>
      </ul>
      <p>Projeto integrador – Jovem Programadora (Senac). Pagamento e entrega são combinados direto com a loja.</p>
    </div>
  </footer>
</body>
</html>
```


### Passo 2: veja a página no Live Server

Ainda não há CSS, então a página parece simples. Confira:

1. O menu aparece como uma lista de links.
2. Aperte **Tab** algumas vezes: o primeiro foco vai para "Ir para o conteúdo" (um link que só vai ganhar visual nas próximas aulas); depois passa pelo logotipo e pelos links do menu.
3. Os links do menu (Catálogo, Sacola, Entrar...) apontam para páginas que ainda **não existem**. Isso é esperado: elas nascem nas próximas aulas.

### Passo 3: confira a estrutura com o painel de Outline do VS Code

No VS Code, abra o painel **Outline** (em português: **Estrutura de tópicos**), na barra lateral do Explorer. Ele lista as regiões do HTML. Confira se existe um `h1` e dois `h2`. Se não aparecer, abra o menu **View > Open View...** (em português: **Exibir > Abrir Modo de Exibição...**) e escolha **Outline**.

### Passo 4: faça um experimento

Troque temporariamente a tag `<main>` por `<div>` (nas duas pontas) e abra o Outline de novo: a região principal desaparece. Para um leitor de tela é como se o conteúdo principal não existisse. Desfaça (Ctrl+Z, ou Cmd+Z no Mac).

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Reescreve a página inicial com HTML semântico"
git push
```

## Explicação do Código

- `<a class="link-pular" href="#conteudo">`: link interno (o `#` leva ao elemento que tem esse `id`). Foi colocado **antes** do menu, para ser o primeiro foco do teclado. O atributo `class` dá um nome a este elemento para o CSS usar no Dia 4.
- `<header class="cabecalho" id="cabecalho">`: o cabeçalho da página. Dentro dele ficam o logotipo e o menu.
- `<div class="container cabecalho-conteudo">`: aqui `div` é correto, porque é só uma caixa para organizar o layout (sem significado).
- `<a class="logotipo" href="index.html">`: o logotipo é um link para a página inicial.
- `<nav aria-label="Principal">`: a região de navegação. O `aria-label` dá um nome para o leitor de tela dizer "navegação principal".
- `<ul class="menu">` e `<li>`: o menu é uma **lista**, porque é um conjunto de links.
- `aria-current="page"`: marca o link da página em que a pessoa está. O CSS e o leitor de tela usam isso para destacar "você está aqui".
- `<main id="conteudo" class="container">`: o conteúdo principal, **único** na página. O `id="conteudo"` é o destino do link para pular.
- `<section aria-labelledby="titulo-como">`: um bloco de conteúdo com um tema. `aria-labelledby` liga a seção ao seu título (`<h2 id="titulo-como">`), dando nome à região.
- `<footer class="rodape">`: o rodapé, com links úteis e um aviso do projeto.
- `id` versus `class`: o `id` é único na página e identifica **um** elemento (ex.: `id="conteudo"`); a `class` pode se repetir em vários elementos.

## Validação

1. O `index.html` abre pelo Live Server sem erros e mostra cabeçalho, conteúdo e rodapé.
2. O painel **Outline** (em português: **Estrutura de tópicos**) mostra um `h1` e dois `h2`.
3. A tecla Tab chega primeiro no link "Ir para o conteúdo".
4. Toda imagem tem `alt`. Procure `<img` no arquivo (Ctrl+F) e confira.

**Erros comuns**

1. *Sintoma:* a página tem dois `h1`. *Causa:* o título do site e o título da página foram marcados como `h1`. *Correção:* só o título da página é `h1`; o nome do site no cabeçalho é um link (`a`).
2. *Sintoma:* o menu aparece com bolinhas e colado ao canto. *Causa:* é o visual padrão de uma lista, sem CSS. *Correção:* nada a fazer agora; o CSS entra no Dia 4.
3. *Sintoma:* o link para pular o conteúdo não faz nada. *Causa:* o `href` do link e o `id` do `main` são diferentes (por exemplo `#conteudo` e `id="conteúdo"`). *Correção:* os dois precisam ter a mesma grafia, sem acento.
4. *Sintoma:* parte da página sumiu. *Causa:* uma tag não foi fechada (por exemplo, falta `</section>`). *Correção:* confira se cada tag que abre tem a sua que fecha, usando a indentação como guia.

**Se travar**

1. Abra o Console (F12 > **Console**, em português: **Console**) e veja se há erros.
2. Compare o seu arquivo com o da aula, de cima para baixo, procurando uma tag que sobra ou falta.
3. Veja o que mudou com `git status` e, se precisar, desfaça com `git restore index.html`.
4. Só depois peça ajuda à sua equipe, dizendo a linha e o que você já tentou.

**Seu projeto agora tem**

- `index.html` semântica (provisória: será trocada pela vitrine no Dia 14), `imagens/sem-foto.svg`, `README.md` e `.gitignore`.
- Um cabeçalho e um rodapé prontos para serem copiados para as outras páginas.

**Como saber que deu certo:** o Outline do VS Code mostra as regiões e um único `h1`, e o primeiro foco do teclado vai para "Ir para o conteúdo".
