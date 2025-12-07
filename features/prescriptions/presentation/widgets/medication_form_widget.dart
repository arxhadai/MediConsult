import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medication.dart';
import '../../domain/enums/medication_form.dart';
import '../../domain/enums/medication_frequency.dart';
import '../../domain/enums/medication_timing.dart';
import 'dosage_selector.dart';
import 'frequency_picker.dart';
import 'timing_selector.dart';

class MedicationFormWidget extends StatefulWidget {
  final Function(Medication) onMedicationAdded;
  final Medication? initialMedication;

  const MedicationFormWidget({
    super.key,
    required this.onMedicationAdded,
    this.initialMedication,
  });

  @override
  State<MedicationFormWidget> createState() => _MedicationFormWidgetState();
}

class _MedicationFormWidgetState extends State<MedicationFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  String? _genericName;
  String? _brandName;
  String _dosage = '';
  MedicationForm _form = MedicationForm.tablet;
  MedicationFrequency _frequency = MedicationFrequency.onceDaily;
  List<MedicationTiming> _timings = [];
  int _durationDays = 7;
  int _quantity = 10;
  String? _instructions;
  bool _beforeFood = false;
  bool _isSubstitutionAllowed = true;
  String? _warnings;

  @override
  void initState() {
    super.initState();
    if (widget.initialMedication != null) {
      _initializeFromExistingMedication(widget.initialMedication!);
    }
  }

  void _initializeFromExistingMedication(Medication medication) {
    _name = medication.name;
    _genericName = medication.genericName;
    _brandName = medication.brandName;
    _dosage = medication.dosage;
    _form = medication.form;
    _frequency = medication.frequency;
    _timings = List.from(medication.timings);
    _durationDays = medication.durationDays;
    _quantity = medication.quantity;
    _instructions = medication.instructions;
    _beforeFood = medication.beforeFood;
    _isSubstitutionAllowed = medication.isSubstitutionAllowed;
    _warnings = medication.warnings;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication name
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Medication Name *',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter medication name';
                }
                return null;
              },
              onChanged: (value) => _name = value,
            ),
            const SizedBox(height: 16),

            // Generic name
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Generic Name (Optional)',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.genericName,
              onChanged: (value) => _genericName = value,
            ),
            const SizedBox(height: 16),

            // Brand name
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Brand Name (Optional)',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.brandName,
              onChanged: (value) => _brandName = value,
            ),
            const SizedBox(height: 16),

            // Dosage selector
            DosageSelector(
              initialDosage: widget.initialMedication?.dosage ?? '',
              onDosageChanged: (dosage) => _dosage = dosage,
            ),
            const SizedBox(height: 16),

            // Form selector
            DropdownButtonFormField<MedicationForm>(
              decoration: const InputDecoration(
                labelText: 'Form *',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.form ?? _form,
              items: MedicationForm.values.map((form) {
                return DropdownMenuItem(
                  value: form,
                  child: Text(_getFormDisplayName(form)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _form = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Frequency picker
            FrequencyPicker(
              initialFrequency:
                  widget.initialMedication?.frequency ?? _frequency,
              onFrequencyChanged: (frequency) => _frequency = frequency,
            ),
            const SizedBox(height: 16),

            // Timing selector
            TimingSelector(
              initialTimings: widget.initialMedication?.timings ?? _timings,
              onTimingsChanged: (timings) => _timings = timings,
            ),
            const SizedBox(height: 16),

            // Duration
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Duration (days) *',
                border: OutlineInputBorder(),
              ),
              initialValue:
                  widget.initialMedication?.durationDays.toString() ?? '7',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  _durationDays = parsed;
                }
              },
            ),
            const SizedBox(height: 16),

            // Quantity
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Quantity *',
                border: OutlineInputBorder(),
              ),
              initialValue:
                  widget.initialMedication?.quantity.toString() ?? '10',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  _quantity = parsed;
                }
              },
            ),
            const SizedBox(height: 16),

            // Instructions
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Instructions (Optional)',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.instructions,
              maxLines: 2,
              onChanged: (value) => _instructions = value,
            ),
            const SizedBox(height: 16),

            // Before food checkbox
            CheckboxListTile(
              title: const Text('Take before food'),
              value: widget.initialMedication?.beforeFood ?? _beforeFood,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _beforeFood = value;
                  });
                }
              },
            ),

            // Substitution allowed checkbox
            CheckboxListTile(
              title: const Text('Substitution allowed'),
              value: widget.initialMedication?.isSubstitutionAllowed ??
                  _isSubstitutionAllowed,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _isSubstitutionAllowed = value;
                  });
                }
              },
            ),

            // Warnings
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Warnings (Optional)',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.initialMedication?.warnings,
              maxLines: 2,
              onChanged: (value) => _warnings = value,
            ),
            const SizedBox(height: 16),

            // Side effects
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Side Effects (Optional)',
                border: OutlineInputBorder(),
              ),
              initialValue: null,
              maxLines: 2,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),

            // Submit button
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.initialMedication == null
                    ? 'Add Medication'
                    : 'Update Medication'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final medication = Medication(
        id: widget.initialMedication?.id ?? const Uuid().v4(),
        name: _name,
        genericName: _genericName,
        brandName: _brandName,
        dosage: _dosage,
        form: _form,
        frequency: _frequency,
        timings: _timings,
        durationDays: _durationDays,
        quantity: _quantity,
        instructions: _instructions,
        beforeFood: _beforeFood,
        isSubstitutionAllowed: _isSubstitutionAllowed,
        warnings: _warnings,
      );

      widget.onMedicationAdded(medication);
    }
  }

  String _getFormDisplayName(MedicationForm form) {
    switch (form) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.syrup:
        return 'Syrup';
      case MedicationForm.suspension:
        return 'Suspension';
      case MedicationForm.injection:
        return 'Injection';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.ointment:
        return 'Ointment';
      case MedicationForm.gel:
        return 'Gel';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.inhaler:
        return 'Inhaler';
      case MedicationForm.patch:
        return 'Patch';
      case MedicationForm.suppository:
        return 'Suppository';
      case MedicationForm.powder:
        return 'Powder';
      case MedicationForm.spray:
        return 'Spray';
      default:
        return form.name;
    }
  }
}
