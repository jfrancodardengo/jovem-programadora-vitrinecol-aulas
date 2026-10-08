**Data:** 22/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero finalizar a sacola e receber um pedido por loja com um botão de WhatsApp para cada uma, para que eu combine a compra direto com cada lojista, vendo só as peças daquela loja.

## Critérios de aceite

- Com peças de duas lojas, **Finalizar sacola (2 pedidos)** mostra a tela "Pedidos enviados" com dois cartões, cada um com o nome da loja, o código `#xxxxxxxx`, os itens e o **Total do pedido** só daquela loja (RN-03).
- Cada botão de WhatsApp abre `https://wa.me/<número da loja>?text=...` com a mensagem só dos itens daquela loja (RN-10); sem WhatsApp cadastrado aparece "Esta loja ainda não cadastrou o WhatsApp..." e o botão não aparece.
- Depois de finalizar, a sacola fica vazia e o contador some.
- Com o preço de uma peça alterado, o sistema **não finaliza**, avisa "O preço mudou: ... (de R$ X para R$ Y)...", atualiza a sacola e finaliza na segunda tentativa (RN-06); com produto desativado, avisa "Estes produtos não estão mais disponíveis...".
- As tabelas `pedidos` e `itens_pedido` continuam **vazias** (a gravação entra no Dia 13; RF-10 em parte).

## Checklist

- [ ] Criar `js/modelos/Pedido.js` (um pedido por loja, todos com o mesmo `grupo_id`).
- [ ] No `lojaServico.js`, colar a função dos contatos das lojas antes do comentário `// ---------- Painel da lojista ----------`.
- [ ] Criar `js/servicos/pedidoServico.js` (versão provisória: confere o preço atual e monta os pedidos, ainda sem gravar).
- [ ] No `sacola.js`, fazer as quatro trocas da aula: comentário do começo; importações (inclui `mostrarCarregando`); elementos da tela (título e confirmação); trocar o botão de teste pelo código "Finalizar" (cartões, WhatsApp, confirmação e a função `finalizar`).
- [ ] No `css/paginas.css`, colar a seção "Meus pedidos e pedidos recebidos" antes de `/* ---------- Painel da lojista ---------- */` e a seção "Sacola: confirmação do pedido" antes de `/* ---------- Botão "Carregar mais" do catálogo ---------- */`.
- [ ] Preparar duas lojas com produtos ativos e WhatsApp cadastrado e adicionar uma peça de cada à sacola.
- [ ] Clicar em **Finalizar sacola** e conferir "Enviando pedidos…", "Montando os pedidos…", os dois cartões e o selo **Enviado à loja**.
- [ ] Clicar no botão de uma loja e conferir que o WhatsApp abre com a mensagem só dos itens dela.
- [ ] Teste de preço (RN-06): editar o preço de uma peça da sacola em **Meus produtos**, voltar e finalizar; conferir o aviso, a sacola atualizada e a segunda tentativa.
- [ ] Teste de produto desativado: desativar uma peça que está na sacola e finalizar.
- [ ] Teste de loja sem WhatsApp: apagar o valor da coluna `whatsapp` no **Table Editor** (em português: **Editor de tabelas**) e finalizar.
- [ ] Conferir que `pedidos` e `itens_pedido` continuam vazias.
- [ ] Testar `criarLinkDoWhatsapp("5527999999999", "teste")` pelo Console (F12) se o texto da mensagem ficar estranho.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D12·A35 – Criar a sacola com localStorage, agrupada por loja, com subtotais, total e contador

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia12-aula36-finalizar-a-sacola.md]({{URL_GUIA}}/dia12-aula36-finalizar-a-sacola.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-10** – Finalizar a sacola de uma cliente logada, gravando um pedido por loja e mostrando um botão de WhatsApp por loja.
- **RN-03** – A sacola mistura lojas; ao finalizar, sai um pedido por loja, cada um com o seu status e o mesmo código de compra (grupo_id).
- **RN-06** – O preço de cada item é copiado para o pedido na hora da compra, o banco calcula o total e só grava se o preço visto ainda for o atual.
- **RN-10** – O WhatsApp é guardado só com dígitos e código do país, e o link segue o formato https://wa.me/número?text=mensagem.

**Observação da aula:** RF-10 (parte), RN-03, RN-06, RN-10
