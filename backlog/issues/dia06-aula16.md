**Data:** 14/10/2026 (quarta-feira) · **Prioridade:** Essencial

## User Story

Como aluna desenvolvedora, quero ligar um script JavaScript ao catálogo e ver mensagens no Console, para que eu entenda variáveis, tipos, operadores e a regra "preço maior que zero".

## Critérios de aceite

- O Console (F12 > **Console**) mostra as 6 mensagens do Passo 3 (nome, preço, tipo `number`, "disponível", "Preço válido." e o preço com desconto `116.91`), sem erros vermelhos.
- Com `estoque = 0` aparece "esgotado"; com `preco = -5` aparece "Preço inválido".
- Tentar mudar uma `const` gera o erro `Assignment to constant variable.` e a linha de teste foi apagada.
- A condicional do desafio mostra "Últimas unidades!" com estoque 1 ou 2.

## Checklist

- [ ] Criar as pastas `js` e `js/paginas` (no **Explorer**, em português: **Explorador**, usar **New Folder**, em português: **Nova Pasta**).
- [ ] Criar `js/paginas/catalogo.js` com o conteúdo da aula.
- [ ] No `catalogo.html`, colar `<script type="module" src="js/paginas/catalogo.js"></script>` logo antes de `</body>`.
- [ ] Abrir pelo **Go Live** (em português: **Ir ao vivo**), nunca direto do arquivo (`file://`), e abrir F12 > **Console**.
- [ ] Conferir as 6 mensagens esperadas.
- [ ] Exercício 1: trocar `const estoque = 3;` por `0` e ver "esgotado".
- [ ] Exercício 2: trocar `let preco = 129.9;` por `-5` e ver "Preço inválido"; voltar o valor.
- [ ] Exercício 3: acrescentar `preco = 139.9;` abaixo da linha do preço e ver o novo valor.
- [ ] Exercício 4: escrever `estoque = 1;` (que é `const`), ver o erro vermelho `Assignment to constant variable.` e apagar a linha.
- [ ] Desafio: escrever uma condicional que mostre "Últimas unidades!" quando o estoque for maior que zero **e** menor que 3 (usar `&&`).
- [ ] Se nada aparecer, conferir o `src` do script e, em F12 > **Network** (em português: **Rede**), se há erro 404.
- [ ] Rodar `git add .`, `git commit -m "..."` e `git push`.

## Depende de

- D5·A15 – Criar as cinco telas estáticas restantes, revisar a acessibilidade e marcar a versão 0.1 (Marco 2)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia06-aula16-javascript-variaveis-tipos-e-condicionais.md]({{URL_GUIA}}/dia06-aula16-javascript-variaveis-tipos-e-condicionais.md)

**Requisitos que esta issue entrega ou prepara:**

- **RN-02** – O preço é maior que zero, o estoque não é negativo e a quantidade mínima de um item é 1.

**Observação da aula:** Não se aplica (base de programação; ensaia a RN-02)
