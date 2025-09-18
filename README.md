# Product Listing App (Flutter Skill Test)

This is a complete Flutter application built as part of a skill test. The app showcases a product listing platform with user authentication, a dynamic home screen, product searching, and wishlist functionality. The project is built following modern Flutter development practices, focusing on clean architecture and a great user experience.

## Features Implemented

-   **Splash Screen**: An animated entry screen that navigates based on the user's login status.
-   **User Authentication**:
    -   Phone number login with a real OTP provided by the API (Can Use Mock Pin as OTP).
    -   Correctly handles new user registration (prompting for a name) versus existing user login.
    -   Securely stores the JWT token on the device after login.
-   **Home Screen**:
    -   Dynamic banner slider fetched from an API.
    -   Displays separate, sorted lists for "Popular Products" and "Latest Products".
    -   Custom search bar that navigates to a dedicated search page.
    -   Floating bottom navigation bar for a modern look, with content scrolling behind it.
-   **Product Listings**:
    -   "All Products" page displaying a full grid of available items:.
    -   Product search page with real-time, debounced API calls to prevent excessive requests:.
-   **Wishlist Functionality**:
    -   Users can add or remove products from their wishlist from any product card.
    -   Real-time UI updates across the app when the wishlist changes.
    -   Dedicated wishlist screen to view all saved items.
-   **User Profile**:
    -   Authenticated screen to display the logged-in user's name and phone number fetched from the server using the JWT.
-   **UI/UX Enhancements**:
    -   **Skeleton Loading**: Shimmering placeholder UIs are used on all data-heavy screens for a better loading experience.
    -   **Animations**:
        -   The wishlist heart icon has a "pop" animation when tapped.
        -   Page transitions use smooth slide and fade animations for a polished feel.
        -   Product grids animate into view as they load.

## Architecture

The project is built using the **BLoC (Business Logic Component)** pattern to ensure a clean separation of concerns.

-   **Data Layer**: The **Repository Pattern** is used to abstract data sources. Repositories are responsible for communicating with the API (using the `dio` package) and parsing the JSON data into clean Dart models.
-   **Logic Layer**: BLoCs handle the application's state. They receive events from the UI, process them using the repositories, and emit new states for the UI to consume. **Cross-BLoC communication** is implemented for the wishlist feature to ensure a reactive UI across multiple screens.
-   **Presentation Layer**: The UI is built with Flutter widgets, which are responsible for displaying the state and sending events to the BLoCs. All UI widgets are stateless (or manage purely local UI state) and react to the state provided by `BlocBuilder` widgets.
-   **Navigation**: A centralized `AppRouter` class using `onGenerateRoute` manages all navigation and BLoC provision for different routes, ensuring a clean and scalable navigation structure.

## Setup and Installation

1.  **Clone the repository**:
    ```sh
    git clone https://github.com/Abhinand-s/product.git
    ```
2.  **Install dependencies**:
    ```sh
    flutter pub get
    ```
3.  **Run the app**:
    ```sh
    flutter run
    ```
4.  **Build a Release APK**:
    ```sh
    flutter build apk --release
    ```
    The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.
