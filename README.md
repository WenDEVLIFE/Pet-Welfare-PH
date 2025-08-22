# Pet-Welfare-PH 🐾

A comprehensive Flutter mobile application designed to support pet welfare services in the Philippines. This platform connects pet owners, animal welfare organizations, shelters, vet clinics, and pet service providers to create a thriving community focused on animal care and welfare.

## 📱 Features

### Core Functionality
- **🏠 Pet Adoption System** - Connect pets with loving families through a streamlined adoption process
- **🆘 Pet Rescue Coordination** - Organize and manage rescue operations for animals in need
- **💝 Donation Platform** - Facilitate financial support for pet welfare causes and organizations
- **👥 Community Engagement** - Share stories, experiences, and build connections within the pet community
- **📍 Location-Based Services** - Find nearby shelters, vet clinics, and pet services
- **💬 Real-time Messaging** - Direct communication between users, adopters, and service providers
- **📢 Notifications** - Stay updated on adoption applications, rescue alerts, and community activities

### User Types
- **Pet Owners** - Individuals looking to adopt, rehome, or seek services for their pets
- **Animal Shelters** - Organizations managing pet adoption and rescue operations
- **Veterinary Clinics** - Medical service providers for pet healthcare
- **Legal Firms** - Legal support for animal welfare cases
- **Administrators** - Platform moderators ensuring community safety and compliance

### Pet Services Categories
- **Pet Adoption** - Browse and apply for pet adoption
- **Missing & Found Pets** - Report and search for lost pets
- **Pet Rescue** - Emergency rescue coordination
- **Call for Aid** - Community support requests
- **Pet Appreciation** - Share positive pet stories and experiences
- **Pet Care Insights** - Educational content and care tips
- **Community Posts** - General pet-related discussions and updates

## 🏗️ Technical Architecture

### Technology Stack
- **Frontend**: Flutter (Dart) - Cross-platform mobile development
- **Backend**: Firebase Ecosystem
  - Firestore - Real-time NoSQL database
  - Firebase Auth - User authentication and authorization
  - Firebase Storage - File and image storage
  - Firebase Cloud Functions - Server-side logic
  - Firebase Messaging - Push notifications
- **Maps**: MapLibre with OpenStreetMap integration
- **State Management**: Provider pattern with ViewModels
- **External APIs**: Yahoo Services, MapTiler, Pet API

### Architecture Patterns
- **Repository Pattern** - Data access abstraction layer
- **MVVM (Model-View-ViewModel)** - UI and business logic separation
- **Provider State Management** - Reactive state updates
- **Service Locator** - Dependency injection for services

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0 <4.0.0)
- Dart SDK
- Android Studio / Xcode (for device builds)
- Firebase CLI (for backend deployment)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/Pet-Welfare-PH.git
   cd Pet-Welfare-PH
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create an `env` file in the root directory
   - Add your API keys and configuration:
   ```
   YAHOO_API_KEY=your_yahoo_api_key
   MAPTILER_API_KEY=your_maptiler_api_key
   PET_API_KEY=your_pet_api_key
   ```

4. **Configure Firebase**
   - Place your `google-services.json` (Android) in `android/app/`
   - Place your `GoogleService-Info.plist` (iOS) in `ios/Runner/`
   - Ensure `serviceaccount.json` is in `assets/key/`

5. **Run the application**
   ```bash
   flutter run
   ```

### Firebase Functions Setup

1. **Navigate to functions directory**
   ```bash
   cd functions
   ```

2. **Install Node.js dependencies**
   ```bash
   npm install
   ```

3. **Deploy functions (optional)**
   ```bash
   firebase deploy --only functions
   ```

## 📂 Project Structure

```
lib/src/
├── Animation/          # UI animation components
├── DialogView/         # Custom dialog widgets
├── State/             # State management utilities
├── exceptions/        # Error handling
├── modal/            # Modal dialogs and popups
├── model/            # Data models
├── repository/       # Data access layer
├── services/         # External API integrations
├── utils/            # Utility classes
├── view/             # UI screens and layouts
├── view_model/       # Business logic ViewModels
└── widgets/          # Reusable UI components

assets/
├── fonts/            # Custom fonts
├── icon/             # App icons
├── images/           # Static images
├── key/              # Service account keys
├── video/            # Video assets
└── word/             # Legal documents and texts

functions/            # Firebase Cloud Functions
android/              # Android platform configuration
ios/                  # iOS platform configuration
```

## 🛠️ Development

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d <device-id>
```

### Building for Production

```bash
# Android APK
flutter build apk

# Android App Bundle (recommended for Play Store)
flutter build appbundle

# iOS (requires macOS and Xcode)
flutter build ios
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format .
```

## 🔧 Configuration

### Environment Variables
The app uses environment variables stored in the `env` file:
- API keys for external services
- Configuration flags
- Service endpoints

### Firebase Configuration
- Authentication providers setup
- Firestore security rules
- Storage bucket permissions
- Cloud Functions deployment

### Maps Configuration
- MapTiler API integration
- OpenStreetMap services
- Location services setup

## 📱 User Roles & Permissions

### Pet Owner (Fur Parent)
- Browse and apply for pet adoption
- Post missing/found pet reports
- Request rescue assistance
- Participate in community discussions

### Shelter/Rescue Organization
- Manage pet adoption listings
- Coordinate rescue operations
- Receive and process adoption applications
- Maintain organization profile

### Veterinary Clinic
- Maintain service listings
- Provide pet care insights
- Connect with pet owners
- Manage clinic information

### Legal Firm
- Provide legal assistance for animal welfare cases
- Maintain legal service listings
- Connect with users needing legal support

### Administrator
- Moderate platform content
- Manage user accounts and permissions
- Monitor platform activity
- Generate reports and analytics

## 🔐 Security

- **Firebase Authentication** - Secure user login and registration
- **ID Verification** - Document upload and verification system
- **Role-based Access Control** - Feature access based on user roles
- **Data Encryption** - Sensitive data protection
- **Input Validation** - Form data sanitization
- **Report System** - Community-driven content moderation

## 🌟 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Write comprehensive tests for new features
- Update documentation for API changes
- Ensure responsive design for various screen sizes
- Test on both Android and iOS platforms

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email support@petwelfareph.com or create an issue in this repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for robust backend services
- OpenStreetMap community for mapping data
- All contributors and beta testers
- Animal welfare organizations for their continuous support

## 📊 Project Status

- ✅ Core adoption system
- ✅ User authentication and roles
- ✅ Real-time messaging
- ✅ Location-based services
- ✅ Community features
- 🚧 Advanced analytics dashboard
- 🚧 Enhanced notification system
- 📋 Multi-language support (planned)

---

**Made with ❤️ for animal welfare in the Philippines**
