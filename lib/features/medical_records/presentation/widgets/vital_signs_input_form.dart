import 'package:flutter/material.dart';

class VitalSignsInputForm extends StatefulWidget {
  final Function(double?, double?) onBloodPressureChanged;
  final Function(double?) onHeartRateChanged;
  final Function(double?) onTemperatureChanged;
  final Function(double?) onWeightChanged;
  final Function(double?) onHeightChanged;
  final Function(double?) onBloodSugarChanged;
  final Function(double?) onOxygenSaturationChanged;
  final Function(double?) onRespiratoryRateChanged;
  final Function(String?) onNotesChanged;

  const VitalSignsInputForm({
    super.key,
    required this.onBloodPressureChanged,
    required this.onHeartRateChanged,
    required this.onTemperatureChanged,
    required this.onWeightChanged,
    required this.onHeightChanged,
    required this.onBloodSugarChanged,
    required this.onOxygenSaturationChanged,
    required this.onRespiratoryRateChanged,
    required this.onNotesChanged,
  });

  @override
  State<VitalSignsInputForm> createState() => _VitalSignsInputFormState();
}

class _VitalSignsInputFormState extends State<VitalSignsInputForm> {
  final _bloodPressureSystolicController = TextEditingController();
  final _bloodPressureDiastolicController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _oxygenSaturationController = TextEditingController();
  final _respiratoryRateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Blood Pressure
        const Text(
          'Blood Pressure',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _bloodPressureSystolicController,
                decoration: const InputDecoration(
                  labelText: 'Systolic (mmHg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final systolic = double.tryParse(value);
                  final diastolic =
                      double.tryParse(_bloodPressureDiastolicController.text);
                  widget.onBloodPressureChanged(systolic, diastolic);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _bloodPressureDiastolicController,
                decoration: const InputDecoration(
                  labelText: 'Diastolic (mmHg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final diastolic = double.tryParse(value);
                  final systolic =
                      double.tryParse(_bloodPressureSystolicController.text);
                  widget.onBloodPressureChanged(systolic, diastolic);
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Heart Rate
        _buildSingleInputField(
          'Heart Rate (bpm)',
          _heartRateController,
          TextInputType.number,
          (value) => widget.onHeartRateChanged(double.tryParse(value)),
        ),

        const SizedBox(height: 16),

        // Temperature
        _buildSingleInputField(
          'Temperature (°F)',
          _temperatureController,
          TextInputType.numberWithOptions(decimal: true),
          (value) => widget.onTemperatureChanged(double.tryParse(value)),
        ),

        const SizedBox(height: 16),

        // Weight and Height
        const Text(
          'Body Measurements',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSingleInputField(
                'Weight (kg)',
                _weightController,
                TextInputType.numberWithOptions(decimal: true),
                (value) => widget.onWeightChanged(double.tryParse(value)),
                showLabel: false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSingleInputField(
                'Height (cm)',
                _heightController,
                TextInputType.numberWithOptions(decimal: true),
                (value) => widget.onHeightChanged(double.tryParse(value)),
                showLabel: false,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Blood Sugar
        _buildSingleInputField(
          'Blood Sugar (mg/dL)',
          _bloodSugarController,
          TextInputType.number,
          (value) => widget.onBloodSugarChanged(double.tryParse(value)),
        ),

        const SizedBox(height: 16),

        // Oxygen Saturation
        _buildSingleInputField(
          'Oxygen Saturation (%)',
          _oxygenSaturationController,
          TextInputType.numberWithOptions(decimal: true),
          (value) => widget.onOxygenSaturationChanged(double.tryParse(value)),
        ),

        const SizedBox(height: 16),

        // Respiratory Rate
        _buildSingleInputField(
          'Respiratory Rate (rpm)',
          _respiratoryRateController,
          TextInputType.number,
          (value) => widget.onRespiratoryRateChanged(double.tryParse(value)),
        ),

        const SizedBox(height: 16),

        // Notes
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: widget.onNotesChanged,
        ),
      ],
    );
  }

  Widget _buildSingleInputField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
    Function(String) onChanged, {
    bool showLabel = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        if (showLabel) const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: !showLabel ? label : null,
            border: const OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _bloodPressureSystolicController.dispose();
    _bloodPressureDiastolicController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bloodSugarController.dispose();
    _oxygenSaturationController.dispose();
    _respiratoryRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
