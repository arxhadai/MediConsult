import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/enums/consultation_type.dart';

/// Page for booking an appointment with a doctor
class BookAppointmentPage extends StatefulWidget {
  final String doctorId;
  final String patientId;

  const BookAppointmentPage({
    super.key,
    required this.doctorId,
    required this.patientId,
  });

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedTimeSlot;
  ConsultationType _selectedConsultationType = ConsultationType.video;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load available time slots for today
    _loadTimeSlotsForDate(_selectedDate);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _loadTimeSlotsForDate(DateTime date) {
    context.read<BookingBloc>().add(
          TimeSlotsLoadRequested(widget.doctorId, date),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            _buildDatePicker(),
            
            const SizedBox(height: 24),
            
            // Time slots
            _buildTimeSlots(),
            
            const SizedBox(height: 24),
            
            // Consultation type
            _buildConsultationTypeSelector(),
            
            const SizedBox(height: 24),
            
            // Notes
            _buildNotesField(),
            
            const SizedBox(height: 32),
            
            // Book button
            _buildBookButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 14, // Show next 14 days
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _isSelectedDate(date);
              
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                      _selectedTimeSlot = null; // Reset time slot selection
                    });
                    _loadTimeSlotsForDate(date);
                  },
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          DateFormat('dd').format(date),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TimeSlotsLoaded) {
          final availableSlots = state.timeSlots
              .where((slot) => slot.isAvailable)
              .toList();

          if (availableSlots.isEmpty) {
            return const Center(
              child: Text(
                'No available time slots for this date',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Time',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableSlots.map((slot) {
                  final isSelected = _selectedTimeSlot?.id == slot.id;
                  
                  return ChoiceChip(
                    label: Text(
                      DateFormat('hh:mm a').format(slot.startTime),
                      style: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimeSlot = selected ? slot : null;
                      });
                    },
                    selectedColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
            ],
          );
        }

        if (state is BookingError) {
          return Center(
            child: Column(
              children: [
                Text(state.message),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _loadTimeSlotsForDate(_selectedDate),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return const Center(child: Text('Loading time slots...'));
      },
    );
  }

  Widget _buildConsultationTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation Type',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<ConsultationType>(
          segments: const [
            ButtonSegment(
              value: ConsultationType.video,
              label: Text('Video'),
              icon: Icon(Icons.videocam),
            ),
            ButtonSegment(
              value: ConsultationType.voice,
              label: Text('Audio'),
              icon: Icon(Icons.phone),
            ),
            ButtonSegment(
              value: ConsultationType.chat,
              label: Text('Chat'),
              icon: Icon(Icons.chat),
            ),
          ],
          selected: {_selectedConsultationType},
          onSelectionChanged: (Set<ConsultationType> newSelection) {
            setState(() {
              _selectedConsultationType = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes (Optional)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Any specific concerns or symptoms...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _canBookAppointment() ? _bookAppointment : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _canBookAppointment() {
    return _selectedTimeSlot != null;
  }

  bool _isSelectedDate(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  void _bookAppointment() {
    if (_selectedTimeSlot == null) return;

    context.read<BookingBloc>().add(
          AppointmentBookingRequested(
            patientId: widget.patientId,
            doctorId: widget.doctorId,
            scheduledAt: _selectedTimeSlot!.startTime,
            durationMinutes: 30, // Default duration
            type: _selectedConsultationType,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          ),
        );

    // Show confirmation or navigate to confirmation page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment booked successfully!'),
      ),
    );
    
    // Navigate back or to confirmation page
    Navigator.of(context).pop();
  }
}