import 'package:flutter/material.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/prescription.dart';
import '../widgets/prescription_header.dart';
import '../widgets/prescription_footer.dart';
import '../widgets/refill_badge.dart';

class PrescriptionDetailPage extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionDetailPage({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrescriptionHeader(prescription: prescription),
            const SizedBox(height: 20),

            // Medications section
            const Text(
              'Medications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // TODO: Add medication list widget

            const SizedBox(height: 20),

            // Notes section
            if (prescription.notes != null && prescription.notes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doctor\'s Notes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(prescription.notes!),
                  const SizedBox(height: 20),
                ],
              ),

            // Pharmacy notes section
            if (prescription.pharmacyNotes != null &&
                prescription.pharmacyNotes!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pharmacy Notes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(prescription.pharmacyNotes!),
                  const SizedBox(height: 20),
                ],
              ),

            // Validity and refill info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valid Until',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      prescription.validUntil != null
                          ? '${prescription.validUntil!.day}/${prescription.validUntil!.month}/${prescription.validUntil!.year}'
                          : 'No expiry',
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

            const SizedBox(height: 20),

            PrescriptionFooter(prescription: prescription),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (prescription.canRefill)
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement refill functionality
                },
                child: const Text('Request Refill'),
              ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement set reminder functionality
              },
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
