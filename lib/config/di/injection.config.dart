// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as _i703;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:mediconsult/config/di/third_party_module.dart' as _i680;
import 'package:mediconsult/features/ai_features/data/datasources/gemini_ai_service.dart'
    as _i901;
import 'package:mediconsult/features/ai_features/data/datasources/gemini_ai_service_impl.dart'
    as _i1051;
import 'package:mediconsult/features/ai_features/data/datasources/speech_recognition_service.dart'
    as _i178;
import 'package:mediconsult/features/ai_features/data/datasources/speech_recognition_service_impl.dart'
    as _i646;
import 'package:mediconsult/features/ai_features/data/repositories/ai_repository_impl.dart'
    as _i125;
import 'package:mediconsult/features/ai_features/data/repositories/transcription_repository_impl.dart'
    as _i1024;
import 'package:mediconsult/features/ai_features/domain/repositories/ai_repository.dart'
    as _i297;
import 'package:mediconsult/features/ai_features/domain/repositories/transcription_repository.dart'
    as _i797;
import 'package:mediconsult/features/ai_features/domain/usecases/analyze_symptoms.dart'
    as _i957;
import 'package:mediconsult/features/ai_features/domain/usecases/check_drug_interactions.dart'
    as _i51;
import 'package:mediconsult/features/ai_features/domain/usecases/generate_summary.dart'
    as _i228;
import 'package:mediconsult/features/ai_features/domain/usecases/send_chat_message.dart'
    as _i199;
import 'package:mediconsult/features/ai_features/domain/usecases/start_transcription.dart'
    as _i774;
import 'package:mediconsult/features/ai_features/domain/usecases/stop_transcription.dart'
    as _i354;
import 'package:mediconsult/features/ai_features/presentation/bloc/summary/summary_bloc.dart'
    as _i247;
import 'package:mediconsult/features/ai_features/presentation/bloc/symptom_checker/symptom_checker_bloc.dart'
    as _i878;
import 'package:mediconsult/features/ai_features/presentation/bloc/transcription/transcription_bloc.dart'
    as _i128;
import 'package:mediconsult/features/appointments/data/datasources/appointments_local_datasource.dart'
    as _i584;
import 'package:mediconsult/features/appointments/data/datasources/appointments_local_datasource_impl.dart'
    as _i648;
import 'package:mediconsult/features/appointments/data/datasources/appointments_remote_datasource.dart'
    as _i387;
import 'package:mediconsult/features/appointments/data/datasources/appointments_remote_datasource_impl.dart'
    as _i108;
import 'package:mediconsult/features/appointments/data/repositories/appointments_repository_impl.dart'
    as _i702;
import 'package:mediconsult/features/appointments/domain/repositories/appointments_repository.dart'
    as _i563;
import 'package:mediconsult/features/appointments/presentation/bloc/appointment_bloc.dart'
    as _i584;
import 'package:mediconsult/features/appointments/presentation/bloc/booking_bloc.dart'
    as _i304;
import 'package:mediconsult/features/auth/data/datasources/auth_local_datasource.dart'
    as _i750;
import 'package:mediconsult/features/auth/data/datasources/auth_local_datasource_impl.dart'
    as _i372;
import 'package:mediconsult/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i749;
import 'package:mediconsult/features/auth/data/datasources/auth_remote_datasource_impl.dart'
    as _i985;
import 'package:mediconsult/features/auth/data/repositories/auth_repository_impl.dart'
    as _i864;
import 'package:mediconsult/features/auth/domain/repositories/auth_repository.dart'
    as _i392;
import 'package:mediconsult/features/auth/domain/usecases/authenticate_biometric.dart'
    as _i638;
import 'package:mediconsult/features/auth/domain/usecases/check_auth_status.dart'
    as _i864;
import 'package:mediconsult/features/auth/domain/usecases/enable_biometric.dart'
    as _i765;
import 'package:mediconsult/features/auth/domain/usecases/get_current_user.dart'
    as _i743;
import 'package:mediconsult/features/auth/domain/usecases/reset_password.dart'
    as _i821;
import 'package:mediconsult/features/auth/domain/usecases/sign_in_with_email.dart'
    as _i975;
import 'package:mediconsult/features/auth/domain/usecases/sign_in_with_google.dart'
    as _i730;
import 'package:mediconsult/features/auth/domain/usecases/sign_in_with_phone.dart'
    as _i27;
import 'package:mediconsult/features/auth/domain/usecases/sign_out.dart'
    as _i178;
import 'package:mediconsult/features/auth/domain/usecases/sign_up_with_email.dart'
    as _i473;
import 'package:mediconsult/features/auth/domain/usecases/update_profile.dart'
    as _i902;
import 'package:mediconsult/features/auth/domain/usecases/verify_otp.dart'
    as _i160;
import 'package:mediconsult/features/auth/presentation/bloc/auth/auth_bloc.dart'
    as _i521;
import 'package:mediconsult/features/auth/presentation/bloc/login/login_bloc.dart'
    as _i393;
import 'package:mediconsult/features/auth/presentation/bloc/registration/registration_bloc.dart'
    as _i609;
import 'package:mediconsult/features/consultation/domain/usecases/start_consultation_with_ai.dart'
    as _i532;
import 'package:mediconsult/features/medical_records/data/datasources/medical_records_local_datasource.dart'
    as _i540;
import 'package:mediconsult/features/medical_records/data/datasources/medical_records_local_datasource_impl.dart'
    as _i1002;
import 'package:mediconsult/features/medical_records/data/datasources/medical_records_remote_datasource.dart'
    as _i483;
import 'package:mediconsult/features/medical_records/data/datasources/medical_records_remote_datasource_impl.dart'
    as _i503;
import 'package:mediconsult/features/medical_records/data/repositories/medical_records_repository_impl.dart'
    as _i196;
import 'package:mediconsult/features/medical_records/domain/repositories/medical_records_repository.dart'
    as _i642;
import 'package:mediconsult/features/medical_records/domain/usecases/delete_document.dart'
    as _i261;
import 'package:mediconsult/features/medical_records/domain/usecases/get_all_documents.dart'
    as _i393;
import 'package:mediconsult/features/medical_records/domain/usecases/get_documents_by_category.dart'
    as _i371;
import 'package:mediconsult/features/medical_records/domain/usecases/get_latest_vital_signs.dart'
    as _i44;
import 'package:mediconsult/features/medical_records/domain/usecases/get_vital_signs_history.dart'
    as _i614;
import 'package:mediconsult/features/medical_records/domain/usecases/record_vital_signs.dart'
    as _i1066;
import 'package:mediconsult/features/medical_records/domain/usecases/revoke_document_access.dart'
    as _i931;
import 'package:mediconsult/features/medical_records/domain/usecases/share_document_with_doctor.dart'
    as _i1053;
import 'package:mediconsult/features/medical_records/domain/usecases/upload_document.dart'
    as _i944;
import 'package:mediconsult/features/medical_records/presentation/bloc/medical_records/medical_records_bloc.dart'
    as _i716;
import 'package:mediconsult/features/medical_records/presentation/bloc/vital_signs/vital_signs_bloc.dart'
    as _i519;
import 'package:mediconsult/features/prescriptions/data/repositories/prescription_repository_impl.dart'
    as _i925;
import 'package:mediconsult/features/prescriptions/domain/repositories/prescription_repository.dart'
    as _i872;
import 'package:mediconsult/features/prescriptions/domain/usecases/create_prescription.dart'
    as _i450;
import 'package:mediconsult/features/prescriptions/domain/usecases/delete_prescription.dart'
    as _i383;
import 'package:mediconsult/features/prescriptions/domain/usecases/generate_prescription_pdf.dart'
    as _i188;
import 'package:mediconsult/features/prescriptions/domain/usecases/get_consultation_prescriptions.dart'
    as _i725;
import 'package:mediconsult/features/prescriptions/domain/usecases/get_patient_prescriptions.dart'
    as _i365;
import 'package:mediconsult/features/prescriptions/domain/usecases/get_prescription_by_id.dart'
    as _i470;
import 'package:mediconsult/features/prescriptions/domain/usecases/request_refill.dart'
    as _i139;
import 'package:mediconsult/features/prescriptions/domain/usecases/set_medication_reminder.dart'
    as _i202;
import 'package:mediconsult/features/prescriptions/domain/usecases/share_prescription.dart'
    as _i983;
import 'package:mediconsult/features/prescriptions/domain/usecases/update_prescription.dart'
    as _i404;
import 'package:mediconsult/features/prescriptions/presentation/bloc/create_prescription/create_prescription_bloc.dart'
    as _i648;
import 'package:mediconsult/features/prescriptions/presentation/bloc/prescription_list/prescription_list_bloc.dart'
    as _i902;
import 'package:mediconsult/features/video_call/data/datasources/agora_video_service.dart'
    as _i1055;
import 'package:mediconsult/features/video_call/data/datasources/agora_video_service_impl.dart'
    as _i561;
import 'package:mediconsult/features/video_call/data/datasources/video_call_remote_datasource.dart'
    as _i1065;
import 'package:mediconsult/features/video_call/data/datasources/video_call_remote_datasource_impl.dart'
    as _i410;
import 'package:mediconsult/features/video_call/data/repositories/video_call_repository_impl.dart'
    as _i578;
import 'package:mediconsult/features/video_call/domain/repositories/video_call_repository.dart'
    as _i279;
import 'package:mediconsult/features/video_call/domain/usecases/end_consultation.dart'
    as _i236;
import 'package:mediconsult/features/video_call/domain/usecases/initialize_video_call.dart'
    as _i321;
import 'package:mediconsult/features/video_call/domain/usecases/join_video_call.dart'
    as _i473;
import 'package:mediconsult/features/video_call/domain/usecases/leave_video_call.dart'
    as _i720;
import 'package:mediconsult/features/video_call/domain/usecases/switch_camera.dart'
    as _i1051;
import 'package:mediconsult/features/video_call/domain/usecases/toggle_audio.dart'
    as _i218;
import 'package:mediconsult/features/video_call/domain/usecases/toggle_video.dart'
    as _i100;
import 'package:mediconsult/features/video_call/presentation/bloc/video_call_bloc.dart'
    as _i936;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i361.Dio>(() => thirdPartyModule.dio);
    gh.lazySingleton<_i59.FirebaseAuth>(() => thirdPartyModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => thirdPartyModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(
        () => thirdPartyModule.firebaseStorage);
    gh.lazySingleton<_i116.GoogleSignIn>(() => thirdPartyModule.googleSignIn);
    gh.lazySingletonAsync<_i460.SharedPreferences>(
        () => thirdPartyModule.sharedPreferences);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
        () => thirdPartyModule.flutterSecureStorage);
    gh.lazySingleton<_i152.LocalAuthentication>(
        () => thirdPartyModule.localAuthentication);
    gh.lazySingletonAsync<_i703.RtcEngine>(() => thirdPartyModule.rtcEngine);
    gh.lazySingleton<_i1055.AgoraVideoService>(
        () => _i561.AgoraVideoServiceImpl());
    gh.lazySingleton<_i1065.VideoCallRemoteDataSource>(
        () => _i410.VideoCallRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i178.SpeechRecognitionService>(
        () => _i646.SpeechRecognitionServiceImpl());
    gh.lazySingleton<_i901.GeminiAiService>(
        () => _i1051.GeminiAiServiceImpl(gh<String>()));
    gh.lazySingleton<_i297.AiRepository>(
        () => _i125.AiRepositoryImpl(gh<_i901.GeminiAiService>()));
    gh.factory<_i716.MedicalRecordsBloc>(() => _i716.MedicalRecordsBloc(
          getAllDocuments: gh<_i393.GetAllDocuments>(),
          getDocumentsByCategory: gh<_i371.GetDocumentsByCategory>(),
          uploadDocument: gh<_i944.UploadDocument>(),
          deleteDocument: gh<_i261.DeleteDocument>(),
          shareDocumentWithDoctor: gh<_i1053.ShareDocumentWithDoctor>(),
          revokeDocumentAccess: gh<_i931.RevokeDocumentAccess>(),
        ));
    gh.factory<_i957.AnalyzeSymptoms>(
        () => _i957.AnalyzeSymptoms(gh<_i297.AiRepository>()));
    gh.factory<_i51.CheckDrugInteractions>(
        () => _i51.CheckDrugInteractions(gh<_i297.AiRepository>()));
    gh.factory<_i228.GenerateSummary>(
        () => _i228.GenerateSummary(gh<_i297.AiRepository>()));
    gh.factory<_i199.SendChatMessage>(
        () => _i199.SendChatMessage(gh<_i297.AiRepository>()));
    gh.lazySingleton<_i279.VideoCallRepository>(
        () => _i578.VideoCallRepositoryImpl(
              gh<_i1055.AgoraVideoService>(),
              gh<_i1065.VideoCallRemoteDataSource>(),
            ));
    gh.lazySingleton<_i872.PrescriptionRepository>(() =>
        _i925.PrescriptionRepositoryImpl(
            firestore: gh<_i974.FirebaseFirestore>()));
    gh.factory<_i247.SummaryBloc>(
        () => _i247.SummaryBloc(gh<_i228.GenerateSummary>()));
    gh.lazySingletonAsync<_i584.AppointmentsLocalDatasource>(() async =>
        _i648.AppointmentsLocalDatasourceImpl(
            prefs: await getAsync<_i460.SharedPreferences>()));
    gh.lazySingletonAsync<_i540.MedicalRecordsLocalDataSource>(() async =>
        _i1002.MedicalRecordsLocalDataSourceImpl(
            prefs: await getAsync<_i460.SharedPreferences>()));
    gh.factory<_i519.VitalSignsBloc>(() => _i519.VitalSignsBloc(
          recordVitalSigns: gh<_i1066.RecordVitalSigns>(),
          getVitalSignsHistory: gh<_i614.GetVitalSignsHistory>(),
          getLatestVitalSigns: gh<_i44.GetLatestVitalSigns>(),
        ));
    gh.lazySingleton<_i387.AppointmentsRemoteDatasource>(() =>
        _i108.AppointmentsRemoteDatasourceImpl(
            firestore: gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i749.AuthRemoteDatasource>(
        () => _i985.AuthRemoteDatasourceImpl(
              firebaseAuth: gh<_i59.FirebaseAuth>(),
              firestore: gh<_i974.FirebaseFirestore>(),
              googleSignIn: gh<_i116.GoogleSignIn>(),
            ));
    gh.lazySingleton<_i483.MedicalRecordsRemoteDataSource>(() =>
        _i503.MedicalRecordsRemoteDataSourceImpl(
            firestore: gh<_i974.FirebaseFirestore>()));
    gh.lazySingletonAsync<_i750.AuthLocalDatasource>(
        () async => _i372.AuthLocalDatasourceImpl(
              secureStorage: gh<_i558.FlutterSecureStorage>(),
              localAuth: gh<_i152.LocalAuthentication>(),
              prefs: await getAsync<_i460.SharedPreferences>(),
            ));
    gh.lazySingletonAsync<_i563.AppointmentsRepository>(() async =>
        _i702.AppointmentsRepositoryImpl(
          remoteDatasource: gh<_i387.AppointmentsRemoteDatasource>(),
          localDatasource: await getAsync<_i584.AppointmentsLocalDatasource>(),
        ));
    gh.factory<_i450.CreatePrescription>(
        () => _i450.CreatePrescription(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i383.DeletePrescription>(
        () => _i383.DeletePrescription(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i188.GeneratePrescriptionPdf>(() =>
        _i188.GeneratePrescriptionPdf(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i725.GetConsultationPrescriptions>(() =>
        _i725.GetConsultationPrescriptions(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i365.GetPatientPrescriptions>(() =>
        _i365.GetPatientPrescriptions(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i470.GetPrescriptionById>(
        () => _i470.GetPrescriptionById(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i139.RequestRefill>(
        () => _i139.RequestRefill(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i202.SetMedicationReminder>(
        () => _i202.SetMedicationReminder(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i983.SharePrescription>(
        () => _i983.SharePrescription(gh<_i872.PrescriptionRepository>()));
    gh.factory<_i404.UpdatePrescription>(
        () => _i404.UpdatePrescription(gh<_i872.PrescriptionRepository>()));
    gh.lazySingleton<_i797.TranscriptionRepository>(() =>
        _i1024.TranscriptionRepositoryImpl(
            gh<_i178.SpeechRecognitionService>()));
    gh.factory<_i902.PrescriptionListBloc>(() => _i902.PrescriptionListBloc(
          getPatientPrescriptions: gh<_i365.GetPatientPrescriptions>(),
          deletePrescription: gh<_i383.DeletePrescription>(),
        ));
    gh.factory<_i878.SymptomCheckerBloc>(() => _i878.SymptomCheckerBloc(
          gh<_i957.AnalyzeSymptoms>(),
          gh<_i199.SendChatMessage>(),
        ));
    gh.factory<_i236.EndConsultation>(
        () => _i236.EndConsultation(gh<_i279.VideoCallRepository>()));
    gh.factory<_i321.InitializeVideoCall>(
        () => _i321.InitializeVideoCall(gh<_i279.VideoCallRepository>()));
    gh.factory<_i473.JoinVideoCall>(
        () => _i473.JoinVideoCall(gh<_i279.VideoCallRepository>()));
    gh.factory<_i720.LeaveVideoCall>(
        () => _i720.LeaveVideoCall(gh<_i279.VideoCallRepository>()));
    gh.factory<_i1051.SwitchCamera>(
        () => _i1051.SwitchCamera(gh<_i279.VideoCallRepository>()));
    gh.factory<_i218.ToggleAudio>(
        () => _i218.ToggleAudio(gh<_i279.VideoCallRepository>()));
    gh.factory<_i100.ToggleVideo>(
        () => _i100.ToggleVideo(gh<_i279.VideoCallRepository>()));
    gh.lazySingletonAsync<_i642.MedicalRecordsRepository>(
        () async => _i196.MedicalRecordsRepositoryImpl(
              remoteDataSource: gh<_i483.MedicalRecordsRemoteDataSource>(),
              localDataSource:
                  await getAsync<_i540.MedicalRecordsLocalDataSource>(),
            ));
    gh.factory<_i532.StartConsultationWithAI>(
        () => _i532.StartConsultationWithAI(
              gh<_i279.VideoCallRepository>(),
              gh<_i797.TranscriptionRepository>(),
            ));
    gh.factory<_i774.StartTranscription>(
        () => _i774.StartTranscription(gh<_i797.TranscriptionRepository>()));
    gh.factory<_i354.StopTranscription>(
        () => _i354.StopTranscription(gh<_i797.TranscriptionRepository>()));
    gh.factory<_i648.CreatePrescriptionBloc>(() => _i648.CreatePrescriptionBloc(
          createPrescription: gh<_i450.CreatePrescription>(),
          updatePrescription: gh<_i404.UpdatePrescription>(),
        ));
    gh.factory<_i128.TranscriptionBloc>(() => _i128.TranscriptionBloc(
          gh<_i774.StartTranscription>(),
          gh<_i354.StopTranscription>(),
        ));
    gh.lazySingletonAsync<_i392.AuthRepository>(
        () async => _i864.AuthRepositoryImpl(
              remoteDatasource: gh<_i749.AuthRemoteDatasource>(),
              localDatasource: await getAsync<_i750.AuthLocalDatasource>(),
            ));
    gh.factoryAsync<_i638.AuthenticateBiometric>(() async =>
        _i638.AuthenticateBiometric(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i864.CheckAuthStatus>(() async =>
        _i864.CheckAuthStatus(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i765.EnableBiometric>(() async =>
        _i765.EnableBiometric(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i743.GetCurrentUser>(() async =>
        _i743.GetCurrentUser(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i821.ResetPassword>(() async =>
        _i821.ResetPassword(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i975.SignInWithEmail>(() async =>
        _i975.SignInWithEmail(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i730.SignInWithGoogle>(() async =>
        _i730.SignInWithGoogle(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i27.SignInWithPhone>(() async =>
        _i27.SignInWithPhone(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i178.SignOut>(
        () async => _i178.SignOut(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i473.SignUpWithEmail>(() async =>
        _i473.SignUpWithEmail(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i902.UpdateProfile>(() async =>
        _i902.UpdateProfile(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i160.VerifyOtp>(
        () async => _i160.VerifyOtp(await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i584.AppointmentBloc>(() async => _i584.AppointmentBloc(
        appointmentsRepository:
            await getAsync<_i563.AppointmentsRepository>()));
    gh.factoryAsync<_i304.BookingBloc>(() async => _i304.BookingBloc(
        appointmentsRepository:
            await getAsync<_i563.AppointmentsRepository>()));
    gh.factoryAsync<_i521.AuthBloc>(() async =>
        _i521.AuthBloc(authRepository: await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i393.LoginBloc>(() async => _i393.LoginBloc(
        authRepository: await getAsync<_i392.AuthRepository>()));
    gh.factoryAsync<_i609.RegistrationBloc>(() async => _i609.RegistrationBloc(
        authRepository: await getAsync<_i392.AuthRepository>()));
    gh.factory<_i936.VideoCallBloc>(() => _i936.VideoCallBloc(
          gh<_i321.InitializeVideoCall>(),
          gh<_i473.JoinVideoCall>(),
          gh<_i720.LeaveVideoCall>(),
          gh<_i218.ToggleAudio>(),
          gh<_i100.ToggleVideo>(),
          gh<_i1051.SwitchCamera>(),
          gh<_i236.EndConsultation>(),
        ));
    return this;
  }
}

class _$ThirdPartyModule extends _i680.ThirdPartyModule {}
