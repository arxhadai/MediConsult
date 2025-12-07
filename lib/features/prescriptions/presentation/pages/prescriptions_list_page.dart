import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/prescription_list/prescription_list_bloc.dart';
import '../bloc/prescription_list/prescription_list_event.dart';
import '../bloc/prescription_list/prescription_list_state.dart';
import '../widgets/prescription_card.dart';

class PrescriptionsListPage extends StatefulWidget {
  final String patientId;

  const PrescriptionsListPage({super.key, required this.patientId});

  @override
  State<PrescriptionsListPage> createState() => _PrescriptionsListPageState();
}

class _PrescriptionsListPageState extends State<PrescriptionsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<PrescriptionListBloc>().add(LoadPrescriptions(widget.patientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Prescriptions'),
        centerTitle: true,
      ),
      body: BlocBuilder<PrescriptionListBloc, PrescriptionListState>(
        builder: (context, state) {
          if (state is PrescriptionListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrescriptionListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<PrescriptionListBloc>()
                          .add(LoadPrescriptions(widget.patientId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is PrescriptionListLoaded) {
            if (state.prescriptions.isEmpty) {
              return const Center(
                child: Text('No prescriptions found'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<PrescriptionListBloc>()
                    .add(RefreshPrescriptions(widget.patientId));
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = state.prescriptions[index];
                  return PrescriptionCard(prescription: prescription);
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