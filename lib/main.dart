import 'package:chatchuispt/src/repositories/authentication/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Home page which just allow to sign in with Google, display the current user and sign out
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// State of the home page
class _MyHomePageState extends State<MyHomePage> {
  // User repository
  final UserRepository _userRepository = UserRepository();

  // Current user
  User? _currentUser;

  // Method to sign in with Google
  Future<void> _signInWithGoogle() async {
    final User? user = await _userRepository.signInWithGoogle();
    setState(() {
      _currentUser = user;
    });
  }

  // Method to sign out
  Future<void> _signOut() async {
    await _userRepository.signOut();
    setState(() {
      _currentUser = null;
    });
  }

  // Method to get the current user
  Future<void> _getCurrentUser() async {
    final User? user = _userRepository.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  // Build the home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Sign in button
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Sign in with Google'),
            ),
            // Current user
            Text(
              'Current user: ${_currentUser?.displayName ?? 'None'}',
            ),
            // Sign out button
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign out'),
            ),
            // Get current user button
            ElevatedButton(
              onPressed: _getCurrentUser,
              child: const Text('Get current user'),
            ),
          ],
        ),
      ),
    );
  }
}
