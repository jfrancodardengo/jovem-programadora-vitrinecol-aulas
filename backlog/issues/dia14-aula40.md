**Data:** 26/10/2026 (segunda-feira) · **Prioridade:** Importante

## User Story

Como cliente, quero abrir o site e ver uma vitrine com peças em destaque, tipos de roupa e lojas parceiras, para que eu decida rápido o que olhar e chegue ao catálogo já filtrado.

## Critérios de aceite

- A página inicial (sem login) mostra hero com título e busca, carrossel com as peças recentes, tipos de roupa, produtos em destaque (os 8 ativos mais recentes com foto e estoque), lojas parceiras, "como funciona" e chamada para lojistas (RF-23).
- O carrossel troca a cada 6 segundos e também por setas **‹** e **›**, pontos, teclado (**←** e **→** com o foco nele) e arraste no celular; para com o mouse ou o foco em cima, tem botão de pausa **⏸**/**▶** (CT-19).
- Com "reduzir movimento" ligado no sistema operacional, o carrossel não troca sozinho e o botão de pausa não aparece.
- Clicar em **Vestidos** abre o catálogo já filtrado; clicar no nome de uma loja abre a página dela; digitar `vestido` no hero e clicar em **Buscar** abre o catálogo com a busca preenchida.
- Bloqueando o pedido de `lojas` na aba **Network** (em português: **Rede**), aparece mensagem de erro, mas o carrossel e os destaques continuam (RF-21); sem produtos com foto e estoque, o carrossel some e os destaques mostram "Ainda não há peças em destaque. Volte em breve!"
- Em 360 e 1280 px não há rolagem horizontal.

## Checklist

- [ ] Abrir o wireframe e o protótipo do catálogo (Aulas 4 e 5) e listar o que a vitrine precisa mostrar nos primeiros segundos.
- [ ] No `lojaServico.js`, colar a função das lojas da vitrine antes do comentário `// ---------- Páginas públicas ----------`.
- [ ] No `produtoServico.js`, colar `listarProdutosEmDestaque` antes de `obterProduto`.
- [ ] Substituir **todo** o conteúdo do `index.html` pela vitrine da aula e conferir o `<link rel="stylesheet" href="css/inicio.css">` no `<head>`, depois de `paginas.css`.
- [ ] Criar `css/inicio.css` por partes: começo e hero; carrossel; tipos de roupa, lojas, "como funciona" e chamada para lojistas; telas maiores (Tablet).
- [ ] Criar `js/ui/carrossel.js` (exporta `criarCarrossel`) e `js/paginas/inicio.js`, de modo que cada bloco carregue sozinho (se um falhar, os outros continuam).
- [ ] Abrir `index.html` sem estar logada e conferir todos os blocos.
- [ ] Testar o carrossel: troca automática, setas, pontos, teclado (Tab até o carrossel e **←**/**→**), pausa com o mouse e botão **⏸**/**▶**, arraste no modo de dispositivo do F12.
- [ ] Ligar "reduzir movimento" no sistema operacional (Windows: **Configurações > Acessibilidade > Efeitos visuais > Efeitos de animação**; Mac: **Ajustes do Sistema > Acessibilidade > Tela > Reduzir movimento**) e conferir que o carrossel não troca sozinho.
- [ ] Clicar em um tipo de roupa e em uma loja; testar a busca do hero com `vestido`.
- [ ] Na aba **Network** (em português: **Rede**) do F12, clicar com o botão direito em um pedido de `lojas`, escolher **Block request URL** (em português: **Bloquear URL do pedido**), recarregar e conferir que o carrossel e os destaques continuam; desfazer o bloqueio.
- [ ] Testar o caso sem produtos com foto e estoque.
- [ ] Conferir em 360 e 1280 px que não há rolagem horizontal e procurar `innerHTML` em `js/` (0 resultados).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D13·A39 – Proteger as telas por perfil, ligar a RLS e gravar os pedidos com a função criar_pedidos

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia14-aula40-pagina-inicial-de-vitrine.md]({{URL_GUIA}}/dia14-aula40-pagina-inicial-de-vitrine.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RF-23** – Mostrar uma página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas).
- **CT-19** – Abrir a página inicial e percorrer o carrossel; o tipo de roupa abre o catálogo filtrado.
