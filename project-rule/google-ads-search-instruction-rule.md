# Google Ads Search Instruction Rule (Generico)

## Objetivo

Padronizar a criacao de campanhas de Google Ads na Rede de Pesquisa com foco em:

- estrutura correta de palavras-chave (incluindo branding);
- volume adequado de assets em RSA (titulos e descricoes);
- quantidade e padrao de CTAs;
- consistencia operacional para escalar em novos projetos.

## Escopo

- Tipo de campanha: `Search` (Rede de Pesquisa).
- Formato de anuncio: `Responsive Search Ads (RSA)`.
- Aplicacao: qualquer produto/servico com ajuste de nicho e compliance local.

## Regra De Prioridade (Projeto Atual)

- Para este projeto, esta regra prevalece sobre orientacoes antigas de "no brand bidding".
- Portanto, `branding name keywords` estao **permitidas e obrigatorias**.
- Sempre incluir termos de marca/produto no plano de keywords e nos assets RSA.

## Regra De Acionamento De Entregavel (Obrigatoria)

- Sempre que o prompt mencionar esta regra de Google Ads (ou citar o arquivo de regra de Google Ads), a IA deve gerar um arquivo `.md` de campanha no formato copy/paste.
- O formato de saida deve ser equivalente ao modelo:
  - `informações de projeto/affiliate guide/google-ads-copy-paste-campaign-brain-song.md`
- O arquivo gerado deve vir pronto para uso no Google Ads Search com:
  - campaign setup;
  - ad groups por tema;
  - keywords;
  - negativas;
  - RSAs com headlines/descriptions;
  - checklist rapido de QA.
- Se o usuario solicitar apenas "criar campanha com base na regra", isso ja e suficiente para disparar a geracao do `.md`.

## Regra De Idioma (Obrigatoria)

- Este documento pode explicar estrategia e instrucoes em portugues.
- Todo conteudo que sera usado dentro do Google Ads deve ser em ingles:
  - palavras-chave;
  - termos/consultas alvo;
  - nome de produto/marca nos assets;
  - headlines;
  - descriptions;
  - CTAs.
- Nao misturar portugues e ingles nos assets do anuncio quando o mercado alvo for ingles.
- Antes de publicar, validar idioma dos assets no checklist de QA.

## Estrutura Minima de Campanha (Search)

### 0) Nome da campanha com tags (obrigatorio)

- Usar padrao de identificacao:
  - `Search | [INTENCAO] | [FUNIL] | [PRODUCT NAME] | [LANG]`
- Exemplo:
  - `Search | Brand | BOFU | Brain Song | EN`
- Objetivo: facilitar leitura, governanca, filtro e relatorio.

### 1) Clusters obrigatorios de palavras-chave

- `Branding`: nome do produto, nome da marca, variacoes e erros comuns de digitacao.
- `Brand + Intent`: review, price, official, buy, where to buy, results.
- `Problema + Solucao`: termos do problema principal com linguagem permitida.
- `Mecanismo/Metodo`: como funciona, metodo, tecnologia, formato da solucao.

### 2) Match types recomendados no inicio

- Branding: priorizar `exact` e `phrase`.
- Brand + intent: `phrase` e `exact`.
- Problema/solucao: iniciar com `phrase`; expandir para broad apenas com negativas maduras.
- Mecanismo: `phrase` + `exact`.

### 2.1) Separacao de ad groups por tema de keyword (obrigatorio)

- Cada ad group deve representar um tema unico de intencao.
- Nao misturar branding com review/duvida no mesmo ad group.
- Estrutura minima recomendada:
  - Grupo 01: `branding-product-name`
  - Grupo 02: `brand-review-intent`
  - Grupo 03: `brand-mechanism-intent`
- Cada grupo deve conter apenas palavras-chave relacionadas ao proprio nome/tema.

### 3) Palavras-chave negativas obrigatorias (base)

- Navegacao irrelevante: `free`, `torrent`, `download`, `pdf`, `youtube`.
- Emprego/educacao: `job`, `career`, `salary`, `course` (quando nao for infoproduto educacional).
- Suporte tecnico: `login`, `refund`, `customer service` (quando o foco for aquisicao).
- Termos proibidos por compliance/brand safety (definir por projeto).

### 3.1) Palavras-chave negativas obrigatorias (expandida)

- Affiliate arbitrage e trafego de baixa qualidade:
  - `affiliate`, `affiliates`, `affiliate program`, `become an affiliate`, `how to promote prodentim`
- Intencao de gratuidade/baixo valor:
  - `free trial`, `free sample`, `coupon code`, `promo code`, `discount code`, `cheap`, `torrent`, `crack`
- Canais/marketplaces proibidos para oferta:
  - `amazon`, `ebay`, `craigslist`, `gumtree`, `kijiji`, `google play`, `apple app store`
- Conteudo nao transacional e baixo fit:
  - `wiki`, `reddit`, `quora`, `youtube`, `pdf`, `slides`, `template`
- Suporte e pos-venda (quando objetivo for aquisicao):
  - `cancel`, `return`, `refund status`, `order tracking`, `customer support phone`

## Padrao de Assets RSA

### Quantidade recomendada por RSA

- Titulos: `12 a 15` (maximo permitido: 15).
- Descricoes: `4` (maximo permitido: 4).
- Limite tecnico de caracteres (obrigatorio):
  - `Headline`: maximo de `30` caracteres por titulo.
  - `Description`: maximo de `90` caracteres por descricao.
  - Se ultrapassar, deve truncar/reescrever antes de exportar para CSV.
- Paths de URL para RSA (obrigatorio neste projeto):
  - `Path 1` deve ser sempre `official`.
  - `Path 2` deve ser removido (nao exportar coluna/valor no CSV de RSA).
- Pinning de headline para Google Ads Editor (obrigatorio):
  - Todas as headlines preenchidas no CSV devem ter `Headline X position` definido.
  - Mapeamento padrao:
    - `Product name` -> posicao `1`
    - `Benefits` -> posicao `2`
    - `CTA` -> posicao `3`
  - Cada RSA deve ter, no minimo, uma headline em cada posicao (`1`, `2`, `3`).
  - Se alguma posicao estiver ausente, o gerador deve reclassificar headlines para evitar erro de importacao:
    - `You don't have enough headlines...`
- Regra obrigatoria de branding em titulos:
  - no minimo `30%` dos titulos devem conter o nome do produto/marca.
  - formula: `ceil(total_de_titulos * 0.30)`.
  - exemplo com 15 titulos: minimo `5` titulos com branding (`Brain Song` e variacoes).

### Quantidade recomendada por ad group

- `3 RSAs` ativas por ad group (minimo de 3 variantes de anuncio).
- Volume total alvo por ad group:
  - `36 a 45` titulos;
  - `12` descricoes.

## Quantidade de CTAs

### Minimo por RSA

- Incluir `3 a 5` variacoes de CTA nos titulos e descricoes.

### Minimo por ad group

- Ter ao menos `8` CTAs distintos no conjunto das 2 RSAs.

### Exemplos de CTA (adaptar ao nicho)

- `Buy Now`
- `Learn More`
- `Watch The Video`
- `See How It Works`
- `Get Started Today`
- `Check Availability`
- `See The Official Page`
- `Start Now`

## Distribuicao recomendada de titulos (por RSA)

- `3 a 5` titulos com palavra-chave principal (incluindo branding).
- `2 a 3` titulos de beneficio principal.
- `2 a 3` titulos de credibilidade/prova.
- `2 a 3` titulos de objecao/risco reduzido.
- `3 a 5` titulos com CTA.

## Distribuicao recomendada de descricoes (4 por RSA)

- Descricao 1: problema + beneficio principal.
- Descricao 2: como funciona + simplicidade.
- Descricao 3: prova/credibilidade sem promessas absolutas.
- Descricao 4: CTA direto + urgencia moderada.

## Branding Keywords (Obrigatorio)

Para todo projeto, criar um bloco especifico de branding com:

- nome exato do produto;
- variacoes do nome (com/sem artigo, singular/plural);
- nome + "official";
- nome + "review";
- nome + "buy";
- nome + "price".

Regra: o cluster de branding deve existir mesmo quando o volume inicial parecer baixo.

## Compliance de Copy (Regra Geral)

- Evitar promessas absolutas e garantias de resultado.
- Evitar termos proibidos por politica da plataforma e por regra do afiliado.
- Em nichos sensiveis (saude/financas), usar linguagem de suporte e potencial, nao de cura/garantia.
- Validar "net impression" do anuncio, nao apenas palavras isoladas.

## Plano de Execucao Rapido (Pesquisa)

### Fase 1 (Dias 1-7)

- Subir campanha com clusters base.
- Coletar termos reais no search terms report.
- Pausar termos sem intencao e adicionar negativas.

### Fase 2 (Dias 8-14)

- Expandir keywords vencedoras.
- Revisar titulos e descricoes com baixo desempenho.
- Ajustar lances por dispositivo/local/horario.

### Fase 3 (Dias 15-21)

- Consolidar vencedores por CTR, CPC e conversao.
- Criar nova iteracao de RSA com aprendizado dos melhores assets.

## Checklist Antes de Publicar

- Estrutura de palavras-chave inclui cluster de branding.
- Nome da campanha segue padrao com tags (`Search | ... | PRODUCT NAME | EN`).
- Ad groups estao separados por tema de keyword.
- Existem 3 RSAs por ad group.
- Cada RSA contem 12-15 titulos e 4 descricoes.
- Todos os titulos respeitam limite de 30 caracteres.
- Todas as descricoes respeitam limite de 90 caracteres.
- Todas as headlines preenchidas possuem `Headline position` (1/2/3).
- Cada RSA possui ao menos uma headline nas posicoes 1, 2 e 3.
- `Path 1` esta padronizado como `official` em todos os RSAs.
- `Path 2` nao e exportado no CSV de RSAs.
- Cada ad group possui 8+ CTAs no conjunto total.
- Minimo de 30% dos titulos por RSA contem branding.
- Keywords, headlines, descriptions e CTAs estao 100% em ingles.
- Lista inicial de negativas aplicada.
- URLs finais e tracking validados.
- Compliance revisado para o nicho do projeto.

## Prompt Replicavel Para IA

```text
Crie uma campanha de Google Ads Search usando RSA para [PRODUTO], seguindo estas regras:

1) Keywords:
- Monte clusters: branding, brand+intent, problema+solucao, mecanismo.
- Inclua obrigatoriamente palavras-chave de branding do produto.
- Defina match type inicial (exact/phrase) e lista de negativas base.

2) RSA:
- Crie 3 RSAs por ad group (minimo de 3 variantes).
- Cada RSA deve ter 12-15 titulos e 4 descricoes.
- Distribua os titulos em: keyword, beneficio, credibilidade, objecao, CTA.
- Gere headlines e descriptions em ingles.
- Garanta que 30% dos titulos tenham branding do produto.

3) CTA:
- Inclua 3-5 CTAs por RSA e pelo menos 8 CTAs distintos por ad group.
- Todas as CTAs devem ser em ingles.

4) Compliance:
- Evite claims proibidos, promessas absolutas e linguagem de cura/garantia.
- Ajuste a linguagem ao nicho sem violar politicas.

5) Entrega:
- Lista de keywords por cluster e match type.
- Lista de negativas.
- Assets RSA completos (titulos e descricoes).
- Plano de otimizacao de 21 dias.
- Gere obrigatoriamente um arquivo .md final no formato copy/paste para Google Ads, semelhante ao padrao "google-ads-copy-paste-campaign-[produto].md".
```
