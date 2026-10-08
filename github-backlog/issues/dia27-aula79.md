**Data:** 13/11/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero executar todos os casos de teste (CT-01 a CT-25) no site publicado e ter um roteiro de usabilidade pronto, para que a equipe saiba o que funciona de verdade antes de chamar usuárias externas.

## Critérios de aceite

- Os dados de teste estão preparados no site publicado: duas lojas de duas lojistas diferentes (cada uma com WhatsApp e pelo menos 2 produtos ativos com fotos, um deles com um tamanho de estoque 0), 13 ou mais produtos ativos, uma conta de cliente, uma de lojista com pedido recebido e uma conta só para o teste de exclusão.
- **Todos** os 25 casos do `docs/TESTES.md` têm `OK` ou `FALHOU` (nenhum `N/A`) e cada `FALHOU` tem uma observação; o quadro do topo (versão testada, endereço, data, aparelho, quem testou) está preenchido e a tabela **Resumo** está contada.
- A decisão sobre **Confirm email** (em português: **Confirmar e-mail**) e o limite de e-mails por hora foram conferidos no Supabase e registrados.
- O roteiro de usabilidade (tarefa lida em voz alta, tabela de observação e 3 perguntas finais) está pronto; a meta é que uma cliente nova vá do catálogo ao pedido em até 6 ações por loja.

## Checklist

- [ ] Conferir no site **publicado** os dados de teste: duas lojas, 13 ou mais produtos ativos, cliente (de preferência com telefone), lojista com pelo menos um pedido recebido e uma conta só para o teste de exclusão (de preferência lojista com loja, produto e foto).
- [ ] Conferir em **Authentication** (em português: **Autenticação**) > **URL Configuration** (em português: **Configuração de URL**) que o endereço de `recuperar-senha.html` do site publicado está liberado (CT-23).
- [ ] Abrir o `docs/TESTES.md`, o site publicado e o Supabase em abas separadas e dividir os casos entre as duplas.
- [ ] Preencher o quadro do topo do `TESTES.md` (versão testada, endereço, data, navegador e aparelho, quem testou).
- [ ] Executar CT-01 a CT-10 e escrever `OK` ou `FALHOU` (com observação) na coluna **Resultado**.
- [ ] Executar CT-11 a CT-16, usando os roteiros do console do `TESTES.md` para CT-11 (F12 > **Console**, trocando só os ids em MAIÚSCULAS).
- [ ] Executar CT-17 (lojista confirma o pedido com recado; cliente vê o contador, **Atualizado**, o status e o recado) e CT-18 a CT-21 com os roteiros do console.
- [ ] Executar CT-22 (12 produtos, botão **Carregar mais produtos** sem repetir), CT-23 (recuperação de senha), CT-24 (exclusão da conta de teste) e CT-25 (foto grande com cerca de 200 KB no Storage).
- [ ] Se sobrar algum `N/A`, preparar os dados que faltam e executar o caso de novo.
- [ ] Contar `OK`, `FALHOU` e `N/A` e preencher a tabela **Resumo**.
- [ ] No Supabase, abrir **Authentication** (em português: **Autenticação**) > **Providers** (em português: **Provedores**) > **Email** (em português: **E-mail**) e olhar **Confirm email** (em português: **Confirmar e-mail**); se for ligar, testar antes com um e-mail que não seja da equipe e, se o e-mail não chegar, deixar desligada e registrar o risco.
- [ ] Procurar a página de limites (**Rate Limits**, em português: **Limites de taxa**) dentro de **Authentication** e anotar quantos e-mails por hora o projeto aceita.
- [ ] Escrever o roteiro de usabilidade em um arquivo ou folha da equipe: a tarefa ("Você quer comprar um vestido e uma camiseta de duas lojas diferentes. Escolha as peças, junte tudo e faça o pedido. Fale em voz alta o que está pensando."), a tabela de observação (usuária, aparelho, tempo, ações, onde hesitou, erros, se concluiu sozinha, comentário) e as 3 perguntas finais (o que foi mais fácil, o que foi confuso, o que mudaria).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D26·A78 – Criar Minha conta com exclusão da própria conta (EXCLUIR)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia27-aula79-plano-de-testes-e-roteiro-de-usabilidade.md]({{URL_GUIA}}/dia27-aula79-plano-de-testes-e-roteiro-de-usabilidade.md)

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
- **RF-11** – Mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja.
- **RF-12** – Cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.
- **RF-14** – Controlar o acesso às telas conforme o perfil (cliente, lojista ou visitante).
- **RF-15** – Permitir à lojista criar e editar a própria loja.
- **RF-16** – Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque.
- **RF-17** – Permitir à lojista editar produto.
- **RF-18** – Permitir à lojista desativar ou excluir produto.
- **RF-19** – Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar.
- **RF-20** – Mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado.
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
- **RF-22** – Avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado.
- **RF-23** – Mostrar uma página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas).
- **RF-24** – Permitir recuperar a senha por e-mail.
- **RF-25** – Permitir à usuária excluir a própria conta.
- **CT-01 a CT-25** – os 25 casos de teste do sistema (abrir o catálogo, filtrar, montar a sacola, finalizar pedido, entrar, sair, tentar acessos indevidos, trocar de tela, recuperar senha e excluir conta)

**Observação da aula:** CT-01 a CT-25 (verificação de RF-01 a RF-25)
