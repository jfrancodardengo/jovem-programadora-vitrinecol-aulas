**Data:** 09/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver o catálogo em cards com foto, nome, preço e loja, para que eu compare as peças de relance e abra a que me interessa.

## Critérios de aceite

- O catálogo mostra 3 cards com foto em formato retrato, nome, preço e loja.
- O card todo é clicável (abre `produto.html`) e o foco do teclado (Tab) desenha um contorno em volta do card inteiro.
- O experimento com `repeat(3, 1fr)` mostrou 3 colunas e o valor voltou para `1fr`.
- O formulário de filtros fica dentro de uma caixa branca com borda.
- As cinco páginas abrem sem erros no Console.

## Checklist

- [ ] Colar a seção do card de produto em `css/componentes.css`, logo antes do comentário `/* ---------- Campos de formulário ---------- */`.
- [ ] Conferir os cards: foto em retrato, cantos arredondados, sombra, um embaixo do outro (uma coluna).
- [ ] Experimento: na regra `.grade-produtos`, trocar `grid-template-columns: 1fr;` por `repeat(3, 1fr);`, ver 3 colunas e voltar para `1fr`.
- [ ] Criar `css/paginas.css` com os estilos dos filtros do catálogo.
- [ ] Colar `<link rel="stylesheet" href="css/paginas.css">` no `<head>` das cinco páginas, antes de `</head>`.
- [ ] Passar o mouse sobre um card e ver o nome com sublinhado.
- [ ] Apertar Tab até o nome de um produto e ver o contorno em volta do card inteiro.
- [ ] Clicar na foto, no preço e na loja do card e conferir que abre a página do produto.
- [ ] Se os cards tiverem alturas diferentes, conferir `height: 100%` em `.card-produto`; se a foto estiver achatada, conferir `object-fit: cover` e `aspect-ratio` em `.card-produto-imagem`.
- [ ] Abrir o Console (F12 > **Console**) nas cinco páginas e conferir que não há erros.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D4·A11 – Montar cabeçalho, menu, botões, campos e chips com Flexbox (componentes.css)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia04-aula12-layout-com-grid-e-card-de-produto.md]({{URL_GUIA}}/dia04-aula12-layout-com-grid-e-card-de-produto.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".

**Observação da aula:** apresentação visual de RF-01
