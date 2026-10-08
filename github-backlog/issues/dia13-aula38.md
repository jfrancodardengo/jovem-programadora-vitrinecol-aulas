**Data:** 23/10/2026 (sexta-feira) · **Prioridade:** Importante

## User Story

Como cliente, quero criar uma senha nova por um link enviado ao meu e-mail, para que eu volte a entrar na minha conta se esquecer a senha.

## Critérios de aceite

- E-mail inválido (`abc`) mostra "Informe um e-mail válido" ao lado do campo; um e-mail com conta e outro **sem** conta mostram a **mesma** mensagem: "Se existir uma conta com este e-mail, enviamos o link para criar uma senha nova. Confira também a caixa de spam." (RF-24).
- O link do e-mail abre `recuperar-senha.html` na etapa **Senha nova** e **Repita a senha nova**; senhas diferentes mostram "As senhas não são iguais." e menos de 6 caracteres mostram "A senha deve ter pelo menos 6 caracteres."
- Com senha válida aparece "Senha alterada! Você já está logada. Redirecionando…"; a senha nova vale e a antiga mostra "E-mail ou senha incorretos." (CT-23).
- Abrir o mesmo link de novo mostra "Este link não vale mais: ele expirou ou já foi usado. Peça um novo link abaixo."

## Checklist

- [ ] No painel do Supabase, abrir **Authentication** (em português: **Autenticação**) > **URL Configuration** (em português: **Configuração de URL**).
- [ ] Em **Site URL** (em português: **URL do site**), escrever `http://127.0.0.1:5500` (será trocada pelo endereço publicado no Dia 15).
- [ ] Em **Redirect URLs** (em português: **URLs de redirecionamento**), clicar em **Add URL** (em português: **Adicionar URL**) e acrescentar `http://127.0.0.1:5500/recuperar-senha.html` e `http://localhost:5500/recuperar-senha.html`; clicar em **Save** (em português: **Salvar**).
- [ ] No `authServico.js`, colar as duas validações antes de `// ---------- Cadastro, login e logout ----------` e as três funções de recuperação no final do arquivo.
- [ ] Criar `recuperar-senha.html` e `js/paginas/recuperarSenha.js` (duas etapas na mesma página).
- [ ] Em **Entrar**, clicar em **Esqueci minha senha** e testar o e-mail inválido.
- [ ] Enviar o link para um e-mail com conta e para um sem conta e conferir que a mensagem é a mesma.
- [ ] Abrir o e-mail recebido (assunto parecido com **Reset Your Password**, em português: **Redefinir sua senha**), clicar no link e conferir a etapa da senha nova.
- [ ] Testar senhas diferentes e senha curta; depois salvar uma senha nova válida e conferir que a pessoa fica logada.
- [ ] Sair e testar a senha antiga (deve falhar) e a nova (deve funcionar) (CT-23).
- [ ] Clicar de novo no mesmo link do e-mail e conferir a mensagem "Este link não vale mais...".
- [ ] Se o e-mail não chegar, testar com o e-mail de um membro da organização, olhar a caixa de spam e esperar alguns minutos.
- [ ] Se o link abrir a página inicial, conferir o endereço exato (com `.html`) em **Redirect URLs**.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D13·A37 – Criar cadastro, login e logout com Supabase Auth

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia13-aula38-recuperacao-de-senha.md]({{URL_GUIA}}/dia13-aula38-recuperacao-de-senha.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-24** – Permitir recuperar a senha por e-mail.
- **CT-23** – Recuperar a senha pelo link do e-mail; a nova senha vale e a antiga não.
