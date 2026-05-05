# Project Rule: Figma MCP Faithful Template

## Objetivo
Padronizar a reproducao fiel de layouts do Figma via MCP, com qualidade consistente neste projeto e em projetos futuros.

## Escopo
- Esta regra se aplica sempre que houver link de Figma como fonte de verdade de UI.
- Valida para landing pages, paginas internas, componentes e seções.

## Fonte De Verdade
- O design do Figma enviado pelo usuario e a referencia principal.
- Nao reinterpretar layout por preferencia pessoal.
- Nao simplificar componentes sem aprovacao explicita do usuario.

## Fluxo Obrigatorio De Implementacao
- Ler o frame correto (node-id especificado) via MCP.
- Reproduzir estrutura visual na ordem do design:
  - layout
  - espacamentos
  - tipografia
  - cores
  - componentes
  - estados visuais relevantes.
- Preservar hierarquia visual e comportamento responsivo equivalente ao frame.

## Regra De Fidelidade Visual
- Exigir paridade visual alta com o Figma:
  - grid/alinhamento
  - margens e paddings
  - tamanhos de fonte e peso
  - raio de borda, sombras e contrastes
  - posicao e escala de imagens/elementos.
- Evitar substituicoes visuais nao solicitadas.
- Se algum asset do Figma nao estiver disponivel, usar fallback temporario e registrar claramente.

## Regra De HTML/CSS
- HTML semantico e organizado por seções do frame.
- CSS modular e previsivel, sem sobrescritas caoticas.
- Nomes de classes claros e consistentes.
- Sem efeitos extras nao previstos no design, a menos que o usuario solicite.

## Regra De Interacao E Conteudo
- Manter textos e CTAs conforme a referencia aprovada.
- Links e variaveis de ambiente devem continuar funcionais apos reproducao visual.
- Qualquer mudanca de comportamento deve ser documentada na entrega.

## Checklist Obrigatorio Antes Da Entrega
- Confirmar que o resultado em localhost corresponde ao frame de referencia.
- Validar desktop e mobile (quando houver variacao no Figma).
- Verificar ausencia de elementos quebrados, placeholders vazios e imagens faltantes.
- Verificar tipografia, tamanhos e espacamentos criticos.

## Regra Para Projetos Futuros
- Reutilizar este mesmo processo em qualquer novo projeto com entrada via Figma.
- Ao detectar divergencia entre implementacao e frame, priorizar correcao de fidelidade antes de melhorias secundarias.
