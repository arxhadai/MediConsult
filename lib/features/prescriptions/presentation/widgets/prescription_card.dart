import 'package:flutter/material.dart';
import '../../domain/entities/prescription.dart';
import '../../domain/enums/prescription_status.dart';
import 'refill_badge.dart';

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionCard({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to prescription detail page
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with doctor info and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prescription.doctorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          prescription.doctorSpecialization,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${prescription.prescribedDate.day}/${prescription.prescribedDate.month}/${prescription.prescribedDate.year}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      if (prescription.status == PrescriptionStatus.active)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(color: Colors.green, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Patient info
              Text(
                'For: ${prescription.patientName}',
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 8),

              // Medications count
              Text(
                '${prescription.medications.length} medication(s)',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 12),

              // Validity and refill info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Valid Until',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        prescription.validUntil != null
                            ? '${prescription.validUntil!.day}/${prescription.validUntil!.month}/${prescription.validUntil!.year}'
                            : 'No expiry',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  if (prescription.refillsAllowed != null)
                    RefillBadge(
                      remainingRefills: prescription.remainingRefills,
                      totalRefills: prescription.refillsAllowed!,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
