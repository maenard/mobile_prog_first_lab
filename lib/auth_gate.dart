import 'package:first_laboratory_exam/pages/auth/login.dart';
import 'package:first_laboratory_exam/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: supabase.auth.onAuthStateChange,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final session = snapshot.data!.session;

          if (session != null) {
            return const Home();
          }

          return const Login();
        },
      ),
    );
  }
}
