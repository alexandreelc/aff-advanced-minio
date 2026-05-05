# Project Rule: Cookie Modal Popup

## Objetivo
Padronizar o modal de `Cookie Settings` para manter consistencia visual, comportamento previsivel e manutencao segura no projeto.

## Escopo De Variante (Obrigatorio)
- **Neste projeto, este modal e unicamente da landing page `v2`** (modal-only), conforme `ab-landing-pages-rule.md`.
- A landing page `v1` (advertorial) segue fluxo completo e regra de formulario, **nao** fluxo modal-only.
- Se houver conflito de interpretacao entre arquivos:
  - `ab-landing-pages-rule.md` define o escopo de variantes (`v1` e `v2`);
  - este arquivo define apenas as regras de implementacao visual/funcional do modal da `v2`.

## Regra Anti-Ambiguidade Para IA (Obrigatoria)
- Ao replicar em outro projeto:
  - aplicar este modal apenas na variante equivalente a `v2` (ou variante explicitamente marcada como modal-only);
  - nao aplicar automaticamente este modal na variante principal (equivalente a `v1`) sem regra explicita.
- Nao assumir que "ter modal no repositorio" significa "usar modal em todas as landings".
- Antes de implementar, validar:
  - qual variante usa modal-only;
  - qual variante usa formulario/fluxo completo;
  - qual arquivo de regra tem precedencia para escopo.

## Contrato De Runtime (Obrigatorio)
- O frontend **nao deve** fazer parse direto de `/.env`.
- O frontend deve ler runtime config de `/config.js` via `window.APP_CONFIG`.
- Chaves padrao (somente uppercase):
  - `CTA_URL`
  - `MODAL_VISIBILITY`
- Nao usar aliases lowercase (`cta_url`, `modal_visibility`) em novos projetos.
- `.env` e `.env.example` devem manter o mesmo contrato de nomes de chave.

## Localizacao No Codigo (Projeto Atual)
- Landing `v2`: `landings/v2/index.html`.
- CSS do modal: bloco `<style>` no `<head>`, com seletores `#cookie-modal-backdrop`, `#cookie-settings-modal`, `.cookie-modal-title`, `.cookie-modal-btn`, `.cookie-modal-btn.accept`, `.cookie-modal-btn.decline`.
- HTML do modal: bloco no final do `<body>`, com:
  - `<div id="cookie-modal-backdrop">`
  - `<div id="cookie-settings-modal" ...>`
  - botoes `#cookie-modal-close`, `#cookie-accept-btn`, `#cookie-decline-btn`
- JS do modal: IIFE apos o HTML do modal, lendo `window.APP_CONFIG`.

## Regra Funcional (Obrigatoria)
- A visibilidade do modal deve ser controlada por `MODAL_VISIBILITY` em runtime (`window.APP_CONFIG.MODAL_VISIBILITY`).
- `MODAL_VISIBILITY=true`: modal aparece no carregamento.
- `MODAL_VISIBILITY=false`: modal nao aparece.
- Em qualquer acao de saida (`X`, `accept`, `decline`, clique no backdrop, clique fora do modal), redirecionar para `CTA_URL`.
- Fallback:
  - `CTA_URL` com valor padrao seguro quando ausente;
  - `MODAL_VISIBILITY` com fallback `true` para evitar falso negativo silencioso em ambiente local.

## Regra De Estrutura HTML (Obrigatoria)
- Manter IDs e classes exatamente:
  - `#cookie-modal-backdrop`
  - `#cookie-settings-modal`
  - `#cookie-modal-close`
  - `#cookie-accept-btn`
  - `#cookie-decline-btn`
  - `.cookie-modal-title`
  - `.cookie-modal-text`
  - `.cookie-modal-actions`
  - `.cookie-modal-btn`, `.accept`, `.decline`
- Nao remover `role="dialog"` e `aria-modal="true"`.

## Regra Visual CSS (Obrigatoria)
- Backdrop:
  - `position: fixed; inset: 0;`
  - overlay escuro com transparencia (`rgba(0, 0, 0, 0.34)`)
  - sem blur no fundo.
- Modal:
  - centralizado com `left: 50%`, `top: 50%`, `transform: translate(-50%, -50%)`
  - largura: `min(560px, calc(100vw - 24px))`
  - `background: #ffffff`, `border-radius: 12px`, `box-shadow` escura suave
  - `z-index` acima do backdrop.
- Tipografia:
  - titulo `.cookie-modal-title`: destaque forte
  - texto `.cookie-modal-text`: legivel e centralizado
  - botoes `.cookie-modal-btn`: texto medio, peso alto, sem exagero.
- Tamanho de botoes:
  - desktop: `font-size: 16px`, `min-height: 58px`
  - mobile: `font-size: 15px`, `min-height: 52px`.

## Correcao Aplicada (Anti-Recorrencia)
- Problema observado:
  - modal nao abria localmente e abria em producao por divergencia de contrato/env e processo local antigo.
- Ajuste adotado:
  - padronizacao para uppercase (`CTA_URL`, `MODAL_VISIBILITY`);
  - leitura exclusiva via `/config.js` (`window.APP_CONFIG`);
  - fallback funcional para evitar modal oculto por default acidental;
  - validacao de `config.js` no ambiente local apos restart.

## Checklist De Validacao (Obrigatorio)
- Verificar `http://127.0.0.1:5500/config.js`:
  - `CTA_URL` correto;
  - `MODAL_VISIBILITY` esperado.
- Verificar em `v2`:
  - modal visivel quando `MODAL_VISIBILITY=true`;
  - botoes `Close`, `Yes, I accept`, `No, I do not accept` renderizados;
  - clique em `X`, `accept`, `decline`, backdrop e fora do modal redireciona para `CTA_URL`.
- Em alteracao de env, reiniciar processo local antes de validar.

## Regra De Manutencao
- Qualquer alteracao no modal deve preservar:
  - contrato de runtime via `/config.js`;
  - redirecionamento para `CTA_URL`;
  - centralizacao e legibilidade do conteudo ao fundo;
  - hierarquia visual atual (titulo > texto > acoes).
- Se houver mudanca de layout/tipografia/comportamento, atualizar este arquivo na mesma entrega.
