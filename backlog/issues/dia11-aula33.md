**Data:** 21/10/2026 (quarta-feira) · **Prioridade:** Importante · **Marco:** Marco 3 · CRUD com imagens (versão 0.5)

## User Story

Como lojista, quero cadastrar até 5 fotos por produto e escolher qual é a capa, para que as clientes vejam a peça de vários ângulos.

## Critérios de aceite

- Um produto com 3 fotos mostra a primeira como capa no catálogo (selo **Capa**) e todas na edição; os botões **Mover para cima/baixo** mudam a capa (RF-19, RN-12, CT-10).
- No Storage, os arquivos ficam em `loja/produto/uuid.jpg` e uma foto de câmera com mais de 1 MB fica com cerca de 200 KB (CT-25).
- Escolher a 6ª foto, um arquivo `.gif` ou um arquivo maior que 2 MB é recusado com mensagem clara, e as fotos já escolhidas continuam na lista (CT-16).
- Excluir o produto apaga os arquivos do Storage (RF-18).
- Sem foto, o card mostra a imagem padrão "Sem foto" (RN-12).
- A tag `v0.5` aparece no GitHub (**Marco 3**).

## Checklist

- [ ] No painel do Supabase, abrir **Storage** (em português: **Armazenamento**) e clicar em **New bucket** (em português: **Novo bucket**); em **Name** (em português: **Nome**) escrever `produtos`, ligar **Public bucket** (em português: **Bucket público**) e clicar em **Create** (em português: **Criar**).
- [ ] No **SQL Editor** (em português: **Editor SQL**), rodar a política provisória `create policy "dev: envio de fotos" on storage.objects for insert to anon ...` (só permite enviar) e anotar no quadro que ela deve ser apagada no Dia 13.
- [ ] Criar `js/servicos/storageServico.js`, `js/ui/imagem.js` (reduz a foto no navegador para cerca de 200 KB) e `js/ui/listaDeFotos.js` (selo **Capa**, **Mover para cima**, **Mover para baixo** e **Remover**).
- [ ] No `produtoServico.js`: trocar as importações (`MAXIMO_DE_FOTOS` e Storage); trocar `validarProduto` pela versão com a regra das 5 fotos; colar `enviarFotosNovas` antes de `criarProduto`; trocar `criarProduto`, `atualizarProduto` e `excluirProduto` pelas versões com fotos.
- [ ] No `painel-produto-form.html`, colar a seção `<section aria-labelledby="titulo-fotos">` antes de `<div class="acoes-formulario">`.
- [ ] No `painelProdutoForm.js`, fazer as nove trocas na ordem da aula (importações, campos das fotos, lista de fotos, leitura do formulário com `fotos.obterParaSalvar()`, erro ao lado do campo, eventos das fotos, mensagem de envio, campo de endereço da imagem como alternativa, `preencherFormulario`).
- [ ] Testar (CT-10): cadastrar um produto com 3 fotos, usar **Mover para baixo** na primeira e salvar; conferir a capa no catálogo e as 3 fotos na edição.
- [ ] Conferir no **Storage** > bucket `produtos` a pasta com o id da loja e a pasta do produto.
- [ ] Testar (CT-25): enviar uma foto de câmera com mais de 1 MB e menos de 2 MB e conferir o arquivo com cerca de 200 KB (JPG).
- [ ] Testar (CT-16): escolher 6 fotos, um `.gif` e um arquivo maior que 2 MB; conferir a mensagem e que as fotos da lista não somem.
- [ ] Excluir o produto de teste em **Meus produtos** e conferir que os arquivos somem do Storage.
- [ ] Plano B: se o envio falhar, informar o endereço (URL) de uma imagem da internet no campo que aparece e salvar.
- [ ] Se der `new row violates row-level security policy`, conferir o nome do bucket e a política; se as fotos não aparecerem no catálogo, conferir **Public bucket**.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`; criar e enviar a tag `v0.5` (`git tag v0.5` e `git push origin v0.5`).

## Depende de

- D11·A32 – Editar, desativar, ativar e excluir produtos (UPDATE e DELETE)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia11-aula33-fotos-no-supabase-storage.md]({{URL_GUIA}}/dia11-aula33-fotos-no-supabase-storage.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-18** – Permitir à lojista desativar ou excluir produto.
- **RF-19** – Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar.
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.
- **CT-10** – Lojista cadastra produto com 3 fotos; a primeira é a capa.
- **CT-16** – Enviar a 6ª foto ou um arquivo maior que 2 MB e o sistema recusar com mensagem clara.
- **CT-25** – Enviar uma foto grande e conferir que o arquivo guardado tem cerca de 200 KB.

**Observação da aula:** RF-19, RN-12, RF-18 (apagar as fotos ao excluir); CT-10, CT-16 e CT-25
