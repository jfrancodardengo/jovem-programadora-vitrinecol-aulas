**Data:** 16/11/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero que ninguém consiga alterar meus pedidos nem os produtos de outra loja, para que meus dados e minhas compras fiquem protegidos na versão final.

## Critérios de aceite

- As consultas de conferência deram: 8 tabelas com `rowsecurity = true`; 24 regras (categorias 1, itens_pedido 1, lojas 4, pedidos 2, perfis 3, produto_fotos 4, produtos 5, tamanhos 4); política provisória de fotos ausente (consulta vazia); 0 regras de INSERT direto em pedidos e itens; 3 funções; limites do bucket de `2097152` bytes e 3 tipos de imagem.
- A busca por `service_role` e `secret` não encontra nenhuma chave (só o comentário do `js/config.js`), `innerHTML` em `js/` dá 0 resultados, `PROVISÓRIO` e `alert(` dão 0, e o histórico (`git log -S"service_role" --oneline`) não mostra chave de verdade.
- Pelo console, o banco **recusa** tudo: a lojista B não altera o produto da lojista A (`data: []` e erro de RLS no Storage, CT-11); a lojista não altera o total do pedido (CT-18); não pula etapa de status nem mexe no aviso da cliente (CT-20); a cliente não grava pedido direto nem com preço forjado (CT-21); o visitante não lê pedidos nem perfis (`data: []`).
- O site publicado está na versão final e o link do e-mail de recuperação de senha abre o **site publicado** (CT-23), com **Site URL** e **Redirect URLs** do Supabase apontando para o endereço publicado.

## Checklist

- [ ] No **SQL Editor** (em português: **Editor SQL**), rodar as consultas 1.1 (RLS nas 8 tabelas), 1.2 (regras por tabela), 1.3 (política provisória de fotos), 1.4 (INSERT direto em pedidos e itens) e 1.5 (funções e limites do bucket) e comparar com o esperado.
- [ ] Se algum resultado for diferente, **parar**: é crítico. Rodar de novo `database/02_rls.sql` e depois `database/04_melhorias.sql` e repetir as consultas.
- [ ] Procurar `service_role` e `secret` (só o comentário do `config.js`), `innerHTML` em `js/` (0), `PROVISÓRIO` e `alert(` (0).
- [ ] No terminal, rodar `git log -S"service_role" --oneline`; se aparecer um commit que adicionou uma chave de verdade, gerar uma chave nova em **Project Settings** (em português: **Configurações do projeto**) > **API** e apagar a antiga.
- [ ] Conferir que o arquivo `.env` (se existir) está no `.gitignore` e não foi para o GitHub.
- [ ] Preparar duas lojistas (A e B), cada uma com loja, produto e um pedido recebido, e uma cliente; trocar os textos em MAIÚSCULAS pelos ids reais.
- [ ] Refazer CT-11 como lojista B no Console (F12 > **Console**) e conferir `data: []` nas quatro primeiras linhas e o erro de RLS na foto; conferir que nada mudou no painel da lojista A.
- [ ] Refazer CT-18 como lojista dona e como outra lojista (`data: []`).
- [ ] Refazer CT-20 com um pedido novo da sua loja: pular etapa e mexer em `status_visto`.
- [ ] Refazer CT-21 como **cliente** e conferir com `select count(*) from public.pedidos;` que o total de pedidos não aumentou.
- [ ] Fazer o teste extra como visitante (sem entrar): as duas consultas devolvem `data: []`.
- [ ] Conferir que todos os pull requests estão na `main` e que o GitHub Pages terminou de publicar (em **Settings > Pages**, em português: **Configurações > Páginas**, ou na aba **Actions**, em português: **Ações**); recarregar com **Ctrl+Shift+R** (Mac: Cmd+Shift+R).
- [ ] No Supabase, abrir **Authentication** (em português: **Autenticação**) > **URL Configuration** (em português: **Configuração de URL**): **Site URL** (em português: **URL do site**) igual ao endereço publicado e **Redirect URLs** (em português: **URLs de redirecionamento**) com `https://SEU-USUARIO.github.io/vitrine-col/recuperar-senha.html` (os endereços de teste podem sair).
- [ ] Fazer o fluxo de recuperação de senha (CT-23) no site publicado com uma conta de teste, conferindo que o link do e-mail abre o site publicado.
- [ ] Percorrer no site publicado: página inicial, catálogo, sacola, login, pedido, **Meus pedidos** e o painel da lojista.
- [ ] Atualizar o `docs/TESTES.md` (resultados novos de CT-11, CT-18, CT-20, CT-21 e CT-23, com data), criar a branch `revisao-de-seguranca`, commitar e abrir o pull request.

## Depende de

- D28·A82 – Corrigir os problemas críticos em branches e refazer os casos de teste

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia28-aula83-revisao-de-seguranca-e-publicacao.md]({{URL_GUIA}}/dia28-aula83-revisao-de-seguranca-e-publicacao.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-05** – O status segue novo, confirmado e concluído; cancelado vale enquanto o pedido não estiver concluído; o banco recusa outras mudanças.
- **RN-06** – O preço de cada item é copiado para o pedido na hora da compra, o banco calcula o total e só grava se o preço visto ainda for o atual.
- **RN-09** – Só a lojista dona da loja altera a loja, os produtos, as fotos e o status dos pedidos recebidos.
- **RN-13** – Quando a lojista muda o status ou o recado, o pedido fica marcado como novidade para a cliente até ela abrir Meus pedidos; a lojista não altera valores, itens, cliente nem loja.
- **CT-11** – Lojista tenta editar o produto de outra loja pelo console e o banco recusa.
- **CT-18** – Lojista tenta alterar o total de um pedido pelo console e o banco recusa.
- **CT-20** – Lojista tenta pular uma etapa do status ou mexer no aviso da cliente pelo console e o banco recusa.
- **CT-21** – Cliente tenta gravar pedido com preço forjado ou direto na tabela e o banco recusa.

**Outros requisitos e testes citados nesta issue:**

- **CT-23** – Recuperar a senha pelo link do e-mail; a nova senha vale e a antiga não.
