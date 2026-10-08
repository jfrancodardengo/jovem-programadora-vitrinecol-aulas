# Aula 41 – Depuração e testes: DevTools, console e os 25 casos de teste

**Dia 14 · Seg 26/10/2026** · **Aula 41** · **UC3**

- **Requisitos cobertos:** verificação de RF-01 a RF-10, RF-12 a RF-16, RF-18, RF-19, RF-21, RF-23 e RF-24 (os casos de teste CT-01 a CT-25; o CT-17, o CT-18, o CT-20 e o CT-24 dependem de telas do Dia 26, então ficam como N/A por enquanto)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** sistema com catálogo, sacola, pedido gravado, login, recuperação de senha, painel da lojista, RLS e página inicial de vitrine (Aulas 29 a 40)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai conhecer as **ferramentas do navegador (DevTools)** para encontrar erros (Console, Rede e Elementos), aprender a **simular uma falha de conexão**, executar os **casos de teste CT-01 a CT-25** em duplas, registrar **OK, FALHOU ou N/A** e anotar os **defeitos** encontrados.

**Abertura (10 minutos).** Retomada da Aula 40: o fluxo completo existe (vitrine, catálogo, sacola, login, pedido, painel). Ninguém sabe ainda **se funciona em todos os casos**. Hoje a equipe vira "usuária exigente": tenta do jeito certo e do jeito errado, e anota o que quebra. Combinem as duplas e dividam os casos: uma dupla fica com CT-01 a CT-08, outra com CT-09 a CT-16 e outra com CT-17 a CT-25 (se a equipe tiver 4 ou 5 pessoas, façam duplas e um trio).

## O Conceito

**Termos desta aula**

- **Depuração (debug)**: procurar a **causa** de um erro e corrigi-lo. Um erro de programa chama-se **bug** (ou **defeito**).
- **Caso de teste**: uma situação a testar, com **passos** (o que fazer) e **resultado esperado** (o que deve acontecer). Cada caso tem um código: CT-01, CT-02...
- **DevTools**: as "ferramentas do desenvolvedor" do navegador (tecla **F12**). Três abas importam hoje: **Console** (mensagens e erros do JavaScript), **Network** (em português: **Rede**: cada pedido que a página faz e a resposta) e **Elements** (em português: **Elementos**: o HTML que o navegador está usando agora, com os estilos).
- **Gravidade**: o quanto o defeito atrapalha: **crítico** (impede o fluxo principal), **importante** (atrapalha, mas há um jeito) ou **desejável** (é um detalhe).

**Analogia:** testar é fazer o papel do **cliente-mistério** de uma loja: ele finge ser uma cliente de verdade, percorre o caminho todo e anota o que travou, sem avisar a equipe antes.

**Regra de ouro:** **reproduza** o defeito antes de anotá-lo (consiga fazê-lo acontecer de novo) e registre **a tela, o passo e o que aconteceu**.

## Mão na Massa

### Passo 1: conheça as três abas (10 minutos)

Abra o catálogo e aperte **F12** (no Mac: Cmd+Option+I).

1. **Console** (em português: **Console**): digite `1 + 1` e Enter: aparece `2`. Os erros do JavaScript aparecem em **vermelho**, com o nome do arquivo e a linha: clique neles.
2. **Elements** (em português: **Elementos**): clique no ícone de seta no canto da janela e depois em um card: o HTML dele aparece. Dê dois cliques no texto do preço e **mude-o**: a página muda (é só um teste local; recarregue e volta).
3. **Network** (em português: **Rede**): recarregue a página: cada linha é um pedido (HTML, CSS, JavaScript, imagens, consultas ao Supabase). **Status 200** = deu certo; **404** = não encontrou; **500** ou vermelho = erro. Clique em um pedido e veja **Headers** (em português: **Cabeçalhos**) e **Response** (em português: **Resposta**).
4. **Simular falha de conexão:** na aba **Network** (em português: **Rede**), mude **No throttling** para **Offline**, recarregue o catálogo e tente trocar um filtro. Deve aparecer uma mensagem em **português** e nenhuma tela em branco (CT-15). Volte para **No throttling**.

### Passo 2: crie o arquivo do plano de testes

Crie a pasta `docs` (se ainda não existir) e, dentro dela, o arquivo `TESTES.md` com o conteúdo abaixo. Ele é a lista dos 25 casos, cada um com os passos e o resultado esperado, mais os roteiros do console e a tabela de resumo.

**Arquivo: `docs/TESTES.md`** (arquivo novo, inteiro)

````markdown
# Casos de teste (CT-01 a CT-25)

Lista de verificação do sistema. A versão 1.0 é aceita quando todos os requisitos **Essenciais** passam nestes casos e
cada requisito **Importante** está pronto ou registrado como fora do escopo.

**Como usar:** execute cada caso no site **publicado ou rodando com o Supabase de verdade** (não vale testar só com o
`js/config.js` de exemplo). Preencha as colunas **Resultado** e **Observações**.

| | |
| --- | --- |
| Versão testada | |
| Endereço do site | |
| Data | |
| Navegador e aparelho | |
| Quem testou | |

**Legenda do Resultado:** `OK` = passou · `FALHOU` = não passou (descreva em Observações) · `N/A` = não executado.

## Antes de começar (dados de teste)

1. O banco está pronto e os scripts de segurança (RLS e melhorias) já foram executados no Supabase.
2. Existem **duas lojas**, de **duas lojistas diferentes**, cada uma com WhatsApp e pelo menos 2 produtos ativos com fotos.
   Um dos produtos tem um tamanho com **estoque 0**.
3. Existe uma conta de **cliente** (de preferência com telefone) e uma de **lojista**.
4. Para os casos do console (CT-11, CT-18, CT-20 e CT-21), use os **roteiros do console** no fim deste arquivo.
5. Para o CT-22, o banco precisa ter 13 ou mais produtos ativos. Para o CT-23, o Supabase precisa ter o endereço de
   `recuperar-senha.html` liberado no painel do Supabase, em **Authentication** (em português: **Autenticação**), na parte **URL Configuration** (em português: **Configuração de URL**). Para o CT-24, use uma conta criada só para o teste.
6. Os casos CT-17, CT-18, CT-20 e CT-24 dependem de telas que só existem depois do Dia 26 (pedidos recebidos, Meus pedidos e
   Minha conta): antes disso, marque **N/A**.

## Lista de verificação

| ID | Caso de teste | Requisitos | Como executar | Resultado esperado | Resultado | Observações |
| --- | --- | --- | --- | --- | --- | --- |
| CT-01 | Abrir o catálogo sem login | RF-01 (listar produtos) | Sem entrar na conta, abra `catalogo.html`. | Aparecem os produtos ativos (e nenhum inativo). | | |
| CT-02 | Filtrar por categoria e por loja | RF-02, RF-03 | Clique em uma categoria (por exemplo **Vestidos**) e depois escolha uma loja no filtro. Clique em **Todas** para limpar. | A lista mostra só o que corresponde ao filtro; **Todas** limpa. | | |
| CT-03 | Filtrar por tamanho sem estoque | RF-04 | Escolha no filtro de tamanho aquele que tem estoque 0 em algum produto. | O produto sem estoque nesse tamanho não aparece. | | |
| CT-04 | Adicionar produtos de duas lojas à sacola | RF-09, RN-03 | Abra um produto da loja A, escolha o tamanho e clique em **Adicionar à sacola**. Repita com um produto da loja B. Abra **Sacola**. | A sacola aceita as duas lojas (sem fazer pergunta) e mostra os itens agrupados por loja, com subtotal de cada uma e total. | | |
| CT-05 | Recarregar a página com itens na sacola | RF-09 | Com a sacola do CT-04, recarregue a página (F5). | Os itens, os subtotais e o total continuam iguais. | | |
| CT-06 | Finalizar pedido sem estar logada | RF-10, RN-04 | Sem entrar na conta, clique em **Finalizar sacola**. Entre com a conta de cliente. | Vai para o login e, depois de entrar, volta à sacola com os mesmos itens. | | |
| CT-07 | Finalizar a sacola logada, com peças de duas lojas | RF-10, RN-03, RN-06 | Logada como cliente, clique em **Finalizar sacola**. Confira os botões de WhatsApp. No SQL Editor: `select loja_id, status, total, grupo_id from public.pedidos order by criado_em desc limit 2;` | Dois pedidos gravados com status `novo` e o **mesmo** `grupo_id`; aparece um botão de WhatsApp por loja, cada um com o resumo só da respectiva loja. | | |
| CT-08 | Cadastrar com e-mail repetido | RF-12 | Em **Cadastrar**, use um e-mail que já tem conta. | Mensagem de erro clara ao lado do campo e-mail. | | |
| CT-09 | Cliente tenta abrir uma tela do painel | RF-14 | Logada como cliente, digite no navegador o endereço de `painel-loja.html`. | Acesso bloqueado: a cliente volta para a página inicial. | | |
| CT-10 | Lojista cadastra produto com 3 fotos | RF-16, RF-19 | Em **Painel** > **Meus produtos** > **Cadastrar produto**, preencha os dados e escolha 3 fotos. Salve. Abra o catálogo e a página do produto. | O card mostra a **primeira** foto como capa, e a página do produto mostra as 3 fotos na galeria. | | |
| CT-11 | Lojista tenta editar produto de outra loja pelo console do navegador | RN-09 (só a dona altera), segurança de acesso | Siga o **roteiro do CT-11** no fim deste arquivo. | O banco recusa a alteração: `data: []` e nada muda no painel da outra lojista. | | |
| CT-12 | Digitar um script em um campo de texto | segurança de conteúdo (nunca `innerHTML` com dados) | Cadastre um produto com o nome `<img src=x onerror=alert(1)>` (ou deixe esse texto no recado de um pedido). Veja o catálogo, a sacola e os pedidos. | O texto aparece como texto, sem ser executado (nenhuma janela de alerta). | | |
| CT-13 | Abrir as telas em 360 px e em 1280 px | responsividade | No navegador, F12 > modo de dispositivo. Abra cada tela nas duas larguras. | Sem rolagem horizontal. | | |
| CT-14 | Percorrer o fluxo de pedido só com o teclado | acessibilidade | Sem usar o mouse (Tab, Shift+Tab, Enter, espaço): escolha um produto, o tamanho, adicione à sacola e finalize. | Todos os passos são alcançáveis, com o foco sempre visível. | | |
| CT-15 | Simular falha de conexão com o Supabase | RF-21 | F12 > **Network** > marque **Offline**. Recarregue o catálogo e tente trocar um filtro. Repita no login. | Mensagem de erro em português e nenhuma tela em branco. | | |
| CT-16 | Enviar a 6ª foto de um produto ou um arquivo maior que 2 MB | RF-19, RN-12 | No formulário do produto, tente escolher uma 6ª foto. Depois tente um arquivo com mais de 2 MB (ou um `.gif`). | O sistema recusa com mensagem clara e mantém as 5 fotos já escolhidas. | | |
| CT-17 | A lojista confirma um pedido e a cliente abre o sistema | RF-11, RF-20, RF-22, RN-13 | Como lojista, em **Pedidos recebidos**, escreva um recado e clique em **Confirmar reserva**. Como cliente, veja o cabeçalho e abra **Meus pedidos**. Veja o cabeçalho de novo. | O link **Meus pedidos** mostra o contador; na tela o pedido aparece como **Atualizado**, com o status **Reserva confirmada** e o recado; depois de aberta, o contador some. | | |
| CT-18 | A lojista tenta alterar o valor total de um pedido pelo console do navegador | RN-13, segurança de acesso | Siga o **roteiro do CT-18** no fim deste arquivo. | O banco recusa a alteração com a mensagem "Só o status e o recado do pedido podem ser alterados.". | | |
| CT-19 | Abrir a página inicial e percorrer o carrossel | RF-23 | Sem entrar na conta, abra `index.html`. Use as setas do carrossel, os pontos, as teclas ← e → (com o foco no carrossel) e o botão de pausa. Clique em um tipo de roupa. | Aparecem o hero, o carrossel (um slide por vez), os tipos de roupa, os destaques e as lojas. A navegação funciona e a pausa para a troca automática. O tipo de roupa abre o catálogo já filtrado. | | |
| CT-20 | A lojista tenta pular uma etapa do status ou mexer no aviso da cliente pelo console | RN-05, RN-13, segurança de acesso | Siga o **roteiro do CT-20** no fim deste arquivo. | O banco recusa com "Esta mudança de status não é permitida para este pedido." e com "Só o status e o recado do pedido podem ser alterados.". | | |
| CT-21 | A cliente tenta gravar um pedido com preço forjado ou direto na tabela pelo console | RN-06, segurança de acesso | Siga o **roteiro do CT-21** no fim deste arquivo. | O insert direto é recusado por row-level security, a função diz que o preço mudou, e nada é gravado. | | |
| CT-22 | Abrir o catálogo com mais de 12 produtos e clicar em Carregar mais produtos | RF-01 | Abra `catalogo.html`. Confira que aparecem 12 produtos e o botão. Clique no botão. Depois troque o filtro de tipo de roupa. | Entram os produtos seguintes, sem repetir nenhum, e o botão some quando acabam. Trocar o filtro volta à primeira página. | | |
| CT-23 | Recuperar a senha pelo link do e-mail | RF-24 | Em **Entrar**, clique em **Esqueci minha senha**, informe o e-mail de uma conta, abra o e-mail recebido, clique no link e escolha a senha nova. Depois saia e entre com a senha nova. | A tela mostra a mensagem de e-mail enviado, o link abre a tela da senha nova, a senha nova entra e a antiga deixa de valer. | | |
| CT-24 | Excluir a própria conta | RF-25, RN-14 | Com uma conta de teste (de preferência uma lojista com loja, produto e foto), clique no seu nome no cabeçalho, digite `EXCLUIR` e confirme. Tente entrar de novo. | A conta e os dados dela somem (no Supabase, a loja, os produtos e as fotos da lojista também) e não dá mais para entrar. | | |
| CT-25 | Enviar uma foto grande | RF-19 | No formulário do produto, escolha uma foto de câmera de mais de 1 MB (e menos de 2 MB) e salve. No Supabase, em **Storage** > **produtos**, veja o tamanho do arquivo. | O arquivo guardado é JPG e tem cerca de 200 KB. | | |

## Roteiros do console

Para os roteiros, abra qualquer página do site, depois o Console (F12 > **Console**). Troque os textos em MAIÚSCULAS pelos ids
reais (você os acha no **SQL Editor** com `select id, nome from public.produtos;`, `select id from public.pedidos;` etc.).

**Roteiro do CT-11** (entre como a **segunda lojista** e troque `ID-DO-PRODUTO-DA-PRIMEIRA` pelo id de um produto da primeira):

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const id = "ID-DO-PRODUTO-DA-PRIMEIRA";
console.log("alterar produto  ->", await supabase.from("produtos").update({ nome: "HACK" }).eq("id", id).select("id"));
console.log("apagar produto   ->", await supabase.from("produtos").delete().eq("id", id).select("id"));
console.log("alterar tamanhos ->", await supabase.from("tamanhos").update({ estoque: 999 }).eq("produto_id", id).select("tamanho"));
console.log("apagar fotos     ->", await supabase.from("produto_fotos").delete().eq("produto_id", id).select("id"));
```

Esperado: cada linha mostra `data: []`. Para o Storage (troque `ID-DA-LOJA` pelo id da loja da primeira lojista):

```js
const arquivo = new File([new Uint8Array(10)], "hack.png", { type: "image/png" });
console.log(await supabase.storage.from("produtos").upload("ID-DA-LOJA/teste/hack.png", arquivo));
```

Esperado: `error` com a mensagem `new row violates row-level security policy`.

**Roteiro do CT-18** (entre como **lojista**, troque `ID-DO-PEDIDO` por um pedido da sua loja):

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
console.log(await supabase.from("pedidos").update({ total: 1 }).eq("id", "ID-DO-PEDIDO").select("id"));
```

Esperado: `error` com a mensagem "Só o status e o recado do pedido podem ser alterados.". Repita com a conta da **outra** lojista: `data: []`.

**Roteiro do CT-20** (entre como **lojista**, troque `ID-DO-PEDIDO` por um pedido **novo** da sua loja):

```js
const { supabase } = await import(new URL("js/supabaseClient.js", location.href));
const id = "ID-DO-PEDIDO";
console.log("pular etapa  ->", (await supabase.from("pedidos").update({ status: "concluido" }).eq("id", id)).error?.message);
console.log("mexer no aviso ->", (await supabase.from("pedidos").update({ status_visto: true }).eq("id", id)).error?.message);
```

Esperado: "Esta mudança de status não é permitida para este pedido." para o primeiro. O segundo só é recusado depois que o pedido
tem uma novidade (por exemplo, depois de confirmar): então a mensagem é "Só o status e o recado do pedido podem ser alterados.".

**Roteiro do CT-21** (entre como **cliente**; troque `ID-DE-UM-PRODUTO` e `ID-DA-LOJA` pelo id de um produto ativo e da loja dele):

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

Esperado: o primeiro recusa por row-level security; o segundo diz que o preço mudou. Nada é gravado.

## Resumo

| Total de casos | OK | FALHOU | N/A |
| --- | --- | --- | --- |
| 25 | | | |

**Observações gerais:**
````


### Passo 3: execute os casos em duplas (25 minutos)

1. Preencha o quadro do topo do `TESTES.md` (versão testada, endereço do site, data, navegador e quem testou).
2. Um da dupla executa os passos; o outro **observa e anota**. Troquem de papel a cada caso.
3. Para cada caso, escreva na coluna **Resultado**: `OK` (passou), `FALHOU` (não passou, descreva em **Observações**) ou `N/A` (não executado). Marque **N/A** nos casos CT-17, CT-18, CT-20 e CT-24: dependem do Dia 26.
4. Para o **CT-22** (mais de 12 produtos), crie produtos de teste ou marque N/A e deixe para o Dia 27. Para o **CT-23** (recuperar a senha) use o e-mail de um membro da organização do Supabase.
5. **CT-12 (segurança):** cadastre um produto com o nome `<img src=x onerror=alert(1)>` e olhe o catálogo, a página do produto e a sacola: o texto deve aparecer **como texto**, sem alerta. Depois apague o produto.
6. **CT-13 e CT-14:** use F12 > **Toggle device toolbar** (em português: **Alternar barra de ferramentas do dispositivo**) para 360 e 1280 px, e faça o fluxo de pedido **só com o teclado**.

### Passo 4: liste os defeitos (5 minutos)

Para **cada** caso que falhou, crie um cartão no quadro Kanban (Aula 2) com o título `Defeito: [tela] [o que aconteceu]` e, na descrição, use este modelo:

| Campo | O que escrever |
| --- | --- |
| Caso de teste | por exemplo, CT-14 |
| Tela e passo | por exemplo, "página do produto, ao apertar Enter em Adicionar à sacola" |
| O que aconteceu | o resultado real, com a mensagem de erro do Console, se houver |
| O que era esperado | o resultado esperado do caso |
| Gravidade | crítico, importante ou desejável |

Conte quantos casos deram OK, FALHOU e N/A e preencha a tabela **Resumo** no fim do arquivo.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Registra o plano de testes e os resultados dos casos CT-01 a CT-25"
git push
```

## Explicação do Código

Sem código novo; explicamos o plano de testes:

- **Por que testar o "caminho errado"?** Sistemas costumam funcionar para quem faz tudo certo. Os defeitos aparecem quando a pessoa digita um e-mail repetido, esquece de escolher o tamanho ou fica sem internet. Por isso há casos como CT-08 (e-mail repetido), CT-15 (sem conexão) e CT-16 (arquivo inválido).
- **Casos pelo console (CT-11, CT-18, CT-20 e CT-21):** o navegador é "território da usuária": ela pode abrir o Console e tentar mandar qualquer coisa ao banco. Esses casos provam que **o banco** (a RLS e a função `criar_pedidos`) recusa o que é proibido, mesmo que a tela esconda o botão.
- **CT-12:** prova que nenhum texto digitado vira código: é a regra "nunca `innerHTML` com dados" funcionando.
- **CT-13 a CT-15:** são casos de **qualidade**: telas pequenas e grandes, teclado e falha de rede.
- **N/A não é falha:** quer dizer "não foi possível executar agora" (a funcionalidade ainda não existe). No Dia 27 todos os casos precisam estar executados.
- **Cartões de defeito no Kanban:** transformam o que a equipe viu em **trabalho a fazer** (Aula 42), com gravidade para decidir o que corrigir primeiro.

## Validação

1. Você usou as abas **Console**, **Rede** e **Elementos** e simulou **Offline**.
2. O `docs/TESTES.md` está criado, com a coluna **Resultado** preenchida (`OK`, `FALHOU` ou `N/A`) em todos os 25 casos.
3. Cada caso `FALHOU` tem uma explicação em **Observações** e um cartão no Kanban.
4. A tabela **Resumo** mostra o total de `OK`, `FALHOU` e `N/A`.

**Erros comuns**

1. *Sintoma:* "não consigo reproduzir o defeito". *Causa:* ele depende de um estado (sacola, conta, produto). *Correção:* anote o estado inicial (qual conta, quais itens) e tente de novo; se não repetir, anote como "intermitente".
2. *Sintoma:* o teste do console mostra `Failed to resolve module specifier`. *Causa:* o endereço do `import` está errado (precisa de `new URL("js/supabaseClient.js", location.href)`). *Correção:* copie o roteiro exatamente como está no `TESTES.md`.
3. *Sintoma:* um caso deu `FALHOU` porque faltam dados (duas lojas, 13 produtos...). *Causa:* os dados de teste não foram preparados. *Correção:* prepare os dados (veja "Antes de começar" no `TESTES.md`) e refaça o caso.
4. *Sintoma:* a dupla discorda se algo é defeito. *Causa:* o resultado esperado não estava claro. *Correção:* releia a coluna **Resultado esperado**; se ainda houver dúvida, trate como "importante" e leve ao grupo.

**Se travar**

1. Releia o caso (passos e resultado esperado) e execute-o devagar, um passo por vez.
2. Para entender o que a página fez, olhe o **Console** e a aba **Network** (em português: **Rede**) logo depois de errar.
3. Se um teste "quebrou" os dados (por exemplo, apagou um produto), recrie os dados de teste.
4. Só depois peça ajuda à sua equipe, dizendo o caso, o passo e o que você viu.

**Seu projeto agora tem**

- `docs/TESTES.md` com os 25 casos, os roteiros do console e os resultados da equipe.
- Cartões de defeito no quadro Kanban, com gravidade.
- O resto do sistema como na Aula 40.

**Como saber que deu certo:** todos os 25 casos têm um resultado (`OK`, `FALHOU` ou `N/A`) e cada falha virou um cartão com tela, passo e gravidade.
