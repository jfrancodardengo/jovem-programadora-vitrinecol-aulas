**Data:** 23/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero que só eu consiga finalizar meus pedidos e que cada lojista só mexa na própria loja, para que meus dados e meus pedidos fiquem protegidos mesmo com a chave pública visível no navegador.

## Critérios de aceite

- Visitante que abre `painel-loja.html` vai para `login.html?voltar=painel-loja.html`; cliente logada é levada à página inicial; a lojista entra e só vê o que é dela (RF-14, CT-09).
- Sem login, "Finalizar sacola" leva ao login e, depois de entrar, **volta à sacola** com os mesmos itens (CT-06).
- Logada como cliente, finalizar uma sacola com duas lojas grava **dois pedidos** com status `novo` e o **mesmo `grupo_id`**, com preço copiado nos itens, e mostra um botão de WhatsApp por loja (RF-10, RN-03, RN-04, RN-06, CT-07).
- As 8 tabelas mostram `rowsecurity = true` (24 regras em `public`: categorias 1, itens_pedido 1, lojas 4, pedidos 2, perfis 3, produto_fotos 4, produtos 5, tamanhos 4); a política `dev: envio de fotos` **não existe mais** (consulta vazia) (RN-09).
- Pelo console, a lojista de outra loja recebe `data: []` ao tentar alterar o produto alheio e erro de RLS no Storage (CT-11); o insert direto em `pedidos` é recusado por **row-level security** e o preço forjado é rejeitado com "o preço mudou" (CT-21, RN-05).
- A página `privacidade.html` abre, com o e-mail de contato da equipe.

## Checklist

- [ ] Conferir que existem: uma conta de **cliente**, a **Lojista Teste** e uma **segunda lojista** (com loja e um produto).
- [ ] Criar `js/ui/protecao.js` (`exigirLogin`, `exigirPerfil` e `enderecoDeRetornoSeguro`).
- [ ] No `login.js` e no `cadastro.js`, fazer as trocas da aula para voltar à página de origem (`voltar` na URL).
- [ ] Nos três HTML do painel (`painel-loja.html`, `painel-produtos.html` e `painel-produto-form.html`), trocar `<main id="conteudo" class="container">` por `<main id="conteudo" class="container" hidden>`.
- [ ] Nos três JS do painel, importar `exigirPerfil` e trocar a função `iniciar` pela versão da aula.
- [ ] No `lojaServico.js`, trocar as importações e as funções `obterMinhaLoja` e `salvarLoja` para usar a lojista logada.
- [ ] No `js/config.js`, **apagar** `LOJISTA_DE_TESTE_ID` e acrescentar `EMAIL_DE_CONTATO` (trocar `EMAIL-DA-EQUIPE@exemplo.com` pelo e-mail real da equipe).
- [ ] No `pedidoServico.js`, trocar o começo do arquivo e a função `criarPedidos` para chamar a função do banco; no `sacola.js`, trocar o começo e a função `finalizar`.
- [ ] Criar `privacidade.html` e `js/paginas/privacidade.js`; colar a seção "Privacidade" no `css/paginas.css`, antes de `/* ---------- Tablet ---------- */`.
- [ ] **Só depois de terminar o código:** criar `database/02_rls.sql`, abrir **SQL Editor** (em português: **Editor SQL**) > nova consulta, colar o arquivo inteiro e clicar em **Run** (em português: **Executar**).
- [ ] Rodar as três consultas de conferência (8 tabelas com `true`; 24 regras; política provisória inexistente).
- [ ] Criar `database/04_melhorias.sql` e rodar o arquivo **inteiro** depois do 02; conferir as duas funções novas.
- [ ] Testar como visitante, como cliente e como lojista (CT-09).
- [ ] Testar CT-06: montar a sacola sem login, finalizar, entrar e voltar à sacola.
- [ ] Testar CT-07: finalizar logada e rodar as duas consultas (`pedidos` e `itens_pedido`) para conferir status `novo`, mesmo `grupo_id` e preços copiados.
- [ ] Testar CT-11 no Console (F12 > **Console**) como a segunda lojista, trocando `ID-DO-PRODUTO-DA-PRIMEIRA` e `ID-DA-LOJA` pelos ids reais.
- [ ] Testar CT-21 no Console como cliente (insert direto e preço forjado).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`, confirmando que nenhum arquivo tem `service_role` ou senhas.

## Depende de

- D13·A38 – Fazer a recuperação de senha por e-mail ("Esqueci minha senha")

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia13-aula39-controle-de-acesso-rls-e-criar-pedidos.md]({{URL_GUIA}}/dia13-aula39-controle-de-acesso-rls-e-criar-pedidos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-10** – Finalizar a sacola de uma cliente logada, gravando um pedido por loja e mostrando um botão de WhatsApp por loja.
- **RF-14** – Controlar o acesso às telas conforme o perfil (cliente, lojista ou visitante).
- **RN-03** – A sacola mistura lojas; ao finalizar, sai um pedido por loja, cada um com o seu status e o mesmo código de compra (grupo_id).
- **RN-04** – Só uma cliente logada cria pedido, e o status inicial é "novo".
- **RN-05** – O status segue novo, confirmado e concluído; cancelado vale enquanto o pedido não estiver concluído; o banco recusa outras mudanças.
- **RN-06** – O preço de cada item é copiado para o pedido na hora da compra, o banco calcula o total e só grava se o preço visto ainda for o atual.
- **RN-09** – Só a lojista dona da loja altera a loja, os produtos, as fotos e o status dos pedidos recebidos.
- **CT-06** – Tentar finalizar sem estar logada e voltar à sacola depois do login.
- **CT-07** – Finalizar logada com peças de duas lojas: dois pedidos com o mesmo código de compra e um botão de WhatsApp por loja.
- **CT-09** – Cliente tenta abrir uma tela do painel e é bloqueada.
- **CT-11** – Lojista tenta editar o produto de outra loja pelo console e o banco recusa.
- **CT-21** – Cliente tenta gravar pedido com preço forjado ou direto na tabela e o banco recusa.
