class RegistrationData {
  const RegistrationData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.age,
    required this.nid,
    required this.country,
    required this.gender,
    required this.interests,
    required this.birthDate,
  });

  final String fullName;
  final String email;
  final String phone;
  final int age;
  final String nid;
  final String country;
  final String gender;
  final List<String> interests;
  final DateTime birthDate;
}
