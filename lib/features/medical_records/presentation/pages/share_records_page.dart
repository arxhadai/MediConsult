import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medical_records/medical_records_bloc.dart';
import '../bloc/medical_records/medical_records_event.dart';
import '../widgets/share_access_dialog.dart';

class ShareRecordsPage extends StatefulWidget {
  final String documentId;

  const ShareRecordsPage({super.key, required this.documentId});

  @override
  State<ShareRecordsPage> createState() => _ShareRecordsPageState();
}

class _ShareRecordsPageState extends State<ShareRecordsPage> {
  final TextEditingController _doctorIdController = TextEditingController();
  String? _selectedDoctorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Medical Records'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Share with Doctor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a doctor to share this medical record with',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Doctor selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Doctor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Doctor search field
                    TextField(
                      controller: _doctorIdController,
                      decoration: const InputDecoration(
                        labelText: 'Doctor ID or Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter doctor ID or search by name',
                      ),
                      onChanged: (value) {
                        // TODO: Implement doctor search functionality
                      },
                    ),

                    const SizedBox(height: 16),

                    // Recent doctors or search results
                    const Text(
                      'Recent Doctors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Sample doctor list (would be populated dynamically in a real app)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final doctors = [
                          {
                            'id': 'doc1',
                            'name': 'Dr. Sarah Johnson',
                            'specialty': 'Cardiologist'
                          },
                          {
                            'id': 'doc2',
                            'name': 'Dr. Michael Chen',
                            'specialty': 'General Practitioner'
                          },
                          {
                            'id': 'doc3',
                            'name': 'Dr. Emily Rodriguez',
                            'specialty': 'Pediatrician'
                          },
                        ];

                        final doctor = doctors[index];
                        return RadioListTile<String>(
                          title: Text(doctor['name']!),
                          subtitle: Text(doctor['specialty']!),
                          value: doctor['id']!,
                          groupValue: _selectedDoctorId,
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctorId = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sharing options
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sharing Options',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text('Allow download'),
                      subtitle: const Text('Doctor can download this document'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement download permission toggle
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Allow printing'),
                      subtitle: const Text('Doctor can print this document'),
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {
                          // TODO: Implement print permission toggle
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Share button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedDoctorId != null ? _shareDocument : null,
                child: const Text('Share Document'),
              ),
            ),

            const SizedBox(height: 16),

            // View shared access
            OutlinedButton(
              onPressed: _viewSharedAccess,
              child: const Text('View Shared Access'),
            ),
          ],
        ),
      ),
    );
  }

  void _shareDocument() {
    if (_selectedDoctorId != null) {
      // Dispatch share event
      context
          .read<MedicalRecordsBloc>()
          .add(ShareDocumentWithDoctor(widget.documentId, _selectedDoctorId!));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document shared successfully')),
      );

      Navigator.pop(context);
    }
  }

  void _viewSharedAccess() {
    // Show dialog with shared access information
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ShareAccessDialog(documentId: '');
      },
    );
  }

  @override
  void dispose() {
    _doctorIdController.dispose();
    super.dispose();
  }
}
