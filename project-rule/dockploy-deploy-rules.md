# Project Rule: Deploy Via Dockploy

## Objetivo
Garantir que todo deploy no Dockploy funcione sem erro de arquivo ausente e com comportamento consistente de runtime config para `v1` e `v2`.

## Regras Obrigatorias
- O repositorio deve conter `Dockerfile` na raiz.
- O deploy atual usa servidor Node (`server.js`) para servir assets e runtime config.
- Nao remover os arquivos de deploy sem substituir por equivalente funcional.

## Padrao De Dockerfile (Projeto Atual)
- Base: `node:20-alpine`.
- Arquivo de entrada: `server.js`.
- Porta da aplicacao: `5500`.
- CMD final: `node server.js`.

## Padrao De Runtime Config
- Expor runtime para frontend por endpoint `/config.js`.
- Frontend deve consumir `window.APP_CONFIG`.
- Nao permitir parse direto de `/.env` no browser.

## Regra De Variaveis De Ambiente (Obrigatoria)
- Nao versionar `.env` no Git; manter em `.gitignore`.
- Manter `.env.example` no repositorio com as chaves esperadas.
- Em producao (Dockploy), definir variaveis no `environment` do servico (uppercase):
  - `CTA_URL`
  - `WEBHOOK_URL`
  - `TRACKING_DEBUG`
  - `MODAL_VISIBILITY`
- Evitar aliases lowercase para reduzir divergencia entre local e producao.

## Checklist Antes De Push
- Validar que `Dockerfile` existe na raiz.
- Validar que `server.js` e `config.js` de runtime estao funcionando no container.
- Validar endpoint de runtime:
  - `GET /config.js` retorna `window.APP_CONFIG` com chaves esperadas.
- Validar rotas:
  - `GET /v1` e `GET /v2` retornam `200`.

## Localizacao No Projeto
- `Dockerfile` (raiz)
- `server.js` (raiz)
- `project-rule/dockploy-deploy-rules.md`
