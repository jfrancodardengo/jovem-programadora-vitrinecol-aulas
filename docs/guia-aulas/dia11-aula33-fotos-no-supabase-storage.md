# Aula 33 – Fotos do produto no Supabase Storage

**Dia 11 · Qua 21/10/2026** · **Aula 33** · **UC3**

- **Requisitos cobertos:** RF-19 (até 5 fotos por produto em JPG, PNG ou WebP, com até 2 MB, escolher a capa e reordenar), RN-12 (de 0 a 5 fotos; a primeira é a capa; sem foto aparece uma imagem padrão), RF-18 (ao excluir o produto, as fotos também são apagadas); casos de teste CT-10, CT-16 e CT-25
- **Tempo:** 10 minutos de abertura, 40 de prática e 10 de fechamento (60 minutos)
- **Ponto de partida:** CRUD de produtos sem fotos (lista, cadastro, edição, ativar e excluir); trigger de 5 fotos no banco (Aulas 26 e 32)

> Se você não terminou a aula anterior, refaça os passos dela (estão na seção Mão na Massa) antes de começar esta.

## Objetivo da aula

Em 60 minutos você vai guardar as **fotos dos produtos** no **Supabase Storage**: criar o **bucket** público `produtos` e a **política provisória** de envio, escolher até **5 fotos** (JPG, PNG ou WebP, até 2 MB), **reduzir cada foto para cerca de 200 KB** no navegador, usar a primeira como **capa**, **remover** e **reordenar**, e apagar os arquivos ao excluir o produto. Esta é uma das aulas mais cheias do Dia 11: faça no seu ritmo.

**Abertura (10 minutos).** Retomada da Aula 32: o CRUD de produtos está completo, mas todo produto aparece com a imagem **Sem foto**. Uma foto é um **arquivo**, e arquivos não cabem em tabelas de banco: eles vão para o **Storage**, e o banco guarda só o **endereço** (a tabela `produto_fotos`). Releia a regra: no máximo 5 fotos por produto, 2 MB cada, e a primeira é a capa.

## O Conceito

**Termos desta aula**

- **Storage e bucket**: o Storage é o "armário de arquivos" do Supabase; um **bucket** é uma "gaveta" dentro dele. O nosso, `produtos`, é **público**: qualquer pessoa pode **ver** as fotos pelo endereço (os visitantes veem o catálogo), mas só quem tem permissão pode **enviar**.
- **Política de Storage**: a regra que diz quem pode enviar ou apagar arquivos. Agora vamos usar uma política **provisória** que deixa **qualquer** pessoa enviar (porque o login só chega no Dia 13). No Dia 13 ela é **apagada** e substituída pelas regras de verdade.
- **Upload**: enviar um arquivo do computador para o Storage. O caminho do arquivo no bucket é `{loja_id}/{produto_id}/{uuid}.jpg`: uma pasta por loja e por produto, e um nome único para cada foto.
- **Reduzir a foto no navegador**: o navegador **redesenha** a foto em um `<canvas>` com tamanho menor e a salva como JPEG, até ficar com cerca de 200 KB. Fotos de celular têm vários megabytes; assim o site carrega rápido e gasta menos do plano gratuito.

**Analogia:** o bucket é o **depósito de fotos** de uma loja: o banco guarda só a etiqueta ("a foto 2 do vestido está na prateleira X"). O navegador faz o papel do **fotógrafo que reduz a foto** antes de entregá-la ao depósito.

**Importante (segurança):** a validação do tipo e do tamanho acontece **no navegador** (para a lojista ver o problema na hora) e, mais tarde (Dia 13), **também no servidor** (o bucket recusa o que não for JPG, PNG ou WebP, ou passar de 2 MB). Nunca confie só no navegador.

## Mão na Massa

### Passo 1: crie o bucket e a política provisória no painel

1. No painel do Supabase, abra **Storage** (em português: **Armazenamento**) e clique em **New bucket** (em português: **Novo bucket**).
2. Em **Name** (em português: **Nome**), escreva exatamente `produtos` (minúsculas). Ligue a opção **Public bucket** (em português: **Bucket público**). Clique em **Create** (em português: **Criar**).
3. No **SQL Editor** (em português: **Editor SQL**), rode a política provisória, que permite **enviar** fotos para esse bucket:

```sql
create policy "dev: envio de fotos" on storage.objects for insert to anon
with check (bucket_id = 'produtos');
```

Essa política só permite **enviar**. Ela é **perigosa** (deixa qualquer pessoa enviar arquivos): **vamos apagá-la no Dia 13**. Anote isso no Kanban.

### Passo 2: o serviço de Storage e a redução da foto

Crie `js/servicos/storageServico.js` e `js/ui/imagem.js`:

**Arquivo: `js/servicos/storageServico.js`** (arquivo novo, inteiro)

```js
// Fala com o Storage do Supabase: envia e apaga as fotos dos produtos (RF-19, RN-12).
// As fotos ficam no bucket público "produtos", em pastas por loja: {loja_id}/{produto_id}/{uuid}.{extensão}
// (o 02_rls.sql só deixa a dona da loja mexer na pasta com o id da própria loja).
import { exigirSupabase } from "../supabaseClient.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { paraErroApp } from "./errosSupabase.js";
import { reduzirFoto } from "../ui/imagem.js";

const BUCKET_DAS_FOTOS = "produtos";
export const TAMANHO_MAXIMO_DA_FOTO_EM_BYTES = 2 * 1024 * 1024; // 2 MB (RN-12)

// A extensão vem do TIPO do arquivo (e não do nome), então um "foto.php" com tipo image/png vira ".png"
const EXTENSOES_ACEITAS = { "image/jpeg": "jpg", "image/png": "png", "image/webp": "webp" };

// Confere o formato e o tamanho. Devolve o motivo da recusa em texto, ou "" se o arquivo está bom.
// A tela usa isto assim que a lojista escolhe os arquivos; o enviarFoto usa de novo antes de enviar.
export function validarArquivoDeFoto(arquivo) {
  if (!arquivo || !EXTENSOES_ACEITAS[arquivo.type]) {
    return "formato não aceito. Use JPG, PNG ou WebP.";
  }
  if (arquivo.size > TAMANHO_MAXIMO_DA_FOTO_EM_BYTES) {
    return "a foto tem mais de 2 MB.";
  }
  return "";
}

// RNF-03: reduz a foto para cerca de 200 KB. Se o navegador não conseguir (formato que ele não lê, por exemplo),
// a foto original, que já passou na validação de 2 MB, é enviada do jeito que está.
async function prepararFoto(arquivo) {
  try {
    return await reduzirFoto(arquivo);
  } catch (erro) {
    console.warn("Não foi possível reduzir a foto; enviando a original.", erro);
    return arquivo;
  }
}

// Envia uma foto e devolve { url, caminho }. O "caminho" é guardado em produto_fotos para podermos apagar o arquivo depois.
export async function enviarFoto(arquivo, lojaId, produtoId) {
  const nome = arquivo?.name ?? "foto";

  try {
    const motivo = validarArquivoDeFoto(arquivo);
    if (motivo) {
      throw new ErroApp("foto_invalida", 'A foto "' + nome + '": ' + motivo);
    }

    const supabase = exigirSupabase();
    const arquivoFinal = await prepararFoto(arquivo);
    // O nome do arquivo é um uuid novo: nunca se repete e não depende do nome que a lojista deu
    const caminho = lojaId + "/" + produtoId + "/" + crypto.randomUUID() + "." + EXTENSOES_ACEITAS[arquivoFinal.type];

    const { error } = await supabase.storage.from(BUCKET_DAS_FOTOS).upload(caminho, arquivoFinal, {
      contentType: arquivoFinal.type,
      cacheControl: "3600",
      upsert: false,
    });
    if (error) {
      throw error;
    }

    const { data } = supabase.storage.from(BUCKET_DAS_FOTOS).getPublicUrl(caminho);
    return { url: data.publicUrl, caminho };
  } catch (erro) {
    if (erro instanceof ErroApp && erro.codigo === "foto_invalida") {
      throw erro;
    }
    // O código "erro_ao_enviar_foto" avisa a tela de que ela pode oferecer o endereço (URL) da imagem como alternativa
    throw new ErroApp(
      "erro_ao_enviar_foto",
      'Não foi possível enviar a foto "' + nome + '". Tente de novo ou informe o endereço (URL) de uma imagem.',
      erro
    );
  }
}

// Apaga um arquivo do Storage.
export async function removerFoto(caminho) {
  await removerFotos([caminho]);
}

// Apaga vários arquivos de uma vez.
export async function removerFotos(caminhos) {
  if (caminhos.length === 0) {
    return;
  }
  try {
    const supabase = exigirSupabase();
    const { error } = await supabase.storage.from(BUCKET_DAS_FOTOS).remove(caminhos);
    if (error) {
      throw error;
    }
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível apagar as fotos do armazenamento.");
  }
}

// "Melhor esforço": tenta apagar e, se não der, só avisa no console. Usada na limpeza depois de uma exclusão
// ou de uma falha, quando um arquivo sobrando é só desperdício de espaço e não deve travar a lojista.
export async function tentarRemoverFotos(caminhos) {
  try {
    await removerFotos(caminhos);
    return true;
  } catch (erro) {
    console.warn("Não foi possível apagar fotos do Storage:", caminhos, erro.cause ?? erro);
    return false;
  }
}
```


**Arquivo: `js/ui/imagem.js`** (arquivo novo, inteiro)

```js
// Reduz uma foto no próprio navegador antes do envio (RNF-03: fotos leves, em torno de 200 KB).
// Usa um <canvas> para redesenhar a imagem menor e salvá-la como JPEG. Fica em ui/ porque mexe com o DOM.

export const TAMANHO_ALVO_DA_FOTO_EM_BYTES = 200 * 1024; // 200 KB
const LADO_MAXIMO_EM_PIXELS = 1280; // maior lado da foto: mais que isso só pesa, a tela do celular não mostra
const QUALIDADES_DO_JPEG = [0.85, 0.75, 0.65, 0.55, 0.45];
const FATOR_DE_REDUCAO = 0.75; // se a foto ainda estiver pesada na pior qualidade, diminui o tamanho e tenta de novo
const MAXIMO_DE_REDUCOES = 4;

function carregarImagem(arquivo) {
  return new Promise((resolver, rejeitar) => {
    const endereco = URL.createObjectURL(arquivo);
    const imagem = new Image();
    imagem.onload = () => {
      URL.revokeObjectURL(endereco);
      resolver(imagem);
    };
    imagem.onerror = () => {
      URL.revokeObjectURL(endereco);
      rejeitar(new Error("Não foi possível ler a imagem."));
    };
    imagem.src = endereco;
  });
}

function canvasParaBlob(canvas, qualidade) {
  return new Promise((resolver, rejeitar) => {
    canvas.toBlob(
      (blob) => (blob ? resolver(blob) : rejeitar(new Error("Não foi possível gerar a imagem."))),
      "image/jpeg",
      qualidade
    );
  });
}

// Desenha a imagem no tamanho pedido. O fundo é branco porque JPEG não tem transparência
// (um PNG com fundo transparente ficaria preto sem isso).
function desenhar(imagem, largura, altura) {
  const canvas = document.createElement("canvas");
  canvas.width = largura;
  canvas.height = altura;
  const contexto = canvas.getContext("2d");
  contexto.fillStyle = "#ffffff";
  contexto.fillRect(0, 0, largura, altura);
  contexto.drawImage(imagem, 0, 0, largura, altura);
  return canvas;
}

// Devolve um File JPEG de até ~200 KB. Se a foto já é pequena, devolve o próprio arquivo, sem recomprimir.
// Se não conseguir reduzir (formato que o navegador não lê, por exemplo), lança um erro: quem chama decide se envia o original.
export async function reduzirFoto(arquivo) {
  const imagem = await carregarImagem(arquivo);
  const ladoMaior = Math.max(imagem.naturalWidth, imagem.naturalHeight);

  if (arquivo.size <= TAMANHO_ALVO_DA_FOTO_EM_BYTES && ladoMaior <= LADO_MAXIMO_EM_PIXELS) {
    return arquivo;
  }

  let escala = Math.min(1, LADO_MAXIMO_EM_PIXELS / ladoMaior);
  let melhor = null;

  for (let tentativa = 0; tentativa <= MAXIMO_DE_REDUCOES; tentativa += 1) {
    const largura = Math.max(1, Math.round(imagem.naturalWidth * escala));
    const altura = Math.max(1, Math.round(imagem.naturalHeight * escala));
    const canvas = desenhar(imagem, largura, altura);

    for (const qualidade of QUALIDADES_DO_JPEG) {
      melhor = await canvasParaBlob(canvas, qualidade);
      if (melhor.size <= TAMANHO_ALVO_DA_FOTO_EM_BYTES) {
        return criarArquivo(melhor, arquivo.name);
      }
    }
    escala *= FATOR_DE_REDUCAO;
  }

  // Não chegou a 200 KB, mas é a menor versão que conseguimos: ainda assim vale mais que o original, se for menor
  return melhor.size < arquivo.size ? criarArquivo(melhor, arquivo.name) : arquivo;
}

function criarArquivo(blob, nomeOriginal) {
  const nomeSemExtensao = String(nomeOriginal ?? "foto").replace(/\.[^.]+$/, "") || "foto";
  return new File([blob], nomeSemExtensao + ".jpg", { type: "image/jpeg" });
}
```


### Passo 3: a lista de fotos do formulário

Crie `js/ui/listaDeFotos.js`. Ela desenha a pré-visualização das fotos, o selo **Capa** na primeira e os botões **Mover para cima**, **Mover para baixo** e **Remover**:

**Arquivo: `js/ui/listaDeFotos.js`** (arquivo novo, inteiro)

```js
// Lista de fotos do formulário do produto (RF-19, RN-12): pré-visualização, "Capa" na primeira,
// botões para mover e remover. A ordem da lista é a ordem das fotos; a primeira é a capa.
// Esta lista só cuida da tela. Enviar para o Storage e gravar no banco é com o produtoServico.
import { MAXIMO_DE_FOTOS } from "../modelos/Produto.js";
import { validarArquivoDeFoto } from "../servicos/storageServico.js";

// Opções:
//   elementoLista: o <ul> onde as fotos aparecem
//   elementoAnuncio: um texto com aria-live, onde avisamos os leitores de tela do que mudou
//   elementoFocoSeVazia: para onde o foco vai quando a última foto é removida
//   aoMudar: função chamada sempre que a lista muda
export function criarListaDeFotos({ elementoLista, elementoAnuncio, elementoFocoSeVazia, aoMudar = () => {} }) {
  // Cada item: { chave, origem, id, url, caminho, arquivo, previa, nome }
  //   origem "salva": já estava no banco (tem id, url e talvez caminho)
  //   origem "arquivo": arquivo escolhido agora, ainda não enviado
  //   origem "endereco": endereço (URL) de imagem informado à mão
  let itens = [];
  // Depois de redesenhar a lista, o foco do teclado volta para o botão que a pessoa acabou de usar
  let focoPendente = null;

  function anunciar(texto) {
    elementoAnuncio.textContent = texto;
  }

  function descreverPosicao(indice) {
    return indice === 0 ? "foto 1, a capa" : "foto " + (indice + 1);
  }

  function criarBotao(texto, complemento, acao, desabilitado, aoClicar) {
    const botao = document.createElement("button");
    botao.type = "button";
    botao.className = "botao botao-secundario botao-pequeno";
    botao.dataset.acao = acao;
    botao.disabled = desabilitado;
    if (acao === "remover") {
      botao.classList.remove("botao-secundario");
      botao.classList.add("botao-perigo");
    }
    botao.append(texto);

    // O texto escondido diz de qual foto é o botão: o leitor de tela lê "Mover para cima (foto 2)"
    const oculto = document.createElement("span");
    oculto.className = "visualmente-oculto";
    oculto.textContent = " (" + complemento + ")";
    botao.append(oculto);

    botao.addEventListener("click", aoClicar);
    return botao;
  }

  function descreverOrigem(item) {
    if (item.origem === "salva") {
      return "Foto já salva";
    }
    if (item.origem === "arquivo") {
      return item.nome + " (nova: será enviada ao salvar)";
    }
    return "Endereço informado: " + item.nome;
  }

  function desenhar() {
    const linhas = itens.map((item, indice) => {
      const li = document.createElement("li");
      li.className = "foto-gerenciar";
      li.dataset.chave = item.chave;

      const imagem = document.createElement("img");
      imagem.src = item.previa ?? item.url;
      imagem.alt = "Pré-visualização da " + descreverPosicao(indice);
      imagem.width = 600;
      imagem.height = 750;

      const corpo = document.createElement("div");
      const titulo = document.createElement("p");
      const numero = document.createElement("strong");
      numero.textContent = "Foto " + (indice + 1);
      titulo.append(numero);
      if (indice === 0) {
        const capa = document.createElement("span");
        capa.className = "selo selo-atualizado";
        capa.textContent = "Capa";
        titulo.append(" ", capa);
      }

      // textContent: o nome do arquivo e o endereço vêm de fora, então nunca entram como HTML
      const detalhe = document.createElement("p");
      detalhe.className = "texto-suave";
      detalhe.textContent = descreverOrigem(item);

      const acoes = document.createElement("div");
      acoes.className = "foto-gerenciar-acoes";
      const posicao = "foto " + (indice + 1);
      acoes.append(
        criarBotao("Mover para cima", posicao, "subir", indice === 0, () => mover(item.chave, -1, "subir")),
        criarBotao("Mover para baixo", posicao, "descer", indice === itens.length - 1, () => mover(item.chave, 1, "descer")),
        criarBotao("Remover", posicao, "remover", false, () => remover(item.chave))
      );

      corpo.append(titulo, detalhe, acoes);
      li.append(imagem, corpo);
      return li;
    });

    elementoLista.replaceChildren(...linhas);
    restaurarFoco();
  }

  function restaurarFoco() {
    if (!focoPendente) {
      return;
    }
    const pendente = focoPendente;
    focoPendente = null;

    if (pendente.chave) {
      const li = elementoLista.querySelector('[data-chave="' + pendente.chave + '"]');
      let alvo = li?.querySelector('[data-acao="' + pendente.acao + '"]');
      // Se o botão ficou desabilitado (a foto chegou ao começo ou ao fim), o foco vai para o outro botão de mover
      if (!alvo || alvo.disabled) {
        alvo = li?.querySelector("button:not(:disabled)");
      }
      alvo?.focus();
      return;
    }

    // Depois de remover: foco no "Remover" da foto que ocupou o lugar, ou da última, ou no campo de arquivo
    const botoes = elementoLista.querySelectorAll('[data-acao="remover"]');
    const alvo = botoes[Math.min(pendente.indice, botoes.length - 1)];
    (alvo ?? elementoFocoSeVazia)?.focus();
  }

  function mover(chave, deslocamento, acao) {
    const indice = itens.findIndex((item) => item.chave === chave);
    const destino = indice + deslocamento;
    if (indice < 0 || destino < 0 || destino >= itens.length) {
      return;
    }

    [itens[indice], itens[destino]] = [itens[destino], itens[indice]];
    focoPendente = { chave, acao };
    desenhar();
    anunciar("Foto movida: agora é a " + descreverPosicao(destino) + ".");
    aoMudar();
  }

  function remover(chave) {
    const indice = itens.findIndex((item) => item.chave === chave);
    if (indice < 0) {
      return;
    }

    const [removido] = itens.splice(indice, 1);
    if (removido.previa) {
      URL.revokeObjectURL(removido.previa); // libera a memória da pré-visualização
    }
    focoPendente = { indice };
    desenhar();
    anunciar("Foto removida. Restam " + itens.length + " de " + MAXIMO_DE_FOTOS + " fotos.");
    aoMudar();
  }

  return {
    // Fotos que já estão no banco (ao editar um produto). Devem vir na ordem certa.
    carregarSalvas(fotos) {
      itens = fotos.map((foto) => ({
        chave: crypto.randomUUID(),
        origem: "salva",
        id: foto.id,
        url: foto.url,
        caminho: foto.caminho ?? null,
        nome: foto.url,
      }));
      desenhar();
      aoMudar();
    },

    // Acrescenta arquivos escolhidos. O que for recusado NÃO tira as fotos que já estavam na lista.
    // Devolve a lista de mensagens de problema (vazia quando todos os arquivos foram aceitos).
    adicionarArquivos(arquivos) {
      const problemas = [];
      const semEspaco = [];

      for (const arquivo of Array.from(arquivos)) {
        const motivo = validarArquivoDeFoto(arquivo);
        if (motivo) {
          problemas.push('"' + arquivo.name + '": ' + motivo);
        } else if (itens.length >= MAXIMO_DE_FOTOS) {
          semEspaco.push(arquivo.name);
        } else {
          itens.push({
            chave: crypto.randomUUID(),
            origem: "arquivo",
            arquivo,
            previa: URL.createObjectURL(arquivo),
            nome: arquivo.name,
          });
        }
      }

      // RN-12: a 6ª foto (e as seguintes) são recusadas, mas as 5 primeiras ficam
      if (semEspaco.length > 0) {
        problemas.push(
          "Cada produto pode ter no máximo " + MAXIMO_DE_FOTOS + " fotos. " +
            (semEspaco.length === 1 ? 'A foto "' + semEspaco[0] + '" não foi adicionada.' : semEspaco.length + " fotos não foram adicionadas.")
        );
      }

      desenhar();
      anunciar(problemas.length === 0 ? "Fotos adicionadas. Agora são " + itens.length + "." : "Algumas fotos não foram adicionadas.");
      aoMudar();
      return problemas;
    },

    // Acrescenta uma imagem pelo endereço (URL). Devolve a mensagem de erro, ou "" se deu certo.
    adicionarEndereco(texto) {
      const endereco = String(texto ?? "").trim();
      if (endereco === "") {
        return "Informe o endereço (URL) da imagem.";
      }

      let url;
      try {
        url = new URL(endereco);
      } catch (erro) {
        return "Este endereço não é válido. Ele deve começar com http:// ou https://.";
      }
      if (url.protocol !== "http:" && url.protocol !== "https:") {
        return "O endereço deve começar com http:// ou https://.";
      }
      if (itens.length >= MAXIMO_DE_FOTOS) {
        return "Cada produto pode ter no máximo " + MAXIMO_DE_FOTOS + " fotos.";
      }

      itens.push({ chave: crypto.randomUUID(), origem: "endereco", url: endereco, nome: url.hostname });
      desenhar();
      anunciar("Foto adicionada pelo endereço. Agora são " + itens.length + ".");
      aoMudar();
      return "";
    },

    // As fotos na ordem final, no formato que o produtoServico espera:
    //   { id, url, caminho } (já salva), { url } (endereço) ou { arquivo } (arquivo novo)
    obterParaSalvar() {
      return itens.map((item) => {
        if (item.origem === "salva") {
          return { id: item.id, url: item.url, caminho: item.caminho };
        }
        return item.origem === "arquivo" ? { arquivo: item.arquivo } : { url: item.url };
      });
    },

    quantidade() {
      return itens.length;
    },
  };
}
```


### Passo 4: o serviço de produtos passa a cuidar das fotos

No `js/servicos/produtoServico.js` faça as trocas. (1) As importações: o `MAXIMO_DE_FOTOS` e o serviço de Storage:

**Arquivo: `js/servicos/produtoServico.js`**: substitua o trecho que começa na linha `import { Produto } from "../modelos/Produto.js";` e termina na linha `import { paraErroApp } from "./errosSupabase.js";` (inclusive) por:

```js
import { Produto, MAXIMO_DE_FOTOS } from "../modelos/Produto.js";
import { paraErroApp } from "./errosSupabase.js";
import { enviarFoto, tentarRemoverFotos } from "./storageServico.js";
```


(2) A validação ganha a regra das 5 fotos:

**Arquivo: `js/servicos/produtoServico.js`**: substitua a função `validarProduto` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Valida o formulário do produto. Devolve { campo: "mensagem" } (vazio quando está tudo certo).
// Chaves: nome, categoriaId, preco, tamanhos, fotos e, para cada linha de tamanho, "tamanho-0", "estoque-0", "tamanho-1"...
// A tela mostra cada mensagem ao lado do campo; criarProduto e atualizarProduto validam de novo antes de gravar.
export function validarProduto({ nome, categoriaId, preco, tamanhos = [], fotos = [] }) {
  const erros = {};

  if (String(nome ?? "").trim() === "") {
    erros.nome = "Informe o nome do produto.";
  }
  if (!categoriaId) {
    erros.categoriaId = "Escolha a categoria.";
  }

  // RN-02: o preço deve ser maior que zero
  const precoNumerico = converterPreco(preco);
  if (!Number.isFinite(precoNumerico) || precoNumerico <= 0) {
    erros.preco = "O preço deve ser maior que zero.";
  }

  if (tamanhos.length === 0) {
    erros.tamanhos = "Adicione pelo menos um tamanho.";
  }

  const jaVistos = new Set();
  tamanhos.forEach((linha, indice) => {
    const nomeDoTamanho = normalizarTamanho(linha.tamanho);

    if (nomeDoTamanho === "") {
      erros["tamanho-" + indice] = "Informe o tamanho.";
    } else if (jaVistos.has(nomeDoTamanho)) {
      erros["tamanho-" + indice] = "Este tamanho já foi adicionado.";
    }
    jaVistos.add(nomeDoTamanho);

    // RN-02: o estoque não pode ser negativo (e precisa ser um número inteiro)
    const textoDoEstoque = String(linha.estoque ?? "").trim();
    const estoque = Number(textoDoEstoque);
    if (textoDoEstoque === "") {
      erros["estoque-" + indice] = "Informe o estoque (use 0 se acabou).";
    } else if (!Number.isInteger(estoque) || estoque < 0) {
      erros["estoque-" + indice] = "O estoque deve ser um número inteiro, zero ou maior.";
    }
  });

  // RN-12: no máximo 5 fotos por produto
  if (fotos.length > MAXIMO_DE_FOTOS) {
    erros.fotos = "Cada produto pode ter no máximo " + MAXIMO_DE_FOTOS + " fotos.";
  }

  return erros;
}
```


(3) Cole a função que envia as fotos novas **logo antes** de `criarProduto`:

**Arquivo: `js/servicos/produtoServico.js`**: adicione esta função (`enviarFotosNovas`) logo antes da função `criarProduto` (junto com os comentários que ficam acima dela):

```js
// Envia os arquivos novos ao Storage e devolve a lista final de fotos, na mesma ordem.
// Cada item de "fotos" é de um destes tipos:
//   { id, url, caminho }  foto que já estava salva
//   { url }               endereço de imagem informado à mão (caminho fica vazio)
//   { arquivo }           arquivo novo, que ainda precisa ser enviado
// "enviados" recebe os caminhos dos arquivos enviados agora, para desfazer se algo falhar depois.
async function enviarFotosNovas(fotos, lojaId, produtoId, enviados) {
  const resultado = [];

  for (const foto of fotos) {
    if (foto.arquivo) {
      const salva = await enviarFoto(foto.arquivo, lojaId, produtoId);
      enviados.push(salva.caminho);
      resultado.push({ url: salva.url, caminho: salva.caminho });
    } else {
      resultado.push({ id: foto.id, url: foto.url, caminho: foto.caminho ?? null });
    }
  }
  return resultado;
}
```


(4) Troque as três funções que passam a cuidar das fotos:

**Arquivo: `js/servicos/produtoServico.js`**: substitua a função `criarProduto` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Cria o produto, os tamanhos e as fotos (RF-16, RF-19).
// "dados.id" é gerado no navegador (crypto.randomUUID()) ANTES do envio, para o caminho das fotos no Storage já usar o id do produto.
// Passos: 1) envia os arquivos; 2) grava o produto; 3) grava tamanhos e fotos. Se algo falhar, desfaz o que foi feito.
export async function criarProduto(dados) {
  const enviados = [];
  let produtoGravado = false;

  try {
    ErroApp.lancarSeHouverErros(validarProduto(dados));
    conferirComOModelo(dados);
    const supabase = exigirSupabase();
    const { linhaDoProduto, linhasDeTamanhos } = montarLinhas(dados);

    const fotos = await enviarFotosNovas(dados.fotos, dados.lojaId, dados.id, enviados);

    const { error: erroDoProduto } = await supabase.from("produtos").insert({ id: dados.id, ...linhaDoProduto });
    if (erroDoProduto) {
      throw erroDoProduto;
    }
    produtoGravado = true;

    const { error: erroDosTamanhos } = await supabase
      .from("tamanhos")
      .insert(linhasDeTamanhos.map((linha) => ({ produto_id: dados.id, ...linha })));
    if (erroDosTamanhos) {
      throw erroDosTamanhos;
    }

    if (fotos.length > 0) {
      const { error: erroDasFotos } = await supabase
        .from("produto_fotos")
        .insert(fotos.map((foto, indice) => ({ produto_id: dados.id, url: foto.url, caminho: foto.caminho, ordem: indice + 1 })));
      if (erroDasFotos) {
        throw erroDasFotos;
      }
    }

    return dados.id;
  } catch (erro) {
    // Desfaz: sem o produto completo, é melhor não deixar produto pela metade nem arquivos soltos.
    // (Apagar o produto também apaga, em cascata, os tamanhos e as fotos dele.)
    if (produtoGravado) {
      await exigirSupabase().from("produtos").delete().eq("id", dados.id);
    }
    await tentarRemoverFotos(enviados);
    throw paraErroApp(erro, "Não foi possível salvar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/produtoServico.js`**: substitua a função `atualizarProduto` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Atualiza o produto, os tamanhos e as fotos (RF-17, RF-19). Os dados têm o mesmo formato do criarProduto.
// As fotos podem ter sido removidas, reordenadas ou acrescentadas: a ordem da lista vira a coluna "ordem" (1 a 5).
export async function atualizarProduto(id, dados) {
  const enviados = [];
  let fotosNovasGravadas = false;

  try {
    ErroApp.lancarSeHouverErros(validarProduto(dados));
    conferirComOModelo({ ...dados, id });
    const supabase = exigirSupabase();
    const { linhaDoProduto, linhasDeTamanhos } = montarLinhas(dados);

    // Como está hoje no banco: serve para saber o que foi removido
    const { data: atual, error: erroAoLer } = await supabase
      .from("produtos")
      .select("id, tamanhos ( tamanho ), produto_fotos ( id, caminho )")
      .eq("id", id)
      .eq("loja_id", dados.lojaId)
      .maybeSingle();
    if (erroAoLer) {
      throw erroAoLer;
    }
    if (!atual) {
      throw new ErroApp("produto_nao_encontrado", "Produto não encontrado.");
    }

    const fotos = await enviarFotosNovas(dados.fotos, dados.lojaId, id, enviados);

    // 1) Dados do produto. Se a loja não for desta lojista, as regras RLS não alteram nada e não volta linha
    const { data: alterados, error: erroDoProduto } = await supabase.from("produtos").update(linhaDoProduto).eq("id", id).select("id");
    if (erroDoProduto) {
      throw erroDoProduto;
    }
    if (alterados.length === 0) {
      throw new ErroApp("permissao_negada", "Você não tem permissão para alterar este produto.");
    }

    // 2) Tamanhos: grava os atuais (cria ou atualiza) e apaga os que a lojista tirou
    const { error: erroDosTamanhos } = await supabase
      .from("tamanhos")
      .upsert(linhasDeTamanhos.map((linha) => ({ produto_id: id, ...linha })), { onConflict: "produto_id,tamanho" });
    if (erroDosTamanhos) {
      throw erroDosTamanhos;
    }
    const tamanhosNovos = new Set(linhasDeTamanhos.map((linha) => linha.tamanho));
    const tamanhosRemovidos = atual.tamanhos.map((t) => t.tamanho).filter((t) => !tamanhosNovos.has(t));
    if (tamanhosRemovidos.length > 0) {
      const { error } = await supabase.from("tamanhos").delete().eq("produto_id", id).in("tamanho", tamanhosRemovidos);
      if (error) {
        throw error;
      }
    }

    // 3) Fotos. Primeiro apaga as removidas (assim o limite de 5 do banco não atrapalha as novas)
    const idsMantidos = new Set(fotos.filter((foto) => foto.id).map((foto) => foto.id));
    const fotosRemovidas = atual.produto_fotos.filter((foto) => !idsMantidos.has(foto.id));
    if (fotosRemovidas.length > 0) {
      const { error } = await supabase.from("produto_fotos").delete().in("id", fotosRemovidas.map((foto) => foto.id));
      if (error) {
        throw error;
      }
    }

    // Depois grava as novas, já com a ordem final
    const fotosParaCriar = fotos
      .map((foto, indice) => ({ foto, ordem: indice + 1 }))
      .filter((item) => !item.foto.id)
      .map((item) => ({ produto_id: id, url: item.foto.url, caminho: item.foto.caminho, ordem: item.ordem }));
    if (fotosParaCriar.length > 0) {
      const { error } = await supabase.from("produto_fotos").insert(fotosParaCriar);
      if (error) {
        throw error;
      }
    }
    fotosNovasGravadas = true;

    // Por fim, a ordem das fotos que já existiam (é isto que muda a capa quando a lojista reordena)
    for (const [indice, foto] of fotos.entries()) {
      if (foto.id) {
        const { error } = await supabase.from("produto_fotos").update({ ordem: indice + 1 }).eq("id", foto.id);
        if (error) {
          throw error;
        }
      }
    }

    // Só agora apaga do Storage os arquivos das fotos removidas (melhor esforço: não trava se falhar)
    await tentarRemoverFotos(fotosRemovidas.map((foto) => foto.caminho).filter(Boolean));
    return id;
  } catch (erro) {
    // Se falhou antes de gravar as fotos novas, os arquivos enviados agora ficariam soltos: apaga
    if (!fotosNovasGravadas) {
      await tentarRemoverFotos(enviados);
    }
    throw paraErroApp(erro, "Não foi possível salvar o produto. Verifique sua conexão e tente novamente.");
  }
}
```


**Arquivo: `js/servicos/produtoServico.js`**: substitua a função `excluirProduto` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Exclui o produto (RF-18). Produto que já foi pedido NÃO pode ser excluído: o banco impede, e a mensagem sugere desativar.
// Ordem dos passos: 1) confere se já foi pedido; 2) guarda os caminhos das fotos; 3) apaga o produto (o banco apaga
// em cascata os tamanhos e as linhas de produto_fotos); 4) apaga os arquivos do Storage, em "melhor esforço".
// Deixamos os arquivos por último de propósito: se o banco recusar a exclusão, nenhuma foto foi perdida.
export async function excluirProduto(id) {
  try {
    const supabase = exigirSupabase();

    // As regras RLS deixam a lojista ver os itens dos pedidos da própria loja, e é neles que o produto aparece
    const { count, error: erroDosPedidos } = await supabase
      .from("itens_pedido")
      .select("id", { count: "exact", head: true })
      .eq("produto_id", id);
    if (erroDosPedidos) {
      throw erroDosPedidos;
    }
    if (count > 0) {
      throw new ErroApp("produto_ja_pedido", MENSAGEM_PRODUTO_JA_PEDIDO);
    }

    const { data: fotos, error: erroDasFotos } = await supabase.from("produto_fotos").select("caminho").eq("produto_id", id);
    if (erroDasFotos) {
      throw erroDasFotos;
    }

    const { data: apagados, error: erroAoApagar } = await supabase.from("produtos").delete().eq("id", id).select("id");
    if (erroAoApagar) {
      // 23503: alguém fez um pedido deste produto entre a conferência e agora
      if (erroAoApagar.code === "23503") {
        throw new ErroApp("produto_ja_pedido", MENSAGEM_PRODUTO_JA_PEDIDO, erroAoApagar);
      }
      throw erroAoApagar;
    }
    if (apagados.length === 0) {
      throw new ErroApp("permissao_negada", "Você não tem permissão para excluir este produto.");
    }

    await tentarRemoverFotos(fotos.map((foto) => foto.caminho).filter(Boolean));
  } catch (erro) {
    throw paraErroApp(erro, "Não foi possível excluir o produto. Verifique sua conexão e tente novamente.");
  }
}
```


### Passo 5: a seção de fotos no formulário

No `painel-produto-form.html`, cole a seção de fotos **logo antes** da linha `<div class="acoes-formulario">`:

**Arquivo: `painel-produto-form.html`**: adicione este trecho logo antes da linha `<div class="acoes-formulario">`:

```html
        <section aria-labelledby="titulo-fotos">
          <h2 id="titulo-fotos">Fotos do produto</h2>

          <div class="campo">
            <label for="arquivos-fotos">Escolher fotos</label>
            <input type="file" id="arquivos-fotos" name="fotos" multiple accept="image/jpeg,image/png,image/webp" aria-describedby="ajuda-fotos">
            <p class="campo-ajuda" id="ajuda-fotos">Até 5 fotos, em JPG, PNG ou WebP, com até 2 MB cada. A primeira da lista é a capa do catálogo.</p>
          </div>

          <ul class="fotos-gerenciar" id="lista-fotos"></ul>
          <p class="visualmente-oculto" id="anuncio-fotos" role="status" aria-live="polite"></p>

          <!-- Só aparece se o envio de uma foto falhar -->
          <div class="campo" id="bloco-endereco-foto" hidden>
            <label for="endereco-foto">Endereço (URL) de uma imagem</label>
            <input type="url" id="endereco-foto" placeholder="https://exemplo.com/foto.jpg" aria-describedby="ajuda-endereco-foto">
            <p class="campo-ajuda" id="ajuda-endereco-foto">Se não for possível enviar o arquivo, você pode usar o endereço de uma imagem que já esteja na internet.</p>
            <button type="button" class="botao botao-secundario botao-pequeno" id="usar-endereco-foto">Usar este endereço</button>
          </div>
        </section>
```


### Passo 6: o formulário envia as fotos

No `js/paginas/painelProdutoForm.js`, faça as trocas na ordem. (1) Cabeçalho e importações:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua o começo do arquivo, até a linha `import { obterProdutoParaEdicao, criarProduto, atualizarProduto, validarProduto } from "../servicos/produtoServico.js";` (inclusive) por:

```js
// Painel da lojista: cadastrar e editar produto, com tamanhos e fotos.
// A página só valida, chama os serviços e mostra o resultado.
// Para editar, o endereço traz o id: painel-produto-form.html?id=...
import { montarCabecalho } from "../ui/cabecalho.js";
import { mostrarCarregando, mostrarErro, limparAvisos, mensagemDoErro, mostrarErroDoCampo, limparErroDoCampo, limparErrosDosCampos } from "../ui/avisos.js";
import { criarListaDeFotos } from "../ui/listaDeFotos.js";
import { ErroApp } from "../modelos/ErroApp.js";
import { obterMinhaLoja } from "../servicos/lojaServico.js";
import { listarCategorias } from "../servicos/categoriaServico.js";
import { obterProdutoParaEdicao, criarProduto, atualizarProduto, validarProduto } from "../servicos/produtoServico.js";
```


(2) Os campos das fotos:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a linha `const botaoAdicionarTamanho = document.getElementById("adicionar-tamanho");` por:

```js
const botaoAdicionarTamanho = document.getElementById("adicionar-tamanho");
const campoArquivos = document.getElementById("arquivos-fotos");
const blocoEnderecoDaFoto = document.getElementById("bloco-endereco-foto");
const campoEnderecoDaFoto = document.getElementById("endereco-foto");
const botaoUsarEndereco = document.getElementById("usar-endereco-foto");
```


(3) A lista de fotos, **logo antes** do comentário `// ---------- Linhas de tamanho (a lojista adiciona e remove) ----------`:

**Arquivo: `js/paginas/painelProdutoForm.js`**: adicione este trecho logo antes da linha `// ---------- Linhas de tamanho (a lojista adiciona e remove) ----------`:

```js
const fotos = criarListaDeFotos({
  elementoLista: document.getElementById("lista-fotos"),
  elementoAnuncio: document.getElementById("anuncio-fotos"),
  elementoFocoSeVazia: campoArquivos,
});
```


(4) O que é lido do formulário passa a incluir as fotos:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a linha `fotos: [],` por:

```js
    fotos: fotos.obterParaSalvar(),
```


(5) O erro das fotos aparece ao lado do campo de arquivos (dentro de `acharCampoDoErro`):

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a linha `tamanhos: botaoAdicionarTamanho,` por:

```js
    tamanhos: botaoAdicionarTamanho,
    fotos: campoArquivos,
```


(6) Os eventos das fotos, **logo antes** do `botaoAdicionarTamanho.addEventListener("click", ...)`:

**Arquivo: `js/paginas/painelProdutoForm.js`**: adicione este trecho logo antes da linha `botaoAdicionarTamanho.addEventListener("click", () => {`:

```js
// ---------- Fotos ----------

campoArquivos.addEventListener("change", () => {
  limparErroDoCampo(campoArquivos);

  // Os arquivos recusados (formato, tamanho ou o limite de 5) não tiram as fotos que já estavam na lista
  const problemas = fotos.adicionarArquivos(campoArquivos.files);
  campoArquivos.value = ""; // assim a lojista pode escolher o mesmo arquivo de novo
  if (problemas.length > 0) {
    mostrarErroDoCampo(campoArquivos, problemas.join(" "));
  }
});

botaoUsarEndereco.addEventListener("click", () => {
  limparErroDoCampo(campoEnderecoDaFoto);

  const problema = fotos.adicionarEndereco(campoEnderecoDaFoto.value);
  if (problema) {
    mostrarErroDoCampo(campoEnderecoDaFoto, problema);
    campoEnderecoDaFoto.focus();
  } else {
    campoEnderecoDaFoto.value = "";
  }
});

```


(7) A mensagem durante o envio:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a linha `mostrarCarregando("Salvando o produto…");` por:

```js
  mostrarCarregando("Salvando o produto e enviando as fotos…");
```


(8) Se o envio falhar, o campo do **endereço (URL)** da imagem aparece como alternativa:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a linha `enviando = false;` por:

```js
    // Se o envio de uma foto falhou, a lojista pode usar o endereço (URL) de uma imagem no lugar (a coluna "caminho" fica vazia)
    if (erro instanceof ErroApp && erro.codigo === "erro_ao_enviar_foto") {
      blocoEnderecoDaFoto.hidden = false;
    }
    enviando = false;
```


(9) Ao editar, as fotos salvas entram na lista:

**Arquivo: `js/paginas/painelProdutoForm.js`**: substitua a função `preencherFormulario` inteira (do comentário acima dela até a chave que a fecha) por:

```js
// Ao editar: coloca nos campos o que já está salvo
function preencherFormulario(produto) {
  campoNome.value = produto.nome;
  campoDescricao.value = produto.descricao ?? "";
  campoCategoria.value = String(produto.categoria_id);
  campoPreco.value = produto.preco;
  campoAtivo.checked = produto.ativo;

  produto.tamanhos.forEach((item) => adicionarLinhaDeTamanho(item.tamanho, String(item.estoque)));
  if (produto.tamanhos.length === 0) {
    adicionarLinhaDeTamanho();
  }

  // As fotos salvas aparecem na ordem da coluna "ordem": a primeira é a capa
  fotos.carregarSalvas([...produto.produto_fotos].sort((a, b) => a.ordem - b.ordem));
}
```


### Passo 7: teste as fotos (CT-10, CT-16 e CT-25)

1. Abra `painel-produto-form.html`. Aparece a seção **Fotos do produto**. Cadastre um produto novo e escolha **3 fotos** (JPG, PNG ou WebP). Elas aparecem em uma lista com o selo **Capa** na primeira. Use **Mover para baixo** na primeira: o selo **Capa** muda de foto. Salve.
2. No catálogo, o card mostra a **primeira** foto (capa). Na lista **Meus produtos**, edite o produto: as 3 fotos voltam à lista, e você pode remover uma e salvar.
3. No Supabase, **Storage** > bucket **produtos** (em português: **Armazenamento**): existe uma pasta com o id da loja, dentro dela uma pasta com o id do produto e as fotos (`.jpg`).
4. **CT-25 (foto grande):** envie uma foto de câmera com mais de 1 MB (e menos de 2 MB). No Storage, o arquivo guardado tem **cerca de 200 KB** e é JPG.
5. **CT-16 (limites):** tente escolher **6 fotos** de uma vez ou uma 6ª depois de ter 5: aparece **Cada produto pode ter no máximo 5 fotos...** e as 5 já escolhidas continuam. Escolha um arquivo `.gif` ou com mais de 2 MB: aparece o motivo ("formato não aceito..." ou "a foto tem mais de 2 MB") e as fotos da lista **não** somem.
6. **Excluir:** exclua o produto de teste em **Meus produtos**: os arquivos dele **somem** do Storage.
7. **Plano B:** se o envio falhar (por exemplo, o bucket não existe), a tela mostra o erro e libera o campo **Endereço (URL) de uma imagem**: informe o endereço de uma imagem da internet e salve; a foto é guardada sem `caminho`.

### Passo 8: faça o commit da aula e marque a versão 0.5

```bash
git add .
git commit -m "Envia fotos dos produtos para o Supabase Storage"
git push
git tag v0.5
git push origin v0.5
```

## Explicação do Código

**storageServico.js**

- `BUCKET_DAS_FOTOS = "produtos"` e `EXTENSOES_ACEITAS`: os tipos aceitos (`image/jpeg`, `image/png`, `image/webp`) e a extensão de cada um. A extensão vem do **tipo** do arquivo, não do nome: um `foto.php` com tipo `image/png` vira `.png`.
- `validarArquivoDeFoto(arquivo)`: devolve o **motivo** da recusa ("formato não aceito..." ou "a foto tem mais de 2 MB"), ou texto vazio se está tudo certo. É usada pela tela e de novo antes de enviar.
- `enviarFoto(arquivo, lojaId, produtoId)`: valida, reduz a foto, cria o caminho `loja/produto/uuid.ext` (`crypto.randomUUID()` garante um nome único), faz o `upload` e devolve `{ url, caminho }` (`getPublicUrl` calcula o endereço público). Se o `upload` falhar, lança um `ErroApp` com o código `erro_ao_enviar_foto`, que a tela usa para oferecer o endereço (URL).
- `removerFotos(caminhos)` e `tentarRemoverFotos(caminhos)`: apagam arquivos. A segunda é de **melhor esforço**: se não conseguir, só avisa no Console (arquivo sobrando é só espaço ocupado, não pode travar a lojista).

**imagem.js**

- `reduzirFoto(arquivo)`: carrega a imagem (`carregarImagem`, que usa `URL.createObjectURL`), e **se já é pequena** (até 200 KB e 1280 px) devolve o próprio arquivo. Senão, desenha em um `canvas` com o maior lado limitado a 1280 px (`desenhar`, com fundo branco porque JPEG não tem transparência) e tenta salvar em qualidades de JPEG cada vez menores (0,85 → 0,45) até ficar com no máximo 200 KB; se não chegar, reduz o tamanho (75%) e tenta de novo (até 4 vezes). `canvasParaBlob` e `criarArquivo` convertem entre `canvas`, `Blob` e `File`.

**listaDeFotos.js**

- `criarListaDeFotos({...})` devolve um objeto com as ações: `carregarSalvas(fotos)` (fotos que já estão no banco), `adicionarArquivos(arquivos)` (valida cada arquivo e o limite de 5; devolve a lista de problemas), `adicionarEndereco(texto)`, `obterParaSalvar()` e `quantidade()`.
- Cada foto tem uma `origem`: `salva` (já no banco), `arquivo` (escolhida agora, ainda não enviada) ou `endereco` (URL digitada). `desenhar()` redesenha a lista com `createElement`/`textContent` (nomes de arquivo nunca entram como HTML). `mover` troca duas fotos de lugar (o selo **Capa** acompanha a primeira posição); `remover` tira da lista e libera a pré-visualização (`URL.revokeObjectURL`).
- Acessibilidade: `anunciar(texto)` escreve em um `aria-live` ("Foto movida: agora é a foto 1, a capa"), os botões têm texto escondido dizendo de qual foto são, e o **foco do teclado** volta ao botão usado depois de redesenhar a lista.

**produtoServico.js**

- `enviarFotosNovas(fotos, lojaId, produtoId, enviados)`: para cada foto da lista, se é um arquivo novo, envia ao Storage e guarda o `caminho` em `enviados` (para **desfazer** se algo falhar); senão, mantém os dados da foto.
- `criarProduto` agora faz 1) envia os arquivos, 2) grava o produto, 3) grava os tamanhos e as fotos (`produto_fotos` com `ordem` = posição + 1). Se algo falhar, **apaga o produto e os arquivos enviados**.
- `atualizarProduto` apaga primeiro as fotos removidas do banco (para o limite de 5 do gatilho não atrapalhar), insere as novas e atualiza a `ordem` das que já existiam: é isso que muda a **capa** ao reordenar. Só no fim apaga os arquivos antigos do Storage.
- `excluirProduto`: guarda os caminhos das fotos, apaga o produto (o banco apaga as linhas de fotos em cascata) e **só depois** apaga os arquivos: se o banco recusar a exclusão, nenhuma foto foi perdida.

## Validação

1. O produto com 3 fotos mostra a primeira como capa no catálogo e todas na edição; reordenar muda a capa.
2. No Storage, os arquivos ficam em `loja/produto/uuid.jpg` e a foto grande tem cerca de 200 KB (CT-25).
3. A 6ª foto e um `.gif` ou arquivo maior que 2 MB são recusados com mensagem clara, mantendo as fotos já escolhidas (CT-16).
4. Excluir o produto apaga os arquivos do Storage.
5. A tag `v0.5` aparece no GitHub (**Marco 3**).

**Erros comuns**

1. *Mensagem:* `new row violates row-level security policy` ao enviar a foto. *Causa:* a política provisória `dev: envio de fotos` não foi criada ou o bucket tem outro nome. *Correção:* confira o Passo 1: o bucket se chama `produtos` e a política foi rodada.
2. *Mensagem:* `Bucket not found`. *Causa:* o bucket não existe ou tem outro nome (`Produtos`). *Correção:* crie um bucket exatamente com o nome `produtos`.
3. *Sintoma:* as fotos enviam, mas não aparecem no catálogo. *Causa:* o bucket não é público. *Correção:* em **Storage** (em português: **Armazenamento**), edite o bucket e ligue **Public bucket** (em português: **Bucket público**).
4. *Mensagem:* `Cada produto pode ter no máximo 5 fotos` ao editar. *Causa:* o gatilho do banco recusou a 6ª foto. *Correção:* remova uma foto antes de adicionar outra.

**Se travar**

1. No Console (F12) e na aba **Network** (em português: **Rede**) veja o pedido de `upload` que falhou e a resposta.
2. Teste com uma foto pequena (menos de 200 KB) para separar o problema do envio do problema da redução.
3. Compare os arquivos novos com os da aula; se algo quebrou, volte com `git restore arquivo`.
4. Só depois peça ajuda à sua equipe.

**Seu projeto agora tem**

- O bucket `produtos` no Supabase e a política provisória `dev: envio de fotos` (**a apagar no Dia 13**).
- `js/servicos/storageServico.js`, `js/ui/imagem.js` e `js/ui/listaDeFotos.js`.
- O formulário de produto com fotos (até 5, capa, reordenar, remover) e `produtoServico.js` completo de CRUD com imagens.
- A versão **0.5** marcada no Git.

**Como saber que deu certo:** você cadastra um produto com 3 fotos e vê a primeira como capa no catálogo, e ao excluir o produto os arquivos somem do Storage.
