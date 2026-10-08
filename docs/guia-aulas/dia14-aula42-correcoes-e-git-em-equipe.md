# Aula 42 – Correções, refinamento da interface e Git em equipe

**Dia 14 · Seg 26/10/2026** · **Aula 42** · **UC3**

- **Requisitos cobertos:** RF-21 (nenhuma tela em branco: mensagens claras de erro e de carregamento) e o que mais os testes apontarem; práticas de versionamento (branch por funcionalidade, pull request revisado por outra integrante)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** docs/TESTES.md preenchido, com a lista de defeitos em cartões do Kanban e a gravidade de cada um (Aula 41); repositório no GitHub com o histórico da equipe

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **corrigir os defeitos mais graves** da lista da Aula 41 trabalhando do jeito de equipes profissionais: **uma branch por correção**, um **pull request** (pedido para juntar o trabalho) **revisado por outra integrante** e **merge** (a junção) na `main`. Também faz uma **revisão de código** com uma lista de conferência.

**Abertura (10 minutos).** Retomada da Aula 41: a lista de defeitos tem cartões **críticos**, **importantes** e **desejáveis**. Hoje a equipe ataca os críticos e os importantes. Se todo mundo editar os mesmos arquivos ao mesmo tempo e enviar direto para a `main`, vão acontecer conflitos e correções que quebram o que já funcionava. O Git tem um jeito de evitar isso.

## O Conceito

**Termos desta aula**

- **Branch (ramo)**: uma linha de histórico **paralela**, onde você faz mudanças **sem mexer na `main`** até ter certeza. Uma branch por funcionalidade ou correção, com nome descritivo: `correcao-preco-sacola`.
- **Merge (junção)**: trazer as mudanças de uma branch para outra (normalmente para a `main`).
- **Pull request (PR)**: no GitHub, um **pedido** para juntar a sua branch na `main`, onde as colegas **veem as mudanças**, comentam e aprovam.
- **Revisão de código (code review)**: uma colega **lê** o que você mudou, procurando erros e fora do padrão, antes de entrar na `main`.
- **Conflito**: quando duas pessoas mudam a **mesma linha** e o Git não sabe qual vale; é preciso escolher à mão.

**Analogia:** a `main` é o **livro publicado**. A sua branch é o **rascunho do capítulo**: você escreve à vontade; o pull request é o **envio para a editora**, que **revisa**; só depois o capítulo entra no livro.

**Regras do projeto:** commits **pequenos**, com mensagem em português no imperativo ("Corrige o total da sacola"); uma branch por correção; **nenhum commit direto na `main`** a partir de hoje.

## Mão na Massa

### Passo 1: escolha e distribua os defeitos (5 minutos)

No Kanban, escolha os cartões **críticos** e **importantes**. Cada integrante assume **um** (mova o cartão para **In Progress**, em português: **Em andamento**). Quem ficou sem defeito pode corrigir um **desejável** ou fazer a revisão de código do Passo 5. Se a sua lista de defeitos estiver vazia ou curta, use o exercício abaixo (troque o e-mail de contato) como a sua correção.

### Passo 2: crie uma branch para a correção

No terminal do VS Code, na pasta do projeto:

```bash
git switch main
git pull
git switch -c correcao-nome-do-defeito
```

O primeiro comando volta para a `main`; o segundo traz as novidades da equipe; o terceiro **cria** a branch `correcao-nome-do-defeito` e já passa a trabalhar nela. (Em versões antigas do Git use `git checkout -b correcao-nome-do-defeito`.) Confira com `git branch`: a branch atual tem um `*`.

**Exercício de apoio (se não tiver defeito):** em `js/config.js`, troque `EMAIL-DA-EQUIPE@exemplo.com` pelo e-mail real da equipe (é o que a página de privacidade mostra). Use o nome de branch `correcao-email-de-contato`.

### Passo 3: corrija, teste e faça commits pequenos

1. Reproduza o defeito (Aula 41), corrija o código e teste: **o caso de teste que falhou precisa passar** e o fluxo ao redor não pode quebrar.
2. Faça o commit **da correção**, com uma mensagem clara:

```bash
git add .
git commit -m "Corrige o e-mail de contato da página de privacidade"
```

3. Envie a branch ao GitHub:

```bash
git push -u origin correcao-nome-do-defeito
```

### Passo 4: abra o pull request e peça a revisão

1. No GitHub, aparece uma faixa amarela **Compare & pull request** (em português: **Comparar e criar pull request**). Clique nela (ou vá em **Pull requests** > **New pull request**, em português: **Pull requests > Novo pull request**).
2. Escreva um **título** claro e, na descrição, **o que mudou**, **qual defeito corrige** (cite o caso CT-xx) e **como testar**.
3. No painel da direita, em **Reviewers** (em português: **Revisores**), escolha **outra integrante**. Clique em **Create pull request** (em português: **Criar pull request**).
4. A revisora abre a aba **Files changed** (em português: **Arquivos alterados**), lê o que mudou (linhas verdes entraram, vermelhas saíram) e, se estiver bom, clica em **Review changes** (em português: **Revisar alterações**) > **Approve** (em português: **Aprovar**) > **Submit review** (em português: **Enviar revisão**). Se achar um problema, clica no `+` ao lado da linha e deixa um comentário.
5. Com a aprovação, quem abriu o PR clica em **Merge pull request** (em português: **Mesclar pull request**) e **Confirm merge** (em português: **Confirmar merge**). Depois, **Delete branch** (em português: **Excluir branch**).
6. No terminal, atualize a `main` do seu computador:

```bash
git switch main
git pull
git branch -d correcao-nome-do-defeito
```

### Passo 5: faça a revisão de código com a lista de conferência

Em dupla, abram o projeto e confiram cada item (use **Ctrl+Shift+F**, em português: **Localizar nos arquivos**, no Mac Cmd+Shift+F). Cada item que falhar vira uma correção em uma branch.

| Item | Como conferir |
| --- | --- |
| Nomes em português, sem acento | arquivos, variáveis, funções e tabelas; `camelCase` no JavaScript e `snake_case` no banco |
| Comentários em português que explicam o **porquê** | leia as funções mais complexas (`sacola.js`, `produtoServico.js`) |
| Um arquivo por responsabilidade | páginas só chamam serviços; serviços falam com o Supabase; classes só guardam regras |
| **Nenhum `innerHTML` com dados** | procure `innerHTML` em `js/`: **0 resultados** |
| **Nenhum segredo no código** | procure `service_role` e `secret` em todo o projeto: **0 chaves** (só o comentário do `config.js`) |
| Mensagens em português | procure textos em inglês nas telas e nos `ErroApp` |
| Toda chamada ao banco avisa **Carregando…** e trata erro | páginas: `mostrarCarregando`, `try/catch` e `mostrarErro(mensagemDoErro(erro))` |
| Valores em R$ e datas `dd/mm/aaaa` | confira cards, sacola e pedidos |
| Código repetido em um lugar só | `criarElemento`, `telefoneValido`, `registrarErro` |

### Passo 6 (opcional, em dupla): resolva um conflito de propósito

Para perder o medo de conflitos: duas integrantes criam, **cada uma a sua branch**, e mudam **a mesma linha** do `README.md` (por exemplo, o título). A primeira faz o merge no GitHub. A segunda, ao abrir o PR, vê **This branch has conflicts** (em português: **Esta branch tem conflitos**): clica em **Resolve conflicts** (em português: **Resolver conflitos**), escolhe como a linha deve ficar (apagando as marcas `<<<<<<<`, `=======` e `>>>>>>>`), **Mark as resolved** (em português: **Marcar como resolvido**) e **Commit merge** (em português: **Fazer o commit do merge**).

### Passo 7: confira o histórico

```bash
git log --oneline --graph
```

Você vê os commits das branches e os pontos onde elas foram juntadas na `main`.

## Explicação do Código

Esta aula é sobre **processo**, então explicamos cada comando e cada decisão:

- `git switch main`: troca para a branch `main`. `git switch -c nome`: cria e troca. `git branch`: lista as branches (a atual tem `*`). `git branch -d nome`: apaga a branch local já juntada.
- `git pull`: traz as novidades da `main` do GitHub. Faça **sempre** antes de criar uma branch, para ela nascer da versão mais nova.
- `git push -u origin nome`: envia a branch ao GitHub e lembra o destino.
- **Por que uma branch por correção?** Se duas correções estiverem juntas e uma delas der problema, não dá para "desfazer só uma". Separadas, cada uma entra (ou sai) sozinha.
- **Por que outra pessoa revisa?** Quem escreveu o código **não enxerga** os próprios erros. Uma revisora vê o que ficou implícito e confere o padrão. É também uma forma de a equipe **aprender o código** das colegas.
- **Mensagens de commit** em português, no imperativo e específicas ("Corrige o total da sacola ao remover item") ajudam a achar uma mudança depois.
- **Revisão de código**: a lista confere o que o projeto exige: nomes, comentários, responsabilidades, segurança (sem `innerHTML` com dados, sem segredos), mensagens em português.

## Validação

1. Cada defeito corrigido tem uma branch, um pull request com revisão aprovada e o merge na `main`; o cartão correspondente foi para **Done** (em português: **Concluído**).
2. O caso de teste que falhou **passa** agora (atualize o `docs/TESTES.md`: troque `FALHOU` por `OK` e anote a data).
3. A busca por `innerHTML` em `js/` mostra **0 resultados** e a busca por `service_role` não encontra chave nenhuma.
4. `git log --oneline --graph` mostra as branches e os merges, com commits de várias integrantes.

**Erros comuns**

1. *Mensagem:* `error: Your local changes to the following files would be overwritten by checkout` ao trocar de branch. *Causa:* há mudanças não salvas no Git. *Correção:* faça `git add .` e `git commit` na branch atual (ou `git stash` para guardá-las) e tente de novo.
2. *Mensagem:* `fatal: a branch named '...' already exists`. *Causa:* o nome já existe. *Correção:* escolha outro nome, ou `git switch nome` para voltar a ela.
3. *Sintoma:* o PR mostra mudanças que não são suas. *Causa:* a branch nasceu de uma `main` desatualizada. *Correção:* rode `git pull` na `main`, depois `git switch sua-branch` e `git merge main`.
4. *Mensagem:* `CONFLICT (content): Merge conflict in ...`. *Causa:* duas pessoas mudaram a mesma linha. *Correção:* abra o arquivo, escolha o texto que vale, apague as marcas `<<<<<<<`, `=======` e `>>>>>>>`, depois `git add .` e `git commit`.

**Se travar**

1. Rode `git status`: ele diz em qual branch você está e o que mudou.
2. Para desfazer uma mudança ainda não commitada em um arquivo: `git restore nome-do-arquivo`.
3. Para voltar a um estado seguro, troque para a `main` (`git switch main`) e crie a branch de novo.
4. Só depois peça ajuda à sua equipe, colando a saída do `git status` e a mensagem de erro.

**Seu projeto agora tem**

- Os defeitos mais graves corrigidos na `main`, cada um com a sua branch e o seu pull request revisado.
- Um histórico organizado (`git log --oneline --graph`) e uma lista de conferência de código aplicada.
- O `docs/TESTES.md` atualizado com os casos que passaram a `OK`.

**Como saber que deu certo:** você abre um pull request, uma colega aprova, e a correção entra na `main` sem quebrar nenhum caso que já passava.
