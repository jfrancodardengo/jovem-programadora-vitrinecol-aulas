**Data:** 22/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver a página do produto com fotos, tamanhos e quantidade e a página da loja com endereço e WhatsApp, para que eu escolha a peça certa e saiba como falar com a loja.

## Critérios de aceite

- A página do produto mostra galeria com miniaturas, preço, "Vendido por Loja Exemplo", descrição e tamanhos; o tamanho **G** (estoque 0) aparece riscado e não pode ser escolhido (RF-08).
- As miniaturas trocam a foto grande com o mouse e com o teclado (Tab + Enter); o título da aba passa a ser o nome do produto.
- Sem tamanho escolhido aparece "Escolha um tamanho." e com quantidade `0` aparece "A quantidade mínima é 1." ao lado do campo (RN-02).
- `produto.html?id=abc`, `produto.html` sem id e `loja.html?id=abc` mostram "Produto não encontrado." ou "Loja não encontrada.", sem tela em branco; um produto inativo também mostra "Produto não encontrado." (RN-08).
- A página da loja mostra nome, descrição, endereço, o botão **Conversar no WhatsApp** com link `https://wa.me/5527999999999?text=...` (RN-10), os produtos e o botão **Ver no mapa** só quando existe link (RF-06, RF-07).

## Checklist

- [ ] Abrir um card do catálogo e olhar a barra de endereço: o `?id=...` é o código do produto.
- [ ] No `produtoServico.js`, colar a função `obterProduto` antes do bloco "Painel da lojista".
- [ ] No `lojaServico.js`, colar a seção "Páginas públicas" antes do comentário `// ---------- Painel da lojista ----------`.
- [ ] No final de `js/ui/formatadores.js`, acrescentar `criarLinkDoWhatsapp` (monta `https://wa.me/<número>?text=<mensagem codificada>` com `encodeURIComponent`).
- [ ] Substituir **todo** o conteúdo de `produto.html` e criar `js/paginas/produto.js`.
- [ ] Substituir **todo** o conteúdo de `loja.html` e criar `js/paginas/loja.js`.
- [ ] Testar o **Vestido midi floral**: foto grande, 3 miniaturas, **Vendido por Loja Exemplo**, tamanho **G** riscado.
- [ ] Testar a galeria com o mouse e com Tab + Enter.
- [ ] Clicar em **Adicionar à sacola** sem tamanho, depois com quantidade `0`, depois com `2` (por enquanto aparece só a mensagem de teste).
- [ ] Abrir `produto.html?id=abc`, `produto.html` e `loja.html?id=abc` e conferir o link **Voltar ao catálogo**.
- [ ] Desativar um produto em **Meus produtos** e abrir o endereço dele.
- [ ] Na página da loja, clicar em **Conversar no WhatsApp** (abre em nova aba) e conferir o endereço `https://wa.me/...`.
- [ ] Em **Minha loja**, apagar o link do mapa, salvar e conferir que o botão **Ver no mapa** some da página pública (RF-07).
- [ ] Confirmar que a página usa só `textContent` e `createElement` (nenhum `innerHTML` em `js/`).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D11·A33 – Enviar até 5 fotos por produto ao Supabase Storage, com capa, reordenação e versão 0.5 (Marco 3)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia12-aula34-paginas-de-produto-e-de-loja.md]({{URL_GUIA}}/dia12-aula34-paginas-de-produto-e-de-loja.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-06** – Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos.
- **RF-07** – Oferecer um botão com o link do mapa da loja.
- **RF-08** – Mostrar a página do produto com galeria de fotos, descrição, preço, loja e tamanhos, com escolha de tamanho e quantidade.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-08** – Produto inativo não aparece no catálogo nem na página da loja.
- **RN-10** – O WhatsApp é guardado só com dígitos e código do país, e o link segue o formato https://wa.me/número?text=mensagem.
