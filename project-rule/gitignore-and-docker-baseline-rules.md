# Project Rule: Gitignore E Baseline De Deploy

## Objetivo
Definir regras minimas obrigatorias para versionamento seguro e deploy consistente.

## Regra 1: Gitignore Obrigatorio
- O projeto deve ter arquivo `.gitignore` na raiz.
- O `.gitignore` deve conter pelo menos:
  - `.env`
  - `project-rule/`
  - `informações de projeto/`
- E proibido versionar arquivos de segredo/ambiente no GitHub.
- E obrigatorio ignorar no Git:
  - a pasta de regras locais/documentacao operacional (`project-rule/`)
  - a pasta de materiais de apoio e informacoes internas (`informações de projeto/`)
- Quando necessario compartilhar chaves esperadas, usar `.env.example` sem segredo real.

## Regra 2: Dockerfile Obrigatorio
- O projeto deve ter `Dockerfile` na raiz.
- O `Dockerfile` deve descrever como subir a aplicacao de forma reprodutivel.
- Alteracoes de stack/runtime devem refletir no `Dockerfile` na mesma entrega.

## Regra 3: Docker Compose Obrigatorio
- O projeto deve ter `docker-compose.yml` na raiz.
- O compose deve conter servico principal da aplicacao (`web` ou equivalente).
- O compose precisa ser compativel com o fluxo de deploy do Dockploy.

## Regra 4: Gate De Validacao Antes De Push
- Confirmar que `.env` nao esta rastreado pelo Git.
- Confirmar que `project-rule/` e `informações de projeto/` nao estao rastreadas pelo Git.
- Confirmar existencia de:
  - `.gitignore`
  - `Dockerfile`
  - `docker-compose.yml`
- Bloquear push/deploy se qualquer item obrigatorio estiver ausente.

## Escopo
- Esta regra vale para todas as entregas deste repositorio, incluindo hotfixes.
