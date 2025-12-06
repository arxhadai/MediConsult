import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/summary/summary_bloc.dart';
import '../../domain/entities/consultation_summary.dart';

/// Page for consultation summary
class ConsultationSummaryPage extends StatefulWidget {
  final String consultationTranscript;

  const ConsultationSummaryPage({
    Key? key,
    required this.consultationTranscript,
  }) : super(key: key);

  @override
  State<ConsultationSummaryPage> createState() => _ConsultationSummaryPageState();
}

class _ConsultationSummaryPageState extends State<ConsultationSummaryPage> {
  @override
  void initState() {
    super.initState();
    // Request summary generation when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SummaryBloc>().add(
            SummaryGenerationRequested(
              consultationTranscript: widget.consultationTranscript,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation Summary'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          if (state is SummaryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SummarySuccess) {
            return _buildSummaryView(state.summary);
          } else if (state is SummaryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error generating summary:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SummaryBloc>().add(
                            SummaryGenerationRequested(
                              consultationTranscript: widget.consultationTranscript,
                            ),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          return const Center(
            child: Text('Initializing...'),
          );
        },
      ),
    );
  }

  Widget _buildSummaryView(ConsultationSummary summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subjective',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(summary.subject),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Objective',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(summary.objective),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assessment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(summary.assessment),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(summary.plan),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (summary.medications.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Medications',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...summary.medications.map((med) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $med'),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (summary.followUpInstructions.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Follow-up Instructions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...summary.followUpInstructions.map((instruction) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $instruction'),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}