**Data:** 27/10/2026 (terça-feira) · **Prioridade:** Essencial · **Marco:** Marco 4 · MVP publicado (versão 0.9)

## User Story

Como aluna desenvolvedora, quero revisar o MVP com uma checklist, demonstrar o caminho do catálogo ao pedido e provar cada indicador com evidências, para que a versão 0.9 fique publicada e as pendências sigam para o Dia 26.

## Critérios de aceite

- A checklist técnica está toda marcada (ou os itens pendentes viraram issues no repositório): 0 `innerHTML` com dados, nenhuma chave `service_role`, mensagens em português e nada em branco no modo **Offline**, 360 px e 1280 px sem rolagem horizontal, `label` em todo campo e `alt` em toda imagem, valores em R$ e datas `dd/mm/aaaa`, RLS ligada nas 8 tabelas e política `dev: envio de fotos` inexistente, README completo, todas as integrantes com commits (`git shortlog -sn`).
- A demonstração completa (vitrine, filtros, produto, sacola de duas lojas, login, finalização, prova no Supabase de dois pedidos com o mesmo `grupo_id` e status `novo`, painel da lojista e bloqueio da cliente no painel) foi feita em até 8 minutos, sem erros.
- A tabela de requisitos foi preenchida ("funciona", "parcial" ou "falta") e cada "falta" ou "parcial" virou issue no repositório com prioridade (RF-11, RF-20, RF-22 e RF-25 ficam para o Dia 26).
- Cada um dos 5 indicadores tem evidência apresentada e menção registrada.
- A tag `v0.9` aparece no GitHub (**Marco 4**: MVP publicado).

## Checklist

- [ ] Abrir em abas diferentes o link público, o repositório, o Supabase e o quadro (são as evidências).
- [ ] Em dupla, conferir cada item da checklist técnica no sistema publicado e no repositório (busca com Ctrl+Shift+F; Mac: Cmd+Shift+F).
- [ ] Preparar os dados da demonstração antes: duas lojas, uma conta de cliente e produtos com fotos.
- [ ] Ensaiar o roteiro da aula, com uma integrante conduzindo e outra narrando: (1) visitante na página inicial, **Vestidos**, filtro de tamanho e busca; (2) produto, troca de foto pelo teclado, sacola agrupada por loja; (3) **Finalizar sacola**, login, volta à sacola e **Pedidos enviados**; (4) prova no Supabase (dois pedidos, mesmo `grupo_id`, status `novo`); (5) lojista: **Minha loja**, **Meus produtos**, cadastrar produto com 3 fotos, editar e desativar; (6) segurança: cliente bloqueada no painel e preço forjado recusado pelo console.
- [ ] Cronometrar a demonstração para caber em 8 minutos.
- [ ] Comparar o sistema com a lista de requisitos e escrever "funciona", "parcial" ou "falta" para RF-01 a RF-05, RF-06 e RF-07, RF-08, RF-09, RF-10, RF-12 a RF-14, RF-15 a RF-19, RF-21, RF-23 e RF-24.
- [ ] Criar uma issue no repositório, com prioridade, para cada requisito "falta" ou "parcial" (RF-11, RF-20, RF-22 e RF-25 entram no Dia 26).
- [ ] Apresentar a evidência de cada um dos 5 indicadores (ambiente de desenvolvimento; melhores práticas da linguagem; elaboração de código; compilação e depuração; integração com banco de dados) e registrar a menção.
- [ ] Se algum indicador ficar parcial ou não atendido, anotar o que falta no quadro.
- [ ] Com a `main` atualizada, rodar `git switch main`, `git pull`, `git tag v0.9` e `git push origin v0.9` (só uma integrante cria a tag).
- [ ] Conferir a tag `v0.9` na lista de tags do GitHub.

## Depende de

- D15·A44 – Escrever o README completo com diagrama ER e instruções de uso

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia15-aula45-revisao-geral-e-avaliacao-da-uc3.md]({{URL_GUIA}}/dia15-aula45-revisao-geral-e-avaliacao-da-uc3.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-02** – Filtrar o catálogo por tipo de roupa.
- **RF-03** – Filtrar o catálogo por loja.
- **RF-04** – Filtrar o catálogo por tamanho, mostrando só produtos com estoque nesse tamanho.
- **RF-05** – Buscar produtos pelo nome, sem diferenciar maiúsculas de minúsculas.
- **RF-06** – Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos.
- **RF-07** – Oferecer um botão com o link do mapa da loja.
- **RF-08** – Mostrar a página do produto com galeria de fotos, descrição, preço, loja e tamanhos, com escolha de tamanho e quantidade.
- **RF-09** – Manter uma sacola com peças de várias lojas: adicionar, mudar quantidade, remover, subtotal por loja e total.
- **RF-10** – Finalizar a sacola de uma cliente logada, gravando um pedido por loja e mostrando um botão de WhatsApp por loja.
- **RF-12** – Cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.
- **RF-14** – Controlar o acesso às telas conforme o perfil (cliente, lojista ou visitante).
- **RF-15** – Permitir à lojista criar e editar a própria loja.
- **RF-16** – Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque.
- **RF-17** – Permitir à lojista editar produto.
- **RF-18** – Permitir à lojista desativar ou excluir produto.
- **RF-19** – Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar.
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RF-23** – Mostrar uma página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas).
- **RF-24** – Permitir recuperar a senha por e-mail.

**Observação da aula:** revisão de RF-01 a RF-10, RF-12 a RF-19, RF-21, RF-23 e RF-24

**Outros requisitos e testes citados nesta issue:**

- **RF-11** – Mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja.
- **RF-20** – Mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado.
- **RF-22** – Avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado.
- **RF-25** – Permitir à usuária excluir a própria conta.
