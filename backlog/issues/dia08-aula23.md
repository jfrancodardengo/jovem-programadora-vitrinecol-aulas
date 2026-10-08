**Data:** 16/10/2026 (sexta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero que cliente e lojista herdem da mesma classe e cada uma responda a sua página inicial, para que o código não se repita e o sistema saiba para onde levar cada perfil.

## Critérios de aceite

- No Console, `rotaInicial()` devolve `index.html` para a cliente e `painel-loja.html` para a lojista (mesma chamada, respostas diferentes).
- `cliente instanceof Usuaria` é `true` e `cliente instanceof Lojista` é `false`.
- Chamar `rotaInicial()` em uma `Usuaria` pura mostra o erro `metodo_nao_implementado`.
- O catálogo funciona como antes, e um produto com `ativo: false` não aparece (RN-08).

## Checklist

- [ ] Criar `js/modelos/Usuaria.js`, `js/modelos/Cliente.js` e `js/modelos/Lojista.js` (as filhas não têm construtor e usam o da mãe).
- [ ] Abrir o `catalogo.html` pelo Live Server, abrir F12 > **Console** e colar o teste da aula (`const { Usuaria } = await import("/js/modelos/Usuaria.js");`). Esperado: duas rotas diferentes, `true true false` e `metodo_nao_implementado`.
- [ ] No `catalogo.js`, trocar a linha `const produtos = produtosFicticios.map(...)` pela versão que adiciona cada produto à lista da sua loja (agregação).
- [ ] Trocar a função `atualizarCatalogo` pela versão que lista só os produtos **ativos** de cada loja.
- [ ] Teste de RN-08: acrescentar `ativo: false,` ao produto "Saia plissada", ver a saia sumir e tirar a linha para ela voltar.
- [ ] Teste de erro: trocar o `lojaId` de um produto por `"l9"`, recarregar, ver o erro no Console e desfazer.
- [ ] Conferir que `export class Usuaria` tem o `export`.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D8·A22 – Criar ErroApp, Produto e Loja com campos privados e regras dentro da classe

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia08-aula23-heranca-polimorfismo-e-agregacao.md]({{URL_GUIA}}/dia08-aula23-heranca-polimorfismo-e-agregacao.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-01** – Cada lojista tem no máximo uma loja.
- **RN-08** – Produto inativo não aparece no catálogo nem na página da loja.
- **RN-11** – O perfil (cliente ou lojista) é escolhido no cadastro e não muda depois.
