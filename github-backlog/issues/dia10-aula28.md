**Data:** 20/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero ver "Carregando…" enquanto os dados chegam e uma mensagem clara quando falham, para que eu saiba o que está acontecendo e nunca veja uma tela em branco.

## Critérios de aceite

- O catálogo mostra os 6 produtos vindos dos arquivos JSON.
- Com **Slow 3G** (em português: **3G lento**) na aba **Network** (em português: **Rede**), o aviso "Carregando…" fica visível por mais tempo.
- Com o nome do arquivo errado aparece "Não foi possível carregar os dados de exemplo."
- Com **Offline** aparece uma mensagem em português, nunca uma tela em branco (RF-21).

## Checklist

- [ ] Criar a pasta provisória `dados-de-exemplo` e o arquivo `dados-de-exemplo/lojas.json` com o conteúdo da aula.
- [ ] Abrir `{{URL_GUIA}}/materiais/dados-de-exemplo-produtos.json`, selecionar tudo (Ctrl+A; Mac: Cmd+A), copiar e colar em um arquivo novo `dados-de-exemplo/produtos.json`.
- [ ] No `catalogo.js`, importar o `ErroApp`, apagar a constante `produtosFicticios` e apagar a função `carregarLojasFicticias`.
- [ ] Colar a função `carregarLojasDoArquivo` (usa `fetch` e `Promise.all`) antes de `iniciar` e trocar `iniciar` pela versão `async`.
- [ ] Abrir o catálogo pelo Live Server e conferir que funciona como antes, agora com dados dos arquivos.
- [ ] Abrir F12 > **Network** (em português: **Rede**), escolher **Slow 3G** (em português: **3G lento**) onde diz **No throttling** (em português: **Sem limitação**) e recarregar (F5) para ver o "Carregando…"; depois voltar para **No throttling**.
- [ ] Provocar o erro 404: trocar `lojas.json` por `loja.json` no código, ver a caixa vermelha e desfazer.
- [ ] Provocar falha de conexão: marcar **Offline** na aba **Network**, recarregar, ver a mensagem em português e voltar para **No throttling**.
- [ ] Se der `await is only valid in async functions`, conferir que a função é `async function`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D9·A27 – Praticar SELECT, INSERT e JOIN, criar a lojista de teste e carregar a Loja Exemplo com 3 produtos

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia10-aula28-javascript-assincrono.md]({{URL_GUIA}}/dia10-aula28-javascript-assincrono.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.
