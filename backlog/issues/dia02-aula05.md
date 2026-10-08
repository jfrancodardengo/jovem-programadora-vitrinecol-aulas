**Data:** 07/10/2026 (quarta-feira) · **Prioridade:** Importante

## User Story

Como aluna desenvolvedora, quero um protótipo clicável das telas no Figma, para que a equipe e outras pessoas testem o caminho catálogo, produto e sacola antes da programação.

## Critérios de aceite

- O arquivo do Figma tem 3 quadros nomeados (Catálogo, Produto, Sacola) e pelo menos 2 componentes (cabeçalho e card de produto).
- No modo **Present** (em português: **Apresentar**), os cliques levam Catálogo → Produto → Sacola → Catálogo.
- Uma colega concluiu a tarefa "escolha uma peça e finalize a sacola" sem ajuda, e a equipe anotou pelo menos um ajuste.
- O link de visualização do protótipo está no `README.md` ou no quadro, e abre sem pedir login.

## Checklist

- [ ] Entrar no Figma (https://www.figma.com) e criar um arquivo: **New design file** (em português: **Novo arquivo de design**), com o nome `VitrineCol – protótipo`.
- [ ] Escolher a ferramenta **Frame** (em português: **Quadro**; tecla F) e, no painel da direita, o tamanho **Phone** (em português: **Celular**).
- [ ] Criar três quadros lado a lado e renomeá-los: `Catálogo`, `Produto` e `Sacola`.
- [ ] No quadro Catálogo, desenhar o cabeçalho com **Rectangle** (em português: **Retângulo**; tecla R) e **Text** (em português: **Texto**; tecla T): "VitrineCol" e os links "Início", "Catálogo" e "Sacola".
- [ ] Transformar o cabeçalho em componente: botão direito > **Create component** (em português: **Criar componente**; Windows: Ctrl+Alt+K; Mac: Cmd+Option+K). Copiar e colar nos quadros Produto e Sacola.
- [ ] Desenhar o card de produto (retângulo da foto com um X, três linhas: nome, preço e loja), transformá-lo em componente e colocar quatro cópias no Catálogo, em duas colunas.
- [ ] Completar o quadro Produto: foto grande, preço, botões de tamanho (P, M, G), campo de quantidade e botão "Adicionar à sacola".
- [ ] Completar o quadro Sacola: título "Sacola", blocos "Loja A" e "Loja B" (cada um com um item e o subtotal), "Total" e botão "Finalizar sacola".
- [ ] Abrir a aba **Prototype** (em português: **Protótipo**) e ligar o primeiro card ao quadro Produto (**On click**, em português: **Ao clicar**; **Navigate to**, em português: **Navegar para**).
- [ ] Ligar "Adicionar à sacola" ao quadro Sacola e "Finalizar sacola" de volta ao Catálogo.
- [ ] Testar com o botão **Present** (em português: **Apresentar**; o triângulo no canto superior direito) e sair com Esc.
- [ ] Em **Share** (em português: **Compartilhar**), permitir que "qualquer pessoa com o link" possa **view** (em português: **visualizar**) e enviar o link a uma colega.
- [ ] Pedir à colega, sem ajudar, que cumpra a tarefa; anotar onde hesitou e corrigir o protótipo.
- [ ] Colar o link do protótipo no `README.md` ou no quadro, para a equipe achar depois.

## Depende de

- D2·A4 – Desenhar os wireframes do Catálogo, da Loja, do Produto e do Login

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia02-aula05-prototipo-navegavel-no-figma.md]({{URL_GUIA}}/dia02-aula05-prototipo-navegavel-no-figma.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (planejamento das telas)
