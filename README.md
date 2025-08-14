**Flutter Bay - Product Explorer App**
A visually appealing and responsive Flutter app to explore products from a public API.

# **Getting Started 🚀**

This project contains 3 flavors:

* development
* staging
* production

To run the desired flavor, use the following commands:
## Development
$ flutter run --flavor development --target lib/main_development.dart

## Staging
$ flutter run --flavor staging --target lib/main_staging.dart

## Production
$ flutter run --flavor production --target lib/main_production.dart

# **Prerequisites**

Flutter SDK installed
Android/iOS emulator or physical device
API endpoint (e.g., Fake Store API or DummyJSON)

# **Setup Instructions**

Clone the repository: git clone https://github.com/CleopasMwape/flutter_bay
Navigate to the project directory: cd flutter_bay
Install dependencies: flutter pub get
Run the app using the desired flavor (see commands above).

*Flutter Bay works on iOS, Android, Web, and Windows.

# **State Management**

The app follows the MVVM (Model-View-ViewModel) architecture with Bloc as the state management pattern. This ensures a clear separation of business logic and UI, leveraging Bloc for reactive state management and predictable state transitions.

# **Features**

## **Core Features**

1. Fetch product list from a mock API (https://fakestoreapi.com/).
2. Display product cards with image, name, price, and rating.
3. Navigate to a product detail page on card click.
4. Include loading animations, pull-to-refresh, and error/empty states.
5. Use Hero animation for smooth transitions.
6. Ensure responsive navigation with feedback.

## Bonus Features

Offline caching using Hive.
Infinite scroll for product list.
Support for dark mode theming.
Filtering by category.


# Running Tests 🧪

To run all unit and widget tests:
sh$ very_good test --coverage --test-randomize-ordering-seed random
View the coverage report using lcov:
sh# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/



# Project Structure

The project is structured as shown in the attached screenshot, with key directories:

* lib/app: Core app logic and configuration.
* lib/core: Shared utilities and services.
* lib/data: Data models and repositories.
* lib/models: Data models for products.
* lib/repositories: Data layer with API and caching logic.
* lib/services: API and Hive services.
* lib/ui: UI components and screens (e.g., product list, details) Bloc implementations for state 
* management for each feature.


## App Demo

[![App Demo Video]](https://youtu.be/3s52513uhl8)

<!-- Or with more descriptive text -->
[![Watch the demo](https://img.shields.io/badge/📹-Watch%20Demo-red?style=for-the-badge)](https://youtu.be/3s52513uhl8)