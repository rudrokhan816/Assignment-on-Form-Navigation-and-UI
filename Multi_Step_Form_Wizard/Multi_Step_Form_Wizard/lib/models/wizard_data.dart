class WizardData {
  String fullName;
  String dateOfBirth;
  String gender;
  String email;
  String phone;
  String address;
  String country;
  List<String> interests;
  bool emailUpdates;
  bool pushNotifications;
  String themePreference;

  WizardData({
    this.fullName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.country = '',
    List<String>? interests,
    this.emailUpdates = true,
    this.pushNotifications = false,
    this.themePreference = 'System default',
  }) : interests = interests ?? <String>[];

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'email': email,
        'phone': phone,
        'address': address,
        'country': country,
        'interests': interests,
        'emailUpdates': emailUpdates,
        'pushNotifications': pushNotifications,
        'themePreference': themePreference,
      };

  factory WizardData.fromJson(Map<String, dynamic> json) => WizardData(
        fullName: json['fullName'] as String? ?? '',
        dateOfBirth: json['dateOfBirth'] as String? ?? '',
        gender: json['gender'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        address: json['address'] as String? ?? '',
        country: json['country'] as String? ?? '',
        interests: (json['interests'] as List<dynamic>? ?? const [])
            .whereType<String>()
            .toList(),
        emailUpdates: json['emailUpdates'] as bool? ?? true,
        pushNotifications: json['pushNotifications'] as bool? ?? false,
        themePreference: json['themePreference'] as String? ?? 'System default',
      );
}
