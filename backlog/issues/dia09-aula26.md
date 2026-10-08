**Data:** 19/10/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero criar as 8 tabelas com chaves, regras e gatilhos usando SQL, para que o banco recuse preço zero, mais de 5 fotos e outras entradas inválidas.

## Critérios de aceite

- A consulta de tabelas em `information_schema.tables` devolve exatamente 8 linhas (`categorias`, `itens_pedido`, `lojas`, `pedidos`, `perfis`, `produto_fotos`, `produtos`, `tamanhos`).
- A consulta de gatilhos devolve 4 linhas (`ao_criar_usuario`, `fotos_limite_por_produto`, `perfis_nao_troca_tipo` e `pedidos_protegidos`).
- A consulta de `CHECK` lista as regras de preço, estoque, ordem, quantidade, status e tipo.
- `select id, nome from public.categorias order by id;` devolve 8 linhas: Blusas, Camisetas, Vestidos, Calças, Saias, Shorts, Jaquetas e Acessórios.
- No **Table Editor** (em português: **Editor de tabelas**) aparecem as 8 tabelas, com a RLS **desligada**.

## Checklist

- [ ] No **Table Editor** (em português: **Editor de tabelas**), confirmar que ainda não há tabelas.
- [ ] Criar a pasta `database` na raiz do projeto e o arquivo `database/01_schema.sql` com a Parte 1 (as 8 tabelas e os índices).
- [ ] No painel, abrir **SQL Editor** (em português: **Editor SQL**) > **New query** (em português: **Nova consulta**), colar a Parte 1 (do primeiro `create table` ao último `create index`) e clicar em **Run** (em português: **Executar**).
- [ ] Se o painel avisar sobre RLS, escolher a opção sem RLS (**Run without RLS**, em português: **Executar sem RLS**); a segurança por linha só entra no Dia 13.
- [ ] Conferir a mensagem **Success. No rows returned** (em português: **Sucesso. Nenhuma linha retornada**) e rodar a consulta que lista as 8 tabelas.
- [ ] Colar a Parte 2 (quatro gatilhos e a função usada pela cliente) no **final** do `database/01_schema.sql`.
- [ ] Em uma nova consulta, rodar a Parte 2 (do comentário `-- Gatilho: cria o perfil...` até o fim) e rodar a consulta que lista os 4 gatilhos.
- [ ] Rodar a consulta das regras `CHECK`.
- [ ] Criar `database/03_seed.sql` com a primeira parte (as categorias), rodar no **SQL Editor** e conferir as 8 categorias.
- [ ] Se aparecer `relation "perfis" already exists`, não rodar a Parte 1 de novo; se aparecer `relation "public.perfis" does not exist`, rodar a Parte 1 antes da Parte 2.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push` (sem nenhuma senha ou chave nos arquivos).

## Depende de

- D9·A25 – Criar o projeto vitrine-col no Supabase e ler o diagrama das 8 tabelas

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia09-aula26-criar-as-tabelas-com-sql.md]({{URL_GUIA}}/dia09-aula26-criar-as-tabelas-com-sql.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-01** – Cada lojista tem no máximo uma loja.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-11** – O perfil (cliente ou lojista) é escolhido no cadastro e não muda depois.
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.
