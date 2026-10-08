**Data:** 12/11/2026 (quinta-feira) · **Prioridade:** Importante

## User Story

Como cliente, quero ver os meus pedidos e ser avisada quando a lojista mudar o status ou deixar um recado, para que eu saiba o que está acontecendo sem precisar perguntar pelo WhatsApp.

## Critérios de aceite

- Como cliente, o link **Meus pedidos** não tem número quando não há novidade; depois de a lojista confirmar um pedido, o link mostra um número (por exemplo, `1`) em até 60 segundos ou ao recarregar (RF-22, RN-13).
- **Meus pedidos** mostra as compras agrupadas ("Compra de 26/10/2026", **Total da compra**, "2 pedidos, um por loja"), do mais recente ao mais antigo, com o status em linguagem simples (por exemplo, **Reserva confirmada** e **Enviado à loja**) e o recado ("Recado da loja: Separado, pode retirar amanhã") (RF-11).
- O pedido mexido pela lojista tem borda destacada e o selo **Atualizado**; logo depois que a tela abre, o número do cabeçalho some e, ao recarregar, o selo não aparece mais; `select status_visto from public.pedidos where status = 'confirmado';` volta `true` (CT-17).
- Cliente sem pedidos vê "Você ainda não fez nenhum pedido. Ver o catálogo."; lojista que abre `meus-pedidos.html` volta para o painel; visitante vai para `login.html?voltar=meus-pedidos.html` e, depois de entrar como cliente, volta para **Meus pedidos**.

## Checklist

- [ ] Abrir uma nova branch: `git switch -c meus-pedidos`.
- [ ] No `pedidoServico.js`, colar `listarMeusPedidos` antes de `listarPedidosDaMinhaLoja` e `contarNovidades` e `marcarComoVistos` no final do arquivo.
- [ ] No `cabecalho.js`, fazer as trocas da aula: começo do arquivo (importações e intervalo de consulta); `linksDaConta` com o contador no link **Meus pedidos**; colar `atualizarContadorDeNovidades`, `pararDeVerNovidades` e `comecarAVerNovidades` antes de `atualizarContadorSacola`; trocar `criarLink` e `montarCabecalho`.
- [ ] Criar `meus-pedidos.html` e `js/paginas/meusPedidos.js`.
- [ ] Abrir **dois navegadores** (ou uma janela anônima): um com a **lojista** e outro com a **cliente** dona de um pedido novo.
- [ ] Como cliente, abrir qualquer página e conferir que **Meus pedidos** não tem número.
- [ ] Como lojista, em **Pedidos recebidos**, escrever o recado e clicar em **Confirmar reserva**.
- [ ] Como cliente, esperar até 60 segundos (ou recarregar) e conferir o número no link **Meus pedidos**.
- [ ] Abrir **Meus pedidos** e conferir os grupos de compra, o selo **Atualizado**, o status e o recado; conferir que o número do cabeçalho some logo depois e que o selo não volta ao recarregar.
- [ ] No **SQL Editor** (em português: **Editor SQL**), conferir `status_visto = true`.
- [ ] Testar uma cliente sem pedidos, a lojista abrindo `meus-pedidos.html` e o visitante com volta ao fim do login.
- [ ] Se o contador nunca aparecer, conferir que a lojista mudou o status ou salvou um recado depois da criação do pedido.
- [ ] Se aparecer `permission denied for function marcar_pedidos_como_vistos`, rodar até o fim a Parte 2 do `01_schema.sql` (Aula 26).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push -u origin meus-pedidos`; abrir o pull request e pedir a revisão.

## Depende de

- D26·A76 – Criar a tela Pedidos recebidos e o fluxo de status da lojista

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia26-aula77-meus-pedidos-e-aviso-de-novidades.md]({{URL_GUIA}}/dia26-aula77-meus-pedidos-e-aviso-de-novidades.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-11** – Mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja.
- **RF-22** – Avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado.
- **RN-13** – Quando a lojista muda o status ou o recado, o pedido fica marcado como novidade para a cliente até ela abrir Meus pedidos; a lojista não altera valores, itens, cliente nem loja.
- **CT-17** – Lojista confirma um pedido e a cliente vê o contador, o selo "Atualizado", o status e o recado.
