**Data:** 16/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como lojista, quero que o sistema recuse produtos com preço zero, estoque negativo ou mais de 5 fotos, para que nenhum produto inválido entre no catálogo.

## Critérios de aceite

- O catálogo funciona como antes, agora usando objetos `Produto` e `Loja`.
- Com preço `0` no primeiro produto, o Console mostra `O preço deve ser maior que zero.` e nenhum card aparece; depois o preço volta para `129.9`.
- No Console, `p.preco = -1` lança o erro e o preço continua `10` (RN-02).
- Ler um campo privado de fora (`p.#preco`) dá erro de sintaxe: o encapsulamento funciona.
- O produto sem foto devolve `imagens/sem-foto.svg` como capa (RN-12) e o WhatsApp da loja só aceita dígitos com país e DDD (RN-10).

## Checklist

- [ ] Criar a pasta `js/modelos` e o arquivo `js/modelos/ErroApp.js` (erro próprio que herda de `Error`, com `export`).
- [ ] Criar `js/modelos/Produto.js` com campos privados `#`, getters, `temEstoque`, `precoFormatado()`, `fotoCapa()` e as regras de preço, estoque e fotos.
- [ ] Criar `js/modelos/Loja.js` com a lista privada de produtos e a regra do WhatsApp.
- [ ] No `catalogo.js`, fazer as trocas na ordem da aula: (1) as duas linhas de `import` de `Produto` e `Loja` no lugar de `formatarPreco`; (2) lojas e produtos viram objetos `Loja` e `Produto`; (3) apagar a função `temEstoque`; (4) usar `produto.temEstoque(filtros.tamanho)`, `produto.fotoCapa()`, `produto.precoFormatado()`, `filtrarProdutos(produtos, filtros)` e `preencherLojas(lojas)`.
- [ ] Abrir o catálogo: filtros, preços em R$ e estado vazio devem funcionar igual à Aula 21.
- [ ] Teste da regra: trocar o preço do primeiro produto por `0`, recarregar, ver o erro `O preço deve ser maior que zero.` no Console (F12 > **Console**) e voltar para `129.9`.
- [ ] No Console, colar o teste da aula (`const { Produto } = await import("/js/modelos/Produto.js");`) e conferir `Teste R$ 10,00 true false imagens/sem-foto.svg`, depois `preco_invalido - O preço deve ser maior que zero.` e por fim `10`.
- [ ] Conferir que `new Produto({...})` usa `new` e que `export class` está nos três arquivos.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D7·A21 – Validar o formulário de produto no navegador (submit, preventDefault e erros ao lado do campo)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia08-aula22-classes-javascript-produto-e-loja.md]({{URL_GUIA}}/dia08-aula22-classes-javascript-produto-e-loja.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-10** – O WhatsApp é guardado só com dígitos e código do país, e o link segue o formato https://wa.me/número?text=mensagem.
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.
