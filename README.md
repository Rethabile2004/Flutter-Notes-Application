
# Notes App – Secure, Real-time, Cross-Platform Notes with Flutter + Firebase

A beautiful, fast, and secure notes application built with **Flutter** and **Firebase**.  
Supports Android, iOS, and Web from a single codebase. Users can sign up, log in, and manage their personal notes with real-time sync — all data is private and tied to their account.

https://github.com/user-attachments/assets/fee1f948-d09b-4756-ae5e-ffba109d092a
https://github.com/user-attachments/assets/118b758d-4f25-44a4-98ad-c9cb8716ffbc
https://github.com/user-attachments/assets/0ad2cbdc-d89f-49ef-8bad-7471132c1bdf
https://github.com/user-attachments/assets/aef48eec-5557-4692-8bbe-17c4f2ce6df0

## Features

- Secure authentication (Email/Password) via Firebase Auth  
- Real-time sync with Firestore – notes update instantly across devices  
- Full CRUD: Create, Read, Update, Delete notes  
- Truly cross-platform: Android · iOS · Web  
- Clean Material 3 design with dark mode support  
- Private notes – only the owner can access their data  
- Offline support (Firestore cache)  
- Auto-save while typing  

## Tech Stack

| Technology              | Purpose                              |
|-------------------------|--------------------------------------|
| Flutter 3.x             | UI & Cross-platform framework        |
| Dart                    | Language                             |
| Firebase Authentication | User auth (email/password)           |
| Firebase Firestore      | Real-time NoSQL database             |
| Firebase Config         | Remote config & feature flags (optional) |
| Provider / Riverpod     | State management (depending on your choice) |

## Prerequisites

- Flutter ≥ 3.16.0 (recommended: latest stable)
- Dart SDK (comes with Flutter)
- Firebase project (free tier is enough)
- Git

## Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/Rethabile2004/notes-app.git
cd notes-app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Set up Firebase

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Create a new project (or use existing)
3. Add apps:
   - Android (package name usually `com.example.notes_app`)
   - iOS (if targeting iOS)
   - Web
4. Download:
   - `google-services.json` → place in `android/app/`
   - `GoogleService-Info.plist` → place in `ios/Runner/` (if iOS)
   - Web config → paste into `lib/firebase_options.dart` (or follow flutterfire setup)
5. Enable in Firebase Console:
   - Authentication → Sign-in method → Email/Password
   - Firestore Database → Create database in production mode → start in your region

### 4. (Recommended) Use FlutterFire CLI for zero-config setup
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
This auto-generates `firebase_options.dart` for all platforms.

### 5. Run the app
```bash
flutter run
```
Or pick your target:
```bash
flutter run -d chrome    # Web
flutter run -d android   # Android emulator/device
```

## Project Structure (Key Folders)

```
lib/
├── main.dart              # Entry point
├── src/
│   ├── screens/           # All pages (login, home, note editor)
│   ├── widgets/           # Reusable components
│   ├── services/          # Firebase auth & firestore logic
│   ├── models/            # Note model
│   └── utils/             # Helpers & constants
```

## Common Issues & Fixes

| Issue                              | Fix                                                                 |
|------------------------------------|---------------------------------------------------------------------|
| `google-services.json` missing     | Add it to `android/app/`                                            |
| Web not loading Firebase           | Run `flutterfire configure` again                                   |
| "No Firebase App initialized"      | Make sure `Firebase.initializeApp()` is called in `main.dart`       |
| Rules too open                     | Use these secure Firestore rules (already in repo or add them):        |

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Contributing

Pull requests are welcome! For major changes, please open an issue first.

## License

[MIT License](LICENSE) – feel free to use this for learning or as a starter template.

---

Made with by [@Rethabile2004](https://github.com/Rethabile2004)

⭐ Star this repo if it helped you!
```
