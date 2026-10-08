**Data:** 16/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver uma mensagem clara em português quando algo der errado, para que eu nunca fique diante de uma tela em branco.

## Critérios de aceite

- O catálogo continua funcionando (filtros, preços e estado vazio).
- Com preço `0` em um produto, aparece uma caixa vermelha com "O preço deve ser maior que zero." e a tela não fica em branco.
- Com um erro de programação (por exemplo, `lojasX.find`), aparece "Algo deu errado. Recarregue a página e tente novamente." e o Console mostra o detalhe técnico.
- `catalogo.js` não tem mais a função do card; `js/ui/cards.js` existe.
- A busca por `innerHTML` em `js/` tem 0 resultados.

## Checklist

- [ ] Criar `js/ui/cards.js` com a função `criarCardProduto` exportada (monta o card só com `createElement` e `textContent`).
- [ ] No `js/ui/avisos.js`, colocar o `import` do `ErroApp` logo após o primeiro comentário e colar as funções `mensagemDoErro` e `registrarErro` antes da seção "Erros ao lado de cada campo de formulário".
- [ ] No `catalogo.js`, trocar as importações para trazer o card de `cards.js` e as funções de erro de `avisos.js`.
- [ ] Tirar a criação das lojas e dos produtos do corpo do arquivo e apagar a função `criarCardProduto` do catálogo.
- [ ] Colar a função `carregarLojasFicticias` antes de `iniciar` e trocar `iniciar` pela versão com `try/catch`, chamando `mostrarErro(mensagemDoErro(erro))`.
- [ ] Teste 1: abrir o catálogo e conferir que funciona como antes.
- [ ] Teste 2: preço `0` no primeiro produto, recarregar, ver a caixa vermelha e voltar para `129.9`.
- [ ] Teste 3: trocar `lojas.find(...)` por `lojasX.find(...)`, recarregar, ver a mensagem geral, olhar o Console (F12 > **Console**) e desfazer.
- [ ] Conferir a organização em `js/modelos`, `js/ui` e `js/paginas`.
- [ ] Procurar `innerHTML` em `js/` (Ctrl+Shift+F; Mac: Cmd+Shift+F) e confirmar 0 resultados.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D8·A23 – Criar Usuaria, Cliente e Lojista (herança e polimorfismo) e ligar Loja a Produto (agregação)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia08-aula24-tratamento-de-erros-e-modulos.md]({{URL_GUIA}}/dia08-aula24-tratamento-de-erros-e-modulos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
