import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/firebase_tracker_repository.dart';
import 'features/auth/tracker_provider.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CleanTrackerApp());
}

class CleanTrackerApp extends StatelessWidget {
  const CleanTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TrackerProvider(FirebaseTrackerRepository()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final trackerProvider = context.read<TrackerProvider>();
          final router = AppRouter.createRouter(trackerProvider);

          return MaterialApp.router(
            title: 'CleanTracker',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
