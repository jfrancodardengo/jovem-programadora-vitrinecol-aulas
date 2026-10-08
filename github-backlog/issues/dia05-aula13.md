**Data:** 13/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero usar o catálogo, a loja, o produto e o login bem no celular, no tablet e no computador, para que eu navegue sem rolagem horizontal em qualquer tela.

## Critérios de aceite

- Em 360, 768 e 1280 px, nenhuma das quatro páginas tem rolagem horizontal.
- O catálogo tem 1 coluna (360 px), 2 colunas (768 px) e 3 ou 4 colunas (1280 px).
- A página do produto mostra foto e informações lado a lado a partir de 768 px.
- O login aparece como um cartão centralizado.
- As cinco páginas têm a linha `<meta name="viewport" ...>` no `<head>`.

## Checklist

- [ ] Abrir o `catalogo.html` no Live Server, apertar F12 e clicar em **Toggle device toolbar** (em português: **Alternar barra de ferramentas do dispositivo**; atalho Ctrl+Shift+M, Mac: Cmd+Shift+M).
- [ ] Na barra **Dimensions** (em português: **Dimensões**; ou **Responsive**, em português: **Responsivo**), digitar as larguras 360, 768 e 1280.
- [ ] Colar no final de `css/paginas.css` os estilos da loja, do produto (galeria com miniaturas) e do login.
- [ ] Colar no final de `css/componentes.css` as media queries (seções Tablet e Desktop).
- [ ] Colar no final de `css/paginas.css` as media queries (seção Tablet).
- [ ] Conferir que cada `@media` vem depois das regras que modifica e que todas as chaves `}` estão fechadas.
- [ ] Testar `catalogo.html`, `loja.html`, `produto.html` e `login.html` em 360, 768 e 1280 px, conferindo a tabela da aula (uma coluna a 360; 2 colunas e filtros em 3 colunas a 768; 3 ou 4 colunas e conteúdo centralizado a 1280).
- [ ] Se aparecer rolagem horizontal em 360 px, abrir **Elements** (em português: **Elementos**), achar o elemento que passa da borda e trocar a largura fixa por `max-width: 100%`.
- [ ] Conferir o `<meta name="viewport" ...>` nas cinco páginas.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D4·A12 – Criar o card de produto com Grid e estilizar o catálogo (paginas.css)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia05-aula13-responsividade-mobile-first.md]({{URL_GUIA}}/dia05-aula13-responsividade-mobile-first.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (tela funcionando de 360 px a 1280 px, sem rolagem horizontal)
