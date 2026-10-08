**Data:** 26/10/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero testar o fluxo completo e registrar o resultado de cada caso, para que a equipe saiba o que funciona e o que precisa ser corrigido antes de publicar.

## Critérios de aceite

- A equipe usou as abas **Console**, **Network** (em português: **Rede**) e **Elements** (em português: **Elementos**) e simulou **Offline**, vendo mensagem em português e nenhuma tela em branco (CT-15).
- `docs/TESTES.md` existe, com a coluna **Resultado** preenchida (`OK`, `FALHOU` ou `N/A`) nos 25 casos; CT-17, CT-18, CT-20 e CT-24 estão como `N/A`.
- Cada caso `FALHOU` tem explicação em **Observações** e uma issue de defeito no repositório, com gravidade (crítico, importante ou desejável).
- O CT-12 foi feito: o nome `<img src=x onerror=alert(1)>` aparece como texto, sem alerta, no catálogo, no produto e na sacola.
- A tabela **Resumo** do arquivo mostra o total de `OK`, `FALHOU` e `N/A`.

## Checklist

- [ ] Abrir o catálogo e apertar F12 (Mac: Cmd+Option+I); no **Console**, digitar `1 + 1`; em **Elements** (em português: **Elementos**), clicar no ícone de seta e em um card, e mudar o preço de teste; em **Network** (em português: **Rede**), recarregar e olhar status 200 e 404, **Headers** (em português: **Cabeçalhos**) e **Response** (em português: **Resposta**).
- [ ] Simular falha de conexão: trocar **No throttling** por **Offline**, recarregar o catálogo e trocar um filtro; voltar para **No throttling**.
- [ ] Criar a pasta `docs` (se não existir) e o arquivo `docs/TESTES.md` com o conteúdo da aula.
- [ ] Combinar as duplas e dividir os casos (por exemplo, CT-01 a CT-08, CT-09 a CT-16 e CT-17 a CT-25).
- [ ] Preencher o quadro do topo do `TESTES.md` (versão testada, endereço do site, data, navegador e quem testou).
- [ ] Em cada caso, uma pessoa executa e a outra observa e anota; trocar de papel a cada caso.
- [ ] Marcar `N/A` nos casos CT-17, CT-18, CT-20 e CT-24 (dependem do Dia 26); para o CT-22, criar produtos de teste ou marcar `N/A`; para o CT-23, usar o e-mail de um membro da organização do Supabase.
- [ ] Fazer o CT-12: cadastrar o produto com o nome `<img src=x onerror=alert(1)>`, olhar o catálogo, o produto e a sacola, e depois apagar o produto.
- [ ] Fazer os CT-13 e CT-14 com **Toggle device toolbar** (em português: **Alternar barra de ferramentas do dispositivo**) em 360 e 1280 px, e o fluxo de pedido só com o teclado.
- [ ] Fazer pelo Console os roteiros de acesso indevido do `TESTES.md` (CT-11 e CT-21), copiando o roteiro exatamente.
- [ ] Para cada caso `FALHOU`, criar uma issue "Defeito: [tela] [o que aconteceu]" com caso de teste, tela e passo, o que aconteceu, o que era esperado e gravidade.
- [ ] Contar `OK`, `FALHOU` e `N/A` e preencher a tabela **Resumo**.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D14·A40 – Construir a página inicial de vitrine com hero, carrossel, tipos de roupa, destaques e lojas

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia14-aula41-depuracao-e-casos-de-teste.md]({{URL_GUIA}}/dia14-aula41-depuracao-e-casos-de-teste.md)

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
- **RF-18** – Permitir à lojista desativar ou excluir produto.
- **RF-19** – Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar.
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RF-23** – Mostrar uma página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas).
- **RF-24** – Permitir recuperar a senha por e-mail.
- **CT-01 a CT-25** – os 25 casos de teste do sistema (abrir o catálogo, filtrar, montar a sacola, finalizar pedido, entrar, sair, tentar acessos indevidos, trocar de tela, recuperar senha e excluir conta)

**Observação da aula:** verificação de RF-01 a RF-10, RF-12 a RF-16, RF-18, RF-19, RF-21, RF-23 e RF-24 (CT-01 a CT-25)

**Outros requisitos e testes citados nesta issue:**

- **CT-01** – Abrir o catálogo sem login e ver os produtos ativos.
- **CT-02** – Filtrar por tipo de roupa e por loja.
- **CT-03** – Filtrar por tamanho sem estoque.
- **CT-04** – Adicionar produtos de duas lojas à sacola.
- **CT-05** – Recarregar a página e manter a sacola.
- **CT-06** – Tentar finalizar sem estar logada e voltar à sacola depois do login.
- **CT-07** – Finalizar logada com peças de duas lojas: dois pedidos com o mesmo código de compra e um botão de WhatsApp por loja.
- **CT-08** – Cadastrar com e-mail repetido e ver mensagem de erro clara.
- **CT-09** – Cliente tenta abrir uma tela do painel e é bloqueada.
- **CT-10** – Lojista cadastra produto com 3 fotos; a primeira é a capa.
- **CT-11** – Lojista tenta editar o produto de outra loja pelo console e o banco recusa.
- **CT-12** – Digitar um script em um campo de texto e ele aparecer como texto, sem executar.
- **CT-13** – Abrir as telas em 360 px e em 1280 px sem rolagem horizontal.
- **CT-14** – Percorrer o fluxo de pedido só com o teclado, com foco visível.
- **CT-15** – Simular falha de conexão e ver mensagem em português, sem tela em branco.
- **CT-16** – Enviar a 6ª foto ou um arquivo maior que 2 MB e o sistema recusar com mensagem clara.
- **CT-17** – Lojista confirma um pedido e a cliente vê o contador, o selo "Atualizado", o status e o recado.
- **CT-18** – Lojista tenta alterar o total de um pedido pelo console e o banco recusa.
- **CT-19** – Abrir a página inicial e percorrer o carrossel; o tipo de roupa abre o catálogo filtrado.
- **CT-20** – Lojista tenta pular uma etapa do status ou mexer no aviso da cliente pelo console e o banco recusa.
- **CT-21** – Cliente tenta gravar pedido com preço forjado ou direto na tabela e o banco recusa.
- **CT-22** – Abrir o catálogo com mais de 12 produtos e usar "Carregar mais produtos", sem repetir nenhum.
- **CT-23** – Recuperar a senha pelo link do e-mail; a nova senha vale e a antiga não.
- **CT-24** – Excluir a própria conta; a conta e os dados somem e não dá mais para entrar.
- **CT-25** – Enviar uma foto grande e conferir que o arquivo guardado tem cerca de 200 KB.
