import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/doctor_schedule.dart';
import '../widgets/doctor_card.dart';

/// Page for finding and searching doctors
class FindDoctorsPage extends StatefulWidget {
  const FindDoctorsPage({super.key});

  @override
  State<FindDoctorsPage> createState() => _FindDoctorsPageState();
}

class _FindDoctorsPageState extends State<FindDoctorsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';

  @override
  void initState() {
    super.initState();
    // Load all doctors initially
    context.read<BookingBloc>().add(const DoctorSearchRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Doctors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<BookingBloc>()
                          .add(const DoctorSearchRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is DoctorsLoaded) {
            return _buildDoctorList(state.doctors);
          }

          return const Center(child: Text('No doctors found'));
        },
      ),
    );
  }

  Widget _buildDoctorList(List<DoctorSchedule> doctors) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return DoctorCard(
          doctor: doctors[index],
          onTap: () {
            // Navigate to doctor detail page
            // For now, we'll just show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('View details for ${doctors[index].doctorName}'),
              ),
            );
          },
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Doctors'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  hintText: 'Enter doctor name',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedSpecialty,
                decoration: const InputDecoration(
                  labelText: 'Specialty',
                ),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('All Specialties')),
                  DropdownMenuItem(value: 'Cardiology', child: Text('Cardiology')),
                  DropdownMenuItem(value: 'Dermatology', child: Text('Dermatology')),
                  DropdownMenuItem(value: 'Neurology', child: Text('Neurology')),
                  DropdownMenuItem(value: 'Orthopedics', child: Text('Orthopedics')),
                  DropdownMenuItem(value: 'Pediatrics', child: Text('Pediatrics')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSpecialty = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BookingBloc>().add(
                      DoctorSearchRequested(
                        specialty: _selectedSpecialty == 'All'
                            ? null
                            : _selectedSpecialty,
                        name: _searchController.text.isEmpty
                            ? null
                            : _searchController.text,
                      ),
                    );
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}