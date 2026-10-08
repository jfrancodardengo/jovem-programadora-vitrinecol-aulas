**Data:** 21/10/2026 (quarta-feira) · **Prioridade:** Essencial

## User Story

Como lojista, quero cadastrar a minha loja e os meus produtos com categoria, preço e tamanhos com estoque, para que as clientes vejam o que eu vendo no catálogo.

## Critérios de aceite

- A tela **Minha loja** carrega a loja de teste, grava a edição ("Loja salva com sucesso.") e mostra o WhatsApp só com dígitos começando por `55` (por exemplo, `5527999998888`) (RF-15, RN-10).
- O produto **Short jeans** é cadastrado e aparece no catálogo; filtrando por tamanho **G** (estoque 0), ele não aparece (RF-16).
- Tamanho repetido ("Este tamanho já foi adicionado.") e preço `0` ("O preço deve ser maior que zero.") mostram erro ao lado do campo (RN-02).
- Cadastrar um produto com o nome `<img src=x onerror=alert(1)>` mostra o texto como texto no catálogo, sem alerta.
- No **Table Editor** (em português: **Editor de tabelas**), `lojas`, `produtos` e `tamanhos` têm as linhas novas; uma segunda loja da mesma lojista é recusada (RN-01).

## Checklist

- [ ] No painel do Supabase, abrir **Authentication** (em português: **Autenticação**) > **Users** (em português: **Usuários**) e copiar o **UID** da lojista de teste.
- [ ] No final de `js/config.js`, colar a constante provisória `LOJISTA_DE_TESTE_ID` e trocar o valor pelo UID copiado.
- [ ] Criar `js/servicos/errosSupabase.js`, que traduz os erros do Supabase para `ErroApp` em português.
- [ ] No `lojaServico.js`, trocar o começo do arquivo pelas novas importações e colar no final o bloco "Painel da lojista" (validação, `obterMinhaLoja` e `salvarLoja`).
- [ ] No `painel-loja.html`: trocar o `<header>` por `<header class="cabecalho" id="cabecalho"></header>`, acrescentar `hidden` na linha do `<form ... id="formulario-loja" novalidate hidden>` e colar `<script type="module" src="js/paginas/painelLoja.js"></script>` antes de `</body>`.
- [ ] Criar `js/paginas/painelLoja.js`.
- [ ] Testar a tela Minha loja: editar a descrição, salvar e recarregar; digitar o WhatsApp `27 99999-8888` e ver `5527999998888`; apagar o nome e ver "Informe o nome da loja."; digitar um link de mapa sem `https://` e ver o erro do link.
- [ ] Conferir no **Table Editor** > `lojas` que o WhatsApp está só com dígitos.
- [ ] No `produtoServico.js`, trocar a importação do `ErroApp` por ela mais `Produto` e a tradução de erros; colar no final `montarLinhas`, `conferirComOModelo` e `criarProduto`.
- [ ] Substituir **todo** o conteúdo de `painel-produto-form.html` e de `js/paginas/painelProdutoForm.js` pelas versões da aula (linhas de tamanho criadas pelo JavaScript).
- [ ] Testar o formulário: clicar em **Adicionar tamanho** duas vezes e em **Remover tamanho** em uma; cadastrar `Short jeans`, categoria **Shorts**, preço `79,90`, tamanhos `M` (estoque 3) e `G` (estoque 0); conferir que o produto aparece no catálogo e não aparece com o filtro **G**.
- [ ] Testar erros: tamanho `M` repetido e preço `0`.
- [ ] Teste de segurança: cadastrar um produto com o nome `<img src=x onerror=alert(1)>`, conferir que aparece como texto e apagá-lo depois no **Table Editor**.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push` (o id provisório não é senha, mas será apagado no Dia 13).

## Depende de

- D10·A30 – Passar os filtros para a consulta ao banco e criar o "Carregar mais produtos" (12 por página)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia11-aula31-cadastro-de-lojas-e-produtos.md]({{URL_GUIA}}/dia11-aula31-cadastro-de-lojas-e-produtos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-15** – Permitir à lojista criar e editar a própria loja.
- **RF-16** – Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque.
- **RN-01** – Cada lojista tem no máximo uma loja.
- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.
- **RN-10** – O WhatsApp é guardado só com dígitos e código do país, e o link segue o formato https://wa.me/número?text=mensagem.
