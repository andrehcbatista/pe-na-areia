# Pe na Areia - Checklist operacional para implementacao futura de Auth e profiles

## 1. Aviso inicial

Este documento e um checklist preparatorio para uma implementacao futura de autenticacao e perfis no Pe na Areia.

Neste ciclo:

- [ ] Nao implementar login.
- [ ] Nao alterar telas.
- [ ] Nao executar SQL.
- [ ] Nao alterar RLS.
- [ ] Nao conectar novos fluxos.
- [ ] Manter o app publico funcionando.

Este checklist nao autoriza implementacao de cadastro real, login real, pedidos, pagamentos, comandas, reservas, cashback real, backend operacional ou integracoes externas.

## 2. Pre-requisitos antes de implementar Auth

Antes de qualquer implementacao real de autenticacao, confirmar:

- [ ] Supabase configurado.
- [ ] Schema executado.
- [ ] RLS executado.
- [ ] Tabela `profiles` existente.
- [ ] `AUTH_AND_ROLES_PLAN.md` revisado.
- [ ] `.env.local` configurado e ignorado pelo Git.
- [ ] `service_role` protegida e nunca exposta no app Flutter.
- [ ] Git limpo antes de iniciar o ciclo.

## 3. Decisoes antes de implementar

Decisoes iniciais aprovadas para orientar ciclos futuros:

- [ ] O login inicial sera por e-mail e senha.
- [ ] Google sera avaliado depois.
- [ ] Apple sera avaliado antes de iOS se houver login social.
- [ ] Telefone/OTP nao entra inicialmente.
- [ ] `visitor` continuara acessando a area publica sem login.
- [ ] `customer` sera o primeiro perfil logado implementado.
- [ ] `establishment_owner`, `establishment_staff` e `platform_admin` virao depois, em ciclos separados.

## 4. Checklist tecnico para cadastro customer

Quando o ciclo de cadastro de consumidor for aprovado:

- [ ] Criar tela de cadastro.
- [ ] Coletar nome, e-mail e senha.
- [ ] Validar campos obrigatorios.
- [ ] Validar formato de e-mail.
- [ ] Validar senha conforme regra minima definida.
- [ ] Criar usuario via Supabase Auth.
- [ ] Criar registro em `profiles` vinculado ao usuario autenticado.
- [ ] Definir `role` inicial como `customer`.
- [ ] Tratar erro de e-mail ja cadastrado.
- [ ] Tratar erro de senha fraca.
- [ ] Tratar falha de conexao.
- [ ] Manter o usuario informado sobre sucesso, erro e proximos passos.
- [ ] Nao exigir login para consulta publica de praias, estabelecimentos e cardapios.

## 5. Checklist tecnico para login customer

Quando o ciclo de login de consumidor for aprovado:

- [ ] Criar tela de login.
- [ ] Implementar login por e-mail e senha.
- [ ] Validar campos obrigatorios.
- [ ] Validar formato de e-mail.
- [ ] Autenticar via Supabase Auth.
- [ ] Carregar o `profile` do usuario autenticado.
- [ ] Manter sessao ativa conforme comportamento padrao aprovado.
- [ ] Permitir logout.
- [ ] Tratar erro de credenciais invalidas.
- [ ] Tratar e-mail nao confirmado, se essa regra estiver ativa no Supabase.
- [ ] Manter a consulta publica acessivel sem login.

## 6. Checklist tecnico para profiles

Antes de usar `profiles` em fluxo real:

- [ ] Confirmar vinculo correto com `auth.users`.
- [ ] Definir campos minimos para o primeiro ciclo.
- [ ] Usar `customer` como `role` padrao para cadastro de consumidor.
- [ ] Nao permitir que usuario comum defina `platform_admin`.
- [ ] Impedir atualizacao indevida de `role` pelo proprio usuario.
- [ ] Proteger leitura e escrita por RLS.
- [ ] Testar leitura do proprio `profile`.
- [ ] Testar bloqueio de leitura de `profile` de outro usuario.
- [ ] Testar bloqueio de alteracao de `role` pelo cliente.

Campos minimos sugeridos para o primeiro ciclo:

- `id`;
- `auth_user_id`;
- `full_name`;
- `email`;
- `role`;
- `status`;
- `created_at`;
- `updated_at`.

## 7. Checklist de navegacao

Ao adicionar Auth futuramente:

- [ ] Manter fluxo visitante.
- [ ] Adicionar entrada discreta para login.
- [ ] Nao bloquear Home.
- [ ] Nao bloquear Cardapio.
- [ ] Nao bloquear consulta publica de estabelecimento.
- [ ] Permitir que botoes futuros como "Fazer pedido", "Abrir comanda" e "Reservar" redirecionem para login quando essas funcionalidades forem aprovadas.
- [ ] Nao implementar pedido neste ciclo.
- [ ] Nao implementar comanda neste ciclo.
- [ ] Nao implementar reserva neste ciclo.

## 8. Checklist de seguranca

Antes de producao ou uso com dados sensiveis:

- [ ] Nunca usar `service_role` no Flutter.
- [ ] Nao expor secrets no codigo, logs, commits ou telas.
- [ ] Nao salvar senha localmente.
- [ ] Nao permitir alteracao de `role` pelo cliente.
- [ ] Testar RLS antes de producao.
- [ ] Usar `audit_logs` para acoes administrativas futuras.
- [ ] Evitar dados pessoais desnecessarios.
- [ ] Cuidar da LGPD desde o primeiro fluxo real.
- [ ] Nao gravar senhas, tokens, chaves ou dados sensiveis em logs.
- [ ] Revisar mensagens de erro para nao expor detalhes internos.

## 9. Ordem recomendada dos proximos ciclos

Ordem segura sugerida para ciclos futuros, sempre com escopo separado:

1. Criar telas de Login, Cadastro e Recuperacao de senha apenas UI, sem conectar Auth.
2. Integrar cadastro `customer` com Supabase Auth.
3. Criar `profile` `customer`.
4. Integrar login e logout.
5. Criar estado de sessao.
6. Criar tela de perfil simples.
7. Proteger rotas futuras.
8. Planejar `establishment_owner`.
9. Planejar `platform_admin` real.

## 10. Criterios de aceite para avancar

Para considerar o ciclo real de Auth pronto para avancar:

- [ ] App publico continua acessivel sem login.
- [ ] Cadastro `customer` funciona em ambiente de teste.
- [ ] `profile` `customer` e criado corretamente.
- [ ] `role` nao pode ser manipulada pelo usuario.
- [ ] Login funciona.
- [ ] Logout funciona.
- [ ] Sessao e restaurada ou encerrada conforme decisao aprovada.
- [ ] Nenhum dado sensivel aparece no Git.
- [ ] Nenhuma chave secreta aparece no Flutter.
- [ ] Fallback publico continua funcional.
- [ ] RLS foi testada para usuario autenticado e visitante.
- [ ] Erros comuns sao tratados de forma clara para o usuario.

## Observacao final

Este documento deve ser revisado imediatamente antes de iniciar qualquer ciclo real de login, cadastro ou perfis.

Enquanto essa etapa nao for aprovada, o Pe na Areia deve continuar com consulta publica livre e sem obrigatoriedade de autenticacao.
