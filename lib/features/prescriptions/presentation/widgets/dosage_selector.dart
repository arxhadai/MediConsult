import 'package:flutter/material.dart';

class DosageSelector extends StatefulWidget {
  final String initialDosage;
  final Function(String) onDosageChanged;

  const DosageSelector({
    super.key,
    required this.initialDosage,
    required this.onDosageChanged,
  });

  @override
  State<DosageSelector> createState() => _DosageSelectorState();
}

class _DosageSelectorState extends State<DosageSelector> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDosage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dosage *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'e.g., 10 mg, 5 ml, 1 tablet',
            border: OutlineInputBorder(),
          ),
          onChanged: widget.onDosageChanged,
        ),
        const SizedBox(height: 8),
        const Text(
          'Examples: 10 mg, 5 ml, 1 tablet, 2 capsules',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}