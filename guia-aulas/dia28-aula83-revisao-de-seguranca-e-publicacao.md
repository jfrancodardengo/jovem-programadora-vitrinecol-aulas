# Aula 83 – Revisão de segurança e publicação da versão final

**Dia 28 · Seg 16/11/2026** · **Aula 83** · **UC6**

- **Requisitos cobertos:** RN-05 (o fluxo de status é imposto pelo banco), RN-06 (o preço é copiado para o pedido e o banco calcula o total e confere o preço), RN-09 (só a lojista dona altera a loja, os produtos, as fotos e os pedidos recebidos) e RN-13 (a lojista não altera valores, itens, cliente nem loja; só o banco mexe nas marcas de visto); casos de teste CT-11, CT-18, CT-20 e CT-21
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** problemas críticos corrigidos e retestados, todos os PRs mergeados na main (Aula 82); sistema publicado no GitHub Pages

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer a **revisão de segurança** final: conferir que a **RLS** está ligada nas **8 tabelas**, que a **política provisória** de fotos **não existe**, que **nenhuma chave `service_role`** nem `innerHTML` com dados está no código, e **refazer pelo console** os testes de acesso indevido (CT-11, CT-18, CT-20 e CT-21). Depois, **publica a versão final** e confere o **endereço de retorno** da recuperação de senha.

**Abertura (10 minutos).** Retomada da Aula 82: as correções entraram. Mudar código pode **abrir uma brecha sem querer**. Por isso, antes de congelar a versão, a equipe confere as **fechaduras**. Lembre da Aula 39: a chave `anon` é pública e o navegador é "território da usuária"; quem protege os dados é o **banco**. Hoje vocês tentam "arrombar" o próprio sistema e conferem que ele recusa.

## O Conceito

**Termos desta aula**

- **Revisão de segurança**: uma lista de verificações que garantem que **só quem pode** vê ou muda cada dado, e que **nenhum segredo** vazou.
- **Teste de acesso indevido**: tentar fazer, pelo Console do navegador, algo **proibido** (alterar o produto de outra loja, forjar o preço, mudar o total do pedido) e **confirmar que o banco recusa**.
- **Segredo versus chave pública**: a chave `anon` é **pública** (qualquer pessoa vê no código) e está protegida pela RLS; a `service_role` é **secreta** e **ignora** a RLS: se vazar, o banco inteiro fica exposto.
- **Congelar para publicar**: parar de mexer e publicar o que foi **testado**, para o que está no ar ser exatamente o que passou nos testes.

**Analogia:** é a **ronda do vigia** antes de fechar o prédio: confere cada porta (as 8 tabelas com RLS), procura chaves esquecidas na fechadura (segredos no código) e tenta abrir portas proibidas para ver se travam.

## Mão na Massa

### Passo 1: confira o banco (RLS e políticas) (10 minutos)

No **SQL Editor** (em português: **Editor SQL**) do Supabase, rode cada consulta e compare com o esperado.

**1.1 RLS ligada nas 8 tabelas** (todas devem mostrar `true`):

```sql
select tablename, rowsecurity from pg_tables
where schemaname = 'public' order by tablename;
```

**1.2 Regras por tabela** (24 no total: categorias 1, itens_pedido 1, lojas 4, pedidos 2, perfis 3, produto_fotos 4, produtos 5 e tamanhos 4):

```sql
select tablename, count(*) as regras from pg_policies
where schemaname = 'public' group by tablename order by tablename;
```

**1.3 A política provisória de fotos não pode existir** (a consulta deve voltar **vazia**):

```sql
select policyname from pg_policies
where schemaname = 'storage' and policyname = 'dev: envio de fotos';
```

**1.4 Nenhuma regra de INSERT direto em pedidos e itens** (deve voltar `0`):

```sql
select count(*) from pg_policies
where tablename in ('pedidos', 'itens_pedido') and cmd = 'INSERT';
```

**1.5 As funções e os limites do bucket** (a primeira, 3 linhas; a segunda, `2097152` e os 3 tipos):

```sql
select proname from pg_proc
where proname in ('criar_pedidos', 'excluir_minha_conta', 'marcar_pedidos_como_vistos');

select file_size_limit, allowed_mime_types from storage.buckets where id = 'produtos';
```

Se algum resultado for diferente, **pare**: o problema é crítico. Rode de novo o `database/02_rls.sql` (e depois o `04_melhorias.sql`) e repita as consultas.

### Passo 2: confira o código (10 minutos)

Use **Ctrl+Shift+F** (em português: **Localizar nos arquivos**; no Mac Cmd+Shift+F) na pasta do projeto:

1. `service_role` e `secret`: nenhuma **chave**. (Só o comentário do `js/config.js`, que **proíbe** colocá-la.) No `js/config.js`, só a URL e a chave `anon`.
2. `innerHTML` em `js/`: **0 resultados**.
3. `PROVISÓRIO` e `alert(`: **0 resultados**.
4. No terminal, pesquise o **histórico**: `git log -S"service_role" --oneline`. Se aparecer um commit que **adicionou uma chave** de verdade (e não só o comentário), a chave **vazou**: no painel, em **Project Settings** (em português: **Configurações do projeto**), na parte **API**, gere uma chave nova e apague a antiga.
5. O arquivo `.env` (se existir) está no `.gitignore` e não foi para o GitHub.

### Passo 3: refaça os testes de acesso indevido pelo console (20 minutos)

Preparação: duas lojistas (A e B), cada uma com loja, produto e **um pedido recebido**, e uma cliente. Troque os textos em MAIÚSCULAS pelos ids reais (`select id, nome from public.produtos;`, `select id, status from public.pedidos;`).

**CT-11: a lojista B tenta mexer no produto da lojista A.** Entre como **lojista B**, abra qualquer página e o Console (F12 > **Console**, em português: **Console**):

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const id = "ID-DO-PRODUTO-DA-LOJISTA-A";
console.log("alterar produto  ->", await supabase.from("produtos").update({ nome: "HACK" }).eq("id", id).select("id"));
console.log("apagar produto   ->", await supabase.from("produtos").delete().eq("id", id).select("id"));
console.log("alterar tamanhos ->", await supabase.from("tamanhos").update({ estoque: 999 }).eq("produto_id", id).select("tamanho"));
console.log("apagar fotos     ->", await supabase.from("produto_fotos").delete().eq("produto_id", id).select("id"));
const arquivo = new File([new Uint8Array(10)], "hack.png", { type: "image/png" });
console.log("enviar foto      ->", await supabase.storage.from("produtos").upload("ID-DA-LOJA-A/teste/hack.png", arquivo));
```

Esperado: as quatro primeiras mostram `data: []` (nenhuma linha afetada) e a foto devolve `error` com **`new row violates row-level security policy`**. No painel da lojista A, **nada mudou**.

**CT-18: a lojista tenta alterar o total do pedido.** Como lojista **dona** do pedido:

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
console.log(await supabase.from("pedidos").update({ total: 1 }).eq("id", "ID-DO-PEDIDO").select("id"));
```

Esperado: `error` com **"Só o status e o recado do pedido podem ser alterados."**. Repita com a lojista **outra** (que não é dona): `data: []`.

**CT-20: pular uma etapa e mexer no aviso da cliente.** Com um pedido **novo** da sua loja:

```js
const id = "ID-DO-PEDIDO";
console.log("pular etapa  ->", (await supabase.from("pedidos").update({ status: "concluido" }).eq("id", id)).error?.message);
console.log("mexer no aviso ->", (await supabase.from("pedidos").update({ status_visto: true }).eq("id", id)).error?.message);
```

Esperado: **"Esta mudança de status não é permitida para este pedido."** para o primeiro. O segundo só é recusado depois que o pedido tem uma novidade (por exemplo, depois de confirmar): então a mensagem é **"Só o status e o recado do pedido podem ser alterados."**.

**CT-21: a cliente tenta forjar um pedido.** Como **cliente**, troque `ID-DE-UM-PRODUTO` e `ID-DA-LOJA`:

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const direto = await supabase.from("pedidos").insert({ cliente_id: crypto.randomUUID(), loja_id: "ID-DA-LOJA", total: 0.01 });
console.log("insert direto ->", direto.error?.message);
const forjado = await supabase.rpc("criar_pedidos", {
  p_grupo_id: crypto.randomUUID(),
  p_pedidos: [{ id: crypto.randomUUID(), loja_id: "ID-DA-LOJA",
    itens: [{ produto_id: "ID-DE-UM-PRODUTO", tamanho: "P", quantidade: 1, preco_unitario: 0.01 }] }],
});
console.log("preço forjado ->", forjado.error?.message);
```

Esperado: o primeiro é recusado por **row-level security**; o segundo diz que **o preço mudou**; nada é gravado (confira com `select count(*) from public.pedidos;`: não aumentou).

**Teste extra (visitante):** sem entrar em nenhuma conta, no Console, rode as linhas abaixo: as duas devolvem `data: []` (visitante não lê pedidos nem perfis).

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
console.log(await supabase.from("pedidos").select("id"));
console.log(await supabase.from("perfis").select("id"));
```

### Passo 4: publique a versão final e confira o retorno da senha (10 minutos)

1. Confirme que **todos** os PRs estão na `main` e que o GitHub Pages terminou de publicar (em **Settings > Pages**, em português: **Configurações > Páginas**, ou na aba **Actions**, em português: **Ações**, o último item está com ✓). Atualize com **Ctrl+Shift+R** (Cmd+Shift+R no Mac).
2. No painel do Supabase, **Authentication** (em português: **Autenticação**) e **URL Configuration** (em português: **Configuração de URL**): **Site URL** é o endereço publicado e **Redirect URLs** contém `https://SEU-USUARIO.github.io/vitrine-col/recuperar-senha.html`. Os endereços de teste (`127.0.0.1` e `localhost`) podem sair.
3. Faça o fluxo de **recuperação de senha** (CT-23) pelo site publicado, com uma conta de teste: o link do e-mail precisa abrir **o site publicado**.
4. Percorra o fluxo completo no site publicado: página inicial, catálogo, sacola, login, pedido, Meus pedidos, painel da lojista.

### Passo 5: registre e faça o commit da aula

Atualize o `docs/TESTES.md` (resultados novos de CT-11, CT-18, CT-20, CT-21 e CT-23, com data) e faça o commit na `main` por um pequeno PR (por exemplo, a branch `revisao-de-seguranca`):

```bash
git switch -c revisao-de-seguranca
git add .
git commit -m "Registra a revisão de segurança da versão final"
git push -u origin revisao-de-seguranca
```

## Explicação do Código

Esta aula é de verificação; veja o que cada conferência prova:

- **`rowsecurity = true` em todas as tabelas:** com a RLS ligada, **nada** é permitido sem uma política. Uma tabela com `false` está **aberta**.
- **Contagem de políticas:** uma política a menos pode significar uma permissão que não funciona; uma a mais, uma brecha. Os números (24 em `public`) vêm do `02_rls.sql`.
- **Política `dev: envio de fotos` inexistente:** ela deixava **qualquer pessoa, até sem login**, enviar arquivos. Na versão final, só a lojista dona envia, na pasta da própria loja.
- **Sem política de `INSERT` em `pedidos`:** ninguém grava pedido direto; só a função `criar_pedidos`, que confere preço e estoque e calcula o total no banco (RN-06).
- **Limite do bucket (2 MB, 3 tipos):** o **servidor** recusa arquivos fora do padrão, mesmo que alguém pule a validação do navegador.
- **`data: []` em vez de erro (CT-11):** quando a RLS impede, o banco **finge que a linha não existe** para quem não é dona. Por isso o `update` "funciona" sem alterar nada.
- **Mensagens dos gatilhos:** vêm **do banco** já em português (`raise exception ...`), e o `errosSupabase.js` as mostra como estão (código `P0001`).
- **Histórico do Git:** apagar uma chave do código **não a remove do histórico**. Por isso a pesquisa no histórico: se uma chave secreta já vazou, o único jeito seguro é **gerar uma nova**.

## Validação

1. As consultas do Passo 1 deram os resultados esperados (8 tabelas com `true`, 24 regras, política provisória ausente, 0 inserts diretos, 3 funções e limites do bucket).
2. A busca por `service_role`/`secret`, `innerHTML` em `js/`, `PROVISÓRIO` e `alert(` não encontrou nada indevido, e o histórico não tem chave secreta.
3. CT-11, CT-18, CT-20 e CT-21 foram refeitos e o banco **recusou** tudo.
4. O site publicado está na versão final e o link do e-mail de recuperação abre o **site publicado**.

**Erros comuns**

1. *Sintoma:* uma tabela aparece com `rowsecurity = false`. *Causa:* o `02_rls.sql` não foi rodado até o fim. *Correção:* rode-o de novo (ele pode ser repetido) e refaça as consultas.
2. *Sintoma:* no CT-21, o `rpc` devolve `permission denied for function criar_pedidos` (sem login) ou **Só contas de cliente fazem pedidos.** (logada como lojista). *Causa:* a conta usada não é de **cliente**. *Correção:* entre como **cliente**.
3. *Sintoma:* o CT-11 mostra `data` com a linha alterada. *Causa:* RLS desligada ou política errada. *Correção:* pare tudo: é **crítico**. Rode o `02_rls.sql` e refaça.
4. *Sintoma:* o link da recuperação de senha abre `localhost`. *Causa:* o **Site URL** (em português: **URL do site**) ainda é o de teste. *Correção:* repita o Passo 4, item 2.

**Se travar**

1. Rode a consulta que falhou **sozinha** e leia o resultado com calma.
2. No Console, veja a **Response** (em português: **Resposta**) do pedido na aba **Network** (em português: **Rede**): a mensagem diz qual regra recusou.
3. Se uma política estiver faltando, rode de novo o `02_rls.sql` e depois o `04_melhorias.sql`.
4. Só depois peça ajuda à sua equipe, colando a consulta e o resultado.

**Seu projeto agora tem**

- A **segurança revisada**: RLS ligada, política provisória apagada, sem segredos nem `innerHTML` com dados.
- Os testes de acesso indevido (CT-11, CT-18, CT-20 e CT-21) refeitos e registrados.
- A **versão final publicada** e o retorno da recuperação de senha conferido.

**Como saber que deu certo:** pelo console, o banco recusa o produto de outra loja, o total alterado, a etapa pulada e o preço forjado; e o site publicado funciona do começo ao fim.
