import 'package:flutter/material.dart';
import '../models/wizard_data.dart';
import 'step_heading.dart';

class PreferencesStep extends StatelessWidget {
  final WizardData data;
  final VoidCallback onChanged;
  const PreferencesStep({super.key, required this.data, required this.onChanged});
  static const options = ['Technology', 'Sports', 'Music', 'Travel', 'Books', 'Photography'];

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const StepHeading(title: 'Preferences & settings', subtitle: 'Personalize the experience to your liking.'),
        Text('Your interests', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('Choose any topics you enjoy.'),
        const SizedBox(height: 8),
        ...options.map((option) => CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              value: data.interests.contains(option),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (checked) {
                if (checked == true) { data.interests.add(option); } else { data.interests.remove(option); }
                onChanged();
              },
            )),
        const Divider(height: 28),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Email updates'), subtitle: const Text('Receive occasional updates by email.'), value: data.emailUpdates, onChanged: (v) { data.emailUpdates = v; onChanged(); }),
        SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Push notifications'), subtitle: const Text('Allow notifications on this device.'), value: data.pushNotifications, onChanged: (v) { data.pushNotifications = v; onChanged(); }),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(value: data.themePreference, decoration: const InputDecoration(labelText: 'Preferred appearance', prefixIcon: Icon(Icons.palette_outlined)), items: const ['System default', 'Light', 'Dark'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) { data.themePreference = v ?? 'System default'; onChanged(); }),
      ]);
}
