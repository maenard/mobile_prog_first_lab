import 'package:first_laboratory_exam/models/user_metadata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserMetadata userMetaData,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: userMetaData.toMap(),
    );
  }

  Future<void> signOut() async {
    supabase.auth.signOut();
  }

  Session? getSession() {
    return supabase.auth.currentSession;
  }
}
