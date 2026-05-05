# Tracking Rule: Landing Pages (Projeto Agnóstico)

## Objetivo

Este documento define um **prompt mestre reutilizável** para implementar tracking em **qualquer landing page**, independentemente de nicho, layout ou plataforma de tráfego.

O foco é:

- padronização de telemetria;
- consistência de eventos para GTM/GA4/Meta;
- robustez de funil (não perder evento por erro de integração);
- facilidade de replicação por outra IA com baixo risco de erro.

## Como usar este arquivo

- Copie o prompt da seção `PROMPT MESTRE PARA IA`.
- Cole em outra IA junto com o contexto do projeto alvo.
- Informe apenas os parâmetros de negócio (nome dos CTAs, tipo de formulário, destinos e integrações).
- Não altere a estrutura-base de eventos sem plano de migração.

## Convenções universais de tracking

- Prefixo de evento recomendado: `lp_` (landing page).
- Transporte primário: `window.dataLayer`.
- Orquestração: GTM (client-side e opcional server-side).
- Eventos devem ser imutáveis no nome após produção.
- Payload deve ser aditivo (novos campos podem ser adicionados sem quebrar os antigos).

## Configuração de GTM via `.env`

### Objetivo

Permitir que o ID do Google Tag Manager seja gerenciado por ambiente (`dev`, `staging`, `prod`) sem hardcode no HTML.

### Padrão recomendado

- Definir no `.env`:

```env
GTM_ID=GTM-XXXXXXX
TRACKING_DEBUG=false
```

- Expor para o frontend por config runtime (exemplo: `/config.js`):

```javascript
window.APP_CONFIG = {
  GTM_ID: "GTM-XXXXXXX",
  TRACKING_DEBUG: false
};
```

- No bootstrap da página:
  - Ler `window.APP_CONFIG.GTM_ID`.
  - Validar formato com regex `^GTM-[A-Z0-9]+$`.
  - Só injetar GTM se válido.
  - Disparar evento de telemetria de boot (`lp_tracking_boot`) informando se há GTM válido.

### Regras por ambiente

- `dev`: pode usar container de teste ou manter vazio para evitar ruído.
- `staging`: usar container de homologação.
- `prod`: usar container oficial de produção.
- Nunca commitar segredo sensível no `.env`; `GTM_ID` não é segredo, mas mantenha consistência operacional.

### Checklist rápido de configuração

- `GTM_ID` existe no `.env` do ambiente correto.
- endpoint/config runtime está expondo `GTM_ID` para o frontend.
- regex de validação evita injeção com valor inválido.
- `noscript` fallback (se estratégia do projeto exigir) está alinhado com política de consentimento.

## Taxonomia mínima recomendada (agnóstica)

### Eventos de inicialização

- `lp_tracking_boot`
- `lp_gtm_loaded`
- `lp_page_view`

### Eventos de consumo de conteúdo

- `lp_section_view`
- `lp_scroll_depth` (marcos: `25, 50, 75, 90, 100`)
- `lp_time_milestone` (marcos: `15, 45, 90, 180` segundos ativos)

### Eventos de intenção

- `lp_cta_view` (quando zona de CTA entra no viewport)
- `lp_cta_click`

### Eventos de captura de lead (se houver formulário)

- `lp_form_open`
- `lp_form_started` (primeiro input alterado)
- `lp_form_submitted`
- `lp_form_submit_success`
- `lp_form_submit_error`
- `lp_form_submit_without_endpoint` (fallback quando endpoint ausente)

### Evento composto de qualidade

- `lp_engaged_user` (disparo único por sessão, baseado em regra composta)

## Matriz Por Variante (`v1` e `v2`)

## Compatibilidade Do Projeto Atual

- A `v1` atual possui eventos legados com prefixo `adv_` em producao.
- Para novos projetos, adotar `lp_*` como padrao desde o inicio.
- Se houver migracao de `adv_*` para `lp_*` em projeto ativo, executar plano em duas fases:
  - fase 1: convivencia dos dois prefixos por janela de validacao;
  - fase 2: desativacao do prefixo antigo apos confirmacao no GTM/GA4/Meta.

### `v1` (advertorial + formulário)

- Manter tracking completo de funil:
  - `lp_tracking_boot`
  - `lp_page_view`
  - `lp_section_view`
  - `lp_scroll_depth`
  - `lp_time_milestone`
  - `lp_cta_view`
  - `lp_cta_click`
  - `lp_form_open`
  - `lp_form_started`
  - `lp_form_submitted`
  - `lp_form_submit_success`
  - `lp_form_submit_error`
  - `lp_form_submit_without_endpoint`

### `v2` (modal-only)

- Implementar tracking **mínimo e objetivo**, pois o único caminho da página é saída para afiliado:
  - `lp_page_view` (view da página)
  - `lp_cta_click` (clique que inicia saída/redirecionamento; incluir `trigger_source`)
  - `lp_redirect_affiliate` (evento de redirecionamento iniciado para URL de afiliado)
- Não adicionar eventos de scroll/time/section no `v2` sem necessidade de negócio.
- Incluir `landing_variant: "v2"` em todos os eventos da variante.
- Garantir guarda anti-duplicidade no redirecionamento para evitar eventos duplicados em múltiplos cliques.

## Parâmetros base obrigatórios em todos os eventos

- `event`
- `tracking_version`
- `session_id`
- `page_type` (ex: `landing_page`)
- `page_path`
- `page_title`
- `active_seconds`
- `utm_source`
- `utm_medium`
- `utm_campaign`
- `utm_content`
- `utm_term`
- `fbclid`
- `gclid`
- `event_timestamp_iso`

## Regras críticas para evitar erros

- Sempre inicializar `dataLayer` antes de qualquer push.
- Nunca depender apenas de clique final para medir intenção; medir também `cta_view`.
- Sempre incluir milestone `100` em scroll.
- Contar tempo apenas com aba visível (`document.visibilityState === "visible"`).
- Garantir fallback de fluxo quando endpoint de lead falhar.
- Não enviar PII para analytics client-side; PII apenas para endpoint transacional autorizado.
- Em erro de webhook/API, registrar evento de erro e preservar navegação do usuário.
- Não usar nomes de evento específicos de um único projeto.

## Confiabilidade Pré-Redirect (Obrigatória para `v2`)

- Para variantes de saída imediata (ex.: modal-only), aplicar envio de confirmação antes do redirect:
  - `dataLayer.push` imediato do `lp_cta_click` e `lp_redirect_affiliate`;
  - tentativa de envio técnico via `navigator.sendBeacon` para endpoint próprio (ex.: `/track-event`);
  - fallback em `fetch(..., { keepalive: true })`;
  - redirect com atraso curto controlado (`120ms` a `300ms`) + timeout máximo.
- Não bloquear navegação indefinidamente aguardando rede.
- Guardar estado anti-duplicidade para não enviar eventos duplicados em cliques repetidos.
- Em backend de saída (`/out` ou endpoint de tracking), responder rápido (`204`/`302`) para preservar UX.

## Regra de engajamento recomendada (genérica)

Disparar `lp_engaged_user` uma única vez quando:

- `active_seconds >= 45`
- `sections_viewed >= 2`
- e (`cta_clicked = true` ou `max_scroll_percent >= 75`)

## Mapeamento universal GTM/GA4/Meta

- GTM:
- criar trigger por custom event `lp_*` (ou regex `^lp_` para observabilidade);
- criar variáveis de Data Layer para parâmetros base e específicos.

- GA4:
- 1 configuração global + 1 tag por evento relevante;
- registrar dimensões personalizadas para `section_name`, `scroll_percent`, `cta_name`, `session_id`.

- Meta:
- mapear `lp_cta_click` para evento de intenção (`Lead` ou custom);
- mapear `lp_form_submit_success` para conversão principal de lead;
- se usar CAPI, aplicar deduplicação por `event_id`.

## Estrutura recomendada do GTM no projeto

### 1) Organização de container

- Criar workspaces por frente de trabalho (ex.: `tracking-lp`, `hotfix`).
- Padronizar nomes:
  - Tags: `GA4 - Event - lp_cta_click`
  - Triggers: `CE - lp_cta_click` (CE = Custom Event)
  - Variáveis: `DLV - cta_name` (DLV = Data Layer Variable)
- Manter pasta por domínio:
  - `01 - Core`
  - `02 - Acquisition`
  - `03 - Engagement`
  - `04 - Conversion`
  - `99 - Debug`

### 2) Camada Core (obrigatória)

- 1 tag de configuração GA4 (base).
- Variáveis DLV para todos campos base (`session_id`, `tracking_version`, `utm_*`, `fbclid`, `gclid`).
- Trigger de inicialização para eventos de bootstrap/página.

### 3) Camada de eventos custom

- 1 trigger para cada evento crítico (`lp_page_view`, `lp_cta_click`, `lp_form_submitted`, `lp_form_submit_success`).
- Opcional: trigger regex `^lp_` + tag de debug para auditoria.
- Evitar lógica complexa em trigger; prefira payload já pronto no frontend.

### 4) Camada de conversão

- GA4:
  - mapear `lp_form_submit_success` como conversão principal;
  - usar `lp_cta_click` como microconversão de intenção.
- Meta:
  - mapear `lp_cta_click` para `Lead` (ou custom conforme estratégia);
  - mapear `lp_form_submit_success` como evento de qualidade/conversão.

### 5) Camada de governança

- Versionar publicações do GTM com changelog curto.
- Publicar com descrição do impacto (eventos criados/alterados/removidos).
- Manter matriz de rastreamento fora do GTM (arquivo versionado no projeto).
- Se mudar nome de evento em produção:
  - executar plano de migração em duas fases (convivência + depreciação).

## Estratégia de testes obrigatória

- Teste funcional de eventos no browser (console + GTM Preview).
- Teste de ordem mínima: `lp_tracking_boot` -> `lp_page_view`.
- Teste de scroll até `100`.
- Teste de milestones de tempo.
- Teste de visualização de seção e CTA.
- Teste de submit com sucesso e com falha.
- Teste de fallback quando endpoint não existe.
- Teste sem UTM (deve funcionar com strings vazias).

## Critérios de aceite

- Nenhum evento crítico ausente.
- Nomes de eventos estáveis e coerentes.
- Sem PII no `dataLayer`.
- Conversão/fallback funcionando sem quebrar navegação.
- Eventos consistentes em local, staging e produção.

## PROMPT MESTRE PARA IA

```text
Implemente um sistema de tracking GTM-centric para uma landing page, de forma genérica e reutilizável, sem acoplamento ao projeto atual.

Objetivo:
- Medir aquisição, consumo de conteúdo, intenção e conversão.
- Permitir roteamento por GTM para GA4 e Meta.
- Garantir robustez operacional (não perder fluxo por erro de integração).

Requisitos de implementação:

1) Bootstrap e runtime
- Inicialize window.dataLayer com segurança.
- Implemente runtime config (por variável global ou endpoint) para chaves como:
  TRACKING_DEBUG, GTM_ID, CTA_URL, FORM_ENDPOINT.
- Dispare lp_tracking_boot ao iniciar.
- Se GTM_ID válido, carregue GTM dinamicamente e dispare lp_gtm_loaded.

2) Função central de push
- Crie pushDataLayer(eventName, payload).
- Inclua sempre os parâmetros base:
  event, tracking_version, session_id, page_type, page_path, page_title, active_seconds,
  utm_source, utm_medium, utm_campaign, utm_content, utm_term, fbclid, gclid, event_timestamp_iso.
- Se TRACKING_DEBUG=true, logue os eventos no console.

3) Sessão e aquisição
- Gere session_id único por aba/sessão e persista em sessionStorage.
- Extraia UTMs e click IDs via URLSearchParams.

4) Eventos obrigatórios
- lp_page_view no init.
- lp_section_view ao visualizar seções relevantes (IntersectionObserver).
- lp_cta_view quando zona de CTA ficar visível pela primeira vez.
- lp_scroll_depth em [25,50,75,90,100].
- lp_time_milestone em [15,45,90,180], apenas com aba visível.
- lp_cta_click em todos CTAs rastreáveis.

5) Formulário (se existir)
- Dispare lp_form_open ao abrir modal/área de captura.
- Dispare lp_form_started no primeiro input alterado.
- Dispare lp_form_submitted no submit válido.
- Se endpoint ausente: dispare lp_form_submit_without_endpoint e siga fallback de navegação.
- Se request 2xx: dispare lp_form_submit_success.
- Se erro/request não-2xx: dispare lp_form_submit_error.
- Não enviar PII no dataLayer; PII apenas no endpoint transacional autorizado.

6) Evento composto de engajamento
- Dispare lp_engaged_user uma vez por sessão quando:
  active_seconds >= 45 AND sections_viewed >= 2 AND (cta_clicked OR max_scroll_percent >= 75).

7) Confiabilidade e fallback
- Não interrompa o fluxo principal por falha de webhook/API.
- Preserve navegação do usuário em blocos finally/controle equivalente.
- Evite duplicidade de eventos com guards de estado (Set/flags).

8) Entregáveis
- Código implementado.
- Lista final de eventos e payload por evento.
- Matriz evento -> trigger GTM -> destino (GA4/Meta).
- Plano de testes executáveis com critérios de aceite.

Restrições:
- Não usar nomes específicos do projeto de origem.
- Não remover evento 100% scroll.
- Não quebrar compatibilidade de nomenclatura após produção.
```

## Checklist de manutenção contínua

- Ao criar evento novo, atualizar taxonomia e GTM juntos.
- Ao alterar payload, versionar `tracking_version`.
- Ao trocar endpoint/form provider, revalidar cenários de sucesso, erro e fallback.
- Revisar periodicamente eventos órfãos não consumidos no GTM/GA4/Meta.
