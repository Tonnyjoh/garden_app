import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gardenapp/pages/home/home.dart';
import 'package:gardenapp/pages/home/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load();

  // Initialize Supabase
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  // Check connectivity
  List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

  runApp(MyApp(connectivityResult: connectivityResult));
}

class MyApp extends StatefulWidget {
  final List<ConnectivityResult> connectivityResult;

  const MyApp({super.key, required this.connectivityResult});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  List<ConnectivityResult> _connectivityResult;

  _MyAppState() : _connectivityResult = [];

  @override
  void initState() {
    super.initState();
    _connectivityResult = widget.connectivityResult;
    _subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Garden App',
      home: _connectivityResult.contains(ConnectivityResult.none)
          ? const NoConnectionScreen()
          : const LoginScreen( ),
    );
  }
}

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.signal_wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'No internet connection',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
                if (!connectivityResult.contains(ConnectivityResult.none)) {
                  runApp(MyApp(connectivityResult: connectivityResult));
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
