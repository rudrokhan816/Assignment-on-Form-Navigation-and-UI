class Validators {
  static String? requiredText(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  static String? email(String? value) {
    final required = requiredText(value, label: 'Email');
    if (required != null) return required;
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!pattern.hasMatch(value!.trim())) return 'Enter a valid email address.';
    return null;
  }

  static String? phone(String? value) {
    final required = requiredText(value, label: 'Phone number');
    if (required != null) return required;
    final digits = value!.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 7 || digits.length > 15) {
      return 'Enter a phone number with 7–15 digits.';
    }
    return null;
  }
}
