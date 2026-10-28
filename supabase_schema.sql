-- ==============================================================================
-- 🍩 DOUGHNUT BAKERY & CAFÉ - SUPABASE DATABASE SCHEMA & SEED DATA
-- ==============================================================================
-- Run this entire script in your Supabase Dashboard -> SQL Editor -> New Query -> Run.

-- 1. PRODUCTS TABLE
create table if not exists public.products (
  id text primary key,
  name text not null,
  category text not null,
  price numeric(10,2) not null,
  rating numeric(3,2) default 5.0,
  reviews_count integer default 1,
  tag text,
  tag_class text,
  image text,
  emoji text default '🍩',
  description text,
  featured boolean default false,
  in_stock boolean default true,
  options_label text default 'Pack Quantity',
  options jsonb default '[]'::jsonb,
  created_at timestamptz default now()
);

-- 2. ORDERS TABLE
create table if not exists public.orders (
  id text primary key,
  customer_name text,
  customer_email text,
  customer_phone text,
  customer_address text,
  items text,
  type text default 'Delivery',
  total numeric(10,2) not null,
  status text default 'new',
  created_at timestamptz default now()
);

-- 3. SITE SETTINGS TABLE (CMS Copy, Hours, Store Info)
create table if not exists public.site_settings (
  id text primary key default 'main',
  content jsonb not null,
  updated_at timestamptz default now()
);

-- ==============================================================================
-- ENABLE ROW LEVEL SECURITY (RLS) & PUBLIC ACCESS POLICIES
-- ==============================================================================
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.site_settings enable row level security;

-- Drop any existing policies to allow re-running safely
drop policy if exists "Allow public select on products" on public.products;
drop policy if exists "Allow public insert on products" on public.products;
drop policy if exists "Allow public update on products" on public.products;
drop policy if exists "Allow public delete on products" on public.products;

drop policy if exists "Allow public select on orders" on public.orders;
drop policy if exists "Allow public insert on orders" on public.orders;
drop policy if exists "Allow public update on orders" on public.orders;

drop policy if exists "Allow public select on site_settings" on public.site_settings;
drop policy if exists "Allow public upsert on site_settings" on public.site_settings;
drop policy if exists "Allow public update on site_settings" on public.site_settings;

-- Products Policies: Public read, public/admin insert, update, delete
create policy "Allow public select on products" on public.products for select using (true);
create policy "Allow public insert on products" on public.products for insert with check (true);
create policy "Allow public update on products" on public.products for update using (true);
create policy "Allow public delete on products" on public.products for delete using (true);

-- Orders Policies: Public read, insert (customer order), update (admin status changes)
create policy "Allow public select on orders" on public.orders for select using (true);
create policy "Allow public insert on orders" on public.orders for insert with check (true);
create policy "Allow public update on orders" on public.orders for update using (true);

-- Site Settings Policies: Public read and write
create policy "Allow public select on site_settings" on public.site_settings for select using (true);
create policy "Allow public upsert on site_settings" on public.site_settings for insert with check (true);
create policy "Allow public update on site_settings" on public.site_settings for update using (true);

-- ==============================================================================
-- ENABLE SUPABASE REALTIME (Instant Live Sync)
-- ==============================================================================
do $$
begin
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'products') then
    alter publication supabase_realtime add table public.products;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'orders') then
    alter publication supabase_realtime add table public.orders;
  end if;
  if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and tablename = 'site_settings') then
    alter publication supabase_realtime add table public.site_settings;
  end if;
exception
  when others then null;
end $$;

-- ==============================================================================
-- SEED INITIAL PRODUCTS (18 Items)
-- ==============================================================================
insert into public.products (id, name, category, price, rating, reviews_count, tag, tag_class, image, emoji, description, featured, in_stock, options_label, options)
values
  ('donut-1', 'Classic Glazed', 'donuts', 2.95, 4.90, 142, 'Bestseller', 'bestseller', 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80', '🍩', 'Our 18-hour slow-fermented signature brioche, dipped warm in translucent Madagascar vanilla bean glaze.', true, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}, {"name": "Box of 4", "priceDelta": 8.50}, {"name": "Box of 6", "priceDelta": 13.00}]'::jsonb),
  ('donut-2', 'Strawberry Sparkle', 'donuts', 3.65, 4.95, 189, 'Bestseller', 'bestseller', 'https://images.unsplash.com/photo-1527515862127-a4fc05baf7a5?auto=format&fit=crop&w=600&q=80', '🍓', 'Infused with freeze-dried Oregon strawberry purée, pink glaze, and colorful rainbow crunchy sprinkles.', true, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}, {"name": "Box of 4", "priceDelta": 10.50}]'::jsonb),
  ('donut-3', 'Belgian Chocolate Dream', 'donuts', 3.75, 4.85, 96, 'Popular', '', 'https://images.unsplash.com/photo-1579372786545-d24232daf58c?auto=format&fit=crop&w=600&q=80', '🍫', 'Double dipped in 70% Callebaut dark chocolate ganache and finished with hand-shaved chocolate curls.', true, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}, {"name": "Box of 4", "priceDelta": 11.00}]'::jsonb),
  ('donut-4', 'Boston Cream Velvet', 'donuts', 3.95, 4.90, 112, 'Chef Pick', 'new', 'https://images.unsplash.com/photo-1626094309830-abbb0c97da56?auto=format&fit=crop&w=600&q=80', '🍮', 'Fluffy pillow donut generously piped with chilled vanilla custard and crowned with dark chocolate glaze.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}, {"name": "Box of 4", "priceDelta": 11.50}]'::jsonb),
  ('donut-5', 'Kyoto Matcha Glaze', 'donuts', 3.85, 4.75, 78, 'Vegan', 'vegan', 'https://images.unsplash.com/photo-1549488344-1f9b8d2bd1f3?auto=format&fit=crop&w=600&q=80', '🍵', 'Ceremonial grade Uji matcha glaze offering earthy notes, paired with lightly roasted white sesame seeds.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}]'::jsonb),
  ('donut-6', 'Biscoff Butter Crunch', 'donuts', 3.95, 4.92, 164, 'Bestseller', 'bestseller', 'https://images.unsplash.com/photo-1582293041079-7814c2f12063?auto=format&fit=crop&w=600&q=80', '🍪', 'Speculoos cookie butter glaze, topped with crushed caramelized Lotus cookies and caramel drizzle.', true, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}, {"name": "Box of 4", "priceDelta": 11.50}]'::jsonb),
  ('donut-7', 'Smoky Maple Bacon', 'donuts', 4.10, 4.80, 84, 'Savory Sweet', 'new', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80', '🥓', 'Pure Vermont grade-A amber maple syrup glaze covered in thick applewood-smoked candied bacon bites.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}]'::jsonb),
  ('donut-8', 'Cookies & Cream Blast', 'donuts', 3.85, 4.82, 103, 'Popular', '', 'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=600&q=80', '🖤', 'Sweet vanilla bean frosting coated in crushed Oreo cookie crumble and cocoa fudge drizzle.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}]'::jsonb),
  ('donut-9', 'Cinnamon Brown Sugar', 'donuts', 2.95, 4.70, 65, 'Classic', '', 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=600&q=80', '🍂', 'Rolled directly out of the fryer in Vietnamese cinnamon and spiced golden raw cane sugar.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}]'::jsonb),
  ('donut-10', 'Wild Blueberry Lemon', 'donuts', 3.75, 4.88, 91, 'Vegan', 'vegan', 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80', '🫐', 'Tangy lemon zest brioche finished with a vibrant purple glaze made from crushed wild blueberries.', false, true, 'Pack Quantity', '[{"name": "Single Donut", "priceDelta": 0}]'::jsonb),
  ('coffee-1', 'Velvet Flat White', 'coffee', 4.25, 4.90, 130, 'Barista Choice', 'bestseller', 'https://images.unsplash.com/photo-1577968897966-3d4325b36b61?auto=format&fit=crop&w=600&q=80', '☕', 'Ristretto double shot blended with micro-foamed whole milk, delivering notes of cocoa and toasted hazelnut.', false, true, 'Size & Milk', '[{"name": "Standard (8 oz)", "priceDelta": 0}, {"name": "Large (12 oz)", "priceDelta": 0.65}]'::jsonb),
  ('coffee-2', 'Cold Brew Reserve', 'coffee', 4.50, 4.92, 175, 'Refreshing', '', 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?auto=format&fit=crop&w=600&q=80', '🧊', 'Steeped for 20 hours in cold filtered mountain water. Ultra-smooth, low acidity with dark chocolate undertones.', true, true, 'Size', '[{"name": "Medium (16 oz)", "priceDelta": 0}, {"name": "Large (24 oz)", "priceDelta": 0.85}]'::jsonb),
  ('coffee-3', 'Salted Caramel Latte', 'coffee', 4.95, 4.94, 210, 'Sweet Favorite', 'bestseller', 'https://images.unsplash.com/photo-1593443320739-77f74939d0da?auto=format&fit=crop&w=600&q=80', '🍯', 'Fresh espresso, house-made butter caramel sauce, sea salt flakes, and silky textured steamed milk.', false, true, 'Temperature', '[{"name": "Hot Medium (12 oz)", "priceDelta": 0}, {"name": "Iced (16 oz)", "priceDelta": 0.50}]'::jsonb),
  ('coffee-4', 'Single Origin Americano', 'coffee', 3.50, 4.65, 68, 'Pure Roast', '', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80', '☕', 'Two shots of Ethiopian washed beans pulled over hot spring water. Clean citrus, floral and jasmine notes.', false, true, 'Size', '[{"name": "Regular (12 oz)", "priceDelta": 0}, {"name": "Large (16 oz)", "priceDelta": 0.50}]'::jsonb),
  ('coffee-5', 'Dark Mocha Truffle', 'coffee', 5.15, 4.86, 94, 'Decadent', 'new', 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=600&q=80', '🍫', 'Melted Valrhona chocolate stirred with bold espresso and topped with whipped Madagascar vanilla cream.', false, true, 'Type', '[{"name": "Hot (12 oz)", "priceDelta": 0}, {"name": "Iced (16 oz)", "priceDelta": 0.50}]'::jsonb),
  ('coffee-6', 'Hazelnut Praline Cortado', 'coffee', 4.35, 4.88, 82, 'Artisan', '', 'https://images.unsplash.com/photo-1511920170033-f8396924c348?auto=format&fit=crop&w=600&q=80', '🌰', 'Equal parts bold espresso and velvety milk, infused with toasted Piedmont hazelnut reduction.', false, true, 'Milk Choice', '[{"name": "Whole Milk", "priceDelta": 0}, {"name": "Oat Milk", "priceDelta": 0.60}]'::jsonb),
  ('combo-1', 'Morning Revival Duo', 'combos', 6.95, 4.96, 310, 'Best Deal', 'bestseller', 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=600&q=80', '☕🍩', 'Any signature brioche donut paired with any large coffee drink. The ultimate sunrise breakfast ritual.', false, true, 'Select Coffee', '[{"name": "Americano + Donut", "priceDelta": 0}, {"name": "Latte + Donut", "priceDelta": 1.00}]'::jsonb),
  ('combo-2', 'Party Sampler Dozen (12)', 'combos', 34.50, 4.98, 220, 'Save $12', 'bestseller', 'https://images.unsplash.com/photo-1527515862127-a4fc05baf7a5?auto=format&fit=crop&w=600&q=80', '🎁', 'A curated tasting flight of our 12 most-demanded flavors packed neatly in our gold-foil presentation box.', false, true, 'Style', '[{"name": "Baker''s Assorted 12", "priceDelta": 0}]'::jsonb)
on conflict (id) do nothing;

-- ==============================================================================
-- SEED INITIAL SITE SETTINGS
-- ==============================================================================
insert into public.site_settings (id, content)
values (
  'main',
  '{
    "announcementText": "🍩 Free delivery on all orders over $30! Use code <strong>DONUT10</strong> for 10% off ✨",
    "heroBadge": "Handcrafted Daily with Love",
    "heroHeadline": "Fresh dough.<br><span class=\"highlight\">Bold coffee.</span><br>Pure joy.",
    "heroSubtext": "Warm brioche donuts crafted from scratch each morning, glazed in vibrant flavors, and paired with artisanal small-batch espresso.",
    "heroPerk1": "100% Organic Brioche",
    "heroPerk2": "Baked Every 3 Hours",
    "aboutTitle": "Rooted in Joy, Baked from Scratch.",
    "aboutP1": "DoughNut began with a tiny kitchen mixer and a bold conviction: that donuts deserve the high culinary treatment of artisan pastry, paired with genuinely remarkable third-wave coffee.",
    "aboutP2": "We slow-proof our brioche dough for eighteen hours to produce that signature airy crumb, cloud-like texture, and subtle buttery tang. Every glaze is simmered from genuine fruit purées, Belgian chocolates, and organic citrus.",
    "aboutStatNum": "100%",
    "aboutStatLabel": "Real churned butter & Madagascar bourbon vanilla beans in every single batch.",
    "contactAddress": "428 Sweet Blossom Blvd, Suite 101, Portland, OR 97204",
    "hoursWeekday": "6:30 AM - 6:00 PM",
    "hoursWeekend": "7:00 AM - 7:00 PM",
    "contactPhone": "(555) 368-4688",
    "contactEmail": "hello@doughnut-bakery.com",
    "locationLandmark": "Corner of 4th & Blossom St."
  }'::jsonb
)
on conflict (id) do update set content = excluded.content;

-- ==============================================================================
-- SEED SAMPLE ORDERS
-- ==============================================================================
insert into public.orders (id, customer_name, customer_email, customer_phone, customer_address, items, type, total, status)
values
  ('#DN-9842', 'Sarah Jenkins', 'customer@doughnut.com', '(555) 234-5678', '742 Evergreen Terrace, Apt 4', '2× Strawberry Sparkle, 1× Cold Brew Reserve', 'Delivery', 11.80, 'baking'),
  ('#DN-9839', 'Marcus Vance', 'marcus@startup.io', '(555) 890-1234', '120 Market St, Suite 500', '1× Party Sampler Dozen (12)', 'Pickup', 37.26, 'delivery'),
  ('#DN-9835', 'Maya Lin', 'maya@design.co', '(555) 678-9012', '88 Maple Ave', '4× Classic Glazed, 2× Velvet Flat White', 'Delivery', 20.30, 'completed')
on conflict (id) do nothing;
