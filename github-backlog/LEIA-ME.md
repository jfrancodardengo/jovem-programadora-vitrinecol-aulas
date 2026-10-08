# Backlog do projeto no GitHub: guia para o professor e para as equipes

Esta pasta transforma o backlog do curso em **54 issues** (uma por aula) dentro do repositório da sua equipe, prontas para serem arrastadas em um quadro do **GitHub Projects**. O escopo é a UC3 (Dias 1 a 15, Aulas 1 a 45) e os Dias 26 a 28 da UC6 (Aulas 76 a 84): **18 dias de aula, 3 aulas por dia, 1 issue por aula**.

## O que tem nesta pasta

| Arquivo | Para que serve |
| --- | --- |
| `issues/diaDD-aulaAA.md` | O texto de cada issue (54 arquivos). O título da issue fica no script e no índice, não no arquivo. |
| `indice.csv` | Uma linha por issue (código, título, dia, data, aula, etiquetas, prioridade, marco, dependências, arquivo). Abra em uma planilha para revisar tudo. |
| `criar-backlog-github.sh` | O script que cria etiquetas, marcos e issues no repositório. |
| `LEIA-ME.md` | Este guia. |

**Como ler os códigos:** `D5·A13` quer dizer **Dia 5, Aula 13**. **RF** é um requisito funcional (o que o sistema faz), **RN** é uma regra de negócio (uma regra que o sistema sempre respeita) e **CT** é um caso de teste. Cada issue explica, em palavras, os RF, RN e CT que ela cita.

---

## 1) Pré-requisitos: instalar o GitHub CLI e fazer o login

O **GitHub CLI** (comando `gh`) é o programa que fala com o GitHub pelo terminal. O script usa ele para criar tudo.

### Windows

1. Abra o **Terminal** (ou o PowerShell) e rode:

   ```
   winget install --id GitHub.cli
   ```

   Se o `winget` não existir no seu computador, baixe o instalador em https://cli.github.com e instale com as opções padrão.
2. **Feche e abra o terminal de novo** (para o Windows reconhecer o comando).
3. O script é escrito em **bash**. No Windows, use o **Git Bash**, que vem junto com a instalação do Git (a mesma da Aula 2). Para abrir: menu Iniciar, procure por **Git Bash**. No VS Code, também dá para escolher o Git Bash no terminal.

### Mac

1. Abra o **Terminal** e rode (precisa do Homebrew, https://brew.sh):

   ```
   brew install gh
   ```

   Sem o Homebrew, baixe o instalador em https://cli.github.com.
2. O Terminal do Mac já roda bash/zsh e aceita o script.

### Fazer o login (Windows e Mac)

```
gh auth login
```

O terminal faz perguntas. Escolha **GitHub.com**, depois **HTTPS**, e entre pelo navegador (**Login with a web browser**, em português: entrar pelo navegador). Copie o código de uso único que aparece no terminal, cole na página do GitHub e autorize.

### Como conferir

```
gh --version
gh auth status
```

O primeiro mostra o número da versão. O segundo deve dizer que você está logada (*Logged in to github.com*).

**Se você for adicionar as issues a um projeto pelo script** (opcional, seção 3), o login precisa da permissão de projetos. Rode uma vez:

```
gh auth refresh -s project
```

---

## 2) Como rodar o script

**Antes de tudo:** o repositório da equipe precisa existir no GitHub (pode estar vazio) e a aba **Issues** do repositório precisa estar ligada (em **Settings**, em português: **Configurações**, na parte de recursos do repositório). Quem cria o repositório é a equipe (ou a professora); o passo "criar o repositório" da D1·A2 pode ser feito antes de rodar o script, sem problema.

1. Abra o terminal (Git Bash no Windows) **dentro da pasta `github-backlog`** (a pasta onde está o `criar-backlog-github.sh`).
2. Abra o script em um editor e confira o começo dele. As variáveis editáveis são:

   | Variável | O que é |
   | --- | --- |
   | `URL_GUIA` | O endereço da pasta de aulas, por exemplo `https://github.com/SEU-USUARIO/SEU-REPOSITORIO-DO-MATERIAL/blob/main/docs/guia-aulas`. É colocado nos links "Aula" de cada issue. |
   | `REPO` | O repositório da equipe, no formato `dono/nome` (exemplo: `ana-souza/vitrine-col`). Se ficar vazio, o script usa o repositório da pasta atual (`gh repo view`). |
   | `PROJETO_DONO` e `PROJETO_NUMERO` | Opcionais. Se os dois forem preenchidos, cada issue criada entra também no projeto. |

   Em vez de editar o arquivo, você pode passar os valores na frente do comando (veja os exemplos abaixo).
3. **Primeiro, o teste (DRY_RUN=1).** Ele só mostra o que faria, sem criar nada:

   ```
   REPO="dono/nome" DRY_RUN=1 bash criar-backlog-github.sh
   ```

4. **Depois, de verdade:**

   ```
   REPO="dono/nome" bash criar-backlog-github.sh
   ```

   Leva pouco mais de 1 minuto, porque o script espera cerca de 1 segundo entre uma issue e outra (assim o GitHub não bloqueia).

### O que esperar

No fim aparece um resumo. Na **primeira vez**, num repositório limpo:

```
Etiquetas: 13 criadas, 0 puladas
Marcos:    18 criados, 0 pulados
Issues:    54 criadas, 0 puladas
Tudo certo!
```

(No modo de teste, os números são o que **seria** criado.) Rodando **de novo**, o script pula tudo o que já existe (a conferência de issues é pelo título): `0 criadas, 54 puladas`. Por isso é seguro rodar outra vez se a internet cair no meio.

**Se algo falhar**, o script mostra a mensagem em português e para (por exemplo, `gh` não instalado, login não feito ou permissão de projetos faltando). Corrija e rode de novo.

### O que o script cria

- **13 etiquetas:** as 10 de assunto (Configuração, Front-end (HTML/CSS), JavaScript, Orientação a Objetos, Supabase (Banco de Dados), Segurança, Fluxo de Pedido, Testes, Publicação, Documentação) e as 3 de prioridade (Essencial, Importante, Desejável).
- **18 marcos (milestones),** um por dia de aula, com o título `Dia N · DD/MM · dia da semana` e a data de entrega do dia.
- **54 issues,** em ordem, cada uma com o título `D<dia>·A<aula> – tarefa`, o texto do arquivo em `issues/`, as etiquetas e o marco do dia.

**Prioridade em uma frase:** **Essencial** = o sistema não funciona sem isso; **Importante** = faz muita falta, mas o sistema ainda funciona; **Desejável** = melhora o sistema e é o primeiro a sair se o tempo apertar.

---

## 3) Como montar o quadro no GitHub Projects

O **GitHub Projects** (em português: **Projetos**) é o quadro de tarefas do GitHub. Ele pertence a uma conta (a sua) ou a uma organização e pode ser ligado a um ou mais repositórios. Os nomes exatos de menus podem mudar um pouco com o tempo; se algum botão não estiver onde o guia diz, procure pelo **objetivo** do passo.

### 3.1 Criar o projeto

1. Abra a aba **Projects** (em português: **Projetos**) do repositório, ou a mesma aba no perfil da conta/organização.
2. Crie um projeto novo (botão **New project**, em português: **Novo projeto**) e, se o GitHub oferecer modelos, escolha **Board** (em português: **Quadro**). Dê o nome, por exemplo, de `Backlog VitrineCol`.
3. Anote o **número do projeto**: ele aparece no endereço da página (`.../projects/NUMERO`). Você vai usá-lo no `PROJETO_NUMERO` se quiser que o script já coloque as issues no quadro.
4. **Ligue o repositório ao projeto** (objetivo: o projeto aparecer na aba Projects do repositório e poder receber as issues dele). Procure na página do projeto, nas configurações do projeto, a opção de ligar a um repositório; ou, na aba Projects do repositório, a opção de ligar um projeto existente.

### 3.2 Criar as colunas (campo Status)

As colunas do quadro vêm do campo **Status**. Objetivo: o campo Status ter **cinco opções, nesta ordem**:

1. **Backlog**: issues dos próximos dias.
2. **A Fazer Hoje**: as 3 issues do dia de aula e as atrasadas de ontem.
3. **Em Andamento**: a dupla começou a issue.
4. **Em Revisão**: a dupla conferiu **todos** os critérios de aceite e enviou o código (`git push`) ou abriu o pull request.
5. **Concluído**: outra integrante conferiu e concordou.

O projeto novo já vem com um campo Status com algumas opções padrão (em inglês, algo como Todo, In Progress e Done). Abra as configurações do campo Status (pelo cabeçalho do campo na visualização Tabela ou pelas configurações do projeto), **renomeie** as opções que já existem, **acrescente** as que faltam e **ponha na ordem** acima.

### 3.3 Criar as visualizações

Uma visualização (view) é um jeito de olhar os mesmos itens. Crie três:

- **Board** (em português: **Quadro**): as colunas do Status. É a que a equipe usa todo dia.
- **Table** (em português: **Tabela**): uma linha por issue, com colunas de etiquetas, marco, responsável e Status. Boa para a professora conferir tudo. Use o agrupamento por **Milestone** (marco) para ver o dia de aula de cada issue.
- **Roadmap** (em português: **Roteiro**): linha do tempo. Ela precisa de campos de data. Se quiser, crie no projeto um campo do tipo data (por exemplo `Data do dia`) e preencha com a data de cada dia (veja a tabela da seção 6). Se não quiser preencher datas, use a Tabela agrupada por marco, que já mostra os 18 dias em ordem.

### 3.4 Adicionar as 54 issues ao quadro

Escolha **uma** das formas:

- **Pelo script (mais fácil):** preencha `PROJETO_DONO` (seu usuário ou o nome da organização) e `PROJETO_NUMERO` e rode o script. Cada issue criada entra no projeto. Precisa do `gh auth refresh -s project` (seção 1).
- **Pelo próprio projeto, de uma vez:** na visualização Tabela, procure o botão de adicionar itens (o **+** no fim da tabela) e a opção de adicionar itens **a partir de um repositório**; escolha o repositório, marque todas as issues (as 54) e confirme.
- **Automático:** nas automações do projeto (seção 3.5), procure a opção que **adiciona ao projeto, sozinha, as issues novas de um repositório**. Ela vale para issues criadas **depois** de ligada; para as que já existem, use uma das duas formas acima.

Depois de adicionar, as issues chegam sem Status. Na Tabela, selecione todas e defina o Status como **Backlog**; ou ligue a automação "item adicionado ao projeto" (3.5), que faz isso sozinha. De manhã, em cada dia de aula, mova as 3 issues do dia para **A Fazer Hoje**.

### 3.5 Automações úteis

Procure o menu do projeto (os três pontinhos, `...`) e a opção **Workflows** (em português: **Fluxos de trabalho**). Os mais úteis:

- **Item added to project** (item adicionado ao projeto) → Status **Backlog**.
- **Item closed** (item fechado) → Status **Concluído**. Assim, quando a issue é fechada, ela vai para Concluído sozinha.
- **Pull request merged** (pull request mesclado) → Status **Concluído**.
- **Item reopened** (item reaberto) → Status **Em Andamento**.

Cada automação é ligada e configurada na própria tela de Workflows. Se alguma não aparecer, o objetivo é: issue fechada ou pull request mesclado vai para **Concluído**.

---

## 4) Como a equipe trabalha

1. **Pegar uma issue:** abra a issue do dia e **atribua a si mesma** (campo **Assignees**, em português: **Responsáveis**). Veja o campo **Depende de**: só comece quando a issue citada lá estiver em **Concluído**.
2. **Mover para Em Andamento** (no quadro, arraste o cartão da issue) e seguir a aula do link "Aula e requisitos".
3. **Fazer a checklist:** marque cada caixinha `- [ ]` conforme avança. O GitHub mostra o progresso da issue.
4. **Conferir os critérios de aceite:** cada um é um teste que se faz no navegador, no terminal ou no painel do Supabase. A issue só está pronta quando **todos** passam.
5. **Abrir um pull request** (em português: **solicitação de pull**) que cita a issue na descrição, assim:

   ```
   Closes #12
   ```

   (troque 12 pelo número da issue). Quando o pull request é mesclado, o GitHub fecha a issue sozinho. Para issues sem código (por exemplo, wireframes e Figma), não há pull request: guarde o material onde a equipe acessa, cole o link em um comentário da issue e **feche a issue** ao concluir.
6. **Mover para Em Revisão** quando os critérios passaram e o pull request está aberto (ou o material foi guardado).
7. **Concluído:** **outra** integrante olha o resultado, confirma que os critérios passam, aprova o pull request e a issue vai para Concluído.

### Limite de trabalho em andamento

**No máximo 1 issue por dupla** na coluna **Em Andamento**. Terminou? Mova para **Em Revisão** antes de puxar a próxima.

### Issue atrasada

Se a issue **não ficou pronta no dia**:

1. Ela volta para o **topo** de **A Fazer Hoje** no dia seguinte, antes das issues novas.
2. A dupla pede ajuda à professora ou usa a seção **"Se travar"** da aula.
3. **Nunca pule para a próxima issue sem concluir a anterior:** cada aula parte do que a anterior deixou pronto.
4. O trabalho que não coube nos 60 minutos fica em **"Observações do dia"** (seção 6); ele **não** vira issue extra.

Os passos de **segurança** (chaves, RLS, política de fotos) e de **banco** (scripts SQL) nunca são pulados, mesmo com atraso.

### Se o tempo apertar, o que sai primeiro (nesta ordem)

1. o link do mapa na página da loja; 2. o carrossel da página inicial, o aviso da lojista à cliente por WhatsApp e a reordenação das fotos do produto; 3. o filtro por tamanho; 4. o envio de fotos pelo sistema (usando o endereço de uma imagem já hospedada).

---

## 5) Avisos importantes

- **As issues não são copiadas quando se cria um repositório a partir de um modelo (template).** Cada equipe roda o script no **seu** repositório. O mesmo vale para etiquetas e marcos: o script cria os três.
- **Cópia do projeto:** o GitHub Projects permite copiar um projeto (no menu `...` do projeto, procure pela opção de fazer uma cópia, em inglês **Make a copy**). A cópia leva a **estrutura do quadro**: campos, visualizações e, em geral, as automações. Ela **não** é um jeito seguro de levar as 54 issues, porque as issues pertencem ao repositório e não ao projeto; só os itens do tipo rascunho (draft) podem acompanhar a cópia. Para ter as issues, rode o script no repositório da equipe e adicione-as ao projeto copiado (seção 3.4).
- **Os links das aulas** dentro das issues dependem do `URL_GUIA`. Se as equipes não conseguirem abrir a pasta de aulas pelo endereço, entregue os arquivos de aula de outro jeito e ajuste o `URL_GUIA` antes de rodar.
- **Limite do teste:** o script foi testado com um `gh` de mentira (que só registra os comandos) e com `bash -n`; **não** foi testado contra o GitHub de verdade. Por isso rode sempre primeiro com `DRY_RUN=1`, e na primeira vez de verdade use um repositório de teste.

---

## 6) Resumo dos dias

| Dia | Data | Aulas | Issues | Entrega do dia / Marco |
| --- | --- | --- | --- | --- |
| 1 | 06/10/2026 (terça-feira) | 1 a 3 | D1·A1, D1·A2, D1·A3 | Backlog do MVP, repositório da equipe e primeira página aberta no Live Server |
| 2 | 07/10/2026 (quarta-feira) | 4 a 6 | D2·A4, D2·A5, D2·A6 | Protótipo navegável no Figma e guia de estilo · **Marco 1** |
| 3 | 08/10/2026 (quinta-feira) | 7 a 9 | D3·A7, D3·A8, D3·A9 | Páginas do projeto em HTML, sem estilo (index.html, login.html, catalogo.html, loja.html e produto.html) |
| 4 | 09/10/2026 (sexta-feira) | 10 a 12 | D4·A10, D4·A11, D4·A12 | Páginas estilizadas conforme o guia de estilo (cores, tipografia, cabeçalho, botões, campos e cards em css/variaveis.css, css/base.css, css/componentes.css e css/paginas.css) |
| 5 | 13/10/2026 (terça-feira) | 13 a 15 | D5·A13, D5·A14, D5·A15 | As dez páginas estáticas responsivas, com CSS organizado em quatro arquivos, foco visível e a tag v0.1 · **Marco 2** |
| 6 | 14/10/2026 (quarta-feira) | 16 a 18 | D6·A16, D6·A17, D6·A18 | Interações básicas nas páginas (script ligado ao catálogo, produtos fictícios como array de objetos, cabeçalho gerado pelo JavaScript, avisos e chips que reagem ao clique) |
| 7 | 15/10/2026 (quinta-feira) | 19 a 21 | D7·A19, D7·A20, D7·A21 | Catálogo filtrável com dados fictícios (cards desenhados pelo JavaScript, filtros por tipo, loja, tamanho e nome) e formulário de produto com validação |
| 8 | 16/10/2026 (sexta-feira) | 22 a 24 | D8·A22, D8·A23, D8·A24 | Classes de domínio do projeto (ErroApp, Produto, Loja, Usuaria, Cliente, Lojista), catálogo com dados fictícios usando as classes, tratamento de erros e código em módulos (modelos, ui, paginas) |
| 9 | 19/10/2026 (segunda-feira) | 25 a 27 | D9·A25, D9·A26, D9·A27 | Banco criado e populado no Supabase (8 tabelas, 4 gatilhos, 8 categorias, lojista de teste, uma loja e 3 produtos de exemplo) |
| 10 | 20/10/2026 (terça-feira) | 28 a 30 | D10·A28, D10·A29, D10·A30 | Catálogo lendo do banco (produtos, categorias e lojas do Supabase), com filtros feitos na consulta e paginação de 12 produtos |
| 11 | 21/10/2026 (quarta-feira) | 31 a 33 | D11·A31, D11·A32, D11·A33 | Loja e produtos cadastrados, editados, desativados e excluídos pelo sistema, com até 5 fotos por produto guardadas no Supabase Storage · **Marco 3** |
| 12 | 22/10/2026 (quinta-feira) | 34 a 36 | D12·A34, D12·A35, D12·A36 | Páginas de produto e de loja com dados do banco, sacola agrupada por loja (localStorage) e "Finalizar sacola" montando um pedido por loja com botão de WhatsApp por loja. **A gravação dos pedidos no banco só entra no Dia 13**, depois do login (RF-10 fica completo no D13·A39) |
| 13 | 23/10/2026 (sexta-feira) | 37 a 39 | D13·A37, D13·A38, D13·A39 | Login, recuperação de senha por e-mail e segurança básica (telas protegidas por perfil, RLS nas 8 tabelas, política provisória de fotos apagada e pedidos gravados somente pela função criar_pedidos do banco) |
| 14 | 26/10/2026 (segunda-feira) | 40 a 42 | D14·A40, D14·A41, D14·A42 | Página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas) e fluxo completo testado e corrigido, com os 25 casos de teste registrados e o Git organizado em branches e pull requests |
| 15 | 27/10/2026 (terça-feira) | 43 a 45 | D15·A43, D15·A44, D15·A45 | Sistema publicado no GitHub Pages, README completo com diagrama ER e MVP revisado e demonstrado ao vivo · **Marco 4** |
| 26 | 12/11/2026 (quinta-feira) | 76 a 78 | D26·A76, D26·A77, D26·A78 | Sistema com conteúdo real e acompanhamento do pedido: a lojista atualiza o status e deixa recado, a cliente é avisada dentro do sistema, a conta pode ser excluída e o catálogo tem lojas, produtos e fotos reais |
| 27 | 13/11/2026 (sexta-feira) | 79 a 81 | D27·A79, D27·A80, D27·A81 | Relatório de testes (docs/relatorio-de-testes.md) com os 25 casos executados no site publicado, as anotações de pelo menos 5 testes com usuárias externas e a lista priorizada de correções com responsável e prazo |
| 28 | 16/11/2026 (segunda-feira) | 82 a 84 | D28·A82, D28·A83, D28·A84 | Problemas críticos corrigidos e retestados, segurança revisada, versão final publicada, documentação final e código congelado (a partir de agora, só correção de erro grave) · **Marco 8** |

**RF** = requisito funcional, **RN** = regra de negócio, **CT** = caso de teste. Não há aula no feriado entre os Dias 4 e 5 nem em fins de semana. Os Dias 16 a 25 e 29 a 31 fazem parte de outro material e não têm issues aqui (por isso a numeração das aulas pula de 45 para 76).

### Observações do dia

Esse trabalho extra de cada aula **não** vira issue: fica aqui.

### Dia 1 · 06/10/2026 · terça-feira

**Entrega do dia:** Backlog do MVP, repositório da equipe e primeira página aberta no Live Server.

**Observações do dia:**

- A Aula 2 (Git e GitHub) é a mais longa do dia: instalar ferramentas, criar o repositório e fazer o primeiro commit de **cada** integrante. Se a equipe não terminar, o que sobrar (clones e commits das últimas integrantes) é feito em casa antes da Aula 3.
- O guia da Aula 2 monta o quadro Kanban no GitHub Projects; o passo a passo para montar o quadro com estas issues está no arquivo LEIA-ME.md deste backlog. As issues só podem ser criadas depois que o repositório da equipe existe.

### Dia 2 · 07/10/2026 · quarta-feira

**Entrega do dia:** Protótipo navegável no Figma e guia de estilo.

**Observações do dia:**

- Nenhum arquivo de código novo no repositório hoje: o trabalho vive no papel e no Figma. A única mudança no repositório é o `README.md` com os links do protótipo e do guia de estilo (Aula 6).
- O Figma e o verificador de contraste têm menus em inglês; os nomes aparecem como na tela, com a versão em português ao lado.

### Dia 3 · 08/10/2026 · quinta-feira

**Entrega do dia:** Páginas do projeto em HTML, sem estilo (`index.html`, `login.html`, `catalogo.html`, `loja.html` e `produto.html`).

**Observações do dia:**

- A Aula 9 é a mais cheia do dia: seis imagens SVG, três cards no catálogo e duas páginas novas (loja e produto). Se não couber em 60 minutos, as seis imagens (Passo 1) podem ser concluídas em casa antes da Aula 10, sem criar issue extra.
- Hoje não há CSS nem JavaScript; os dados são escritos à mão no HTML. Links para páginas que ainda não existem (Sacola, Cadastrar, Meus pedidos, Painel da loja) são esperados.

### Dia 4 · 09/10/2026 · sexta-feira

**Entrega do dia:** Páginas estilizadas conforme o guia de estilo (cores, tipografia, cabeçalho, botões, campos e cards em `css/variaveis.css`, `css/base.css`, `css/componentes.css` e `css/paginas.css`).

**Observações do dia:**

- A Aula 11 (Flexbox) tem quatro partes de CSS para colar e conferir (cabeçalho, botões, campos, avisos e chips). Se faltar tempo, a equipe termina os Passos 3 e 4 em casa antes da Aula 12, sem criar issue extra.
- O catálogo fica em **uma coluna** de propósito; as colunas que mudam com a largura da tela entram no Dia 5.

### Dia 5 · 13/10/2026 · terça-feira

**Entrega do dia:** As dez páginas estáticas responsivas, com CSS organizado em quatro arquivos, foco visível e a tag `v0.1`.

**Observações do dia:**

- A Aula 15 é a mais pesada do dia: cinco páginas HTML novas e quatro blocos de CSS para colar. Se não couber em 60 minutos, o Passo 2 (estilos) e a revisão de acessibilidade (Passo 4) são terminados em casa antes da Aula 16; a tag `v0.1` só é criada depois que a revisão estiver toda marcada.
- Só uma integrante cria a tag `v0.1`; as outras só conferem no GitHub.
- Não há aula no feriado entre os Dias 4 e 5: por isso o Dia 5 acontece na terça-feira 13/10.

### Dia 6 · 14/10/2026 · quarta-feira

**Entrega do dia:** Interações básicas nas páginas (script ligado ao catálogo, produtos fictícios como array de objetos, cabeçalho gerado pelo JavaScript, avisos e chips que reagem ao clique).

**Observações do dia:**

- Os exercícios opcionais das Aulas 16 e 17 (por exemplo, o desafio "Últimas unidades!", a função `calcularDesconto` e o 7º produto) são o primeiro trabalho que sobra se faltar tempo; não viram issue extra.
- Só o `catalogo.html` passa a gerar o cabeçalho pelo JavaScript hoje; as outras páginas mantêm o cabeçalho escrito à mão por enquanto.

### Dia 7 · 15/10/2026 · quinta-feira

**Entrega do dia:** Catálogo filtrável com dados fictícios (cards desenhados pelo JavaScript, filtros por tipo, loja, tamanho e nome) e formulário de produto com validação.

**Observações do dia:**

- A Aula 20 é a que mais pesa: são cinco funções novas coladas em ordem no `catalogo.js`. Se faltar tempo, o que sobrar do teste final (Passo 6, itens 4 e 5, tamanho e busca por nome) é concluído antes da Aula 21, sem criar issue extra.
- A busca pelo nome (RF-05) é Desejável; aqui ela é só ensaiada com dados fictícios. A versão com o banco vem no Dia 10.
- O 15/10 foi tratado como dia normal de aula.

### Dia 8 · 16/10/2026 · sexta-feira

**Entrega do dia:** Classes de domínio do projeto (`ErroApp`, `Produto`, `Loja`, `Usuaria`, `Cliente`, `Lojista`), catálogo com dados fictícios usando as classes, tratamento de erros e código em módulos (`modelos`, `ui`, `paginas`).

**Observações do dia:**

- A Aula 22 tem a maior sequência de trocas no `catalogo.js` (oito substituições, na ordem). Se faltar tempo, o teste do Passo 5 (item 3, no Console) é concluído antes da Aula 23, sem issue extra.
- Com a Aula 24 termina o Módulo 2 (JavaScript e orientação a objetos). Os dados continuam fictícios; o banco só entra no Dia 9.

### Dia 9 · 19/10/2026 · segunda-feira

**Entrega do dia:** Banco criado e populado no Supabase (8 tabelas, 4 gatilhos, 8 categorias, lojista de teste, uma loja e 3 produtos de exemplo).

**Observações do dia:**

- **Regra para os Dias 9 a 12:** a RLS (segurança por linha) fica **desativada**, a política provisória de Storage entra no Dia 11 e a lojista de teste é quem faz as ações (ainda não há login). Quem ativar a RLS antes do Dia 13 trava as telas dos dias seguintes. A RLS definitiva e o login só entram no Dia 13.
- A Aula 26 tem o script mais comprido do curso (`01_schema.sql`). Copiar o script **inteiro**, sem cortar linhas; se der erro no meio, seguir a seção "Se travar" da aula e não pular para a Aula 27 sem as 8 tabelas e os 4 gatilhos.
- Passos de **banco** (scripts SQL) nunca são pulados: as aulas seguintes dependem deles.
- A senha do banco é guardada **fora** do repositório (nunca no código nem no GitHub). Regra do plano gratuito: entrar no painel ou rodar o site pelo menos uma vez por semana, para o projeto não ser pausado.

### Dia 10 · 20/10/2026 · terça-feira

**Entrega do dia:** Catálogo lendo do banco (produtos, categorias e lojas do Supabase), com filtros feitos na consulta e paginação de 12 produtos.

**Observações do dia:**

- Continuam valendo as regras do curso para os Dias 9 a 12: RLS **desativada**, lojista de teste e nenhum login ainda. No **Table Editor** (em português: **Editor de tabelas**) cada tabela deve mostrar **RLS disabled**.
- A Aula 29 mistura painel do Supabase, arquivos novos e seis trocas no `catalogo.js`. Se o tempo estourar, a equipe termina o Passo 7 (apagar `dados-de-exemplo` e testar com a configuração real) antes da Aula 30; o Passo 4 (arquivos de serviço) nunca é pulado.
- Na Aula 29, só a chave pública `anon` entra no código; a chave `service_role` (ou `secret`) nunca aparece em nenhum arquivo nem em mensagens de pedido de ajuda.
- Na Aula 30, o teste de paginação troca `PRODUTOS_POR_PAGINA` para 2 só de forma **temporária**; o valor volta para 12 no fim.

### Dia 11 · 21/10/2026 · quarta-feira

**Entrega do dia:** Loja e produtos cadastrados, editados, desativados e excluídos pelo sistema, com até 5 fotos por produto guardadas no Supabase Storage.

**Observações do dia:**

- **Regra para os Dias 9 a 12:** RLS **desativada**, a política provisória de Storage (`dev: envio de fotos`) existe só até o Dia 13 e as telas do painel usam a **lojista de teste** (o id provisório fica em `js/config.js`). Qualquer pessoa com o endereço do site poderia gravar: usar só dados de teste e não divulgar o link.
- A Aula 33 é uma das mais cheias do curso (nove trocas no formulário, três arquivos novos e o painel do Storage). Se o tempo estourar, **o que pode sair primeiro é a reordenação das fotos** (botões "Mover para cima" e "Mover para baixo"), depois o upload de arquivos (usando o campo de endereço/URL como plano B); os passos de banco e de segurança não são pulados.
- Anotar no quadro do GitHub Projects: "apagar a política provisória de fotos no Dia 13".
- Se algum passo de uma aula não terminar, anotar o número do passo e continuar dele no começo da aula seguinte, sem passar à próxima aula com a issue anterior aberto.

### Dia 12 · 22/10/2026 · quinta-feira

**Entrega do dia:** Páginas de produto e de loja com dados do banco, sacola agrupada por loja (localStorage) e "Finalizar sacola" montando um pedido por loja com botão de WhatsApp por loja. **A gravação dos pedidos no banco só entra no Dia 13**, depois do login (RF-10 fica completo no D13·A39).

**Observações do dia:**

- **Regra para os Dias 9 a 12:** RLS **desativada**, política provisória de Storage ainda existente e lojista de teste (nenhum login). Nada é gravado nas tabelas `pedidos` e `itens_pedido` hoje: elas devem continuar **vazias** (confira no **Table Editor**, em português: **Editor de tabelas**).
- Hoje a tela "Pedidos enviados" mostra o texto "Pedidos gravados!" mesmo sem gravar; isso é esperado e vira verdade só no Dia 13. Registrar isso na issue para a equipe não achar que é erro.
- É o dia mais cheio do módulo de pedidos (três aulas longas). Se o tempo apertar, **o primeiro item a sair é o link "Ver no mapa" da página da loja (RF-07)**; a galeria acessível por teclado, a sacola com duas lojas e o botão de WhatsApp por loja ficam.
- Para testar a sacola é preciso ter **duas lojas** com produtos ativos e WhatsApp cadastrado (a Loja Exemplo e uma segunda loja cadastrada em **Minha loja** na Aula 31 ou criada hoje, com outra lojista de teste).
- Cada aula termina com `git commit` e `git push`; só passar à issue seguinte quando o anterior estiver em "Concluído".

### Dia 13 · 23/10/2026 · sexta-feira

**Entrega do dia:** Login, recuperação de senha por e-mail e segurança básica (telas protegidas por perfil, RLS nas 8 tabelas, política provisória de fotos apagada e pedidos gravados somente pela função `criar_pedidos` do banco).

**Observações do dia:**

- **Este é um dos dias mais cheios do curso** (três aulas pesadas). A ordem do curso vale: **login e RLS definitiva só neste dia**. Até aqui (Dias 9 a 12) a RLS ficou desativada, a política provisória de Storage existia e a lojista de teste fazia tudo.
- **Ordem obrigatória na Aula 39:** primeiro mudar o **código** (Passos 1 a 6) e **só depois** ligar a RLS no banco (Passos 7 e 8). Se a RLS for ligada antes, o painel antigo (que usa a lojista de teste) deixa de funcionar.
- Os passos de **segurança e de banco** da Aula 39 (RLS, `04_melhorias.sql`, apagar a política `dev: envio de fotos`) **nunca são pulados**; se faltar tempo, o que fica para depois da aula são os testes de acesso indevido pelo console (Passo 10), que a equipe refaz antes de seguir para o cartão do Dia 14.
- Antes de começar a Aula 39 a equipe precisa de: uma conta de **cliente**, a **Lojista Teste** e uma **segunda lojista** (cadastrada com perfil **Lojista**, com loja e um produto).
- Se o e-mail de recuperação de senha não chegar (Aula 38): o plano gratuito envia poucos e-mails por hora e pode enviar só para membros da organização; testar com o e-mail de quem criou o projeto ou de uma integrante convidada, e esperar alguns minutos se aparecer "Muitas tentativas em pouco tempo".
- A confirmação de e-mail fica **desligada** só durante as aulas (será revista no Dia 27).
- O 23/10 foi tratado como dia normal de aula.

### Dia 14 · 26/10/2026 · segunda-feira

**Entrega do dia:** Página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas) e fluxo completo testado e corrigido, com os 25 casos de teste registrados e o Git organizado em branches e pull requests.

**Observações do dia:**

- A Aula 40 é muito cheia (HTML, CSS e JavaScript). Os blocos da vitrine são independentes: se o tempo apertar, **o carrossel é o primeiro item a sair** (o hero e os destaques ficam); a equipe só deixa o carrossel para depois se já tiver marcado isso na issue.
- Na Aula 41, os casos CT-17, CT-18, CT-20 e CT-24 dependem de telas do Dia 26 e ficam como **N/A** por enquanto; o CT-22 (mais de 12 produtos) pode ficar N/A e voltar no Dia 27 se faltarem produtos de teste.
- Cada defeito encontrado na Aula 41 vira um cartão no quadro (modelo "Defeito: [tela] [o que aconteceu]", com caso de teste, tela e passo, o que aconteceu, o que era esperado e gravidade). Essas issues de defeito são o trabalho da Aula 42; **não** substituem as issues deste backlog.
- Na Aula 42, o Passo 6 (resolver um conflito de propósito, em dupla) é opcional e o primeiro a sair se faltar tempo.
- Ao redigir o `docs/TESTES.md`, a equipe usa só os roteiros da própria aula; o restante do tempo vai para a correção dos defeitos críticos e importantes.

### Dia 15 · 27/10/2026 · terça-feira

**Entrega do dia:** Sistema publicado no GitHub Pages, README completo com diagrama ER e MVP revisado e demonstrado ao vivo.

**Observações do dia:**

- A Aula 45 tem quatro blocos de 15 minutos (checklist, demonstração, conferência do que falta e avaliação dos indicadores) mais a tag. Se o tempo estourar, o **ensaio da demonstração** (Passo 2) é o que fica mais curto: cronometrar para caber em 8 minutos e, se preciso, repetir antes da próxima aula. Os itens de segurança da checklist (nenhum `innerHTML` com dados, nenhuma chave `service_role`, RLS ligada) não são pulados.
- Os requisitos que ainda **não existem** no fim do dia são RF-11, RF-20, RF-22 e RF-25 (entram no Dia 26): a equipe cria uma issue de pendência no quadro para cada item "falta" ou "parcial" da tabela da Aula 45, com prioridade.
- A cada `git push` na `main`, o GitHub Pages publica de novo em alguns minutos; evitar enviar alterações no meio da demonstração.
- Se um indicador ficar "parcialmente atendido" ou "não atendido", a recuperação é imediata nas aulas seguintes; anotar o que falta no quadro.
- As aulas dos Dias 16 a 25 tratam de outros assuntos e não fazem parte deste backlog: depois do Dia 15, a próxima issue é a D26·A76, em 12/11/2026.

### Dia 26 · 12/11/2026 · quinta-feira

**Entrega do dia:** Sistema com conteúdo real e acompanhamento do pedido: a lojista atualiza o status e deixa recado, a cliente é avisada dentro do sistema, a conta pode ser excluída e o catálogo tem lojas, produtos e fotos reais.

**Observações do dia:**

- Este dia começa a fase de fechamento da versão 1.0. Antes de abrir a primeira issue, conferir que o MVP 0.9 continua publicado, que existe **pelo menos um pedido** gravado na tabela `pedidos` e que a lojista dona dele tem a loja cadastrada.
- **O que a aula pede além dos 60 minutos da Aula 78 (fica só como observação, sem issue extra):** a carga do conteúdo real pelo próprio sistema (meta: pelo menos 3 lojas e 12 produtos, com 2 fotos cada; e 13 ou mais produtos ativos no total para o CT-22), a limpeza dos dados de teste e a revisão de responsividade e acessibilidade com o conteúdo real em 360 e 1280 px, com uma issue de pendência para cada problema. Dividir entre as integrantes: duas pessoas ficam com **Minha conta** (Aula 78) e as outras com a carga de conteúdo. Só usar fotos e textos com autorização de uso e nunca imagens com rosto de pessoas sem consentimento.
- **Itens pendentes do backlog (RF-11, RF-20, RF-22, RF-25 e os cartões criados no D15·A45):** priorizar os **Essenciais** e os **Importantes**; os **Desejáveis** só entram se sobrar tempo.
- **Se o tempo apertar, o primeiro a sair é o aviso da lojista à cliente por WhatsApp** (o aviso dentro do sistema continua; é o RF-22 principal). O botão "Avisar a cliente pelo WhatsApp" só aparece quando a cliente tem telefone cadastrado.
- Cada uma das três aulas termina com uma branch própria, pull request e revisão de outra integrante (como no D14·A42); o commit direto na `main` não vale a partir de hoje.
- Os testes de acesso indevido (CT-18 e CT-20) e o CT-17 são feitos hoje e voltam a ser refeitos no Dia 28.

### Dia 27 · 13/11/2026 · sexta-feira

**Entrega do dia:** Relatório de testes (`docs/relatorio-de-testes.md`) com os 25 casos executados no site publicado, as anotações de pelo menos 5 testes com usuárias externas e a lista priorizada de correções com responsável e prazo.

**Observações do dia:**

- **O que a aula pede além dos 60 minutos (fica só como observação, sem issue extra):** executar os 25 casos de teste em 25 minutos exige dividir os casos entre as duplas (por exemplo, CT-01 a CT-08, CT-09 a CT-16 e CT-17 a CT-25) e deixar os dados de teste prontos antes da aula; os casos que dependem de e-mail (CT-08 e CT-23) podem ser repetidos mais tarde se aparecer "Muitas tentativas em pouco tempo".
- Na Aula 79 **não pode sobrar nenhum `N/A`**: o que depende de dados que faltam (13 ou mais produtos ativos, duas lojas, conta de teste para o CT-24) é preparado primeiro. Para o CT-24, usar sempre uma conta criada só para o teste, nunca uma conta real.
- A Aula 80 depende de **pelo menos 5 usuárias externas** (de outras turmas, convidadas ou lojistas parceiras) disponíveis na hora; se não houver tantas, cada sessão leva só cerca de 10 minutos e a equipe convida colegas de outras turmas. Anotar só o primeiro nome da usuária e nunca dados pessoais.
- Se o site cair durante uma sessão de teste, anotar o horário e a mensagem de erro: é um defeito **crítico**.
- Na Aula 81, se a lista de correções ficar grande demais, **só os críticos e os importantes** entram nas Aulas 82 e 83; o restante vai para a seção "não será feito na versão 1.0" com o motivo.
- A confirmação de e-mail do Supabase continua **desligada** durante os testes se o e-mail de confirmação não chegar para quem não é da equipe; registrar essa decisão e o risco no relatório (seção 5 da Aula 81).

### Dia 28 · 16/11/2026 · segunda-feira

**Entrega do dia:** Problemas críticos corrigidos e retestados, segurança revisada, versão final publicada, documentação final e código congelado (a partir de agora, só correção de erro grave).

**Observações do dia:**

- **O que a aula pede além dos 60 minutos (fica só como observação, sem issue extra):** na Aula 82, a revisão das mensagens das **15 telas** em todos os estados da tabela da aula (o que é dividido entre as duplas) e a varredura de código por `PROVISÓRIO`, `alert(`, `console.log(` e `throw new Error(`; na Aula 83, o teste extra do visitante pelo Console; na Aula 84, a proteção opcional da `main` (branch protection) e o vídeo curto da demonstração (gravação de reserva).
- Todas as correções entram por **branch, pull request revisado por outra integrante e merge**. A tag `v1.0` só é criada **depois** do merge do README final (a tag deve apontar para o commit que já tem o README final); se for criada antes, apagar (`git tag -d v1.0` e `git push origin --delete v1.0`) e criar de novo.
- A publicação no GitHub Pages leva alguns minutos depois do merge; refazer os casos de teste com **Ctrl+Shift+R** (Mac: Cmd+Shift+R) para ignorar o cache.
- Se aparecer um problema que não é crítico, ele **não** entra hoje: vai para a seção "não será feito na versão 1.0" do relatório de testes.
- Depois de hoje, o código fica **congelado**: só correção de erro grave, em branch e pull request revisado.
- As aulas seguintes (Dias 29 a 31) fazem parte de outro material e não têm cartão neste backlog.

