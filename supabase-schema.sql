-- =========================================================
-- MotoControl — Esquema para Supabase
-- Copia y pega todo este archivo en Supabase > SQL Editor > Run
-- =========================================================

create extension if not exists "pgcrypto";

-- ---------- Tablas ----------
create table if not exists motos (
  id uuid primary key default gen_random_uuid(),
  placa text not null,
  marca text,
  modelo text,
  anio text,
  conductor_id uuid,
  estado text default 'activa',
  notas text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists conductores (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  cedula text,
  telefono text,
  fecha_ingreso date,
  estado text default 'activo',
  notas text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists movimientos (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('ingreso','egreso')),
  fecha date not null,
  monto numeric not null default 0,
  moto_id uuid references motos(id) on delete set null,
  conductor_id uuid references conductores(id) on delete set null,
  categoria text,
  descripcion text,
  created_at timestamptz default now()
);

alter table motos
  add constraint motos_conductor_fk foreign key (conductor_id) references conductores(id) on delete set null;

-- ---------- Seguridad (RLS) ----------
-- Solo usuarios autenticados (los que ustedes creen manualmente) pueden leer y escribir.
alter table motos enable row level security;
alter table conductores enable row level security;
alter table movimientos enable row level security;

create policy "motos_select" on motos for select using (auth.role() = 'authenticated');
create policy "motos_insert" on motos for insert with check (auth.role() = 'authenticated');
create policy "motos_update" on motos for update using (auth.role() = 'authenticated');
create policy "motos_delete" on motos for delete using (auth.role() = 'authenticated');

create policy "conductores_select" on conductores for select using (auth.role() = 'authenticated');
create policy "conductores_insert" on conductores for insert with check (auth.role() = 'authenticated');
create policy "conductores_update" on conductores for update using (auth.role() = 'authenticated');
create policy "conductores_delete" on conductores for delete using (auth.role() = 'authenticated');

create policy "movimientos_select" on movimientos for select using (auth.role() = 'authenticated');
create policy "movimientos_insert" on movimientos for insert with check (auth.role() = 'authenticated');
create policy "movimientos_update" on movimientos for update using (auth.role() = 'authenticated');
create policy "movimientos_delete" on movimientos for delete using (auth.role() = 'authenticated');

-- ---------- Tiempo real ----------
-- Para que los cambios de una persona aparezcan al instante en la pantalla de las demás.
alter publication supabase_realtime add table motos;
alter publication supabase_realtime add table conductores;
alter publication supabase_realtime add table movimientos;
