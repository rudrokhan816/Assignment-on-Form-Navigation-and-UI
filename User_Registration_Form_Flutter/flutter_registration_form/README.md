# User Registration Form — Flutter + Dart

A modular registration-form project designed for a class assignment. It includes:
- Personal information: full name, email, phone, age, and NID
- Password and confirm-password fields
- Password strength indicator and custom validation
- Searchable country selector
- Gender radio buttons
- Interests checkboxes
- Date-of-birth picker
- Centralized validation in `Validators`
- Success screen showing a registration summary (demo only; no data is uploaded)

## Project structure

```text
lib/
  main.dart
  models/
    registration_data.dart
  screens/
    registration_screen.dart
    success_screen.dart
  validators/
    validators.dart
  widgets/
    app_section_card.dart
    personal_information_section.dart
    password_section.dart
    country_dropdown_field.dart
    gender_section.dart
    interests_section.dart
    birth_date_field.dart
    form_text_field.dart
```

Each section is a separate widget/file so you can find and customize it easily.

## Run the project

1. Install Flutter and confirm setup with `flutter doctor`.
2. Open a terminal in this project folder.
3. Run:
   ```bash
   flutter pub get
   flutter run
   ```
4. For a release APK:
   ```bash
   flutter build apk --release
   ```
   The APK will be created under `build/app/outputs/flutter-apk/app-release.apk`.

## Important notes

- This source bundle contains the Dart app source and project configuration. To generate Android/iOS platform folders, run `flutter create .` from this directory with Flutter installed.
- The form validates data locally. It does not create an account, save data to a server, or transmit personal information.
- NID validation is intentionally general (8–20 digits) because national ID formats vary by country. Adjust `Validators.nid` if your instructor specifies a particular format.
- Age is checked against the selected date of birth, so the age and date fields must agree.
