**Data:** 09/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero escrever o guia de estilo em código (variáveis, tipografia e reset), para que trocar uma cor em um só lugar mude todas as páginas.

## Critérios de aceite

- As cinco páginas (`index`, `catalogo`, `loja`, `produto`, `login`) carregam sem erro de arquivo CSS no Console (F12 > **Console**).
- O fundo é o tom quente claro (`#fbf8f6`), o texto é escuro, os títulos têm tamanhos diferentes e as imagens respeitam a largura da tela.
- O conteúdo fica centralizado, com margem nas laterais, em janela larga.
- Trocar `--cor-fundo` em `variaveis.css` muda o fundo de todas as páginas de uma vez (e o valor original foi restaurado).

## Checklist

- [ ] Criar a pasta `css` na raiz do projeto.
- [ ] Criar `css/variaveis.css` com as cores do guia de estilo, fontes, espaços, bordas arredondadas e sombras.
- [ ] Criar `css/base.css` com o reset leve, a tipografia, os links, as imagens e o contêiner central.
- [ ] Colar as duas linhas `<link rel="stylesheet" href="css/variaveis.css">` e `<link rel="stylesheet" href="css/base.css">` dentro do `<head>`, antes de `</head>`, nas cinco páginas, nessa ordem (variáveis primeiro).
- [ ] Abrir o `catalogo.html` no Live Server e conferir fonte, cores e conteúdo centralizado.
- [ ] Apertar F12, abrir a aba **Elements** (em português: **Elementos**), clicar no título "Catálogo" e achar o diagrama do modelo de caixa na aba **Computed** (em português: **Calculado**); identificar `padding`, `border` e `margin`.
- [ ] Experimento com variáveis: trocar `--cor-fundo: #fbf8f6;` por `--cor-fundo: #ffe9f1;`, ver todas as páginas mudarem e voltar ao valor original.
- [ ] Experimento com seletor: na regra `h1` do `base.css`, trocar `var(--tamanho-titulo)` por `3rem`, ver os títulos crescerem e desfazer (Ctrl+Z; Mac: Cmd+Z).
- [ ] Conferir que `class="container"` está no `<main>` e no `<div>` do cabeçalho.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D3·A9 – Montar catalogo, loja, produto e login em HTML e ligar as páginas por links

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia04-aula10-css-seletores-cores-tipografia-e-caixa.md]({{URL_GUIA}}/dia04-aula10-css-seletores-cores-tipografia-e-caixa.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (identidade visual das telas)
