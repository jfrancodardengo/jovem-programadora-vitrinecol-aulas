# Aula 43 – Publicação em hospedagem estática gratuita (GitHub Pages)

**Dia 15 · Ter 27/10/2026** · **Aula 43** · **UC3**

- **Requisitos cobertos:** RF-24 (a recuperação de senha também funcionando online, com o endereço publicado liberado no Supabase)
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** sistema completo e testado, com as correções mergeadas na branch main (Aulas 40 a 42); repositório público no GitHub

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai **publicar o sistema** no **GitHub Pages** (hospedagem estática gratuita), testar o endereço no **celular**, conferir que os **caminhos são relativos** e que **só a chave pública `anon`** está no código, e liberar o endereço publicado no Supabase para a **recuperação de senha** funcionar online.

**Abertura (10 minutos).** Retomada da Aula 42: o sistema funciona no seu computador (`http://127.0.0.1:5500`), mas só **você** o vê. Um sistema de moda local precisa estar na internet para a cliente abrir no celular. Como o site é só arquivos (HTML, CSS e JavaScript) e o back-end é o Supabase, **não precisamos de servidor próprio**: basta um lugar que "sirva" os arquivos. É o que o GitHub Pages faz de graça.

## O Conceito

**Termos desta aula**

- **Hospedagem estática**: um serviço que apenas **entrega os arquivos** do site, sem rodar código no servidor. O nosso JavaScript roda no navegador da cliente.
- **GitHub Pages**: o serviço gratuito do GitHub que publica o conteúdo de um repositório em um endereço `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.
- **Caminho relativo**: um endereço que parte da pasta atual (`css/base.css`), e não da raiz do site (`/css/base.css`). Como o nosso site fica em uma **subpasta** (`/vitrine-col/`), um caminho que começa com `/` quebraria.
- **Site URL e Redirect URLs**: no Supabase, o endereço do site e a lista de endereços para onde os links dos e-mails (como o de recuperar a senha) podem levar.

**Analogia:** publicar é **abrir a loja ao público**: até aqui você só testava com a porta dos fundos. Agora a vitrine está na rua: confira se a placa (o endereço) está certa e se não deixou nenhuma chave da gaveta de dinheiro (`service_role`) pendurada na porta.

## Mão na Massa

### Passo 1: confira o que vai para a internet (10 minutos)

Antes de publicar, três conferências (use **Ctrl+Shift+F**, em português: **Localizar nos arquivos**; no Mac, Cmd+Shift+F):

1. **Nenhuma chave secreta:** procure `service_role` e `secret`: não pode haver **nenhuma chave** (só o comentário do `js/config.js` que **proíbe** colocá-la). No `js/config.js`, só a URL do projeto e a chave `anon` (pública).
2. **Caminhos relativos:** procure `href="/` e `src="/`: **0 resultados**. Todos os caminhos devem ser como `css/base.css` e `js/paginas/catalogo.js`.
3. **Sem `innerHTML` com dados:** procure `innerHTML` em `js/`: **0 resultados**.
4. Confira que a branch `main` está atualizada: `git status` deve dizer `nothing to commit` e `git pull` não traz nada novo.

### Passo 2: ligue o GitHub Pages

1. No repositório do GitHub, abra **Settings** (em português: **Configurações**) e, no menu da esquerda, **Pages** (em português: **Páginas**).
2. Em **Build and deployment** (em português: **Construção e implantação**), em **Source** (em português: **Origem**), escolha **Deploy from a branch** (em português: **Implantar a partir de uma branch**).
3. Em **Branch**, escolha **main** e a pasta **/ (root)** (em português: **/ (raiz)**) e clique em **Save** (em português: **Salvar**).
4. Espere de 1 a 3 minutos. Atualize a página: aparece **Your site is live at** (em português: **Seu site está no ar em**) e o endereço, parecido com `https://SEU-USUARIO.github.io/vitrine-col/`. Copie-o.

### Passo 3: libere o endereço publicado no Supabase

No painel do Supabase, abra **Authentication** (em português: **Autenticação**) e **URL Configuration** (em português: **Configuração de URL**):

1. Em **Site URL** (em português: **URL do site**), troque `http://127.0.0.1:5500` pelo endereço publicado, **com a barra no fim**: `https://SEU-USUARIO.github.io/vitrine-col/`.
2. Em **Redirect URLs** (em português: **URLs de redirecionamento**), **acrescente** (sem apagar os de teste) `https://SEU-USUARIO.github.io/vitrine-col/recuperar-senha.html`.
3. Clique em **Save** (em português: **Salvar**).

### Passo 4: teste o endereço publicado no computador e no celular

1. **No computador:** abra o endereço. A página inicial aparece com o carrossel e os destaques. Percorra o fluxo: catálogo, produto, sacola, **Entrar**, finalizar um pedido (CT-07), e confira o painel da lojista.
2. **Recuperação de senha online (RF-24):** em **Entrar**, clique em **Esqueci minha senha**, informe o e-mail de uma conta (de um membro da organização, se necessário), abra o e-mail e confira que o link **abre o site publicado** (e não o endereço de teste) na tela da senha nova.
3. **No celular:** abra o mesmo endereço no navegador do celular (pode digitar ou enviar o link para você mesma). Teste: o menu, o carrossel (arrastando o dedo), a escolha de tamanho na página do produto e a sacola. Nenhuma tela deve ter rolagem horizontal.
4. Se alguma imagem, estilo ou script **não carregar**, aperte F12 > **Console** (em português: **Console**) e abra a aba **Network** (em português: **Rede**): os pedidos com erro **404** mostram o caminho errado.
5. Cole o endereço no `README.md` (por enquanto, em uma linha: `Site: https://...`; a Aula 44 refaz o README completo).

### Passo 5: faça o commit da aula

```bash
git add .
git commit -m "Registra o endereço do site publicado no README"
git push
```

Atenção: a cada `git push` na `main`, o GitHub Pages **publica de novo** em alguns minutos.

## Explicação do Código

Nesta aula não há código novo; explicamos as decisões:

- **Por que funciona sem servidor?** O GitHub Pages entrega os arquivos como estão, e o navegador roda o JavaScript. O banco, o login e as fotos estão no Supabase, que o navegador chama direto.
- **Por que o caminho relativo importa?** Seu site fica em `https://usuario.github.io/vitrine-col/`. Um link `/css/base.css` procuraria `https://usuario.github.io/css/base.css` (sem `vitrine-col`) e daria 404. `css/base.css` parte da pasta do site.
- **Por que só a chave `anon`?** Qualquer pessoa pode abrir o código do site publicado (aba **Sources**, em português: **Fontes**, do F12). A chave `anon` é pública **por desenho**: quem protege os dados é a **RLS** (Aula 39). Já a `service_role` ignora a RLS: no código público, daria acesso total ao banco a qualquer um.
- **Por que mudar o Site URL e os Redirect URLs?** O link do e-mail de recuperação precisa levar ao **site publicado**. O Supabase só redireciona para endereços da lista, para um atacante não conseguir desviar o link para um site falso.
- **Por que o Pages publica de novo a cada `push`?** O Pages "olha" a branch `main`; cada novo commit nela gera uma nova versão do site.

## Validação

1. O endereço `https://SEU-USUARIO.github.io/vitrine-col/` abre a página inicial, com estilo, imagens, carrossel e dados do Supabase.
2. O fluxo de pedido funciona online: catálogo, sacola, login, finalizar, botões de WhatsApp.
3. O link do e-mail de recuperação abre a tela da senha nova no **site publicado** (RF-24 online).
4. No celular, as telas funcionam sem rolagem horizontal.
5. A busca por `service_role` não encontra nenhuma chave e a de `href="/` não encontra nada.

**Erros comuns**

1. *Sintoma:* a página abre, mas **sem estilo** e sem imagens. *Causa:* caminhos que começam com `/` (ou nomes com maiúsculas diferentes: o servidor do GitHub **diferencia** maiúsculas de minúsculas, `Css/` não é `css/`). *Correção:* use caminhos relativos e confira a grafia exata das pastas e arquivos.
2. *Sintoma:* **404** no endereço do site. *Causa:* o Pages ainda não terminou de publicar, ou a branch/pasta escolhida está errada. *Correção:* espere uns minutos e confira **Settings > Pages** (em português: **Configurações > Páginas**): a origem deve ser **main** e **/ (root)**.
3. *Sintoma:* a página inicial abre, mas o catálogo mostra o aviso de **configuração de exemplo**. *Causa:* o `js/config.js` publicado ainda tem os valores de exemplo. *Correção:* confirme que o `config.js` com os valores reais foi commitado e enviado (`git push`).
4. *Sintoma:* o link do e-mail de recuperação abre o endereço de teste, ou dá erro. *Causa:* o endereço publicado não está nos **Redirect URLs** ou o **Site URL** ficou o antigo. *Correção:* repita o Passo 3, com o endereço exato.

**Se travar**

1. Abra o Console (F12) e a aba **Network** (em português: **Rede**) no endereço publicado: os 404 e os erros vermelhos mostram o que falta.
2. Compare o que funciona no `127.0.0.1:5500` com o que falha online: a diferença costuma ser o caminho ou a configuração do Supabase.
3. Se mudou algo, faça `git push` e espere o Pages republicar.
4. Só depois peça ajuda à sua equipe, dizendo o endereço, a tela e a mensagem.

**Seu projeto agora tem**

- O sistema **publicado** e acessível por um link público.
- O Supabase configurado para o endereço publicado (Site URL e Redirect URLs).
- A conferência de segurança feita: só a chave pública no código, caminhos relativos e sem `innerHTML` com dados.

**Como saber que deu certo:** você abre o link no celular, monta uma sacola e a página inicial, o catálogo e o login funcionam como no computador.
