**Data:** 12/11/2026 (quinta-feira) · **Prioridade:** Importante

## User Story

Como cliente, quero excluir a minha conta e os meus dados digitando EXCLUIR, para que eu possa apagar tudo de forma definitiva quando quiser.

## Critérios de aceite

- **Minha conta** mostra **Meus dados** (nome, e-mail e tipo de conta) e a área **Excluir minha conta** (borda vermelha) com a lista do que vai sumir (para a lojista, também a loja, os produtos, as fotos e os pedidos recebidos).
- Com o campo vazio, aparece "Digite EXCLUIR para confirmar." e nada é excluído; digitando `excluir` ou `EXCLUIR` (sem espaços), aparecem "Excluindo a conta…" e "Conta excluída. Obrigada por ter usado a VitrineCol. Redirecionando…", e em 2 segundos a pessoa volta à página inicial como visitante (RF-25).
- A exclusão apaga perfil, pedidos, loja, produtos, tamanhos e fotos, inclusive os arquivos no Storage: a conta some de **Authentication > Users**, `select count(*) from public.perfis where nome = 'NOME DA CONTA';` volta `0` e a pasta da loja some do bucket `produtos` (RN-14, CT-24).
- Tentar entrar com o e-mail e a senha da conta excluída mostra "E-mail ou senha incorretos."; visitante que abre `minha-conta.html` vai para `login.html?voltar=minha-conta.html`.

## Checklist

- [ ] Abrir uma nova branch: `git switch -c minha-conta`.
- [ ] No `authServico.js`, trocar a importação de formatadores pela versão da aula (com o apoio ao Storage) e colar no final a seção "Excluir a própria conta" (apaga primeiro os arquivos de foto do Storage e depois chama a função `excluir_minha_conta` do banco).
- [ ] Criar `minha-conta.html` e `js/paginas/minhaConta.js`.
- [ ] No `css/paginas.css`, colar a seção "Minha conta" antes de `/* ---------- Botão "Carregar mais" do catálogo ---------- */`.
- [ ] Criar uma conta **só para o teste**: cadastrar uma lojista de teste em **Cadastrar**, criar a loja em **Minha loja** e um produto com **uma foto**.
- [ ] Clicar no nome no cabeçalho ("Olá, ...") para abrir **Minha conta** e conferir os dados e a área de exclusão.
- [ ] Clicar em **Excluir minha conta** com o campo vazio e conferir a mensagem; depois digitar `EXCLUIR` e confirmar.
- [ ] Conferir em **Authentication > Users** (em português: **Autenticação > Usuários**), no **SQL Editor** (em português: **Editor SQL**) (`perfis` e `lojas`) e em **Storage** > `produtos` (em português: **Armazenamento**) que tudo sumiu.
- [ ] Tentar entrar com a conta excluída e conferir a mensagem de erro.
- [ ] Abrir `minha-conta.html` sem login e conferir o redirecionamento.
- [ ] Se aparecer `permission denied for function excluir_minha_conta`, rodar o `04_melhorias.sql` (Aula 39); se as fotos ficarem no Storage, apagar a pasta da loja pelo painel.
- [ ] Conferir que o pedido de exclusão chama a função do banco e que o site nunca grava direto nas tabelas `pedidos` e `itens_pedido`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push -u origin minha-conta`; abrir o pull request (o conteúdo real fica no Supabase, não no repositório) e pedir a revisão de outra integrante.
- [ ] Combinar com a equipe a carga do conteúdo real e os ajustes de interface descritos nas observações do dia, registrando cada problema em uma issue de pendência com prioridade.

## Depende de

- D26·A77 – Criar Meus pedidos e o aviso de novidades para a cliente

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia26-aula78-minha-conta-conteudo-real-e-ajustes.md]({{URL_GUIA}}/dia26-aula78-minha-conta-conteudo-real-e-ajustes.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-25** – Permitir à usuária excluir a própria conta.
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.
- **RN-14** – A usuária pode excluir a própria conta; a exclusão apaga perfil, pedidos, loja, produtos, tamanhos e fotos, de forma definitiva.
- **CT-24** – Excluir a própria conta; a conta e os dados somem e não dá mais para entrar.

**Observação da aula:** RF-25, RN-14, RN-12 (carga de fotos); CT-24
