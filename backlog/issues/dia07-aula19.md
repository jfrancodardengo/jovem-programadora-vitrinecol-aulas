**Data:** 15/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver os produtos em cards com foto, nome, preço em reais e loja, para que eu compare as peças e nunca veja uma tela em branco.

## Critérios de aceite

- O catálogo mostra "Carregando…" por cerca de 0,6 segundo e depois 6 cards, cada um com foto, nome, preço no formato `R$ 129,90` e loja.
- Com a lista vazia (`mostrarProdutos([])`), aparece "Nenhum produto encontrado." em vez de uma tela em branco.
- Um 7º produto acrescentado à lista aparece sozinho como novo card.
- O Console não mostra erros e a busca por `innerHTML` em `js/` (Ctrl+Shift+F; Mac: Cmd+Shift+F) dá 0 resultados.

## Checklist

- [ ] Criar `js/ui/formatadores.js` com a função `formatarPreco` (usa `Intl.NumberFormat` em R$), com a palavra `export` na frente.
- [ ] No `js/paginas/catalogo.js`, trocar o começo do arquivo (até a linha de `import` de `avisos.js`) pelo trecho da aula.
- [ ] Manter a lista `produtosFicticios` e trocar tudo o que vem depois dela (a partir de `const listaChips = ...`) pelo código da aula, que cria cada card com `createElement` e `textContent`.
- [ ] No `catalogo.html`, trocar a lista `<ul class="grade-produtos" id="lista-produtos">` inteira por `<ul class="grade-produtos" id="lista-produtos"></ul>` (sem os 3 cards escritos à mão) e conferir o aviso de lista vazia (`id="mensagem-vazio"`).
- [ ] Abrir o catálogo e conferir "Carregando…" e os 6 cards com preço `R$ 129,90`.
- [ ] Clicar em um card e conferir que abre a página do produto.
- [ ] Teste do estado vazio: trocar `mostrarProdutos(produtosFicticios);` por `mostrarProdutos([]);`, ver "Nenhum produto encontrado." e voltar ao código original.
- [ ] Acrescentar um 7º produto à lista e ver o 7º card aparecer.
- [ ] Procurar `innerHTML` em `js/` e confirmar 0 resultados.
- [ ] Se os cards antigos aparecerem junto com os novos, conferir que a `ul` do HTML está vazia.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D6·A18 – Mexer na página com o DOM: criarElemento, avisos, cabeçalho em JavaScript e chips clicáveis

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia07-aula19-catalogo-a-partir-de-um-array-de-objetos.md]({{URL_GUIA}}/dia07-aula19-catalogo-a-partir-de-um-array-de-objetos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Observação da aula:** RF-01 (com dados fictícios), RF-21
