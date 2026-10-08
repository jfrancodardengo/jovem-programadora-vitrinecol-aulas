# Aula 8 – Listas e formulários HTML: campos, rótulos e botões

**Dia 3 · Qui 08/10/2026** · **Aula 8** · **UC3**

- **Requisitos cobertos:** apenas a estrutura de RF-02 (filtrar o catálogo por tipo de roupa), RF-03 (filtrar por loja), RF-13 (entrar na conta) e RF-05 (campo de busca pelo nome)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** index.html semântica com cabeçalho, menu e rodapé prontos para copiar (Aula 7)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar duas páginas com formulários: `login.html` (entrar) e `catalogo.html` (filtros do catálogo), usando **listas**, `form`, `label`, `input`, `select` e `button`, com **todo campo ligado ao seu rótulo**.

**Abertura (10 minutos).** Retomada da Aula 7: o `index.html` tem um cabeçalho e um rodapé que serão copiados para todas as páginas. Hoje criamos as duas primeiras páginas novas. Abra o wireframe do **Login** e do **Catálogo** (Aula 4) e liste os campos que cada um precisa.

## O Conceito

**Termos desta aula**

- **Formulário (`form`)**: a região da página onde a pessoa preenche informações e envia.
- **Campo (`input`, `select`)**: o espaço onde a pessoa digita ou escolhe. O `type` do `input` muda o comportamento: `email` pede um e-mail, `password` esconde a senha, `search` é uma caixa de busca.
- **Rótulo (`label`)**: o texto que diz o que o campo é. É **obrigatório** ligá-lo ao campo: o `for` do rótulo e o `id` do campo têm o mesmo valor. Assim, ao clicar no rótulo, o campo é focado, e o leitor de tela diz o nome do campo.
- **Botão (`button`)**: `type="submit"` envia o formulário; `type="button"` é um botão comum que só faz algo quando o JavaScript mandar.

**Analogia:** o formulário em papel de uma clínica: cada linha tem um nome ("Nome:", "Telefone:") e um espaço para escrever. Se faltar o nome, ninguém sabe o que preencher. O `label` é esse nome impresso.

**Listas:** `ul` (lista com marcadores) e `li` (cada item). O menu de navegação já é uma lista. Os chips de tipo de roupa também serão: uma lista de botões.

## Mão na Massa

### Passo 1: crie o login.html

Crie o arquivo na raiz do projeto e cole:

**Arquivo: `login.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Entrar – VitrineCol</title>
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho">
    <div class="container cabecalho-conteudo">
      <a class="logotipo" href="index.html">VitrineCol</a>
      <nav aria-label="Principal">
        <ul class="menu">
          <li><a href="index.html">Início</a></li>
          <li><a href="catalogo.html">Catálogo</a></li>
          <li><a href="sacola.html">Sacola</a></li>
          <li><a href="login.html" aria-current="page">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <div class="cartao-formulario">
      <h1>Entrar</h1>
      <form class="formulario" id="formulario-login" novalidate>
        <div class="campo">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" autocomplete="email" required>
        </div>
        <div class="campo">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" autocomplete="current-password" required>
        </div>
        <button type="submit" class="botao">Entrar</button>
      </form>
      <p><a href="recuperar-senha.html">Esqueci minha senha</a></p>
      <p>Ainda não tem conta? <a href="cadastro.html" id="link-cadastro">Cadastre-se</a>.</p>
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
</body>
</html>
```


### Passo 2: crie o catalogo.html

**Arquivo: `catalogo.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Catálogo – VitrineCol</title>
  <meta name="description" content="Todas as roupas das lojas locais: filtre por tipo, tamanho e loja.">
</head>
<body>
  <a class="link-pular" href="#conteudo">Ir para o conteúdo</a>
  <header class="cabecalho" id="cabecalho">
    <div class="container cabecalho-conteudo">
      <a class="logotipo" href="index.html">VitrineCol</a>
      <nav aria-label="Principal">
        <ul class="menu">
          <li><a href="index.html">Início</a></li>
          <li><a href="catalogo.html" aria-current="page">Catálogo</a></li>
          <li><a href="sacola.html">Sacola</a></li>
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <h1>Catálogo</h1>

    <form class="filtros" aria-label="Filtros do catálogo">
      <div class="campo">
        <label for="busca">Buscar pelo nome</label>
        <input type="search" id="busca" name="busca" placeholder="Ex.: vestido">
      </div>

      <div class="filtros-campos">
        <div class="campo">
          <label for="filtro-loja">Loja</label>
          <select id="filtro-loja" name="loja">
            <option value="">Todas</option>
            <option>Loja Exemplo</option>
            <option>Loja do Bairro</option>
          </select>
        </div>
        <div class="campo">
          <label for="filtro-tamanho">Tamanho</label>
          <select id="filtro-tamanho" name="tamanho">
            <option value="">Todos</option>
            <option>P</option>
            <option>M</option>
            <option>G</option>
            <option>GG</option>
            <option>38</option>
            <option>40</option>
            <option>42</option>
          </select>
        </div>
      </div>

      <div>
        <p class="legenda" id="rotulo-categorias">Tipo de roupa</p>
        <ul class="chips" id="chips-categorias" aria-labelledby="rotulo-categorias">
          <li><button type="button" class="chip" aria-pressed="true">Todas</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Blusas</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Camisetas</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Vestidos</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Calças</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Saias</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Shorts</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Jaquetas</button></li>
          <li><button type="button" class="chip" aria-pressed="false">Acessórios</button></li>
        </ul>
      </div>
    </form>

    <section aria-labelledby="titulo-produtos">
      <h2 id="titulo-produtos" class="visualmente-oculto">Produtos</h2>
      <ul class="grade-produtos" id="lista-produtos"></ul>
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
</body>
</html>
```


### Passo 3: confira no Live Server

1. Abra `login.html` e `catalogo.html` pelo Live Server (botão **Go Live**, em português: **Ir ao vivo**, ou clique direito > **Open with Live Server**, em português: **Abrir com Live Server**).
2. No login, **clique no texto "E-mail"**: o cursor deve ir para o campo de e-mail. Se isso acontece, o `label` está ligado ao campo.
3. No campo de senha, digite algo: os caracteres aparecem escondidos.
4. No catálogo, abra a lista **Loja** e a lista **Tamanho** e escolha uma opção.
5. Os chips de tipo de roupa aparecem como botões comuns, sem estilo. A lista de produtos ainda está vazia (os cards entram na próxima aula).

### Passo 4: faça experimentos

1. Apague `for="email"` do primeiro `label` e salve. Clique no texto "E-mail": o campo **não** é mais focado. Desfaça.
2. Troque `type="password"` por `type="text"`: a senha fica visível. Desfaça.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Cria os formulários de login e de filtros do catálogo"
git push
```

## Explicação do Código

**login.html**

- `<form class="formulario" id="formulario-login" novalidate>`: o formulário. `id` identifica este formulário para o JavaScript. `novalidate` desliga as mensagens automáticas do navegador, porque na Aula 21 vamos escrever as nossas, em português e ao lado de cada campo.
- `<div class="campo">`: uma caixinha para agrupar rótulo e campo (o CSS vai alinhar).
- `<label for="email">E-mail</label>` e `<input type="email" id="email" name="email" autocomplete="email" required>`: o `for` e o `id` têm o mesmo valor (`email`), e é isso que liga os dois. `name` é o nome do campo quando o formulário é enviado. `autocomplete="email"` deixa o navegador sugerir o e-mail salvo. `required` marca o campo como obrigatório.
- `<input type="password" ... autocomplete="current-password">`: senha escondida; `current-password` avisa ao navegador que é a senha atual (ele pode preencher sozinho).
- `<button type="submit" class="botao">Entrar</button>`: envia o formulário.
- Os dois parágrafos abaixo do formulário têm links: **Esqueci minha senha** (a página `recuperar-senha.html` será criada no Dia 13) e **Cadastre-se** (`cadastro.html`, na Aula 15).

**catalogo.html**

- `<meta name="description" ...>`: resumo da página que aparece em buscadores.
- `<form class="filtros" aria-label="Filtros do catálogo">`: o formulário de filtros. `aria-label` dá um nome a ele para os leitores de tela.
- `<input type="search" id="busca" name="busca" placeholder="Ex.: vestido">`: campo de busca pelo nome (RF-05). `placeholder` é uma dica que some ao digitar. Ele ainda não faz nada: ganha vida mais adiante.
- `<select id="filtro-loja">` com `<option>`: lista suspensa. `value=""` na opção "Todas" quer dizer "sem filtro". Há duas lojas de exemplo.
- `<select id="filtro-tamanho">`: tamanhos de roupa (P, M, G, GG) e de calçado/numeração (38, 40, 42).
- `<p class="legenda" id="rotulo-categorias">` e `<ul class="chips" id="chips-categorias" aria-labelledby="rotulo-categorias">`: o tipo de roupa é uma **lista de botões** (os chips). O `aria-labelledby` liga a lista ao texto "Tipo de roupa".
- `<button type="button" class="chip" aria-pressed="true">`: `type="button"` porque este botão **não envia** formulário. `aria-pressed` diz ao leitor de tela se o botão está escolhido: `true` no "Todas".
- `<ul class="grade-produtos" id="lista-produtos"></ul>`: a lista (vazia) onde os cards de produto vão entrar. O título `h2` desta seção usa a classe `visualmente-oculto`: ele existe para leitores de tela, e o CSS da Aula 14 o esconde da vista.

## Validação

1. As duas páginas abrem pelo Live Server e mostram os formulários.
2. Clicar em cada rótulo do login coloca o cursor no campo certo.
3. Todo campo de `catalogo.html` tem um rótulo: **Buscar pelo nome**, **Loja**, **Tamanho** (e o texto "Tipo de roupa" para os chips).
4. Use Tab para percorrer o formulário do catálogo: o foco passa por todos os campos e botões na ordem.

**Erros comuns**

1. *Sintoma:* clicar no rótulo não foca o campo. *Causa:* o `for` do `label` e o `id` do campo são diferentes (por exemplo `for="e-mail"` e `id="email"`). *Correção:* deixe os dois idênticos.
2. *Sintoma:* ao clicar em um chip, a página recarrega ou muda de endereço. *Causa:* o botão ficou com `type="submit"` (o padrão dentro de um `form`). *Correção:* use `type="button"` nos botões que não enviam.
3. *Sintoma:* dois campos com o mesmo `id="email"` na mesma página. *Causa:* cópia sem renomear. *Correção:* cada `id` é único na página.
4. *Sintoma:* as opções do `select` aparecem todas na mesma linha. *Causa:* o `</option>` ficou sem a tag de abertura ou há uma tag a mais. *Correção:* uma `option` por linha, cada uma entre `<option>` e `</option>`.

**Se travar**

1. Aperte F12 e veja o **Console** (em português: **Console**); depois use a aba **Elements** (em português: **Elementos**) para ver como o navegador interpretou o HTML.
2. Compare o seu arquivo com o da aula, procurando uma aspa `"` que falta.
3. Desfaça com `git status` e `git restore nome-do-arquivo`, se um arquivo existente foi estragado.
4. Só depois peça ajuda à sua equipe, dizendo o arquivo e a linha.

**Seu projeto agora tem**

- `index.html`, `login.html` e `catalogo.html` (estáticas, sem CSS), `imagens/sem-foto.svg`, `README.md` e `.gitignore`.
- Um formulário de login e um formulário de filtros com todos os campos rotulados.

**Como saber que deu certo:** você consegue preencher o login só com o teclado e, ao clicar em qualquer rótulo, o campo certo recebe o foco.
