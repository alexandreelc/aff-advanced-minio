# Instrução Inicial de Projeto (Replicável)

## Finalidade

Este documento define um passo a passo padrão para iniciar qualquer projeto com qualidade, reduzindo erros de arquitetura, tracking, segurança, compliance e retrabalho.

Use este fluxo **antes de escrever código**.

## Escopo de aplicação

- Projetos novos.
- Evolução de projeto existente.
- Migração/refatoração.
- Setup por IA ou por time humano.

## Entradas mínimas obrigatórias

- Pasta de regras do projeto (exemplo: `project-rule/`).
- Pasta de materiais de referência do projeto (exemplo: `informações de projeto/`).
- Arquivos de configuração de ambiente (`.env`, `.env.example`, secrets manager, quando existir).
- Contexto de negócio: objetivo, público, funil, métricas e restrições.

## Regra obrigatória para links de afiliado

- Todo link de direcionamento de afiliado deve ficar em variável de ambiente (ex.: `CTA_URL`, `AFFILIATE_URL`).
- Botões de CTA e elementos de redirecionamento devem ler a URL de runtime (config carregada do `.env`), nunca hardcode no HTML/JS.
- Se a variável estiver ausente, aplicar fallback controlado e registrar evento/log de configuração ausente.
- Qualquer alteração de link deve ocorrer por ambiente (env), sem editar código-fonte.
- Padronizar contrato em uppercase (`CTA_URL`, `WEBHOOK_URL`, `TRACKING_DEBUG`, `MODAL_VISIBILITY`) e manter `.env` e `.env.example` sincronizados.
- Frontend deve consumir runtime config por endpoint dedicado (ex.: `/config.js` + `window.APP_CONFIG`), sem parse direto de `/.env`.

## Passo a passo padrão de kickoff

### 1) Inventário inicial

- Liste os documentos de regra e governança do projeto.
- Liste os materiais de negócio/produto/copys/requisitos.
- Liste arquivos críticos de runtime e deploy.
- Defina claramente o objetivo do ciclo atual (ex.: conversão, estabilidade, escalabilidade).

### 2) Leitura de regras do projeto (obrigatório)

- Ler todas as regras em `project-rule/`.
- Garantir leitura explícita da regra de tracking base (arquivo: `tracking-rule.md`).
- Garantir leitura explícita dos arquivos de variação/experimento quando existirem (ex.: `ab-landing-pages-rule.md`).
- Quando houver captura de lead, garantir leitura explícita da regra de formulário (ex.: `form-lead-capture-rules.md`).
- Quando houver operação de afiliado, garantir leitura explícita da regra de email de solicitação de afiliação e assets (ex.: `affiliate-request-email-template-rules.md`).
- Extrair decisões mandatórias:
  - arquitetura;
  - segurança;
  - logging/observabilidade;
  - performance;
  - testes;
  - banco e migrações;
  - tracking/analytics.
- Transformar as regras em checklist operacional para a execução.

### 3) Investigação da pasta de informações do projeto (obrigatório)

- Ler e resumir os materiais da pasta de referência do projeto.
- Exemplo deste projeto: `d:\Projetos\aff-brainsong\informações de projeto`.
- Para replicar em outro projeto, substitua pelo diretório equivalente (ex.: `docs/`, `product-info/`, `knowledge-base/`).
- Objetivo da análise:
  - entender contexto de produto e oferta;
  - extrair termos permitidos/proibidos;
  - identificar linguagem de comunicação;
  - mapear objeções, promessas e riscos de compliance;
  - identificar artefatos úteis para implementação (copy, fluxos, FAQs, guias).

### 4) Consolidação de requisitos e riscos

- Converter leitura em artefatos práticos:
  - requisitos funcionais;
  - requisitos não funcionais;
  - riscos de segurança;
  - riscos de performance;
  - riscos de manutenção;
  - riscos de tracking/dados.
- Sinalizar lacunas de informação antes de codar.

### 5) Definição de arquitetura e contratos

- Definir fronteiras por camada (interface/api, aplicação, domínio, infraestrutura).
- Definir contratos de entrada/saída (payloads, validações, erros).
- Definir estratégia de idempotência e anti-duplicidade quando houver integração/ETL.
- Definir padrão de observabilidade (logs estruturados e eventos críticos).
- Definir contrato de runtime config para CTAs de afiliado:
  - chave de env obrigatória;
  - endpoint/config de exposição para frontend;
  - validação de formato de URL antes de uso.
- Se houver estratégia A/B:
  - mapear slugs obrigatórios das variantes (ex.: `v1`, `v2`);
  - separar estrutura física por variante;
  - garantir isolamento entre versões para edição e rollback.

### 6) Definição do plano de tracking (quando aplicável)

- Definir taxonomia de eventos.
- Se houver `v2` modal-only, limitar tracking da variante para:
  - `lp_page_view`
  - `lp_cta_click`
  - `lp_redirect_affiliate`
- Em `v2` modal-only, aplicar confiabilidade pré-redirect:
  - `sendBeacon` + fallback `fetch keepalive`;
  - timeout curto de redirecionamento sem travar UX.
- Definir parâmetros comuns obrigatórios.
- Definir eventos críticos de funil.
- Definir mapeamento GTM -> GA4/Meta.
- Definir critérios de aceite de tracking.

### 7) Estratégia de testes antes da implementação

- Planejar:
  - testes unitários;
  - testes de integração;
  - e2e quando fluxo for crítico.
- Definir gate mínimo:
  - lint;
  - typecheck;
  - testes;
  - validações de segurança;
  - migrações (se houver schema).

### 8) Plano de execução incremental

- Dividir em etapas pequenas com validação por etapa.
- Para cada etapa, definir:
  - saída esperada;
  - risco principal;
  - rollback simples.
- Evitar mudanças grandes sem checkpoints.

### 9) Critério de início de implementação

Só iniciar código quando:

- regras do projeto foram lidas e resumidas;
- pasta de informações foi analisada;
- riscos críticos foram mapeados;
- tracking e testes mínimos estão definidos;
- estratégia de links de afiliado via env foi validada (sem hardcode);
- contrato de variáveis entre `.env` e `.env.example` foi validado (mesmos nomes e sem duplicidade de aliases);
- dúvidas bloqueantes foram resolvidas.

### 10) Critério de conclusão do ciclo

- Implementação aderente às regras.
- Sem regressão crítica de comportamento.
- Logs/eventos essenciais funcionando.
- Testes e validações mínimas executados.
- Documentação atualizada para próximo ciclo.
- Runtime config validado localmente por endpoint (ex.: checar `/config.js` apos restart do servidor).

## Prompt replicável para IA (instrução inicial)

```text
Atue como engenheiro sênior de software orientado a produção.

Antes de implementar qualquer código, execute obrigatoriamente:

1) Ler todas as regras do projeto na pasta de regras (ex.: project-rule/).
2) Ler e analisar todos os materiais da pasta de informações do projeto
   (ex.: "informações de projeto/" ou pasta equivalente).
3) Gerar resumo estruturado com:
   - requisitos funcionais e não funcionais;
   - riscos de segurança, performance e manutenção;
   - decisões mandatórias de arquitetura;
   - estratégia de tracking e testes.
   - estratégia de links de afiliado via env para CTAs.
   - estratégia A/B por slug e organização por variante (quando aplicável).
   - estratégia de formulário (estrutura, validação, webhook por env, tracking e redirect).
   - estratégia de comunicação com afiliador (email de aprovação + pedido de assets oficiais).
4) Identificar lacunas e perguntas necessárias.
5) Propor plano incremental com critérios de aceite por etapa.

Regras de execução:
- Não iniciar implementação antes de concluir análise e investigação.
- Não ignorar regras explícitas do projeto.
- Não usar soluções que quebrem rastreabilidade, validação de contrato e observabilidade.
- Não hardcodear links de afiliado em botões; usar variável de ambiente e config runtime.
- Priorizar confiabilidade, clareza e facilidade de manutenção.

Ao final da análise, entregue:
- checklist de conformidade com as project rules;
- plano de implementação;
- plano de testes;
- riscos e mitigação.
```

## Checklist rápido (uso diário)

- Li todas as regras em `project-rule/`.
- Li a regra base de tracking (`tracking-rule.md`).
- Li também regras de experimento/variação (ex.: `ab-landing-pages-rule.md`) quando aplicável.
- Li também regras de formulário (ex.: `form-lead-capture-rules.md`) quando aplicável.
- Li também regras de comunicação com afiliador (ex.: `affiliate-request-email-template-rules.md`) quando aplicável.
- Analisei a pasta de informações do projeto.
- Mapeei requisitos e riscos.
- Defini tracking e testes mínimos.
- Só então iniciei implementação.
