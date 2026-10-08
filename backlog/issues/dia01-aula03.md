**Data:** 06/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero escrever a primeira página em HTML e vê-la no navegador, para que eu entenda a estrutura básica de uma página e o ciclo salvar-e-ver do Live Server.

## Critérios de aceite

- O `index.html` abre pelo Live Server (endereço parecido com `http://127.0.0.1:5500/index.html`) com título, dois parágrafos, a imagem e o link.
- A aba do navegador mostra o texto "VitrineCol".
- Ao trocar um texto, salvar (Ctrl+S) e olhar o navegador, a mudança aparece sem apertar nada.
- Se o `src` da imagem estiver errado, aparece o texto do `alt`.
- `git log --oneline` mostra o commit da aula e o GitHub mostra `index.html` e a pasta `imagens`.

## Checklist

- [ ] Abrir a pasta `vitrine-col` no VS Code e rodar `git status`: deve dizer `nothing to commit, working tree clean`.
- [ ] No **Explorer** (em português: **Explorador**), clicar em **New Folder** (em português: **Nova Pasta**) e criar a pasta `imagens`.
- [ ] Criar `imagens/sem-foto.svg` com o conteúdo da aula.
- [ ] Criar `index.html` na raiz com o conteúdo da aula e salvar (Ctrl+S; Mac: Cmd+S).
- [ ] Clicar em **Go Live** (em português: **Ir ao vivo**) ou clicar com o botão direito no arquivo e escolher **Open with Live Server** (em português: **Abrir com Live Server**).
- [ ] Testar a atualização automática: trocar o texto de um parágrafo, salvar e olhar o navegador.
- [ ] Experimento 1: trocar `<h1>` por `<h2>` (e o fechamento), ver o título menor e voltar para `h1`.
- [ ] Experimento 2: apagar o valor do `alt` da imagem, entender por que leitores de tela precisam dele e colocar o texto de volta.
- [ ] Experimento 3: trocar o `src` por `imagens/nao-existe.svg`, ver o `alt` aparecer e voltar para `imagens/sem-foto.svg`.
- [ ] Se algo falhar, apertar F12 no navegador e ler a aba **Console** (em português: **Console**).
- [ ] Rodar `git add .`, `git commit -m "..."` (mensagem em português) e `git push`.

## Depende de

- D1·A2 – Instalar Git e Live Server, criar o repositório vitrine-col e fazer o primeiro commit de cada integrante

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia01-aula03-html-estrutura-da-pagina-textos-links-e-imagens.md]({{URL_GUIA}}/dia01-aula03-html-estrutura-da-pagina-textos-links-e-imagens.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (base de todas as telas)
