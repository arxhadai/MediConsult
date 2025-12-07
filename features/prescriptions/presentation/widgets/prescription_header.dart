import 'package:flutter/material.dart';
import '../../domain/entities/prescription.dart';

class PrescriptionHeader extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionHeader({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic/Doctor info
            if (prescription.clinicName != null)
              Text(
                prescription.clinicName!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (prescription.clinicAddress != null)
              Text(
                prescription.clinicAddress!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

            const SizedBox(height: 8),

            // Doctor info
            Text(
              'Dr. ${prescription.doctorName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              prescription.doctorSpecialization,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            Text(
              'License: ${prescription.doctorLicenseNumber}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            if (prescription.doctorPhone != null)
              Text(
                'Phone: ${prescription.doctorPhone}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

            const Divider(height: 32),

            // Patient info
            const Text(
              'Prescribed to:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            Text(
              prescription.patientName,
              style: const TextStyle(fontSize: 16),
            ),

            if (prescription.patientAge != null ||
                prescription.patientGender != null)
              Text(
                '${prescription.patientAge != null ? '${prescription.patientAge} years' : ''}${prescription.patientAge != null && prescription.patientGender != null ? ', ' : ''}${prescription.patientGender ?? ''}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

            const SizedBox(height: 8),

            // Date info
            Row(
              children: [
                const Text(
                  'Date: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${prescription.prescribedDate.day}/${prescription.prescribedDate.month}/${prescription.prescribedDate.year}',
                ),
              ],
            ),

            if (prescription.diagnosis != null &&
                prescription.diagnosis!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Diagnosis: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(prescription.diagnosis!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
