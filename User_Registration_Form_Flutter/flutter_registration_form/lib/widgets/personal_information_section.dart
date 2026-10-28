import 'package:flutter/material.dart';
import '../validators/validators.dart';
import 'app_section_card.dart';
import 'form_text_field.dart';

class PersonalInformationSection extends StatelessWidget {
  const PersonalInformationSection({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.ageController,
    required this.nidController,
    required this.birthDate,
    required this.onBirthDateTap,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController nidController;
  final DateTime? birthDate;
  final Future<DateTime?> Function() onBirthDateTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Personal information',
      subtitle: 'Tell us a little about yourself',
      icon: Icons.person_outline_rounded,
      child: Column(
        children: [
          FormTextField(
            controller: nameController,
            label: 'Full name',
            hint: 'e.g. Alex Morgan',
            icon: Icons.badge_outlined,
            textCapitalization: TextCapitalization.words,
            validator: Validators.fullName,
          ),
          const SizedBox(height: 15),
          FormTextField(
            controller: emailController,
            label: 'Email address',
            hint: 'you@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 15),
          FormTextField(
            controller: phoneController,
            label: 'Phone number',
            hint: '+880 1XXXXXXXXX',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: FormTextField(
                  controller: ageController,
                  label: 'Age',
                  hint: 'e.g. 21',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => Validators.age(
                    value,
                    birthDate: birthDate,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FormTextField(
                  controller: nidController,
                  label: 'NID number',
                  hint: '8–20 digits',
                  icon: Icons.credit_card_outlined,
                  keyboardType: TextInputType.number,
                  validator: Validators.nid,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          FormField<DateTime>(
            initialValue: birthDate,
            validator: Validators.birthDate,
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    final picked = await onBirthDateTap();
                    if (picked != null) field.didChange(picked);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date of birth',
                      prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
                      errorText: field.errorText,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            birthDate == null
                                ? 'Choose your birth date'
                                : '${birthDate!.day.toString().padLeft(2, '0')}/'
                                  '${birthDate!.month.toString().padLeft(2, '0')}/'
                                  '${birthDate!.year}',
                            style: TextStyle(
                              color: birthDate == null
                                  ? Colors.grey.shade600
                                  : const Color(0xFF202333),
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
