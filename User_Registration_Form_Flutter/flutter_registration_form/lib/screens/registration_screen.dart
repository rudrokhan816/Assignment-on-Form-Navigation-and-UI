import 'package:flutter/material.dart';
import '../models/registration_data.dart';
import '../validators/validators.dart';
import '../widgets/birth_date_field.dart';
import '../widgets/country_dropdown_field.dart';
import '../widgets/gender_section.dart';
import '../widgets/interests_section.dart';
import '../widgets/password_section.dart';
import '../widgets/personal_information_section.dart';
import 'success_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _nidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _country;
  String? _gender;
  DateTime? _birthDate;
  Set<String> _interests = {};
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _nidController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<DateTime?> _selectBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'SELECT YOUR DATE OF BIRTH',
    );
    if (picked == null) return null;

    setState(() {
      _birthDate = picked;
      _ageController.text = Validators.calculateAge(picked, DateTime.now()).toString();
    });
    return picked;
  }

  void _submitForm() {
    setState(() => _submitted = true);
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the highlighted fields and try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth.')),
      );
      return;
    }

    final data = RegistrationData(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      nid: _nidController.text.trim(),
      country: _country!,
      gender: _gender!,
      interests: _interests.toList()..sort(),
      birthDate: _birthDate!,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SuccessScreen(data: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF777BFF), Color(0xFF4C50D9)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.7,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Fill in the details below to get started.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    PersonalInformationSection(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      ageController: _ageController,
                      nidController: _nidController,
                      birthDate: _birthDate,
                      onBirthDateTap: _selectBirthDate,
                    ),
                    const SizedBox(height: 16),
                    PasswordSection(
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onPasswordChanged: (_) {
                        // Rebuild the form so confirm-password and strength state stay current.
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    CountryDropdownField(
                      selectedCountry: _country,
                      onChanged: (country) => setState(() => _country = country),
                    ),
                    const SizedBox(height: 16),
                    GenderSection(
                      value: _gender,
                      onChanged: (gender) => setState(() => _gender = gender),
                    ),
                    const SizedBox(height: 16),
                    InterestsSection(
                      selectedInterests: _interests,
                      onChanged: (interests) => setState(() => _interests = interests),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _submitForm,
                        icon: const Icon(Icons.check_circle_outline_rounded),
                        label: const Text(
                          'Create account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'Your information stays on this demo device.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
