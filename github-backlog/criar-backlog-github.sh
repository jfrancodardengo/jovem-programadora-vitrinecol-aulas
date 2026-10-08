#!/usr/bin/env bash
# =====================================================================
# criar-backlog-github.sh
# Cria etiquetas, marcos (um por dia de aula) e as 54 issues do backlog
# no repositório da sua equipe, usando o GitHub CLI (gh).
#
# Como rodar (dentro da pasta github-backlog):
#   DRY_RUN=1 bash criar-backlog-github.sh     # só mostra o que faria
#   bash criar-backlog-github.sh               # cria de verdade
#
# Pode rodar de novo sem medo: o que já existe é pulado.
# =====================================================================

# ---------- 1) Variáveis que você pode editar ----------

# Endereço da pasta de aulas (onde ficam os arquivos dia01-aula01-....md).
# Troque pelo endereço real. Ele é colocado nos links dentro de cada issue.
URL_GUIA="${URL_GUIA:-https://github.com/SEU-USUARIO/SEU-REPOSITORIO-DO-MATERIAL/blob/main/docs/guia-aulas}"

# Repositório da equipe, no formato dono/nome (exemplo: ana-souza/vitrine-col).
# Se ficar vazio, o script usa o repositório da pasta atual (gh repo view).
REPO="${REPO:-}"

# Projeto do GitHub (opcional). Se preencher os dois, cada issue criada
# também é adicionada ao projeto. O número aparece no endereço do projeto:
# https://github.com/orgs/DONO/projects/NUMERO
PROJETO_DONO="${PROJETO_DONO:-}"
PROJETO_NUMERO="${PROJETO_NUMERO:-}"

# Modo de teste: DRY_RUN=1 só mostra o que seria feito, sem criar nada.
DRY_RUN="${DRY_RUN:-0}"

# ---------- 2) Conferências iniciais ----------

PASTA="$(cd "$(dirname "$0")" && pwd)"

if ! command -v gh >/dev/null 2>&1; then
  echo "ERRO: o GitHub CLI (gh) não está instalado."
  echo "Instale pelo LEIA-ME.md (Windows: winget install --id GitHub.cli | Mac: brew install gh) e rode de novo."
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "ERRO: você ainda não fez login no GitHub CLI."
  echo "Rode: gh auth login   (escolha GitHub.com e siga as perguntas) e rode este script de novo."
  exit 1
fi

if [ -n "$PROJETO_NUMERO" ]; then
  if [ -z "$PROJETO_DONO" ]; then
    echo "ERRO: você preencheu PROJETO_NUMERO, mas falta o PROJETO_DONO (seu usuário ou o nome da organização)."
    exit 1
  fi
  if ! gh auth status 2>&1 | grep -q "project"; then
    echo "ERRO: seu login ainda não tem a permissão de projetos."
    echo "Rode: gh auth refresh -s project   e rode este script de novo."
    exit 1
  fi
fi

if [ -z "$REPO" ]; then
  REPO="$(gh repo view --json nameWithOwner --jq .nameWithOwner 2>/dev/null)"
fi
if [ -z "$REPO" ]; then
  echo "ERRO: não consegui descobrir o repositório."
  echo "Edite a variável REPO no começo do script (exemplo: REPO=\"ana-souza/vitrine-col\") ou rode dentro da pasta do repositório."
  exit 1
fi

case "$URL_GUIA" in
  *SEU-USUARIO*)
    echo "AVISO: URL_GUIA ainda tem o valor de exemplo. Os links das aulas dentro das issues vão ficar errados."
    echo "       Edite a variável URL_GUIA no começo do script se quiser links certos."
    ;;
esac

echo "Repositório: $REPO"
if [ "$DRY_RUN" = "1" ]; then
  echo "MODO DE TESTE (DRY_RUN=1): nada será criado."
fi
echo

# ---------- 3) O que já existe no repositório (para não duplicar) ----------

ETIQUETAS_EXISTENTES="$(gh label list --repo "$REPO" --limit 200 --json name --jq '.[].name' 2>/dev/null)"
MARCOS_EXISTENTES="$(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq '.[].title' 2>/dev/null)"
ISSUES_EXISTENTES="$(gh issue list --repo "$REPO" --state all --limit 1000 --json title --jq '.[].title' 2>/dev/null)"

# Contadores do resumo final
ETQ_CRIADAS=0; ETQ_PULADAS=0
MAR_CRIADOS=0; MAR_PULADOS=0
ISS_CRIADAS=0; ISS_PULADAS=0
FALHAS=0

# O {{URL_GUIA}} dos arquivos é trocado pelo valor de URL_GUIA (com cuidado com & e |).
URL_GUIA_SED="$(printf '%s' "$URL_GUIA" | sed -e 's/[&|\\]/\\&/g')"
CORPO_TMP="$(mktemp)"
trap 'rm -f "$CORPO_TMP"' EXIT

# ---------- 4) Funções (cada uma faz uma coisa só) ----------

# criar_etiqueta NOME COR DESCRIÇÃO
criar_etiqueta() {
  if printf '%s\n' "$ETIQUETAS_EXISTENTES" | grep -Fxq -- "$1"; then
    echo "  pulada (já existe): $1"
    ETQ_PULADAS=$((ETQ_PULADAS + 1))
    return
  fi
  if [ "$DRY_RUN" = "1" ]; then
    echo "  [teste] criaria a etiqueta: $1"
    ETQ_CRIADAS=$((ETQ_CRIADAS + 1))
    return
  fi
  if gh label create "$1" --repo "$REPO" --color "$2" --description "$3" >/dev/null; then
    echo "  criada: $1"
    ETQ_CRIADAS=$((ETQ_CRIADAS + 1))
  else
    echo "  FALHOU: $1"
    FALHAS=$((FALHAS + 1))
  fi
}

# criar_marco TÍTULO DATA_DE_ENTREGA(AAAA-MM-DDT12:00:00Z) DESCRIÇÃO
criar_marco() {
  if printf '%s\n' "$MARCOS_EXISTENTES" | grep -Fxq -- "$1"; then
    echo "  pulado (já existe): $1"
    MAR_PULADOS=$((MAR_PULADOS + 1))
    return
  fi
  if [ "$DRY_RUN" = "1" ]; then
    echo "  [teste] criaria o marco: $1 (entrega $2)"
    MAR_CRIADOS=$((MAR_CRIADOS + 1))
    return
  fi
  if gh api "repos/$REPO/milestones" -f title="$1" -f due_on="$2" -f description="$3" --silent; then
    echo "  criado: $1"
    MAR_CRIADOS=$((MAR_CRIADOS + 1))
  else
    echo "  FALHOU: $1"
    FALHAS=$((FALHAS + 1))
  fi
}

# criar_issue TÍTULO ARQUIVO MARCO ETIQUETA...
criar_issue() {
  TITULO="$1"; ARQUIVO="$2"; MARCO="$3"; shift 3
  if printf '%s\n' "$ISSUES_EXISTENTES" | grep -Fxq -- "$TITULO"; then
    echo "  pulada (já existe): $TITULO"
    ISS_PULADAS=$((ISS_PULADAS + 1))
    return
  fi
  ETIQUETAS_ARGS=()
  for ETQ in "$@"; do
    ETIQUETAS_ARGS+=(--label "$ETQ")
  done
  if [ "$DRY_RUN" = "1" ]; then
    echo "  [teste] criaria a issue: $TITULO  (marco: $MARCO; etiquetas: $*)"
    ISS_CRIADAS=$((ISS_CRIADAS + 1))
    return
  fi
  sed "s|{{URL_GUIA}}|$URL_GUIA_SED|g" "$PASTA/issues/$ARQUIVO" > "$CORPO_TMP"
  if URL_ISSUE="$(gh issue create --repo "$REPO" --title "$TITULO" --body-file "$CORPO_TMP" --milestone "$MARCO" "${ETIQUETAS_ARGS[@]}")"; then
    echo "  criada: $TITULO"
    ISS_CRIADAS=$((ISS_CRIADAS + 1))
    if [ -n "$PROJETO_NUMERO" ]; then
      gh project item-add "$PROJETO_NUMERO" --owner "$PROJETO_DONO" --url "$URL_ISSUE" >/dev/null \
        || echo "  AVISO: a issue foi criada, mas não entrou no projeto: $URL_ISSUE"
    fi
  else
    echo "  FALHOU: $TITULO"
    FALHAS=$((FALHAS + 1))
  fi
  sleep 1   # espera um pouco para o GitHub não bloquear o script
}

# ---------- 5) Etiquetas ----------
echo "== Etiquetas =="
criar_etiqueta 'Configuração' 6f42c1 'Instalar ferramentas, criar repositório e ajustar o ambiente'
criar_etiqueta 'Front-end (HTML/CSS)' 1d76db 'Páginas, estilos, layout, responsividade e telas no Figma'
criar_etiqueta 'JavaScript' f1e05a 'Scripts das páginas, DOM, eventos e validações'
criar_etiqueta 'Orientação a Objetos' 0e8a16 'Classes, herança, polimorfismo, agregação e erros próprios'
criar_etiqueta 'Supabase (Banco de Dados)' 3ecf8e 'Tabelas, SQL, consultas, Storage e ligação do site ao Supabase'
criar_etiqueta 'Segurança' d73a4a 'Login, RLS, chaves, proteção de telas e testes de acesso indevido'
criar_etiqueta 'Fluxo de Pedido' f9a03f 'Sacola, finalização, pedidos por loja, status e avisos'
criar_etiqueta 'Testes' 5319e7 'Casos de teste, depuração e correções'
criar_etiqueta 'Publicação' 006b75 'GitHub Pages, versões e endereço publicado'
criar_etiqueta 'Documentação' 0075ca 'Backlog, README, guia de estilo e relatórios'
criar_etiqueta 'Essencial' b60205 'O sistema não funciona sem isso'
criar_etiqueta 'Importante' ff7619 'Faz muita falta, mas o sistema ainda funciona sem isso'
criar_etiqueta 'Desejável' c5def5 'Melhora o sistema; é o primeiro a sair se o tempo apertar'

echo
echo "== Marcos (um por dia de aula) =="
criar_marco 'Dia 1 · 06/10 · terça-feira' 2026-10-06T12:00:00Z 'Entrega do dia: backlog do MVP, repositório da equipe e primeira página aberta no Live Server.'
criar_marco 'Dia 2 · 07/10 · quarta-feira' 2026-10-07T12:00:00Z 'Entrega do dia: protótipo navegável no Figma e guia de estilo.'
criar_marco 'Dia 3 · 08/10 · quinta-feira' 2026-10-08T12:00:00Z 'Entrega do dia: páginas do projeto em HTML, sem estilo (index.html, login.html, catalogo.html, loja.html e produto.html).'
criar_marco 'Dia 4 · 09/10 · sexta-feira' 2026-10-09T12:00:00Z 'Entrega do dia: páginas estilizadas conforme o guia de estilo (cores, tipografia, cabeçalho, botões, campos e cards em css/variaveis.css, css/base.css, css/componentes.css e css/paginas.css).'
criar_marco 'Dia 5 · 13/10 · terça-feira' 2026-10-13T12:00:00Z 'Entrega do dia: as dez páginas estáticas responsivas, com CSS organizado em quatro arquivos, foco visível e a tag v0.1.'
criar_marco 'Dia 6 · 14/10 · quarta-feira' 2026-10-14T12:00:00Z 'Entrega do dia: interações básicas nas páginas (script ligado ao catálogo, produtos fictícios como array de objetos, cabeçalho gerado pelo JavaScript, avisos e chips que reagem ao clique).'
criar_marco 'Dia 7 · 15/10 · quinta-feira' 2026-10-15T12:00:00Z 'Entrega do dia: catálogo filtrável com dados fictícios (cards desenhados pelo JavaScript, filtros por tipo, loja, tamanho e nome) e formulário de produto com validação.'
criar_marco 'Dia 8 · 16/10 · sexta-feira' 2026-10-16T12:00:00Z 'Entrega do dia: classes de domínio do projeto (ErroApp, Produto, Loja, Usuaria, Cliente, Lojista), catálogo com dados fictícios usando as classes, tratamento de erros e código em módulos (modelos, ui, paginas).'
criar_marco 'Dia 9 · 19/10 · segunda-feira' 2026-10-19T12:00:00Z 'Entrega do dia: banco criado e populado no Supabase (8 tabelas, 4 gatilhos, 8 categorias, lojista de teste, uma loja e 3 produtos de exemplo).'
criar_marco 'Dia 10 · 20/10 · terça-feira' 2026-10-20T12:00:00Z 'Entrega do dia: catálogo lendo do banco (produtos, categorias e lojas do Supabase), com filtros feitos na consulta e paginação de 12 produtos.'
criar_marco 'Dia 11 · 21/10 · quarta-feira' 2026-10-21T12:00:00Z 'Entrega do dia: loja e produtos cadastrados, editados, desativados e excluídos pelo sistema, com até 5 fotos por produto guardadas no Supabase Storage.'
criar_marco 'Dia 12 · 22/10 · quinta-feira' 2026-10-22T12:00:00Z 'Entrega do dia: páginas de produto e de loja com dados do banco, sacola agrupada por loja (localStorage) e "Finalizar sacola" montando um pedido por loja com botão de WhatsApp por loja. **A gravação dos pedidos no banco só entra no Dia 13**, depois do login (RF-10 fica completo no D13·A39).'
criar_marco 'Dia 13 · 23/10 · sexta-feira' 2026-10-23T12:00:00Z 'Entrega do dia: login, recuperação de senha por e-mail e segurança básica (telas protegidas por perfil, RLS nas 8 tabelas, política provisória de fotos apagada e pedidos gravados somente pela função criar_pedidos do banco).'
criar_marco 'Dia 14 · 26/10 · segunda-feira' 2026-10-26T12:00:00Z 'Entrega do dia: página inicial de vitrine (hero, carrossel, tipos de roupa, destaques e lojas) e fluxo completo testado e corrigido, com os 25 casos de teste registrados e o Git organizado em branches e pull requests.'
criar_marco 'Dia 15 · 27/10 · terça-feira' 2026-10-27T12:00:00Z 'Entrega do dia: sistema publicado no GitHub Pages, README completo com diagrama ER e MVP revisado e demonstrado ao vivo.'
criar_marco 'Dia 26 · 12/11 · quinta-feira' 2026-11-12T12:00:00Z 'Entrega do dia: sistema com conteúdo real e acompanhamento do pedido: a lojista atualiza o status e deixa recado, a cliente é avisada dentro do sistema, a conta pode ser excluída e o catálogo tem lojas, produtos e fotos reais.'
criar_marco 'Dia 27 · 13/11 · sexta-feira' 2026-11-13T12:00:00Z 'Entrega do dia: relatório de testes (docs/relatorio-de-testes.md) com os 25 casos executados no site publicado, as anotações de pelo menos 5 testes com usuárias externas e a lista priorizada de correções com responsável e prazo.'
criar_marco 'Dia 28 · 16/11 · segunda-feira' 2026-11-16T12:00:00Z 'Entrega do dia: problemas críticos corrigidos e retestados, segurança revisada, versão final publicada, documentação final e código congelado (a partir de agora, só correção de erro grave).'

echo
echo "== Issues =="

# Dia 1 · 06/10 · terça-feira
criar_issue 'D1·A1 – Montar o quadro do GitHub Projects, priorizar os 25 requisitos e formar a equipe' dia01-aula01.md 'Dia 1 · 06/10 · terça-feira' 'Documentação' 'Configuração' 'Essencial'
criar_issue 'D1·A2 – Instalar Git e Live Server, criar o repositório vitrine-col e fazer o primeiro commit de cada integrante' dia01-aula02.md 'Dia 1 · 06/10 · terça-feira' 'Configuração' 'Essencial'
criar_issue 'D1·A3 – Criar a primeira página HTML e abrir com o Live Server' dia01-aula03.md 'Dia 1 · 06/10 · terça-feira' 'Front-end (HTML/CSS)' 'Essencial'

# Dia 2 · 07/10 · quarta-feira
criar_issue 'D2·A4 – Desenhar os wireframes do Catálogo, da Loja, do Produto e do Login' dia02-aula04.md 'Dia 2 · 07/10 · quarta-feira' 'Front-end (HTML/CSS)' 'Documentação' 'Importante'
criar_issue 'D2·A5 – Montar o protótipo navegável no Figma (Catálogo, Produto e Sacola)' dia02-aula05.md 'Dia 2 · 07/10 · quarta-feira' 'Front-end (HTML/CSS)' 'Importante'
criar_issue 'D2·A6 – Definir nome, paleta, tipografia e guia de estilo (Marco 1)' dia02-aula06.md 'Dia 2 · 07/10 · quarta-feira' 'Front-end (HTML/CSS)' 'Documentação' 'Importante'

# Dia 3 · 08/10 · quinta-feira
criar_issue 'D3·A7 – Reescrever o index.html com HTML semântico (cabeçalho e rodapé comuns)' dia03-aula07.md 'Dia 3 · 08/10 · quinta-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D3·A8 – Criar login.html e catalogo.html com listas e formulários rotulados' dia03-aula08.md 'Dia 3 · 08/10 · quinta-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D3·A9 – Montar catalogo, loja, produto e login em HTML e ligar as páginas por links' dia03-aula09.md 'Dia 3 · 08/10 · quinta-feira' 'Front-end (HTML/CSS)' 'Essencial'

# Dia 4 · 09/10 · sexta-feira
criar_issue 'D4·A10 – Criar css/variaveis.css e css/base.css e ligar às cinco páginas' dia04-aula10.md 'Dia 4 · 09/10 · sexta-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D4·A11 – Montar cabeçalho, menu, botões, campos e chips com Flexbox (componentes.css)' dia04-aula11.md 'Dia 4 · 09/10 · sexta-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D4·A12 – Criar o card de produto com Grid e estilizar o catálogo (paginas.css)' dia04-aula12.md 'Dia 4 · 09/10 · sexta-feira' 'Front-end (HTML/CSS)' 'Essencial'

# Dia 5 · 13/10 · terça-feira
criar_issue 'D5·A13 – Tornar catálogo, loja, produto e login responsivos (mobile-first, 768 px e 1024 px)' dia05-aula13.md 'Dia 5 · 13/10 · terça-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D5·A14 – Fechar o base.css: foco visível, link "Ir para o conteúdo", contraste e variáveis' dia05-aula14.md 'Dia 5 · 13/10 · terça-feira' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D5·A15 – Criar as cinco telas estáticas restantes, revisar a acessibilidade e marcar a versão 0.1 (Marco 2)' dia05-aula15.md 'Dia 5 · 13/10 · terça-feira' 'Front-end (HTML/CSS)' 'Testes' 'Essencial'

# Dia 6 · 14/10 · quarta-feira
criar_issue 'D6·A16 – Ligar o primeiro script ao catálogo e treinar variáveis, tipos e condicionais no Console' dia06-aula16.md 'Dia 6 · 14/10 · quarta-feira' 'JavaScript' 'Essencial'
criar_issue 'D6·A17 – Representar produtos como array de objetos e escrever funções que os percorrem' dia06-aula17.md 'Dia 6 · 14/10 · quarta-feira' 'JavaScript' 'Essencial'
criar_issue 'D6·A18 – Mexer na página com o DOM: criarElemento, avisos, cabeçalho em JavaScript e chips clicáveis' dia06-aula18.md 'Dia 6 · 14/10 · quarta-feira' 'JavaScript' 'Segurança' 'Essencial'

# Dia 7 · 15/10 · quinta-feira
criar_issue 'D7·A19 – Desenhar o catálogo pelo JavaScript: cards, preço em R$ e estado vazio' dia07-aula19.md 'Dia 7 · 15/10 · quinta-feira' 'JavaScript' 'Front-end (HTML/CSS)' 'Essencial'
criar_issue 'D7·A20 – Filtrar o catálogo por tipo, loja, tamanho e nome com filter, find e includes' dia07-aula20.md 'Dia 7 · 15/10 · quinta-feira' 'JavaScript' 'Essencial'
criar_issue 'D7·A21 – Validar o formulário de produto no navegador (submit, preventDefault e erros ao lado do campo)' dia07-aula21.md 'Dia 7 · 15/10 · quinta-feira' 'JavaScript' 'Front-end (HTML/CSS)' 'Essencial'

# Dia 8 · 16/10 · sexta-feira
criar_issue 'D8·A22 – Criar ErroApp, Produto e Loja com campos privados e regras dentro da classe' dia08-aula22.md 'Dia 8 · 16/10 · sexta-feira' 'Orientação a Objetos' 'JavaScript' 'Essencial'
criar_issue 'D8·A23 – Criar Usuaria, Cliente e Lojista (herança e polimorfismo) e ligar Loja a Produto (agregação)' dia08-aula23.md 'Dia 8 · 16/10 · sexta-feira' 'Orientação a Objetos' 'Essencial'
criar_issue 'D8·A24 – Tratar erros com try/catch e ErroApp e organizar o código em módulos' dia08-aula24.md 'Dia 8 · 16/10 · sexta-feira' 'JavaScript' 'Orientação a Objetos' 'Essencial'

# Dia 9 · 19/10 · segunda-feira
criar_issue 'D9·A25 – Criar o projeto vitrine-col no Supabase e ler o diagrama das 8 tabelas' dia09-aula25.md 'Dia 9 · 19/10 · segunda-feira' 'Supabase (Banco de Dados)' 'Configuração' 'Essencial'
criar_issue 'D9·A26 – Rodar o 01_schema.sql no Supabase: 8 tabelas, 4 gatilhos e 8 categorias' dia09-aula26.md 'Dia 9 · 19/10 · segunda-feira' 'Supabase (Banco de Dados)' 'Essencial'
criar_issue 'D9·A27 – Praticar SELECT, INSERT e JOIN, criar a lojista de teste e carregar a Loja Exemplo com 3 produtos' dia09-aula27.md 'Dia 9 · 19/10 · segunda-feira' 'Supabase (Banco de Dados)' 'Essencial'

# Dia 10 · 20/10 · terça-feira
criar_issue 'D10·A28 – Buscar os dados com async/await e fetch, com "Carregando…" e erro (arquivos JSON de teste)' dia10-aula28.md 'Dia 10 · 20/10 · terça-feira' 'JavaScript' 'Essencial'
criar_issue 'D10·A29 – Conectar o site ao Supabase com supabase-js e listar os produtos do banco' dia10-aula29.md 'Dia 10 · 20/10 · terça-feira' 'Supabase (Banco de Dados)' 'JavaScript' 'Essencial'
criar_issue 'D10·A30 – Passar os filtros para a consulta ao banco e criar o "Carregar mais produtos" (12 por página)' dia10-aula30.md 'Dia 10 · 20/10 · terça-feira' 'Supabase (Banco de Dados)' 'JavaScript' 'Essencial'

# Dia 11 · 21/10 · quarta-feira
criar_issue 'D11·A31 – Cadastrar a loja e os produtos (INSERT) como lojista de teste' dia11-aula31.md 'Dia 11 · 21/10 · quarta-feira' 'Supabase (Banco de Dados)' 'JavaScript' 'Essencial'
criar_issue 'D11·A32 – Editar, desativar, ativar e excluir produtos (UPDATE e DELETE)' dia11-aula32.md 'Dia 11 · 21/10 · quarta-feira' 'Supabase (Banco de Dados)' 'JavaScript' 'Essencial'
criar_issue 'D11·A33 – Enviar até 5 fotos por produto ao Supabase Storage, com capa, reordenação e versão 0.5 (Marco 3)' dia11-aula33.md 'Dia 11 · 21/10 · quarta-feira' 'Supabase (Banco de Dados)' 'Segurança' 'Importante'

# Dia 12 · 22/10 · quinta-feira
criar_issue 'D12·A34 – Montar as páginas de produto (galeria) e de loja (endereço e mapa) usando o id na URL' dia12-aula34.md 'Dia 12 · 22/10 · quinta-feira' 'JavaScript' 'Supabase (Banco de Dados)' 'Essencial'
criar_issue 'D12·A35 – Criar a sacola com localStorage, agrupada por loja, com subtotais, total e contador' dia12-aula35.md 'Dia 12 · 22/10 · quinta-feira' 'JavaScript' 'Fluxo de Pedido' 'Essencial'
criar_issue 'D12·A36 – Finalizar a sacola em um pedido por loja, com o mesmo grupo_id, e botão de WhatsApp por loja' dia12-aula36.md 'Dia 12 · 22/10 · quinta-feira' 'Fluxo de Pedido' 'JavaScript' 'Essencial'

# Dia 13 · 23/10 · sexta-feira
criar_issue 'D13·A37 – Criar cadastro, login e logout com Supabase Auth' dia13-aula37.md 'Dia 13 · 23/10 · sexta-feira' 'Segurança' 'Supabase (Banco de Dados)' 'Essencial'
criar_issue 'D13·A38 – Fazer a recuperação de senha por e-mail ("Esqueci minha senha")' dia13-aula38.md 'Dia 13 · 23/10 · sexta-feira' 'Segurança' 'Supabase (Banco de Dados)' 'Importante'
criar_issue 'D13·A39 – Proteger as telas por perfil, ligar a RLS e gravar os pedidos com a função criar_pedidos' dia13-aula39.md 'Dia 13 · 23/10 · sexta-feira' 'Segurança' 'Fluxo de Pedido' 'Essencial'

# Dia 14 · 26/10 · segunda-feira
criar_issue 'D14·A40 – Construir a página inicial de vitrine com hero, carrossel, tipos de roupa, destaques e lojas' dia14-aula40.md 'Dia 14 · 26/10 · segunda-feira' 'Front-end (HTML/CSS)' 'JavaScript' 'Importante'
criar_issue 'D14·A41 – Depurar com as DevTools e executar os 25 casos de teste (CT-01 a CT-25)' dia14-aula41.md 'Dia 14 · 26/10 · segunda-feira' 'Testes' 'Documentação' 'Essencial'
criar_issue 'D14·A42 – Corrigir os defeitos graves com branch, pull request revisado e merge' dia14-aula42.md 'Dia 14 · 26/10 · segunda-feira' 'Testes' 'Configuração' 'Essencial'

# Dia 15 · 27/10 · terça-feira
criar_issue 'D15·A43 – Publicar o site no GitHub Pages e liberar o endereço publicado no Supabase' dia15-aula43.md 'Dia 15 · 27/10 · terça-feira' 'Publicação' 'Segurança' 'Essencial'
criar_issue 'D15·A44 – Escrever o README completo com diagrama ER e instruções de uso' dia15-aula44.md 'Dia 15 · 27/10 · terça-feira' 'Documentação' 'Importante'
criar_issue 'D15·A45 – Revisar o MVP, demonstrar o fluxo completo e marcar a versão 0.9 (Marco 4)' dia15-aula45.md 'Dia 15 · 27/10 · terça-feira' 'Testes' 'Publicação' 'Essencial'

# Dia 26 · 12/11 · quinta-feira
criar_issue 'D26·A76 – Criar a tela Pedidos recebidos e o fluxo de status da lojista' dia26-aula76.md 'Dia 26 · 12/11 · quinta-feira' 'Fluxo de Pedido' 'Segurança' 'Importante'
criar_issue 'D26·A77 – Criar Meus pedidos e o aviso de novidades para a cliente' dia26-aula77.md 'Dia 26 · 12/11 · quinta-feira' 'Fluxo de Pedido' 'JavaScript' 'Importante'
criar_issue 'D26·A78 – Criar Minha conta com exclusão da própria conta (EXCLUIR)' dia26-aula78.md 'Dia 26 · 12/11 · quinta-feira' 'Segurança' 'Supabase (Banco de Dados)' 'Importante'

# Dia 27 · 13/11 · sexta-feira
criar_issue 'D27·A79 – Executar os 25 casos de teste no site publicado e escrever o roteiro de usabilidade' dia27-aula79.md 'Dia 27 · 13/11 · sexta-feira' 'Testes' 'Documentação' 'Essencial'
criar_issue 'D27·A80 – Aplicar o roteiro de usabilidade com pelo menos 5 usuárias externas e registrar cada problema' dia27-aula80.md 'Dia 27 · 13/11 · sexta-feira' 'Testes' 'Importante'
criar_issue 'D27·A81 – Consolidar o relatório de testes e priorizar as correções em crítico, importante e desejável' dia27-aula81.md 'Dia 27 · 13/11 · sexta-feira' 'Testes' 'Documentação' 'Essencial'

# Dia 28 · 16/11 · segunda-feira
criar_issue 'D28·A82 – Corrigir os problemas críticos em branches e refazer os casos de teste' dia28-aula82.md 'Dia 28 · 16/11 · segunda-feira' 'Testes' 'JavaScript' 'Essencial'
criar_issue 'D28·A83 – Revisar a segurança (RLS, chaves, acessos indevidos) e publicar a versão final' dia28-aula83.md 'Dia 28 · 16/11 · segunda-feira' 'Segurança' 'Publicação' 'Essencial'
criar_issue 'D28·A84 – Fechar a documentação, marcar a versão 1.0 e congelar o código (Marco 8)' dia28-aula84.md 'Dia 28 · 16/11 · segunda-feira' 'Documentação' 'Publicação' 'Essencial'

# ---------- 6) Resumo ----------
echo
echo "================ RESUMO ================"
if [ "$DRY_RUN" = "1" ]; then
  echo "(modo de teste: os números abaixo são o que SERIA criado)"
fi
echo "Etiquetas: $ETQ_CRIADAS criadas, $ETQ_PULADAS puladas"
echo "Marcos:    $MAR_CRIADOS criados, $MAR_PULADOS pulados"
echo "Issues:    $ISS_CRIADAS criadas, $ISS_PULADAS puladas"
if [ "$FALHAS" -gt 0 ]; then
  echo "ATENÇÃO: $FALHAS item(ns) falharam. Leia as mensagens acima e rode o script de novo (o que já foi criado será pulado)."
  exit 1
fi
echo "Tudo certo!"
