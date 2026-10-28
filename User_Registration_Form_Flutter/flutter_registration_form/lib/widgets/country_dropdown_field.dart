import 'package:flutter/material.dart';
import '../validators/validators.dart';
import 'app_section_card.dart';

class CountryDropdownField extends StatelessWidget {
  const CountryDropdownField({
    required this.selectedCountry,
    required this.onChanged,
    super.key,
  });

  final String? selectedCountry;
  final ValueChanged<String> onChanged;

  static const List<String> countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Argentina', 'Australia', 'Austria',
    'Bahrain', 'Bangladesh', 'Belgium', 'Bhutan', 'Brazil', 'Brunei',
    'Cambodia', 'Canada', 'Chile', 'China', 'Colombia', 'Denmark', 'Egypt',
    'Finland', 'France', 'Germany', 'Ghana', 'Greece', 'India', 'Indonesia',
    'Iran', 'Iraq', 'Ireland', 'Italy', 'Japan', 'Jordan', 'Kenya', 'Kuwait',
    'Malaysia', 'Maldives', 'Mexico', 'Nepal', 'Netherlands', 'New Zealand',
    'Nigeria', 'Norway', 'Oman', 'Pakistan', 'Philippines', 'Poland',
    'Portugal', 'Qatar', 'Saudi Arabia', 'Singapore', 'South Africa',
    'South Korea', 'Spain', 'Sri Lanka', 'Sweden', 'Switzerland', 'Thailand',
    'Turkey', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
    'United States', 'Vietnam',
  ];

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Country',
      subtitle: 'Where are you based?',
      icon: Icons.public_rounded,
      child: FormField<String>(
        initialValue: selectedCountry,
        validator: Validators.country,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => const _CountrySearchSheet(),
                  );
                  if (result != null) {
                    onChanged(result);
                    field.didChange(result);
                  }
                },
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Select country',
                    prefixIcon: const Icon(Icons.flag_outlined, size: 20),
                    suffixIcon: const Icon(Icons.search_rounded),
                    errorText: field.errorText,
                  ),
                  child: Text(
                    selectedCountry ?? 'Search and choose a country',
                    style: TextStyle(
                      color: selectedCountry == null
                          ? Colors.grey.shade600
                          : const Color(0xFF202333),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CountrySearchSheet extends StatefulWidget {
  const _CountrySearchSheet();

  @override
  State<_CountrySearchSheet> createState() => _CountrySearchSheetState();
}

class _CountrySearchSheetState extends State<_CountrySearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = CountryDropdownField.countries
        .where((country) => country.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Choose your country',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Type a country name...',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No countries found.'))
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 8),
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          return ListTile(
                            title: Text(country),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () => Navigator.pop(context, country),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
