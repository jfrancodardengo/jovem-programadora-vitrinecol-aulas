# Aula 82 – Correção dos problemas críticos

**Dia 28 · Seg 16/11/2026** · **Aula 82** · **UC6**

- **Requisitos cobertos:** RF-21 (nenhuma tela em branco: mensagem em português para carregamento, erro e sucesso) e os RF dos casos de teste que falharam e dos problemas críticos da lista priorizada (Aula 81)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** relatório de testes e lista priorizada de correções, com responsável e prazo, e os cartões no Kanban (Aula 81); repositório com a main atualizada

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **reproduzir** cada problema crítico, **corrigir em uma branch**, **refazer o caso de teste** e passar pela **revisão de código** de outra integrante. Também vai **revisar as mensagens de erro e as telas sem resposta**, para que **nenhuma tela fique em branco**.

**Abertura (10 minutos).** Retomada da Aula 81: a equipe tem uma lista priorizada, e cada integrante tem os seus itens. Hoje **só os críticos**: o que impede o fluxo principal ou a segurança. Releia o seu cartão: tela, passo, o que aconteceu e qual caso de teste vai repetir. O objetivo de hoje não é "mexer no código": é **provar que o problema acabou**.

## O Conceito

**Termos desta aula**

- **Reproduzir**: fazer o problema acontecer **de novo**, seguindo os passos anotados. Se você não consegue reproduzir, não consegue saber se corrigiu.
- **Correção mínima**: mudar **o menos possível** para resolver. Corrigir um problema e "aproveitar" para mexer em outras coisas cria problemas novos.
- **Teste de regressão**: depois de corrigir, refazer o caso que falhava **e** os casos que passavam e tocam o mesmo código, para ver se nada quebrou.
- **Tela em branco**: uma tela que não mostra nada nem diz o que houve (no Console há um erro, mas a pessoa não vê). Quebra o RF-21.

**Analogia:** é o **conserto de um carro** na oficina: o mecânico primeiro **repete o barulho** (reproduz), troca **só a peça** com defeito, e dá uma **volta de teste** para conferir que o barulho sumiu e nada novo apareceu.

**Roteiro de cada correção:** reproduzir → branch → corrigir → testar o caso → testar o que está ao redor → commit → pull request → revisão → merge → marcar o caso como `OK`.

## Mão na Massa

### Passo 1: corrija o seu problema crítico, um de cada vez (25 minutos)

Para **cada** item crítico que é seu:

1. **Reproduza** seguindo o cartão. Anote a mensagem do Console (F12 > **Console**, em português: **Console**) e do pedido que falhou (aba **Network**, em português: **Rede**).
2. **Crie a branch:**

```bash
git switch main
git pull
git switch -c correcao-nome-do-problema
```

3. **Ache a causa.** Comece pelo Console: ele mostra o arquivo e a linha. Use **Ctrl+Shift+F** (em português: **Localizar nos arquivos**; no Mac Cmd+Shift+F) para achar o texto da mensagem ou o nome da função. Em dúvida entre tela e banco: se o pedido na aba **Network** (em português: **Rede**) tem erro, o problema é do banco ou da regra; se o pedido deu certo, é da tela.
4. **Corrija o mínimo.** Se a correção está em uma **regra de negócio** (preço, estoque, status), o lugar certo é a **classe** ou o **serviço**, não a página.
5. **Teste:** repita **exatamente** os passos do caso (CT-xx) no seu computador: precisa dar o **resultado esperado**. Depois teste o que está ao redor (por exemplo, se mexeu na sacola, refaça CT-04, CT-05 e CT-07).
6. **Commit** pequeno, com mensagem clara, e envio:

```bash
git add .
git commit -m "Corrige o problema X na tela Y"
git push -u origin correcao-nome-do-problema
```

7. **Pull request:** abra no GitHub (**Compare & pull request**, em português: **Comparar e criar pull request**), cite o **caso de teste** e o **cartão do Kanban** e peça a revisão de **outra integrante** (Aula 42).

### Passo 2: faça a revisão de código de um PR de outra integrante (10 minutos)

Ao revisar, abra **Files changed** (em português: **Arquivos alterados**) e confira, linha por linha:

- [ ] A mudança é **mínima** e resolve **o problema do cartão** (nada de mudanças soltas).
- [ ] Nomes em português sem acento; comentários explicam o **porquê**.
- [ ] Nenhum `innerHTML` com dados; nenhum segredo; nenhum `console.log` de teste esquecido.
- [ ] Mensagens ao usuário em **português**.
- [ ] A regra continua em **um só lugar** (sem código copiado).
- [ ] Os passos de teste do PR foram feitos (peça para ver a tela ou o resultado).

Aprove (**Approve**, em português: **Aprovar**) ou comente. Depois do **merge**, quem corrigiu atualiza a `main` (`git switch main` e `git pull`) e a dupla **refaz o caso** no site publicado (a publicação leva alguns minutos). Atualize o `docs/TESTES.md` (`FALHOU` vira `OK`, com data) e mova o cartão para **Done** (em português: **Concluído**).

### Passo 3: revise as mensagens de erro e as telas sem resposta (15 minutos)

Divida as 15 telas entre as duplas. Em cada uma, **provoque** os estados abaixo e confira que **sempre aparece uma mensagem em português** (nunca uma tela em branco, nunca texto em inglês):

| Tela | Estado a provocar | Esperado |
| --- | --- | --- |
| `index.html` | **Offline** (aba **Rede**) e recarregar | uma mensagem de erro; o que carregou continua |
| `catalogo.html` | **Offline**; filtro sem resultado | erro em português; "Nenhum produto encontrado." |
| `loja.html` | `loja.html?id=abc` | "Loja não encontrada." com link para o catálogo |
| `produto.html` | `produto.html?id=abc`; produto sem estoque | "Produto não encontrado."; "sem estoque no momento" |
| `sacola.html` | sacola vazia; **Offline** ao finalizar | "Sua sacola está vazia"; erro sem esvaziar a sacola |
| `login.html` | senha errada; **Offline** | "E-mail ou senha incorretos."; erro de conexão |
| `cadastro.html` | e-mail repetido; senha curta | erros ao lado dos campos |
| `recuperar-senha.html` | link já usado | "Este link não vale mais..." |
| `privacidade.html` | abrir | texto e e-mail de contato |
| `minha-conta.html` | sem login; sem digitar EXCLUIR | vai ao login; "Digite EXCLUIR para confirmar." |
| `meus-pedidos.html` | cliente sem pedidos; **Offline** | mensagem de lista vazia; erro em português |
| `painel-loja.html` | lojista sem loja; **Offline** | aviso para cadastrar; erro em português |
| `painel-produtos.html` | sem loja; sem produtos | aviso; "Você ainda não cadastrou nenhum produto." |
| `painel-produto-form.html` | `?id=abc`; sem loja | "Produto não encontrado."; aviso de cadastrar a loja |
| `painel-pedidos.html` | sem pedidos; sem loja | "Sua loja ainda não recebeu nenhum pedido."; aviso |

Para cada falha, crie um cartão (se for **crítico**, corrija hoje, com o roteiro do Passo 1).

**Varredura de código (5 minutos).** Procure em `js/` com **Ctrl+Shift+F** (em português: **Localizar nos arquivos**): `PROVISÓRIO` (**não pode sobrar nada**), `alert(`, `console.log(` (só o `console.warn` e `console.error` do registro de erros são permitidos) e `throw new Error(` (deve ser `ErroApp`, com mensagem em português).

## Explicação do Código

Esta aula é sobre **processo**; entenda as decisões:

- **Reproduzir antes de corrigir:** sem reproduzir, você corrige o que **acha** que está errado. Com o caso de teste na mão, você prova que o resultado esperado voltou.
- **Corrigir na camada certa:** uma regra de negócio (preço maior que zero, fluxo de status) vive em **classes e serviços** (`Produto`, `Pedido`, `produtoServico.js`). A **página** só mostra. Corrigir na página uma regra que é do serviço deixa a mesma falha em outra tela.
- **Revisão por outra pessoa:** quem escreveu não vê os próprios erros; a revisora confere também **o que foi mexido sem precisar**.
- **Regressão:** a sacola, os pedidos e os filtros se tocam. Por isso, depois de uma correção, refazem-se os casos vizinhos.
- **Estados da tela (carregando, vazio, erro, sucesso):** toda chamada ao banco passa por esses quatro estados. A tabela do Passo 3 percorre as 15 telas procurando o estado **esquecido**, que é a causa mais comum de **tela em branco**.
- **`ErroApp` em vez de `Error`:** o `ErroApp` carrega uma mensagem **em português** que as telas sabem mostrar. Um `Error` comum viraria a frase genérica "Algo deu errado".

## Validação

1. Cada problema crítico da lista tem uma branch, um PR **aprovado por outra integrante** e o merge na `main`.
2. Cada caso de teste correspondente foi **refeito no site publicado** com resultado `OK`, e o cartão está em **Done** (em português: **Concluído**).
3. A tabela das 15 telas foi percorrida: **nenhuma** tela fica em branco e nenhuma mostra mensagem em inglês.
4. A varredura de código não encontrou `PROVISÓRIO`, `alert(` nem `throw new Error(`.

**Erros comuns**

1. *Sintoma:* "consertei", mas o problema continua no site publicado. *Causa:* a publicação ainda não terminou, ou o navegador usa a versão antiga. *Correção:* espere uns minutos e recarregue com **Ctrl+Shift+R** (no Mac, Cmd+Shift+R), que ignora o cache.
2. *Sintoma:* a correção resolveu um caso e quebrou outro. *Causa:* faltou o teste de regressão. *Correção:* refaça os casos vizinhos antes de abrir o PR.
3. *Sintoma:* o PR tem muitas mudanças que não são da correção. *Causa:* a branch misturou assuntos. *Correção:* volte à `main`, crie uma branch nova e refaça só a correção.
4. *Sintoma:* não consigo reproduzir o problema. *Causa:* depende de dados ou da conta. *Correção:* anote qual conta e quais itens, e peça à usuária (ou à colega que o encontrou) para mostrar na sua tela.

**Se travar**

1. Releia o cartão e reproduza com a pessoa que encontrou o problema ao seu lado.
2. Procure a mensagem exata em `js/` (Ctrl+Shift+F, em português: **Localizar nos arquivos**): ela leva à função que a mostra.
3. Se a correção ficar grande, divida em dois PRs ou passe a parte menos grave para "não será feito na 1.0".
4. Só depois peça ajuda à sua equipe, colando a mensagem e o arquivo.

**Seu projeto agora tem**

- Os problemas **críticos** corrigidos e retestados, com histórico de branches e pull requests revisados.
- O `docs/TESTES.md` atualizado, com os casos corrigidos como `OK`.
- As 15 telas revisadas: sem tela em branco e com mensagens em português.

**Como saber que deu certo:** você refaz o caso de teste que falhava, no site publicado, e ele passa; e nenhuma das 15 telas fica em branco em nenhum dos estados da tabela.
