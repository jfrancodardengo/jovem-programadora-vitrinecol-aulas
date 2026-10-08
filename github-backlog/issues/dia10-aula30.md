**Data:** 20/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero filtrar por tipo, loja e tamanho, buscar pelo nome e carregar mais produtos aos poucos, para que o catálogo seja rápido e traga só o que eu pedi.

## Critérios de aceite

- Cada filtro (tipo, loja, tamanho e busca) funciona sozinho e combinado, e **Todas** limpa o de tipo (RF-02, RF-03, RF-04).
- O filtro de tamanho **G** não mostra o produto sem estoque nesse tamanho.
- Digitar `CAMISETA` acha a camiseta (RF-05); digitar `zzz` mostra "Nenhum produto encontrado."
- Com `PRODUTOS_POR_PAGINA = 2`, o botão **Carregar mais produtos** aparece, traz o próximo produto sem repetir nenhum e some no fim; ao mudar o filtro, a lista volta à primeira página; depois do teste o valor volta para 12 (RF-01).
- `catalogo.html?categoria=3` abre já filtrado e com o chip **Vestidos** marcado.
- Sem internet (**Offline**), aparece uma mensagem em português.

## Checklist

- [ ] No `produtoServico.js`, colar as três funções de apoio antes de `listarProdutosAtivos`: `escaparCuringas`, `montarConsultaDosProdutosAtivos` e `erroAoListarProdutos`.
- [ ] Trocar `listarProdutosAtivos` pela versão com filtros e colar a função da paginação antes do bloco "Painel da lojista".
- [ ] No `catalogo.html`, colar o `<p class="paginacao">` com o botão **Carregar mais produtos** logo antes de `</section>`.
- [ ] No final de `css/paginas.css`, colar a seção do botão "Carregar mais".
- [ ] Substituir **todo** o conteúdo de `js/paginas/catalogo.js` pelo arquivo completo da aula (filtros no banco, paginação, busca com espera e leitura do endereço).
- [ ] Testar o filtro de tipo (**Vestidos**), de loja (**Loja Exemplo**) e de tamanho (**G**).
- [ ] Testar a busca com `CAMISETA` e com `zzz`.
- [ ] Testar a paginação trocando temporariamente `const PRODUTOS_POR_PAGINA = 12;` por `2`; clicar em **Carregar mais produtos** e conferir que não repete produto; **voltar o valor para 12**.
- [ ] Abrir `catalogo.html?categoria=3` na barra de endereço e conferir o filtro já aplicado.
- [ ] Na aba **Network** (em português: **Rede**) do F12, filtrar por `produtos` e conferir uma consulta por filtro, com parâmetros na URL.
- [ ] Conferir **Offline** na aba **Network** e a mensagem em português.
- [ ] Se produtos se repetirem, conferir o `.order("id")` de desempate; se a busca consultar a cada letra, conferir `setTimeout` e `clearTimeout` em `configurarFiltros`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D10·A29 – Conectar o site ao Supabase com supabase-js e listar os produtos do banco

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia10-aula30-catalogo-e-filtros-consultando-o-banco.md]({{URL_GUIA}}/dia10-aula30-catalogo-e-filtros-consultando-o-banco.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-02** – Filtrar o catálogo por tipo de roupa.
- **RF-03** – Filtrar o catálogo por loja.
- **RF-04** – Filtrar o catálogo por tamanho, mostrando só produtos com estoque nesse tamanho.
- **RF-05** – Buscar produtos pelo nome, sem diferenciar maiúsculas de minúsculas.
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Observação da aula:** RF-01, RF-02, RF-03, RF-04, RF-05 (Desejável), RF-21
