**Data:** 15/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como lojista, quero que o formulário de produto me avise de cada erro ao lado do campo, para que eu corrija preço, estoque e telefone antes de salvar.

## Critérios de aceite

- Salvar o formulário vazio mostra uma mensagem vermelha ao lado de cada campo inválido ("Informe o nome do produto.", "Escolha a categoria.", "O preço deve ser maior que zero.", "Informe o tamanho.") e leva o foco ao primeiro.
- Preço `-5` e estoque `-1` são recusados com mensagens claras; preço `129,90` (com vírgula) é aceito.
- Com tudo certo aparece **Tudo certo!** e a página não recarrega.
- No Console, `telefoneValido(normalizarTelefone("(27) 99999-9999"))` é `true` (RN-10).

## Checklist

- [ ] No final de `js/ui/formatadores.js`, acrescentar `normalizarTelefone` e `telefoneValido` (regra do telefone escrita uma única vez).
- [ ] No final de `js/ui/avisos.js`, colar as funções que mostram e apagam o erro de um campo.
- [ ] No final de `css/componentes.css`, colar o estilo de campo com erro.
- [ ] Criar a pasta `js/servicos` e o arquivo `js/servicos/produtoServico.js`, por enquanto só com a validação do produto (preço maior que zero, estoque não negativo; RN-02).
- [ ] Criar `js/paginas/painelProdutoForm.js`, que trata o `submit` com `evento.preventDefault()`, limpa os erros **antes** de validar e mostra a mensagem "Tudo certo!".
- [ ] No `painel-produto-form.html`, trocar o bloco `<header>` inteiro por `<header class="cabecalho" id="cabecalho"></header>` e colar `<script type="module" src="js/paginas/painelProdutoForm.js"></script>` antes de `</body>`.
- [ ] Abrir `painel-produto-form.html` e clicar em **Salvar produto** sem preencher nada; conferir os 4 erros e o foco no primeiro campo.
- [ ] Testar preço `-5` e estoque `-1`; depois preço `129,90` e estoque `3` e conferir "Tudo certo!" sem recarregar.
- [ ] No Console (F12 > **Console**), colar `const f = await import("/js/ui/formatadores.js");` e testar o telefone; esperado `5527999999999`, `true` e `false`.
- [ ] Conferir que cada campo está dentro de um `<div class="campo">`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D7·A20 – Filtrar o catálogo por tipo, loja, tamanho e nome com filter, find e includes

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia07-aula21-formularios-e-validacao-no-navegador.md]({{URL_GUIA}}/dia07-aula21-formularios-e-validacao-no-navegador.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-10** – O WhatsApp é guardado só com dígitos e código do país, e o link segue o formato https://wa.me/número?text=mensagem.

**Observação da aula:** RN-02, RN-10 (telefone), RF-21
