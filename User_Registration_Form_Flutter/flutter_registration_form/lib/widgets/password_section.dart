import 'package:flutter/material.dart';
import '../validators/validators.dart';
import 'app_section_card.dart';

class PasswordSection extends StatefulWidget {
  const PasswordSection({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onPasswordChanged,
    super.key,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String> onPasswordChanged;

  @override
  State<PasswordSection> createState() => _PasswordSectionState();
}

class _PasswordSectionState extends State<PasswordSection> {
  bool _hidePassword = true;
  bool _hideConfirmation = true;

  int get _strength {
    final value = widget.passwordController.text;
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[a-z]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]').hasMatch(value)) score++;
    return score;
  }

  String get _strengthLabel {
    if (_strength <= 2) return 'Weak';
    if (_strength <= 4) return 'Medium';
    return 'Strong';
  }

  Color get _strengthColor {
    if (_strength <= 2) return Colors.redAccent;
    if (_strength <= 4) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: 'Secure your account',
      subtitle: 'Create a strong password',
      icon: Icons.lock_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.passwordController,
            obscureText: _hidePassword,
            onChanged: (value) {
              setState(() {});
              widget.onPasswordChanged(value);
            },
            validator: Validators.password,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'At least 8 characters',
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              suffixIcon: IconButton(
                tooltip: _hidePassword ? 'Show password' : 'Hide password',
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.passwordController.text.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _strength / 5,
                      minHeight: 6,
                      color: _strengthColor,
                      backgroundColor: const Color(0xFFE9EAF2),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _strengthLabel,
                  style: TextStyle(
                    color: _strengthColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Use 8+ characters with uppercase, lowercase, a number, and a symbol.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 15),
          ] else
            const SizedBox(height: 15),
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: _hideConfirmation,
            validator: (value) => Validators.confirmPassword(
              value,
              widget.passwordController.text,
            ),
            decoration: InputDecoration(
              labelText: 'Confirm password',
              hintText: 'Enter the same password again',
              prefixIcon: const Icon(Icons.verified_user_outlined, size: 20),
              suffixIcon: IconButton(
                tooltip: _hideConfirmation ? 'Show password' : 'Hide password',
                onPressed: () => setState(
                  () => _hideConfirmation = !_hideConfirmation,
                ),
                icon: Icon(
                  _hideConfirmation
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
