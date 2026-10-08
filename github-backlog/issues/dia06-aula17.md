**Data:** 14/10/2026 (quarta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero guardar os produtos fictícios em uma lista de objetos e percorrê-la com funções, para que o catálogo seja desenhado a partir de dados e não escrito à mão.

## Critérios de aceite

- O Console mostra 6 linhas de resumo (uma por produto, com o estoque total), `false` para "Vestido tem estoque no G?" e `99.80` para o subtotal de duas camisetas.
- A função `calcularDesconto(100, 10)` devolve `90`.
- Um 7º produto acrescentado à lista aparece no laço sem mudar o código do laço.
- Não há erros vermelhos no Console.

## Checklist

- [ ] Abrir o `catalogo.js` e confirmar que ainda mostra as mensagens da Aula 16.
- [ ] Apagar todo o conteúdo de `js/paginas/catalogo.js` e colar a versão da aula, com a lista `produtosFicticios` (`id`, `nome`, `descricao`, `preco`, `categoria`, `lojaId`, `lojaNome`, `tamanhos`, `fotos`) e as funções que a percorrem com `for...of`.
- [ ] Abrir o Console e conferir as 6 linhas, o `false` do vestido no G e o `99.80`.
- [ ] Exercício 1: mudar o `estoque` de G do primeiro produto para `2` e ver a resposta passar a `true`.
- [ ] Exercício 2: escrever `calcularDesconto(preco, percentual)` com `return` e testar `console.log(calcularDesconto(129.9, 20))`.
- [ ] Exercício 3: acrescentar um 7º produto com os mesmos campos (foto `exemplo-1.svg`) e conferir que o laço o mostra.
- [ ] Exercício 4: mostrar só o nome da última peça com `console.log(produtosFicticios[produtosFicticios.length - 1].nome)`.
- [ ] Se aparecer `Cannot read properties of undefined`, lembrar que a contagem das posições começa em 0.
- [ ] Conferir as vírgulas entre os objetos e as chaves `}` de cada um.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D6·A16 – Ligar o primeiro script ao catálogo e treinar variáveis, tipos e condicionais no Console

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia06-aula17-funcoes-arrays-e-objetos.md]({{URL_GUIA}}/dia06-aula17-funcoes-arrays-e-objetos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.

**Observação da aula:** Não se aplica (dados fictícios; ensaia a RN-02)
