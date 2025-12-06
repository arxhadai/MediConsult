import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';
import '../../domain/entities/appointment.dart';

/// Page for the waiting room experience
class WaitingRoomPage extends StatefulWidget {
  final String appointmentId;
  final String patientId;
  final Appointment appointment;

  const WaitingRoomPage({
    super.key,
    required this.appointmentId,
    required this.patientId,
    required this.appointment,
  });

  @override
  State<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends State<WaitingRoomPage> {
  int _position = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    // Join the waiting room
    context.read<AppointmentBloc>().add(
          WaitingRoomJoinRequested(
            widget.appointmentId,
            widget.patientId,
          ),
        );
    
    // Start polling for position updates
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _updatePosition();
    });
    
    // Initial position check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePosition();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    // Leave the waiting room
    context.read<AppointmentBloc>().add(
          WaitingRoomLeaveRequested(
            widget.appointmentId,
            widget.patientId,
          ),
        );
    super.dispose();
  }

  void _updatePosition() {
    context.read<AppointmentBloc>().add(
          WaitingRoomPositionRequested(
            widget.appointmentId,
            widget.patientId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _updatePosition,
          ),
        ],
      ),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is WaitingRoomState) {
            setState(() {
              _position = state.position;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor information
              _buildDoctorInfo(),
              
              const SizedBox(height: 32),
              
              // Waiting status
              _buildWaitingStatus(),
              
              const SizedBox(height: 32),
              
              // Position indicator
              _buildPositionIndicator(),
              
              const SizedBox(height: 32),
              
              // Estimated wait time
              _buildEstimatedWaitTime(),
              
              const Spacer(),
              
              // Leave waiting room button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _leaveWaitingRoom,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.red),
                  ),
                  child: const Text(
                    'Leave Waiting Room',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Doctor avatar
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: const Icon(Icons.person, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.appointment.doctorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.appointment.doctorSpecialty,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaitingStatus() {
    return const Column(
      children: [
        Icon(
          Icons.hourglass_bottom,
          size: 60,
          color: Colors.orange,
        ),
        SizedBox(height: 16),
        Text(
          'You are in the waiting room',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please wait for the doctor to call you',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildPositionIndicator() {
    return Column(
      children: [
        const Text(
          'Your Position',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
          child: Center(
            child: Text(
              _position > 0 ? '$_position' : '-',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'patients ahead',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEstimatedWaitTime() {
    // Estimate wait time based on position (assuming 15 mins per patient)
    final estimatedMinutes = _position * 15;
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Estimated Wait Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              estimatedMinutes > 0
                  ? '$estimatedMinutes minutes'
                  : 'Soon',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _leaveWaitingRoom() {
    context.read<AppointmentBloc>().add(
          WaitingRoomLeaveRequested(
            widget.appointmentId,
            widget.patientId,
          ),
        );
    
    Navigator.of(context).pop();
  }
}