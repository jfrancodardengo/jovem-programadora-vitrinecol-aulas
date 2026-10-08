# Aula 26 – Criar as tabelas e os relacionamentos com SQL

**Dia 9 · Seg 19/10/2026** · **Aula 26** · **UC3**

- **Requisitos cobertos:** RN-01 (cada lojista tem no máximo uma loja), RN-02 (preço maior que zero, estoque não negativo, quantidade mínima 1), RN-11 (o perfil não muda depois do cadastro) e RN-12 (no máximo 5 fotos por produto)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** projeto criado no Supabase, com a senha do banco guardada, e o diagrama das 8 tabelas entendido (Aula 25)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai escrever, em **SQL**, as **8 tabelas** com seus tipos, chaves primárias e estrangeiras, regras `CHECK` e valores padrão, e os **gatilhos** do banco, e vai rodar tudo no **SQL Editor** do Supabase. Você também carrega as **8 categorias** (tipos de roupa).

**Abertura (10 minutos).** Retomada da Aula 25: o projeto Supabase está vazio e o diagrama das 8 tabelas está claro. Abra o painel, entre em **Table Editor** (em português: **Editor de tabelas**) e confirme que **não há tabelas**. Hoje elas nascem. Atenção: **este é o script mais comprido do curso**; a maior parte é copiar, colar e entender o que cada pedaço faz.

## O Conceito

**Termos desta aula**

- **SQL**: a linguagem para conversar com bancos de dados relacionais (criar tabelas, guardar e consultar dados).
- **`CREATE TABLE`**: comando que cria uma tabela, listando as colunas, o **tipo** de cada uma (`text` = texto, `uuid` = identificador único, `numeric(10,2)` = número com 2 casas, `integer` = inteiro, `boolean` = verdadeiro/falso, `timestamptz` = data e hora) e as **regras**.
- **`CHECK`**: uma regra que o banco confere a cada linha gravada. `check (preco > 0)` faz o banco recusar um preço zero ou negativo, mesmo que o site esqueça de conferir.
- **Gatilho (trigger)**: uma ação que o banco executa **sozinho** quando acontece algo (por exemplo, "antes de inserir uma foto, conte quantas o produto já tem e recuse a 6ª").

**Analogia:** o `CREATE TABLE` é desenhar o formulário em branco (as colunas e as regras de preenchimento); o `CHECK` é o carimbo "não aceitar se estiver errado"; o gatilho é o **porteiro** que confere cada pessoa que entra, sem ninguém pedir.

**Palavras-chave que você vai ver:** `primary key` (chave primária), `references` (chave estrangeira), `not null` (obrigatório), `unique` (não repete), `default` (valor padrão), `on delete cascade` (apagar a linha "mãe" apaga as "filhas").

> **Sobre o idioma:** o painel do Supabase continua em inglês; os nomes dos menus aparecem como na tela e a tradução em português vem em seguida. Os nomes de tabelas e colunas, em português sem acento, ficam como estão.

## Mão na Massa

### Passo 1: crie o arquivo com as tabelas

Crie a pasta `database` na raiz do projeto e, dentro dela, o arquivo `01_schema.sql`. Cole a **Parte 1** (as 8 tabelas e os índices):

**Arquivo: `database/01_schema.sql`** (arquivo novo):

```sql
-- 01_schema.sql — Estrutura do banco da plataforma de moda local
-- Rodar no SQL Editor do Supabase.

create table public.perfis (
  id uuid primary key references auth.users (id) on delete cascade,
  nome text not null,
  tipo text not null check (tipo in ('cliente', 'lojista')),
  telefone text check (telefone ~ '^[0-9]{12,13}$'),
  criado_em timestamptz not null default now()
);

create table public.lojas (
  id uuid primary key default gen_random_uuid(),
  dono_id uuid not null unique references public.perfis (id) on delete cascade,
  nome text not null,
  descricao text,
  endereco text not null,
  cidade text not null,
  whatsapp text check (whatsapp ~ '^[0-9]{12,13}$'),
  link_mapa text,
  imagem_url text,
  criado_em timestamptz not null default now()
);

create table public.categorias (
  id bigint generated always as identity primary key,
  nome text not null unique
);

create table public.produtos (
  id uuid primary key default gen_random_uuid(),
  loja_id uuid not null references public.lojas (id) on delete cascade,
  categoria_id bigint not null references public.categorias (id),
  nome text not null,
  descricao text,
  preco numeric(10,2) not null check (preco > 0),
  ativo boolean not null default true,
  criado_em timestamptz not null default now()
);

-- RN-12: até 5 fotos por produto; a de menor ordem é a capa
create table public.produto_fotos (
  id uuid primary key default gen_random_uuid(),
  produto_id uuid not null references public.produtos (id) on delete cascade,
  url text not null,
  caminho text, -- caminho do arquivo no Storage (vazio se a foto for um link externo)
  ordem integer not null default 1 check (ordem between 1 and 5),
  criado_em timestamptz not null default now()
);

create table public.tamanhos (
  produto_id uuid not null references public.produtos (id) on delete cascade,
  tamanho text not null,
  estoque integer not null default 0 check (estoque >= 0),
  primary key (produto_id, tamanho)
);

create table public.pedidos (
  id uuid primary key default gen_random_uuid(),
  cliente_id uuid not null references public.perfis (id),
  loja_id uuid not null references public.lojas (id),
  status text not null default 'novo'
    check (status in ('novo', 'confirmado', 'concluido', 'cancelado')),
  total numeric(10,2) not null check (total >= 0),
  observacao text,
  -- RN-03: pedidos criados na mesma finalização da sacola (um por loja) compartilham o grupo_id
  grupo_id uuid not null default gen_random_uuid(),
  -- RN-13: recado da lojista e controle de aviso à cliente
  mensagem_loja text,
  status_visto boolean not null default true,
  atualizado_em timestamptz not null default now(),
  criado_em timestamptz not null default now()
);

create table public.itens_pedido (
  id uuid primary key default gen_random_uuid(),
  pedido_id uuid not null references public.pedidos (id) on delete cascade,
  produto_id uuid not null references public.produtos (id),
  tamanho text not null,
  quantidade integer not null check (quantidade >= 1),
  preco_unitario numeric(10,2) not null check (preco_unitario > 0)
);

create index on public.produtos (loja_id);
create index on public.produtos (categoria_id);
create index on public.produto_fotos (produto_id);
create index on public.pedidos (cliente_id);
create index on public.pedidos (loja_id);
create index on public.pedidos (grupo_id);
create index on public.itens_pedido (pedido_id);

```


### Passo 2: rode a Parte 1 no Supabase

1. No painel do Supabase, abra o **SQL Editor** (em português: **Editor SQL**) e clique em **New query** (em português: **Nova consulta**).
2. Copie a Parte 1 do arquivo (do primeiro `create table` ao último `create index`), cole na consulta e clique em **Run** (em português: **Executar**).
3. Se o painel mostrar um aviso sobre **RLS** (segurança por linha) ao criar tabelas, escolha a opção que executa **sem** ativar a RLS (por exemplo **Run without RLS**, em português: **Executar sem RLS**). A segurança por linha entra no Dia 13; ligá-la agora travaria as telas que você vai construir até lá.
4. Deve aparecer a mensagem **Success. No rows returned** (em português: **Sucesso. Nenhuma linha retornada**).

Confira se as 8 tabelas existem. Rode esta consulta em uma nova consulta: devem aparecer **8 linhas** (categorias, itens_pedido, lojas, pedidos, perfis, produto_fotos, produtos, tamanhos):

```sql
select table_name from information_schema.tables
where table_schema = 'public' order by table_name;
```

### Passo 3: acrescente os gatilhos ao arquivo

Cole a **Parte 2** **no final** do `database/01_schema.sql`: são quatro gatilhos (cria o perfil de quem se cadastra; impede trocar o tipo do perfil; limita as fotos a 5; protege o pedido e marca novidades para a cliente) e uma função usada pela cliente:

**Arquivo: `database/01_schema.sql`**: adicione este trecho no final do arquivo:

```sql
-- Gatilho: cria o perfil quando uma usuária se cadastra (lê nome e tipo enviados no cadastro)
create or replace function public.criar_perfil_novo_usuario()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  -- só dígitos; vale apenas se tiver código do país + DDD + número (12 ou 13 dígitos)
  v_telefone text := regexp_replace(coalesce(new.raw_user_meta_data ->> 'telefone', ''), '[^0-9]', '', 'g');
begin
  insert into public.perfis (id, nome, tipo, telefone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'nome', 'Sem nome'),
    case when new.raw_user_meta_data ->> 'tipo' = 'lojista' then 'lojista' else 'cliente' end,
    case when v_telefone ~ '^[0-9]{12,13}$' then v_telefone else null end
  );
  return new;
end;
$$;

create trigger ao_criar_usuario
after insert on auth.users
for each row execute function public.criar_perfil_novo_usuario();

-- RN-11: o perfil (cliente ou lojista) não muda depois do cadastro
create or replace function public.impedir_troca_de_tipo()
returns trigger
language plpgsql
as $$
begin
  if new.tipo <> old.tipo then
    raise exception 'O perfil da usuária não pode ser alterado.';
  end if;
  return new;
end;
$$;

create trigger perfis_nao_troca_tipo
before update on public.perfis
for each row execute function public.impedir_troca_de_tipo();

-- RN-12: no máximo 5 fotos por produto
create or replace function public.limitar_fotos_por_produto()
returns trigger
language plpgsql
as $$
begin
  if (select count(*) from public.produto_fotos where produto_id = new.produto_id) >= 5 then
    raise exception 'Cada produto pode ter no máximo 5 fotos.';
  end if;
  return new;
end;
$$;

create trigger fotos_limite_por_produto
before insert on public.produto_fotos
for each row execute function public.limitar_fotos_por_produto();

-- RN-13: a lojista só altera status e recado; quando eles mudam, a cliente passa a ter uma novidade
create or replace function public.proteger_e_marcar_pedido()
returns trigger
language plpgsql
as $$
begin
  if new.cliente_id <> old.cliente_id
     or new.loja_id <> old.loja_id
     or new.total <> old.total
     or new.grupo_id <> old.grupo_id
     or new.criado_em <> old.criado_em
     or new.observacao is distinct from old.observacao then
    raise exception 'Só o status e o recado do pedido podem ser alterados.';
  end if;

  if new.status <> old.status or new.mensagem_loja is distinct from old.mensagem_loja then
    new.status_visto := false;
    new.atualizado_em := now();
  end if;
  return new;
end;
$$;

create trigger pedidos_protegidos
before update on public.pedidos
for each row execute function public.proteger_e_marcar_pedido();

-- RN-13: a cliente abre Meus pedidos e marca as novidades como vistas.
-- É uma função (e não um update direto) para a cliente não poder alterar nenhuma outra coluna.
create or replace function public.marcar_pedidos_como_vistos()
returns void
language sql
security definer
set search_path = public
as $$
  update public.pedidos
  set status_visto = true
  where cliente_id = auth.uid() and status_visto = false;
$$;

revoke execute on function public.marcar_pedidos_como_vistos() from public, anon;
grant execute on function public.marcar_pedidos_como_vistos() to authenticated;
```


### Passo 4: rode a Parte 2

Em uma nova consulta, cole a Parte 2 (do comentário `-- Gatilho: cria o perfil...` até o fim) e clique em **Run** (em português: **Executar**). Depois rode:

```sql
-- os 4 gatilhos (devem aparecer 4 linhas)
select tgname from pg_trigger where not tgisinternal order by tgname;

-- as regras CHECK (preço > 0, estoque >= 0, até 5 de ordem, quantidade >= 1...)
select conrelid::regclass as tabela, conname, pg_get_constraintdef(oid) as regra
from pg_constraint
where connamespace = 'public'::regnamespace and contype = 'c'
order by 1, 2;
```

### Passo 5: crie e rode as categorias

Crie o arquivo `database/03_seed.sql` com o começo abaixo (o resto do arquivo vem na próxima aula). **Dica:** o comentário do topo diz "Fase 3", que é uma anotação de um roteiro antigo: pode ignorar.

**Arquivo: `database/03_seed.sql`** (arquivo novo):

```sql
-- 03_seed.sql — Dados iniciais
-- Parte 1: categorias (pode rodar já na Fase 3).
insert into public.categorias (nome) values
  ('Blusas'), ('Camisetas'), ('Vestidos'), ('Calças'),
  ('Saias'), ('Shorts'), ('Jaquetas'), ('Acessórios')
on conflict (nome) do nothing;

```


Copie esse conteúdo para uma nova consulta no **SQL Editor** (em português: **Editor SQL**) e rode. Confira com:

```sql
select id, nome from public.categorias order by id;
```

Devem aparecer 8 linhas: Blusas, Camisetas, Vestidos, Calças, Saias, Shorts, Jaquetas e Acessórios.

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Cria o esquema do banco (8 tabelas e gatilhos) e as categorias"
git push
```

## Explicação do Código

**Parte 1: as tabelas** (leia uma por uma, sempre conferindo com o diagrama da Aula 25)

- `perfis`: `id uuid primary key references auth.users (id) on delete cascade`: o `id` é o **mesmo** da usuária no login do Supabase (chave primária e também estrangeira), e se a conta for apagada o perfil some junto. `nome text not null` é obrigatório. `tipo text not null check (tipo in ('cliente', 'lojista'))` aceita só essas duas palavras. `telefone ... check (telefone ~ '^[0-9]{12,13}$')`: se preenchido, tem de ter só dígitos, 12 ou 13 (RN-10); o `~` testa uma "expressão regular". `criado_em timestamptz not null default now()` grava a data e a hora de agora, sozinho.
- `lojas`: `id uuid primary key default gen_random_uuid()` gera um identificador novo automaticamente. `dono_id uuid not null unique references public.perfis (id)`: é a lojista dona da loja, e o **`unique`** garante que a mesma lojista **não** tem duas lojas (RN-01). Os campos `nome`, `endereco` e `cidade` são obrigatórios; `descricao`, `link_mapa` e `imagem_url` são opcionais (sem `not null`); `whatsapp` tem o mesmo `check` do telefone.
- `categorias`: `id bigint generated always as identity primary key` é um número que cresce sozinho (1, 2, 3...). `nome text not null unique`.
- `produtos`: `loja_id ... references public.lojas (id) on delete cascade` (apagar a loja apaga os produtos); `categoria_id bigint not null references public.categorias (id)`; `preco numeric(10,2) not null check (preco > 0)` (RN-02); `ativo boolean not null default true` (RN-08).
- `produto_fotos`: `produto_id` com `on delete cascade`; `url text not null` (endereço da imagem); `caminho text` (onde o arquivo está no Storage, vazio se for link externo); `ordem integer not null default 1 check (ordem between 1 and 5)` (a menor ordem é a capa, RN-12).
- `tamanhos`: **chave primária composta** `primary key (produto_id, tamanho)`: um produto não repete o mesmo tamanho. `estoque integer not null default 0 check (estoque >= 0)` (RN-02).
- `pedidos`: `cliente_id` e `loja_id` obrigatórios; `status text not null default 'novo' check (status in ('novo', 'confirmado', 'concluido', 'cancelado'))`; `total numeric(10,2) ... check (total >= 0)`; `grupo_id uuid not null default gen_random_uuid()` é o código da compra (RN-03); `mensagem_loja`, `status_visto boolean default true` e `atualizado_em` servem ao aviso da cliente (RN-13).
- `itens_pedido`: `pedido_id ... on delete cascade`; `produto_id ... references public.produtos (id)` **sem** cascade (por isso um produto já pedido **não pode ser excluído**); `quantidade integer not null check (quantidade >= 1)` (RN-02); `preco_unitario ... check (preco_unitario > 0)` guarda o preço da compra (RN-06).
- `create index on public.produtos (loja_id);` etc.: **índices** são como o índice de um livro: deixam as buscas por loja, categoria, pedido etc. mais rápidas.

**Parte 2: gatilhos e função**

- `criar_perfil_novo_usuario()` + `trigger ao_criar_usuario ... after insert on auth.users`: quando alguém se cadastra (nova linha em `auth.users`), o banco cria **sozinho** a linha em `perfis`, lendo o nome, o tipo e o telefone enviados no cadastro (`raw_user_meta_data`). O telefone só é aceito se tiver 12 ou 13 dígitos. `security definer` faz a função rodar com os direitos do dono do banco (necessário, porque a pessoa ainda não tem permissão para escrever em `perfis`).
- `impedir_troca_de_tipo()` + `perfis_nao_troca_tipo`: antes de atualizar um perfil, se o `tipo` mudou, o banco **lança um erro** (`raise exception`). É a **RN-11**.
- `limitar_fotos_por_produto()` + `fotos_limite_por_produto`: antes de inserir uma foto, conta quantas o produto já tem; se já são 5, recusa. É a **RN-12** garantida no banco.
- `proteger_e_marcar_pedido()` + `pedidos_protegidos`: a lojista só pode mudar status e recado do pedido (qualquer outra mudança é recusada) e, quando muda, o pedido fica "não visto" para a cliente (RN-13). Será melhorada no Dia 13.
- `marcar_pedidos_como_vistos()`: função usada pela cliente quando abre **Meus pedidos**, para marcar as novidades como vistas. As linhas `revoke` e `grant` no fim controlam **quem pode chamá-la** (só quem está logada).

**03_seed.sql**: um `insert` das 8 categorias, com `on conflict (nome) do nothing` ("se o nome já existe, ignore"), para poder rodar de novo sem erro.

## Validação

1. A consulta de tabelas devolve exatamente **8 linhas**.
2. A consulta de gatilhos devolve **4 linhas** (`ao_criar_usuario`, `fotos_limite_por_produto`, `perfis_nao_troca_tipo` e `pedidos_protegidos`).
3. A consulta de `CHECK` lista as regras de preço, estoque, ordem, quantidade, status e tipo.
4. A consulta das categorias devolve as 8 categorias.
5. No **Table Editor** (em português: **Editor de tabelas**) aparecem as 8 tabelas.

**Erros comuns**

1. *Mensagem:* `relation "perfis" already exists`. *Causa:* a Parte 1 já foi rodada. *Correção:* não rode de novo; confira as tabelas com a consulta do Passo 2.
2. *Mensagem:* `syntax error at or near ...`. *Causa:* faltou copiar o final de um comando (por exemplo, o `);` de uma tabela). *Correção:* copie o script inteiro, do começo ao fim, sem cortar linhas.
3. *Mensagem:* `relation "public.perfis" does not exist` ao rodar a Parte 2. *Causa:* a Parte 1 não foi rodada antes. *Correção:* rode a Parte 1 e depois a 2.
4. *Sintoma:* a consulta das categorias volta vazia. *Causa:* o `03_seed.sql` ainda não foi executado. *Correção:* rode o conteúdo do arquivo no **SQL Editor** (em português: **Editor SQL**).

**Se travar**

1. Leia a mensagem de erro do painel: ela mostra a linha e o termo com problema.
2. Rode a consulta de tabelas para ver até onde o script foi.
3. Se algo ficou pela metade, apague **só** as tabelas que o script criou (no **Table Editor**, em português: **Editor de tabelas**, clique nos três pontinhos de cada tabela e em **Delete table**, em português: **Excluir tabela**) e rode a Parte 1 de novo. Não use comandos que apagam o banco inteiro.
4. Só depois peça ajuda à sua equipe, colando a mensagem exata.

**Seu projeto agora tem**

- `database/01_schema.sql` e `database/03_seed.sql` (só a primeira parte, as categorias).
- No Supabase: 8 tabelas com índices, 4 gatilhos, a função das novidades e as 8 categorias.
- O resto do projeto como na Aula 24.

**Como saber que deu certo:** você abre o **Table Editor** (em português: **Editor de tabelas**), vê as 8 tabelas e, em `categorias`, as 8 linhas.
