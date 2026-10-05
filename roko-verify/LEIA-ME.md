# Comece por GUIA-HOSPEDAGEM.md
Tudo que você edita fica em `config.js`.

# ROKO Verify — instalação (15 min)
1. Crie conta grátis em supabase.com > New project.
2. SQL Editor > cole `schema.sql` > Run. (Se já tinha rodado a versão anterior, rode de novo: ele só atualiza.)
3. Authentication > Users > Add user (seu e-mail + senha). Esse é o login do admin. Em Authentication > Providers > Email, desative "Allow new users to sign up".
4. Project Settings > API: copie a Project URL e a anon key. Cole em `SUPABASE_URL` e `SUPABASE_KEY` no `index.html` e no `admin.html`.
5. Publique a pasta no Netlify (arrastar e soltar) ou Cloudflare Pages. Aponte `verify.seudominio.com` para ela.
6. Em `admin.html`, troque `SITE_URL` pelo endereço publicado.
7. Abra `/admin.html`, entre, gere um lote, baixe o CSV (código + URL) e mande para a gráfica imprimir etiqueta/QR.
Cada QR abre `verify.seudominio.com/?c=CODIGO` e já verifica sozinho.

## Verificação por QR code
- **Cliente:** no site, botão "Escanear QR code" abre a câmera (precisa de HTTPS, o Netlify já dá). Ou escaneia com a câmera nativa do celular, que abre o link e verifica sozinho.
- **Você:** no admin, "PNG" baixa o QR de uma peça e "Imprimir etiquetas QR do último lote" abre uma folha pronta para imprimir ou salvar em PDF.
- Imprima o QR com pelo menos 2 cm de lado, em fundo claro e alto contraste.

## Cadastro de produtos
No admin, seção **Produtos**: nome, SKU, descrição e foto. Depois, em **Gerar lote**, escolha o produto na lista. Quando o cliente verifica a peça, vê a foto, o SKU e a descrição.

## Um QR só para todas as peças, com verificação individual
1. No admin, "Baixar QR geral (PNG)": é o mesmo QR para todos os produtos (abre o site de verificação).
2. "Etiquetas só com código": folha com o código único de cada peça. Peça à gráfica etiqueta raspável (raspadinha) para esconder o código até a compra.
3. O cliente escaneia o QR geral, digita o código da peça e a verificação é individual.
