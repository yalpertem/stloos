-- Create stloos_images table
create table if not exists public.stloos_images (
    id uuid primary key default gen_random_uuid(),
    name text not null,
    created_at timestamptz default now(),
    updated_at timestamptz default now(),
    url text not null
);

-- Enable Row Level Security
alter table public.stloos_images enable row level security;

-- Create policy for public read access
create policy allow_public_read_access on public.stloos_images
for select using (true);

-- Create policy for authenticated users to manage images
create policy allow_authenticated_users_to_manage_images
on public.stloos_images
for all using (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

-- Create trigger to automatically update updated_at on row updates
create trigger set_updated_at
before update on public.stloos_images
for each row execute function public.handle_updated_at();
