**Data:** 13/11/2026 (sexta-feira) · **Prioridade:** Importante

## User Story

Como aluna desenvolvedora, quero observar pessoas de fora usando o sistema sem ajudar, para que a equipe saiba em qual tela e em qual passo elas travam.

## Critérios de aceite

- Pelo menos **5 usuárias externas** (que não são da equipe) fizeram a tarefa, com a tabela de observação de cada sessão preenchida: tempo, ações, onde hesitou, erros, se concluiu sozinha e comentários (RF-10, RF-11, RF-20, RF-22 no fluxo completo).
- Cada problema está registrado em uma tabela única da equipe (Nº, tela, passo, o que aconteceu, primeiro nome da usuária e frase dela), com tela e passo precisos.
- Os números foram calculados: quantas usuárias testaram, quantas concluíram sozinhas, tempo médio do catálogo ao botão de WhatsApp e média de ações (meta: até 6 por loja).
- A tabela de observação está guardada em `docs/` (sem nomes completos nem dados pessoais).

## Checklist

- [ ] Combinar os papéis de cada sessão: condutora (lê a tarefa e faz as perguntas finais), observadora (anota em silêncio) e cronometrista; combinar o sinal de silêncio (observadora de braços cruzados).
- [ ] Preparar de 3 a 5 estações (computador ou celular) com o site publicado aberto na página inicial, sacola vazia e uma conta de cliente de teste (ou sem conta, para testar também o cadastro).
- [ ] Dar a cada observadora uma cópia da tabela de observação e das 3 perguntas finais.
- [ ] Acolher a usuária e ler o consentimento ("Vamos testar o sistema, não você... Eu não vou poder ajudar... Pode ser?"); só começar depois do "sim".
- [ ] Ler a tarefa em voz alta, sem explicar, e disparar o cronômetro quando a usuária começar; parar quando ela chegar ao botão do WhatsApp (ou desistir).
- [ ] Observadora: contar cada clique ou escolha como uma ação, anotar hesitações de mais de 5 segundos, cliques errados, mensagens de erro e frases entre aspas.
- [ ] Se a usuária travar por mais de 2 minutos, perguntar só "O que você está procurando?" e anotar que houve ajuda.
- [ ] Fazer as 3 perguntas finais e anotar as respostas.
- [ ] Logo depois de cada sessão, passar a limpo cada problema em uma linha da tabela única (tela e passo precisos) e registrar também as sessões que correram bem.
- [ ] Esvaziar a sacola e voltar à página inicial entre as sessões.
- [ ] Se houver lojista parceira ou colega, aplicar a segunda tarefa: cadastrar um produto com uma foto e confirmar um pedido com recado, medindo o tempo.
- [ ] Somar os resultados (quantas testaram, quantas concluíram sozinhas, tempo médio e média de ações) e comparar com a meta.
- [ ] Guardar a tabela na pasta `docs/` e rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D27·A79 – Executar os 25 casos de teste no site publicado e escrever o roteiro de usabilidade

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia27-aula80-testes-com-usuarias-reais.md]({{URL_GUIA}}/dia27-aula80-testes-com-usuarias-reais.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-10** – Finalizar a sacola de uma cliente logada, gravando um pedido por loja e mostrando um botão de WhatsApp por loja.
- **RF-11** – Mostrar à cliente os pedidos dela, agrupados por compra, com o status e o recado da loja.
- **RF-20** – Mostrar à lojista os pedidos da loja e permitir mudar o status e deixar um recado.
- **RF-22** – Avisar a cliente, dentro do sistema, quando a lojista mudar o status ou deixar um recado.

**Observação da aula:** RF-10, RF-11, RF-20, RF-22 (fluxo completo)
