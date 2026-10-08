**Data:** 21/10/2026 (quarta-feira) · **Prioridade:** Essencial

## User Story

Como lojista, quero corrigir, desativar e excluir os meus produtos, para que o catálogo mostre só o que eu realmente vendo.

## Critérios de aceite

- A tabela **Meus produtos** lista os produtos da loja, ativos e inativos, e vira blocos em 360 px.
- Editar abre o formulário com os dados preenchidos, salva ("Produto atualizado com sucesso.") e a mudança aparece no catálogo (RF-17).
- Desativar tira o produto do catálogo ("Produto desativado: ele não aparece mais no catálogo."); Ativar traz de volta (RN-08).
- Excluir um produto novo funciona, com confirmação; excluir um produto já pedido mostra "Este produto já foi pedido; desative-o em vez de excluir." (RF-18).
- `painel-produto-form.html?id=abc` mostra "Produto não encontrado."

## Checklist

- [ ] No `produtoServico.js`, colar a constante `MENSAGEM_PRODUTO_JA_PEDIDO` antes de `normalizarTamanho` e as funções `listarProdutosDaLoja` e `obterProdutoParaEdicao` antes de `montarLinhas`.
- [ ] Colar no final do arquivo `atualizarProduto`, `definirAtivo` e `excluirProduto`, nessa ordem.
- [ ] Substituir **todo** o conteúdo de `painel-produtos.html` e criar `js/paginas/painelProdutos.js`.
- [ ] No `painelProdutoForm.js`, fazer as cinco trocas: cabeçalho e importações; `idNaUrl` com `URLSearchParams` (modo edição); salvar criando **ou** atualizando; colar `preencherFormulario` antes de `iniciar`; trocar `iniciar`.
- [ ] Testar a lista (Ativo/Inativo, 360 px em blocos).
- [ ] Testar **Editar** no Short jeans (preço `69,90`, tirar o tamanho G) e conferir o novo preço no catálogo.
- [ ] Testar **Desativar** (some do catálogo) e **Ativar** (volta).
- [ ] Testar **Excluir** com a confirmação do navegador.
- [ ] No **SQL Editor** (em português: **Editor SQL**), gravar um pedido de teste (`insert into public.pedidos ...` com os ids da sua conta), tentar excluir a **Camiseta básica branca** na tela e ver a mensagem de "desative-o"; depois apagar o pedido de teste com `delete from public.pedidos where id = '11111111-1111-1111-1111-111111111111';`.
- [ ] Abrir `painel-produto-form.html?id=abc` e ver "Produto não encontrado."
- [ ] Se o formulário abrir vazio ao editar, conferir o `?id=` do link **Editar** e a chamada de `preencherFormulario` em `iniciar`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D11·A31 – Cadastrar a loja e os produtos (INSERT) como lojista de teste

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia11-aula32-editar-e-excluir-produtos.md]({{URL_GUIA}}/dia11-aula32-editar-e-excluir-produtos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-17** – Permitir à lojista editar produto.
- **RF-18** – Permitir à lojista desativar ou excluir produto.
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RN-08** – Produto inativo não aparece no catálogo nem na página da loja.
