# Aula 81 – Registro dos feedbacks e priorização das correções

**Dia 27 · Sex 13/11/2026** · **Aula 81** · **UC6**

- **Requisitos cobertos:** CT-01 a CT-25 (consolidação do relatório de testes com OK, FALHOU e N/A) e os requisitos afetados pelos problemas encontrados
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** casos de teste executados no site publicado, anotações de pelo menos 5 usuárias externas e a lista de problemas com tela e passo (Aulas 79 e 80)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **reunir os problemas** do teste em uma tabela (tela, o que aconteceu, gravidade), **priorizar** em **crítico, importante e desejável**, **definir quem corrige o quê** e **consolidar o relatório de testes** (OK, FALHOU e N/A).

**Abertura (10 minutos).** Retomada da Aula 80: vocês têm muitas anotações soltas: do plano de testes (Aula 79) e das usuárias (Aula 80). Se a equipe corrigir tudo ao mesmo tempo, o prazo estoura; se corrigir só o que "parece fácil", os problemas graves ficam. Hoje a equipe **decide o que corrigir primeiro, e quem corrige**. A Aula 82 (amanhã, no Dia 28) começa pelo primeiro item da lista.

## O Conceito

**Termos desta aula**

- **Feedback**: o que as usuárias disseram e fizeram: frases, hesitações, erros. É **matéria-prima**: ainda não é uma tarefa.
- **Gravidade**: o quanto o problema atrapalha. **Crítico**: impede o fluxo principal (escolher, juntar, finalizar, WhatsApp, entrar) ou quebra a **segurança** dos dados. **Importante**: atrapalha, mas há um jeito de contornar. **Desejável**: detalhe ou melhoria.
- **Priorização**: ordenar o que será corrigido, pela **gravidade** e pelo **número de pessoas afetadas** (um problema que 4 de 5 usuárias tiveram vem antes de um que 1 teve).
- **Relatório de testes**: o documento que resume o que foi testado, o resultado e o que será feito. É uma das **evidências** da UC6 (**Marco 8**).

**Analogia:** é a **triagem de um pronto-socorro**: todo mundo é atendido, mas quem está com o problema mais grave é visto primeiro. O quadro de prioridades diz quem entra agora e quem espera.

**Regra de ouro:** quem **descobriu** o problema não precisa ser quem **corrige**. Distribua conforme os papéis (front-end, banco, conteúdo), e toda correção ganha **dono, prazo e caso de teste** para refazer.

## Mão na Massa

### Passo 1: crie o relatório de testes

Crie o arquivo `docs/relatorio-de-testes.md` com este modelo e preencha o cabeçalho (versão, endereço, período e equipe):

**Arquivo: `docs/relatorio-de-testes.md`** (arquivo novo, inteiro)

```markdown
# Relatório de testes: VitrineCol

| | |
| --- | --- |
| Versão testada | |
| Endereço do site | |
| Período dos testes | |
| Equipe | |

## 1. Resumo dos casos de teste (CT-01 a CT-25)

| Total de casos | OK | FALHOU | N/A |
| --- | --- | --- | --- |
| 25 | | | |

Casos que **falharam**, com o requisito afetado e a decisão:

| Caso | O que falhou | Requisito | Decisão (corrigir agora, depois ou não corrigir) |
| --- | --- | --- | --- |
| | | | |

## 2. Testes de usabilidade com usuárias reais

| Item | Resultado |
| --- | --- |
| Quantidade de usuárias externas | (mínimo: 5) |
| Quantas concluíram o pedido sozinhas | |
| Tempo médio do catálogo ao pedido | |
| Média de ações do catálogo ao pedido (meta: até 6 por loja) | |

## 3. Problemas encontrados

| Nº | Tela | Passo | O que aconteceu | Quantas usuárias | Gravidade | Quem corrige | Situação |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | | | | | | | |

**Gravidade:** `crítico` (impede o fluxo principal ou a segurança), `importante` (atrapalha, mas há um jeito) ou `desejável` (detalhe).

## 4. Lista priorizada de correções

| Ordem | Problema (nº da tabela 3) | Gravidade | Responsável | Prazo (aula) |
| --- | --- | --- | --- | --- |
| 1 | | crítico | | Aula 82 |

## 5. Riscos e decisões registradas

- Confirmação de e-mail do Supabase (ligada ou desligada e por quê):
- Limite de e-mails por hora observado:
- O que **não** será feito na versão 1.0 e por quê:
```


### Passo 2: consolide os casos de teste (seção 1) (10 minutos)

1. Conte no `docs/TESTES.md` quantos casos deram `OK`, `FALHOU` e `N/A` e preencha a tabela da seção 1. **N/A deve ser zero** (a Aula 79 pediu isso); se sobrou, execute o caso agora.
2. Para cada caso `FALHOU`, preencha a tabela de baixo: **o que falhou**, o **requisito** (RF ou RN, em palavras, por exemplo "RF-10, finalizar gerando um pedido por loja") e a **decisão**.

### Passo 3: some os números da usabilidade (seção 2) (5 minutos)

Com as tabelas de observação da Aula 80, calcule: quantas usuárias testaram, **quantas concluíram sozinhas**, o **tempo médio** do catálogo ao pedido e a **média de ações**. Compare com a meta (**até 6 ações** por loja).

### Passo 4: reúna os problemas em uma tabela só (seção 3) (15 minutos)

1. Junte, **em uma tabela única**, os problemas das duas fontes: casos que falharam e problemas das usuárias. **Agrupe os repetidos**: se 3 usuárias travaram no mesmo lugar, vira **uma** linha com "3 usuárias".
2. Para cada linha, preencha: **Tela**, **Passo**, **O que aconteceu**, **Quantas usuárias** e **Gravidade**.
3. Classifique a **gravidade** com estas perguntas, nesta ordem:

| Pergunta | Se a resposta for sim |
| --- | --- |
| Impede a cliente de montar a sacola, finalizar ou chegar ao WhatsApp? Ou expõe ou permite alterar dados que não deveria? | **crítico** |
| A usuária conseguiu o que queria, mas demorou, errou ou ficou em dúvida? | **importante** |
| É estética, texto ou melhoria que não atrapalha o fluxo? | **desejável** |

4. Se a equipe discordar da gravidade, **vence a mais alta** até conversar com todas.

### Passo 5: priorize e distribua (seção 4) (10 minutos)

1. Ordene a **lista priorizada**: primeiro todos os **críticos** (os que mais usuárias tiveram, antes), depois os **importantes**, por último os **desejáveis**.
2. Escreva ao lado de cada item o **responsável** (um nome só) e o **prazo** em aula: os críticos entram na **Aula 82** e os importantes na **Aula 83** (junto com a revisão de segurança) ou no tempo que sobrar. **Combine um limite**: cada integrante assume **no máximo 2 itens** na Aula 82.
3. Crie um cartão no quadro Kanban para cada item (**título**: `[crítico] tela: problema`; **descrição**: tela, passo, caso de teste a repetir, quem corrige).
4. **O que não será feito na versão 1.0** vai para a seção 5 do relatório, com o motivo (por exemplo, "pagamento on-line: fora do escopo do curso"). Registre também a decisão sobre a **confirmação de e-mail** do Supabase e o **limite de e-mails** (Aula 79).

### Passo 6: faça o commit da aula

```bash
git add .
git commit -m "Consolida o relatório de testes e a lista priorizada de correções"
git push
```

## Explicação do Código

Sem código hoje; entenda cada parte do relatório:

- **Seção 1 (casos de teste):** mostra **o que foi verificado** e o resultado, com o requisito afetado em cada falha. É a prova de que o sistema foi testado de ponta a ponta.
- **Seção 2 (usabilidade):** os **números** (conclusão, tempo, ações) comparados com a **meta de 6 ações**. Números vencem opiniões nas discussões da equipe.
- **Seção 3 (problemas):** o inventário. Agrupar os repetidos mostra **o que mais afeta as pessoas**.
- **Seção 4 (priorização):** a ordem de ataque, com **dono** e **prazo**. Sem dono, ninguém corrige.
- **Seção 5 (riscos e decisões):** o que **não** será feito e por quê (escopo), mais a decisão sobre e-mail e limites. Registrar protege a equipe: depois ninguém precisa lembrar "por que não fizemos isso".
- **Critério de gravidade em perguntas:** evita discussão sem fim. "Impede o fluxo principal?" é uma pergunta que se responde com **sim** ou **não**.
- **Limite de itens por pessoa:** com tempo curto, é melhor corrigir **menos coisas bem** (com teste e revisão) do que muitas pela metade.

## Validação

1. O `docs/relatorio-de-testes.md` tem as 5 seções preenchidas.
2. A seção 1 mostra os 25 casos contados (sem `N/A`) e cada falha explicada.
3. A seção 3 tem cada problema com tela, passo, número de usuárias e gravidade.
4. A seção 4 tem a lista **ordenada**, com responsável e prazo, e cada item é um cartão no Kanban.
5. A seção 5 registra o que **não** entra na versão 1.0 e a decisão sobre a confirmação de e-mail.

**Erros comuns**

1. *Sintoma:* tudo ficou **crítico**. *Causa:* medo de deixar algo para depois. *Correção:* use as perguntas do Passo 4: só é crítico o que **impede o fluxo principal** ou afeta **segurança**.
2. *Sintoma:* problemas repetidos em linhas separadas. *Causa:* cada observadora anotou o seu. *Correção:* agrupe e escreva "3 usuárias".
3. *Sintoma:* itens sem responsável ("a equipe corrige"). *Causa:* ninguém quis assumir. *Correção:* distribua em reunião rápida, **um nome** por item.
4. *Sintoma:* a lista tem 25 itens para um único dia. *Causa:* não houve corte. *Correção:* mantenha **só os críticos e os importantes** para a Aula 82 e 83; passe o resto para "não será feito na 1.0" com o motivo.

**Se travar**

1. Releia a tabela de gravidade e responda às três perguntas, na ordem, para o item em dúvida.
2. Se a equipe não chegar a um acordo, use o número de usuárias afetadas como critério de desempate.
3. Se a lista ficou grande demais, volte ao Passo 5 e corte.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- O `docs/relatorio-de-testes.md` completo, uma das evidências do **Marco 8**.
- Uma lista **priorizada** de correções com responsável e prazo, e os cartões correspondentes no Kanban.

**Como saber que deu certo:** cada integrante sabe **qual correção é dela**, em **que aula** e **qual caso de teste** vai repetir para provar que corrigiu.
