# ✦ PharaTrip — Travel, Reimagined

<p align="center">
  <img src="assets/images/phara_trip_splash.png" alt="PharaTrip" width="180" />
</p>

<h3 align="center">A premium Flutter travel experience inspired by Egypt.</h3>

<p align="center">
  Discover iconic destinations, curate unforgettable trips, and book every detail from one elegant travel companion.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-0EA5C6?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-163D3A?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/License-Private-C99A3D?style=for-the-badge" alt="Private project" />
</p>

---

## The idea

**PharaTrip** turns travel planning into a polished, story-driven experience. From the first glimpse of the pyramids to the final booking confirmation, every screen is designed to feel warm, effortless, and distinctly Egyptian.

> **Travel beautifully. Explore deeply. Book confidently.**

## ✨ What is inside

- **Curated destinations** — Explore Egypt through destinations such as Cairo, Dahab, Siwa, Luxor, Hurghada, and the Red Sea.
- **Personalized onboarding** — A visual introduction designed around Egypt’s heritage, culture, and landscapes.
- **Secure authentication flow** — Sign up, phone verification, password reset, and secure local storage.
- **Trip discovery** — Browse available trips and view rich trip details before booking.
- **Seat selection** — Choose seats through an intuitive visual layout.
- **Booking journey** — A smooth confirmation flow from trip selection to successful reservation.
- **My Trips** — Keep upcoming and previous adventures close at hand.
- **Favorites** — Save the experiences worth coming back to.
- **Live trip tracking** — Follow trip progress with an interactive map experience.
- **Travel concierge** — Contact support directly through the in-app chat.
- **Localization-ready UI** — Built with a translation-friendly architecture for a global audience.
- **Responsive experience** — Designed to adapt across mobile, tablet, desktop, and web layouts.

## 🎨 Design language

PharaTrip combines **deep teal**, **sandstone neutrals**, and **golden accents** with cinematic Egyptian imagery. The result is a visual identity that feels premium without losing the warmth of the destination.

## 🧰 Built with

| Layer | Technology |
| --- | --- |
| Framework | Flutter |
| Language | Dart |
| State management | Riverpod |
| Navigation | GoRouter |
| Maps | Flutter Map + LatLong2 |
| Authentication & local data | Flutter Secure Storage + Shared Preferences |
| Typography | Google Fonts |
| Media | Image Picker + Flutter SVG |
| Translation | Google ML Kit Translation |
| Quality | Flutter Lints |

## 🚀 Run locally

### Requirements

- Flutter SDK with Dart 3.13.7 or newer
- Android Studio or Xcode for native builds
- A connected device, emulator, or Chrome

### Setup

```bash
git clone https://github.com/MahmoudAlazazy/Book-Trip.git
cd Book-Trip
flutter pub get
flutter run
```

### Run for web

```bash
flutter config --enable-web
flutter run -d chrome
```

### Build a release

```bash
flutter build web --release
flutter build apk --release
```

## 🗺️ Project architecture

```text
lib/
├── core/                 # Theme, routing, localization, shared widgets
├── features/
│   ├── auth/             # Sign in, sign up, verification, reset password
│   ├── booking/          # Booking, seats, transport, confirmation
│   ├── favorites/        # Saved destinations and trips
│   ├── home/             # Discovery and featured experiences
│   ├── my_trips/         # Upcoming and past trips
│   ├── notifications/    # Travel updates and alerts
│   ├── profile/          # Profile, support, privacy, and settings
│   ├── tracking/         # Trip tracking and maps
│   └── trips/             # Trip details and available trips
└── main.dart             # Application entry point
```

## 🌐 Deployment

The project includes a GitHub Actions workflow for Flutter Web deployment through GitHub Pages:

```text
.github/workflows/deploy.yml
```

Push to the `main` branch after enabling **GitHub Pages → GitHub Actions** in the repository settings.

## 🔐 Project status

PharaTrip is an evolving travel-booking experience. The current foundation includes the core browsing, booking, profile, favorites, tracking, and support journeys, with room to connect production APIs and payment services.

## 🤝 Contributing

This is currently a private product project. For collaboration or product inquiries, open an issue or contact the project owner.

## Made for journeys that deserve a story

Built with Flutter and a little Egyptian sunshine. ☀️

