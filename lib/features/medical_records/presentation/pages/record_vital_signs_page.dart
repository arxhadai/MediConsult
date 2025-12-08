import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/vital_signs/vital_signs_bloc.dart';
import '../bloc/vital_signs/vital_signs_event.dart';
import '../bloc/vital_signs/vital_signs_state.dart';
import '../../domain/entities/vital_signs.dart';
import '../widgets/vital_signs_input_form.dart';

class RecordVitalSignsPage extends StatefulWidget {
  final String patientId;

  const RecordVitalSignsPage({super.key, required this.patientId});

  @override
  State<RecordVitalSignsPage> createState() => _RecordVitalSignsPageState();
}

class _RecordVitalSignsPageState extends State<RecordVitalSignsPage> {
  final _formKey = GlobalKey<FormState>();
  double? _bloodPressureSystolic;
  double? _bloodPressureDiastolic;
  double? _heartRate;
  double? _temperature;
  double? _weight;
  double? _height;
  double? _bloodSugar;
  double? _oxygenSaturation;
  double? _respiratoryRate;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Vital Signs'),
        centerTitle: true,
      ),
      body: BlocListener<VitalSignsBloc, VitalSignsState>(
        listener: (context, state) {
          if (state is VitalSignsRecorded) {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Vital signs recorded successfully')),
            );
            Navigator.pop(context);
          } else if (state is VitalSignsError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your current vital signs measurements',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                VitalSignsInputForm(
                  onBloodPressureChanged: (systolic, diastolic) {
                    setState(() {
                      _bloodPressureSystolic = systolic;
                      _bloodPressureDiastolic = diastolic;
                    });
                  },
                  onHeartRateChanged: (value) {
                    setState(() {
                      _heartRate = value;
                    });
                  },
                  onTemperatureChanged: (value) {
                    setState(() {
                      _temperature = value;
                    });
                  },
                  onWeightChanged: (value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                  onHeightChanged: (value) {
                    setState(() {
                      _height = value;
                    });
                  },
                  onBloodSugarChanged: (value) {
                    setState(() {
                      _bloodSugar = value;
                    });
                  },
                  onOxygenSaturationChanged: (value) {
                    setState(() {
                      _oxygenSaturation = value;
                    });
                  },
                  onRespiratoryRateChanged: (value) {
                    setState(() {
                      _respiratoryRate = value;
                    });
                  },
                  onNotesChanged: (value) {
                    setState(() {
                      _notes = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _recordVitalSigns,
                    child: BlocBuilder<VitalSignsBloc, VitalSignsState>(
                      builder: (context, state) {
                        if (state is VitalSignsRecording) {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Recording...'),
                            ],
                          );
                        }
                        return const Text('Record Vital Signs');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _recordVitalSigns() {
    // Validate that at least one vital sign is entered
    if (_bloodPressureSystolic == null &&
        _bloodPressureDiastolic == null &&
        _heartRate == null &&
        _temperature == null &&
        _weight == null &&
        _height == null &&
        _bloodSugar == null &&
        _oxygenSaturation == null &&
        _respiratoryRate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one vital sign')),
      );
      return;
    }

    final vitalSigns = VitalSigns(
      id: const Uuid().v4(),
      patientId: widget.patientId,
      bloodPressureSystolic: _bloodPressureSystolic,
      bloodPressureDiastolic: _bloodPressureDiastolic,
      heartRate: _heartRate,
      temperature: _temperature,
      weight: _weight,
      height: _height,
      bloodSugar: _bloodSugar,
      oxygenSaturation: _oxygenSaturation,
      respiratoryRate: _respiratoryRate,
      recordedAt: DateTime.now(),
      notes: _notes,
    );

    context.read<VitalSignsBloc>().add(RecordVitalSigns(vitalSigns));
  }
}
