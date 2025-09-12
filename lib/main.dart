import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hr_attendance_tracker/config/env.dart';
import 'package:hr_attendance_tracker/providers/admin_provider.dart';
import 'package:hr_attendance_tracker/providers/attendance_provider.dart';
import 'package:hr_attendance_tracker/providers/auth_provider.dart';
import 'package:hr_attendance_tracker/providers/profile_provider.dart';
import 'package:hr_attendance_tracker/routes.dart';
import 'package:hr_attendance_tracker/screens/attendance_history_screen.dart';
import 'package:hr_attendance_tracker/screens/profile_screen.dart';
import 'package:hr_attendance_tracker/screens/home_screen.dart';
import 'package:hr_attendance_tracker/widgets/custom_buttom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env
  await dotenv.load(fileName: ".env");

  // Firebase init
  await Firebase.initializeApp(
    options: FirebaseOptions(
      projectId: Env.firebaseProjectId,
      messagingSenderId: Env.firebaseSenderId,
      apiKey: Env.firebaseApiKey,
      appId: Env.firebaseAppId,
    ),
  );

  // Supabase init
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Attendance Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // warna dasar
        ),
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ralewayTextTheme().copyWith(
          headlineLarge: GoogleFonts.raleway(fontWeight: FontWeight.bold),
          headlineSmall: GoogleFonts.raleway(fontWeight: FontWeight.w600),
          labelLarge: GoogleFonts.raleway(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: GoogleFonts.raleway(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // home: const MainScreen(),
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() => _currentIndex = index);
  }

  List<Widget> get _screens => [
    HomeScreen(),
    AttendanceHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_currentIndex]),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
