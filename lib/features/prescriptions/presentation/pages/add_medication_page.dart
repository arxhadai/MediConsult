import 'package:flutter/material.dart';
import '../widgets/medication_form_widget.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/medication.dart';

class AddMedicationPage extends StatelessWidget {
  final Function(Medication) onMedicationAdded;

  const AddMedicationPage({super.key, required this.onMedicationAdded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MedicationFormWidget(
          onMedicationAdded: onMedicationAdded,
        ),
      ),
    );
  }
}
