# Aula 27 – SQL básico: SELECT, INSERT e JOIN, com dados de exemplo

**Dia 9 · Seg 19/10/2026** · **Aula 27** · **UC3**

- **Requisitos cobertos:** não se aplica (preparação dos dados de teste; base de RF-01, RF-06 e RF-16); reforça RN-02 e RN-12 testando as regras do banco
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** 8 tabelas, 4 gatilhos e 8 categorias criados no Supabase; database/01_schema.sql e database/03_seed.sql com a primeira parte (Aula 26)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai aprender os comandos **SELECT**, **WHERE**, **ORDER BY**, **INSERT** e **JOIN**, criar a **lojista de teste** no painel de autenticação e rodar o bloco que cria **uma loja e 3 produtos de exemplo**. Também vai entender por que a segurança por linha (RLS) fica desligada até o Dia 13.

**Abertura (10 minutos).** Retomada da Aula 26: as 8 tabelas existem, mas só `categorias` tem dados. Para o catálogo ter o que mostrar, precisamos de uma loja e de produtos. Uma loja pertence a uma lojista, e uma lojista é uma usuária do login do Supabase. Então hoje vamos: (1) aprender a consultar e inserir; (2) criar a lojista de teste; (3) carregar os produtos de exemplo.

## O Conceito

**Termos desta aula**

- **`SELECT`**: pede dados. `select nome, preco from public.produtos;` devolve duas colunas de todas as linhas. `select *` devolve todas as colunas.
- **`WHERE` e `ORDER BY`**: `where` escolhe **quais linhas** (`where preco > 100`); `order by` define a ordem (`order by preco desc` = do maior para o menor).
- **`INSERT`**: grava uma linha nova: `insert into tabela (colunas) values (valores);`.
- **`JOIN`**: junta duas tabelas pela chave estrangeira. `produtos p join lojas l on l.id = p.loja_id` liga cada produto à sua loja, para mostrar o **nome da loja** ao lado do produto.

**Analogia:** o `SELECT` é pedir ao arquivista "traga as fichas de produtos"; o `WHERE` é "só as que custam mais de 100"; o `JOIN` é "e, junto de cada ficha, traga a ficha da loja correspondente".

**Por que a RLS fica desligada até o Dia 13?** A **RLS** (segurança por linha) são regras que dizem quem pode ver e mudar cada linha. Enquanto o login não existe no site (ele chega no Dia 13), nenhuma tela saberia "quem" está pedindo, e as regras bloqueariam tudo. Então, até lá, as tabelas ficam **sem RLS** e usamos **só dados de teste**.

> **Atenção:** com a RLS desligada, qualquer pessoa que tenha a chave pública do projeto consegue ler e alterar as tabelas. Use só dados de teste e **não divulgue** o endereço do site com dados reais até o Dia 13.

## Mão na Massa

### Passo 1: consultas com SELECT, WHERE e ORDER BY

No **SQL Editor** (em português: **Editor SQL**) do Supabase, abra uma **New query** (em português: **Nova consulta**) e rode (**Run**, em português: **Executar**) cada consulta, uma por vez, olhando o resultado:

```sql
select * from public.categorias;
select nome from public.categorias order by nome;
select nome from public.categorias where nome like 'S%';
select id, nome from public.categorias where id <= 3 order by id desc;
```

A terceira devolve as categorias que **começam com S** (`like 'S%'`): Saias e Shorts.

### Passo 2: INSERT e DELETE de teste

```sql
insert into public.categorias (nome) values ('Teste');
select * from public.categorias;
delete from public.categorias where nome = 'Teste';
```

Você inseriu uma categoria, viu a nova linha e a apagou. **Cuidado:** um `delete` **sem** `where` apaga a tabela inteira. Sempre confira o `where`.

### Passo 3: crie a lojista de teste no painel

1. No menu da esquerda, abra **Authentication** (em português: **Autenticação**) e depois **Users** (em português: **Usuários**).
2. Clique em **Add user** (em português: **Adicionar usuário**) e em **Create new user** (em português: **Criar novo usuário**).
3. Preencha um **Email** que você consiga acessar e uma **Password** (em português: **Senha**) com pelo menos 6 caracteres. Se houver a opção **Auto Confirm User** (em português: **Confirmar usuária automaticamente**), marque.
4. Se o formulário tiver o campo de metadados (**User Metadata**, em português: **Metadados do usuário**), cole:

```json
{"nome": "Lojista Teste", "tipo": "lojista"}
```

5. Clique em **Create user** (em português: **Criar usuário**). Depois **copie o id** da usuária (coluna **UID**, um texto parecido com `3f2b8c1e-9d4a-4c7e-8a51-0b6d2e7f9a10`).
6. Confira se o gatilho criou o perfil. No **SQL Editor** (em português: **Editor SQL**):

```sql
select id, nome, tipo from public.perfis;
```

Deve aparecer **uma linha** com nome `Lojista Teste` e tipo `lojista`. **Se aparecer `Sem nome` e `cliente`**: o formulário não aceitou os metadados. Como o tipo do perfil não pode ser trocado, corrija apagando e recriando o perfil. Troque `COLE-O-ID-AQUI` pelo id copiado, nas duas linhas:

```sql
delete from public.perfis where id = 'COLE-O-ID-AQUI';
insert into public.perfis (id, nome, tipo) values ('COLE-O-ID-AQUI', 'Lojista Teste', 'lojista');
```

### Passo 4: o bloco que cria a loja e os 3 produtos

O bloco é longo, então ele está em um **material**: o arquivo é copiado para o final do seu `database/03_seed.sql`.

**Material:** `docs/guia-aulas/materiais/03_seed_parte2.sql` (58 linhas). Abra esse arquivo, selecione tudo (Ctrl+A no Windows, Cmd+A no Mac), copie (Ctrl+C / Cmd+C) e cole no final de `database/03_seed.sql`.


Agora rode o bloco no Supabase:

1. Copie, do `03_seed.sql`, **somente o bloco**: do `do $$` até o `$$;` do final. Cole em uma **nova consulta** do **SQL Editor** (em português: **Editor SQL**).
2. Nessa cópia (no editor do Supabase, **não** no arquivo do projeto), procure a linha `v_dono uuid := '00000000-0000-0000-0000-000000000000';` e troque os zeros pelo **id da lojista de teste**, mantendo as aspas. No arquivo do projeto, deixe os zeros: o id é da **sua** conta de teste e não precisa ficar no repositório.
3. Clique em **Run** (em português: **Executar**). Deve aparecer **Success**.

### Passo 5: consultas com JOIN

```sql
select nome, cidade, whatsapp from public.lojas;

select p.nome as produto, p.preco, l.nome as loja
from public.produtos p
join public.lojas l on l.id = p.loja_id
order by p.preco desc;

select p.nome,
       count(distinct f.id) as fotos,
       count(distinct t.tamanho) as tamanhos
from public.produtos p
left join public.produto_fotos f on f.produto_id = p.id
left join public.tamanhos t on t.produto_id = p.id
group by p.nome order by p.nome;
```

A última consulta deve mostrar:

| nome | fotos | tamanhos |
| --- | --- | --- |
| Calça jeans reta | 1 | 3 |
| Camiseta básica branca | 2 | 3 |
| Vestido midi floral | 3 | 3 |

### Passo 6: teste as regras do banco

Rode cada comando e veja o erro **esperado**:

```sql
-- preço zero: o banco recusa (check preco > 0)
insert into public.produtos (loja_id, categoria_id, nome, preco)
select id, 1, 'Produto inválido', 0 from public.lojas limit 1;

-- uma segunda loja para a mesma lojista: recusa (unique)
insert into public.lojas (dono_id, nome, endereco, cidade)
select dono_id, 'Outra loja', 'Rua X', 'Cidade' from public.lojas limit 1;
```

Os erros devem citar `violates check constraint "produtos_preco_check"` e `duplicate key value violates unique constraint "lojas_dono_id_key"`. Depois, teste o **limite de 5 fotos**: o "Vestido midi floral" já tem 3. Rode as duas linhas abaixo (devem funcionar) e depois a terceira (deve falhar com **Cada produto pode ter no máximo 5 fotos.**):

```sql
insert into public.produto_fotos (produto_id, url, ordem) select id, 'https://exemplo.com/a.jpg', 4 from public.produtos where nome = 'Vestido midi floral';
insert into public.produto_fotos (produto_id, url, ordem) select id, 'https://exemplo.com/b.jpg', 5 from public.produtos where nome = 'Vestido midi floral';
insert into public.produto_fotos (produto_id, url, ordem) select id, 'https://exemplo.com/c.jpg', 5 from public.produtos where nome = 'Vestido midi floral';
```

Limpe as fotos de teste:

```sql
delete from public.produto_fotos where url like 'https://exemplo.com/%';
```

### Passo 7: faça o commit da aula

```bash
git add .
git commit -m "Completa o seed com a loja e os produtos de exemplo"
git push
```

## Explicação do Código

- `select ... from public.categorias`: `public` é o "esquema" (a pasta) onde as nossas tabelas moram; `categorias` é a tabela.
- `like 'S%'`: o `%` significa "qualquer coisa depois"; `S%` = "começa com S".
- `order by id desc`: `desc` é do maior para o menor (`asc`, o padrão, é do menor para o maior).
- `insert into public.categorias (nome) values ('Teste');`: grava uma linha informando só a coluna `nome`; o `id` é gerado sozinho.
- `delete from ... where ...`: apaga as linhas que passam no `where`.
- **O bloco do seed (`do $$ ... $$;`)**: é um pequeno programa do banco. Declara variáveis (`v_dono`, `v_loja`, `v_produto`), insere a loja (`returning id into v_loja` guarda o id gerado), depois, para cada produto, insere o produto, os tamanhos (`values (v_produto, 'P', 3), ...`) e as fotos. Por usar a **variável** do id gerado, ele liga cada peça ao produto certo. O `(select id from public.categorias where nome = 'Vestidos')` busca o id da categoria pelo nome. As fotos de exemplo usam endereços do site `picsum.photos` (imagens aleatórias para testes).
- **`join ... on l.id = p.loja_id`**: liga cada produto (`p`) à sua loja (`l`) comparando a chave estrangeira com a chave primária. `p` e `l` são **apelidos** das tabelas. `as loja` dá nome à coluna do resultado.
- **`left join`**: mantém o produto mesmo que ele não tenha foto (um `join` comum o esconderia). `count(distinct ...)` conta valores diferentes e `group by` agrupa por produto.
- **Os testes de regras**: provam que o **banco** recusa dados inválidos mesmo que o site esqueça de conferir: `check`, `unique` e o gatilho de fotos.

## Validação

1. As consultas do Passo 1 e 2 funcionaram e a categoria `Teste` foi apagada.
2. `select id, nome, tipo from public.perfis;` mostra `Lojista Teste` com tipo `lojista`.
3. Existem **1 loja e 3 produtos**, com 3, 2 e 1 fotos e 3 tamanhos cada (a tabela do Passo 5).
4. Os testes do Passo 6 geraram os 3 erros esperados e as fotos de teste foram apagadas.
5. O `database/03_seed.sql` tem as duas partes e o `v_dono` com os zeros.

**Erros comuns**

1. *Mensagem:* `insert or update on table "lojas" violates foreign key constraint "lojas_dono_id_fkey"`. *Causa:* o id no `v_dono` não é de uma usuária que existe (ou ainda são os zeros). *Correção:* refaça o Passo 3 e troque o id corretamente.
2. *Mensagem:* `duplicate key value violates unique constraint "lojas_dono_id_key"`. *Causa:* a lojista de teste já tem uma loja (o bloco foi rodado duas vezes). *Correção:* para repetir, apague a loja com `delete from public.lojas where dono_id = 'COLE-O-ID-AQUI';` (os produtos, tamanhos e fotos somem junto) e rode o bloco de novo.
3. *Sintoma:* o perfil apareceu como `Sem nome` / `cliente`. *Causa:* os metadados não foram aceitos no formulário. *Correção:* use o comando de apagar e recriar do Passo 3.
4. *Mensagem:* `syntax error at or near "do"`. *Causa:* o bloco foi copiado sem a primeira linha `do $$` ou sem o `$$;` final. *Correção:* copie do `do $$` até o `$$;` inclusive.

**Se travar**

1. Leia a mensagem do painel inteira: o nome da regra violada (`..._check`, `..._key`, `..._fkey`) diz qual é o problema.
2. Conferir os dados com `select * from public.perfis;` e `select * from public.lojas;`.
3. Compare o bloco com o do material.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata.

**Seu projeto agora tem**

- `database/01_schema.sql` e `database/03_seed.sql` completos (as duas partes), e o material `docs/guia-aulas/materiais/03_seed_parte2.sql`.
- No Supabase: a lojista de teste, a **Loja Exemplo** e 3 produtos com tamanhos e fotos.
- Fim do **Dia 9**: banco criado e populado.

**Como saber que deu certo:** a consulta com `join` mostra os 3 produtos com o nome da **Loja Exemplo** ao lado.
