# Project Rule: Modelo De Email Para Solicitar Afiliação E Materiais

## Objetivo

Padronizar a criação de email para:

- solicitar aprovação de afiliação com o produtor/afiliador;
- solicitar materiais oficiais de suporte para o afiliado;
- apresentar o projeto com profundidade técnica e operacional para aumentar taxa de aprovação.

## Quando usar

- Sempre que iniciar operação de tráfego como afiliado.
- Sempre que precisar formalizar pedido de assets oficiais (copy, compliance, criativos, brand kit, regras de tráfego).
- Sempre que houver mudança de estratégia relevante (nova landing, novo tracking, novo fluxo de lead).

## Resultado esperado

- Email objetivo, profissional e auditável.
- Cobertura de pontos críticos que normalmente bloqueiam aprovação.
- Alinhamento entre expectativa do afiliador e implementação real do projeto.

## Configuração atual deste projeto (obrigatória no contexto local)

- Affiliate ID atual: `risead`
- Referência no ambiente:
  - arquivo: `d:\Projetos\aff-brainsong\.env`
  - chave de ID: `AFFILIATE_ID=risead`
  - chave de destino: `CTA_URL` (deve conter `affiliate=risead`)
- Regra:
  - o código deve ler destino e ID pelo env/runtime config;
  - não hardcodear `risead` diretamente em HTML/JS.

## Estrutura obrigatória do email

### 1) Assunto (Subject)

- Deve ser curto e direto, contendo:
  - pedido de afiliação;
  - pedido de materiais;
  - nome do produto.

Exemplo:

- `Affiliate Request | Rules, Lookalike, Email Assets, and Support | <PRODUCT_NAME>`

### 2) Abertura

- Apresentação em 1-2 linhas:
  - quem está solicitando;
  - pedido de aprovação de afiliação para o produto.

### 3) Resumo do projeto

- Manter simplificado e não estratégico:
  - produto alvo;
  - referência de afiliado (quando aplicável, ex.: `AFFILIATE_ID`);
  - intenção de operar dentro das regras oficiais.

### 4) Controles de qualidade e compliance

- Solicitar explicitamente:
  - regras de compliance e claims permitidos/proibidos;
  - restrições de tráfego;
  - disclaimers obrigatórios.

### 5) Solicitação objetiva de materiais

- Pedir apenas o necessário para operar:
  - regras oficiais de afiliação;
  - orientação de público lookalike;
  - arquivos/listas de email (swipes/templates/sequências);
  - suporte detalhado disponível para afiliados.

### 6) Perguntas objetivas

- Confirmar de forma direta:
  - o que é permitido/proibido;
  - qual lookalike recomendam;
  - quais assets de email podem fornecer;
  - qual suporte conseguem oferecer de boa fé e vontade.

### 7) Encerramento

- Pedir retorno com:
  - aprovação;
  - envio dos materiais solicitados;
  - contato responsável pelo suporte.

## Checklist antes de enviar

- O email está curto e objetivo.
- O pedido de afiliação está explícito.
- O pedido de regras oficiais está explícito.
- O pedido de lookalike está explícito.
- O pedido de arquivos/listas de email está explícito.
- O pedido de suporte detalhado está explícito.
- Não há detalhes de estratégia interna.

## Modelo base (replicável para qualquer projeto)

```text
Subject: Affiliate Request | Rules, Lookalike Audience, Email Assets, and Support

Hello <AFFILIATE_MANAGER_NAME/TEAM>,

My name is <YOUR_NAME>. I would like to request affiliate approval for <PRODUCT_NAME>.

Please share, objectively, the following:
1) Official affiliate rules and restrictions (traffic, compliance, and mandatory disclaimers)
2) Lookalike audience guidance you recommend (seed quality, audience % ranges, and any best-practice notes)
3) Available email list assets (swipes, templates, approved sequences, and usage conditions)
4) Detailed support documentation currently available to affiliates
   - What your team can offer in good faith and willingness
   - Onboarding materials
   - Operational support scope
   - Optimization guidance scope
   - Response SLA/channel, if applicable

Best regards,
<YOUR_NAME>
<CONTACT_INFO>
```

## Modelo preenchido para este projeto (The Brain Song)

```text
Subject: Affiliate Request | Rules, Lookalike Audience, Email Assets, and Support (The Brain Song)

Hello Affiliate Support Team,

My name is <YOUR_NAME>, and I would like to request affiliate approval for The Brain Song.

Affiliate reference:
- Affiliate ID: risead

Please share the following:
1) Official affiliate rules and restrictions
   - traffic restrictions
   - compliance rules
   - mandatory disclaimers
2) Lookalike audience guidance
   - recommended audience seeds
   - recommended lookalike ranges
   - practical recommendations you already validated
3) Email list assets
   - approved swipe files
   - approved email templates/sequences
   - usage conditions and limitations
4) Detailed affiliate support package
   - all materials currently available
   - what your team can offer in good faith and willingness
   - support channels, scope, and expected response time

Best regards,
<YOUR_NAME>
<CONTACT_INFO>
```

## Regras de manutenção deste arquivo

- Se a arquitetura do funil mudar, atualizar o modelo preenchido na mesma entrega.
- Se regras de compliance mudarem, atualizar seção de "compliance posture" e checklist.
- Se A/B variar (`v1`, `v2`, etc.), refletir no modelo e perguntas ao afiliador.
