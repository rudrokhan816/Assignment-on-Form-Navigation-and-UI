import 'package:flutter/material.dart';
import '../validators/validators.dart';
import 'app_section_card.dart';

class GenderSection extends StatelessWidget {
  const GenderSection({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Gender',
      subtitle: 'Choose an option',
      icon: Icons.people_outline_rounded,
      child: FormField<String>(
        initialValue: value,
        validator: Validators.gender,
        builder: (field) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
                  .map(
                    (option) => SizedBox(
                      width: option == 'Prefer not to say' ? 190 : 135,
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(option, style: const TextStyle(fontSize: 13)),
                        value: option,
                        groupValue: value,
                        onChanged: (newValue) {
                          onChanged(newValue);
                          field.didChange(newValue);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
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
