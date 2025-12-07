import 'package:go_router/go_router.dart';
import '../../features/video_call/presentation/pages/video_call_page.dart';
import '../../features/video_call/presentation/pages/pre_call_check_page.dart';
import '../../features/video_call/presentation/pages/call_ended_page.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const PreCallCheckPage(
        consultationId: 'test_consultation',
        doctorName: 'Dr. Sarah Johnson',
        doctorSpecialty: 'Cardiologist',
      ),
    ),
    GoRoute(
      path: RouteNames.preCall,
      builder: (context, state) => const PreCallCheckPage(
        consultationId: 'test_consultation',
        doctorName: 'Dr. Sarah Johnson',
        doctorSpecialty: 'Cardiologist',
      ),
    ),
    GoRoute(
      path: RouteNames.videoCall,
      builder: (context, state) => const VideoCallPage(
        doctorName: 'Dr. Sarah Johnson',
        doctorSpecialty: 'Cardiologist',
      ),
    ),
    GoRoute(
      path: RouteNames.callEnded,
      builder: (context, state) => const CallEndedPage(
        doctorName: 'Dr. Sarah Johnson',
        callDuration: Duration(minutes: 5, seconds: 32),
      ),
    ),
  ],
);
