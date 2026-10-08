**Data:** 12/11/2026 (quinta-feira) · **Prioridade:** Importante

## User Story

Como lojista, quero ver os pedidos da minha loja e mudar o status deixando um recado, para que a cliente saiba se o pedido foi confirmado, concluído ou cancelado.

## Critérios de aceite

- A lojista vê **só** os pedidos da própria loja, cada um com código `#xxxxxxxx`, data, selo de status, nome da cliente, itens, **Total do pedido**, campo "Recado para a cliente (opcional)" e botões; outra lojista não vê esses pedidos e, sem pedidos, aparece "Sua loja ainda não recebeu nenhum pedido." (RF-20, RN-09).
- Em pedido **novo** aparecem só **Confirmar reserva**, **Cancelar pedido** e **Salvar só o recado**; em **confirmado**, **Marcar como concluído**, **Cancelar pedido** e **Salvar só o recado**; em concluído ou cancelado, só **Salvar só o recado** (RN-05).
- Status e recado são salvos juntos, a mensagem "Pedido #...: reserva confirmada. A cliente será avisada em Meus pedidos." aparece e o banco deixa o pedido com `status_visto = false` (RN-13).
- Pelo Console, alterar o total é recusado com "Só o status e o recado do pedido podem ser alterados." (CT-18); pular de **novo** direto para **concluído** é recusado com "Esta mudança de status não é permitida para este pedido." e mexer em `status_visto` é recusado (CT-20).
- Datas aparecem em dd/mm/aaaa.

## Checklist

- [ ] Abrir um novo branch para a aula: `git switch -c pedidos-recebidos`.
- [ ] Conferir que existe pelo menos um pedido na tabela `pedidos` e que a lojista dona dele tem a loja cadastrada.
- [ ] Em `js/modelos/Pedido.js`, fazer as seis trocas na ordem da aula: rótulos antes de `export class Pedido {`; campos novos depois de `#itens`; construtor completo; leitores novos (`mensagemLoja`, `statusVisto`, `criadoEm`, `clienteNome`, `clienteTelefone`) antes de `grupoId`; métodos `deLinha`, `statusPermitidos`, `proximosStatus` e `alterarStatus` antes de `codigoCurto`; fim da classe a partir de `rotuloParaCliente()`.
- [ ] Em `js/ui/formatadores.js`, colar `formatadorDeData` antes de `formatarPreco` e `formatarData` antes de `normalizarTelefone`.
- [ ] No final de `js/servicos/pedidoServico.js`, colar o bloco de comentário e as constantes, `listarPedidosDaMinhaLoja` e `atualizarPedido` (muda status e recado numa única atualização).
- [ ] Criar `painel-pedidos.html` e `js/paginas/painelPedidos.js`.
- [ ] No `css/paginas.css`, colar a seção do botão de aviso antes de `/* ---------- Botão "Carregar mais" do catálogo ---------- */`.
- [ ] Entrar como a **lojista dona** de um pedido, abrir **Painel** > **Pedidos recebidos** e conferir o cartão de cada pedido.
- [ ] Em um pedido novo, escrever o recado `Separado, pode retirar amanhã`, clicar em **Confirmar reserva** e conferir o selo **Confirmado** e o **Recado atual para a cliente**.
- [ ] Clicar em **Marcar como concluído** e conferir que só resta **Salvar só o recado**.
- [ ] Em outro pedido novo, clicar em **Cancelar pedido**, confirmar a pergunta "Cancelar este pedido? A cliente será avisada em Meus pedidos." e conferir o selo **Cancelado**.
- [ ] Conferir o botão **Avisar a cliente pelo WhatsApp** (só aparece se a cliente tem telefone); este botão é o primeiro a sair se faltar tempo.
- [ ] Entrar como **outra lojista** e conferir que ela não vê esses pedidos (RN-09).
- [ ] No **SQL Editor** (em português: **Editor SQL**), rodar `select status, mensagem_loja, status_visto, atualizado_em from public.pedidos;` e conferir `status_visto = false` nos pedidos mexidos.
- [ ] Testar CT-18 no Console (F12 > **Console**): trocar `ID-DO-PEDIDO` por um pedido da sua loja, rodar o roteiro do `TESTES.md` e conferir a mensagem de recusa; repetir com a outra lojista e conferir `data: []`.
- [ ] Testar CT-20 no Console com um pedido **novo**: pular etapa e mexer em `status_visto`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push -u origin pedidos-recebidos`; abrir o pull request e pedir a revisão de outra integrante; depois do merge, `git switch main` e `git pull`.

## Depende de

- D15·A45 – Revisar o MVP, demonstrar o fluxo completo e marcar a versão 0.9 (Marco 4)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia26-aula76-pedidos-recebidos-e-fluxo-de-status.md]({{URL_GUIA}}/dia26-aula76-pedidos-recebidos-e-fluxo-de-status.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-20** – Mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado.
- **RN-05** – O status segue novo, confirmado e concluído; cancelado vale enquanto o pedido não estiver concluído; o banco recusa outras mudanças.
- **RN-09** – Só a lojista dona da loja altera a loja, os produtos, as fotos e o status dos pedidos recebidos.
- **RN-13** – Quando a lojista muda o status ou o recado, o pedido fica marcado como novidade para a cliente até ela abrir Meus pedidos; a lojista não altera valores, itens, cliente nem loja.
- **CT-18** – Lojista tenta alterar o total de um pedido pelo console e o banco recusa.
- **CT-20** – Lojista tenta pular uma etapa do status ou mexer no aviso da cliente pelo console e o banco recusa.

**Observação da aula:** RF-20, RN-05, RN-09, RN-13; CT-18 e CT-20
