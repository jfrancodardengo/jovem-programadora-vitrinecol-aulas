**Data:** 07/10/2026 (quarta-feira) · **Prioridade:** Importante · **Marco:** Marco 1 · protótipo navegável e guia de estilo

## User Story

Como aluna desenvolvedora, quero um guia de estilo de uma página com cores, fontes, botão e card, para que todas as telas tenham a mesma identidade e texto legível (contraste mínimo de 4,5:1).

## Critérios de aceite

- O guia de estilo tem: nome e slogan, paleta com código e nome de cada cor, tipografia, botão principal e secundário, card de produto e escala de espaços.
- Os 4 pares de contraste testados (`#ffffff` sobre `#8a2252`, `#2b2230` sobre `#fbf8f6`, `#5d5365` sobre `#ffffff` e `#b3261e` sobre `#fde8e6`) deram 4,5:1 ou mais, com o resultado anotado.
- O protótipo da Aula 5 usa a paleta.
- O `README.md` no GitHub mostra o link do protótipo e do guia de estilo.
- **Marco 1:** protótipo e guia de estilo prontos.

## Checklist

- [ ] Usar o nome de trabalho **VitrineCol** (se a equipe trocar, anotar para trocar nos textos das aulas) e escrever um slogan, por exemplo "Moda das lojas do seu bairro".
- [ ] No Figma, criar um quadro chamado `Guia de estilo`.
- [ ] Desenhar um quadradinho para cada cor, com o código e o nome para o CSS: `--cor-primaria` `#8a2252`, `--cor-primaria-escura` `#6b1a40`, `--cor-primaria-clara` `#f7e6ee`, `--cor-fundo` `#fbf8f6`, `--cor-superficie` `#ffffff`, `--cor-texto` `#2b2230`, `--cor-texto-suave` `#5d5365`, `--cor-texto-sobre-primaria` `#ffffff`, `--cor-borda` `#ddd5da`, `--cor-borda-campo` `#7a6f82`, `--cor-erro`/`--cor-erro-fundo`, `--cor-sucesso`/`--cor-sucesso-fundo`, `--cor-info`/`--cor-info-fundo`, `--cor-neutro`/`--cor-neutro-fundo` e `--cor-foco` `#1a5fb4`.
- [ ] Abrir o verificador de contraste (https://webaim.org/resources/contrastchecker/; **Foreground Color** = cor do texto, em português: **Cor do primeiro plano**; **Background Color** = cor do fundo, em português: **Cor de fundo**) e testar os 4 pares da aula.
- [ ] Se a equipe trocar uma cor, repetir o teste; se der menos de 4,5, escurecer o texto até passar.
- [ ] Registrar a fonte do sistema: `system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif`.
- [ ] Registrar os tamanhos: 14 px, 16 px, 18 px, 24 px e 28 px.
- [ ] Desenhar o botão principal (fundo `--cor-primaria`, texto branco, cantos de 12 px, altura mínima de 44 px, negrito) e o secundário (fundo branco, borda e texto na cor primária escura).
- [ ] Desenhar o card de produto (fundo branco, borda fina, foto 4:5, nome em negrito, preço em cor primária escura e loja em texto suave).
- [ ] Registrar a escala de espaços: múltiplos de 4 px (4, 8, 12, 16, 24, 32, 48).
- [ ] Pintar o protótipo da Aula 5 com a paleta (usando os códigos da tabela, sem copiar "a olho").
- [ ] Colar os links do protótipo e do guia no `README.md` e rodar `git add .`, `git commit -m "..."` e `git push` (se falhar, `git pull` e tentar de novo).

## Depende de

- D2·A5 – Montar o protótipo navegável no Figma (Catálogo, Produto e Sacola)

## Aula e requisitos

- **Aula:** [{{URL_GUIA}}/dia02-aula06-nome-identidade-visual-e-guia-de-estilo.md]({{URL_GUIA}}/dia02-aula06-nome-identidade-visual-e-guia-de-estilo.md)

**Requisitos:** nenhum requisito do sistema é entregue diretamente nesta issue.

**Observação da aula:** Não se aplica (identidade visual; prepara contraste e acessibilidade nível AA)
