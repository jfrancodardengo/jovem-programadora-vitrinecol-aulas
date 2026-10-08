**Data:** 13/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero poder usar o site só com o teclado e ler tudo com bom contraste, para que a plataforma seja acessível a quem não usa o mouse.

## Critérios de aceite

- Com a tecla Tab, o primeiro foco mostra "Ir para o conteúdo" e depois todos os elementos interativos mostram um contorno azul de 3 px.
- O contraste de dois pares de cores foi anotado, ambos com ✓ (acima de 4,5:1).
- Trocar `--cor-primaria` mudou botões, chips, contador e preço ao mesmo tempo, e o valor original foi restaurado.
- Os quatro CSS continuam ligados às cinco páginas, na ordem `variaveis`, `base`, `componentes`, `paginas`.

## Checklist

- [ ] Sem usar o mouse, abrir o `catalogo.html` e apertar Tab várias vezes para ver como o foco está antes da mudança.
- [ ] Colar no final de `css/base.css` o bloco com foco visível (`:focus-visible`), `.link-pular`, `.visualmente-oculto`, `[hidden]` (com `!important`) e respeito a "menos movimento".
- [ ] Clicar numa área em branco e apertar Tab: o link "Ir para o conteúdo" deve aparecer só quando recebe o foco.
- [ ] Continuar com Tab: logotipo, menu, campos, chips e cards, cada um com contorno azul; no card, o contorno envolve o card inteiro.
- [ ] Abrir F12 > **Elements** (em português: **Elementos**), clicar no nome da loja de um card, e no painel **Styles** (em português: **Estilos**) clicar no quadradinho ao lado de `color`; ler o **Contrast ratio** (em português: **Taxa de contraste**) e conferir o ✓.
- [ ] Repetir no texto branco do botão **Entrar** e anotar os dois valores.
- [ ] Experimento 1: trocar `--cor-primaria: #8a2252;` por `#1d4e89;`, ver tudo mudar junto e voltar ao valor original.
- [ ] Experimento 2: trocar `--cor-foco: #1a5fb4;` por `#ff6600;`, apertar Tab, ver o contorno laranja e voltar ao valor original.
- [ ] Conferir a grafia idêntica de `visualmente-oculto` no HTML e no CSS e usar `:focus-visible` (não `:focus`).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D5·A13 – Tornar catálogo, loja, produto e login responsivos (mobile-first, 768 px e 1024 px)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia05-aula14-variaveis-css-hover-e-foco-visivel.md]({{URL_GUIA}}/dia05-aula14-variaveis-css-hover-e-foco-visivel.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (acessibilidade nível AA básico: foco visível, contraste, menos movimento)
