# Project Rule: A/B Landing Pages (`v1` e `v2`)

## Objetivo

Padronizar a estratégia de teste A/B para landing pages com organização separada por versão, facilitando substituição, edição e manutenção sem quebrar roteamento, tracking ou regras de afiliado.

## Escopo obrigatório deste projeto

- `v1`: landing principal no formato advertorial (estrutura completa atual).
- `v2`: landing simplificada contendo apenas comportamento definido em `modal-popup-rules.md`.
- Em `v2`, qualquer clique relevante deve direcionar para o link de afiliado vindo do ambiente (`.env`), sem hardcode.

## Slugs obrigatórios

- `v1`
- `v2`

Exemplos de URLs:

- `/v1`
- `/v2`

## Regra de afiliado (obrigatória)

- O link de afiliado deve ser lido por variável de ambiente (ex.: `CTA_URL` ou `AFFILIATE_URL`).
- Qualquer botão/link/ação de redirecionamento deve consumir URL de runtime exposta pelo backend/config (`/config.js`, variável global equivalente, etc.).
- Não hardcodear URL de afiliado em HTML, CSS ou JavaScript.
- Se variável não existir:
  - registrar erro de configuração;
  - aplicar fallback controlado e rastreável.
- Em novos projetos, padronizar chaves em uppercase e evitar aliases lowercase.

## Comportamento esperado por versão

### `v1` (advertorial)

- Mantém fluxo completo (conteúdo, CTA, tracking e modal de lead se aplicável).
- Mantém taxonomia de tracking definida nas regras de tracking do projeto.
- Deve conter formulário de captura de lead antes do redirecionamento final.
- Endpoint do formulário (webhook) deve vir de variável de ambiente (ex.: `WEBHOOK_URL`), sem hardcode.
- URL de afiliado final deve vir de variável de ambiente (ex.: `CTA_URL`/`AFFILIATE_URL`).
- Após envio do formulário:
  - tentar envio ao webhook;
  - registrar tracking de sucesso/erro;
  - redirecionar para link de afiliado (fallback seguro mesmo com erro no webhook).

### `v2` (modal-only)

- Implementa apenas o modal e regras visuais/funcionais de `modal-popup-rules.md`.
- Qualquer ação de fechamento/interação que represente continuação de fluxo deve redirecionar para URL de afiliado via env.
- Em cenários de "qualquer click", aplicar no escopo da landing (container principal ou documento), exceto elementos explicitamente de controle técnico (ex.: debug/admin, quando existir).
- **Referência oficial de escopo da `v2`**: `modal-popup-rules.md` (seções de escopo de variante e regra anti-ambiguidade).
- Contrato de runtime da `v2`:
  - ler `CTA_URL` e `MODAL_VISIBILITY` por `window.APP_CONFIG` (provido por `/config.js`);
  - nao fazer parse de `/.env` no frontend.

## Organização recomendada de pastas (replicável)

```text
project-root/
  landings/
    v1/
      index.html
      styles.css
      script.js
    v2/
      index.html
      styles.css
      script.js
  shared/
    tracking/
    runtime-config/
  project-rule/
    ab-landing-pages-rule.md
    modal-popup-rules.md
    tracking-rule.md
```

## Regras de organização e manutenção

- Não misturar código de `v1` e `v2` no mesmo arquivo principal.
- Permitir deploy/rollback independente por versão.
- Componentes compartilhados devem ficar em `shared/` com contrato estável.
- Alterações de comportamento em uma versão não devem impactar a outra sem mudança explícita.

## Roteamento recomendado (genérico)

- Resolver slug da URL (`/v1` ou `/v2`) no servidor ou gateway.
- Servir artefato da pasta correspondente.
- Opcional: fallback de rota raiz (`/`) para versão definida por estratégia de tráfego (ex.: redirecionar para `/v1`).

## Estratégia de tráfego e distribuição A/B

- Definir split de entrada em camada de tráfego (ad network, edge, backend, experiment tool).
- Preservar consistência de versão por sessão/usuário para evitar contaminação de experimento.
- Registrar metadado da variante em todos os eventos (`landing_variant: v1|v2`).

## Tracking mínimo obrigatório por variante

- `v1`: tracking completo da landing advertorial + tracking de formulário:
  - evento de abertura de formulário (quando aplicável);
  - evento de submit;
  - evento de submit com sucesso;
  - evento de submit com erro;
  - evento de fallback sem webhook configurado.
- `v2`: no mínimo:
  - `lp_page_view`
  - `lp_cta_click` (ou evento equivalente de clique de saída)
  - evento de redirecionamento para afiliado
  - `landing_variant` em todos os eventos.

## Critérios de aceite

- Rotas `/v1` e `/v2` funcionando.
- `v2` respeita `modal-popup-rules.md`.
- Link de afiliado em ambas variantes vem de env/runtime config.
- Em `v1`, webhook do formulário vem de env/runtime config.
- Em `v1`, envio do formulário aciona tracking e redireciona para afiliado.
- Nenhuma URL de afiliado hardcoded no código.
- Nenhuma URL de webhook hardcoded no código.
- Estrutura de pastas separada e editável por versão.
- `.env` e `.env.example` com contrato consistente de chaves (sem duplicidade uppercase/lowercase).

## Prompt replicável para IA (A/B)

```text
Implemente arquitetura A/B para duas landing pages com slugs fixos:
- v1: landing completa (advertorial).
- v2: landing simplificada com modal-only conforme regra de modal.

Regras obrigatórias:
1) Organize código em pastas separadas por variante (`landings/v1` e `landings/v2`).
2) Não misture lógica específica de variantes no mesmo arquivo, exceto roteador.
3) Use URL de afiliado apenas por variável de ambiente/runtime config (ex.: CTA_URL).
4) Em v1, implemente formulário com webhook por env (ex.: WEBHOOK_URL), tracking de submit e redirecionamento final para afiliado por env.
5) Em v2, direcione para URL de afiliado em qualquer click relevante da landing.
6) Aplique tracking com campo `landing_variant` em todos os eventos.
7) Garanta que /v1 e /v2 sejam servidos corretamente.
8) Entregue checklist de validação final (rotas, env, tracking, redirecionamento).
```
