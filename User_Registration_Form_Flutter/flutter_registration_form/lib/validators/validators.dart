/// All form validation rules live here so they are easy to find and edit.
class Validators {
  Validators._();

  static String? requiredText(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  static String? fullName(String? value) {
    final requiredError = requiredText(value, label: 'Full name');
    if (requiredError != null) return requiredError;

    final name = value!.trim();
    if (name.length < 2) return 'Name must be at least 2 characters.';
    if (name.length > 60) return 'Name must be 60 characters or fewer.';
    if (!RegExp(r"^[A-Za-z][A-Za-z\s'.-]*$").hasMatch(name)) {
      return 'Use letters, spaces, apostrophes, dots, or hyphens only.';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredText(value, label: 'Email');
    if (requiredError != null) return requiredError;

    final email = value!.trim();
    final pattern = RegExp(
      r'^[A-Za-z0-9.!#$%&’*+/=?^_`{|}~-]+@[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?)+$',
    );
    if (!pattern.hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  static String? phone(String? value) {
    final requiredError = requiredText(value, label: 'Phone number');
    if (requiredError != null) return requiredError;

    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Phone number must contain 7–15 digits.';
    }
    if (!RegExp(r'^[+()\-\s\d]+$').hasMatch(value.trim())) {
      return 'Use digits, spaces, +, parentheses, or hyphens only.';
    }
    return null;
  }

  static String? age(String? value, {DateTime? birthDate}) {
    final requiredError = requiredText(value, label: 'Age');
    if (requiredError != null) return requiredError;

    final parsedAge = int.tryParse(value!.trim());
    if (parsedAge == null) return 'Age must be a whole number.';
    if (parsedAge < 1 || parsedAge > 120) {
      return 'Enter an age between 1 and 120.';
    }
    if (birthDate != null) {
      final calculated = calculateAge(birthDate, DateTime.now());
      if (parsedAge != calculated) {
        return 'Age does not match the selected date of birth ($calculated).';
      }
    }
    return null;
  }

  static int calculateAge(DateTime birthDate, DateTime today) {
    var result = today.year - birthDate.year;
    final birthdayHasNotOccurred = today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day);
    if (birthdayHasNotOccurred) result--;
    return result;
  }

  static String? nid(String? value) {
    final requiredError = requiredText(value, label: 'NID');
    if (requiredError != null) return requiredError;

    final nid = value!.trim();
    if (!RegExp(r'^\d{8,20}$').hasMatch(nid)) {
      return 'NID must contain 8–20 digits.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 8) return 'Use at least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter (A–Z).';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least one lowercase letter (a–z).';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Include at least one number (0–9).';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]').hasMatch(value)) {
      return 'Include at least one special character.';
    }
    if (RegExp(r'\s').hasMatch(value)) {
      return 'Password cannot contain spaces.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != originalPassword) return 'Passwords do not match.';
    return null;
  }

  static String? country(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please select a country.';
    return null;
  }

  static String? gender(String? value) {
    if (value == null || value.isEmpty) return 'Please select a gender.';
    return null;
  }

  static String? interests(List<String> values) {
    if (values.isEmpty) return 'Select at least one interest.';
    return null;
  }

  static String? birthDate(DateTime? value) {
    if (value == null) return 'Please select your date of birth.';
    if (value.isAfter(DateTime.now())) return 'Birth date cannot be in the future.';
    if (calculateAge(value, DateTime.now()) > 120) {
      return 'Please enter a valid birth date.';
    }
    return null;
  }
}
