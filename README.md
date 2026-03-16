# Grocery Stores Flutter Application

A Flutter application that displays a list of grocery stores with search, sort, and filter functionality. Built using Clean Architecture, BLoC/Cubit state management, and Dio for API connections.

## Features

- **Shop List Display**: View a list of grocery stores with detailed information
- **Search**: Debounced search by shop name or description
- **Sort**: Sort shops by ETA (ascending) or minimum order (ascending)
- **Filter**: Toggle between "Open only" and "All" shops
- **Error Handling**: Graceful handling of network failures with clear loading, error, and empty states
- **Pull to Refresh**: Refresh the shop list by pulling down

## Architecture

The application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core functionality shared across features
│   ├── constants/          # App-wide constants
│   ├── errors/             # Error handling and failures
│   ├── network/            # API client setup
│   ├── usecases/           # Base use case classes
│   └── injection/          # Dependency injection setup
│
└── features/
    └── shops/              # Shops feature module
        ├── data/           # Data layer
        │   ├── datasources/    # Remote data sources
        │   ├── models/         # Data models
        │   └── repositories/   # Repository implementations
        ├── domain/         # Domain layer (business logic)
        │   ├── entities/       # Business entities
        │   ├── repositories/   # Repository interfaces
        │   └── usecases/       # Use cases
        └── presentation/  # Presentation layer (UI)
            ├── cubit/          # State management (Cubit)
            ├── pages/          # Screen widgets
            └── widgets/        # Reusable UI components
```

### State Management

- **Cubit** from `flutter_bloc` package for state management
- Clear separation between UI, state, and data layers

### API Connection

- **Dio** for HTTP requests
- Centralized API client with interceptors
- Error handling with proper failure types

## Setup Instructions

### Prerequisites

- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd shops
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables (Required)**
   
   Create a `.env` file in the root directory with your secret key:
   ```bash
   SECRET_KEY=???
   ```
   
   **Alternative: Use --dart-define** (For CI/CD or when .env is not available)
   
   ```bash
   flutter run --dart-define=SECRET_KEY=??
   ```
   
   **Important**: 
   - The `.env` file is already in `.gitignore` to prevent committing sensitive keys
   - Never commit your `.env` file to version control
   - The app requires SECRET_KEY to be set either in `.env` file or via `--dart-define`

4. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

### Core Module

- **Constants**: API endpoints and app strings
- **Errors**: Failure classes for error handling
- **Network**: Dio client configuration
- **Use Cases**: Base use case interface
- **Injection**: Dependency injection using GetIt

### Shops Feature

#### Domain Layer
- `Shop` entity: Core business model
- `ShopsRepository` interface: Contract for data access
- `GetShops` use case: Business logic for fetching shops

#### Data Layer
- `ShopModel`: Data model extending Shop entity
- `ShopsRemoteDataSource`: API data source implementation
- `ShopsRepositoryImpl`: Repository implementation

#### Presentation Layer
- `ShopsCubit`: State management for shops feature
- `ShopsPage`: Main screen displaying shop list
- `ShopCard`: Individual shop card widget
- `SearchBarWidget`: Search input with debouncing
- `FilterSection`: Sort and filter controls

## API Details

- **Base URL**: `https://api.orianosy.com`
- **Endpoint**: `/shop/test/find/all/shop`
- **Authentication**: Secret key passed in headers as `secretKey`

## Features Implementation

### Search
- Debounced search (500ms delay) to reduce API calls
- Searches in both shop name and description
- Real-time filtering of displayed results

### Sort
- **None**: No sorting (default order)
- **ETA (Ascending)**: Sort by estimated delivery time
- **Minimum Order (Ascending)**: Sort by minimum order amount

### Filter
- **All**: Show all shops regardless of availability
- **Open Only**: Show only shops that are currently open

### Clear Filters
- Clear button appears when any filter is active
- Resets search, sort, and filter to default values

## Error Handling

The app handles various error states:

- **Loading State**: Shows a loading indicator while fetching data
- **Error State**: Displays error message with retry button
- **Empty State**: Shows "No results" message when filters return no shops
- **Network Errors**: Handled gracefully with user-friendly messages

## Dependencies

### Main Dependencies
- `flutter_bloc: ^8.1.6` - State management
- `dio: ^5.4.0` - HTTP client
- `equatable: ^2.0.5` - Value equality
- `dartz: ^0.10.1` - Functional programming (Either type)
- `flutter_dotenv: ^5.1.0` - Environment variables
- `cached_network_image: ^3.3.1` - Image caching
- `get_it: ^7.6.4` - Dependency injection

## Assumptions & Trade-offs

### Assumptions
1. The API returns shop data in a consistent format
2. Estimated delivery time is in minutes
3. Minimum order is a numeric value (double)
4. Cover photos are valid URLs
5. The secret key is required for all API requests

### Trade-offs
1. **No Local Caching**: Data is fetched fresh on each app launch. Could be improved with local storage (Hive/SharedPreferences)
2. **Simple Error Handling**: Basic error messages. Could be enhanced with more specific error types
3. **No Pagination**: All shops are loaded at once. For large datasets, pagination would be beneficial
4. **Debounce Timing**: 500ms debounce for search. Could be made configurable
5. **Image Loading**: Uses cached_network_image but no placeholder customization beyond default

## Building the APK

To build an APK for Android:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is created for interview/assessment purposes.

## Contact

For questions or issues, please open an issue in the repository.
