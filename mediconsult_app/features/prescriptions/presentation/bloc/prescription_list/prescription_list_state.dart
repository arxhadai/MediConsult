import 'package:equatable/equatable.dart';

/// Base class for all prescription list states
abstract class PrescriptionListState extends Equatable {
  const PrescriptionListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PrescriptionListInitial extends PrescriptionListState {}

/// Loading state
class PrescriptionListLoading extends PrescriptionListState {}

/// Loaded state with prescriptions
class PrescriptionListLoaded extends PrescriptionListState {
  final List<dynamic> prescriptions;

  const PrescriptionListLoaded(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

/// Error state
class PrescriptionListError extends PrescriptionListState {
  final String message;

  const PrescriptionListError(this.message);

  @override
  List<Object?> get props => [message];
}