# 🍩 DoughNut - Modern Bakery & Café E-Commerce Web App

> **"Fresh dough. Bold coffee. Pure joy."**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fblubador-shhh%2Fdoughnut-store)

A complete, self-contained, production-quality e-commerce and store operations web application for **DoughNut**, a modern boutique bakery & specialty café. Built with zero build step dependencies (vanilla HTML5, CSS3, and modern JavaScript).

---

## ✨ Features

- **Artisanal Brand & Design System**:
  - Warm bakery palette: `#FFF6EC` warm cream, `#3B2418` espresso brown, `#FF6FA3` strawberry glaze, and `#D98E3F` warm caramel.
  - Friendly typography: Fredoka display font paired with DM Sans.
  - Micro-interactions, sprinkle effects, floating hero donut, and responsive layout across mobile (360px), tablet (768px), and desktop (1440px).

- **Menu & Catalog (18+ Products)**:
  - 10 Gourmet Donuts (*Classic Glazed, Strawberry Sprinkle, Boston Cream, Biscoff Crunch, Matcha Glaze, Maple Bacon, etc.*)
  - 6 Specialty Coffees (*Espresso, Cappuccino, Caramel Latte, Cold Brew, Hazelnut Latte, etc.*)
  - Combo & Sharing Deals (*Coffee + Donut pairings, Party Boxes*)
  - Category filtering, real-time instant search, and sorting (popularity, price low/high).

- **Interactive Customer Experience**:
  - **Quick-View Modal**: Flavor options, box sizing (1, 4, 6, 12 pack) or coffee sizes (S, M, L).
  - **Build-Your-Own Box Visualizer**: Select 4 or 6 custom donut flavors into an interactive box.
  - **Favorites / Wishlist**: Heart toggle with instant badge counter.
  - **Cart Drawer & Checkout**: Live quantity adjustments, promo code discount engine (`DONUT10` for 10% off), delivery vs. pickup toggle, and generated order confirmation tickets.
  - **Customer Portal**: Sign in, register, track order history, and earn loyalty sprinkle points.

- **Admin Operations & Real-Time Website CMS**:
  - **Admin Mode Toolbar**: Appears when authenticated as Admin.
  - **In-Place Website CMS (`✏️ Edit Website Info`)**: Live-update announcement bar copy, hero headline, about brand story, counter metrics, store hours, and contact details.
  - **Direct Menu Product Editing (`✏️ Edit` on Cards)**: Update prices, names, photos, descriptions, categories, or toggle items as *Sold Out*.
  - **Kitchen & Order Console**: Real-time kitchen tickets with status transitions (`New Ticket` ➔ `Baking` ➔ `Out for Delivery` ➔ `Completed`).
  - **Supabase Cloud Database & Realtime**: Integrated with Supabase Postgres for shared cloud catalog, live kitchen order sync, and authentication with seamless offline/localStorage fallback.

---

## ⚡ Supabase Cloud Setup (1-Minute)

Your application is already configured with your Supabase credentials:
- **Project URL**: `https://yuqulyumgvkvktfzrdgc.supabase.co`

To enable the cloud database and realtime sync across all visitors and devices:
1. Open your [Supabase Dashboard](https://supabase.com/dashboard).
2. Go to **SQL Editor** ➔ **New Query**.
3. Copy and paste the contents of [`supabase_schema.sql`](supabase_schema.sql).
4. Click **Run**.

This automatically creates the `products`, `orders`, and `site_settings` tables, seeds all 18 gourmet products, configures open public read/write access policies, and enables instant Realtime updates!

---

## 🚀 Quick Start

1. Clone or download this repository.
2. Open [`index.html`](index.html) in any web browser.
   *No Node.js, npm, or build step required!*

---

## 🔑 Demo Accounts

| Role | Email | Password | Privileges |
| :--- | :--- | :--- | :--- |
| **Store Admin** | `admin@doughnut.com` | `admin123` | Real-time site editing, product editing, kitchen console |
| **Customer** | `customer@doughnut.com` | `donut123` | Ordering, loyalty sprinkle points, order history |

*Tip: Use the convenient "Auto-Fill Demo Admin" or "Auto-Fill Demo Customer" buttons on the login modal for quick testing.*

---

## 📂 Project Structure

```text
doughnut/
├── index.html        # Complete self-contained single-page application
├── README.md         # Documentation & guide
└── .gitignore        # Git ignore rules
```

---

## 📄 License

MIT License. Open for educational and commercial bakery use!
