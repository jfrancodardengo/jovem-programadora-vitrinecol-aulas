# Aula 45 – Revisão geral e avaliação prática dos indicadores da UC3

**Dia 15 · Ter 27/10/2026** · **Aula 45** · **UC3**

- **Requisitos cobertos:** revisão de RF-01 a RF-10, RF-12 a RF-19, RF-21, RF-23 e RF-24 (catálogo e filtros, páginas de loja e produto, sacola, pedido, cadastro e login, controle de acesso, painel da lojista, fotos, avisos, página inicial e recuperação de senha)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** sistema publicado, documentado e testado, com as correções principais já mergeadas (Aulas 40 a 44)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai fazer a **revisão geral** do MVP com uma checklist técnica, **demonstrar o fluxo completo** (loja, produto, sacola, pedido), conferir **o que falta** (e registrar no Kanban) e participar da **avaliação prática dos 5 indicadores da UC3**. No fim, marca a **versão 0.9** (**Marco 4**).

**Abertura (10 minutos).** Retomada da Aula 44: o sistema está no ar e documentado. Hoje a equipe **se avalia** como a professora vai avaliar: com evidências. Para cada indicador há um jeito de **provar** que foi atendido (um arquivo, uma tela, um comando). Antes de começar, abra o link público, o repositório, o Supabase e o Kanban em abas diferentes: são as suas evidências.

## O Conceito

**Termos desta aula**

- **Indicador**: um critério da avaliação da UC. Cada um recebe **Atendido (A)**, **Parcialmente atendido (PA)** ou **Não atendido (NA)**; no fim da UC, só **A** ou **NA**.
- **Evidência**: a **prova** de que o indicador foi atendido (um arquivo, uma tela funcionando, um commit, um resultado de teste).
- **Demonstração (demo)**: a apresentação do sistema funcionando, **ao vivo**, seguindo um roteiro, sem improviso.
- **Versão 0.9 (MVP)**: a versão mínima completa do fluxo de pedido: o que o curso prometeu entregar até o fim do Dia 15.

**Analogia:** é a **vistoria final** antes de entregar a casa: o engenheiro percorre cada cômodo com uma lista, abre as torneiras e liga as luzes, e anota o que ainda falta.

**Os 5 indicadores da UC3:**

| Nº | Indicador | Quer dizer |
| --- | --- | --- |
| 1 | Ambiente de desenvolvimento | usar as ferramentas do trabalho (editor, Git e GitHub, servidor local, Supabase, publicação) |
| 2 | Melhores práticas da linguagem | código organizado: classes, módulos, nomes, tratamento de erros, comentários |
| 3 | Elaboração de código | HTML, CSS e JavaScript corretos, semânticos, responsivos e acessíveis |
| 4 | Compilação e depuração | testar, encontrar e corrigir defeitos usando as ferramentas do navegador |
| 5 | Integração com banco de dados | o sistema lê e grava no banco, com segurança |

## Mão na Massa

### Passo 1: a checklist técnica (15 minutos)

Em dupla, confira **cada item** no sistema publicado e no repositório. Marque ✔ ou anote o que falta.

- [ ] Nenhum `innerHTML` com dados em `js/` (busca com Ctrl+Shift+F, em português: **Localizar nos arquivos**; no Mac Cmd+Shift+F): **0 resultados**.
- [ ] Nenhuma chave `service_role` no código (só a chave pública `anon` no `js/config.js`).
- [ ] As mensagens ao usuário estão **em português** e nenhuma tela fica em branco quando algo falha (teste **Offline**).
- [ ] As telas abrem em **360 px** e em **1280 px** sem rolagem horizontal.
- [ ] Todo campo tem `label`, toda imagem tem `alt`, e o foco do teclado é visível.
- [ ] Valores em **R$** e datas em **dd/mm/aaaa**.
- [ ] A RLS está **ligada** nas 8 tabelas e a política provisória `dev: envio de fotos` **não existe**.
- [ ] O `README.md` está completo e o endereço publicado funciona.
- [ ] Todas as integrantes têm commits no histórico (`git shortlog -sn`).

### Passo 2: ensaie e faça a demonstração do fluxo completo (15 minutos)

Siga **exatamente** este roteiro (uma integrante conduz, outra narra):

1. **Visitante:** abre a página inicial (hero, carrossel, destaques, lojas), clica em **Vestidos** e chega ao catálogo filtrado; aplica o filtro de tamanho e a busca.
2. **Produto e sacola:** abre um produto (troca de foto pelo teclado), escolhe o tamanho, adiciona à sacola; abre um produto de **outra loja** e adiciona; mostra a **Sacola** agrupada por loja com subtotais e total.
3. **Login:** clica em **Finalizar sacola**; é levada ao login; entra como **cliente**; volta à sacola; finaliza: aparece **Pedidos enviados** com um botão de WhatsApp por loja.
4. **Prova no banco:** no Supabase, mostra **dois pedidos** com o **mesmo `grupo_id`** e status `novo`.
5. **Lojista:** entra como lojista; mostra **Minha loja**, **Meus produtos** (cadastra um produto com 3 fotos, edita, desativa) e como ele aparece (ou some) no catálogo.
6. **Segurança:** mostra que a cliente, ao digitar o endereço do painel, é **bloqueada**, e (pelo console) que o banco recusa o preço forjado.

Cronometre: a demonstração deve caber em **8 minutos**.

### Passo 3: confira o que falta (5 minutos)

Compare o sistema com o backlog da Aula 1 usando a tabela abaixo. Para cada linha, escreva **"funciona"**, **"parcial"** ou **"falta"**:

| Requisito (em palavras) | Como conferir | Situação |
| --- | --- | --- |
| RF-01 a RF-05: catálogo, filtros e busca | catálogo, 12 por página, filtros e busca | |
| RF-06 e RF-07: página da loja e mapa | página da loja com WhatsApp e mapa | |
| RF-08: página do produto | galeria, tamanho e quantidade | |
| RF-09: sacola com várias lojas | adicionar, quantidade, remover, subtotais | |
| RF-10: finalizar gravando um pedido por loja | dois pedidos e dois botões de WhatsApp | |
| RF-12 a RF-14: cadastro, login e acesso por perfil | contas de cliente e de lojista, telas bloqueadas | |
| RF-15 a RF-19: loja, produtos e fotos da lojista | painel completo, até 5 fotos | |
| RF-21: carregamento, erro e sucesso | Carregando…, mensagens, nada em branco | |
| RF-23: página inicial de vitrine | hero, carrossel, destaques, lojas | |
| RF-24: recuperar a senha por e-mail | fluxo completo online | |

Os requisitos que **ainda não existem** são **RF-11** (a cliente ver os pedidos dela), **RF-20** (a lojista ver e atualizar os pedidos), **RF-22** (aviso de mudança de status) e **RF-25** (excluir a própria conta): eles entram no **Dia 26**. Crie um cartão no Kanban para cada **"falta"** ou **"parcial"** com a prioridade.

### Passo 4: avaliação prática dos 5 indicadores (15 minutos)

A professora (ou outra equipe) avalia, com a sua ajuda. **Para cada indicador, apresente a evidência** e marque a menção (A, PA ou NA):

| Indicador | Evidências para mostrar | Menção |
| --- | --- | --- |
| 1. Ambiente de desenvolvimento | VS Code com Live Server; Git e GitHub (commits, branches, pull requests, tags `v0.1`, `v0.5`); Supabase configurado; site no GitHub Pages | |
| 2. Melhores práticas da linguagem | classes com campos privados (`Produto`, `Loja`, `Sacola`, `Pedido`), herança e polimorfismo (`Usuaria`, `Cliente`, `Lojista`), `ErroApp`, módulos em `js/modelos`, `js/ui`, `js/paginas`, `js/servicos`; nomes e comentários em português | |
| 3. Elaboração de código | HTML semântico, CSS com variáveis e media queries, JavaScript com DOM e eventos, validação de formulários, sem `innerHTML` com dados | |
| 4. Compilação e depuração | `docs/TESTES.md` preenchido, defeitos no Kanban corrigidos por branch e pull request, uso do Console e da aba **Rede** | |
| 5. Integração com banco de dados | tabelas e relações no `01_schema.sql`; leitura, cadastro, edição e exclusão pelo `supabase-js`; RLS e a função `criar_pedidos` | |

Se um indicador ficar **PA** ou **NA**, a recuperação é **imediata** (nas aulas seguintes): anote o que falta no Kanban.

### Passo 5: marque a versão 0.9 (5 minutos)

Com a `main` atualizada e tudo revisado:

```bash
git switch main
git pull
git tag v0.9
git push origin v0.9
```

No GitHub, a tag `v0.9` aparece na lista de tags do repositório.

## Explicação do Código

Esta aula não tem código novo; explicamos o que cada parte da avaliação procura:

- **Checklist técnica:** repete, em uma lista só, os cuidados de segurança, de qualidade e de acessibilidade que o projeto pede desde a Aula 1. É a **vistoria final**.
- **Roteiro de demonstração:** um roteiro **ensaiado** mostra o fluxo inteiro sem desvios e prova que o sistema entrega o que prometeu (escolher peças, juntar lojas, finalizar, WhatsApp, painel).
- **Prova no banco:** abrir o Supabase para mostrar dois pedidos com o mesmo `grupo_id` prova a regra RN-03 funcionando de verdade, não só na tela.
- **Segurança no console:** mostrar que o banco recusa o preço forjado prova que a segurança está **no banco**.
- **Evidências por indicador:** em vez de "acho que sei", cada indicador exige algo que a avaliadora **vê**: um arquivo, um commit, uma tela.
- **Tag `v0.9`:** marca para sempre o estado do MVP que foi avaliado.

## Validação

1. A checklist técnica está toda marcada (ou os itens pendentes viraram cartões no Kanban).
2. A demonstração completa foi feita em **até 8 minutos**, sem erros.
3. A tabela de requisitos foi preenchida e o que falta virou cartão no Kanban, com prioridade.
4. Cada um dos 5 indicadores tem evidência apresentada e menção registrada.
5. A tag `v0.9` aparece no GitHub (**Marco 4**: MVP publicado).

**Erros comuns**

1. *Sintoma:* a demonstração trava no meio. *Causa:* faltou preparar os dados (duas lojas, uma conta de cliente, produtos com fotos). *Correção:* prepare os dados **antes** e ensaie com o cronômetro.
2. *Sintoma:* a busca por `innerHTML` encontra resultados. *Causa:* sobrou uma linha antiga em algum arquivo. *Correção:* troque por `createElement` e `textContent` (Aula 18) em uma branch e faça o pull request.
3. *Sintoma:* o Supabase não mostra os pedidos na demonstração. *Causa:* o pedido foi feito com outra conta ou o projeto está pausado. *Correção:* confira se está no projeto certo e finalize uma sacola nova.
4. *Sintoma:* `git push origin v0.9` dá "tag already exists". *Causa:* outra integrante já criou a tag. *Correção:* é só conferir no GitHub; uma pessoa basta.

**Se travar**

1. Releia o item da checklist e confira onde ele falha (arquivo ou tela).
2. Se a demonstração falhar, volte ao último passo que funcionou e conserte antes de seguir.
3. Anote o problema no Kanban com gravidade e siga para o próximo item: não gaste os 60 minutos em um só.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- O **MVP publicado e revisado**, marcado como **versão 0.9** (**Marco 4**).
- Uma lista de pendências no Kanban (RF-11, RF-20, RF-22, RF-25 e ajustes) para o **Dia 26**.
- Os 5 indicadores da UC3 avaliados com evidências.

**Como saber que deu certo:** você demonstra, ao vivo e em poucos minutos, o caminho do catálogo ao pedido gravado e prova no Supabase que os dois pedidos têm o mesmo `grupo_id`.
