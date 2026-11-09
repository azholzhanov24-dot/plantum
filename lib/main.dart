import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/greenhouse_state.dart';
import 'screens/main_wrapper.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
  const PlantumApp({super.key});

  @override
  State<PlantumApp> createState() => _PlantumAppState();
}

class _PlantumAppState extends State<PlantumApp> {
  late final GreenhouseController _greenhouseController;

  @override
  void initState() {
    super.initState();
    _greenhouseController = GreenhouseController();
  }

  @override
  void dispose() {
    _greenhouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GreenhouseScope(
      controller: _greenhouseController,
      child: MaterialApp(
        title: 'Plantum',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.navActiveGreen,
            primary: AppColors.navActiveGreen,
            surface: AppColors.background,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          fontFamily: 'Roboto',
        ),
        home: const MainWrapper(),
      ),
    );
  }
}
