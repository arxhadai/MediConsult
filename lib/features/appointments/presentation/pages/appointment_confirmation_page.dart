import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment.dart';

/// Page for confirming appointment details
class AppointmentConfirmationPage extends StatelessWidget {
  final Appointment appointment;

  const AppointmentConfirmationPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Confirmed'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Confirmation icon
            const Center(
              child: Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Confirmation message
            const Center(
              child: Text(
                'Appointment Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            const Center(
              child: Text(
                'Your appointment has been successfully booked',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Appointment details card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointment Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Doctor name
                    _buildDetailRow(
                      icon: Icons.person,
                      label: 'Doctor',
                      value: appointment.doctorName,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Specialty
                    _buildDetailRow(
                      icon: Icons.medical_services,
                      label: 'Specialty',
                      value: appointment.doctorSpecialty,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Date and time
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      label: 'Date & Time',
                      value: DateFormat('EEEE, MMMM d, yyyy \'at\' h:mm a')
                          .format(appointment.scheduledAt),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Consultation type
                    _buildDetailRow(
                      icon: Icons.video_call,
                      label: 'Type',
                      value: appointment.type.displayName,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Duration
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Duration',
                      value: '${appointment.durationMinutes} minutes',
                    ),
                    
                    if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      
                      // Notes
                      _buildDetailRow(
                        icon: Icons.note,
                        label: 'Notes',
                        value: appointment.notes!,
                      ),
                    ],
                    
                    const SizedBox(height: 12),
                    
                    // Status
                    _buildDetailRow(
                      icon: Icons.info,
                      label: 'Status',
                      value: appointment.status.displayName,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to appointments list
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Add to calendar functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding to calendar functionality coming soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Calendar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}