import 'package:flutter/material.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/prescription.dart';

class PrescriptionFooter extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionFooter({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Instructions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Take medications as prescribed',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '• Complete the full course of treatment',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '• Contact your doctor if you experience any adverse reactions',
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              '• Store medications properly as instructed',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Doctor signature placeholder
            if (prescription.doctorSignatureUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doctor\'s Signature:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TODO: Display actual signature image
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Text('Signature Image'),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Doctor\'s electronic signature will be added upon finalization',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
