import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/enums/record_category.dart';
import '../models/health_document_model.dart';
import '../models/vital_signs_model.dart';
import 'medical_records_remote_datasource.dart';

@LazySingleton(as: MedicalRecordsRemoteDataSource)
class MedicalRecordsRemoteDataSourceImpl
    implements MedicalRecordsRemoteDataSource {
  final FirebaseFirestore _firestore;

  MedicalRecordsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<Either<String, void>> uploadDocument(
      HealthDocumentModel document) async {
    try {
      // Upload document metadata to Firestore
      await _firestore
          .collection('patients')
          .doc(document.patientId)
          .collection('medical_records')
          .doc(document.id)
          .set(document.toJson());

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } on DioException catch (e) {
      return Left('Network error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, List<HealthDocumentModel>>> getAllDocuments(
      String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('medical_records')
          .orderBy('uploadedAt', descending: true)
          .get();

      final documents = snapshot.docs
          .map((doc) => HealthDocumentModel.fromJson(doc.data()))
          .toList();

      return Right(documents);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, HealthDocumentModel>> getDocumentById(String id) async {
    try {
      // This would typically require patientId as well for security
      // For simplicity, assuming we have a way to query by document ID
      final snapshot = await _firestore
          .collectionGroup('medical_records')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Left('Document not found');
      }

      final document = HealthDocumentModel.fromJson(snapshot.docs.first.data());
      return Right(document);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, List<HealthDocumentModel>>> getDocumentsByCategory(
      String patientId, RecordCategory category) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('medical_records')
          .where('category', isEqualTo: category.name)
          .orderBy('documentDate', descending: true)
          .get();

      final documents = snapshot.docs
          .map((doc) => HealthDocumentModel.fromJson(doc.data()))
          .toList();

      return Right(documents);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteDocument(String id) async {
    try {
      // This would typically require patientId as well for security
      // For simplicity, assuming we have a way to query by document ID
      final snapshot = await _firestore
          .collectionGroup('medical_records')
          .where('id', isEqualTo: id)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
      }

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> shareDocumentWithDoctor(
      String documentId, String doctorId) async {
    try {
      // This would typically require patientId as well for security
      // For simplicity, assuming we have a way to query by document ID
      final snapshot = await _firestore
          .collectionGroup('medical_records')
          .where('id', isEqualTo: documentId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Left('Document not found');
      }

      // Update document with shared doctor ID
      final docRef = snapshot.docs.first.reference;
      final documentData = snapshot.docs.first.data();

      // Add doctor to sharedWithDoctorIds array
      final sharedWith =
          List<String>.from(documentData['sharedWithDoctorIds'] ?? []);
      if (!sharedWith.contains(doctorId)) {
        sharedWith.add(doctorId);
        await docRef.update({'sharedWithDoctorIds': sharedWith});
      }

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> revokeDocumentAccess(
      String documentId, String doctorId) async {
    try {
      // This would typically require patientId as well for security
      // For simplicity, assuming we have a way to query by document ID
      final snapshot = await _firestore
          .collectionGroup('medical_records')
          .where('id', isEqualTo: documentId)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Left('Document not found');
      }

      // Update document by removing doctor from sharedWithDoctorIds array
      final docRef = snapshot.docs.first.reference;
      final documentData = snapshot.docs.first.data();

      // Remove doctor from sharedWithDoctorIds array
      final sharedWith =
          List<String>.from(documentData['sharedWithDoctorIds'] ?? []);
      sharedWith.remove(doctorId);
      await docRef.update({'sharedWithDoctorIds': sharedWith});

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, void>> recordVitalSigns(
      VitalSignsModel vitalSigns) async {
    try {
      await _firestore
          .collection('patients')
          .doc(vitalSigns.patientId)
          .collection('vital_signs')
          .doc(vitalSigns.id)
          .set(vitalSigns.toJson());

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, List<VitalSignsModel>>> getVitalSignsHistory(
      String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('vital_signs')
          .orderBy('recordedAt', descending: true)
          .get();

      final vitalSigns = snapshot.docs
          .map((doc) => VitalSignsModel.fromJson(doc.data()))
          .toList();

      return Right(vitalSigns);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

  @override
  Future<Either<String, VitalSignsModel>> getLatestVitalSigns(
      String patientId) async {
    try {
      final snapshot = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('vital_signs')
          .orderBy('recordedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return const Left('No vital signs recorded');
      }

      final vitalSigns = VitalSignsModel.fromJson(snapshot.docs.first.data());
      return Right(vitalSigns);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
}
