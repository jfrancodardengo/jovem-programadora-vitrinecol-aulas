# Aula 80 – Testes com usuárias reais

**Dia 27 · Sex 13/11/2026** · **Aula 80** · **UC6**

- **Requisitos cobertos:** RF-10 (finalizar a sacola gerando um pedido por loja e o botão de WhatsApp), RF-11 (a cliente vê os seus pedidos), RF-20 (a lojista vê e atualiza os pedidos) e RF-22 (a cliente é avisada da mudança) no fluxo completo, mais a meta de usabilidade de até 6 ações do catálogo ao pedido
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** casos de teste executados no site publicado, dados de teste e roteiro de usabilidade prontos (Aula 79)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **receber usuárias externas** (de outras turmas, convidadas ou lojistas parceiras), **observá-las sem ajudar** enquanto usam o sistema, anotar **onde travam, quanto tempo levam e quantas ações usam**, e registrar **cada problema** com a tela e o passo. A meta é **pelo menos 5 usuárias**.

**Abertura (10 minutos).** Retomada da Aula 79: vocês testaram o sistema como **donas** dele. Hoje quem testa é quem **nunca o viu**. A parte mais difícil é **ficar quieta**: quando a usuária travar, a vontade é ajudar, mas é aí que o teste mostra algo valioso. Combinem os papéis de cada sessão: **condutora** (lê a tarefa e faz as perguntas finais), **observadora** (anota na tabela, em silêncio) e **cronometrista** (mede o tempo). Preparem 3 a 5 estações (computador ou celular, com o site aberto na **página inicial** e a sacola **vazia**).

## O Conceito

**Termos desta aula**

- **Teste de usabilidade**: observar pessoas **reais** usando o sistema para descobrir o que é difícil. Não testa a pessoa: testa o **sistema**.
- **Observar sem ajudar**: a condutora **não** explica, **não** aponta e **não** corrige. Se a usuária pedir ajuda, diga: "Faça como faria sozinha, em casa."
- **Pensar em voz alta**: pedir que a usuária **fale** o que está pensando. É assim que a equipe descobre por que ela clicou onde clicou.
- **Consentimento**: antes de começar, a usuária concorda em participar. A equipe **não** guarda dados pessoais (só o primeiro nome e o perfil: já usou lojas on-line?).

**Analogia:** é a **degustação** de uma receita: você serve a quem nunca a provou e **observa o rosto**, sem explicar o tempero. O que ela estranhar vira ajuste.

**Regras do teste:** cada sessão dura **de 8 a 10 minutos**: acolhida (1 min), tarefa (5 min), perguntas finais (2 min). Todas as usuárias recebem **a mesma tarefa** (do roteiro da Aula 79) para os resultados poderem ser comparados.

## Mão na Massa

### Passo 1: prepare as estações e o roteiro (5 minutos)

1. Em cada estação: o site publicado aberto na **página inicial**, uma conta de **cliente** de teste já criada (ou, para testar também o cadastro, **sem** conta), e o roteiro da Aula 79 impresso ou aberto.
2. Cada observadora tem **uma cópia da tabela de observação** (tarefa, tempo, ações, onde hesitou, erros, se concluiu sozinha, comentários) e as **3 perguntas finais**.
3. Combine o **sinal** para a condutora **não** falar: observadora de braços cruzados significa "silêncio".

### Passo 2: acolha a usuária e leia o consentimento

Diga, com as suas palavras: "Vamos testar **o sistema**, não você. Não existe resposta errada. Pode parar a qualquer momento. Eu **não vou poder ajudar** durante a tarefa: faça como faria em casa e fale em voz alta o que está pensando. Pode ser? Anotamos só o seu primeiro nome e se você já comprou roupa pela internet." Só comece depois do "sim".

### Passo 3: aplique a tarefa e observe (5 minutos por sessão)

1. A condutora lê a tarefa **em voz alta**, sem explicar:

> "Você quer comprar **um vestido** e **uma camiseta** de duas lojas diferentes. Escolha as peças, junte tudo e faça o pedido. Fale em voz alta o que está pensando."

2. A cronometrista **dispara** o tempo quando a usuária começa e **para** quando ela chega ao botão do WhatsApp do pedido (ou desiste).
3. A observadora anota **sem falar**: cada clique ou escolha (conte as **ações**), onde a usuária **hesita** (mais de 5 segundos olhando sem clicar), cliques no lugar errado, mensagens de erro que aparecem, e frases dela entre aspas.
4. Se a usuária travar por mais de **2 minutos**, a condutora pergunta apenas: "O que você está procurando?" e anota a resposta (isso conta como **ajuda**).
5. Quando a usuária terminar ou desistir, a condutora faz as **perguntas finais**: 1) O que foi mais fácil? 2) O que foi confuso? 3) O que você mudaria?

### Passo 4: registre cada problema na hora

Logo depois de cada sessão (antes da próxima usuária), a observadora passa a limpo, em uma tabela única da equipe, **um problema por linha**:

| Nº | Tela | Passo | O que aconteceu | Usuária (primeiro nome) | Frase dela |
| --- | --- | --- | --- | --- | --- |
| 1 | produto | escolher o tamanho | procurou o tamanho por 15 segundos, clicou na foto | Ana | "Cadê o tamanho?" |

Escreva **a tela e o passo** com precisão (a Aula 81 usa esta tabela). Registre também as sessões que **correram bem**: "concluiu em 6 ações e 2 minutos, sem hesitar" é um resultado importante.

### Passo 5: faça uma rodada com a lojista (se houver lojista parceira ou colega)

Se alguma participante for **lojista**, aplique uma segunda tarefa: "Entre como lojista, cadastre um produto com uma foto e **confirme** um pedido com um recado para a cliente." Meça o tempo e anote onde travou (painel, formulário de produto, fotos, pedidos recebidos).

### Passo 6: junte os números e faça o commit

Ao fim, some os resultados (quantas usuárias, quantas concluíram sozinhas, tempo médio, média de ações) e guarde a tabela de observação no repositório, em um arquivo de texto ou planilha exportada, na pasta `docs/` (sem nomes completos nem dados pessoais):

```bash
git add .
git commit -m "Registra as anotações dos testes de usabilidade com usuárias externas"
git push
```

## Explicação do Código

Sem código hoje; veja por que cada regra do teste existe:

- **Mesma tarefa para todas:** só assim dá para **comparar** (se 4 de 5 hesitam no mesmo passo, o problema é do sistema, não da pessoa).
- **Pensar em voz alta:** "cadê o tamanho?" diz mais que "ela demorou 15 segundos".
- **Não ajudar:** o que parece óbvio para a equipe (que **conhece** o sistema) não é para quem nunca o viu. O teste serve justamente para revelar isso.
- **Contar as ações:** é um número objetivo. A meta é **até 6 ações por loja** (abrir o produto, escolher o tamanho, adicionar, abrir a sacola, finalizar, clicar no WhatsApp). Para duas lojas o caminho tem mais ações, mas deve ser proporcional (o login, se for preciso, conta como ações a mais; se muitas usuárias gastam **mais de 10**, há passos demais).
- **Registrar tela e passo:** um problema só pode ser corrigido se alguém consegue **reproduzi-lo**.
- **Consentimento e sem dados pessoais:** respeita a **LGPD** e a privacidade das pessoas que ajudam o projeto.

## Validação

1. A equipe testou com **pelo menos 5 usuárias externas** (que não são da equipe).
2. Cada sessão tem a tabela de observação preenchida: tempo, ações, onde hesitou, erros, se concluiu sozinha e comentários.
3. Cada problema está registrado com **tela e passo**.
4. Os números (quantas concluíram sozinhas, tempo médio e média de ações) foram calculados.

**Erros comuns**

1. *Sintoma:* a condutora ajudou sem perceber ("é só clicar ali"). *Causa:* vontade de ajudar. *Correção:* o sinal combinado (observadora de braços cruzados); anote que houve ajuda e em que passo, e continue.
2. *Sintoma:* a usuária desistiu logo e a sessão acabou em 1 minuto. *Causa:* a tarefa estava confusa ou o site estava fora do ar. *Correção:* confira se o site funciona e se a tarefa foi lida em voz alta, palavra por palavra; refaça com a usuária seguinte.
3. *Sintoma:* os dados de teste acabaram (a sacola já tem itens de outra pessoa). *Causa:* a estação não foi limpa. *Correção:* esvazie a sacola e volte à página inicial entre as sessões.
4. *Sintoma:* os problemas foram anotados sem a tela e o passo. *Causa:* correria. *Correção:* complete na hora, enquanto a equipe ainda lembra.

**Se travar**

1. Se o site cair no meio da sessão, anote o horário e a mensagem de erro; é um **defeito crítico**.
2. Se faltar gente para as 5 sessões, convide colegas de outras turmas; cada sessão leva só 10 minutos.
3. Se as observadoras discordam sobre o que viram, confiem na **tabela** e nas frases ditas pela usuária.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- As anotações de **pelo menos 5 usuárias externas**, com os números do teste.
- Uma lista de problemas, com tela e passo, pronta para a priorização (Aula 81).

**Como saber que deu certo:** a equipe sabe dizer, com números e frases das usuárias, em qual tela e em qual passo as pessoas travaram.
