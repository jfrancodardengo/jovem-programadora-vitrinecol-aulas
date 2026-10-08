# Aula 15 – Revisão e fechamento do front-end estático (versão 0.1)

**Dia 5 · Ter 13/10/2026** · **Aula 15** · **UC3**

- **Requisitos cobertos:** apenas a estrutura de RF-09 (sacola com peças de várias lojas), RF-12 (cadastro), RF-15 (editar a própria loja), RF-16 (cadastrar produto), RF-17 (editar produto) e RF-19 (campos de fotos, na Aula 33)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** quatro arquivos CSS completos e ligados às páginas catalogo, loja, produto, login e index (Aulas 10 a 14); páginas responsivas

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai montar a estrutura das **telas seguintes** (cadastro, sacola, minha loja, meus produtos e formulário de produto) usando os componentes que já existem, revisar a **acessibilidade básica** e marcar a **versão 0.1** no Git.

**Abertura (10 minutos).** Retomada da Aula 14: o CSS está pronto para o que existe. Hoje criamos o resto das telas **estáticas** do projeto (sem JavaScript e com dados de exemplo). Antes de começar, confira no Kanban quais cartões Essenciais dizem respeito a estas telas (RF-12, RF-15, RF-16, RF-17) e arraste-os para **In Progress** (em português: **Em andamento**).

## O Conceito

**Termos desta aula**

- **Tabela (`table`)**: uma grade de linhas (`tr`) e colunas, com células de cabeçalho (`th`) e de dados (`td`). Use tabela só para **dados em colunas**, como a lista de produtos da lojista.
- **`scope="col"`**: diz que o `th` é cabeçalho de uma **coluna** (ajuda os leitores de tela).
- **Tag do Git**: um "marcador" colocado em um commit para dizer "esta é a versão 0.1". Fica no histórico para sempre.
- **Revisão de acessibilidade**: uma lista de conferência para garantir que qualquer pessoa consegue usar a página, com teclado, leitor de tela ou baixa visão.

**Analogia:** a tag é o carimbo "Edição 1" na capa de um livro. Mesmo se você escrever uma edição nova, a primeira continua guardada.

**Por que estas telas já têm conteúdo de exemplo?** Para o CSS ser testado agora. Nos próximos dias, o JavaScript vai trocar esses exemplos pelos dados reais.

## Mão na Massa

### Passo 1: crie as cinco páginas

Crie cada arquivo na raiz do projeto e cole o conteúdo. Salve com Ctrl+S (no Mac, Cmd+S).

**Arquivo: `cadastro.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cadastrar – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
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
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html" aria-current="page">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <div class="cartao-formulario">
      <h1>Cadastrar</h1>
      <form class="formulario" id="formulario-cadastro" novalidate>
        <div class="campo">
          <label for="nome">Nome</label>
          <input type="text" id="nome" name="nome" autocomplete="name" required>
        </div>
        <div class="campo">
          <label for="email">E-mail</label>
          <input type="email" id="email" name="email" autocomplete="email" required>
        </div>
        <div class="campo">
          <label for="senha">Senha</label>
          <input type="password" id="senha" name="senha" autocomplete="new-password" minlength="6" required aria-describedby="ajuda-senha">
          <p class="campo-ajuda" id="ajuda-senha">Use pelo menos 6 caracteres.</p>
        </div>
        <div class="campo">
          <label for="telefone">Telefone com DDD (opcional)</label>
          <input type="tel" id="telefone" name="telefone" autocomplete="tel-national" inputmode="numeric" placeholder="27 99999-9999" aria-describedby="ajuda-telefone">
          <p class="campo-ajuda" id="ajuda-telefone">Com DDD, por exemplo 27 99999-9999. A loja usa para avisar você pelo WhatsApp.</p>
        </div>
        <fieldset class="campo">
          <legend>Quero me cadastrar como</legend>
          <div class="opcoes">
            <label class="opcao"><input type="radio" name="perfil" value="cliente" checked> Cliente</label>
            <label class="opcao"><input type="radio" name="perfil" value="lojista"> Lojista</label>
          </div>
          <p class="campo-ajuda">O perfil não pode ser trocado depois.</p>
        </fieldset>
        <button type="submit" class="botao">Criar conta</button>
      </form>
      <p>Já tem conta? <a href="login.html" id="link-login">Entrar</a>.</p>
      <p class="campo-ajuda">Coletamos só nome, e-mail e telefone opcional. Veja o <a href="privacidade.html">aviso de privacidade</a>.</p>
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


**Arquivo: `sacola.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sacola – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
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
          <li><a href="sacola.html" aria-current="page">Sacola</a></li>
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <div class="sacola-layout">
      <h1 id="titulo-sacola" tabindex="-1">Sacola</h1>

      <!-- A sacola em si: itens por loja, total e o botão de finalizar -->
      <section id="sacola-conteudo" aria-label="Itens da sacola">
        <p class="texto-suave" id="explicacao-sacola">Cada loja recebe um pedido separado. O combinado de pagamento e entrega é feito pelo WhatsApp da loja.</p>
        <div id="grupos-sacola">
          <section class="sacola-loja" aria-labelledby="loja-1">
            <h2 id="loja-1"><a href="loja.html">Loja Exemplo</a></h2>
            <ul class="sacola-itens">
              <li class="sacola-item">
                <img src="imagens/exemplo-1.svg" alt="Foto de Vestido midi floral" width="600" height="750">
                <div>
                  <p class="sacola-item-nome">Vestido midi floral – tamanho M</p>
                  <p>R$ 129,90 cada</p>
                  <div class="sacola-item-controles">
                    <label for="quantidade-1">Quantidade</label>
                    <input id="quantidade-1" type="number" min="1" step="1" value="1">
                    <button type="button" class="botao botao-perigo botao-pequeno">Remover</button>
                  </div>
                </div>
              </li>
            </ul>
            <p class="sacola-subtotal">Subtotal da loja: R$ 129,90</p>
          </section>
          <section class="sacola-loja" aria-labelledby="loja-2">
            <h2 id="loja-2"><a href="loja.html">Loja do Bairro</a></h2>
            <ul class="sacola-itens">
              <li class="sacola-item">
                <img src="imagens/exemplo-3.svg" alt="Foto de Calça jeans reta" width="600" height="750">
                <div>
                  <p class="sacola-item-nome">Calça jeans reta – tamanho 40</p>
                  <p>R$ 159,90 cada</p>
                  <div class="sacola-item-controles">
                    <label for="quantidade-2">Quantidade</label>
                    <input id="quantidade-2" type="number" min="1" step="1" value="1">
                    <button type="button" class="botao botao-perigo botao-pequeno">Remover</button>
                  </div>
                </div>
              </li>
            </ul>
            <p class="sacola-subtotal">Subtotal da loja: R$ 159,90</p>
          </section>
        </div>

        <div id="rodape-sacola">
          <p class="sacola-total" id="total-sacola">Total: R$ 289,80</p>
          <button type="button" class="botao botao-largo" id="botao-finalizar">Finalizar sacola (2 pedidos)</button>
        </div>
      </section>

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


**Arquivo: `painel-loja.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Minha loja – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
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
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <nav aria-label="Painel da lojista">
      <ul class="navegacao-painel">
        <li><a href="painel-loja.html" aria-current="page">Minha loja</a></li>
        <li><a href="painel-produtos.html">Meus produtos</a></li>
        <li><a href="painel-pedidos.html">Pedidos recebidos</a></li>
      </ul>
    </nav>

    <div class="cartao-formulario">
      <h1>Minha loja</h1>
      <form class="formulario" id="formulario-loja" novalidate>
        <div class="campo">
          <label for="nome-loja">Nome da loja</label>
          <input type="text" id="nome-loja" name="nome" required>
        </div>
        <div class="campo">
          <label for="descricao-loja">Descrição (opcional)</label>
          <textarea id="descricao-loja" name="descricao"></textarea>
        </div>
        <div class="campo">
          <label for="endereco-loja">Endereço</label>
          <input type="text" id="endereco-loja" name="endereco" autocomplete="street-address" required>
        </div>
        <div class="campo">
          <label for="cidade-loja">Cidade</label>
          <input type="text" id="cidade-loja" name="cidade" required>
        </div>
        <div class="campo">
          <label for="whatsapp-loja">WhatsApp da loja</label>
          <input type="tel" id="whatsapp-loja" name="whatsapp" placeholder="27 99999-9999" required aria-describedby="ajuda-whatsapp">
          <p class="campo-ajuda" id="ajuda-whatsapp">Com DDD, por exemplo 27 99999-9999. O sistema guarda só os números e acrescenta o código 55 do Brasil.</p>
        </div>
        <div class="campo">
          <label for="mapa-loja">Link do mapa (opcional)</label>
          <input type="url" id="mapa-loja" name="link_mapa" placeholder="https://maps.google.com/..." aria-describedby="ajuda-mapa">
          <p class="campo-ajuda" id="ajuda-mapa">Copie o link da loja no Google Maps. Ele deve começar com https://.</p>
        </div>
        <button type="submit" class="botao">Salvar loja</button>
      </form>
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


**Arquivo: `painel-produtos.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Meus produtos – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
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
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <nav aria-label="Painel da lojista">
      <ul class="navegacao-painel">
        <li><a href="painel-loja.html">Minha loja</a></li>
        <li><a href="painel-produtos.html" aria-current="page">Meus produtos</a></li>
        <li><a href="painel-pedidos.html">Pedidos recebidos</a></li>
      </ul>
    </nav>

    <h1>Meus produtos</h1>

    <p class="painel-acoes" id="acoes-produtos">
      <a class="botao" href="painel-produto-form.html">Cadastrar produto</a>
    </p>

    <table class="tabela" id="tabela-produtos" role="table">
      <caption class="visualmente-oculto">Lista dos produtos da loja</caption>
      <thead role="rowgroup">
        <tr role="row">
          <th scope="col" role="columnheader">Produto</th>
          <th scope="col" role="columnheader">Categoria</th>
          <th scope="col" role="columnheader">Preço</th>
          <th scope="col" role="columnheader">Situação</th>
          <th scope="col" role="columnheader">Ações</th>
        </tr>
      </thead>
      <tbody id="lista-produtos-painel" role="rowgroup">
        <tr role="row">
          <td data-rotulo="Produto" role="cell">Vestido midi floral</td>
          <td data-rotulo="Categoria" role="cell">Vestidos</td>
          <td data-rotulo="Preço" role="cell">R$ 129,90</td>
          <td data-rotulo="Situação" role="cell"><span class="selo selo-confirmado">Ativo</span></td>
          <td data-rotulo="Ações" role="cell">
            <div class="tabela-acoes">
              <a class="botao botao-secundario botao-pequeno" href="painel-produto-form.html">Editar<span class="visualmente-oculto"> (Vestido midi floral)</span></a>
              <button type="button" class="botao botao-pequeno botao-secundario">Desativar<span class="visualmente-oculto"> (Vestido midi floral)</span></button>
              <button type="button" class="botao botao-pequeno botao-perigo">Excluir<span class="visualmente-oculto"> (Vestido midi floral)</span></button>
            </div>
          </td>
        </tr>
        <tr role="row">
          <td data-rotulo="Produto" role="cell">Camiseta básica branca</td>
          <td data-rotulo="Categoria" role="cell">Camisetas</td>
          <td data-rotulo="Preço" role="cell">R$ 49,90</td>
          <td data-rotulo="Situação" role="cell"><span class="selo selo-concluido">Inativo</span></td>
          <td data-rotulo="Ações" role="cell">
            <div class="tabela-acoes">
              <a class="botao botao-secundario botao-pequeno" href="painel-produto-form.html">Editar<span class="visualmente-oculto"> (Camiseta básica branca)</span></a>
              <button type="button" class="botao botao-pequeno botao-secundario">Ativar<span class="visualmente-oculto"> (Camiseta básica branca)</span></button>
              <button type="button" class="botao botao-pequeno botao-perigo">Excluir<span class="visualmente-oculto"> (Camiseta básica branca)</span></button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
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


**Arquivo: `painel-produto-form.html`** (arquivo novo, inteiro)

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Cadastrar ou editar produto – VitrineCol</title>
  <link rel="stylesheet" href="css/variaveis.css">
  <link rel="stylesheet" href="css/base.css">
  <link rel="stylesheet" href="css/componentes.css">
  <link rel="stylesheet" href="css/paginas.css">
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
          <li><a href="login.html">Entrar</a></li>
          <li><a href="cadastro.html">Cadastrar</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="conteudo" class="container">
    <nav aria-label="Painel da lojista">
      <ul class="navegacao-painel">
        <li><a href="painel-loja.html">Minha loja</a></li>
        <li><a href="painel-produtos.html" aria-current="page">Meus produtos</a></li>
        <li><a href="painel-pedidos.html">Pedidos recebidos</a></li>
      </ul>
    </nav>

    <div class="cartao-formulario cartao-formulario-largo">
      <h1 id="titulo-pagina">Cadastrar produto</h1>

      <form class="formulario" id="formulario-produto" novalidate>
        <div class="campo">
          <label for="nome-produto">Nome</label>
          <input type="text" id="nome-produto" name="nome" required>
        </div>
        <div class="campo">
          <label for="descricao-produto">Descrição (opcional)</label>
          <textarea id="descricao-produto" name="descricao"></textarea>
        </div>
        <div class="campo">
          <label for="categoria-produto">Categoria</label>
          <select id="categoria-produto" name="categoria" required>
            <option value="">Escolha uma categoria</option>
          </select>
        </div>
        <div class="campo">
          <label for="preco-produto">Preço (R$)</label>
          <input type="number" id="preco-produto" name="preco" min="0.01" step="0.01" inputmode="decimal" required>
        </div>

        <fieldset class="campo">
          <legend>Tamanhos e estoque</legend>
          <div id="linhas-tamanhos">
            <div class="linha-tamanho" role="group" aria-label="Tamanho e estoque, linha 1">
              <div class="campo">
                <label for="tamanho-1">Tamanho</label>
                <input id="tamanho-1" type="text" list="sugestoes-tamanhos" required>
              </div>
              <div class="campo">
                <label for="estoque-1">Estoque</label>
                <input id="estoque-1" type="number" min="0" step="1" value="0" required>
              </div>
              <button type="button" class="botao botao-perigo botao-pequeno">Remover tamanho</button>
            </div>
          </div>
          <button type="button" class="botao botao-secundario botao-pequeno" id="adicionar-tamanho">Adicionar tamanho</button>
          <p class="campo-ajuda">Use estoque 0 para o tamanho que acabou: ele aparece sem estoque para as clientes.</p>
          <datalist id="sugestoes-tamanhos">
            <option value="P"></option>
            <option value="M"></option>
            <option value="G"></option>
            <option value="GG"></option>
            <option value="38"></option>
            <option value="40"></option>
            <option value="42"></option>
          </datalist>
        </fieldset>

        <div class="campo">
          <label class="opcao" for="ativo-produto"><input type="checkbox" id="ativo-produto" name="ativo" checked> Produto ativo (aparece no catálogo)</label>
        </div>

        <div class="acoes-formulario">
          <button type="submit" class="botao">Salvar produto</button>
          <a class="botao botao-secundario" href="painel-produtos.html">Cancelar</a>
        </div>
      </form>
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


### Passo 2: acrescente os estilos que faltam

**Em `css/componentes.css`**, cole as duas seções **logo antes do comentário** `/* ---------- Tablet ---------- */`:

**Arquivo: `css/componentes.css`**: adicione estas seções logo antes do comentário `/* ---------- Tablet ---------- */`:

```css
/* ---------- Selos de status do pedido ---------- */
.selo {
  display: inline-block;
  padding: var(--espaco-1) var(--espaco-3);
  font-size: var(--tamanho-pequeno);
  font-weight: 700;
  border-radius: var(--raio-pilula);
}

.selo-novo {
  color: var(--cor-info);
  background-color: var(--cor-info-fundo);
}

.selo-confirmado {
  color: var(--cor-sucesso);
  background-color: var(--cor-sucesso-fundo);
}

.selo-concluido {
  color: var(--cor-neutro);
  background-color: var(--cor-neutro-fundo);
}

.selo-cancelado {
  color: var(--cor-erro);
  background-color: var(--cor-erro-fundo);
}

.selo-atualizado {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
}

/* ---------- Tabela (no celular cada linha vira um bloco, para não rolar na horizontal) ---------- */
.tabela {
  width: 100%;
  border-collapse: collapse;
  background-color: var(--cor-superficie);
}

.tabela thead {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
}

.tabela tr {
  display: block;
  margin-bottom: var(--espaco-4);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.tabela td {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: var(--espaco-3);
  padding: var(--espaco-2) var(--espaco-4);
  border-bottom: 1px solid var(--cor-borda);
  text-align: right;
}

.tabela td:last-child {
  border-bottom: 0;
}

.tabela td::before {
  content: attr(data-rotulo);
  font-weight: 600;
  text-align: left;
}

.tabela-acoes {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
  justify-content: flex-end;
}
```


**Em `css/paginas.css`**, cole a seção da sacola **logo antes do comentário** `/* ---------- Login e cadastro ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Login e cadastro ---------- */`:

```css
/* ---------- Sacola (sacola.html) ---------- */
.sacola-loja {
  margin-bottom: var(--espaco-5);
  padding: var(--espaco-4);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-medio);
}

.sacola-itens {
  list-style: none;
}

.sacola-item {
  display: grid;
  grid-template-columns: 4.5rem 1fr;
  gap: var(--espaco-3);
  padding-block: var(--espaco-3);
  border-bottom: 1px solid var(--cor-borda);
}

.sacola-item img {
  width: 4.5rem;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  border-radius: var(--raio-pequeno);
}

.sacola-item-nome {
  margin: 0;
  font-weight: 600;
}

.sacola-item-controles {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: var(--espaco-2) var(--espaco-3);
  margin-top: var(--espaco-2);
}

.sacola-item-controles input {
  width: 4.5rem;
  min-height: 2.5rem;
  padding: var(--espaco-1) var(--espaco-2);
  font: inherit;
  border: 2px solid var(--cor-borda-campo);
  border-radius: var(--raio-pequeno);
}

.sacola-subtotal {
  margin: var(--espaco-3) 0 0;
  text-align: right;
  font-weight: 700;
}

.sacola-total {
  margin-bottom: var(--espaco-4);
  font-size: var(--tamanho-grande);
  font-weight: 700;
  text-align: right;
}

.sacola-whatsapp {
  display: grid;
  gap: var(--espaco-3);
  margin-top: var(--espaco-6);
}
```


Ainda em `css/paginas.css`, cole a seção do painel **logo antes do comentário** `/* ---------- Tablet ---------- */`:

**Arquivo: `css/paginas.css`**: adicione estas seções logo antes do comentário `/* ---------- Tablet ---------- */`:

```css
/* ---------- Painel da lojista ---------- */
.navegacao-painel {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
  margin-bottom: var(--espaco-5);
  list-style: none;
}

.navegacao-painel a {
  display: inline-block;
  padding: var(--espaco-2) var(--espaco-4);
  font-weight: 600;
  text-decoration: none;
  color: var(--cor-primaria-escura);
  background-color: var(--cor-superficie);
  border: 2px solid var(--cor-primaria);
  border-radius: var(--raio-pilula);
}

.navegacao-painel a[aria-current="page"] {
  color: var(--cor-texto-sobre-primaria);
  background-color: var(--cor-primaria);
}

.painel-topo {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: var(--espaco-3);
  margin-bottom: var(--espaco-4);
}

.painel-topo h1 {
  margin: 0;
}

.tamanhos-estoque {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: var(--espaco-3);
}

.fotos-gerenciar {
  display: grid;
  gap: var(--espaco-3);
  list-style: none;
}

.foto-gerenciar {
  display: grid;
  grid-template-columns: 4.5rem 1fr;
  gap: var(--espaco-3);
  align-items: center;
  padding: var(--espaco-3);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-pequeno);
}

.foto-gerenciar img {
  width: 4.5rem;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  border-radius: var(--raio-pequeno);
}

.foto-gerenciar-acoes {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-2);
  margin-top: var(--espaco-2);
}

.pedido-atualizar {
  display: grid;
  gap: var(--espaco-3);
  margin-top: var(--espaco-3);
}
```


E, por fim, cole **no final** do `css/paginas.css`:

**Arquivo: `css/paginas.css`**: adicione estas seções no final do arquivo:

```css
/* ---------- Painel: formulário do produto ---------- */
.cartao-formulario-largo {
  max-width: 42rem;
}

.painel-acoes {
  margin: 0 0 var(--espaco-4);
}

.acoes-formulario {
  display: flex;
  flex-wrap: wrap;
  gap: var(--espaco-3);
}

/* Uma linha de tamanho: tamanho, estoque e o botão de remover */
.linha-tamanho {
  display: grid;
  gap: var(--espaco-3);
  margin-bottom: var(--espaco-3);
  padding: var(--espaco-3);
  background-color: var(--cor-superficie);
  border: 1px solid var(--cor-borda);
  border-radius: var(--raio-pequeno);
}

#linhas-tamanhos {
  margin-bottom: var(--espaco-3);
}

@media (min-width: 768px) {
  .linha-tamanho {
    grid-template-columns: 1fr 1fr auto;
    align-items: end;
  }
}
```


### Passo 3: percorra as telas

Abra cada página pelo Live Server e confira:

1. `cadastro.html`: formulário com nome, e-mail, senha, telefone e a escolha entre **Cliente** e **Lojista**.
2. `sacola.html`: dois blocos de loja, com um item cada, subtotal por loja, total e o botão **Finalizar sacola (2 pedidos)**.
3. `painel-loja.html`: o menu do painel (Minha loja, Meus produtos e Pedidos recebidos) e o formulário da loja.
4. `painel-produtos.html`: a tabela dos produtos. Diminua a janela para 360 px: **cada linha vira um bloco** com os rótulos ao lado dos valores.
5. `painel-produto-form.html`: campos do produto e **uma linha de tamanho e estoque**. Nesta versão ainda não há envio de fotos (entra na Aula 33).

### Passo 4: revise a acessibilidade

Faça a lista de conferência em **todas as dez páginas** (as cinco de antes e as cinco novas). Use Ctrl+F no VS Code para procurar `<img`, `<input` e `<h1`.

- [ ] Existe **um único** `h1` em cada página.
- [ ] Toda `img` tem `alt` (descrevendo a imagem).
- [ ] Todo campo tem um `label` ligado por `for` e `id`.
- [ ] O foco do teclado aparece em todos os botões, links e campos (aperte Tab).
- [ ] Todo botão que não envia formulário tem `type="button"`.
- [ ] Os preços estão no formato brasileiro (`R$ 129,90`, com vírgula). As datas, quando aparecerem, serão `dd/mm/aaaa` (por exemplo `05/11/2026`).
- [ ] Em 360 px e em 1280 px não há rolagem horizontal.

Corrija o que a lista apontar e comente com a equipe.

### Passo 5: faça o commit e marque a versão 0.1

```bash
git add .
git commit -m "Cria as telas de cadastro, sacola e painel da lojista"
git push
git tag v0.1
git push origin v0.1
```

Cada integrante confere o histórico da equipe com:

```bash
git shortlog -sn
```

Esse comando mostra quantos commits cada pessoa fez; todas devem aparecer.

## Explicação do Código

- **cadastro.html**: o formulário tem `<input type="tel" ... inputmode="numeric">` para o telefone (abre o teclado numérico no celular) e um `fieldset` com `legend` "Quero me cadastrar como", com dois **rádios** (`type="radio" name="perfil"`) cujo rótulo envolve o campo (`<label class="opcao"><input ...> Cliente</label>`). `checked` deixa **Cliente** marcado de início. `aria-describedby="ajuda-senha"` liga o campo à frase de ajuda "Use pelo menos 6 caracteres", para o leitor de tela ler junto.
- **sacola.html**: `<div class="sacola-layout">` limita a largura. Cada loja é uma `section.sacola-loja` com um título (`h2`) que é link para a loja e uma lista (`ul.sacola-itens`). Cada item tem foto, nome, preço unitário, o campo **Quantidade** (`type="number" min="1"`) e o botão **Remover**. Abaixo há `p.sacola-subtotal`, o total e o botão **Finalizar sacola (2 pedidos)** (`botao-largo`).
- **painel-loja.html**: o menu do painel é uma `nav` com lista (`navegacao-painel`), e o link da página atual tem `aria-current="page"`. O formulário usa `type="url"` para o link do mapa e `textarea` para a descrição (um campo de **várias linhas**).
- **painel-produtos.html**: a tabela tem `caption` (um título que só o leitor de tela lê, com `visualmente-oculto`), `thead` com `th scope="col"` e `tbody` com as linhas. As células têm `data-rotulo="Produto"` etc.: o CSS mostra esse texto ao lado do valor quando a tabela vira blocos no celular. Os atributos `role="table"`, `role="row"` e `role="cell"` devolvem a semântica de tabela aos leitores de tela, que a perdem quando o CSS muda o `display`.
- **painel-produto-form.html**: `<input type="number" min="0.01" step="0.01" inputmode="decimal">` para o preço (passo de 1 centavo). `<datalist id="sugestoes-tamanhos">` oferece sugestões (P, M, G...) para o campo de tamanho, que continua aceitando outros valores. O checkbox **Produto ativo** vem marcado.
- **componentes.css, "Selos"**: pequenas "pílulas" coloridas para status (novo, confirmado, concluído, cancelado) e para o "Ativo/Inativo" da lista. **"Tabela"**: no celular a tabela vira blocos (`display: block` em `tr`, `td` com `data-rotulo`); a 768 px (já escrito na seção Tablet) volta a ser tabela.
- **paginas.css, "Sacola", "Painel da lojista" e "Painel: formulário do produto"**: grade da sacola, subtotal, navegação do painel, linhas de tamanho e botões do formulário.
- **Tag `v0.1`**: `git tag v0.1` marca o commit atual; `git push origin v0.1` envia a tag para o GitHub, onde ela aparece em **Releases** (em português: **Versões**) e no seletor de branches.

## Validação

1. As dez páginas abrem pelo Live Server e estão navegáveis pelo menu e pelos links.
2. A tabela do painel vira blocos em 360 px e volta a ser tabela em 768 px.
3. A lista de acessibilidade do Passo 4 está toda marcada.
4. `git shortlog -sn` mostra commits de todas as integrantes, e a tag `v0.1` aparece no GitHub (no botão que lista as branches, na aba **Tags**; a palavra continua igual em português).

**Erros comuns**

1. *Sintoma:* a tabela continua com linhas e colunas no celular. *Causa:* faltaram as seções `Tabela` ou `Tablet` do `componentes.css`, ou foram coladas em outro lugar. *Correção:* a seção `Tabela` vem **antes** da `Tablet`.
2. *Sintoma:* o menu do painel aparece sem estilo. *Causa:* a seção `Painel da lojista` não foi colada em `paginas.css`. *Correção:* cole-a antes da seção `Tablet`.
3. *Sintoma:* `git push origin v0.1` dá `tag 'v0.1' already exists`. *Causa:* outra integrante já criou a tag. *Correção:* é só conferir no GitHub; só uma pessoa precisa criar a tag.
4. *Sintoma:* os rótulos dos campos da sacola não clicam. *Causa:* `id` e `for` repetidos ou diferentes. *Correção:* cada `id` é único na página (`quantidade-1`, `quantidade-2`), e o `for` aponta para o `id` certo.

**Se travar**

1. Abra o **Console** (F12; em português: **Console**) e veja se há arquivos não encontrados.
2. Compare a página com a da aula, olhando principalmente nomes de `id`, `class` e fechamento de tags.
3. Se um arquivo ficou ruim, volte ao último commit: `git restore nome-do-arquivo`.
4. Só depois peça ajuda à sua equipe, dizendo a página e o problema.

**Seu projeto agora tem**

- 10 páginas HTML estáticas: `index`, `catalogo`, `loja`, `produto`, `login`, `cadastro`, `sacola`, `painel-loja`, `painel-produtos` e `painel-produto-form`.
- Os 4 arquivos CSS (`variaveis`, `base`, `componentes`, `paginas`) completos para essas páginas, e as imagens de exemplo.
- A tag **v0.1** no GitHub: **Marco 2** do curso (front-end estático responsivo).

**Como saber que deu certo:** você abre as dez páginas, todas com visual consistente e sem rolagem horizontal, e a tag `v0.1` aparece no GitHub.
