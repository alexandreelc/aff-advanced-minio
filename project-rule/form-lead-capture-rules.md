# Project Rule: Formulário de Captura de Lead

## Objetivo

Definir padrão obrigatório para formulário de captura em landing page, cobrindo:

- estrutura visual;
- tipografia e dimensões;
- validações de entrada;
- integração com variáveis de ambiente;
- tracking de envio;
- redirecionamento final para link de afiliado.

## Escopo

- Válido para qualquer landing page com formulário de lead.
- Especialmente obrigatório para variante principal de funil (ex.: `v1`).

## Variáveis de ambiente obrigatórias

- `CTA_URL` (ou `AFFILIATE_URL`): URL de afiliado para redirecionamento final.
- `WEBHOOK_URL`: endpoint de recepção de lead (POST JSON).
- `TRACKING_DEBUG` (opcional): debug de eventos no client.

## Regras de configuração (obrigatórias)

- Não hardcodear `CTA_URL`/`AFFILIATE_URL` no código fonte.
- Não hardcodear `WEBHOOK_URL` no código fonte.
- Frontend deve consumir essas variáveis por config runtime (ex.: `window.APP_CONFIG`).
- Se variável estiver ausente:
  - registrar evento técnico de fallback;
  - preservar fluxo de usuário sem travar.

## Estrutura mínima do formulário

- Campos obrigatórios:
  - `full_name` (nome completo);
  - `phone`;
  - `email`.
- Elementos obrigatórios:
  - título claro;
  - subtítulo de orientação;
  - labels por campo;
  - mensagens de erro por validação;
  - botão de envio com estado de loading/disabled;
  - microcopy de privacidade.

## Regras de layout e tamanho

- Largura do card: `max-width` entre `480px` e `560px`.
- Espaçamento interno: `16px` a `24px`.
- Distância entre campos: `12px` a `16px`.
- Botão principal:
  - largura total (`100%`);
  - altura mínima de `48px` (desktop) e `44px` (mobile).
- Inputs:
  - altura mínima de `40px`;
  - borda e foco visíveis;
  - acessíveis por teclado.

## Tipografia recomendada

- Título: sans-serif, peso alto (`600+`), tamanho entre `20px` e `28px`.
- Label: sans-serif, peso médio/semibold (`500-600`), `13px` a `15px`.
- Input text: `14px` a `16px`, contraste legível.
- Mensagens auxiliares/privacidade: `12px` a `13px`, sem perder legibilidade.

## Regras de validação (obrigatórias)

- `full_name`:
  - remover espaços extras;
  - exigir pelo menos 2 palavras.
- `phone`:
  - máscara durante digitação (compatível com mercado alvo);
  - validar quantidade mínima de dígitos.
- `email`:
  - normalizar (`trim`, lowercase quando aplicável);
  - validar formato.
- Em caso de erro:
  - bloquear submit;
  - mostrar mensagem clara e objetiva;
  - não limpar formulário indevidamente.

## Integração com webhook (obrigatória)

- Método: `POST`.
- Header: `Content-Type: application/json`.
- Payload mínimo sugerido:
  - `full_name`
  - `phone`
  - `email`
  - `cta_url`
  - `page_url`
  - `page_path`
  - `timestamp`
  - `utm_*` e click IDs (quando existir)
- Observacao de contrato:
  - nome da chave no payload pode ser `cta_url`, mas a origem deve ser a env/runtime `CTA_URL` (uppercase).
- Tratar respostas não-2xx como erro de envio.

## Tracking obrigatório do formulário

- Evento de abertura de formulário (quando aplicável).
- Evento de submit válido (`form_submitted`).
- Evento de sucesso (`form_submit_success`).
- Evento de erro (`form_submit_error`).
- Evento de ausência de webhook (`form_submit_without_endpoint`).
- Todos eventos devem incluir:
  - `tracking_version`;
  - `session_id`;
  - `landing_variant` (quando houver A/B).

## Regra de redirecionamento pós-envio

- Após tentativa de envio do formulário, redirecionar para URL de afiliado da variável de ambiente.
- Redirecionamento deve ocorrer:
  - no sucesso do webhook;
  - no erro do webhook;
  - na ausência de webhook (fallback).
- O fluxo não pode travar por indisponibilidade do endpoint.

## Segurança e conformidade

- Não enviar PII para analytics client-side (`dataLayer`/pixels).
- PII apenas no webhook transacional autorizado.
- Não logar payload sensível completo no console em produção.
- Nunca expor segredos em frontend.

## Critérios de aceite

- Formulário renderiza corretamente em desktop e mobile.
- Validações funcionam e mensagens são claras.
- `WEBHOOK_URL` e `CTA_URL` vêm de env/runtime config.
- Sem hardcode de URLs sensíveis.
- Eventos de tracking do formulário disparam corretamente.
- Redirecionamento final para afiliado funciona em todos cenários (sucesso, erro, fallback).

## Prompt replicável para IA (Formulário)

```text
Implemente um formulário de captura de lead para landing page com padrão de produção.

Requisitos:
1) Campos: full_name, phone, email (obrigatórios).
2) Validação:
   - full_name com mínimo de 2 palavras;
   - phone com máscara e mínimo de dígitos;
   - email com validação de formato.
3) Configuração por env/runtime:
   - WEBHOOK_URL para envio POST JSON;
   - CTA_URL (ou AFFILIATE_URL) para redirecionamento final.
4) Tracking obrigatório:
   - form_open (quando aplicável),
   - form_submitted,
   - form_submit_success,
   - form_submit_error,
   - form_submit_without_endpoint.
5) Não hardcodear URLs no frontend.
6) Após tentativa de envio, redirecionar para CTA_URL em sucesso, erro ou fallback.
7) Não enviar PII para dataLayer/analytics; PII apenas no webhook autorizado.

Entregáveis:
- Código do formulário;
- contrato de payload;
- lista de eventos de tracking;
- checklist de testes de sucesso/erro/fallback.
```
