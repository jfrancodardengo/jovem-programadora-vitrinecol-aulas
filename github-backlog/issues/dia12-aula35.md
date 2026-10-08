**Data:** 22/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero juntar peças de lojas diferentes na mesma sacola e ver o subtotal de cada loja e o total, para que eu compre de várias lojas de uma vez sem perder o que escolhi ao recarregar a página.

## Critérios de aceite

- Peças de duas lojas ficam na mesma sacola, agrupadas por loja, cada bloco com o subtotal da loja e, no fim, o **Total**; o botão diz "Finalizar sacola (2 pedidos)" (RF-09, RN-03, CT-04).
- Recarregar a página (F5) mantém itens, subtotais e total (CT-05).
- O contador no cabeçalho soma ao adicionar, diminui ao remover e some em zero.
- Quantidade `0` mostra "A quantidade mínima é 1." e volta ao valor anterior (RN-02); o mesmo produto no mesmo tamanho vira uma linha só com quantidade `2`.
- Sem itens aparece "Sua sacola está vazia. Ver o catálogo."; na aba **Application** (em português: **Aplicativo**) existe a chave `sacola` no **Local Storage** (em português: **Armazenamento local**).

## Checklist

- [ ] Criar `js/modelos/Sacola.js` (adicionar, mudar a quantidade, remover, salvar no `localStorage`; aceita lojas diferentes).
- [ ] No `cabecalho.js`: trocar o comentário e a importação da `Sacola`; trocar os links para o link da sacola pedir o contador (`comContador: true`); colar `atualizarContadorSacola` antes de `criarLink`; trocar `criarLink` e `montarCabecalho` pelas versões da aula.
- [ ] No `css/componentes.css`, colar a seção do contador antes de `/* ---------- Erro ao lado de um campo de formulário ---------- */`.
- [ ] No `produto.js`: trocar o comentário do começo; importar `atualizarContadorSacola` e `Sacola`; trocar o trecho final do `submit` para gravar na sacola e mostrar "Peça adicionada à sacola. Ver sacola ou continuar comprando."
- [ ] Substituir **todo** o conteúdo de `sacola.html` e criar `js/paginas/sacola.js`.
- [ ] Testar (CT-04): adicionar uma peça da **Loja Exemplo** e uma de outra loja e conferir que o site não pergunta nada ao misturar.
- [ ] Abrir **Sacola** e conferir os blocos por loja, subtotais, **Total** e "Finalizar sacola (2 pedidos)".
- [ ] Mudar a quantidade para `3` (valores atualizam sem recarregar) e para `0` (erro e volta ao valor anterior).
- [ ] Clicar em **Remover**, conferir o contador e o foco no próximo botão; remover todos e ver "Sua sacola está vazia."
- [ ] Adicionar duas vezes o mesmo produto e tamanho e conferir uma linha com quantidade `2`.
- [ ] Testar (CT-05): recarregar com itens na sacola e abrir outra página; contador e valores continuam.
- [ ] No F12 > **Application** (em português: **Aplicativo**) > **Local Storage** (em português: **Armazenamento local**), conferir a chave `sacola`.
- [ ] Se a sacola esvaziar ao recarregar, conferir que toda alteração termina com `sacola.salvar()`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D12·A34 – Montar as páginas de produto (galeria) e de loja (endereço e mapa) usando o id na URL

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia12-aula35-sacola-agrupada-por-loja.md]({{URL_GUIA}}/dia12-aula35-sacola-agrupada-por-loja.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-09** – Manter uma sacola com peças de várias lojas: adicionar, mudar quantidade, remover, subtotal por loja e total.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-03** – A sacola mistura lojas; ao finalizar, sai um pedido por loja, cada um com o seu status e o mesmo código de compra (grupo_id).
- **CT-04** – Adicionar produtos de duas lojas à sacola.
- **CT-05** – Recarregar a página e manter a sacola.

**Observação da aula:** RF-09, RN-02, RN-03; CT-04 e CT-05
