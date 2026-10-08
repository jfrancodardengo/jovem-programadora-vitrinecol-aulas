**Data:** 23/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero criar minha conta, entrar e sair do sistema mantendo a sessão, para que eu finalize minhas compras e acompanhe meus pedidos.

## Critérios de aceite

- Criar uma conta de cliente leva à página inicial com "Conta criada! Redirecionando…" e o cabeçalho mostra **Meus pedidos**, "Olá, [nome]" e **Sair**; **Sair** volta a mostrar **Entrar** e **Cadastrar** (RF-12, RF-13).
- Cadastrar com o mesmo e-mail mostra, ao lado do campo, "Este e-mail já está cadastrado. Entre na sua conta ou use outro e-mail." (CT-08); senha com 3 caracteres mostra "A senha deve ter pelo menos 6 caracteres." sem chamar o servidor; telefone `123` mostra erro.
- A lojista entra e vai para `painel-loja.html`; a cliente vai para a página inicial; senha errada mostra "E-mail ou senha incorretos."
- A sessão continua depois de recarregar (o `localStorage` tem uma chave que começa com `sb-`).
- `select nome, tipo, telefone from public.perfis;` mostra o tipo escolhido no cadastro, e tentar trocar o tipo no banco devolve "O perfil da usuária não pode ser alterado." (RN-11).

## Checklist

- [ ] No painel do Supabase, abrir **Authentication** (em português: **Autenticação**) > **Providers** (em português: **Provedores**) > **Email** (em português: **E-mail**) (em versões novas, **Sign In / Providers**) e desligar **Confirm email** (em português: **Confirmar e-mail**); clicar em **Save** (em português: **Salvar**).
- [ ] Criar `js/servicos/authServico.js` (cadastrar, entrar, sair e `usuariaAtual`, devolvendo dados ou lançando `ErroApp` em português).
- [ ] No `cabecalho.js`: trocar o começo do arquivo (comentários e importações); trocar `linksDaConta`; colar `criarItensDaUsuaria` e `sairDaConta` antes de `montarCabecalho`; trocar `montarCabecalho` pela versão `async`.
- [ ] No `css/componentes.css`, colar a seção do nome e do botão **Sair** antes de `/* ---------- Erro ao lado de um campo de formulário ---------- */`.
- [ ] Substituir **todo** o conteúdo de `cadastro.html` e de `login.html` e criar `js/paginas/cadastro.js` e `js/paginas/login.js`.
- [ ] Testar o cadastro de cliente e conferir o cabeçalho; clicar em **Sair**.
- [ ] Testar o e-mail repetido (CT-08), a senha curta e o telefone inválido.
- [ ] No **SQL Editor** (em português: **Editor SQL**), rodar `select nome, tipo, telefone from public.perfis;`; cadastrar também uma conta **Lojista** e conferir.
- [ ] Entrar com a cliente (vai para a página inicial) e com a **Lojista Teste** (vai para o painel e vê **Painel** no menu); testar senha errada.
- [ ] Recarregar a página e abrir outra para conferir a sessão; olhar F12 > **Application** (em português: **Aplicativo**) > **Local Storage** (em português: **Armazenamento local**) e achar a chave `sb-`.
- [ ] Tentar `update public.perfis set tipo = 'lojista' where nome = 'SEU NOME';` e conferir a recusa do banco (RN-11).
- [ ] Se aparecer `Database error saving new user`, conferir se o `01_schema.sql` (Parte 2) foi rodado até o fim.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push` (sem colar senhas nem chaves).

## Depende de

- D12·A36 – Finalizar a sacola em um pedido por loja, com o mesmo grupo_id, e botão de WhatsApp por loja

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia13-aula37-cadastro-e-login.md]({{URL_GUIA}}/dia13-aula37-cadastro-e-login.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-12** – Cadastrar usuária com nome, e-mail, senha, perfil e telefone opcional.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.
- **RN-11** – O perfil (cliente ou lojista) é escolhido no cadastro e não muda depois.
- **CT-08** – Cadastrar com e-mail repetido e ver mensagem de erro clara.
