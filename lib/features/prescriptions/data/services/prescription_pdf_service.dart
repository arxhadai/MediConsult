import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/prescription.dart';
import '../../domain/entities/medication.dart';

/// Service for generating prescription PDFs
class PrescriptionPdfService {
  /// Generate a PDF for a prescription
  Future<String> generatePrescriptionPdf(Prescription prescription) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              _buildHeader(prescription),
              pw.SizedBox(height: 20),
              _buildPatientInfo(prescription),
              pw.SizedBox(height: 20),
              _buildDoctorInfo(prescription),
              pw.SizedBox(height: 30),
              _buildMedicationsSection(prescription.medications),
              if (prescription.notes != null && prescription.notes!.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                _buildNotesSection(prescription.notes!),
              ],
              if (prescription.diagnosis != null && prescription.diagnosis!.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                _buildDiagnosisSection(prescription.diagnosis!),
              ],
              pw.SizedBox(height: 30),
              _buildFooter(prescription),
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

    return filePath;
  }

  /// Build prescription header
  pw.Widget _buildHeader(Prescription prescription) {
    return pw.Column(
      children: [
        pw.Text(
          'PRESCRIPTION',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Medical Prescription Document',
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Divider(),
      ],
    );
  }

  /// Build patient information section
  pw.Widget _buildPatientInfo(Prescription prescription) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Patient Information',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Name: ${prescription.patientName}'),
                  if (prescription.patientAge != null)
                    pw.Text('Age: ${prescription.patientAge}'),
                  if (prescription.patientGender != null)
                    pw.Text('Gender: ${prescription.patientGender}'),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Date: ${prescription.prescribedDate.toString().split(' ')[0]}'),
                  if (prescription.validUntil != null)
                    pw.Text('Valid Until: ${prescription.validUntil.toString().split(' ')[0]}'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build doctor information section
  pw.Widget _buildDoctorInfo(Prescription prescription) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Doctor Information',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Name: ${prescription.doctorName}'),
        pw.Text('Specialization: ${prescription.doctorSpecialization}'),
        pw.Text('License: ${prescription.doctorLicenseNumber}'),
        if (prescription.clinicName != null)
          pw.Text('Clinic: ${prescription.clinicName}'),
        if (prescription.clinicAddress != null)
          pw.Text('Address: ${prescription.clinicAddress}'),
      ],
    );
  }

  /// Build medications section
  pw.Widget _buildMedicationsSection(List<Medication> medications) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Medications',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headers: ['Medicine', 'Dosage', 'Frequency', 'Duration'],
          data: medications
              .map((med) => [
                    med.name,
                    med.dosage,
                    med.frequencyDisplayText,
                    '${med.durationDays} days',
                  ])
              .toList(),
          border: null,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
            color: PdfColors.grey300,
          ),
          cellAlignment: pw.Alignment.centerLeft,
          cellPadding: const pw.EdgeInsets.all(5),
        ),
        pw.SizedBox(height: 15),
        pw.Column(
          children: medications
              .map((med) => _buildMedicationDetails(med))
              .toList(),
        ),
      ],
    );
  }

  /// Build detailed medication information
  pw.Widget _buildMedicationDetails(Medication medication) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            medication.name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('${medication.dosage} ${medication.formDisplayText}'),
              pw.Text(medication.frequencyDisplayText),
            ],
          ),
          if (medication.timings.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Text('Timing: ${medication.timingDisplayText}'),
          ],
          if (medication.instructions != null && medication.instructions!.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Text('Instructions: ${medication.instructions}'),
          ],
          if (medication.warnings != null && medication.warnings!.isNotEmpty) ...[
            pw.SizedBox(height: 5),
            pw.Text(
              'Warnings: ${medication.warnings}',
              style: const pw.TextStyle(color: PdfColors.red),
            ),
          ],
        ],
      ),
    );
  }

  /// Build notes section
  pw.Widget _buildNotesSection(String notes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Notes',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(notes),
      ],
    );
  }

  /// Build diagnosis section
  pw.Widget _buildDiagnosisSection(String diagnosis) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Diagnosis',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(diagnosis),
      ],
    );
  }

  /// Build footer with signature
  pw.Widget _buildFooter(Prescription prescription) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Refills: ${prescription.remainingRefills}'),
                if (prescription.refillsAllowed != null)
                  pw.Text('Allowed: ${prescription.refillsAllowed}'),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                if (prescription.doctorSignatureUrl != null) ...[
                  // Signature image would be loaded here
                  pw.SizedBox(height: 30),
                  pw.SizedBox(height: 5),
                ],
                pw.Text('Dr. ${prescription.doctorName}'),
                pw.Text('Signature'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}