import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment.dart';
import '../../domain/enums/appointment_status.dart';
import '../../domain/enums/consultation_type.dart';

/// Widget for displaying appointment information in a card format
class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isDoctor;
  final VoidCallback? onCancel;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isDoctor,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with doctor/patient info
            _buildHeader(context),
            
            const SizedBox(height: 12),
            
            // Date and time
            _buildDateTimeInfo(),
            
            const SizedBox(height: 12),
            
            // Status badge
            _buildStatusBadge(),
            
            const SizedBox(height: 12),
            
            // Consultation type
            _buildConsultationType(),
            
            const SizedBox(height: 16),
            
            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Avatar placeholder
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.person, size: 25),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDoctor ? appointment.doctorName : appointment.doctorName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isDoctor ? appointment.doctorSpecialty : appointment.doctorSpecialty,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeInfo() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(appointment.scheduledAt),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor = Colors.white;
    
    switch (appointment.status) {
      case AppointmentStatus.pending:
        backgroundColor = Colors.orange;
        break;
      case AppointmentStatus.confirmed:
        backgroundColor = Colors.green;
        break;
      case AppointmentStatus.cancelled:
        backgroundColor = Colors.red;
        break;
      case AppointmentStatus.completed:
        backgroundColor = Colors.blue;
        break;
      case AppointmentStatus.rescheduled:
        backgroundColor = Colors.purple;
        break;
      default:
        backgroundColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        appointment.status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildConsultationType() {
    IconData icon;
    String typeText;
    
    switch (appointment.type) {
      case ConsultationType.video:
        icon = Icons.videocam;
        typeText = 'Video Call';
        break;
      case ConsultationType.voice:
        icon = Icons.phone;
        typeText = 'Voice Call';
        break;
      case ConsultationType.chat:
        icon = Icons.chat;
        typeText = 'Chat';
        break;
      case ConsultationType.inPerson:
        icon = Icons.person;
        typeText = 'In-Person';
        break;
    }
    
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          typeText,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Join/Start button (for active appointments)
        if (appointment.status == AppointmentStatus.confirmed)
          ElevatedButton(
            onPressed: () {
              // Navigate to video call or chat
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Join consultation functionality coming soon'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isDoctor ? 'Start Consultation' : 'Join Consultation',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        // Cancel button (for patients, only for pending/confirmed appointments)
        if (!isDoctor &&
            onCancel != null &&
            (appointment.status == AppointmentStatus.pending ||
                appointment.status == AppointmentStatus.confirmed))
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
      ],
    );
  }
}