# Colocar o ROKO Verify no ar — passo a passo

Tempo: cerca de 30 minutos. Custo: R$ 0 (planos grátis). O único gasto opcional é o domínio.

## Etapa 1 — Banco de dados (Supabase)
1. Entre em **supabase.com**, crie a conta e clique em **New project**.
2. Dê um nome (ex: roko-verify), crie uma senha forte do banco (guarde-a) e escolha a região **South America (São Paulo)**.
3. Quando o projeto terminar de criar, abra **SQL Editor > New query**, cole todo o conteúdo do arquivo `schema.sql` e clique em **Run**. Deve aparecer "Success".
4. Abra **Authentication > Users > Add user > Create new user**. Informe seu e-mail e uma senha forte. Marque a opção de confirmar o e-mail automaticamente, se existir. Esse é o seu login do painel admin.
5. Em **Authentication**, procure a configuração de **Sign ups** e desative "Allow new users to sign up". Assim ninguém além de você cria conta.
6. Abra **Project Settings > API** e copie:
   - **Project URL**
   - chave **anon public**
   Não use a chave `service_role`, ela é secreta.

## Etapa 2 — Configurar o projeto
1. Abra o arquivo `config.js` em qualquer editor de texto (Bloco de Notas serve).
2. Cole a Project URL em `SUPABASE_URL` e a chave anon em `SUPABASE_KEY`.
3. Deixe `SITE_URL` com o endereço final do site. Se ainda não tem domínio, faça a Etapa 3 primeiro, pegue o endereço que o Netlify gerar e volte aqui.
   **Importante:** o QR gerado leva o `SITE_URL`. Acerte esse endereço antes de gerar e imprimir qualquer lote.

## Etapa 3 — Publicar (Netlify, grátis)
1. Entre em **netlify.com** e crie a conta.
2. Em **Sites**, use a opção de **arrastar e soltar** (Deploy manually) e solte a pasta `roko-verify` descompactada.
3. O Netlify gera um endereço tipo `nome-aleatorio.netlify.app`. Em **Site configuration > Change site name** troque por algo como `roko-verify`. Fica `roko-verify.netlify.app`.
4. Se o `SITE_URL` do `config.js` ainda não estava certo, corrija com esse endereço e solte a pasta de novo para atualizar.
O Netlify já entrega com HTTPS, que é obrigatório para a câmera funcionar.

## Etapa 4 — Domínio próprio (opcional)
1. Registre o domínio (ex: no Registro.br para .com.br).
2. No Netlify: **Domain management > Add a domain** e siga as instruções de DNS.
3. Para usar `verify.seudominio.com.br`, crie no DNS do domínio um registro **CNAME** com nome `verify` apontando para o endereço `.netlify.app` do seu site.
4. Atualize `SITE_URL` no `config.js` para o novo endereço e publique de novo.

## Etapa 5 — Testar antes de imprimir
1. Abra `SEU-SITE/admin.html`, entre com o e-mail e a senha da Etapa 1.
2. Em **Produtos**, cadastre um produto com foto.
3. Em **Gerar lote**, escolha o produto, lote `TESTE`, quantidade 3.
4. Clique em **Imprimir etiquetas QR do último lote** e escaneie um QR com o celular. Deve aparecer "Peça original ✓" com a foto.
5. Verifique o mesmo código de novo: deve aparecer "Código já verificado".
6. Digite um código inventado: deve aparecer "não encontrado".
7. Cancele os códigos de teste na lista, para não confundir com os reais.

## Etapa 6 — Usar de verdade
1. Cadastre cada produto (e variação) em **Produtos**.
2. Gere um lote com a quantidade exata de peças que vai fabricar.
3. Baixe o CSV, ou as etiquetas, e mande para a gráfica.
   - QR em cada peça: "Imprimir etiquetas QR do último lote".
   - Um QR só em todas as peças: "Baixar QR geral (PNG)" mais "Etiquetas só com código", de preferência raspável.
4. Acompanhe no painel as consultas repetidas e as tentativas de código inválido.

## Cuidados
- O `admin.html` não aparece em buscas, mas não é secreto. Quem protege é o login. Use senha forte.
- Guarde a senha do banco e o login do admin em um gerenciador de senhas.
- Faça backup: no Supabase, **Table Editor > codes > Export** em CSV de tempos em tempos.
- Se mudar o endereço do site depois de imprimir, os QR antigos deixam de funcionar. Mantenha o domínio.
