# Aula 1 – Backlog do MVP a partir das personas e formação das equipes

**Dia 1 · Ter 06/10/2026** · **Aula 1** · **UC3**

- **Requisitos cobertos:** visão geral dos 25 requisitos funcionais (RF-01 a RF-25), só leitura: nesta aula você apenas lê e prioriza a lista, sem programar nada
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** nenhum arquivo ainda. Você só precisa de um editor de texto ou de uma planilha para anotar (Google Docs, Google Planilhas, Word, Excel ou o Bloco de Notas)

> Esta é a primeira aula do curso, então não existe aula anterior para refazer. Se algum passo ficar incompleto, termine-o em casa antes da Aula 2.

## Objetivo da aula

Em 60 minutos você vai transformar um problema e duas personas em uma **lista priorizada de funcionalidades** (o backlog do MVP) e combinar com a sua equipe quem faz o quê.

**Abertura (10 minutos).** Como esta é a primeira aula de programação do projeto, a "retomada" é sobre o que você já conhece: nas aulas anteriores do curso a turma definiu o problema (as lojas de roupa do bairro vendem pouco pela internet e as clientes não conseguem comparar peças de lojas diferentes) e as personas. Leia o resumo abaixo em voz alta com a sua equipe e confirme que todas entendem o que será construído.

> **O produto, em uma frase:** uma plataforma web de moda local em que a cliente filtra roupas por tipo, tamanho e loja, junta peças de lojas diferentes na mesma sacola e faz um pedido por loja, combinado pelo WhatsApp; a lojista cadastra a loja e os produtos (até 5 fotos cada) e responde os pedidos.

Ao final você terá: (1) o backlog dos 25 requisitos com prioridade, (2) a equipe formada com papéis combinados e (3) um combinado de como a equipe vai trabalhar.

## O Conceito

**Termos desta aula**

- **Persona**: uma pessoa inventada, mas parecida com quem vai usar o sistema, com nome, rotina e necessidades. Ajuda a pensar "o que a Marina precisa?" em vez de "o que eu acho legal?".
- **Backlog**: a lista de tudo o que o sistema precisa fazer, em ordem de importância. É a "lista de compras" do projeto.
- **Requisito funcional (RF)**: uma frase que diz o que o sistema deve fazer, por exemplo "listar os produtos em cards". Neste curso cada um tem um código: RF-01, RF-02 e assim por diante.
- **MVP**: a menor versão do sistema que já entrega o fluxo completo de ponta a ponta (aqui: escolher peças, montar a sacola e fazer o pedido). Funcionalidades que não são indispensáveis ficam para depois.

**Por que começar por uma lista?** Pense em fazer uma viagem: antes de arrumar a mala você decide o destino e anota o que não pode faltar. Um projeto de software é igual: sem lista, a equipe gasta o tempo em detalhes bonitos e esquece o essencial. Com a lista priorizada, quando o tempo apertar você já sabe o que pode ficar de fora.

**Três níveis de prioridade** usados neste curso:

| Prioridade | Significa | Se faltar tempo |
| --- | --- | --- |
| **Essencial** | sem isso o sistema não funciona (não existe MVP) | nunca sai |
| **Importante** | melhora muito a experiência | fica pronto ou é registrado como "fora do escopo" |
| **Desejável** | é bom ter, mas o sistema funciona sem | é o primeiro a sair |

## Mão na Massa

### Passo 1: leia o problema e as duas personas (10 minutos)

Se a sua equipe já tem personas feitas nas aulas anteriores, use as suas. Se não tiver, use estas duas:

- **Marina, 22 anos, estudante.** Gosta de moda, mas não tem tempo de andar por várias lojas. Quer ver o que cada loja do bairro tem, comparar preços, separar as peças e combinar a retirada pelo WhatsApp, que ela já usa todo dia. Mexe pouco no computador e usa muito o celular.
- **Dona Célia, 48 anos, dona de uma loja de roupas.** Vende só no balcão e no Instagram. Quer mostrar os produtos com várias fotos, controlar o estoque por tamanho e receber os pedidos de forma organizada, sem perder mensagens. Precisa de telas simples, com poucos botões.

### Passo 2: transforme necessidades em funcionalidades (15 minutos)

Em equipe, complete cada frase abaixo no formato **"Como [persona], quero [o quê], para [por quê]"**. Escreva pelo menos 6 frases. Exemplos para você começar:

1. Como **Marina**, quero filtrar as roupas por tipo, tamanho e loja, para achar rápido o que combina comigo.
2. Como **Marina**, quero juntar peças de lojas diferentes na mesma sacola, para fazer a compra de uma vez.
3. Como **Dona Célia**, quero cadastrar a minha loja e os meus produtos com fotos, para as clientes verem o que eu vendo.
4. Como **Dona Célia**, quero ver os pedidos que chegaram e avisar a cliente quando eu confirmar, para ela saber o que está acontecendo.

Acrescente as suas próprias frases (por exemplo: recuperar a senha esquecida, ver a loja no mapa, apagar a própria conta).

### Passo 3: compare com a lista oficial dos 25 requisitos (15 minutos)

Abaixo está a lista que vamos construir durante o curso. Copie a tabela para o seu documento e **marque ao lado de cada linha qual frase do Passo 2 ela atende**. Se alguma frase sua não aparecer na lista, anote como "ideia para depois": ela não entra no MVP.

| Código | O sistema deve | Prioridade |
| --- | --- | --- |
| RF-01 | Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos" | Essencial |
| RF-02 | Filtrar o catálogo por tipo de roupa | Essencial |
| RF-03 | Filtrar o catálogo por loja | Essencial |
| RF-04 | Filtrar o catálogo por tamanho, mostrando só produtos com estoque nesse tamanho | Importante |
| RF-05 | Buscar produtos pelo nome, sem diferenciar maiúsculas de minúsculas | Desejável |
| RF-06 | Mostrar a página da loja com nome, descrição, endereço, WhatsApp e produtos | Essencial |
| RF-07 | Oferecer um botão com o link do mapa da loja | Desejável |
| RF-08 | Mostrar a página do produto com galeria de fotos, descrição, preço, loja e tamanhos, com escolha de tamanho e quantidade | Essencial |
| RF-09 | Manter uma sacola com peças de várias lojas: adicionar, mudar quantidade, remover, subtotal por loja e total | Essencial |
| RF-10 | Finalizar a sacola de uma cliente logada, gravando um pedido por loja e mostrando um botão de WhatsApp por loja | Essencial |
| RF-11 | Mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja | Importante |
| RF-12 | Cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional | Essencial |
| RF-13 | Permitir entrar e sair da conta, mantendo a sessão | Essencial |
| RF-14 | Controlar o acesso às telas conforme o perfil (cliente, lojista ou visitante) | Essencial |
| RF-15 | Permitir à lojista criar e editar a própria loja | Essencial |
| RF-16 | Permitir à lojista cadastrar produto com nome, descrição, categoria, preço e tamanhos com estoque | Essencial |
| RF-17 | Permitir à lojista editar produto | Essencial |
| RF-18 | Permitir à lojista desativar ou excluir produto | Essencial |
| RF-19 | Enviar até 5 fotos por produto (JPG, PNG ou WebP, até 2 MB), escolher a capa e reordenar | Importante |
| RF-20 | Mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado | Importante |
| RF-21 | Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco | Essencial |
| RF-22 | Avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado | Importante |
| RF-23 | Mostrar uma página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas) | Importante |
| RF-24 | Permitir recuperar a senha por e-mail | Importante |
| RF-25 | Permitir à usuária excluir a própria conta | Importante |

Quando todas as linhas estiverem conferidas, a equipe responde em voz alta: **"Se faltar tempo, o que sai primeiro?"** A resposta combinada para o curso é, nesta ordem: (1) o link do mapa da loja, (2) o carrossel da página inicial e a reordenação das fotos, (3) o filtro por tamanho, (4) o envio de fotos pelo sistema.

### Passo 4: forme a equipe e combine os papéis (10 minutos)

Cada equipe tem de 4 a 5 pessoas. Existem cinco papéis, que **rodam** ao longo do curso para todas aprenderem um pouco de cada área:

| Papel | O que faz |
| --- | --- |
| Produto/negócio | Cuida do backlog e das prioridades; decide o que entra e o que sai |
| UX/UI | Cuida das telas, das cores e da facilidade de uso |
| Front-end | Escreve o HTML, o CSS e o JavaScript das telas |
| Banco/back-end | Cuida das tabelas, das regras de acesso e da ligação com o Supabase |
| Conteúdo/QA | Cuida dos textos, das fotos e dos testes |

Anote em uma tabela quem assume cada papel **nesta semana** e quando o papel muda (sugestão: troca a cada dia de aula). Em programação, **todas escrevem código**: o papel só diz quem "puxa" a conversa daquela área. Combine também que as duplas de trabalho se alternam (uma digita, outra confere).

### Passo 5: combinados da equipe (5 minutos)

Escreva no documento, em poucas linhas: como a equipe se comunica (grupo de mensagens), em que horário se encontra fora da aula, e que **ninguém fica com dúvida sozinha por mais de 15 minutos**: pede ajuda à equipe.

## Explicação do Código

Esta aula não tem código, então aqui explicamos cada decisão:

- **Por que usar personas?** Elas obrigam a equipe a pensar em pessoas reais. A Marina usa o celular; por isso, no Dia 5, as telas serão feitas primeiro para o celular. A Dona Célia quer telas simples; por isso o painel da lojista terá poucas telas.
- **Por que o formato "Como..., quero..., para..."?** Ele força a equipe a escrever o "por quê". Se você não consegue explicar o motivo, talvez a funcionalidade não seja necessária.
- **Por que 25 requisitos e não mais?** O curso tem poucas semanas. A lista foi cortada para caber: pagamento online, entrega, avaliações, mapa embutido e aplicativo de celular ficam de fora de propósito.
- **Por que marcar "Essencial", "Importante" e "Desejável"?** Para decidir sem brigar quando o tempo acabar. Quem escolheu o corte foi a lista, e não a pessoa.
- **Por que os papéis rodam?** Quem só faz o banco nunca aprende a tela. No fim do curso todas devem entender o sistema inteiro.

## Validação

Confira com a sua equipe, marcando cada item:

- [ ] Existe um documento com pelo menos 6 frases "Como..., quero..., para..." e a tabela dos 25 requisitos com a coluna "frase que atende".
- [ ] Todos os requisitos **Essenciais** estão marcados e a equipe sabe nomeá-los em voz alta (RF-01, 02, 03, 06, 08, 09, 10, 12, 13, 14, 15, 16, 17, 18 e 21).
- [ ] Os cinco papéis têm responsável nesta semana.
- [ ] A equipe sabe responder: "o que sai primeiro se faltar tempo?".

**Erros comuns**

1. *Sintoma:* a lista ficou com 60 itens e ninguém sabe o que fazer primeiro. *Causa:* cada ideia virou um requisito. *Correção:* junte os itens parecidos e mova o que não está na lista dos 25 para a coluna "ideias para depois".
2. *Sintoma:* todos os requisitos ficaram "Essenciais". *Causa:* medo de deixar algo de fora. *Correção:* pergunte "o sistema funciona sem isso?". Se a resposta for sim, não é essencial.
3. *Sintoma:* só uma pessoa fez a lista inteira. *Causa:* o grupo esperou uma pessoa começar. *Correção:* divida os 25 requisitos entre as integrantes (5 para cada uma), cada uma marca a sua parte e depois todas revisam juntas.

**Se travar**

1. Releia o Passo em que parou e confira se o exemplo dado ainda não resolve a sua dúvida.
2. Compare o seu documento com a tabela da aula: todos os códigos de RF-01 a RF-25 estão lá?
3. Se ainda assim travar, volte ao último passo que funcionou e refaça-o com a equipe. Só depois peça ajuda à sua equipe, dizendo o passo e o que você já tentou.

**Seu projeto agora tem**

- Um documento de backlog com os 25 requisitos priorizados (ainda sem repositório e sem código).
- A equipe formada, com papéis combinados e a regra "se faltar tempo, o que sai primeiro".

**Como saber que deu certo:** a sua equipe consegue explicar, sem olhar a tabela, o que o sistema faz e quais funcionalidades nunca podem sair do projeto.
