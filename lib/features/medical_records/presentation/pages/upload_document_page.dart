import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/medical_records/medical_records_bloc.dart';
import '../bloc/medical_records/medical_records_event.dart';
import '../bloc/medical_records/medical_records_state.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/enums/record_category.dart';
import '../../domain/enums/access_level.dart';

class UploadDocumentPage extends StatefulWidget {
  final String patientId;

  const UploadDocumentPage({super.key, required this.patientId});

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  DocumentType? _documentType;
  RecordCategory? _recordCategory;
  AccessLevel _accessLevel = AccessLevel.private;
  String _fileUrl = '';
  String _fileName = '';
  int _fileSize = 0;
  String _mimeType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Medical Document'),
        centerTitle: true,
      ),
      body: BlocListener<MedicalRecordsBloc, MedicalRecordsState>(
        listener: (context, state) {
          if (state is DocumentUploadSuccess) {
            // Show success message and navigate back
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document uploaded successfully')),
            );
            Navigator.pop(context);
          } else if (state is MedicalRecordsError) {
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
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _title = value;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    _description = value;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DocumentType>(
                  decoration: const InputDecoration(
                    labelText: 'Document Type',
                    border: OutlineInputBorder(),
                  ),
                  items: DocumentType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a document type';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _documentType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<RecordCategory>(
                  decoration: const InputDecoration(
                    labelText: 'Record Category',
                    border: OutlineInputBorder(),
                  ),
                  items: RecordCategory.values
                      .where((category) => category != RecordCategory.all)
                      .map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.displayName),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a record category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _recordCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AccessLevel>(
                  decoration: const InputDecoration(
                    labelText: 'Access Level',
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _accessLevel,
                  items: AccessLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _accessLevel = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Select File'),
                  subtitle: _fileName.isEmpty ? null : Text(_fileName),
                  trailing: const Icon(Icons.attach_file),
                  onTap: () {
                    // TODO: Implement file selection
                    _selectFile();
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _uploadDocument,
                    child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
                      builder: (context, state) {
                        if (state is DocumentUploading) {
                          return const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('Uploading...'),
                            ],
                          );
                        }
                        return const Text('Upload Document');
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

  void _selectFile() {
    // TODO: Implement actual file selection
    // For now, we'll simulate file selection
    setState(() {
      _fileName = 'medical_report.pdf';
      _fileUrl = 'https://example.com/medical_report.pdf';
      _fileSize = 2048000; // 2MB
      _mimeType = 'application/pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File selected (simulated)')),
    );
  }

  void _uploadDocument() {
    if (_formKey.currentState!.validate()) {
      if (_fileName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a file')),
        );
        return;
      }

      final document = HealthDocument(
        id: const Uuid().v4(),
        patientId: widget.patientId,
        title: _title,
        description: _description,
        type: _documentType!,
        category: _recordCategory!,
        fileUrl: _fileUrl,
        fileName: _fileName,
        fileSizeBytes: _fileSize,
        mimeType: _mimeType,
        documentDate: DateTime.now(),
        uploadedAt: DateTime.now(),
        accessLevel: _accessLevel,
      );

      context.read<MedicalRecordsBloc>().add(UploadDocument(document));
    }
  }
}
