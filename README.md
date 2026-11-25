# Flutter Conf Latam Web

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Official website for Flutter Conf Latam - The premier Flutter conference in Latin America.

## Overview

Flutter Conf Latam Web is the public-facing website for the conference, built with Flutter Web. It provides information
about speakers, schedule, venue, sponsors, and ticket sales.

## Features

| Feature             | Description                                                                       |
|---------------------|-----------------------------------------------------------------------------------|
| **Home**            | Single-page layout: hero, features, novelties, timeline, and the sections below   |
| **Speakers**        | Browse speakers with detailed profiles and social links (own route: `/speakers`)  |
| **Schedule**        | Sessions/workshops/activities timeline — section inside Home, no standalone route |
| **Venue**           | Event location with maps, amenities, and travel tips — section inside Home        |
| **Pricing**         | Ticket tiers and pricing information — section inside Home                        |
| **Gallery**         | Photo gallery from previous events — section inside Home                          |
| **Organizers**      | Meet the team and allied communities — section inside Home                        |
| **Sponsorship**     | "Be a sponsor" page with packages/startup track (own route: `/be-sponsor`)        |
| **Contact**         | Contact form and social media links — section inside Home                         |
| **Privacy & Terms** | Legal documents (own routes: `/privacy-policy`, `/terms-conditions`)              |

> **Note:** only Home, Speakers, Sponsorship, Privacy Policy, and Terms & Conditions are real routes
> (`lib/core/routes/app_route_path.dart`). Schedule/Venue/Pricing/Gallery/Organizers/Contact are sections
> rendered inside the single Home page (`lib/features/home/presentation/widgets/`), not standalone features —
> there is no `lib/features/{schedule,venue,pricing,gallery,organizers,contact}/` folder.

## Prerequisites

- **Flutter SDK**: 3.44.0 or higher
- **Dart SDK**: 3.12.0 or higher
- **Firebase CLI**:
  ```bash
  npm install -g firebase-tools
  ```
- **Google Chrome**: to run in development mode

## Project Structure

```
lib/
├── app.dart
├── bootstrap.dart
├── core/
│   ├── config/                    # App configuration
│   ├── dependencies.dart          # Signal initialization
│   ├── enums/                     # Shared enumerations
│   ├── extensions/                # Dart extension methods
│   ├── models/                    # Shared data models
│   ├── providers/                 # Shared providers
│   ├── responsive/                # Responsive utilities
│   ├── routes/                    # Routing + SeoRouteObserver
│   ├── seo/                       # Meta tags, SEO config, structured data
│   ├── services/                  # Web local storage and other services
│   ├── social/                    # Social media models and providers
│   ├── utils/                     # Page preloader and utilities
│   └── widgets/                   # Reusable UI components
├── features/                      # Feature modules
│   ├── errors/
│   ├── home/                      # Single-page layout, hosts schedule/venue/pricing/gallery/organizers/contact
│   │   └── presentation/widgets/  # home_timeline, home_venue, home_pricing, home_gallery, home_organizers, etc.
│   ├── privacy_terms/
│   ├── speakers/
│   ├── splash/
│   └── sponsorship/                # "Be a sponsor" page (packages + startup track)
├── l10n/                          # Localization (en, es)
├── main.dart
└── styles/                        # Theme, colors, typography, generated assets
    ├── core/
    ├── generated/
    └── schemes/
```

## Initial Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd flutterconfweb
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

```bash
dart pub global activate flutterfire_cli

flutterfire configure \
  --project=<PROJECT_ID> \
  --out=lib/firebase_options.dart \
  --platforms=web
```

### 4. Configure environment variables

Create `keys.json` in the root directory:

```json
{
  "COUNTRY_PAGE_URL": "https://example.com/country-page",
  "TICKET_PAGE_URL": "https://example.com/tickets",
  "CFP_FORM_URL": "https://example.com/call-for-papers",
  "APP_STORE_URL": "https://apps.apple.com/app/your-app-id",
  "GOOGLE_APP_URL": "https://play.google.com/store/apps/details?id=your.package.name",
  "VENUE_MAP_URL": "https://maps.google.com/your-venue-location",
  "CONTACT_EMAIL": "contact@example.com",
  "FCL_PRIVACY_POLICY_URL": "https://example.com/privacy-policy",
  "FIREBASE_STORAGE_URL": "https://firebasestorage.googleapis.com/v0/b/your-project.appspot.com/o",
  "SPONSORSHIP_FILE_NAME": "Your Sponsorship Package",
  "SHOW_DISCLAIMER_DIALOG": false
}
```

### 5. Generate localization files

```bash
flutter gen-l10n
```

## Development

```bash
flutter run -d chrome --dart-define-from-file=keys.json
```

### With Firebase Emulators

```bash
# In flutter_conf_backend directory
firebase emulators:start

# Then run the app (auto-connects to emulators in debug mode)
flutter run -d chrome --dart-define-from-file=keys.json
```

## Build & Deploy

### Build

```bash
flutter build web --release --wasm --dart-define-from-file=keys.json
```

### Deploy to Firebase Hosting

```bash
firebase deploy --project <PROJECT_ID> --only hosting
```

## SEO & Performance

The site is optimized for SEO and performance. Key implementations:

### What's implemented

- **Static meta tags** in `index.html` — read by all crawlers before JS executes
- **Dynamic meta tags per route** — updated via `SeoRouteObserver` on navigation (read by Googlebot)
- **Open Graph + Twitter Cards** — social media previews
- **JSON-LD Structured Data** — Google rich snippets (event, organization, breadcrumbs)
- **Canonical URLs** — avoids duplicate content
- **Rive asset preloading** — critical animations cached before first use
- **Loading indicator** — spinner shown while Flutter engine loads

> **Note on crawlers:** Dynamic meta tags work for Googlebot (executes JS). Social crawlers (WhatsApp, LinkedIn,
> Twitter) only read static tags from `index.html` — both layers are configured.

### Configure SEO URLs

Edit `lib/core/seo/seo_config.dart`:

```dart

static const String baseUrl = 'https://flutterconflatam.dev';
static const String defaultImageUrl = 'https://flutterconflatam.dev/icons/Icon-512.png';
```

### Add SEO for a new route

Add to the `routes` map in `lib/core/seo/seo_config.dart`:

```dart

final map = <String, dynamic>{
  '/nueva-ruta': SeoConfig(
    title: 'Nueva Ruta - Flutter Conf Latam',
    description: 'Descripción para Google y redes sociales',
    keywords: ['flutter', 'conferencia'],
    imageUrl: defaultImageUrl,
  ),
};
```

`SeoRouteObserver` applies it automatically on navigation.

### Add custom Structured Data

In `lib/core/routes/helpers/seo_route_observer.dart`, method `_addStructuredDataForRoute`:

```dart
/*
case '/faq':
  MetaTagsManager.addStructuredData(
    StructuredDataBuilder.buildFaqData([
      FaqItem(question: '¿Cuándo es el evento?', answer: '22-24 Sept 2026'),
    ]),
  );
*/
```

### Verify SEO

```bash
# Check meta tags update on navigation
flutter run -d chrome --dart-define-from-file=keys.json
# DevTools → Elements → <head> — og:title, twitter:card, application/ld+json

# Lighthouse (run on release build)
python3 -m http.server 8080 --directory build/web
# DevTools → Lighthouse → Navigation → Performance + SEO
# Expected: SEO ~95, Performance ~85

# Structured data
# https://search.google.com/test/rich-results
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    flutter_conf_latam (web)                     │
│                      (Presentation Layer)                       │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    flutter_conf_backend                         │
│              (Firebase Data Source Implementations)             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    flutter_conf_core                            │
│          (Domain Layer - Interfaces, Entities, Repositories)    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    flutter_conf_common                          │
│              (Result type, Exceptions, Utilities)               │
└─────────────────────────────────────────────────────────────────┘
```

## Main Dependencies

| Package                       | Purpose                       |
|-------------------------------|-------------------------------|
| `signals`                     | Reactive state management     |
| `go_router`                   | Navigation and routing        |
| `flutter_conf_core`           | Domain layer and repositories |
| `flutter_conf_backend`        | Firebase implementations      |
| `flutter_conf_common`         | Shared utilities              |
| `firebase_core`               | Firebase initialization       |
| `flutter_hooks`               | Hook-based widget utilities   |
| `cached_network_image`        | Network image caching         |
| `flutter_animate`             | Animations                    |
| `flutter_layout_grid`         | CSS Grid-style layouts        |
| `flutter_staggered_grid_view` | Staggered grid layouts        |
| `flutter_svg`                 | SVG asset rendering           |
| `google_fonts`                | Google Fonts integration      |
| `rive`                        | Interactive animations        |
| `markdown_widget`             | Markdown rendering            |
| `shared_preferences`          | Local storage for preferences |
| `url_launcher`                | Open URLs in browser          |
| `timezone`                    | Timezone-aware date/time      |
| `web`                         | Web platform APIs (WASM-safe) |
| `vector_graphics`             | Optimized vector rendering    |

## Localization

Supports English (`en`) and Spanish (`es`). Translation files in `lib/l10n/arb/`.

```bash
# Regenerate after editing .arb files
flutter gen-l10n
```

## Related Packages

| Package                                                                      | Description                                       |
|------------------------------------------------------------------------------|---------------------------------------------------|
| [`flutter_conf_common`](https://github.com/flutter-es/flutter_conf_common)   | Core utilities, Result type, exceptions           |
| [`flutter_conf_core`](https://github.com/flutter-es/flutter_conf_core)       | Domain layer - Interfaces, entities, repositories |
| [`flutter_conf_backend`](https://github.com/flutter-es/flutter_conf_backend) | Firebase implementations                          |

## Troubleshooting

### Flutter SDK not found

```bash
flutter doctor
```

### l10n errors

```bash
flutter gen-l10n
```

### Firebase issues

```bash
flutterfire configure
```

### keys.json not found

Create the file as described in [Configure environment variables](#4-configure-environment-variables).

### Meta tags not updating on navigation

Verify `SeoRouteObserver` is in the router (`lib/core/routes/app_routes.dart`):

```dart

final route = GoRouter(
  observers: [SeoRouteObserver()],
  // ...
);
```

## Contributing

1. Create a branch from `develop`
2. Make your changes
3. Run `flutter analyze`
4. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg

[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
