import 'package:flutter/material.dart';
import '../models/wizard_data.dart';
import '../validators/validators.dart';
import 'step_heading.dart';

class PersonalInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final WizardData data;
  final VoidCallback onChanged;
  const PersonalInfoStep({super.key, required this.formKey, required this.data, required this.onChanged});

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const StepHeading(title: 'Personal information', subtitle: 'Let’s start with a few details about you.'),
          TextFormField(
            initialValue: data.fullName,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
            validator: (v) => Validators.requiredText(v, label: 'Full name'),
            onChanged: (v) { data.fullName = v; onChanged(); },
          ),
          const SizedBox(height: 16),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(context: context, initialDate: DateTime(now.year - 18), firstDate: DateTime(1900), lastDate: now);
              if (picked != null) {
                data.dateOfBirth = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                onChanged();
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(labelText: 'Date of birth', prefixIcon: const Icon(Icons.calendar_month_outlined), errorText: data.dateOfBirth.isEmpty && _showDateError ? 'Date of birth is required.' : null),
              child: Text(data.dateOfBirth.isEmpty ? 'Choose your date of birth' : data.dateOfBirth, style: TextStyle(color: data.dateOfBirth.isEmpty ? Colors.black54 : Colors.black87)),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: data.gender.isEmpty ? null : data.gender,
            decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.people_outline)),
            items: const ['Female', 'Male', 'Non-binary', 'Prefer not to say'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            validator: (v) => v == null ? 'Please choose an option.' : null,
            onChanged: (v) { data.gender = v ?? ''; onChanged(); },
          ),
        ]),
      );

  // The date field is checked by the wizard before moving to the next step.
  bool get _showDateError => false;
}
