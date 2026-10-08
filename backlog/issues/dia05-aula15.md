**Data:** 13/10/2026 (terça-feira) · **Prioridade:** Essencial · **Marco:** Marco 2 · front-end estático responsivo (versão 0.1)

## User Story

Como lojista, quero as telas de cadastro, sacola, minha loja, meus produtos e formulário de produto prontas e acessíveis, para que a equipe possa ligá-las ao JavaScript e ao banco nos próximos dias.

## Critérios de aceite

- As dez páginas (`index`, `catalogo`, `loja`, `produto`, `login`, `cadastro`, `sacola`, `painel-loja`, `painel-produtos`, `painel-produto-form`) abrem pelo Live Server e são navegáveis pelo menu e pelos links.
- A tabela do `painel-produtos.html` vira blocos em 360 px e volta a ser tabela em 768 px.
- A lista de acessibilidade está toda marcada: um único `h1` por página, `alt` em toda imagem, `label` em todo campo, foco visível, `type="button"` nos botões que não enviam, preços como `R$ 129,90` e sem rolagem horizontal em 360 e 1280 px.
- `git shortlog -sn` mostra commits de todas as integrantes e a tag `v0.1` aparece no GitHub (aba **Tags**).
- **Marco 2:** front-end estático responsivo, versão 0.1.

## Checklist

- [ ] Abrir o quadro e mover as issues ligadas a RF-12, RF-15, RF-16 e RF-17 para "Em Andamento" (uma issue por dupla).
- [ ] Criar na raiz `cadastro.html`, `sacola.html`, `painel-loja.html`, `painel-produtos.html` e `painel-produto-form.html` com o conteúdo da aula; salvar com Ctrl+S (Mac: Cmd+S).
- [ ] Colar em `css/componentes.css`, logo antes de `/* ---------- Tablet ---------- */`, as seções de selos de status do pedido e de tabela.
- [ ] Colar em `css/paginas.css`, logo antes de `/* ---------- Login e cadastro ---------- */`, a seção da sacola.
- [ ] Colar em `css/paginas.css`, logo antes de `/* ---------- Tablet ---------- */`, a seção do painel da lojista.
- [ ] Colar no final de `css/paginas.css` a seção do formulário do produto.
- [ ] Abrir cada página pelo Live Server e conferir: cadastro (nome, e-mail, senha, telefone e escolha **Cliente**/**Lojista**), sacola (dois blocos de loja, subtotais, total e botão "Finalizar sacola (2 pedidos)"), painel da loja, tabela de produtos (blocos em 360 px) e formulário do produto (uma linha de tamanho e estoque, sem fotos ainda).
- [ ] Nas dez páginas, usar Ctrl+F por `<img`, `<input` e `<h1` e marcar a lista: um `h1`; `alt`; `label` com `for` e `id`; foco com Tab; `type="button"`; preços com vírgula; sem rolagem horizontal em 360 e 1280 px.
- [ ] Corrigir o que a lista apontar e comentar com a equipe.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.
- [ ] Rodar `git shortlog -sn` e conferir que todas as integrantes aparecem.
- [ ] (Só uma integrante) Criar e enviar a tag `v0.1` (`git tag v0.1` e `git push origin v0.1`); as outras conferem na aba **Tags** do GitHub.
- [ ] Mover a issue no quadro do GitHub Projects para "Em Revisão" só depois do push e da tag.

## Depende de

- D5·A14 – Fechar o base.css: foco visível, link "Ir para o conteúdo", contraste e variáveis

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia05-aula15-revisao-e-fechamento-do-front-end-estatico.md]({{URL_GUIA}}/dia05-aula15-revisao-e-fechamento-do-front-end-estatico.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-09** – Manter uma sacola com peças de várias lojas: adicionar, mudar quantidade, remover, subtotal por loja e total.
- **RF-12** – Cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional.
- **RF-15** – Permitir à lojista criar e editar a própria loja.
- **RF-16** – Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque.
- **RF-17** – Permitir à lojista editar produto.
- **RF-19** – Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar.

**Observação da aula:** só a estrutura de RF-09, RF-12, RF-15, RF-16, RF-17 e RF-19
