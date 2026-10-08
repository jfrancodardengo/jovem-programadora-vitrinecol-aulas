# Aula 79 – Plano de testes e roteiro de usabilidade

**Dia 27 · Sex 13/11/2026** · **Aula 79** · **UC6**

- **Requisitos cobertos:** CT-01 a CT-25, que verificam RF-01 a RF-25 (catálogo e filtros, sacola, pedido, cadastro e login, painel da lojista, fotos, avisos, página inicial, recuperação de senha, acompanhamento do pedido e exclusão da conta); também a meta de usabilidade: uma cliente nova chega do catálogo ao pedido em até 6 ações
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** sistema com conteúdo real, acompanhamento do pedido e exclusão de conta, publicado no GitHub Pages (Dia 26); docs/TESTES.md criado na Aula 41

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **preparar os dados de teste**, **executar os 25 casos de teste (CT-01 a CT-25) no sistema publicado** e escrever o **roteiro de usabilidade**: uma cliente nova deve chegar do catálogo ao pedido em **até 6 ações**. Também confere no painel do Supabase a **confirmação de e-mail** e o **limite de e-mails por hora**.

**Abertura (10 minutos).** Retomada do Dia 26: o sistema está completo, com conteúdo real. Na Aula 41 vocês testaram sem os recursos do Dia 26, e muitos casos ficaram como **N/A**. Hoje **todos** os casos precisam ser executados, e no endereço **publicado** (não no seu computador): é o que a usuária real vai usar. Abra o `docs/TESTES.md`, o site publicado e o Supabase em abas separadas, e divida os casos entre as duplas.

## O Conceito

**Termos desta aula**

- **Plano de testes**: o documento com **todos** os casos de teste, cada um com passos e resultado esperado (a tabela abaixo é o plano completo, e é o mesmo conteúdo do seu `docs/TESTES.md`).
- **Dados de teste**: as lojas, produtos e contas necessárias para executar os casos, preparados **antes** (senão cada caso trava).
- **Roteiro de usabilidade**: uma **tarefa** dada a uma pessoa que nunca usou o sistema ("escolha um vestido e faça o pedido"), observada **sem ajuda**, para medir tempo, número de ações e dificuldades.
- **Ação**: um clique, escolha ou envio. A meta: **6 ações** do catálogo ao pedido (clicar no produto, escolher o tamanho, adicionar à sacola, abrir a sacola, finalizar, clicar no botão do WhatsApp).

**Analogia:** o plano de testes é a **lista de verificação de um piloto antes da decolagem**: item por item, sem pular nenhum. O roteiro de usabilidade é o **voo de teste com uma passageira de primeira viagem**: o que a faz hesitar mostra onde a sinalização é ruim.

## Mão na Massa

### Passo 1: prepare os dados de teste (10 minutos)

Confira, no site **publicado**, que existem:

1. **Duas lojas**, de duas lojistas diferentes, cada uma com WhatsApp e pelo menos **2 produtos ativos** com fotos. **Um** dos produtos tem um tamanho com **estoque 0**.
2. Pelo menos **13 produtos ativos** no total (para o CT-22).
3. Uma conta de **cliente** (de preferência com telefone) e uma de **lojista** (com a loja cadastrada e pelo menos um pedido recebido, para o CT-17, CT-18 e CT-20).
4. Uma **conta criada só para o teste** de exclusão (CT-24), de preferência uma lojista com loja, produto e foto.
5. O endereço de `recuperar-senha.html` do site publicado liberado em **Authentication** (em português: **Autenticação**), na parte **URL Configuration** (em português: **Configuração de URL**), como na Aula 43 (CT-23).

### Passo 2: execute os 25 casos no site publicado (25 minutos)

O plano de testes completo está abaixo. Para cada caso, escreva `OK`, `FALHOU` (com a observação) ou `N/A` na coluna **Resultado** do seu `docs/TESTES.md`. **Nesta aula não pode sobrar N/A**: se um caso depende de dados que faltam, prepare os dados (Passo 1) e execute. Preencha também o quadro do topo (versão testada, endereço, data, aparelho, quem testou).

#### Casos de teste (CT-01 a CT-25)

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

##### Antes de começar (dados de teste)

1. O banco está pronto e os scripts de segurança (RLS e melhorias) já foram executados no Supabase.
2. Existem **duas lojas**, de **duas lojistas diferentes**, cada uma com WhatsApp e pelo menos 2 produtos ativos com fotos.
   Um dos produtos tem um tamanho com **estoque 0**.
3. Existe uma conta de **cliente** (de preferência com telefone) e uma de **lojista**.
4. Para os casos do console (CT-11, CT-18, CT-20 e CT-21), use os **roteiros do console** no fim deste arquivo.
5. Para o CT-22, o banco precisa ter 13 ou mais produtos ativos. Para o CT-23, o Supabase precisa ter o endereço de
   `recuperar-senha.html` liberado no painel do Supabase, em **Authentication** (em português: **Autenticação**), na parte **URL Configuration** (em português: **Configuração de URL**). Para o CT-24, use uma conta criada só para o teste.
6. Os casos CT-17, CT-18, CT-20 e CT-24 dependem de telas que só existem depois do Dia 26 (pedidos recebidos, Meus pedidos e
   Minha conta): antes disso, marque **N/A**.

##### Lista de verificação

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

##### Roteiros do console

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

##### Resumo

| Total de casos | OK | FALHOU | N/A |
| --- | --- | --- | --- |
| 25 | | | |

**Observações gerais:**


### Passo 3: confira o painel do Supabase (5 minutos)

1. **Confirmação de e-mail.** Abra **Authentication** (em português: **Autenticação**), **Providers** (em português: **Provedores**) e **Email** (em português: **E-mail**) e veja a opção **Confirm email** (em português: **Confirmar e-mail**). Durante as aulas ela ficou **desligada**. **Se o site for aberto para usuárias reais, ligue-a**: cada pessoa terá de clicar no link do e-mail antes de entrar (o `cadastro.js` já mostra **Conta criada! Enviamos uma mensagem de confirmação para o seu e-mail**).
   - **Cuidado:** no plano gratuito, sem servidor de e-mail próprio, o Supabase pode **só enviar e-mails** para os membros da sua organização, e limita a poucos e-mails por hora. Antes de ligar, teste cadastrando uma conta com um e-mail **que não seja da equipe**: se o e-mail de confirmação **não chegar**, deixe a confirmação **desligada** para os testes desta semana e **registre o risco** no relatório (a Aula 81 tem um lugar para isso).
2. **Limite de e-mails por hora.** Procure a página de limites (**Rate Limits**, em português: **Limites de taxa**; o nome pode variar com a versão do painel) dentro de **Authentication** (em português: **Autenticação**). Anote quantos e-mails por hora o projeto aceita: os testes com muitas usuárias ao mesmo tempo (cadastros e recuperações de senha) podem **bater nesse limite**; se aparecer **Muitas tentativas em pouco tempo**, espere e distribua os testes.

### Passo 4: escreva o roteiro de usabilidade (15 minutos)

Cada sessão de teste (Aula 80) segue este roteiro. Copie para um arquivo ou uma folha da equipe:

**Tarefa dada à usuária (leia em voz alta, sem explicar nada):**

> "Você quer comprar **um vestido** e **uma camiseta** de duas lojas diferentes. Escolha as peças, junte tudo e faça o pedido. Fale em voz alta o que está pensando."

**O que a observadora anota (não ajuda, não aponta, não explica):**

| Campo | O que registrar |
| --- | --- |
| Usuária | só o primeiro nome e se já usou lojas on-line (sem dados pessoais) |
| Aparelho | celular ou computador; navegador |
| Tempo | quanto levou do catálogo até o botão de WhatsApp do pedido |
| Ações | quantas ações fez (conte cada clique ou escolha); a meta é **até 6 por loja**, e quanto mais lojas, mais ações |
| Onde hesitou | tela, passo e o que a fez parar |
| Erros | cliques no lugar errado, mensagens de erro que viu |
| Concluiu sozinha? | sim ou não (se precisou de ajuda, em que passo) |
| Comentário dela | frases dela, entre aspas |

**Perguntas finais (3):** 1) O que foi mais fácil? 2) O que foi confuso? 3) O que você mudaria?

**Como contar as ações:** um clique, uma escolha em lista, um envio de formulário e um toque no botão do WhatsApp contam 1 cada. Para **uma** loja, o caminho ideal é: (1) abrir o produto, (2) escolher o tamanho, (3) adicionar à sacola, (4) abrir a sacola, (5) finalizar, (6) clicar no botão do WhatsApp.

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Registra os resultados dos casos de teste no site publicado"
git push
```

## Explicação do Código

Sem código novo hoje; entenda como o plano funciona:

- **Casos em três grupos:** de **funcionalidade** (CT-01 a CT-10, CT-17, CT-19, CT-22 a CT-25: "o sistema faz o que promete"), de **segurança pelo console** (CT-11, CT-18, CT-20 e CT-21: "o banco recusa o que é proibido") e de **qualidade** (CT-12 a CT-16: texto sem execução, telas pequenas e grandes, teclado, falha de conexão e arquivos inválidos).
- **Por que testar no site publicado?** O endereço de retorno da recuperação de senha, o `config.js` e os caminhos relativos só são validados de verdade lá.
- **Por que a meta de 6 ações?** É uma forma **objetiva** de medir facilidade: se a usuária precisa de 12 ações, há passos demais no caminho (por exemplo, um login pedido antes da hora).
- **Por que não ajudar durante o teste de usabilidade?** Se você ajuda, mede **você explicando**, e não o sistema. O que faz a pessoa hesitar é justamente o que precisa melhorar.
- **Confirmação de e-mail:** protege contra cadastros com e-mails que não são da pessoa, mas depende do envio de e-mails funcionar. Por isso ela é conferida **antes** de abrir o sistema ao público.

## Validação

1. Os dados de teste estão preparados (duas lojas, 13 ou mais produtos, cliente, lojista e conta de teste).
2. **Todos** os 25 casos têm resultado `OK` ou `FALHOU` (sem `N/A`) e cada `FALHOU` tem uma observação.
3. Você conferiu **Confirm email** e o limite de e-mails e registrou a decisão.
4. O roteiro de usabilidade (tarefa, tabela de observação e perguntas finais) está pronto.

**Erros comuns**

1. *Sintoma:* um caso dá `FALHOU` por falta de dados (não há 13 produtos, ou só há uma loja). *Causa:* os dados de teste não foram preparados. *Correção:* cadastre os dados e refaça o caso.
2. *Sintoma:* o CT-24 apagou a conta errada. *Causa:* o teste foi feito com uma conta real. *Correção:* use **sempre** uma conta criada só para o teste.
3. *Mensagem:* `Muitas tentativas em pouco tempo` no CT-08 ou CT-23. *Causa:* o limite de e-mails por hora. *Correção:* espere e execute esses casos mais tarde.
4. *Sintoma:* o CT-23 não recebe o e-mail. *Causa:* o endereço publicado não está nos Redirect URLs, ou o plano gratuito só envia para membros da organização. *Correção:* confira a Aula 43 e use o e-mail de uma integrante que é membro da organização.

**Se travar**

1. Releia o caso (passos e resultado esperado) e execute devagar, um passo por vez.
2. Para os casos de console, copie os roteiros do `docs/TESTES.md` **sem mudar nada**, só os ids.
3. Se um teste quebrou os dados, recrie-os.
4. Só depois peça ajuda à sua equipe, dizendo o caso, o passo e o que apareceu.

**Seu projeto agora tem**

- O `docs/TESTES.md` com os 25 casos executados no site publicado.
- O roteiro de usabilidade, a tabela de observação e as perguntas finais.
- A situação da confirmação de e-mail e do limite de e-mails registrada.

**Como saber que deu certo:** não existe nenhum `N/A` no plano de testes, e a equipe tem um roteiro de usabilidade que qualquer integrante consegue aplicar sem ajuda.
