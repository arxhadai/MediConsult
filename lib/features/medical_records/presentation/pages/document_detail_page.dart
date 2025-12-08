import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/medical_records/medical_records_bloc.dart';
import '../bloc/medical_records/medical_records_event.dart';
import '../bloc/medical_records/medical_records_state.dart';
import '../../domain/enums/document_type.dart';
import '../../domain/enums/access_level.dart';
import '../../domain/enums/record_category.dart';

class DocumentDetailPage extends StatelessWidget {
  final String documentId;

  const DocumentDetailPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
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
      body: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
        builder: (context, state) {
          if (state is MedicalRecordsLoaded) {
            final document = state.documents.firstWhere(
              (doc) => doc.id == documentId,
              orElse: () => throw Exception('Document not found'),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document header with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          document.type.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              document.type.displayName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Document details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _detailRow('Description',
                              document.description ?? 'No description'),
                          const Divider(),
                          _detailRow('Category', document.category.displayName),
                          const Divider(),
                          _detailRow('File Size', document.fileSizeFormatted),
                          const Divider(),
                          _detailRow(
                              'Document Date',
                              DateFormat('MMM dd, yyyy')
                                  .format(document.documentDate)),
                          const Divider(),
                          _detailRow(
                              'Uploaded',
                              DateFormat('MMM dd, yyyy HH:mm')
                                  .format(document.uploadedAt)),
                          const Divider(),
                          _detailRow(
                              'Access Level', document.accessLevel.displayName),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement view functionality
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('View Document'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement share functionality
                            Navigator.pushNamed(context, '/share_records',
                                arguments: document.id);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement download functionality
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Show confirmation dialog before deleting
                        _confirmDelete(context, document.id);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete Document',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Loading document details...'));
        },
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(value),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: const Text(
              'Are you sure you want to delete this document? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Dispatch delete event
                context
                    .read<MedicalRecordsBloc>()
                    .add(DeleteDocument(documentId));
                Navigator.pop(context);
                Navigator.pop(context); // Pop back to the previous screen
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
