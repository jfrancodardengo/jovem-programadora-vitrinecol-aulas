**Data:** 19/10/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero consultar o banco com SQL e carregar uma loja e 3 produtos de exemplo, para que o catálogo tenha dados de teste quando eu ligar o site ao banco.

## Critérios de aceite

- As consultas de SELECT, WHERE e ORDER BY funcionaram e a categoria `Teste` foi inserida e apagada.
- `select id, nome, tipo from public.perfis;` mostra uma linha `Lojista Teste` com tipo `lojista`.
- A consulta com `join` mostra 3 produtos (Calça jeans reta: 1 foto e 3 tamanhos; Camiseta básica branca: 2 fotos e 3 tamanhos; Vestido midi floral: 3 fotos e 3 tamanhos) com o nome da **Loja Exemplo**.
- Os testes de regra geram os erros esperados (`produtos_preco_check`, `lojas_dono_id_key` e "Cada produto pode ter no máximo 5 fotos.") e as fotos de teste foram apagadas.
- `database/03_seed.sql` tem as duas partes, com o `v_dono` ainda com zeros no arquivo do projeto.

## Checklist

- [ ] No **SQL Editor** (em português: **Editor SQL**), rodar uma por vez as consultas de `select`, `where` e `order by` do Passo 1 (a terceira, com `like 'S%'`, devolve Saias e Shorts).
- [ ] Rodar o `insert` da categoria `Teste`, ver a nova linha e rodar o `delete` com `where` (nunca um `delete` sem `where`).
- [ ] No painel, abrir **Authentication** (em português: **Autenticação**) > **Users** (em português: **Usuários**) > **Add user** (em português: **Adicionar usuário**) > **Create new user** (em português: **Criar novo usuário**).
- [ ] Preencher **Email** (que você acesse) e **Password** (em português: **Senha**) com pelo menos 6 caracteres e marcar **Auto Confirm User** (em português: **Confirmar usuária automaticamente**), se existir.
- [ ] Em **User Metadata** (em português: **Metadados do usuário**), se existir, colar `{"nome": "Lojista Teste", "tipo": "lojista"}`; clicar em **Create user** (em português: **Criar usuário**) e copiar o **UID**.
- [ ] Rodar `select id, nome, tipo from public.perfis;`. Se aparecer `Sem nome` e `cliente`, apagar o perfil (`delete from public.perfis where id = '...'`) e recriar como a aula indica.
- [ ] Abrir `{{URL_GUIA}}/materiais/03_seed_parte2.sql`, selecionar tudo (Ctrl+A; Mac: Cmd+A), copiar e colar no final de `database/03_seed.sql`.
- [ ] Copiar do `03_seed.sql` só o bloco do `do $$` até o `$$;`, colar em uma nova consulta no painel e trocar os zeros de `v_dono` pelo UID da lojista de teste (somente na cópia do painel, não no arquivo do projeto).
- [ ] Clicar em **Run** (em português: **Executar**) e conferir **Success**.
- [ ] Rodar a consulta das lojas e a consulta com `join` e conferir a tabela do Passo 5.
- [ ] Rodar os testes das regras do banco (preço zero e segunda loja da mesma lojista) e o teste do limite de 5 fotos; limpar as fotos de teste com `delete ... where url like 'https://exemplo.com/%'`.
- [ ] Anotar no quadro do GitHub Projects que a RLS fica **desligada** até o Dia 13 e que só dados de teste são usados.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D9·A26 – Rodar o 01_schema.sql no Supabase: 8 tabelas, 4 gatilhos e 8 categorias

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia09-aula27-sql-basico-select-insert-e-join.md]({{URL_GUIA}}/dia09-aula27-sql-basico-select-insert-e-join.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-06** – Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos.
- **RF-16** – Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.

**Observação da aula:** Não se aplica (preparação dos dados; base de RF-01, RF-06 e RF-16; reforça RN-02 e RN-12)
