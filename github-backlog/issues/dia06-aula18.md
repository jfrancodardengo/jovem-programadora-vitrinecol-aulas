**Data:** 14/10/2026 (quarta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver avisos de "Carregando…", erro e sucesso e chips que reagem ao clique, para que a tela nunca fique em branco ou sem resposta.

## Critérios de aceite

- O menu aparece gerado pelo JavaScript e o link **Catálogo** está destacado como página atual.
- "Carregando…" aparece abaixo do título e some sozinho depois de cerca de 1,5 segundo.
- Ao clicar em um chip (por exemplo, **Vestidos**), ele fica pressionado e aparece "Você escolheu: Vestidos"; ao clicar em outro, o anterior volta ao normal.
- O teste `document.querySelector("h1").textContent = "<b>teste</b>"` mostra o texto `<b>teste</b>` literalmente, sem negrito.
- Procurando `innerHTML` em `js/` (Ctrl+Shift+F; Mac: Cmd+Shift+F) não há resultados, e o Console não mostra erros.

## Checklist

- [ ] Criar a pasta `js/ui` e o arquivo `js/ui/elementos.js` com a função `criarElemento`.
- [ ] Criar `js/ui/avisos.js` (avisos de carregamento, erro, sucesso e informação, usando as classes `aviso`).
- [ ] Criar `js/ui/cabecalho.js`, que gera o cabeçalho comum.
- [ ] No `catalogo.html`, trocar o bloco `<header class="cabecalho" id="cabecalho">` inteiro por `<header class="cabecalho" id="cabecalho"></header>`.
- [ ] Trocar o conteúdo de `js/paginas/catalogo.js` pela versão da aula (mantém os produtos fictícios e acrescenta avisos e eventos de clique nos chips).
- [ ] Abrir o `catalogo.html` no Live Server e conferir o menu, o "Carregando…" que some e o chip pressionado.
- [ ] Teste de segurança no Console (F12 > **Console**): rodar `document.querySelector("h1").textContent = "<b>teste</b>"`, ver o texto sem negrito e recarregar a página.
- [ ] Procurar `innerHTML` em `js/` e conferir que não há resultados.
- [ ] Se o cabeçalho aparecer duplicado, conferir que o `<header>` do HTML ficou vazio; se der 404 no `import`, conferir o caminho `../ui/cabecalho.js`.
- [ ] Conferir que o `id="chips-categorias"` do HTML é igual ao usado no `getElementById`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D6·A17 – Representar produtos como array de objetos e escrever funções que os percorrem

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia06-aula18-dom-e-eventos.md]({{URL_GUIA}}/dia06-aula18-dom-e-eventos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Observação da aula:** início de RF-21
