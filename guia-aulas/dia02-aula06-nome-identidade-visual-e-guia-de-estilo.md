# Aula 6 – Nome, identidade visual e guia de estilo

**Dia 2 · Qua 07/10/2026** · **Aula 6** · **UC3**

- **Requisitos cobertos:** não se aplica (identidade visual; prepara RNF de contraste e acessibilidade nível AA)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** protótipo navegável no Figma testado com uma colega (Aula 5). Um navegador para abrir o verificador de contraste

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai escolher o **nome** da plataforma, definir a **paleta de cores** (com contraste suficiente para ler), a **tipografia** e o estilo do **botão** e do **card**, e registrar tudo em um **guia de estilo** de uma página (**Marco 1** do curso).

**Abertura (10 minutos).** Retomada da Aula 5: o protótipo está em preto e branco. Hoje ele ganha identidade. Para você não ter que inventar tudo do zero em uma aula, este guia traz uma paleta pronta e testada. A equipe pode **trocar** as cores, desde que cada par de cor de texto e fundo passe no teste de contraste do Passo 3.

## O Conceito

**Termos desta aula**

- **Identidade visual**: o conjunto de nome, cores, fonte e estilo dos elementos que faz o sistema ser reconhecido.
- **Guia de estilo**: uma página que registra essas escolhas, para qualquer integrante desenhar e programar do mesmo jeito.
- **Contraste**: a diferença de claridade entre a cor do texto e a cor do fundo. É medido por um número (por exemplo 7:1). Texto normal precisa de **pelo menos 4,5:1** (nível AA de acessibilidade).
- **Tipografia**: a escolha da fonte, dos tamanhos e dos pesos dos textos.

**Analogia:** o guia de estilo é o "manual da marca" de uma loja: define o uniforme, a cor da sacola e o jeito de falar com o cliente. Sem ele, cada pessoa da equipe vestiria a loja de um jeito.

**Por que cuidar do contraste?** Muita gente lê no celular sob sol forte, tem baixa visão ou daltonismo. Cores bonitas que não se leem não servem. E o nível AA é uma regra internacional de acessibilidade que vamos seguir no projeto.

## Mão na Massa

### Passo 1: escolha o nome (5 minutos)

O nome de trabalho do projeto deste curso é **VitrineCol**. Ele aparece nos textos e no código das aulas seguintes, então **use esse nome**. (Se a sua equipe preferir outro, anote-o agora e lembre-se de trocá-lo nos textos quando aparecer "VitrineCol" nas aulas.) Escreva também uma frase-slogan, por exemplo: "Moda das lojas do seu bairro".

### Passo 2: monte a paleta (15 minutos)

No Figma, crie um quadro novo chamado `Guia de estilo`. Para cada cor abaixo, desenhe um quadradinho com o código da cor e o nome. A coluna **Nome no código** será usada no CSS, a partir da Aula 10 (por isso os nomes são em português, sem acento):

| Nome no código | Cor | Para que serve |
| --- | --- | --- |
| `--cor-primaria` | `#8a2252` | botões, links em destaque |
| `--cor-primaria-escura` | `#6b1a40` | títulos, logotipo, estado de passar o mouse |
| `--cor-primaria-clara` | `#f7e6ee` | fundos suaves de destaque |
| `--cor-fundo` | `#fbf8f6` | fundo da página |
| `--cor-superficie` | `#ffffff` | fundo de cartões e campos |
| `--cor-texto` | `#2b2230` | texto principal |
| `--cor-texto-suave` | `#5d5365` | textos secundários |
| `--cor-texto-sobre-primaria` | `#ffffff` | texto sobre botões coloridos |
| `--cor-borda` | `#ddd5da` | linhas e bordas leves |
| `--cor-borda-campo` | `#7a6f82` | borda dos campos de digitar |
| `--cor-erro` / `--cor-erro-fundo` | `#b3261e` / `#fde8e6` | avisos de erro |
| `--cor-sucesso` / `--cor-sucesso-fundo` | `#1b6b3a` / `#e6f4ea` | avisos de sucesso |
| `--cor-info` / `--cor-info-fundo` | `#1d4e89` / `#e3eefb` | avisos de informação |
| `--cor-neutro` / `--cor-neutro-fundo` | `#3d3a40` / `#ececee` | selos neutros |
| `--cor-foco` | `#1a5fb4` | contorno de quem navega pelo teclado |

### Passo 3: teste o contraste (10 minutos)

1. Abra um verificador de contraste, por exemplo https://webaim.org/resources/contrastchecker/ (em inglês: o campo **Foreground Color** é a cor do texto e **Background Color** é a cor do fundo).
2. Teste estes pares e anote o resultado. Todos devem dar **4,5 ou mais**:

| Texto | Fundo | Contraste aproximado |
| --- | --- | --- |
| `#ffffff` | `#8a2252` | 8,6:1 |
| `#2b2230` | `#fbf8f6` | 14,4:1 |
| `#5d5365` | `#ffffff` | 7,3:1 |
| `#b3261e` | `#fde8e6` | 5,6:1 |

3. Se a sua equipe trocar uma cor, repita o teste com o novo par. Se der menos de 4,5, escureça o texto até passar.

### Passo 4: defina a tipografia e os elementos (15 minutos)

Registre no guia:

- **Fonte:** a do próprio sistema, sem baixar nada: `system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif`. Ela é rápida e já está no computador e no celular da cliente.
- **Tamanhos:** pequeno 14 px (0,875 rem), normal 16 px (1 rem), médio 18 px (1,125 rem), grande 24 px (1,5 rem), título 28 px (1,75 rem).
- **Botão principal:** fundo `--cor-primaria`, texto branco, cantos arredondados (12 px), altura mínima de 44 px (fácil de tocar), texto em negrito. Ao passar o mouse, o fundo escurece para `--cor-primaria-escura`.
- **Botão secundário:** fundo branco, borda e texto na cor primária escura.
- **Card de produto:** fundo branco, borda fina `--cor-borda`, cantos arredondados, foto na proporção 4:5, depois nome (negrito), preço (cor primária escura, negrito) e nome da loja (texto suave).
- **Espaçamentos:** use sempre múltiplos de 4 px (4, 8, 12, 16, 24, 32, 48).

Desenhe no guia um exemplo de cada um desses elementos.

### Passo 5: aplique no protótipo e registre (5 minutos)

Pinte o protótipo da Aula 5 com a paleta (use as cores como **styles** do Figma se souber; se não, copie os códigos). Cole o link do guia de estilo no `README.md` do repositório e faça o commit:

```bash
git add .
git commit -m "Registra o link do protótipo e do guia de estilo no README"
git push
```

## Explicação do Código

Mesmo sem código, estas decisões aparecem depois nos arquivos:

- **Nomes de cor em português, sem acento, com hífens** (`--cor-primaria`): seguem a convenção do projeto, e na Aula 10 viram variáveis CSS. Trocar uma cor no guia significa trocar uma linha só no CSS.
- **Uma cor para texto, outra para texto suave**: dois níveis de importância bastam.
- **Cores de estado (erro, sucesso, informação) sempre em pares texto/fundo**: o contraste já vem testado.
- **Fonte do sistema**: não há nada para baixar, a página carrega mais rápido e funciona sem internet.
- **Altura mínima de 44 px nos botões**: é o tamanho recomendado para o dedo no celular.
- **Múltiplos de 4 px**: dão ritmo à página e deixam o código previsível.

## Validação

1. O guia de estilo tem: nome e slogan, paleta com código e nome de cada cor, tipografia, botão principal e secundário, card de produto e escala de espaços.
2. Os 4 pares de contraste do Passo 3 foram testados e anotados com resultado igual ou maior que 4,5.
3. O protótipo da Aula 5 usa a paleta.
4. O `README.md` no GitHub mostra o link do protótipo e do guia de estilo.

**Erros comuns**

1. *Sintoma:* texto cinza claro sobre fundo branco, bonito mas difícil de ler. *Causa:* o contraste não foi testado. *Correção:* teste o par no verificador e escureça o texto até passar de 4,5:1.
2. *Sintoma:* cada integrante pinta a tela com um tom de rosa diferente. *Causa:* as cores foram copiadas "a olho". *Correção:* use sempre os códigos hexadecimais da tabela.
3. *Sintoma:* o link do Figma abre pedindo login. *Causa:* o arquivo está privado. *Correção:* mude o compartilhamento para "qualquer pessoa com o link pode visualizar".

**Se travar**

1. Releia o passo e use as cores da tabela exatamente como estão; a tabela já foi testada.
2. Se o verificador de contraste estiver confuso, teste só o primeiro par da tabela e confira se o resultado bate (8,6:1).
3. Se o `git push` falhar, rode `git pull` e tente de novo.
4. Só depois peça ajuda à sua equipe, dizendo o que você já tentou.

**Seu projeto agora tem**

- O `README.md` com o link do protótipo e do guia de estilo.
- Um guia de estilo com a paleta de 15 grupos de cores (nomes em português), tipografia e componentes, testado quanto ao contraste.
- O **Marco 1** do curso: protótipo e guia de estilo prontos.

**Como saber que deu certo:** qualquer integrante consegue desenhar um botão novo, igual aos outros, só olhando o guia de estilo.
