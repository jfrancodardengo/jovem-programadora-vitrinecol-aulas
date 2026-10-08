**Data:** 16/11/2026 (segunda-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero corrigir cada problema crítico em uma branch e provar que ele acabou refazendo o caso de teste, para que a versão final não tenha falhas que impeçam o pedido ou exponham dados.

## Critérios de aceite

- Cada problema crítico da lista tem uma branch, um pull request **aprovado por outra integrante** e o merge na `main`; a issue está em "Concluído".
- Cada caso de teste correspondente foi **refeito no site publicado** com resultado `OK` e o `docs/TESTES.md` foi atualizado (`FALHOU` para `OK`, com data).
- A tabela das 15 telas foi percorrida: nenhuma tela fica em branco e nenhuma mostra mensagem em inglês (RF-21).
- A varredura de código em `js/` não encontrou `PROVISÓRIO`, `alert(` nem `throw new Error(` (deve ser `ErroApp` com mensagem em português); só `console.warn` e `console.error` do registro de erros são permitidos.

## Checklist

- [ ] Reler a issue do problema: tela, passo, o que aconteceu e o caso de teste a repetir.
- [ ] Reproduzir o problema seguindo a issue e anotar a mensagem do Console (F12 > **Console**) e do pedido que falhou (aba **Network**, em português: **Rede**).
- [ ] Voltar à `main` (`git switch main`), trazer as novidades (`git pull`) e criar a branch da correção (`git switch -c correcao-...`).
- [ ] Achar a causa com o Console e com **Ctrl+Shift+F** (em português: **Localizar nos arquivos**; Mac: Cmd+Shift+F). Se o pedido na aba **Network** tem erro, o problema é do banco ou da regra; se deu certo, é da tela.
- [ ] Corrigir o mínimo; se a correção é em regra de negócio (preço, estoque, status), fazer na classe ou no serviço, não na página.
- [ ] Repetir exatamente os passos do caso (CT-xx) e depois os casos vizinhos (por exemplo, se mexeu na sacola, refazer CT-04, CT-05 e CT-07).
- [ ] Fazer `git add .`, `git commit -m "..."` (mensagem clara) e `git push -u origin correcao-...`.
- [ ] Abrir o pull request (**Compare & pull request**, em português: **Comparar e criar pull request**), citar o caso de teste e a issue e pedir a revisão de outra integrante.
- [ ] Ao revisar o pull request de outra integrante, abrir **Files changed** (em português: **Arquivos alterados**) e conferir: mudança mínima; nomes em português sem acento e comentários que explicam o porquê; nenhum `innerHTML` com dados, nenhum segredo e nenhum `console.log` de teste; mensagens em português; regra em um só lugar; passos de teste feitos. Aprovar (**Approve**, em português: **Aprovar**) ou comentar.
- [ ] Depois do merge, atualizar a `main` (`git switch main` e `git pull`), esperar a publicação e refazer o caso no site publicado; atualizar o `docs/TESTES.md` e mover a issue para "Concluído".
- [ ] Dividir as 15 telas entre as duplas e provocar em cada uma os estados da tabela da aula (por exemplo, **Offline** na aba **Rede**, `loja.html?id=abc`, `produto.html?id=abc`, sacola vazia, senha errada, link de recuperação já usado, `minha-conta.html` sem login); abrir uma issue para cada falha.
- [ ] Varrer `js/` por `PROVISÓRIO` (não pode sobrar nada), `alert(`, `console.log(` e `throw new Error(`.
- [ ] Se a correção ficar grande, dividir em dois pull requests ou passar a parte menos grave para "não será feito na 1.0".

## Depende de

- D27·A81 – Consolidar o relatório de testes e priorizar as correções em crítico, importante e desejável

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia28-aula82-correcao-dos-problemas-criticos.md]({{URL_GUIA}}/dia28-aula82-correcao-dos-problemas-criticos.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Observação da aula:** RF-21 e os RF dos casos que falharam

**Outros requisitos e testes citados nesta issue:**

- **CT-04** – Adicionar produtos de duas lojas à sacola.
- **CT-05** – Recarregar a página e manter a sacola.
- **CT-07** – Finalizar logada com peças de duas lojas: dois pedidos com o mesmo código de compra e um botão de WhatsApp por loja.
