**Data:** 09/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero um cabeçalho com menu em linha, botões e campos de formulário bem alinhados, para que eu navegue e preencha formulários sem me perder.

## Critérios de aceite

- O cabeçalho mostra o logotipo à esquerda e o menu à direita; em janela estreita, o menu quebra de linha sem rolagem horizontal.
- Os botões têm cor, cantos arredondados, altura mínima de 44 px e escurecem ao passar o mouse.
- No `login.html`, cada rótulo fica acima do seu campo; no `catalogo.html`, os chips ficam em linha e o chip "Todas" fica destacado.
- A caixa de aviso vermelha de teste apareceu e foi removida do `login.html`.

## Checklist

- [ ] Criar `css/componentes.css` com as seções de cabeçalho/menu e de rodapé (Flexbox).
- [ ] Colar `<link rel="stylesheet" href="css/componentes.css">` no `<head>` das cinco páginas, depois do `base.css` (ordem: variáveis, base, componentes).
- [ ] Diminuir a janela do navegador e conferir que o menu quebra de linha sem estourar a tela.
- [ ] Acrescentar no final do arquivo a seção de botões; conferir o botão **Entrar** e os botões da loja e passar o mouse sobre eles.
- [ ] Acrescentar a seção de campos de formulário; conferir o `login.html`, o `catalogo.html` e os botões de tamanho do produto.
- [ ] Acrescentar a seção de avisos e chips; conferir os chips do catálogo em "pílulas".
- [ ] Colar temporariamente `<p class="aviso aviso-erro" role="alert">E-mail ou senha incorretos.</p>` abaixo do `<h1>Entrar</h1>`, ver a caixa vermelha e apagar a linha.
- [ ] Se o menu continuar em coluna, conferir que o `display: flex` está no `ul` (`.menu`) e não no `li` ou no `a`.
- [ ] Conferir que o botão do login tem `class="botao"`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D4·A10 – Criar css/variaveis.css e css/base.css e ligar às cinco páginas

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia04-aula11-layout-com-flexbox.md]({{URL_GUIA}}/dia04-aula11-layout-com-flexbox.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (apresentação visual das telas)
