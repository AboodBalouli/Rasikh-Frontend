<p align="center">
  <img src="assets/images/logobg.png" alt="Rasikh Logo" width="160"/>
</p>

<h1 align="center">راسخ — Rasikh</h1>

<p align="center">
  A mobile marketplace for handmade goods, homemade food, and community organizations — connecting local sellers with customers across Jordan.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/State-Riverpod-6C63FF" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License"/>
</p>

---

##  Screenshots

<p align="center">
  <img src="assets/images/screenshots/landing.png" alt="Landing Page" width="250"/>
  &nbsp;&nbsp;
  <img src="assets/images/screenshots/home.png" alt="Home Page" width="250"/>
  &nbsp;&nbsp;
  <img src="assets/images/screenshots/guest_profile.png" alt="Guest Profile" width="250"/>
</p>

> *Landing page · Home page · Guest profile*

---

## Features

- **User Authentication** — Register, login, password recovery with OTP verification
- **Store Browsing** — Explore handmade crafts and homemade food stores by category
- **Product Search & Details** — Full product pages with image carousels and wishlists
- **Shopping Cart & Checkout** — Add to cart, adjust quantities, and place orders with multiple payment methods
- **Rasikh Wallet** — In-app wallet for quick payments
- **Custom Orders** — Request personalized items directly from sellers with image attachments
- **Public Orders** — Post open requests for any seller to fulfill
- **Organization Stores** — Browse and buy from community organizations / associations
- **Seller Dashboard** — Sellers can create stores, manage products, and handle incoming orders
- **AI Chatbot** — Integrated AI assistant for product help and recommendations
- **AI Image Generation** — Generate product images using AI
- **Order History & Ratings** — Track past orders and rate sellers
- **Bilingual UI** — Full Arabic (RTL) and English support with runtime switching
- **Seasonal Events** — Discover stores and promotions tied to seasons and events
- **Responsive Design** — Works on Android, iOS, and Web

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.x (Dart 3.x) |
| **State Management** | Riverpod + Provider |
| **Routing** | GoRouter |
| **HTTP Client** | `http` package |
| **Local Storage** | Flutter Secure Storage, SharedPreferences |
| **UI Extras** | Google Fonts, Carousel Slider, Dash Chat 2 |
| **Image Handling** | Image Picker, Image Cropper, Palette Generator |
| **Backend** | Spring Boot REST API *(separate repo)* |

---

## Architecture

The project follows a **feature-based clean architecture** pattern:

```
lib/
├── app/                    # App entry, router, DI, global providers
├── core/                   # Shared constants, theme, entities, network, utils
└── features/               # Feature modules (28 total)
    ├── auth/               # Authentication (login, register)
    ├── home/               # Main home page
    ├── shop_page/          # Store browsing & product details
    ├── cart/               # Shopping cart
    ├── orders/             # Checkout, order history, ratings
    ├── custom_orders/      # Custom order flow (buyer & seller)
    ├── public_orders/      # Public order board
    ├── organization/       # Organization stores & admin
    ├── wallet/             # In-app wallet
    ├── ai_chat/            # AI chatbot
    ├── image_generate/     # AI image generation
    ├── events/             # Seasonal events
    └── ...                 # + 16 more feature modules
```

Each feature follows the **data → domain → presentation** layer structure.

---

## How to Run

### Prerequisites

- Flutter SDK `>=3.9.2`
- A running instance of the backend API (Spring Boot)

### Setup

```bash
# Clone the repo
git clone https://github.com/AboodBaloworkeduli/Rasikh-Frontend.git
cd Rasikh-Frontend

# Install dependencies
flutter pub get

# Run on your device/emulator (defaults to localhost:8080)
flutter run

# Or point to a custom backend
flutter run --dart-define=API_BASE_URL=http://<your-ip>:8080
```

> **Note:** On Android emulator, the app automatically uses `10.0.2.2` to reach the host machine.

---

## 🔗 Backend

The backend for this project is a **Spring Boot** REST API (separate repository).

> *Link will be added once the backend repo is published.*

---

## Project Status

**Graduation Project — Completed**

This is a university graduation project built as a full-stack mobile marketplace application.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
