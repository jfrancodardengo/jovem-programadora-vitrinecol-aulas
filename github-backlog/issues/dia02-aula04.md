**Data:** 07/10/2026 (quarta-feira) · **Prioridade:** Importante

## User Story

Como aluna desenvolvedora, quero desenhar em baixa fidelidade as quatro telas-chave e o caminho do catálogo até o pedido, para que a equipe combine como as telas serão antes de escrever mais código.

## Critérios de aceite

- Existe um wireframe de cada uma das 4 telas (catálogo, loja, produto, login), com todos os campos e botões escritos.
- Há um desenho do caminho com setas, do catálogo até o WhatsApp, com no máximo 6 ações da cliente.
- Outra equipe respondeu às 5 perguntas de revisão e a equipe anotou os ajustes.
- As fotos dos wireframes estão salvas em uma pasta que toda a equipe acessa.

## Checklist

- [ ] Pegar 4 folhas (ou 4 áreas de desenho) e escrever no topo: Catálogo, Loja, Produto, Login. Desenhar em formato de celular (retângulo alto, cerca de 9 cm por 16 cm).
- [ ] Combinar as convenções: retângulo com "X" = foto; linhas onduladas = texto; retângulo com texto = botão; retângulo vazio = campo de digitar.
- [ ] Desenhar o Catálogo (RF-01 a RF-04): cabeçalho, filtros por tipo, loja e tamanho, cards de produto e botão "Carregar mais produtos".
- [ ] Desenhar a Loja: nome, descrição, endereço, botões "Conversar no WhatsApp" e "Ver no mapa" e os cards dos produtos da loja.
- [ ] Desenhar o Produto: foto grande, faixa de miniaturas, preço, "Vendido por [loja]", descrição, botões de tamanho (um deles "sem estoque"), campo de quantidade e botão "Adicionar à sacola".
- [ ] Desenhar o Login: título "Entrar", campos E-mail e Senha, botão "Entrar" e links "Esqueci minha senha" e "Ainda não tem conta? Cadastre-se".
- [ ] Usar setas para indicar "esta imagem leva a esta tela" (o card leva ao Produto; o nome da loja leva à Loja).
- [ ] Em uma folha à parte, desenhar o caminho Catálogo → Produto → Sacola → (se não estiver logada) Login → Pedidos enviados → WhatsApp.
- [ ] Contar as ações da cliente (clicar no produto, escolher tamanho, Adicionar à sacola, abrir a Sacola, Finalizar sacola, botão do WhatsApp) e simplificar se passar de 6.
- [ ] Trocar os rascunhos com outra equipe e pedir que responda, sem explicação: qual é o botão principal de cada tela? Dá para saber de qual loja é cada produto? Dá para voltar ao catálogo de qualquer tela? O que aparece se a lista estiver vazia? O caminho passa de 6 ações?
- [ ] Ajustar os desenhos com as respostas, tirar uma foto de cada wireframe final com o celular e guardar na pasta compartilhada.

## Depende de

- D1·A3 – Criar a primeira página HTML e abrir com o Live Server

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia02-aula04-wireframes-das-telas-chave.md]({{URL_GUIA}}/dia02-aula04-wireframes-das-telas-chave.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-06** – Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos.
- **RF-08** – Mostrar a página do produto com galeria de fotos, descrição, preço, loja e tamanhos, com escolha de tamanho e quantidade.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.

**Observação da aula:** Não se aplica (planejamento das telas; prepara RF-01, RF-06, RF-08 e RF-13)

**Outros requisitos e testes citados nesta issue:**

- **RF-02** – Filtrar o catálogo por tipo de roupa.
- **RF-03** – Filtrar o catálogo por loja.
- **RF-04** – Filtrar o catálogo por tamanho, mostrando só produtos com estoque nesse tamanho.
