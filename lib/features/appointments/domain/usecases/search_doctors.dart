import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_schedule.dart';
import '../repositories/appointments_repository.dart';

/// Use case for searching doctors
class SearchDoctors {
  final AppointmentsRepository _repository;

  SearchDoctors(this._repository);

  /// Execute the use case
  Future<Either<Failure, List<DoctorSchedule>>> call(SearchDoctorsParams params) {
    return _repository.searchDoctors(
      specialty: params.specialty,
      name: params.name,
      limit: params.limit,
    );
  }
}

/// Parameters for searching doctors
class SearchDoctorsParams extends Equatable {
  final String? specialty;
  final String? name;
  final int limit;

  const SearchDoctorsParams({
    this.specialty,
    this.name,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [specialty, name, limit];
}
