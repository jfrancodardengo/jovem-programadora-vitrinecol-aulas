# Aula 25 – Banco em nuvem: criar o projeto no Supabase e retomar a modelagem

**Dia 9 · Seg 19/10/2026** · **Aula 25** · **UC3**

- **Requisitos cobertos:** base de RN-01 (cada lojista tem no máximo uma loja), RN-03 (a sacola mistura lojas e gera um pedido por loja) e RN-12 (de 0 a 5 fotos por produto)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** catálogo com dados fictícios, classes e tratamento de erros (Aulas 16 a 24); uma conta no GitHub (para entrar no Supabase) e acesso à internet

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai criar o **projeto no Supabase** (o banco de dados em nuvem), conhecer os **limites do plano gratuito** e **ler o diagrama das 8 tabelas** do sistema, entendendo as ligações "1 para N".

**Abertura (10 minutos).** Retomada da Aula 24: o catálogo funciona, mas os produtos moram dentro do código (dados fictícios) e somem a cada recarga. Para a plataforma ter lojas, produtos e pedidos **de verdade**, os dados precisam ficar guardados em um **banco de dados**. Hoje preparamos esse banco. Lembre que a modelagem de banco foi vista na UC2: aqui só retomamos o que precisamos.

## O Conceito

**Termos desta aula**

- **Banco de dados**: um "armário organizado" onde o sistema guarda as informações de forma duradoura. O nosso é o **PostgreSQL**, dentro do Supabase.
- **Tabela, linha e coluna**: uma tabela é como uma planilha. Cada **coluna** é um tipo de dado (nome, preço) e cada **linha** é um registro (um produto).
- **Chave primária**: a coluna que **identifica** cada linha, sem repetição (normalmente um `id`).
- **Chave estrangeira**: uma coluna que **aponta** para a chave primária de outra tabela, ligando as duas (por exemplo, `produtos.loja_id` aponta para `lojas.id`).
- **Relacionamento 1 para N (1:N)**: uma linha de uma tabela se liga a **várias** da outra. Uma loja tem **muitos** produtos; cada produto é de **uma** loja.

**Supabase**: um serviço gratuito (até certos limites) que entrega, sem você instalar nada: o **banco PostgreSQL**, o **login** das usuárias (Authentication), o **armazenamento de arquivos** (Storage, onde ficam as fotos) e uma "porta" para o navegador conversar com tudo isso. Não existe servidor nosso: o site é só arquivos HTML, CSS e JavaScript, e o navegador fala **direto** com o Supabase.

**Analogia:** o banco é o arquivo de uma loja com várias gavetas. Cada gaveta é uma tabela (produtos, pedidos, clientes). A etiqueta com o número de cada ficha é a chave primária; o número da gaveta de outra ficha anotado na ficha é a chave estrangeira.

> **Sobre o idioma:** o painel do Supabase é todo em inglês, e a tela **não** é traduzida. Por isso os nomes dos menus e botões aparecem como na tela, seguidos da tradução em português para você entender o que clica.

## Mão na Massa

### Passo 1: crie a conta e o projeto (uma integrante da equipe)

1. Entre em https://supabase.com e clique em **Start your project** (em português: **Comece o seu projeto**). Escolha **Continue with GitHub** (em português: **Continuar com o GitHub**) e autorize.
2. Se o painel pedir, crie uma **organização** (uma "pasta" para os projetos) com o nome da equipe e escolha o plano **Free** (em português: **Gratuito**).
3. Clique em **New project** (em português: **Novo projeto**) e preencha:
   - **Name** (em português: **Nome**): `vitrine-col`.
   - **Database Password** (em português: **Senha do banco**): clique em **Generate a password** (em português: **Gerar uma senha**) e **copie e guarde** em um gerenciador de senhas ou em um arquivo seu **fora do repositório**. Essa senha **nunca** vai para o código nem para o GitHub.
   - **Region** (em português: **Região**): escolha a mais próxima do Brasil, por exemplo **South America (São Paulo)** (em português: **América do Sul (São Paulo)**).
4. Clique em **Create new project** (em português: **Criar novo projeto**) e espere uns 2 minutos, até o painel carregar.
5. Para as outras integrantes entrarem no mesmo projeto, convide-as pelo e-mail no menu da organização (procure por **Team**, em português: **Equipe**, e **Invite**, em português: **Convidar**). Se o seu painel estiver diferente, use a busca do painel.

### Passo 2: conheça o painel

No menu da esquerda, encontre (sem clicar em nada que modifique):

| No painel | Em português | Para que serve neste curso |
| --- | --- | --- |
| **Table Editor** | Editor de tabelas | ver e editar linhas como em uma planilha |
| **SQL Editor** | Editor SQL | escrever comandos para criar tabelas e consultar dados |
| **Authentication** | Autenticação | usuárias e login |
| **Storage** | Armazenamento | fotos dos produtos |
| **Project Settings** | Configurações do projeto | endereço e chaves do projeto |

### Passo 3: conheça os limites do plano gratuito

Procure na página https://supabase.com/pricing (os valores podem mudar; confira sempre a página). Em geral, o plano gratuito oferece, aproximadamente: **500 MB** de espaço de banco, **1 GB** de arquivos (fotos), um número grande de usuárias por mês e **poucos e-mails por hora** (isso importa no Dia 13, na recuperação de senha). E uma regra importante: **um projeto sem nenhum uso por cerca de uma semana é pausado**. Para a equipe não perder o projeto: **entre no painel ou rode o site pelo menos uma vez por semana**. Anote essa regra no Kanban.

### Passo 4: leia o diagrama das 8 tabelas

O sistema tem **8 tabelas**. Leia a lista e depois o desenho:

| Tabela | O que guarda |
| --- | --- |
| `perfis` | uma linha por usuária: nome, tipo (cliente ou lojista) e telefone |
| `lojas` | as lojas: nome, endereço, WhatsApp, link do mapa; uma lojista tem no máximo uma |
| `categorias` | os tipos de roupa (Blusas, Vestidos...) |
| `produtos` | os produtos de cada loja: nome, preço, ativo ou não |
| `tamanhos` | os tamanhos de cada produto, com o estoque de cada um |
| `produto_fotos` | as fotos de cada produto (até 5), com a ordem |
| `pedidos` | um pedido por loja, com status e total, ligado a quem comprou |
| `itens_pedido` | as peças de cada pedido: produto, tamanho, quantidade e preço |

```text
auth.users (login do Supabase)
     |  1 : 1
     v
  perfis ----------------------------+
     | 1 : 0..1                       | 1 : N  (cliente faz vários pedidos)
     v                                v
   lojas --- 1 : N ---> pedidos <--- (cada pedido é de uma loja)
     | 1 : N                           | 1 : N
     v                                 v
 produtos <--- N : 1 --- itens_pedido
   | 1 : N        | 1 : N
   v              v
tamanhos     produto_fotos          categorias --- 1 : N ---> produtos
```

**Como ler o "1 : N":** `lojas 1 : N produtos` = uma loja tem muitos produtos. `perfis 1 : 0..1 lojas` = uma lojista (perfil) tem **zero ou uma** loja (RN-01).

### Passo 5: responda às perguntas de leitura (em equipe)

Responda no caderno e confira com a equipe:

1. Quantos pedidos uma sacola com peças de 3 lojas gera? (Resposta: 3, um por loja, RN-03.) Em qual tabela eles ficam? (`pedidos`.) E as peças? (`itens_pedido`.)
2. Quantas fotos um produto pode ter, no máximo? (5, RN-12.) Em qual tabela elas ficam? (`produto_fotos`.)
3. Se apagarmos uma loja, o que deve acontecer com os produtos dela? (Devem sumir junto, "em cascata".)
4. Por que `tamanhos` fica separada de `produtos`? (Um produto tem vários tamanhos, cada um com o seu estoque: é uma relação 1:N.)
5. Qual tabela liga `pedidos` a `produtos`? (A tabela `itens_pedido`, que liga um pedido a vários produtos.)

## Explicação do Código

Sem código hoje, então veja o porquê das decisões:

- **Projeto na nuvem**: o banco fica nos computadores do Supabase; qualquer integrante, de qualquer lugar, usa o mesmo projeto. O site publicado também o usará.
- **Senha do banco guardada fora do código**: ela dá acesso total ao banco. No site usaremos só a chave "pública" (Aula 29) e as **regras de acesso** (Dia 13) para proteger os dados.
- **`perfis` separado de `auth.users`**: o Supabase guarda e-mail e senha em uma tabela interna (`auth.users`); a nossa tabela `perfis` guarda o que é do **nosso** sistema (nome, tipo, telefone), com o mesmo `id`.
- **`pedidos` por loja**: como cada loja confirma o seu pedido de forma independente, cada pedido tem **um** status e **uma** loja. Os pedidos da mesma compra compartilham um `grupo_id`.
- **`itens_pedido` guarda o preço**: o preço da peça é copiado no momento da compra, para um aumento de preço depois não mudar o pedido antigo (RN-06).
- **Fotos em tabela própria**: com a regra de no máximo 5 por produto, o banco conta e recusa a 6ª (Aula 26).

## Validação

1. O projeto `vitrine-col` aparece no painel do Supabase, sem mensagem de erro ou de "projeto pausado".
2. A senha do banco está guardada em lugar seguro **fora** do repositório.
3. Você consegue dizer, olhando o diagrama, quantas tabelas existem (8) e o que significa `1 : N`.
4. As respostas do Passo 5 foram conferidas pela equipe.

**Erros comuns**

1. *Sintoma:* o painel mostra "Setting up project" por muito tempo. *Causa:* a criação ainda não terminou. *Correção:* espere mais alguns minutos e recarregue a página (F5).
2. *Sintoma:* esqueci a senha do banco. *Causa:* ela não foi guardada. *Correção:* no painel, **Project Settings > Database** (em português: **Configurações do projeto > Banco de dados**) existe a opção de **Reset database password** (em português: **Redefinir a senha do banco**). Guarde a nova.
3. *Sintoma:* "Free plan limit reached" ao criar o projeto. *Causa:* a conta já tem projetos gratuitos demais. *Correção:* use um projeto já existente da equipe ou pause/apague um que não use mais.
4. *Sintoma:* a colega não vê o projeto. *Causa:* ela não foi convidada para a organização. *Correção:* convide-a pelo e-mail (Passo 1, item 5).

**Se travar**

1. Releia o passo e confira o nome exato do botão na tela (em inglês).
2. Atualize a página do painel (F5) e tente de novo.
3. Se a criação do projeto falhar, crie outro com um nome um pouco diferente (por exemplo, `vitrine-col-2`).
4. Só depois peça ajuda à sua equipe, dizendo o passo e o que apareceu na tela.

**Seu projeto agora tem**

- Nenhum arquivo novo no repositório.
- Um projeto Supabase pronto (e vazio), e a equipe sabe os limites do plano gratuito e a regra de usar o projeto toda semana.
- O diagrama das 8 tabelas entendido.

**Como saber que deu certo:** você abre o painel do Supabase, vê o seu projeto ativo e consegue explicar quais tabelas guardam pedidos e peças.
