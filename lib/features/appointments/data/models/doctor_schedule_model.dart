import '../../domain/entities/doctor_schedule.dart';

/// Data model for DoctorSchedule entity with JSON serialization
class DoctorScheduleModel extends DoctorSchedule {
  const DoctorScheduleModel({
    required super.doctorId,
    required super.doctorName,
    required super.specialty,
    super.photoUrl,
    required super.rating,
    required super.yearsOfExperience,
    required super.workingHours,
    required super.qualifications,
    super.bio,
    required super.createdAt,
  });

  /// Create DoctorScheduleModel from JSON map
  factory DoctorScheduleModel.fromJson(Map<String, dynamic> json) {
    return DoctorScheduleModel(
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      photoUrl: json['photoUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      yearsOfExperience: json['yearsOfExperience'] as int,
      workingHours: (json['workingHours'] as List<dynamic>)
          .map((e) => WorkingHoursModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialty': specialty,
      'photoUrl': photoUrl,
      'rating': rating,
      'yearsOfExperience': yearsOfExperience,
      'workingHours': workingHours.map((e) => (e as WorkingHoursModel).toJson()).toList(),
      'qualifications': qualifications,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create DoctorScheduleModel from DoctorSchedule entity
  factory DoctorScheduleModel.fromEntity(DoctorSchedule schedule) {
    return DoctorScheduleModel(
      doctorId: schedule.doctorId,
      doctorName: schedule.doctorName,
      specialty: schedule.specialty,
      photoUrl: schedule.photoUrl,
      rating: schedule.rating,
      yearsOfExperience: schedule.yearsOfExperience,
      workingHours: schedule.workingHours,
      qualifications: schedule.qualifications,
      bio: schedule.bio,
      createdAt: schedule.createdAt,
    );
  }

  /// Convert to DoctorSchedule entity
  DoctorSchedule toEntity() {
    return DoctorSchedule(
      doctorId: doctorId,
      doctorName: doctorName,
      specialty: specialty,
      photoUrl: photoUrl,
      rating: rating,
      yearsOfExperience: yearsOfExperience,
      workingHours: workingHours,
      qualifications: qualifications,
      bio: bio,
      createdAt: createdAt,
    );
  }

  /// Create copy with updated fields
  @override
  DoctorScheduleModel copyWith({
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
    return DoctorScheduleModel(
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
}

/// Data model for WorkingHours with JSON serialization
class WorkingHoursModel extends WorkingHours {
  const WorkingHoursModel({
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.breakTimes,
  });

  /// Create WorkingHoursModel from JSON map
  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      dayOfWeek: json['dayOfWeek'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      breakTimes: (json['breakTimes'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'breakTimes': breakTimes,
    };
  }

  /// Create WorkingHoursModel from WorkingHours entity
  factory WorkingHoursModel.fromEntity(WorkingHours hours) {
    return WorkingHoursModel(
      dayOfWeek: hours.dayOfWeek,
      startTime: hours.startTime,
      endTime: hours.endTime,
      breakTimes: hours.breakTimes,
    );
  }

  /// Convert to WorkingHours entity
  WorkingHours toEntity() {
    return WorkingHours(
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      breakTimes: breakTimes,
    );
  }
}
