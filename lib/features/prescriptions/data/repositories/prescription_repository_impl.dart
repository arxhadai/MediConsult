import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/prescription.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../models/prescription_model.dart';

/// Implementation of PrescriptionRepository
@LazySingleton(as: PrescriptionRepository)
class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final FirebaseFirestore _firestore;

  PrescriptionRepositoryImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<Either<Failure, Prescription>> createPrescription(
      Prescription prescription) async {
    try {
      final prescriptionModel = prescription as PrescriptionModel;
      await _firestore
          .collection('prescriptions')
          .doc(prescription.id)
          .set(prescriptionModel.toJson());

      return Right(prescription);
    } catch (e) {
      return Left(ServerFailure('Failed to create prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, Prescription>> getPrescriptionById(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('prescriptions').doc(id).get();

      if (!docSnapshot.exists) {
        return Left(ServerFailure('Prescription not found'));
      }

      final prescription = PrescriptionModel.fromJson({
        'id': docSnapshot.id,
        ...docSnapshot.data() as Map<String, dynamic>,
      });

      return Right(prescription);
    } catch (e) {
      return Left(ServerFailure('Failed to get prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Prescription>>> getPatientPrescriptions(
      String patientId) async {
    try {
      final querySnapshot = await _firestore
          .collection('prescriptions')
          .where('patientId', isEqualTo: patientId)
          .orderBy('prescribedDate', descending: true)
          .get();

      final prescriptions = querySnapshot.docs
          .map((doc) => PrescriptionModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      return Right(prescriptions);
    } catch (e) {
      return Left(ServerFailure('Failed to get patient prescriptions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Prescription>>> getConsultationPrescriptions(
      String consultationId) async {
    try {
      final querySnapshot = await _firestore
          .collection('prescriptions')
          .where('consultationId', isEqualTo: consultationId)
          .get();

      final prescriptions = querySnapshot.docs
          .map((doc) => PrescriptionModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      return Right(prescriptions);
    } catch (e) {
      return Left(
          ServerFailure('Failed to get consultation prescriptions: $e'));
    }
  }

  @override
  Future<Either<Failure, Prescription>> updatePrescription(
      Prescription prescription) async {
    try {
      final prescriptionModel = prescription as PrescriptionModel;
      await _firestore.collection('prescriptions').doc(prescription.id).update({
        ...prescriptionModel.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get updated prescription
      final updatedPrescription = await getPrescriptionById(prescription.id);
      return updatedPrescription;
    } catch (e) {
      return Left(ServerFailure('Failed to update prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrescription(String id) async {
    try {
      await _firestore.collection('prescriptions').doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> generatePrescriptionPdf(
      Prescription prescription) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Prescription',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Patient: ${prescription.patientName}'),
                pw.Text('Doctor: ${prescription.doctorName}'),
                pw.Text('Date: ${prescription.prescribedDate}'),
                pw.SizedBox(height: 20),
                pw.Text('Medications:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ...prescription.medications.map(
                  (med) => pw.Container(
                    margin: const pw.EdgeInsets.symmetric(vertical: 5),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(med.name,
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('${med.dosage} ${med.formDisplayText}'),
                        pw.Text(med.frequencyDisplayText),
                      ],
                    ),
                  ),
                ),
                if (prescription.notes != null) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Notes:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(prescription.notes!),
                ],
              ],
            );
          },
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = await pdf.save();
      final filePath = '${dir.path}/prescription_${prescription.id}.pdf';

      // Save file
      final ioFile = File(filePath);
      await ioFile.writeAsBytes(file);

      return Right(filePath);
    } catch (e) {
      return Left(ServerFailure('Failed to generate PDF: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sharePrescription(
      String prescriptionId, List<String> sharingMethods) async {
    try {
      // First get the prescription
      final prescriptionResult = await getPrescriptionById(prescriptionId);

      return prescriptionResult.fold(
        (failure) => Left(failure),
        (prescription) async {
          // Generate PDF
          final pdfResult = await generatePrescriptionPdf(prescription);

          return pdfResult.fold(
            (failure) => Left(failure),
            (filePath) async {
              // Share the file
              final file = XFile(filePath);
              await Share.shareXFiles([file]);
              return const Right(null);
            },
          );
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to share prescription: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setMedicationReminder(
      String prescriptionId, Medication medication) async {
    try {
      // In a real implementation, this would set up local notifications
      // For now, we'll just simulate the operation
      // ignore: avoid_print
      print('Setting reminder for medication: ${medication.name}');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to set medication reminder: $e'));
    }
  }

  @override
  Future<Either<Failure, Prescription>> requestRefill(
      String prescriptionId) async {
    try {
      // First get the prescription
      final prescriptionResult = await getPrescriptionById(prescriptionId);

      return prescriptionResult.fold(
        (failure) => Left(failure),
        (prescription) async {
          // Check if refill is allowed
          if (!prescription.canRefill) {
            return Left(
                ServerFailure('Refill not allowed for this prescription'));
          }

          // Update refill count
          final updatedPrescription = prescription.copyWith(
            refillsUsed: prescription.refillsUsed + 1,
            updatedAt: DateTime.now(),
          );

          // Save updated prescription
          final updateResult = await updatePrescription(updatedPrescription);
          return updateResult;
        },
      );
    } catch (e) {
      return Left(ServerFailure('Failed to request refill: $e'));
    }
  }
}
