-- Rode no Supabase: SQL Editor > New query > Run. Pode rodar de novo sem problema (serve para instalar e para atualizar).
create table if not exists products(
  id bigint generated always as identity primary key,
  name text not null, sku text, description text, image_url text,
  created_at timestamptz default now()
);
create table if not exists codes(
  id bigint generated always as identity primary key,
  code text unique not null, product text, batch text not null,
  status text not null default 'active', -- active | revoked
  scans int not null default 0, first_scan timestamptz, created_at timestamptz default now()
);
alter table codes add column if not exists product_id bigint references products(id) on delete set null;
alter table codes alter column product drop not null;
create table if not exists scan_log(
  id bigint generated always as identity primary key,
  code text, result text, ua text, at timestamptz default now()
);
alter table products enable row level security;
alter table codes enable row level security;
alter table scan_log enable row level security;
drop policy if exists admin_products on products;
create policy admin_products on products for all to authenticated using(true) with check(true);
drop policy if exists admin_codes on codes;
create policy admin_codes on codes for all to authenticated using(true) with check(true);
drop policy if exists admin_log on scan_log;
create policy admin_log on scan_log for all to authenticated using(true) with check(true);

-- Pasta pública de fotos dos produtos (só o admin envia; todos podem ver)
insert into storage.buckets(id,name,public) values('products','products',true) on conflict do nothing;
drop policy if exists admin_photos on storage.objects;
create policy admin_photos on storage.objects for all to authenticated
  using(bucket_id='products') with check(bucket_id='products');

create or replace function verify_code(p_code text) returns json
language plpgsql security definer set search_path=public as $$
declare r codes%rowtype; p products%rowtype; res text;
begin
  p_code := upper(regexp_replace(coalesce(p_code,''),'[^A-Za-z0-9]','','g'));
  select * into r from codes where regexp_replace(code,'[^A-Z0-9]','','g')=p_code;
  if not found then
    insert into scan_log(code,result) values(p_code,'invalid');
    return json_build_object('status','invalid');
  end if;
  if r.status='revoked' then
    insert into scan_log(code,result) values(r.code,'revoked');
    return json_build_object('status','revoked');
  end if;
  update codes set scans=scans+1, first_scan=coalesce(first_scan,now()) where id=r.id returning * into r;
  res := case when r.scans=1 then 'ok' else 'repeat' end;
  insert into scan_log(code,result) values(r.code,res);
  select * into p from products where id=r.product_id;
  return json_build_object('status',res,'product',coalesce(p.name,r.product),'sku',p.sku,
    'description',p.description,'image',p.image_url,'batch',r.batch,'scans',r.scans,'first_scan',r.first_scan);
end $$;
grant execute on function verify_code(text) to anon, authenticated;
