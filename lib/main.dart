import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/greenhouse_state.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/main_wrapper.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uedifyfbfnrhlazlswmx.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_04zKncisbwnOJne4I6shvA_mmng8cVB',
  );

  // Set system UI overlay style for seamless status bar integration
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PlantumApp());
}

class PlantumApp extends StatefulWidget {
  final GreenhouseController? controller;
  final ThemeController? themeController;
  final Widget? home;

  const PlantumApp({
    super.key,
    this.controller,
    this.themeController,
    this.home,
  });

  @override
  State<PlantumApp> createState() => _PlantumAppState();
}

class _PlantumAppState extends State<PlantumApp> {
  late final GreenhouseController _greenhouseController;
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _greenhouseController = widget.controller ?? GreenhouseController();
    _themeController = widget.themeController ?? ThemeController();
    if (SupabaseService.isAuthenticated) {
      _greenhouseController.loadGreenhouseFromSupabase();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _greenhouseController.dispose();
    }
    if (widget.themeController == null) {
      _themeController.dispose();
    }
    super.dispose();
  }

  Widget _getInitialScreen() {
    if (widget.home != null) return widget.home!;
    if (SupabaseService.isAuthenticated) {
      return const MainWrapper();
    }
    return const SignUpScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      controller: _themeController,
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, _) {
          return GreenhouseScope(
            controller: _greenhouseController,
            child: MaterialApp(
              title: 'Plantum',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _themeController.themeMode,
              home: _getInitialScreen(),
            ),
          );
        },
      ),
    );
  }
}
