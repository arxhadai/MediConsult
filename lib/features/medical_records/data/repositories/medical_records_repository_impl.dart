import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/health_document.dart';
import '../../domain/entities/vital_signs.dart';
import '../../domain/enums/record_category.dart';
import '../../domain/repositories/medical_records_repository.dart';
import '../models/health_document_model.dart';
import '../models/vital_signs_model.dart';
import '../datasources/medical_records_remote_datasource.dart';
import '../datasources/medical_records_local_datasource.dart';

/// Implementation of MedicalRecordsRepository
@LazySingleton(as: MedicalRecordsRepository)
class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final MedicalRecordsRemoteDataSource _remoteDataSource;
  final MedicalRecordsLocalDataSource _localDataSource;

  MedicalRecordsRepositoryImpl({
    required MedicalRecordsRemoteDataSource remoteDataSource,
    required MedicalRecordsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, void>> uploadDocument(HealthDocument document) async {
    try {
      final documentModel = document as HealthDocumentModel;
      final result = await _remoteDataSource.uploadDocument(documentModel);

      return result.fold(
        (error) => Left(ServerFailure(error)),
        (success) async {
          // Cache the document locally
          await _localDataSource.cacheDocument(documentModel);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to upload document: $e'));
    }
  }

  @override
  Future<Either<Failure, List<HealthDocument>>> getAllDocuments(
      String patientId) async {
    try {
      // Try to get from remote first
      final result = await _remoteDataSource.getAllDocuments(patientId);

      return result.fold(
        (error) async {
          // If remote fails, try local cache
          final cachedDocuments =
              await _localDataSource.getCachedDocuments(patientId);
          return Right(cachedDocuments);
        },
        (documents) async {
          // Cache the documents locally
          for (final document in documents) {
            await _localDataSource.cacheDocument(document);
          }
          return Right(documents);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get documents: $e'));
    }
  }

  @override
  Future<Either<Failure, HealthDocument>> getDocumentById(String id) async {
    try {
      // Try to get from remote first
      final result = await _remoteDataSource.getDocumentById(id);

      return result.fold(
        (error) async {
          // If remote fails, try local cache
          final cachedDocument = await _localDataSource.getCachedDocument(id);
          if (cachedDocument != null) {
            return Right(cachedDocument);
          }
          return Left(ServerFailure(error));
        },
        (document) async {
          // Cache the document locally
          await _localDataSource.cacheDocument(document);
          return Right(document);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get document: $e'));
    }
  }

  @override
  Future<Either<Failure, List<HealthDocument>>> getDocumentsByCategory(
      String patientId, RecordCategory category) async {
    try {
      // Try to get from remote first
      final result =
          await _remoteDataSource.getDocumentsByCategory(patientId, category);

      return result.fold(
        (error) async {
          // If remote fails, try local cache
          final cachedDocuments = await _localDataSource
              .getCachedDocumentsByCategory(patientId, category);
          return Right(cachedDocuments);
        },
        (documents) async {
          // Cache the documents locally
          for (final document in documents) {
            await _localDataSource.cacheDocument(document);
          }
          return Right(documents);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get documents by category: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String id) async {
    try {
      final result = await _remoteDataSource.deleteDocument(id);

      return result.fold(
        (error) => Left(ServerFailure(error)),
        (success) async {
          // Also delete from local cache
          await _localDataSource.deleteCachedDocument(id);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to delete document: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> shareDocumentWithDoctor(
      String documentId, String doctorId) async {
    try {
      final result =
          await _remoteDataSource.shareDocumentWithDoctor(documentId, doctorId);

      return result.fold(
        (error) => Left(ServerFailure(error)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to share document: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> revokeDocumentAccess(
      String documentId, String doctorId) async {
    try {
      final result =
          await _remoteDataSource.revokeDocumentAccess(documentId, doctorId);

      return result.fold(
        (error) => Left(ServerFailure(error)),
        (success) => const Right(null),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to revoke document access: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> recordVitalSigns(VitalSigns vitalSigns) async {
    try {
      final vitalSignsModel = vitalSigns as VitalSignsModel;
      final result = await _remoteDataSource.recordVitalSigns(vitalSignsModel);

      return result.fold(
        (error) => Left(ServerFailure(error)),
        (success) async {
          // Cache the vital signs locally
          await _localDataSource.cacheVitalSigns(vitalSignsModel);
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to record vital signs: $e'));
    }
  }

  @override
  Future<Either<Failure, List<VitalSigns>>> getVitalSignsHistory(
      String patientId) async {
    try {
      // Try to get from remote first
      final result = await _remoteDataSource.getVitalSignsHistory(patientId);

      return result.fold(
        (error) async {
          // If remote fails, try local cache
          final cachedVitalSigns =
              await _localDataSource.getCachedVitalSignsHistory(patientId);
          return Right(cachedVitalSigns);
        },
        (vitalSigns) async {
          // Cache the vital signs locally
          for (final vs in vitalSigns) {
            await _localDataSource.cacheVitalSigns(vs);
          }
          return Right(vitalSigns);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get vital signs history: $e'));
    }
  }

  @override
  Future<Either<Failure, VitalSigns>> getLatestVitalSigns(
      String patientId) async {
    try {
      // Try to get from remote first
      final result = await _remoteDataSource.getLatestVitalSigns(patientId);

      return result.fold(
        (error) async {
          // If remote fails, try local cache
          final cachedVitalSigns =
              await _localDataSource.getLatestCachedVitalSigns(patientId);
          if (cachedVitalSigns != null) {
            return Right(cachedVitalSigns);
          }
          return Left(ServerFailure(error));
        },
        (vitalSigns) async {
          // Cache the vital signs locally
          await _localDataSource.cacheVitalSigns(vitalSigns);
          return Right(vitalSigns);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to get latest vital signs: $e'));
    }
  }
}
