import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_prescription/create_prescription_bloc.dart';
import '../bloc/create_prescription/create_prescription_event.dart';
import '../bloc/create_prescription/create_prescription_state.dart';
import '../widgets/medication_form_widget.dart';
import '../widgets/doctor_signature_pad.dart';

class CreatePrescriptionPage extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String doctorLicenseNumber;
  final String patientId;
  final String patientName;
  final int? patientAge;
  final String? patientGender;
  final String consultationId;

  const CreatePrescriptionPage({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.doctorLicenseNumber,
    required this.patientId,
    required this.patientName,
    this.patientAge,
    this.patientGender,
    required this.consultationId,
  });

  @override
  State<CreatePrescriptionPage> createState() => _CreatePrescriptionPageState();
}

class _CreatePrescriptionPageState extends State<CreatePrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  String? _diagnosis;
  String? _notes;
  String? _pharmacyNotes;
  DateTime? _validUntil;
  int? _refillsAllowed;

  @override
  void initState() {
    super.initState();
    context.read<CreatePrescriptionBloc>().add(InitializePrescription(
          doctorId: widget.doctorId,
          doctorName: widget.doctorName,
          doctorSpecialization: widget.doctorSpecialization,
          doctorLicenseNumber: widget.doctorLicenseNumber,
          patientId: widget.patientId,
          patientName: widget.patientName,
          patientAge: widget.patientAge,
          patientGender: widget.patientGender,
          consultationId: widget.consultationId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Prescription'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePrescription,
          ),
        ],
      ),
      body: BlocConsumer<CreatePrescriptionBloc, CreatePrescriptionState>(
        listener: (context, state) {
          if (state is CreatePrescriptionSuccess) {
            Navigator.pop(context, true); // Return success indicator
          } else if (state is CreatePrescriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CreatePrescriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CreatePrescriptionEditing) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Patient info
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Patient Information',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${widget.patientName}'),
                            if (widget.patientAge != null)
                              Text('Age: ${widget.patientAge}'),
                            if (widget.patientGender != null)
                              Text('Gender: ${widget.patientGender}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Diagnosis
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Diagnosis',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => _diagnosis = value,
                    ),
                    const SizedBox(height: 16),

                    // Medications section
                    const Text(
                      'Medications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // TODO: Add medication list display

                    const SizedBox(height: 16),

                    // Add medication button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddMedicationDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Medication'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Doctor\'s Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => _notes = value,
                    ),
                    const SizedBox(height: 16),

                    // Pharmacy Notes
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Pharmacy Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (value) => _pharmacyNotes = value,
                    ),
                    const SizedBox(height: 16),

                    // Validity period
                    ListTile(
                      title: const Text('Valid Until'),
                      subtitle: Text(_validUntil == null
                          ? 'No expiry'
                          : '${_validUntil!.day}/${_validUntil!.month}/${_validUntil!.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _selectValidityDate,
                    ),
                    const SizedBox(height: 16),

                    // Refills
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Number of Refills Allowed (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          _refillsAllowed = int.tryParse(value),
                    ),
                    const SizedBox(height: 16),

                    // Signature pad
                    const Text(
                      'Doctor\'s Signature',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const DoctorSignaturePad(),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Medication'),
          content: MedicationFormWidget(
            onMedicationAdded: (medication) {
              context
                  .read<CreatePrescriptionBloc>()
                  .add(AddMedication(medication));
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectValidityDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _validUntil) {
      setState(() {
        _validUntil = picked;
      });
    }
  }

  void _savePrescription() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<CreatePrescriptionBloc>().state;
      if (state is CreatePrescriptionEditing) {
        context.read<CreatePrescriptionBloc>().add(UpdatePrescriptionDetails(
              diagnosis: _diagnosis,
              notes: _notes,
              pharmacyNotes: _pharmacyNotes,
              validUntil: _validUntil,
              refillsAllowed: _refillsAllowed,
            ));

        // Get the updated prescription and save it
        final updatedState = context.read<CreatePrescriptionBloc>().state;
        if (updatedState is CreatePrescriptionEditing) {
          context.read<CreatePrescriptionBloc>().add(
                SavePrescription(updatedState.prescription),
              );
        }
      }
    }
  }
}
