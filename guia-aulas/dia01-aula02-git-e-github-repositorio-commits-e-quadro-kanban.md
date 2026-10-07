# Aula 2 – Git e GitHub: repositório, commits, README e quadro Kanban

**Dia 1 · Ter 06/10/2026** · **Aula 2** · **UC3**

- **Requisitos cobertos:** não se aplica (preparação do ambiente de desenvolvimento)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** o backlog e a equipe da Aula 1. Você precisa do VS Code instalado e de uma conta gratuita no GitHub (ou criá-la agora)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai instalar o Git e a extensão Live Server, criar o **repositório** da equipe no GitHub, fazer o seu primeiro **commit** e montar o **quadro Kanban** com o backlog da Aula 1.

**Abertura (10 minutos).** Retomada: na Aula 1 vocês montaram o backlog (a lista dos 25 requisitos). Hoje essa lista vai para um quadro visual, e o código do projeto passa a ter um "histórico de versões" compartilhado. Confira antes de começar: o backlog está em um documento e a equipe sabe quem assume cada papel.

## O Conceito

**Termos desta aula**

- **Git**: programa que guarda o histórico de todas as versões dos seus arquivos. Funciona como o "desfazer" mais poderoso que existe: você volta a qualquer momento ao que estava salvo antes.
- **Commit**: uma "foto" do projeto em um momento, com uma mensagem que explica o que mudou. Cada commit deve ser pequeno e ter uma mensagem em português, no imperativo: "Adiciona o formulário de login".
- **Repositório**: a pasta do projeto com todo o histórico de commits. Existe uma cópia no seu computador e outra no GitHub.
- **GitHub**: site que guarda o repositório na internet para a equipe toda acessar. **push** envia os seus commits para lá; **pull** traz os commits das colegas.
- **Kanban**: quadro com colunas (a fazer, em andamento, concluído) onde cada tarefa é um cartão que anda da esquerda para a direita.

**Analogia:** o Git é um caderno em que cada commit é uma página datada; o GitHub é o armário da turma onde cada uma guarda uma cópia do caderno. O Kanban é o mural na parede com os post-its das tarefas.

> **Sobre o idioma das ferramentas:** o VS Code pode estar em português ou em inglês, dependendo de como foi instalado, e o GitHub continua em inglês (a tela não é traduzida). Por isso, nos passos, o nome do botão ou do menu aparece em inglês, **exatamente como na tela**, e logo depois vem a tradução em português do Brasil para você entender o que está clicando. Se o seu VS Code já está em português, siga a versão em português.

## Mão na Massa

### Passo 1: confira o Git e instale a extensão Live Server

1. Abra o VS Code. Abra o terminal integrado: no menu **Terminal > New Terminal** (em português: **Terminal > Novo Terminal**). O atalho é Ctrl+` ou Ctrl+J (a tecla do acento grave, no Windows e no Mac).
2. No terminal, digite e aperte Enter:

```bash
git --version
```
Deve aparecer algo como `git version 2.43.0`. Se aparecer "comando não encontrado": no **Windows**, instale pelo site https://git-scm.com/download/win (aceite as opções padrão), feche e abra o VS Code de novo; no **Mac**, o próprio comando oferece instalar as ferramentas de desenvolvimento (clique em **Install**, em português: **Instalar**).

3. Instale o Live Server: clique no ícone de quadradinhos da barra lateral esquerda, **Extensions** (em português: **Extensões**), ou use Ctrl+Shift+X (no Mac, Cmd+Shift+X). Na busca digite `Live Server`, escolha a extensão de **Ritwick Dey** e clique em **Install** (em português: **Instalar**). Quando terminar, aparece o botão **Go Live** no canto inferior direito do VS Code.

### Passo 2: diga ao Git quem é você

No terminal (troque pelo seu nome e e-mail; use o mesmo e-mail da conta do GitHub):

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu-email@exemplo.com"
```

### Passo 3: crie o repositório no GitHub (uma integrante por equipe)

> Se você estuda sozinha, faça este passo na sua conta e pule o convite do item 4.

1. Entre em https://github.com e faça login (se não tiver conta, **Sign up**, em português: **Cadastre-se**).
2. No canto superior direito clique no botão **+** e depois em **New repository** (em português: **Novo repositório**).
3. Em **Repository name** (em português: **Nome do repositório**) escreva `vitrine-col`. Deixe **Public** (em português: **Público**) marcado. **Não** marque a opção **Add a README file** (em português: **Adicionar um arquivo README**). Clique em **Create repository** (em português: **Criar repositório**).
4. Convide as colegas: **Settings > Collaborators > Add people** (em português: **Configurações > Colaboradores > Adicionar pessoas**) e informe o nome de usuária de cada uma. Elas recebem um e-mail e precisam aceitar o convite.

### Passo 4: crie a pasta do projeto e os dois primeiros arquivos (a mesma integrante)

1. No computador, crie uma pasta chamada `vitrine-col` (por exemplo, dentro de Documentos).
2. No VS Code: **File > Open Folder...** (em português: **Arquivo > Abrir Pasta...**) e escolha a pasta `vitrine-col`. Se o VS Code perguntar se você confia nos autores dos arquivos desta pasta, clique em **Yes, I trust the authors** (em português: **Sim, eu confio nos autores**).
3. No painel **Explorer** (em português: **Explorador**), passe o mouse sobre o nome da pasta e clique no ícone **New File** (em português: **Novo Arquivo**). Crie os dois arquivos abaixo, colando o conteúdo e salvando com Ctrl+S (no Mac, Cmd+S).

**Arquivo: `README.md`** (arquivo novo, inteiro)

```markdown
# Vitrine Col

Plataforma web de moda local feita no curso **Jovem Programadora (Senac)**.

Clientes filtram roupas por tipo, tamanho e loja, juntam peças de lojas diferentes na mesma sacola e fazem um
pedido por loja, combinado pelo WhatsApp. Lojistas cadastram a loja e os produtos.

## Integrantes da equipe

- Nome da primeira integrante

## Como rodar

Abra a pasta no VS Code e clique em **Go Live** (extensão Live Server).
```


**Arquivo: `.gitignore`** (arquivo novo, inteiro)

```text
# Arquivos do sistema operacional
.DS_Store
Thumbs.db
desktop.ini

# Arquivos dos editores
.vscode/
.idea/

# Segredos e arquivos locais: nunca versionar
.env
.env.*
*.local

# Registros e temporários
*.log
*.tmp
*.bak
```


### Passo 5: faça o primeiro commit e envie para o GitHub

No terminal do VS Code (troque `SEU-USUARIO` pelo nome de usuária do GitHub):

```bash
git init
git branch -M main
git add .
git commit -m "Cria o README e o .gitignore"
git remote add origin https://github.com/SEU-USUARIO/vitrine-col.git
git push -u origin main
```

Na primeira vez, o Git pode abrir uma janela do navegador pedindo para você entrar no GitHub e autorizar: faça isso e volte ao VS Code. Depois, atualize a página do repositório no GitHub: os dois arquivos devem aparecer.

### Passo 6: as outras integrantes clonam e fazem o primeiro commit (uma de cada vez)

1. Cada integrante abre o terminal em uma pasta de trabalho (por exemplo, Documentos) e digita:

```bash
git clone https://github.com/SEU-USUARIO/vitrine-col.git
```
Depois abre a pasta `vitrine-col` criada: **File > Open Folder...** (em português: **Arquivo > Abrir Pasta...**).

2. Edite o `README.md` e troque a linha `- Nome da primeira integrante` pelo seu nome, acrescentando uma nova linha para cada integrante (uma de cada vez, para não bagunçar). Salve.
3. Faça o commit e o envio:

```bash
git add .
git commit -m "Adiciona meu nome ao README"
git pull
git push
```

   O `git pull` traz o que as colegas já enviaram antes de você enviar o seu. Se aparecer um conflito (o arquivo mostra trechos entre `<<<<<<<`, `=======` e `>>>>>>>`), apague essas três marcas e deixe as linhas de todas as pessoas no arquivo; depois faça `git add .`, `git commit -m "Resolve conflito no README"` e `git push`.

### Passo 7: monte o quadro Kanban

1. No repositório do GitHub, clique na aba **Projects** (em português: **Projetos**) e depois em **New project** (em português: **Novo projeto**).
2. Escolha o modelo **Board** (em português: **Quadro**), dê o nome `Kanban da equipe` e clique em **Create project** (em português: **Criar projeto**).
3. O quadro vem com as colunas **Todo** (em português: **A fazer**), **In Progress** (em português: **Em andamento**) e **Done** (em português: **Concluído**). Na coluna **Todo**, clique em **Add item** (em português: **Adicionar item**), escreva o título e aperte Enter. Crie **um cartão para cada requisito Essencial** do backlog da Aula 1, por exemplo: `RF-01 Listar os produtos em cards`.
4. Combine na equipe: quem pega um cartão arrasta para **In Progress** (em português: **Em andamento**); quando termina, arrasta para **Done** (em português: **Concluído**).

## Explicação do Código

- `git --version`: mostra a versão instalada. Serve só para provar que o Git existe.
- `git config --global user.name ...` e `user.email ...`: gravam o seu nome e e-mail para aparecerem em cada commit. O `--global` vale para todos os projetos deste computador, então só é preciso fazer uma vez.
- `README.md`: a "capa" do repositório. O GitHub mostra esse arquivo na página inicial. A extensão `.md` quer dizer *Markdown*: `#` vira título, `-` vira lista, e os asteriscos duplos `**` deixam o texto em **negrito**.
- `.gitignore`: lista de arquivos que o Git deve **ignorar**. Aqui ficam arquivos que o sistema operacional cria sozinho (`.DS_Store`, `Thumbs.db`), arquivos de configuração do editor e, o mais importante, arquivos de segredos (`.env`), que nunca devem ir para um repositório público.
- `git init`: transforma a pasta em um repositório (cria uma pasta escondida `.git` com o histórico).
- `git branch -M main`: chama a linha principal de histórico de `main`. Uma *branch* é uma linha de histórico; vamos usar várias no Dia 14.
- `git add .`: separa **todas** as mudanças (o ponto significa "tudo") para entrarem no próximo commit.
- `git commit -m "mensagem"`: grava o commit com a mensagem. Escreva no imperativo e em português ("Cria", "Adiciona", "Corrige").
- `git remote add origin URL`: diz ao Git qual é o endereço do repositório no GitHub. `origin` é só o apelido.
- `git push -u origin main`: envia os commits para o GitHub. O `-u` lembra o destino, então nas próximas vezes basta `git push`.
- `git clone URL`: baixa uma cópia completa do repositório (com o histórico) para o seu computador.
- `git pull`: traz os commits novos do GitHub. Faça sempre antes do `git push` quando mais gente mexe no mesmo repositório.
- **Kanban**: o quadro deixa visível quem faz o quê e evita duas pessoas fazendo a mesma tarefa.

## Validação

1. No terminal, digite `git log --oneline`. Deve aparecer pelo menos um commit seu, com a mensagem em português.
2. Abra a página do repositório no GitHub: devem aparecer `README.md` e `.gitignore`, e o README deve listar o nome de cada integrante já presente.
3. Abra a aba **Projects** (em português: **Projetos**): o quadro tem pelo menos 15 cartões, um para cada requisito Essencial.
4. No VS Code, o botão **Go Live** (em português: **Ir ao vivo**) aparece no canto inferior direito.

**Erros comuns**

1. *Mensagem:* `fatal: not a git repository`. *Causa:* o terminal está em uma pasta que não é a do projeto. *Correção:* confira que a pasta `vitrine-col` está aberta no VS Code e abra o terminal pelo menu **Terminal > New Terminal** (em português: **Terminal > Novo Terminal**) depois de abrir a pasta.
2. *Mensagem:* `error: failed to push some refs ... Updates were rejected`. *Causa:* alguém enviou commits antes de você. *Correção:* rode `git pull` e depois `git push` de novo.
3. *Mensagem:* `Author identity unknown` ou `Please tell me who you are`. *Causa:* o Passo 2 não foi feito. *Correção:* rode os dois comandos `git config --global ...` do Passo 2 e repita o `git commit`.
4. *Sintoma:* o commit foi feito, mas o arquivo não aparece no GitHub. *Causa:* faltou o `git push`. *Correção:* rode `git push`.

**Se travar**

1. Releia a mensagem de erro do terminal com calma: quase sempre ela diz o que falta.
2. Compare o que você digitou com o comando da aula, letra por letra (principalmente o endereço do repositório).
3. Use `git status` para ver o que o Git está vendo. Se você mexeu em um arquivo por engano, desfaça com `git restore nome-do-arquivo` (isso volta o arquivo ao último commit).
4. Só depois peça ajuda à sua equipe, colando a mensagem de erro exata e dizendo o que você já tentou.

**Seu projeto agora tem**

- `README.md` e `.gitignore` na pasta `vitrine-col`, versionados e enviados ao GitHub.
- Um commit de cada integrante no histórico.
- Um quadro Kanban com o backlog.
- O VS Code com o Git e a extensão Live Server funcionando.

**Como saber que deu certo:** o repositório no GitHub mostra o README com o nome de todas as integrantes e `git log --oneline` mostra os commits de cada uma.
