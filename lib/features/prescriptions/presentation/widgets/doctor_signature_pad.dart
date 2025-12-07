import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class DoctorSignaturePad extends StatefulWidget {
  const DoctorSignaturePad({super.key});

  @override
  State<DoctorSignaturePad> createState() => _DoctorSignaturePadState();
}

class _DoctorSignaturePadState extends State<DoctorSignaturePad> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

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
          'Doctor\'s Signature',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _controller,
            width: double.infinity,
            height: 150,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                _controller.clear();
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }
}