import 'package:equatable/equatable.dart';

/// Dosage information for medications
class Dosage extends Equatable {
  final double amount;
  final String unit;

  const Dosage({
    required this.amount,
    required this.unit,
  });

  @override
  List<Object?> get props => [amount, unit];
}