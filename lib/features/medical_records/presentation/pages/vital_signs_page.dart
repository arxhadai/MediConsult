import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/vital_signs/vital_signs_bloc.dart';
import '../bloc/vital_signs/vital_signs_event.dart';
import '../bloc/vital_signs/vital_signs_state.dart';
import '../widgets/vital_signs_card.dart';
import '../widgets/vital_signs_chart.dart';

class VitalSignsPage extends StatefulWidget {
  final String patientId;

  const VitalSignsPage({super.key, required this.patientId});

  @override
  State<VitalSignsPage> createState() => _VitalSignsPageState();
}

class _VitalSignsPageState extends State<VitalSignsPage> {
  @override
  void initState() {
    super.initState();
    // Load vital signs history
    context.read<VitalSignsBloc>().add(LoadVitalSignsHistory(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vital Signs History'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to record vital signs page
              Navigator.pushNamed(context, '/record_vital_signs',
                  arguments: widget.patientId);
            },
          ),
        ],
      ),
      body: BlocBuilder<VitalSignsBloc, VitalSignsState>(
        builder: (context, state) {
          if (state is VitalSignsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VitalSignsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<VitalSignsBloc>()
                          .add(LoadVitalSignsHistory(widget.patientId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is VitalSignsHistoryLoaded) {
            if (state.vitalSignsHistory.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monitor_heart, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No vital signs recorded yet'),
                    SizedBox(height: 8),
                    Text('Tap the + button to record your first vital signs',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<VitalSignsBloc>()
                    .add(RefreshVitalSignsHistory(widget.patientId));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.vitalSignsHistory.length,
                itemBuilder: (context, index) {
                  final vitalSigns = state.vitalSignsHistory[index];
                  return Column(
                    children: [
                      VitalSignsCard(vitalSigns: vitalSigns),
                      if (index == 0) const SizedBox(height: 16),
                      if (index == 0)
                        VitalSignsChart(
                            vitalSignsHistory: state.vitalSignsHistory),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}
