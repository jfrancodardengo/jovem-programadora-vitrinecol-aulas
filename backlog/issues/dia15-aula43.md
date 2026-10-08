**Data:** 27/10/2026 (terça-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero abrir o site pelo celular em um link público, para que eu faça meus pedidos de qualquer lugar, inclusive recuperando a senha pelo e-mail.

## Critérios de aceite

- O endereço `https://SEU-USUARIO.github.io/vitrine-col/` abre a página inicial com estilo, imagens, carrossel e dados do Supabase.
- O fluxo de pedido funciona online: catálogo, sacola, login, finalizar e botões de WhatsApp (CT-07).
- O link do e-mail de recuperação de senha abre a tela da senha nova no **site publicado** (RF-24 online).
- No celular, as telas funcionam sem rolagem horizontal.
- Procurar `service_role` não encontra nenhuma chave; `href="/` e `src="/` dão 0 resultados; `innerHTML` em `js/` dá 0 resultados.

## Checklist

- [ ] Procurar `service_role` e `secret` com Ctrl+Shift+F (em português: **Localizar nos arquivos**; Mac: Cmd+Shift+F): só o comentário do `js/config.js`, e no `config.js` só a URL e a chave `anon`.
- [ ] Procurar `href="/` e `src="/`: 0 resultados (usar caminhos como `css/base.css`).
- [ ] Procurar `innerHTML` em `js/`: 0 resultados.
- [ ] Conferir que a `main` está atualizada (`git status` diz `nothing to commit` e `git pull` não traz nada).
- [ ] No GitHub, abrir **Settings** (em português: **Configurações**) > **Pages** (em português: **Páginas**); em **Build and deployment** (em português: **Construção e implantação**) > **Source** (em português: **Origem**), escolher **Deploy from a branch** (em português: **Implantar a partir de uma branch**).
- [ ] Em **Branch**, escolher **main** e a pasta **/ (root)** (em português: **/ (raiz)**) e clicar em **Save** (em português: **Salvar**).
- [ ] Esperar de 1 a 3 minutos e copiar o endereço que aparece em **Your site is live at** (em português: **Seu site está no ar em**).
- [ ] No Supabase, abrir **Authentication** (em português: **Autenticação**) > **URL Configuration** (em português: **Configuração de URL**) e trocar **Site URL** (em português: **URL do site**) pelo endereço publicado, com a barra no fim.
- [ ] Em **Redirect URLs** (em português: **URLs de redirecionamento**), acrescentar (sem apagar os de teste) `https://SEU-USUARIO.github.io/vitrine-col/recuperar-senha.html` e clicar em **Save** (em português: **Salvar**).
- [ ] No computador, percorrer catálogo, produto, sacola, **Entrar**, finalizar um pedido (CT-07) e o painel da lojista no endereço publicado.
- [ ] Testar "Esqueci minha senha" online com o e-mail de um membro da organização e conferir que o link abre o site publicado.
- [ ] No celular, abrir o mesmo endereço e testar o menu, o carrossel (arrastar o dedo), a escolha de tamanho e a sacola.
- [ ] Se algo não carregar, abrir F12 > **Console** e a aba **Network** (em português: **Rede**) e olhar os erros 404 (atenção a maiúsculas e minúsculas nos nomes de pastas e arquivos).
- [ ] Colar no `README.md` uma linha `Site: https://...`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D14·A42 – Corrigir os defeitos graves com branch, pull request revisado e merge

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia15-aula43-publicacao-no-github-pages.md]({{URL_GUIA}}/dia15-aula43-publicacao-no-github-pages.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-24** – Permitir recuperar a senha por e-mail.

**Observação da aula:** RF-24 (online)

**Outros requisitos e testes citados nesta issue:**

- **CT-07** – Finalizar logada com peças de duas lojas: dois pedidos com o mesmo código de compra e um botão de WhatsApp por loja.
