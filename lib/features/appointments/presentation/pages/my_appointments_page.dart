import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';
import '../../domain/entities/appointment.dart';
import '../widgets/appointment_card.dart';

/// Page for viewing user's appointments
class MyAppointmentsPage extends StatefulWidget {
  final String userId;
  final bool isDoctor;

  const MyAppointmentsPage({
    super.key,
    required this.userId,
    required this.isDoctor,
  });

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load appointments based on user type
    if (widget.isDoctor) {
      context
          .read<AppointmentBloc>()
          .add(DoctorAppointmentsLoadRequested(widget.userId));
    } else {
      context
          .read<AppointmentBloc>()
          .add(AppointmentsLoadRequested(widget.userId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming appointments
          _buildAppointmentsList(false),
          
          // Appointment history
          _buildAppointmentsList(true),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(bool isHistory) {
    // For history tab, we need to load history specifically
    if (isHistory && !widget.isDoctor) {
      return BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AppointmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AppointmentBloc>()
                          .add(AppointmentHistoryLoadRequested(widget.userId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is AppointmentsLoaded && state.isHistory) {
            if (state.appointments.isEmpty) {
              return const Center(
                child: Text(
                  'No appointment history',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.appointments.length,
              itemBuilder: (context, index) {
                return AppointmentCard(
                  appointment: state.appointments[index],
                  isDoctor: widget.isDoctor,
                  onCancel: widget.isDoctor
                      ? null
                      : () {
                          _cancelAppointment(state.appointments[index]);
                        },
                );
              },
            );
          }

          // Load history if not already loaded
          if (!(state is AppointmentsLoaded && state.isHistory)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context
                  .read<AppointmentBloc>()
                  .add(AppointmentHistoryLoadRequested(widget.userId));
            });
          }

          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    // For upcoming appointments or doctor appointments
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AppointmentError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.isDoctor) {
                      context.read<AppointmentBloc>().add(
                            DoctorAppointmentsLoadRequested(widget.userId),
                          );
                    } else {
                      context.read<AppointmentBloc>().add(
                            AppointmentsLoadRequested(widget.userId),
                          );
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<Appointment> appointments = [];
        if (state is AppointmentsLoaded && !state.isHistory) {
          appointments = state.appointments;
        } else if (state is DoctorAppointmentsLoaded) {
          appointments = state.appointments;
        }

        if (appointments.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No upcoming appointments',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Book an appointment to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return AppointmentCard(
              appointment: appointments[index],
              isDoctor: widget.isDoctor,
              onCancel: widget.isDoctor
                  ? null
                  : () {
                      _cancelAppointment(appointments[index]);
                    },
            );
          },
        );
      },
    );
  }

  void _cancelAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text(
            'Are you sure you want to cancel this appointment?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AppointmentBloc>().add(
                      AppointmentCancelRequested(
                        appointment.id,
                        widget.userId,
                      ),
                    );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }
}