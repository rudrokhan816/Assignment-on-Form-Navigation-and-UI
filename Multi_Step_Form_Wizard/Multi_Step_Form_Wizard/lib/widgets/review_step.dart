import 'package:flutter/material.dart';
import '../models/wizard_data.dart';
import 'step_heading.dart';

class ReviewStep extends StatelessWidget {
  final WizardData data;
  const ReviewStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const StepHeading(title: 'Review & submit', subtitle: 'Check your details before completing the form.'),
        _ReviewCard(title: 'Personal information', icon: Icons.person_outline, rows: {'Full name': data.fullName, 'Date of birth': _value(data.dateOfBirth), 'Gender': data.gender}),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Contact details', icon: Icons.contact_mail_outlined, rows: {'Email': data.email, 'Phone': data.phone, 'Address': data.address, 'Country': data.country}),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Preferences & settings', icon: Icons.tune, rows: {'Interests': data.interests.isEmpty ? 'None selected' : data.interests.join(', '), 'Email updates': data.emailUpdates ? 'Enabled' : 'Disabled', 'Push notifications': data.pushNotifications ? 'Enabled' : 'Disabled', 'Appearance': data.themePreference}),
        const SizedBox(height: 14),
        const Text('By submitting, you confirm that the information above is correct.', style: TextStyle(color: Colors.black54)),
      ]);

  static String _value(String value) => value.isEmpty ? 'Not provided' : value;
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, String> rows;
  const _ReviewCard({required this.title, required this.icon, required this.rows});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFE7E8F0))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 9), Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))]),
            const SizedBox(height: 12),
            ...rows.entries.map((e) => Padding(padding: const EdgeInsets.only(bottom: 9), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 115, child: Text(e.key, style: const TextStyle(color: Colors.black54))), Expanded(child: Text(e.value, style: const TextStyle(fontWeight: FontWeight.w500)))]))),
          ]),
        ),
      );
}
