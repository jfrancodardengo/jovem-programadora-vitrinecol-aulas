**Data:** 13/11/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero juntar os problemas em uma tabela, classificar a gravidade e definir quem corrige o quê, para que a equipe corrija primeiro o que mais atrapalha a cliente.

## Critérios de aceite

- O `docs/relatorio-de-testes.md` tem as 5 seções preenchidas: casos de teste, usabilidade, problemas, lista priorizada e o que não entra na versão 1.0.
- A seção 1 mostra os 25 casos contados (sem `N/A`) e cada falha explicada com o requisito e a decisão.
- A seção 3 tem cada problema com tela, passo, número de usuárias e gravidade (crítico, importante ou desejável); problemas repetidos estão agrupados em uma linha.
- A seção 4 tem a lista **ordenada** (primeiro os críticos), com um responsável e um prazo por item (no máximo 2 itens por integrante na Aula 82), e cada item é uma issue no repositório com o título `[crítico] tela: problema`.
- A seção 5 registra o que não será feito na 1.0, com o motivo, e a decisão sobre a confirmação de e-mail e o limite de e-mails.

## Checklist

- [ ] Criar `docs/relatorio-de-testes.md` com o modelo da aula e preencher o cabeçalho (versão, endereço, período e equipe).
- [ ] Contar no `docs/TESTES.md` os `OK`, `FALHOU` e `N/A` e preencher a tabela da seção 1; se sobrar `N/A`, executar o caso agora.
- [ ] Para cada caso `FALHOU`, preencher o que falhou, o requisito (RF ou RN em palavras) e a decisão.
- [ ] Com as tabelas de observação da Aula 80, calcular quantas usuárias testaram, quantas concluíram sozinhas, o tempo médio e a média de ações, e comparar com a meta de até 6 ações por loja (seção 2).
- [ ] Juntar em uma tabela única os casos que falharam e os problemas das usuárias, agrupando os repetidos (por exemplo, "3 usuárias") (seção 3).
- [ ] Classificar a gravidade com as perguntas da aula, nesta ordem: impede sacola, finalização ou WhatsApp, ou expõe dados? (crítico); a usuária conseguiu, mas demorou ou errou? (importante); é estética ou texto? (desejável). Se houver discordância, vale a gravidade mais alta.
- [ ] Ordenar a lista priorizada (críticos primeiro, os que mais usuárias tiveram antes) e escrever um responsável e um prazo por item: críticos na Aula 82, importantes na Aula 83 ou no tempo que sobrar (seção 4).
- [ ] Criar uma issue no repositório para cada item, com o título `[crítico] tela: problema` e, na descrição, tela, passo, caso de teste a repetir e quem corrige.
- [ ] Cortar a lista para só críticos e importantes nas Aulas 82 e 83 e mover o resto para a seção 5 com o motivo (por exemplo, "pagamento on-line: fora do escopo do curso").
- [ ] Registrar na seção 5 a decisão sobre a confirmação de e-mail e o limite de e-mails (Aula 79).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D27·A80 – Aplicar o roteiro de usabilidade com pelo menos 5 usuárias externas e registrar cada problema

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia27-aula81-feedbacks-e-priorizacao-das-correcoes.md]({{URL_GUIA}}/dia27-aula81-feedbacks-e-priorizacao-das-correcoes.md)

**Requisitos que esta issue entrega ou prepara:**

- **CT-01 a CT-25** – os 25 casos de teste do sistema (abrir o catálogo, filtrar, montar a sacola, finalizar pedido, entrar, sair, tentar acessos indevidos, trocar de tela, recuperar senha e excluir conta)

**Observação da aula:** CT-01 a CT-25 (e os requisitos afetados pelos problemas encontrados)
