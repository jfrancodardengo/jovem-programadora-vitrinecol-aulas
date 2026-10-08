**Data:** 20/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero que o catálogo mostre os produtos que estão no banco, para que o que a loja cadastrou apareça de verdade no site.

## Critérios de aceite

- Com os valores de exemplo em `js/config.js`, o catálogo mostra a caixa vermelha "O sistema ainda não está conectado ao banco de dados. Preencha a URL e a chave do Supabase no arquivo js/config.js."
- Com os valores certos, o catálogo mostra os 3 produtos do banco, as 8 categorias como chips e a Loja Exemplo na lista de lojas, e os filtros continuam funcionando.
- Procurando `service_role` e `secret` com Ctrl+Shift+F (Mac: Cmd+Shift+F) há 0 resultados no código; só a chave pública `anon` aparece.
- A pasta `dados-de-exemplo` não existe mais.
- Trocar um preço no **Table Editor** do Supabase e recarregar o catálogo mostra o novo preço.

## Checklist

- [ ] No painel do Supabase, abrir **Project Settings** (em português: **Configurações do projeto**) > **API** (ou o botão **Connect**, em português: **Conectar**) e copiar o **Project URL** (em português: **URL do projeto**).
- [ ] Copiar a chave **anon / public** (em projetos novos, **publishable key**, em português: **chave publicável**). Não copiar a chave `service_role` (ou `secret`).
- [ ] Criar `js/config.js` com o conteúdo da aula e trocar os dois valores de exemplo pelos do seu projeto, mantendo as aspas.
- [ ] Criar `js/supabaseClient.js` (carrega a biblioteca por CDN e cria o cliente).
- [ ] Criar `js/servicos/categoriaServico.js` e `js/servicos/lojaServico.js` (cada função devolve dados ou lança `ErroApp`, dentro de `try/catch`).
- [ ] No `produtoServico.js`, trocar o começo do arquivo pelas importações e constantes e colar a função `listarProdutosAtivos` (só produtos ativos; RN-08) antes do bloco "Painel da lojista".
- [ ] No `Produto.js`, colar o método estático `deLinha` antes do comentário `// ---------- Leitura ----------`.
- [ ] No `catalogo.js`, fazer as cinco trocas da aula, na ordem: importações; dados fictícios saem; nova `atualizarCatalogo`; chips usam `categoria.nome`; apagar `carregarLojasDoArquivo` e trocar `iniciar`.
- [ ] Apagar `dados-de-exemplo/lojas.json` e `dados-de-exemplo/produtos.json`.
- [ ] Teste 1 (antes de preencher a configuração): abrir o catálogo e ver o aviso da caixa vermelha.
- [ ] Teste 2 (configuração preenchida): conferir os 3 produtos, as 8 categorias e a Loja Exemplo.
- [ ] No **Table Editor**, conferir que cada tabela mostra **RLS disabled**.
- [ ] Procurar `service_role` e `secret` em todo o código: 0 resultados.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`, sem colar a chave em nenhuma mensagem de ajuda.

## Depende de

- D10·A28 – Buscar os dados com async/await e fetch, com "Carregando…" e erro (arquivos JSON de teste)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia10-aula29-conectar-o-front-ao-supabase.md]({{URL_GUIA}}/dia10-aula29-conectar-o-front-ao-supabase.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-01** – Listar os produtos ativos em cards (foto de capa, nome, preço e loja), 12 por página, com o botão "Carregar mais produtos".
- **RF-21** – Avisar carregamento, erro e sucesso em toda chamada ao banco, sem deixar tela em branco.

**Outros requisitos e testes citados nesta issue:**

- **RN-08** – Produto inativo não aparece no catálogo nem na página da loja.
