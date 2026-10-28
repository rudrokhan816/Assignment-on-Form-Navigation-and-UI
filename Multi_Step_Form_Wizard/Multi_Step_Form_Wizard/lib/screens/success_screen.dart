import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final VoidCallback onStartOver;
  const SuccessScreen({super.key, required this.onStartOver});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 92, height: 92, decoration: BoxDecoration(color: Colors.green.withOpacity(.12), shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: Colors.green, size: 58)),
                const SizedBox(height: 24),
                Text('You’re all set!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                const Text('The form has been completed successfully. This demo does not send your information to a server.', textAlign: TextAlign.center, style: TextStyle(height: 1.5, color: Colors.black54)),
                const SizedBox(height: 28),
                FilledButton.icon(onPressed: onStartOver, icon: const Icon(Icons.refresh), label: const Text('Start a new form')),
              ]),
            ),
          ),
        ),
      );
}
