import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:mediconsult/features/prescriptions/domain/entities/prescription.dart';
import 'package:mediconsult/features/prescriptions/data/services/prescription_pdf_service.dart';

class PrescriptionPdfPreviewPage extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionPdfPreviewPage({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printPrescription(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePrescription(context),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        allowSharing: false,
        allowPrinting: false,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdfService = PrescriptionPdfService();
    final filePath = await pdfService.generatePrescriptionPdf(prescription);
    final file = File(filePath);
    return await file.readAsBytes();
  }

  Future<void> _printPrescription(BuildContext context) async {
    try {
      await Printing.layoutPdf(
        onLayout: _generatePdf,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error printing: $e')),
        );
      }
    }
  }

  Future<void> _sharePrescription(BuildContext context) async {
    try {
      await _generatePdf(PdfPageFormat.a4);
      // TODO: Implement sharing functionality
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share functionality not implemented yet')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: $e')),
        );
      }
    }
  }
}