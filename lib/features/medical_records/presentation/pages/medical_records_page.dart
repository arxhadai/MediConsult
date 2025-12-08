import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/medical_records/medical_records_bloc.dart';
import '../bloc/medical_records/medical_records_event.dart';
import '../bloc/medical_records/medical_records_state.dart';
import '../../domain/enums/record_category.dart';
import '../widgets/document_card.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/empty_records_widget.dart';

class MedicalRecordsPage extends StatefulWidget {
  final String patientId;

  const MedicalRecordsPage({super.key, required this.patientId});

  @override
  State<MedicalRecordsPage> createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  RecordCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    // Load all medical records initially
    context
        .read<MedicalRecordsBloc>()
        .add(LoadMedicalRecords(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medical Records'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              // Navigate to upload document page
              Navigator.pushNamed(context, '/upload_document',
                  arguments: widget.patientId);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter bar
          CategoryFilterBar(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });

              if (category == null) {
                // Load all records
                context
                    .read<MedicalRecordsBloc>()
                    .add(LoadMedicalRecords(widget.patientId));
              } else {
                // Load records by category
                context.read<MedicalRecordsBloc>().add(
                    LoadMedicalRecordsByCategory(widget.patientId, category));
              }
            },
          ),
          // Records list
          Expanded(
            child: BlocBuilder<MedicalRecordsBloc, MedicalRecordsState>(
              builder: (context, state) {
                if (state is MedicalRecordsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MedicalRecordsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedCategory == null) {
                              context
                                  .read<MedicalRecordsBloc>()
                                  .add(LoadMedicalRecords(widget.patientId));
                            } else {
                              context.read<MedicalRecordsBloc>().add(
                                  LoadMedicalRecordsByCategory(
                                      widget.patientId, _selectedCategory!));
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is MedicalRecordsLoaded) {
                  if (state.documents.isEmpty) {
                    return const EmptyRecordsWidget();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      if (_selectedCategory == null) {
                        context
                            .read<MedicalRecordsBloc>()
                            .add(RefreshMedicalRecords(widget.patientId));
                      } else {
                        context
                            .read<MedicalRecordsBloc>()
                            .add(RefreshMedicalRecords(widget.patientId));
                      }
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.documents.length,
                      itemBuilder: (context, index) {
                        final document = state.documents[index];
                        return DocumentCard(
                          document: document,
                          onTap: () {
                            // Navigate to document detail page
                            Navigator.pushNamed(context, '/document_detail',
                                arguments: document.id);
                          },
                          onShare: () {
                            // Navigate to share records page
                            Navigator.pushNamed(context, '/share_records',
                                arguments: document.id);
                          },
                        );
                      },
                    ),
                  );
                }

                return const Center(child: Text('Unknown state'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
