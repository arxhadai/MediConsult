import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/health_document_model.dart';
import '../models/vital_signs_model.dart';
import '../../domain/enums/record_category.dart';
import 'medical_records_local_datasource.dart';

@LazySingleton(as: MedicalRecordsLocalDataSource)
class MedicalRecordsLocalDataSourceImpl
    implements MedicalRecordsLocalDataSource {
  final SharedPreferences _prefs;

  // Storage keys
  static const String _keyDocuments = 'medical_records_documents';
  static const String _keyVitalSigns = 'medical_records_vital_signs';

  MedicalRecordsLocalDataSourceImpl({required SharedPreferences prefs})
      : _prefs = prefs;

  @override
  Future<void> cacheDocument(HealthDocumentModel document) async {
    final documents = await getCachedDocuments(document.patientId);

    // Remove existing document with same ID if it exists
    documents.removeWhere((doc) => doc.id == document.id);

    // Add the new document
    documents.add(document);

    // Save to shared preferences
    final jsonString = jsonEncode(
      documents.map((doc) => doc.toJson()).toList(),
    );
    await _prefs.setString(
        '${_keyDocuments}_${document.patientId}', jsonString);
  }

  @override
  Future<HealthDocumentModel?> getCachedDocument(String id) async {
    // We need patientId to get the right cache, so we'll need to search all patient caches
    // This is a simplified implementation - in a real app, you'd store document IDs separately
    final keys = _prefs.getKeys().where((key) => key.startsWith(_keyDocuments));

    for (final key in keys) {
      final documents = await _getCachedDocumentsByKey(key);
      for (final doc in documents) {
        if (doc.id == id) {
          return doc;
        }
      }
    }

    return null;
  }

  @override
  Future<List<HealthDocumentModel>> getCachedDocuments(String patientId) async {
    return _getCachedDocumentsByKey('${_keyDocuments}_$patientId');
  }

  Future<List<HealthDocumentModel>> _getCachedDocumentsByKey(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) =>
              HealthDocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<List<HealthDocumentModel>> getCachedDocumentsByCategory(
      String patientId, RecordCategory category) async {
    final documents = await getCachedDocuments(patientId);
    return documents.where((doc) => doc.category == category).toList();
  }

  @override
  Future<void> deleteCachedDocument(String id) async {
    // We need to find and remove the document from all patient caches
    final keys = _prefs.getKeys().where((key) => key.startsWith(_keyDocuments));

    for (final key in keys) {
      final documents = await _getCachedDocumentsByKey(key);
      final filteredDocuments = documents.where((doc) => doc.id != id).toList();

      if (filteredDocuments.length != documents.length) {
        // Document was found and removed
        if (filteredDocuments.isEmpty) {
          await _prefs.remove(key);
        } else {
          final jsonString = jsonEncode(
            filteredDocuments.map((doc) => doc.toJson()).toList(),
          );
          await _prefs.setString(key, jsonString);
        }
      }
    }
  }

  @override
  Future<void> clearCachedDocuments() async {
    final keys =
        _prefs.getKeys().where((key) => key.startsWith(_keyDocuments)).toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  @override
  Future<void> cacheVitalSigns(VitalSignsModel vitalSigns) async {
    final vitalSignsList =
        await getCachedVitalSignsHistory(vitalSigns.patientId);

    // Remove existing vital signs with same ID if it exists
    vitalSignsList.removeWhere((vs) => vs.id == vitalSigns.id);

    // Add the new vital signs
    vitalSignsList.add(vitalSigns);

    // Save to shared preferences
    final jsonString = jsonEncode(
      vitalSignsList.map((vs) => vs.toJson()).toList(),
    );
    await _prefs.setString(
        '${_keyVitalSigns}_${vitalSigns.patientId}', jsonString);
  }

  @override
  Future<List<VitalSignsModel>> getCachedVitalSignsHistory(
      String patientId) async {
    final jsonString = _prefs.getString('${_keyVitalSigns}_$patientId');
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => VitalSignsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  @override
  Future<VitalSignsModel?> getLatestCachedVitalSigns(String patientId) async {
    final vitalSignsList = await getCachedVitalSignsHistory(patientId);
    if (vitalSignsList.isEmpty) return null;

    // Sort by recordedAt descending and return the first (latest)
    vitalSignsList.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return vitalSignsList.first;
  }

  @override
  Future<void> clearCachedVitalSigns() async {
    final keys = _prefs
        .getKeys()
        .where((key) => key.startsWith(_keyVitalSigns))
        .toList();
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
