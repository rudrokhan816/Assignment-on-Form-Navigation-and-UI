import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wizard_data.dart';

class DraftService {
  static const _draftKey = 'multi_step_form_wizard_draft';
  static const _stepKey = 'multi_step_form_wizard_step';

  Future<void> save(WizardData data, int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(data.toJson()));
    await prefs.setInt(_stepKey, step);
  }

  Future<(WizardData, int)?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final step = (prefs.getInt(_stepKey) ?? 0).clamp(0, 3);
      return (WizardData.fromJson(decoded), step);
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
    await prefs.remove(_stepKey);
  }
}
