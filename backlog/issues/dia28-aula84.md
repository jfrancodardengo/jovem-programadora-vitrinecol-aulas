**Data:** 16/11/2026 (segunda-feira) · **Prioridade:** Essencial · **Marco:** Marco 8 · versão 1.0 publicada e congelada

## User Story

Como aluna desenvolvedora, quero entregar a versão 1.0 marcada no Git, com documentação que bate com o sistema e o código congelado, para que qualquer pessoa consiga usar e entender o projeto sem a nossa ajuda.

## Critérios de aceite

- O `README.md` está atualizado para a versão 1.0, com manual de uso (cliente e lojista), estrutura de pastas, segurança, testes, histórico de versões e o diagrama ER das 8 tabelas desenhado no GitHub.
- Uma colega que não escreveu o manual o executou como cliente (do catálogo a **Meus pedidos**) e como lojista (loja, produto, pedido recebido) e tudo funcionou exatamente como escrito.
- A tag `v1.0` existe no GitHub e aponta para o commit que **já tem** o README final; há um release com as novidades da versão.
- O combinado de congelamento ("a partir de hoje, só correção de erro grave, em branch e pull request revisado") está registrado no README e no quadro.
- O link público funciona no computador e no celular, no fluxo completo, com o e-mail de contato real na página de privacidade (**Marco 8**).

## Checklist

- [ ] Criar a branch `documentacao-final` (`git switch -c documentacao-final`).
- [ ] Substituir **todo** o conteúdo do `README.md` pela versão da aula; trocar `SEU-USUARIO`, conferir os nomes das integrantes e a data da versão e ler cada passo conferindo se é verdadeiro.
- [ ] Pedir a uma colega que não participou da escrita que execute o manual como cliente e como lojista; anotar o que não bate e corrigir.
- [ ] Conferir que os 15 arquivos HTML da tabela de telas existem na raiz.
- [ ] Comparar a árvore de pastas do README com a pasta real (`js/modelos`, `js/servicos`, `js/ui`, `js/paginas`, `css` com 5 arquivos e `database` com 4 scripts).
- [ ] Fazer `git add .`, `git commit -m "..."`, `git push -u origin documentacao-final`, abrir o pull request, pedir a revisão e fazer o merge **antes** de marcar a tag.
- [ ] Conferir no GitHub que o diagrama ER aparece desenhado (bloco com três crases e `mermaid` bem fechado).
- [ ] Registrar o combinado de congelamento no README (seção "Histórico de versões") e no quadro.
- [ ] Com a `main` atualizada (`git switch main` e `git pull`), criar e enviar a tag (`git tag v1.0` e `git push origin v1.0`); só uma integrante cria a tag.
- [ ] No GitHub, abrir **Releases** (em português: **Versões**) > **Create a new release** (em português: **Criar uma nova versão**); em **Choose a tag** (em português: **Escolher uma tag**) escolher `v1.0`; em **Release title** (em português: **Título da versão**) escrever `Versão 1.0`; descrever as novidades e clicar em **Publish release** (em português: **Publicar versão**).
- [ ] (Opcional) Em **Settings** (em português: **Configurações**) > **Branches**, criar uma regra para a `main` que exija pull request antes de juntar.
- [ ] Abrir `https://SEU-USUARIO.github.io/vitrine-col/` no computador e no celular, em janela anônima ou depois de sair da conta.
- [ ] Percorrer o fluxo completo: página inicial, catálogo com filtros, produto, sacola com duas lojas, **Cadastrar**, finalizar, **Meus pedidos** e, em outro aparelho, o painel da lojista com **Pedidos recebidos**.
- [ ] Conferir que os links do README, do release e do cabeçalho funcionam e que o e-mail de contato da página de privacidade é o real.
- [ ] Guardar o link e um vídeo curto da demonstração (gravação de reserva, para o caso de a internet falhar).

## Depende de

- D28·A83 – Revisar a segurança (RLS, chaves, acessos indevidos) e publicar a versão final

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia28-aula84-documentacao-final-e-versao-1-0.md]({{URL_GUIA}}/dia28-aula84-documentacao-final-e-versao-1-0.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (documentação e entrega da versão 1.0)
