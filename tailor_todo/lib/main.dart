import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // import home screen
import 'utils/fonts.dart';
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fzvqejmjbnygdkjdjtpj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6dnFlam1qYm55Z2RramRqdHBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNDI3MzIsImV4cCI6MjA3MjYxODczMn0.ZHyLT8visKC9Dsp6xlpDscAWYXNWc1bgHEuhFl9NSDs',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _authSubscription;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = Supabase.instance.client.auth.currentUser;

    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      setState(() {
        _user = data.session?.user;
      });
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tailor Todo',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: _user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
