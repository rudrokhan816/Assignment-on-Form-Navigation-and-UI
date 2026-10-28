import 'package:flutter/material.dart';
import '../models/wizard_data.dart';
import '../services/draft_service.dart';
import '../validators/validators.dart';
import '../widgets/contact_details_step.dart';
import '../widgets/personal_info_step.dart';
import '../widgets/preferences_step.dart';
import '../widgets/review_step.dart';
import 'success_screen.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});
  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final _draftService = DraftService();
  final _stepKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final _data = WizardData();
  int _currentStep = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _completed = false;

  static const _titles = ['Personal', 'Contact', 'Preferences', 'Review'];
  static const _icons = [Icons.person_outline, Icons.contact_mail_outlined, Icons.tune, Icons.fact_check_outlined];

  @override
  void initState() {
    super.initState();
    _restoreDraft();
  }

  Future<void> _restoreDraft() async {
    final draft = await _draftService.load();
    if (!mounted) return;
    if (draft != null) {
      final restored = draft.$1;
      _copyData(restored);
      _currentStep = draft.$2;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your saved draft has been restored.')));
      });
    }
    setState(() => _isLoading = false);
  }

  void _copyData(WizardData source) {
    _data.fullName = source.fullName;
    _data.dateOfBirth = source.dateOfBirth;
    _data.gender = source.gender;
    _data.email = source.email;
    _data.phone = source.phone;
    _data.address = source.address;
    _data.country = source.country;
    _data.interests = List<String>.from(source.interests);
    _data.emailUpdates = source.emailUpdates;
    _data.pushNotifications = source.pushNotifications;
    _data.themePreference = source.themePreference;
  }

  Future<void> _saveDraft({bool showMessage = true}) async {
    setState(() => _isSaving = true);
    try {
      await _draftService.save(_data, _currentStep);
      if (mounted && showMessage) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved on this device.')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save the draft. Please try again.')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _next() async {
    if (_currentStep == 0 && _data.dateOfBirth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose your date of birth.')));
      return;
    }
    if (_currentStep < 2 && !(_stepKeys[_currentStep].currentState?.validate() ?? false)) return;
    if (_currentStep == 2) {
      setState(() => _currentStep = 3);
      await _saveDraft(showMessage: false);
    } else if (_currentStep < 3) {
      setState(() => _currentStep++);
      await _saveDraft(showMessage: false);
    }
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  Future<void> _submit() async {
    // Recheck the data itself because earlier step widgets are not mounted on Review.
    if (_data.fullName.trim().isEmpty || _data.dateOfBirth.isEmpty || _data.gender.isEmpty) {
      setState(() => _currentStep = 0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all personal information fields.')));
      return;
    }
    if (Validators.email(_data.email) != null ||
        Validators.phone(_data.phone) != null ||
        _data.address.trim().isEmpty || _data.country.isEmpty) {
      setState(() => _currentStep = 1);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please correct your contact details.')));
      return;
    }
    await _draftService.clear();
    if (mounted) setState(() => _completed = true);
  }

  Future<void> _startOver() async {
    await _draftService.clear();
    _copyData(WizardData());
    if (mounted) setState(() { _currentStep = 0; _completed = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_completed) return SuccessScreen(onStartOver: _startOver);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Wizard', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: false,
        actions: [TextButton.icon(onPressed: _isSaving ? null : () => _saveDraft(), icon: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined), label: const Text('Save draft')), const SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(children: [
              Padding(padding: const EdgeInsets.fromLTRB(20, 12, 20, 8), child: _buildProgress()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFFE7E8F0))),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: KeyedSubtree(key: ValueKey(_currentStep), child: _buildCurrentStep()),
                      ),
                    ),
                  ),
                ),
              ),
              _buildNavigation(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Text('STEP ${_currentStep + 1} OF 4', style: const TextStyle(fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w800, color: Color(0xFF6254D9))), const Spacer(), Text('${((_currentStep + 1) / 4 * 100).round()}% complete', style: const TextStyle(fontSize: 12, color: Colors.black54))]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: (_currentStep + 1) / 4, minHeight: 7, backgroundColor: const Color(0xFFE8E7F7))),
        const SizedBox(height: 14),
        Row(children: List.generate(4, (i) => Expanded(child: Padding(padding: EdgeInsets.only(right: i == 3 ? 0 : 8), child: Column(children: [
          CircleAvatar(radius: 17, backgroundColor: i <= _currentStep ? Theme.of(context).colorScheme.primary : const Color(0xFFE9EAF2), child: Icon(i < _currentStep ? Icons.check : _icons[i], size: 17, color: i <= _currentStep ? Colors.white : Colors.black45)),
          const SizedBox(height: 6),
          Text(_titles[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: i == _currentStep ? FontWeight.w800 : FontWeight.w500, color: i == _currentStep ? Theme.of(context).colorScheme.primary : Colors.black54)),
        ]))))),
      ]);

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return PersonalInfoStep(formKey: _stepKeys[0], data: _data, onChanged: _onDataChanged);
      case 1: return ContactDetailsStep(formKey: _stepKeys[1], data: _data, onChanged: _onDataChanged);
      case 2: return PreferencesStep(data: _data, onChanged: _onDataChanged);
      default: return ReviewStep(data: _data);
    }
  }

  void _onDataChanged() {
    // Keep the in-memory data current; the Save Draft button persists it.
    setState(() {});
  }

  Widget _buildNavigation() => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE7E8F0)))),
        child: Row(children: [
          OutlinedButton.icon(onPressed: _currentStep == 0 ? null : _back, icon: const Icon(Icons.arrow_back), label: const Text('Back')),
          const Spacer(),
          Text('${_currentStep + 1} / 4', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          const SizedBox(width: 14),
          FilledButton.icon(onPressed: _currentStep == 3 ? _submit : _next, icon: Icon(_currentStep == 3 ? Icons.check : Icons.arrow_forward), label: Text(_currentStep == 3 ? 'Submit' : 'Next'), iconAlignment: IconAlignment.end),
        ]),
      );
}
