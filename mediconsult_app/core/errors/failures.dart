import 'package:equatable/equatable.dart';

/// Base failure class for all application failures
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Failure for server-side errors
class ServerFailure extends Failure {
  final String message;
  
  ServerFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'ServerFailure: $message';
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  final String message;
  
  CacheFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'CacheFailure: $message';
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  final String message;
  
  NetworkFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'NetworkFailure: $message';
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final String message;
  
  ValidationFailure(this.message);
  
  @override
  List<Object?> get props => [message];
  
  @override
  String toString() => 'ValidationFailure: $message';
}