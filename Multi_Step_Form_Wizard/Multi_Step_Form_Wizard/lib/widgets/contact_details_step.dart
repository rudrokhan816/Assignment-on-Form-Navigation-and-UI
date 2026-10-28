import 'package:flutter/material.dart';
import '../models/wizard_data.dart';
import '../validators/validators.dart';
import 'step_heading.dart';

class ContactDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final WizardData data;
  final VoidCallback onChanged;
  const ContactDetailsStep({super.key, required this.formKey, required this.data, required this.onChanged});

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const StepHeading(title: 'Contact details', subtitle: 'How can we reach you if needed?'),
          TextFormField(initialValue: data.email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email_outlined)), validator: Validators.email, onChanged: (v) { data.email = v; onChanged(); }),
          const SizedBox(height: 16),
          TextFormField(initialValue: data.phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number', prefixIcon: Icon(Icons.phone_outlined), hintText: '+880 1XXX-XXXXXX'), validator: Validators.phone, onChanged: (v) { data.phone = v; onChanged(); }),
          const SizedBox(height: 16),
          TextFormField(initialValue: data.address, maxLines: 2, textCapitalization: TextCapitalization.sentences, decoration: const InputDecoration(labelText: 'Street address', prefixIcon: Icon(Icons.location_on_outlined), alignLabelWithHint: true), validator: (v) => Validators.requiredText(v, label: 'Address'), onChanged: (v) { data.address = v; onChanged(); }),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(value: data.country.isEmpty ? null : data.country, decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.public)), items: const ['Bangladesh', 'India', 'Pakistan', 'Nepal', 'United States', 'United Kingdom', 'Canada', 'Australia', 'Other'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), validator: (v) => v == null ? 'Please select your country.' : null, onChanged: (v) { data.country = v ?? ''; onChanged(); }),
        ]),
      );
}
