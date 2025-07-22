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

-- Insert sample data
insert into public.stloos_images (name, url, created_at) values
('Sample Image 1', 'https://picsum.photos/400/600?random=1', '2024-01-15 10:30:00+00'),
('Sample Image 2', 'https://picsum.photos/400/600?random=2', '2024-02-20 14:15:00+00'),
('Sample Image 3', 'https://picsum.photos/400/600?random=3', '2024-03-10 09:45:00+00'),
('Sample Image 4', 'https://picsum.photos/400/600?random=4', '2024-04-05 16:20:00+00'),
('Sample Image 5', 'https://picsum.photos/400/600?random=5', '2024-05-12 11:10:00+00'),
('Sample Image 6', 'https://picsum.photos/400/600?random=6', '2024-06-18 13:30:00+00'),
('Sample Image 7', 'https://picsum.photos/400/600?random=7', '2024-07-03 08:25:00+00'),
('Sample Image 8', 'https://picsum.photos/400/600?random=8', '2024-08-14 15:40:00+00'),
('Sample Image 9', 'https://picsum.photos/400/600?random=9', '2024-09-22 12:05:00+00'),
('Sample Image 10', 'https://picsum.photos/400/600?random=10', '2024-10-07 17:55:00+00'),
('Sample Image 11', 'https://picsum.photos/400/600?random=11', '2024-11-11 10:15:00+00'),
('Sample Image 12', 'https://picsum.photos/400/600?random=12', '2024-12-25 14:30:00+00');
