**Data:** 06/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero um repositório compartilhado no GitHub com o meu primeiro commit, para que a equipe guarde o histórico do código e trabalhe junta sem perder versões.

## Critérios de aceite

- No terminal do VS Code, `git --version` mostra um número de versão.
- O botão **Go Live** (em português: **Ir ao vivo**) aparece no canto inferior direito do VS Code.
- A página do repositório `vitrine-col` no GitHub mostra `README.md` e `.gitignore`.
- O README lista o nome de cada integrante da equipe.
- `git log --oneline` mostra pelo menos um commit seu, com mensagem em português.

## Checklist

- [ ] Abrir o terminal do VS Code: **Terminal > New Terminal** (em português: **Terminal > Novo Terminal**) e rodar `git --version`. Se der "comando não encontrado", instalar o Git (Windows: https://git-scm.com/download/win, com as opções padrão) e reabrir o VS Code.
- [ ] Instalar o Live Server: abrir **Extensions** (em português: **Extensões**, atalho Ctrl+Shift+X; no Mac, Cmd+Shift+X), buscar `Live Server`, escolher a de **Ritwick Dey** e clicar em **Install** (em português: **Instalar**).
- [ ] Rodar `git config --global user.name "Seu Nome"` e `git config --global user.email "seu-email@exemplo.com"` (o mesmo e-mail da conta do GitHub).
- [ ] (Uma integrante por equipe) Se o repositório `vitrine-col` ainda não existe, no GitHub clicar em **+ > New repository** (em português: **Novo repositório**), nomear `vitrine-col`, deixar **Public** (em português: **Público**) e **não** marcar **Add a README file**; clicar em **Create repository** (em português: **Criar repositório**). Se ele já foi criado para rodar o script do backlog, só conferir o nome e a visibilidade.
- [ ] Convidar as colegas em **Settings > Collaborators > Add people** (em português: **Configurações > Colaboradores > Adicionar pessoas**) e conferir que todas aceitaram o convite por e-mail.
- [ ] Criar a pasta `vitrine-col` no computador e abrir no VS Code: **File > Open Folder...** (em português: **Arquivo > Abrir Pasta...**); se perguntar, clicar em **Yes, I trust the authors** (em português: **Sim, eu confio nos autores**).
- [ ] No painel **Explorer** (em português: **Explorador**), criar `README.md` e `.gitignore` com o conteúdo da aula e salvar com Ctrl+S (Mac: Cmd+S).
- [ ] Rodar `git init` e os comandos da aula para o primeiro commit (mensagem em português) e o `git push`; entrar no GitHub se o navegador pedir.
- [ ] Atualizar a página do repositório no GitHub e conferir que os dois arquivos aparecem.
- [ ] (Cada outra integrante, uma de cada vez) Rodar `git clone https://github.com/SEU-USUARIO/vitrine-col.git` e abrir a pasta com **File > Open Folder...** (em português: **Arquivo > Abrir Pasta...**).
- [ ] Editar o `README.md` trocando `- Nome da primeira integrante` pelo seu nome (uma linha por integrante), salvar e rodar `git add .`, `git commit`, `git pull` e `git push`.
- [ ] Se aparecer conflito (`<<<<<<<`, `=======`, `>>>>>>>`), apagar as três marcas, manter as linhas de todas, rodar `git add .`, `git commit -m "Resolve conflito no README"` e `git push`.
- [ ] Conferir que o quadro do GitHub Projects montado na D1·A1 (aba **Projects**, em português: **Projetos**, do repositório) mostra as issues do backlog nas colunas certas.
- [ ] Rodar `git log --oneline` e conferir um commit de cada integrante.

## Depende de

- D1·A1 – Montar o quadro do GitHub Projects, priorizar os 25 requisitos e formar a equipe

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia01-aula02-git-e-github-repositorio-commits-e-quadro-kanban.md]({{URL_GUIA}}/dia01-aula02-git-e-github-repositorio-commits-e-quadro-kanban.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (preparação do ambiente de desenvolvimento)
