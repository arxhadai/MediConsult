import 'package:equatable/equatable.dart';

/// Represents a doctor's schedule/availability
class DoctorSchedule extends Equatable {
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String? photoUrl;
  final double rating;
  final int yearsOfExperience;
  final List<WorkingHours> workingHours;
  final List<String> qualifications;
  final String? bio;
  final DateTime createdAt;

  const DoctorSchedule({
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    this.photoUrl,
    required this.rating,
    required this.yearsOfExperience,
    required this.workingHours,
    required this.qualifications,
    this.bio,
    required this.createdAt,
  });

  /// Check if doctor is available today
  bool get isAvailableToday {
    final today = DateTime.now().weekday;
    return workingHours.any((hours) => hours.dayOfWeek == today);
  }

  /// Get today's working hours
  WorkingHours? get todaysHours {
    final today = DateTime.now().weekday;
    try {
      return workingHours.firstWhere((hours) => hours.dayOfWeek == today);
    } catch (e) {
      return null;
    }
  }

  /// Create a copy with updated fields
  DoctorSchedule copyWith({
    String? doctorId,
    String? doctorName,
    String? specialty,
    String? photoUrl,
    double? rating,
    int? yearsOfExperience,
    List<WorkingHours>? workingHours,
    List<String>? qualifications,
    String? bio,
    DateTime? createdAt,
  }) {
    return DoctorSchedule(
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      photoUrl: photoUrl ?? this.photoUrl,
      rating: rating ?? this.rating,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      workingHours: workingHours ?? this.workingHours,
      qualifications: qualifications ?? this.qualifications,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        doctorId,
        doctorName,
        specialty,
        photoUrl,
        rating,
        yearsOfExperience,
        workingHours,
        qualifications,
        bio,
        createdAt,
      ];
}

/// Working hours for a specific day
class WorkingHours extends Equatable {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final DateTime startTime; // Time part only
  final DateTime endTime; // Time part only
  final List<String> breakTimes; // Time ranges when not available

  const WorkingHours({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.breakTimes,
  });

  /// Get day name
  String get dayName {
    switch (dayOfWeek) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object?> get props => [
        dayOfWeek,
        startTime,
        endTime,
        breakTimes,
      ];
}
