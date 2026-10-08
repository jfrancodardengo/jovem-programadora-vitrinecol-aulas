**Data:** 15/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero filtrar as roupas por tipo, loja e tamanho e buscar pelo nome, para que eu encontre rápido o que procuro.

## Critérios de aceite

- Os 8 chips de tipo de roupa e as 2 lojas aparecem sozinhos (criados pelo JavaScript); o chip **Todas** vem marcado.
- Cada filtro funciona sozinho e combinado com os outros; **Todas** limpa o filtro de tipo.
- Escolhendo o tamanho **G**, o vestido (estoque 0 em G) não aparece e as camisetas aparecem.
- Digitar `calça` ou `CAMISETA` encontra o produto, sem diferenciar maiúsculas de minúsculas.
- Quando nada combina (por exemplo, **Vestidos** + **Loja do Bairro**), aparece "Nenhum produto encontrado."

## Checklist

- [ ] No `catalogo.html`, trocar o formulário de filtros inteiro (de `<form class="filtros" aria-label="Filtros do catálogo">` até `</form>`) pela versão da aula, com só o chip **Todas** e a opção **Todas**.
- [ ] No `catalogo.js`, trocar as constantes `listaProdutos` e `mensagemVazio` pelo bloco da aula (campos do formulário, dados fictícios de lojas e tipos e o objeto `filtros`).
- [ ] Colar `temEstoque` e `filtrarProdutos` logo antes de `criarCardProduto`.
- [ ] Colar `atualizarCatalogo`, `preencherCategorias`, `preencherLojas`, `escolherCategoria` e `configurarFiltros` logo antes de `iniciar`, nessa ordem.
- [ ] Trocar a função `iniciar` e a chamada `iniciar();` do final pela versão da aula.
- [ ] Conferir os `id` do HTML: `busca`, `filtro-loja`, `filtro-tamanho` e `chips-categorias`.
- [ ] Testar: **Vestidos** mostra só o vestido; **Todas** traz os 6 de volta.
- [ ] Testar: **Loja do Bairro** mostra só os produtos dela; **Vestidos** + **Loja do Bairro** mostra "Nenhum produto encontrado."
- [ ] Testar: tamanho **G** esconde o vestido; busca por `calça` e por `CAMISETA`.
- [ ] Se o filtro de loja não mostrar nada, conferir que `opcao.value = loja.id` (e não o nome).
- [ ] Se algo falhar, escrever `console.log(filtros);` dentro de `atualizarCatalogo` e ver o estado no Console (F12 > **Console**).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D7·A19 – Desenhar o catálogo pelo JavaScript: cards, preço em R$ e estado vazio

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia07-aula20-filtros-com-metodos-de-array.md]({{URL_GUIA}}/dia07-aula20-filtros-com-metodos-de-array.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-02** – Filtrar o catálogo por tipo de roupa.
- **RF-03** – Filtrar o catálogo por loja.
- **RF-04** – Filtrar o catálogo por tamanho, mostrando só produtos com estoque nesse tamanho.
- **RF-05** – Buscar produtos pelo nome, sem diferenciar maiúsculas de minúsculas.

**Observação da aula:** RF-02, RF-03, RF-04 (dados fictícios); ensaia RF-05
