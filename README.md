# Guia de aulas: construindo uma plataforma web de moda local do zero

Este guia leva você, **sozinha e passo a passo**, de uma pasta vazia até uma **plataforma web de moda local** completa:
a **cliente** filtra roupas por tipo, tamanho e loja, junta peças de lojas diferentes na mesma sacola e faz um pedido por
loja, combinado pelo WhatsApp, e acompanha o status no sistema; a **lojista** cadastra a loja e os produtos (até 5 fotos
cada) e atualiza os pedidos. O projeto é o **projeto integrador do curso Jovem Programadora (Senac)**.

São **54 aulas de 60 minutos**, em 18 dias: **Dias 1 a 15 (Aulas 1 a 45, UC3)** e **Dias 26 a 28 (Aulas 76 a 84, UC6)**. A
numeração é a do calendário oficial do curso, por isso ela **pula de 45 para 76** (os Dias 16 a 25 tratam de outros assuntos, em
outros materiais). Tudo o que você precisa copiar (código, SQL, dados de exemplo, casos de teste e requisitos) está **escrito nas
aulas**; você não precisa de nenhum outro arquivo.

## Como usar este guia sozinha

1. **Uma aula por vez, em ordem.** Cada aula parte do que a anterior deixou pronto. Pular uma aula quase sempre quebra a
   seguinte. Na primeira linha de cada aula está o **ponto de partida** (arquivos que já devem existir) e, no fim, **Seu projeto agora
   tem** diz o que você deve ter ao terminar.
2. **Divisão de cada aula (60 minutos):** **10 minutos de abertura** (leia o *Objetivo* e relembre a aula anterior), **40 de prática**
   (a seção *Mão na Massa*, com o código e os comandos exatos) e **10 de fechamento** (a seção *Validação*: teste o que fez, leia os
   *Erros comuns* e confira o *Como saber que deu certo*). As seções *O Conceito* e *Explicação do Código* explicam o porquê e o que cada
   parte faz: leia com calma.
3. **Cada trecho de código vem com o rótulo "Arquivo: caminho/do/arquivo"** e diz se é arquivo **novo**, **inteiro**, ou se você deve
   **substituir** ou **acrescentar** um trecho (sempre indicando **onde**). Copie exatamente; os nomes de arquivos, pastas, funções e
   `id` são os mesmos em todas as aulas e **não mudam**.
4. **Faça o commit de cada aula.** Os comandos `git add .` e `git commit -m "..."` estão no fim da *Mão na Massa*. Os commits são o
   seu "ponto de salvamento": se algo quebrar, você volta ao último commit.
5. **Se uma aula atrasar:** anote **onde parou** (o número do passo) e **continue de lá** na próxima vez, **antes** de iniciar a aula
   seguinte. Você pode pular **explicações e experimentos**, mas **nunca** os passos de **segurança** (chaves, RLS, política de fotos)
   e de **banco** (scripts SQL): sem eles, as aulas seguintes não funcionam.
6. **Como pedir ajuda à sua equipe** (em ordem): (a) leia a mensagem de erro do **Console** (F12) até o fim; (b) compare o seu arquivo com
   o da aula; (c) desfaça com `git status` e `git restore nome-do-arquivo` e refaça o passo; (d) só então peça ajuda. Ao pedir, **cole a mensagem de
   erro exata**, diga **o arquivo e a linha**, e mostre **o que você já tentou**. **Nunca cole chaves nem senhas** na mensagem.

## Antes da Aula 1

### O idioma das ferramentas

Muitas ferramentas do curso (o painel do **Supabase**, o **GitHub**, o **Figma** e as **DevTools** do navegador) têm menus, botões e
abas **em inglês**, e a tela do Supabase e do GitHub **não é traduzida**. Por isso, em todos os passos, o nome do item aparece
**em inglês, exatamente como na tela**, e logo depois vem a **versão em português do Brasil**, assim:

> No menu: **File > Open Folder...** (em português: **Arquivo > Abrir Pasta...**)

O VS Code pode estar em português ou em inglês, conforme a instalação: siga a versão que aparece na **sua** tela. Os **comandos de
terminal** (`git ...`), os **atalhos** (Ctrl+S) e os nomes de **arquivos, tabelas e colunas** nunca são traduzidos. Nos atalhos, o
**Windows** usa **Ctrl** e o **Mac** usa **Cmd**: as aulas mostram os dois quando for diferente.

### O que precisa estar instalado e com conta criada

| O que | Como conferir |
| --- | --- |
| **VS Code** (editor de código) com a extensão **Live Server** (de Ritwick Dey) | abra o VS Code; depois de abrir uma pasta com um arquivo `.html`, o botão **Go Live** aparece no canto inferior direito |
| **Git** | no terminal do VS Code (**Terminal > New Terminal**, em português: **Terminal > Novo Terminal**), digite `git --version`: deve aparecer um número de versão |
| **Navegador atualizado** (Chrome, Edge ou Firefox) | abra o menu de ajuda do navegador > sobre, e confira a versão; atualize se houver aviso |
| **Conta gratuita no GitHub** | entre em https://github.com e faça login |
| **Conta gratuita no Supabase** | entre em https://supabase.com (a Aula 25 cria o projeto) |

A Aula 2 mostra como instalar o Git e a extensão Live Server, caso falte algum. Você **não** precisa de Node, Python ou outras
ferramentas.

## Como o projeto vai ficar

### O que o sistema faz, em linguagem simples

- **Qualquer pessoa (visitante)** abre a **página inicial** (uma vitrine com destaques e um carrossel de peças), o **catálogo** (com filtros por
  tipo de roupa, tamanho e loja, e busca pelo nome), a **página da loja** e a **página do produto** (com fotos, tamanhos e quantidade).
  Pode montar a **sacola** com peças de lojas diferentes. Para **finalizar**, precisa entrar na conta.
- **A cliente** cria a conta, finaliza a sacola (o sistema grava **um pedido por loja** e mostra um **botão de WhatsApp por loja**), acompanha
  os pedidos em **Meus pedidos** (com o status e o recado da loja, e um aviso quando a loja responde) e pode **excluir a própria conta**.
- **A lojista** cria a conta com o perfil de lojista, cadastra a **loja** (com WhatsApp e link do mapa), os **produtos** (com tamanhos, estoque
  e até 5 fotos), desativa ou exclui produtos, e vê os **pedidos recebidos**, que ela confirma, conclui ou cancela, deixando um recado.
- **Todas** podem **recuperar a senha por e-mail** e ler o **aviso de privacidade**.

São **15 páginas HTML**, que o guia constrói aos poucos.

### A árvore de pastas final

```text
vitrine-col/
├── index.html, catalogo.html, loja.html, produto.html, sacola.html
├── login.html, cadastro.html, recuperar-senha.html, minha-conta.html
├── meus-pedidos.html, privacidade.html
├── painel-loja.html, painel-produtos.html, painel-produto-form.html, painel-pedidos.html
├── css/        variaveis.css, base.css, componentes.css, paginas.css, inicio.css
├── js/
│   ├── config.js, supabaseClient.js
│   ├── modelos/    ErroApp, Usuaria, Cliente, Lojista, Loja, Produto, Sacola, Pedido
│   ├── servicos/   authServico, lojaServico, produtoServico, categoriaServico, pedidoServico, storageServico, errosSupabase
│   ├── ui/         cabecalho, cards, avisos, formatadores, protecao, elementos, carrossel, imagem, listaDeFotos
│   └── paginas/    um arquivo por tela
├── imagens/        sem-foto.svg e exemplo-1.svg a exemplo-6.svg
├── database/       01_schema.sql, 02_rls.sql, 03_seed.sql, 04_melhorias.sql
├── docs/           TESTES.md e relatorio-de-testes.md
├── README.md
└── .gitignore
```

## Pontos de conferência

Nestes cinco dias o seu projeto deve ter os arquivos e o comportamento abaixo. Use a lista para **se comparar sozinha**.

### Dia 4 (fim da Aula 12): páginas estilizadas

- **Arquivos:** `index.html`, `catalogo.html`, `loja.html`, `produto.html`, `login.html` (estáticas, sem JavaScript); `imagens/sem-foto.svg` e `imagens/exemplo-1.svg` a `exemplo-6.svg`; `css/variaveis.css`, `css/base.css` (primeira parte), `css/componentes.css` e `css/paginas.css` (só o catálogo).
- **Funciona:** abrir as páginas pelo Live Server com cores e fonte do guia de estilo, cabeçalho com menu em linha, botões, campos de formulário, chips e **cards de produto** em grade (uma coluna por enquanto).

### Dia 8 (fim da Aula 24): catálogo com dados fictícios e classes

- **Arquivos novos:** `js/ui/elementos.js`, `avisos.js`, `cabecalho.js`, `formatadores.js`, `cards.js`; `js/modelos/ErroApp.js`, `Produto.js`, `Loja.js`, `Usuaria.js`, `Cliente.js`, `Lojista.js`; `js/paginas/catalogo.js`; `js/servicos/produtoServico.js` (só a validação), `js/paginas/painelProdutoForm.js` (só a validação); páginas já com as 10 telas estáticas e `css` completo para elas.
- **Funciona:** o `catalogo.html` mostra 6 produtos fictícios, filtra por tipo, loja, tamanho (só com estoque) e nome, e mostra uma **mensagem de erro em português** se um dado for inválido; `Cliente` e `Lojista` respondem `rotaInicial()` de formas diferentes.

### Dia 12 (fim da Aula 36): banco, CRUD, sacola e pedido montado

- **Banco no Supabase:** 8 tabelas, 4 gatilhos, 8 categorias, uma lojista de teste, uma loja e 3 produtos de exemplo; bucket `produtos`; **RLS ainda desligada** e a política provisória de fotos criada.
- **Arquivos:** `database/01_schema.sql` e `database/03_seed.sql`; `js/config.js`, `js/supabaseClient.js`, todos os serviços exceto `authServico.js`; as classes `Sacola` e `Pedido`; `produto.js`, `loja.js`, `sacola.js` e as telas do painel.
- **Funciona:** o catálogo lê do banco com filtros e **12 por página**; a lojista de teste cadastra, edita, desativa e exclui produtos, com até 5 fotos reduzidas para cerca de 200 KB; a **sacola** guarda peças de duas lojas, agrupadas, com subtotais e contador; **Finalizar** mostra um cartão e um botão de WhatsApp **por loja** (ainda sem gravar o pedido).

### Dia 15 (fim da Aula 45): MVP publicado, versão 0.9

- **Arquivos novos:** `js/servicos/authServico.js`, `js/ui/protecao.js`, `recuperar-senha.html`, `privacidade.html` (e seus `.js`), `index.html` (vitrine), `css/inicio.css`, `js/ui/carrossel.js`, `database/02_rls.sql` e `database/04_melhorias.sql`, `docs/TESTES.md`.
- **Funciona:** cadastro, login, logout e recuperação de senha por e-mail; telas protegidas por perfil; **RLS ligada nas 8 tabelas**; **pedido gravado pela função `criar_pedidos`** (dois pedidos com o mesmo `grupo_id` para peças de duas lojas); página inicial com carrossel acessível; site **publicado no GitHub Pages**; README completo; tag `v0.9`.

### Dia 28 (fim da Aula 84): versão 1.0 congelada

- **Arquivos novos:** `painel-pedidos.html`, `meus-pedidos.html`, `minha-conta.html` (e seus `.js`); `docs/relatorio-de-testes.md`.
- **Funciona:** a lojista vê os pedidos da loja e muda o status (seguindo o fluxo) com um recado; a cliente vê **Meus pedidos** com um **contador de novidades** e o selo **Atualizado**; **Minha conta** exclui a própria conta (e apaga as fotos do Storage); os 25 casos de teste (CT-01 a CT-25) foram executados e registrados; a revisão de segurança passou; a tag `v1.0` e o release estão no GitHub, e o projeto tem **as 15 páginas HTML, os 5 arquivos CSS, todos os módulos de `js/` e os 4 scripts SQL**.

## Arquivos da pasta materiais

Alguns textos são longos demais para caber na aula. Ficam em `docs/guia-aulas/materiais/`, e cada aula que usa um deles diz o
caminho e como copiá-lo.

- [`materiais/03_seed_parte2.sql`](materiais/03_seed_parte2.sql): Loja de exemplo e 3 produtos (Aula 27)
- [`materiais/dados-de-exemplo-produtos.json`](materiais/dados-de-exemplo-produtos.json): Os 6 produtos de exemplo da Aula 28, em JSON

## Índice das aulas

| Dia | Data | Aula | Título | Arquivo |
| --- | --- | --- | --- | --- |
| 1 | Ter 06/10/2026 | 1 | Backlog do MVP e formação das equipes | [dia01-aula01-backlog-do-mvp-e-formacao-das-equipes.md](dia01-aula01-backlog-do-mvp-e-formacao-das-equipes.md) |
| 1 | Ter 06/10/2026 | 2 | Git e GitHub: repositório, commits e quadro Kanban | [dia01-aula02-git-e-github-repositorio-commits-e-quadro-kanban.md](dia01-aula02-git-e-github-repositorio-commits-e-quadro-kanban.md) |
| 1 | Ter 06/10/2026 | 3 | HTML: estrutura da página, textos, links e imagens | [dia01-aula03-html-estrutura-da-pagina-textos-links-e-imagens.md](dia01-aula03-html-estrutura-da-pagina-textos-links-e-imagens.md) |
| 2 | Qua 07/10/2026 | 4 | Wireframes das telas-chave | [dia02-aula04-wireframes-das-telas-chave.md](dia02-aula04-wireframes-das-telas-chave.md) |
| 2 | Qua 07/10/2026 | 5 | Protótipo navegável no Figma | [dia02-aula05-prototipo-navegavel-no-figma.md](dia02-aula05-prototipo-navegavel-no-figma.md) |
| 2 | Qua 07/10/2026 | 6 | Nome, identidade visual e guia de estilo | [dia02-aula06-nome-identidade-visual-e-guia-de-estilo.md](dia02-aula06-nome-identidade-visual-e-guia-de-estilo.md) |
| 3 | Qui 08/10/2026 | 7 | HTML semântico | [dia03-aula07-html-semantico.md](dia03-aula07-html-semantico.md) |
| 3 | Qui 08/10/2026 | 8 | Listas e formulários HTML | [dia03-aula08-listas-e-formularios-html.md](dia03-aula08-listas-e-formularios-html.md) |
| 3 | Qui 08/10/2026 | 9 | Montagem das páginas do projeto em HTML | [dia03-aula09-montagem-das-paginas-do-projeto-em-html.md](dia03-aula09-montagem-das-paginas-do-projeto-em-html.md) |
| 4 | Sex 09/10/2026 | 10 | CSS: seletores, cores, tipografia e caixa | [dia04-aula10-css-seletores-cores-tipografia-e-caixa.md](dia04-aula10-css-seletores-cores-tipografia-e-caixa.md) |
| 4 | Sex 09/10/2026 | 11 | Layout com Flexbox | [dia04-aula11-layout-com-flexbox.md](dia04-aula11-layout-com-flexbox.md) |
| 4 | Sex 09/10/2026 | 12 | Layout com Grid e card de produto | [dia04-aula12-layout-com-grid-e-card-de-produto.md](dia04-aula12-layout-com-grid-e-card-de-produto.md) |
| 5 | Ter 13/10/2026 | 13 | Responsividade mobile-first | [dia05-aula13-responsividade-mobile-first.md](dia05-aula13-responsividade-mobile-first.md) |
| 5 | Ter 13/10/2026 | 14 | Variáveis CSS, hover e foco visível | [dia05-aula14-variaveis-css-hover-e-foco-visivel.md](dia05-aula14-variaveis-css-hover-e-foco-visivel.md) |
| 5 | Ter 13/10/2026 | 15 | Revisão e fechamento do front-end estático | [dia05-aula15-revisao-e-fechamento-do-front-end-estatico.md](dia05-aula15-revisao-e-fechamento-do-front-end-estatico.md) |
| 6 | Qua 14/10/2026 | 16 | JavaScript: variáveis, tipos e condicionais | [dia06-aula16-javascript-variaveis-tipos-e-condicionais.md](dia06-aula16-javascript-variaveis-tipos-e-condicionais.md) |
| 6 | Qua 14/10/2026 | 17 | Funções, arrays e objetos | [dia06-aula17-funcoes-arrays-e-objetos.md](dia06-aula17-funcoes-arrays-e-objetos.md) |
| 6 | Qua 14/10/2026 | 18 | DOM e eventos | [dia06-aula18-dom-e-eventos.md](dia06-aula18-dom-e-eventos.md) |
| 7 | Qui 15/10/2026 | 19 | Catálogo a partir de um array de objetos | [dia07-aula19-catalogo-a-partir-de-um-array-de-objetos.md](dia07-aula19-catalogo-a-partir-de-um-array-de-objetos.md) |
| 7 | Qui 15/10/2026 | 20 | Filtros com métodos de array | [dia07-aula20-filtros-com-metodos-de-array.md](dia07-aula20-filtros-com-metodos-de-array.md) |
| 7 | Qui 15/10/2026 | 21 | Formulários e validação no navegador | [dia07-aula21-formularios-e-validacao-no-navegador.md](dia07-aula21-formularios-e-validacao-no-navegador.md) |
| 8 | Sex 16/10/2026 | 22 | Classes JavaScript: Produto e Loja | [dia08-aula22-classes-javascript-produto-e-loja.md](dia08-aula22-classes-javascript-produto-e-loja.md) |
| 8 | Sex 16/10/2026 | 23 | Herança, polimorfismo e agregação | [dia08-aula23-heranca-polimorfismo-e-agregacao.md](dia08-aula23-heranca-polimorfismo-e-agregacao.md) |
| 8 | Sex 16/10/2026 | 24 | Tratamento de erros e módulos | [dia08-aula24-tratamento-de-erros-e-modulos.md](dia08-aula24-tratamento-de-erros-e-modulos.md) |
| 9 | Seg 19/10/2026 | 25 | Supabase e modelagem do banco | [dia09-aula25-supabase-e-modelagem-do-banco.md](dia09-aula25-supabase-e-modelagem-do-banco.md) |
| 9 | Seg 19/10/2026 | 26 | Criar as tabelas com SQL | [dia09-aula26-criar-as-tabelas-com-sql.md](dia09-aula26-criar-as-tabelas-com-sql.md) |
| 9 | Seg 19/10/2026 | 27 | SQL básico: SELECT, INSERT e JOIN | [dia09-aula27-sql-basico-select-insert-e-join.md](dia09-aula27-sql-basico-select-insert-e-join.md) |
| 10 | Ter 20/10/2026 | 28 | JavaScript assíncrono | [dia10-aula28-javascript-assincrono.md](dia10-aula28-javascript-assincrono.md) |
| 10 | Ter 20/10/2026 | 29 | Conectar o front ao Supabase | [dia10-aula29-conectar-o-front-ao-supabase.md](dia10-aula29-conectar-o-front-ao-supabase.md) |
| 10 | Ter 20/10/2026 | 30 | Catálogo e filtros consultando o banco | [dia10-aula30-catalogo-e-filtros-consultando-o-banco.md](dia10-aula30-catalogo-e-filtros-consultando-o-banco.md) |
| 11 | Qua 21/10/2026 | 31 | Cadastro de lojas e produtos | [dia11-aula31-cadastro-de-lojas-e-produtos.md](dia11-aula31-cadastro-de-lojas-e-produtos.md) |
| 11 | Qua 21/10/2026 | 32 | Editar e excluir produtos | [dia11-aula32-editar-e-excluir-produtos.md](dia11-aula32-editar-e-excluir-produtos.md) |
| 11 | Qua 21/10/2026 | 33 | Fotos no Supabase Storage | [dia11-aula33-fotos-no-supabase-storage.md](dia11-aula33-fotos-no-supabase-storage.md) |
| 12 | Qui 22/10/2026 | 34 | Páginas de produto e de loja | [dia12-aula34-paginas-de-produto-e-de-loja.md](dia12-aula34-paginas-de-produto-e-de-loja.md) |
| 12 | Qui 22/10/2026 | 35 | Sacola agrupada por loja | [dia12-aula35-sacola-agrupada-por-loja.md](dia12-aula35-sacola-agrupada-por-loja.md) |
| 12 | Qui 22/10/2026 | 36 | Finalizar a sacola | [dia12-aula36-finalizar-a-sacola.md](dia12-aula36-finalizar-a-sacola.md) |
| 13 | Sex 23/10/2026 | 37 | Cadastro e login | [dia13-aula37-cadastro-e-login.md](dia13-aula37-cadastro-e-login.md) |
| 13 | Sex 23/10/2026 | 38 | Recuperação de senha | [dia13-aula38-recuperacao-de-senha.md](dia13-aula38-recuperacao-de-senha.md) |
| 13 | Sex 23/10/2026 | 39 | Controle de acesso, RLS e criar_pedidos | [dia13-aula39-controle-de-acesso-rls-e-criar-pedidos.md](dia13-aula39-controle-de-acesso-rls-e-criar-pedidos.md) |
| 14 | Seg 26/10/2026 | 40 | Página inicial de vitrine | [dia14-aula40-pagina-inicial-de-vitrine.md](dia14-aula40-pagina-inicial-de-vitrine.md) |
| 14 | Seg 26/10/2026 | 41 | Depuração e casos de teste | [dia14-aula41-depuracao-e-casos-de-teste.md](dia14-aula41-depuracao-e-casos-de-teste.md) |
| 14 | Seg 26/10/2026 | 42 | Correções e Git em equipe | [dia14-aula42-correcoes-e-git-em-equipe.md](dia14-aula42-correcoes-e-git-em-equipe.md) |
| 15 | Ter 27/10/2026 | 43 | Publicação no GitHub Pages | [dia15-aula43-publicacao-no-github-pages.md](dia15-aula43-publicacao-no-github-pages.md) |
| 15 | Ter 27/10/2026 | 44 | Documentação técnica | [dia15-aula44-documentacao-tecnica.md](dia15-aula44-documentacao-tecnica.md) |
| 15 | Ter 27/10/2026 | 45 | Revisão geral e avaliação da UC3 | [dia15-aula45-revisao-geral-e-avaliacao-da-uc3.md](dia15-aula45-revisao-geral-e-avaliacao-da-uc3.md) |
| 26 | Qui 12/11/2026 | 76 | Pedidos recebidos e fluxo de status | [dia26-aula76-pedidos-recebidos-e-fluxo-de-status.md](dia26-aula76-pedidos-recebidos-e-fluxo-de-status.md) |
| 26 | Qui 12/11/2026 | 77 | Meus pedidos e aviso de novidades | [dia26-aula77-meus-pedidos-e-aviso-de-novidades.md](dia26-aula77-meus-pedidos-e-aviso-de-novidades.md) |
| 26 | Qui 12/11/2026 | 78 | Minha conta, conteúdo real e ajustes | [dia26-aula78-minha-conta-conteudo-real-e-ajustes.md](dia26-aula78-minha-conta-conteudo-real-e-ajustes.md) |
| 27 | Sex 13/11/2026 | 79 | Plano de testes e roteiro de usabilidade | [dia27-aula79-plano-de-testes-e-roteiro-de-usabilidade.md](dia27-aula79-plano-de-testes-e-roteiro-de-usabilidade.md) |
| 27 | Sex 13/11/2026 | 80 | Testes com usuárias reais | [dia27-aula80-testes-com-usuarias-reais.md](dia27-aula80-testes-com-usuarias-reais.md) |
| 27 | Sex 13/11/2026 | 81 | Feedbacks e priorização das correções | [dia27-aula81-feedbacks-e-priorizacao-das-correcoes.md](dia27-aula81-feedbacks-e-priorizacao-das-correcoes.md) |
| 28 | Seg 16/11/2026 | 82 | Correção dos problemas críticos | [dia28-aula82-correcao-dos-problemas-criticos.md](dia28-aula82-correcao-dos-problemas-criticos.md) |
| 28 | Seg 16/11/2026 | 83 | Revisão de segurança e publicação | [dia28-aula83-revisao-de-seguranca-e-publicacao.md](dia28-aula83-revisao-de-seguranca-e-publicacao.md) |
| 28 | Seg 16/11/2026 | 84 | Documentação final e versão 1.0 | [dia28-aula84-documentacao-final-e-versao-1-0.md](dia28-aula84-documentacao-final-e-versao-1-0.md) |
