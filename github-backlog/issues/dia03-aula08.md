**Data:** 08/10/2026 (quinta-feira) · **Prioridade:** Essencial

## User Story

Como cliente, quero um formulário de login e filtros do catálogo claros e com rótulos, para que eu consiga preencher tudo, inclusive só com o teclado.

## Critérios de aceite

- `login.html` e `catalogo.html` abrem pelo Live Server e mostram os formulários.
- Clicar em cada rótulo do login (por exemplo, "E-mail") coloca o cursor no campo certo.
- No campo de senha, os caracteres aparecem escondidos.
- Todo campo do catálogo tem rótulo: **Buscar pelo nome**, **Loja**, **Tamanho** e o texto "Tipo de roupa" para os chips.
- Com a tecla Tab, o foco passa por todos os campos e botões do catálogo, na ordem.

## Checklist

- [ ] Antes de começar, abrir o wireframe do Login e do Catálogo (Aula 4) e listar os campos de cada um.
- [ ] Criar `login.html` na raiz com o conteúdo da aula (cabeçalho e rodapé copiados do `index.html`).
- [ ] Criar `catalogo.html` na raiz com o conteúdo da aula.
- [ ] Abrir as duas páginas pelo Live Server (**Go Live**, em português: **Ir ao vivo**, ou botão direito > **Open with Live Server**, em português: **Abrir com Live Server**).
- [ ] No login, clicar no texto "E-mail" e conferir que o cursor vai para o campo.
- [ ] Digitar no campo de senha e conferir que os caracteres ficam escondidos.
- [ ] No catálogo, abrir as listas **Loja** e **Tamanho** e escolher uma opção.
- [ ] Conferir que os chips de tipo de roupa são botões comuns (`type="button"`) e a lista de produtos ainda está vazia.
- [ ] Experimento 1: apagar `for="email"` do primeiro `label`, ver que o clique no texto não foca mais o campo e desfazer.
- [ ] Experimento 2: trocar `type="password"` por `type="text"`, ver a senha visível e desfazer.
- [ ] Conferir que cada `id` é único na página (sem dois `id="email"`).
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D3·A7 – Reescrever o index.html com HTML semântico (cabeçalho e rodapé comuns)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia03-aula08-listas-e-formularios-html.md]({{URL_GUIA}}/dia03-aula08-listas-e-formularios-html.md)

**Requisitos que esta issue entrega ou prepara:**

- **RF-02** – Filtrar o catálogo por tipo de roupa.
- **RF-03** – Filtrar o catálogo por loja.
- **RF-05** – Buscar produtos pelo nome, sem diferenciar maiúsculas de minúsculas.
- **RF-13** – Permitir entrar e sair da conta, mantendo a sessão.

**Observação da aula:** só a estrutura de RF-02, RF-03, RF-05 e RF-13
