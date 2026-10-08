**Data:** 08/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero uma página com regiões semânticas (header, nav, main, section, footer), para que leitores de tela e o navegador entendam a estrutura e eu tenha um modelo de cabeçalho e rodapé para copiar nas outras páginas.

## Critérios de aceite

- O `index.html` abre pelo Live Server sem erros e mostra cabeçalho, conteúdo e rodapé.
- O painel **Outline** (em português: **Estrutura de tópicos**) mostra um `h1` e dois `h2`.
- Apertando Tab, o primeiro foco vai para o link "Ir para o conteúdo".
- Toda imagem tem `alt` (busca com Ctrl+F por `<img`).

## Checklist

- [ ] Abrir o `index.html` no Live Server e navegar com a tecla Tab para ver o comportamento antes da mudança.
- [ ] Apagar todo o conteúdo do `index.html` e colar o modelo semântico da aula; salvar com Ctrl+S (Mac: Cmd+S).
- [ ] Conferir no navegador: o menu aparece como lista de links e os links para páginas que ainda não existem (Catálogo, Sacola, Entrar) são esperados.
- [ ] Apertar Tab e conferir a ordem: "Ir para o conteúdo", logotipo e links do menu.
- [ ] Abrir o painel **Outline** (em português: **Estrutura de tópicos**) no Explorer; se não aparecer, usar **View > Open View...** (em português: **Exibir > Abrir Modo de Exibição...**) e escolher **Outline**. Conferir um `h1` e dois `h2`.
- [ ] Experimento: trocar `<main>` por `<div>` (nas duas pontas), ver a região principal sumir no Outline e desfazer com Ctrl+Z (Mac: Cmd+Z).
- [ ] Conferir que o `href` do link de pular e o `id` do `main` têm a mesma grafia, sem acento.
- [ ] Conferir que há um único `h1` na página (o nome do site no cabeçalho é um link `a`).
- [ ] Rodar `git add .`, `git commit -m "..."` (mensagem em português) e `git push`.

## Depende de

- D2·A6 – Definir nome, paleta, tipografia e guia de estilo (Marco 1)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia03-aula07-html-semantico.md]({{URL_GUIA}}/dia03-aula07-html-semantico.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (base de acessibilidade de todas as telas)
