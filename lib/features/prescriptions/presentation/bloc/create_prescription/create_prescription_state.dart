import 'package:equatable/equatable.dart';
import 'package:mediconsult/features/prescriptions/domain/entities/prescription.dart';

/// Base class for all create prescription states
abstract class CreatePrescriptionState extends Equatable {
  const CreatePrescriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CreatePrescriptionInitial extends CreatePrescriptionState {}

/// Loading state
class CreatePrescriptionLoading extends CreatePrescriptionState {}

/// Editing state with prescription details
class CreatePrescriptionEditing extends CreatePrescriptionState {
  final Prescription prescription;
  final bool isValid;

  const CreatePrescriptionEditing({
    required this.prescription,
    required this.isValid,
  });

  CreatePrescriptionEditing copyWith({
    Prescription? prescription,
    bool? isValid,
  }) {
    return CreatePrescriptionEditing(
      prescription: prescription ?? this.prescription,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [prescription, isValid];
}

/// Success state after saving
class CreatePrescriptionSuccess extends CreatePrescriptionState {
  final Prescription prescription;

  const CreatePrescriptionSuccess(this.prescription);

  @override
  List<Object?> get props => [prescription];
}

/// Error state
class CreatePrescriptionError extends CreatePrescriptionState {
  final String message;

  const CreatePrescriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
