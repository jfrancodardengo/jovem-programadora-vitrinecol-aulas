**Data:** 26/10/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero corrigir cada defeito em uma branch própria e juntar com um pull request revisado, para que a correção entre na main sem quebrar o que já funcionava.

## Critérios de aceite

- Cada defeito crítico ou importante corrigido tem uma branch, um pull request aprovado por **outra** integrante e o merge na `main`; a issue do defeito foi para "Concluído".
- O caso de teste que falhou **passa** agora e o `docs/TESTES.md` foi atualizado (`FALHOU` para `OK`, com a data).
- A busca por `innerHTML` em `js/` dá 0 resultados e a busca por `service_role` não encontra chave nenhuma (RF-21: nenhuma tela em branco).
- `git log --oneline --graph` mostra as branches e os merges, com commits de várias integrantes.

## Checklist

- [ ] No quadro, escolher as issues de defeito **críticos** e **importantes**; cada integrante assume um e o move para "Em Andamento" (quem ficou sem defeito corrige um desejável ou faz a revisão de código).
- [ ] No terminal, voltar para a `main` (`git switch main`), trazer as novidades (`git pull`) e criar a branch (`git switch -c correcao-nome-do-defeito`); conferir com `git branch`.
- [ ] Se não houver defeito, usar o exercício de apoio: branch `correcao-email-de-contato` e trocar `EMAIL-DA-EQUIPE@exemplo.com` pelo e-mail real da equipe em `js/config.js`.
- [ ] Reproduzir o defeito (Aula 41), corrigir, testar o caso e o fluxo ao redor, e fazer `git add .` e `git commit -m "..."` com mensagem clara.
- [ ] Enviar a branch: `git push -u origin correcao-nome-do-defeito`.
- [ ] No GitHub, clicar em **Compare & pull request** (em português: **Comparar e criar pull request**), escrever título e descrição (o que mudou, qual caso CT-xx corrige e como testar) e escolher outra integrante em **Reviewers** (em português: **Revisores**); clicar em **Create pull request** (em português: **Criar pull request**).
- [ ] A revisora abre **Files changed** (em português: **Arquivos alterados**), lê o que mudou e clica em **Review changes** (em português: **Revisar alterações**) > **Approve** (em português: **Aprovar**) > **Submit review** (em português: **Enviar revisão**).
- [ ] Quem abriu o pull request clica em **Merge pull request** (em português: **Mesclar pull request**), **Confirm merge** (em português: **Confirmar merge**) e **Delete branch** (em português: **Excluir branch**); depois roda `git switch main` e `git pull`.
- [ ] Em dupla, fazer a revisão de código com a lista de conferência da aula (nomes em português sem acento, comentários que explicam o porquê, um arquivo por responsabilidade, nenhum `innerHTML` com dados, nenhum segredo no código, mensagens em português, "Carregando…" e `try/catch` em toda chamada ao banco, valores em R$ e datas `dd/mm/aaaa`, código repetido em um lugar só).
- [ ] (Opcional, em dupla) Criar um conflito de propósito no `README.md` em duas branches e resolver com **Resolve conflicts** (em português: **Resolver conflitos**), **Mark as resolved** (em português: **Marcar como resolvido**) e **Commit merge** (em português: **Fazer o commit do merge**).
- [ ] Atualizar o `docs/TESTES.md` com os casos que passaram a `OK`.
- [ ] Rodar `git log --oneline --graph` e conferir as branches e os merges.

## Depende de

- D14·A41 – Depurar com as DevTools e executar os 25 casos de teste (CT-01 a CT-25)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia14-aula42-correcoes-e-git-em-equipe.md]({{URL_GUIA}}/dia14-aula42-correcoes-e-git-em-equipe.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Observação da aula:** RF-21 e os RF dos casos que falharam
