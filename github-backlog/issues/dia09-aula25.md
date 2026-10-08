**Data:** 19/10/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero criar o banco em nuvem da equipe e entender as 8 tabelas e suas ligações "1 para N", para que os dados da plataforma fiquem guardados de verdade e não somem a cada recarga.

## Critérios de aceite

- O projeto `vitrine-col` aparece ativo no painel do Supabase, sem mensagem de erro ou "projeto pausado".
- A senha do banco está guardada em lugar seguro **fora** do repositório.
- Olhando o diagrama, a equipe diz que existem 8 tabelas e o que significa `1 : N`.
- As respostas das 5 perguntas de leitura foram conferidas pela equipe (3 lojas geram 3 pedidos; um produto tem no máximo 5 fotos; apagar a loja apaga os produtos em cascata; `tamanhos` é separada de `produtos` por ser relação 1:N; `itens_pedido` liga pedidos a produtos).

## Checklist

- [ ] (Uma integrante) Entrar em https://supabase.com e clicar em **Start your project** (em português: **Comece o seu projeto**), escolher **Continue with GitHub** (em português: **Continuar com o GitHub**) e autorizar.
- [ ] Se o painel pedir, criar uma organização com o nome da equipe e escolher o plano **Free** (em português: **Gratuito**).
- [ ] Clicar em **New project** (em português: **Novo projeto**) e preencher **Name** (em português: **Nome**): `vitrine-col`.
- [ ] Em **Database Password** (em português: **Senha do banco**), clicar em **Generate a password** (em português: **Gerar uma senha**) e guardar a senha fora do repositório.
- [ ] Em **Region** (em português: **Região**), escolher **South America (São Paulo)** (em português: **América do Sul (São Paulo)**).
- [ ] Clicar em **Create new project** (em português: **Criar novo projeto**) e esperar cerca de 2 minutos até o painel carregar.
- [ ] Convidar as outras integrantes por e-mail em **Team** (em português: **Equipe**) > **Invite** (em português: **Convidar**).
- [ ] Identificar no menu da esquerda, sem modificar nada: **Table Editor** (em português: **Editor de tabelas**), **SQL Editor** (em português: **Editor SQL**), **Authentication** (em português: **Autenticação**), **Storage** (em português: **Armazenamento**) e **Project Settings** (em português: **Configurações do projeto**).
- [ ] Abrir https://supabase.com/pricing, anotar os limites do plano gratuito (cerca de 500 MB de banco, 1 GB de arquivos, poucos e-mails por hora) e a regra de pausa por falta de uso; registrar no quadro do GitHub Projects o combinado de entrar no painel toda semana.
- [ ] Ler a lista das 8 tabelas (`perfis`, `lojas`, `categorias`, `produtos`, `tamanhos`, `produto_fotos`, `pedidos`, `itens_pedido`) e o diagrama, e treinar a leitura de `lojas 1 : N produtos` e `perfis 1 : 0..1 lojas`.
- [ ] Responder às 5 perguntas de leitura no caderno e conferir com a equipe.

## Depende de

- D8·A24 – Tratar erros com try/catch e ErroApp e organizar o código em módulos

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia09-aula25-supabase-e-modelagem-do-banco.md]({{URL_GUIA}}/dia09-aula25-supabase-e-modelagem-do-banco.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-01** – Cada lojista tem no máximo uma loja.
- **RN-03** – A sacola mistura lojas; ao finalizar, sai um pedido por loja, cada um com o seu status e o mesmo código de compra (grupo_id).
- **RN-12** – Cada produto tem de 0 a 5 fotos (JPG, PNG ou WebP, até 2 MB); a primeira é a capa; sem foto aparece uma imagem padrão.

**Observação da aula:** base de RN-01, RN-03 e RN-12
