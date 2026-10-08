**Data:** 08/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero percorrer catálogo, produto, loja e login só clicando, para que eu encontre uma peça e saiba de qual loja ela é.

## Critérios de aceite

- As quatro páginas (`catalogo.html`, `loja.html`, `produto.html`, `login.html`) abrem pelo Live Server.
- O caminho do Passo 5 (Catálogo → Produto → Loja → início → Entrar) funciona só com cliques.
- O catálogo mostra 3 cards, a loja mostra 2 e o produto mostra 3 miniaturas e 3 tamanhos (o G desabilitado).
- Toda imagem tem `alt` e todo campo tem `label` (busca com Ctrl+F por `<img` e `<input`).
- O Outline do VS Code mostra um `h1` em cada página.

## Checklist

- [ ] Criar as seis imagens `imagens/exemplo-1.svg` a `imagens/exemplo-6.svg` (uma "camiseta" de cada cor), com os nomes idênticos aos do HTML.
- [ ] No `catalogo.html`, trocar a linha `<ul class="grade-produtos" id="lista-produtos"></ul>` pela lista com três cards.
- [ ] Criar `loja.html` na raiz com o conteúdo da aula (nome, descrição, endereço, botões e dois produtos).
- [ ] Criar `produto.html` na raiz com o conteúdo da aula (foto, miniaturas, preço, loja, descrição, tamanhos, quantidade e botão); conferir que os três botões de tamanho têm o mesmo `name="tamanho"`.
- [ ] Conferir cada página contra o protótipo do Figma (Aula 5).
- [ ] Percorrer o caminho só com cliques: menu **Catálogo** > nome do produto > **Loja Exemplo** > produto > logotipo **VitrineCol** > **Entrar**.
- [ ] Se aparecer "Cannot GET /produto.html", conferir que o arquivo está na raiz, junto do `index.html`.
- [ ] Se uma imagem quebrar, abrir F12 > **Network** (em português: **Rede**) e procurar o erro 404.
- [ ] Confirmar que o cabeçalho não foi colado duas vezes (menu duplicado).
- [ ] Conferir `alt` em toda imagem e `label` em todo campo; abrir o Outline e ver um `h1` por página.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D3·A8 – Criar login.html e catalogo.html com listas e formulários rotulados

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia03-aula09-montagem-das-paginas-do-projeto-em-html.md]({{URL_GUIA}}/dia03-aula09-montagem-das-paginas-do-projeto-em-html.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-06** – Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos.
- **RF-08** – Mostrar a página do produto com galeria de fotos, descrição, preço, loja e tamanhos, com escolha de tamanho e quantidade.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.

**Observação da aula:** só a estrutura de RF-01, RF-06, RF-08 e RF-13
