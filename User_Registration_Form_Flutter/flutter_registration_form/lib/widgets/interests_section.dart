import 'package:flutter/material.dart';
import '../validators/validators.dart';
import 'app_section_card.dart';

class InterestsSection extends StatelessWidget {
  const InterestsSection({
    required this.selectedInterests,
    required this.onChanged,
    super.key,
  });

  final Set<String> selectedInterests;
  final ValueChanged<Set<String>> onChanged;

  static const List<String> interests = [
    'Technology', 'Sports', 'Music', 'Travel', 'Reading', 'Photography',
    'Gaming', 'Cooking',
  ];

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Interests',
      subtitle: 'Select at least one that you enjoy',
      icon: Icons.favorite_border_rounded,
      child: FormField<List<String>>(
        initialValue: selectedInterests.toList(),
        validator: (value) => Validators.interests(value ?? const []),
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 2,
              children: interests.map((interest) {
                final selected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: selected,
                  onSelected: (isSelected) {
                    final updated = Set<String>.from(selectedInterests);
                    if (isSelected) {
                      updated.add(interest);
                    } else {
                      updated.remove(interest);
                    }
                    onChanged(updated);
                    field.didChange(updated.toList());
                  },
                );
              }).toList(),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
