// auth_provider.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:uuid/uuid.dart';
import 'package:wheelbase/models/user_profile_model.dart';
import 'package:wheelbase/screens/auth/login_page.dart';

class AuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  Session? _session;
  User? _user;
  UserProfileModel? _profile;

  Session? get session => _session;
  User? get user => _user;
  UserProfileModel? get profile => _profile;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // 1️⃣ Sign up with Supabase Auth
      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (response.user == null) {
        return "Signup failed. Please try again.";
      }

      final authUser = response.user!;
      _user = authUser;
      _session = response.session;

      // 2️⃣ Insert into users table
      final cleanEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9@.]'), '');

      // final uuid = const Uuid().v4();
      final uuid = cleanEmail;
      final authUuid = authUser.id.toString().trim(); // ✅ ensure string

      final insertResponse = await supabase.from('users').insert({
        'email': email.trim(),
        'password': password, // ⚠️ still plain text
        'name': name.trim(),
        'phone': phone.trim(),
        'auth_uuid': authUuid,
        'uuid': uuid,
      }).select(); // ✅ select returns inserted row

      if (insertResponse.isEmpty) {
        return "Failed to save user profile in database.";
      }

      // 3️⃣ Fetch profile immediately from DB (guaranteed to exist)
      await fetchUserProfile(authUuid);

      notifyListeners();
      return null; // success
    } on PostgrestException catch (e) {
      debugPrint("Postgres error: ${e.message}");
      return e.message;
    } on AuthException catch (e) {
      debugPrint("Auth error: ${e.message}");
      return e.message;
    } catch (e, stack) {
      debugPrint("Unexpected error: $e");
      debugPrint(stack.toString());
      return "Unexpected error occurred. Please try again.";
    }
  }

  /// 🔹 Fetch the logged-in user's profile from `users` table
  Future<void> fetchUserProfile(String authUuid) async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('auth_uuid', authUuid.trim())
          .maybeSingle();

      if (response == null) {
        _profile = null;
      } else {
        _profile = UserProfileModel.fromJson(response);
      }

      // ✅ Make sure _user is set if session exists
      final session = supabase.auth.currentSession;
      if (session != null) {
        _user = session.user;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1️⃣ Sign in with Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final authUser = response.user;
      if (authUser == null) return "Invalid email or password";

      _user = authUser;
      _session = response.session;

      final authUuid = authUser.id.toString().trim();

      // 2️⃣ Fetch user profile from 'users' table
      await fetchUserProfile(authUuid);

      notifyListeners();
      return null; // success
    } on AuthException catch (e) {
      debugPrint("Auth error: ${e.message}");
      return e.message;
    } on PostgrestException catch (e) {
      debugPrint("DB error: ${e.message}");
      return e.message;
    } catch (e, stack) {
      debugPrint("Unexpected error: $e");
      debugPrint(stack.toString());
      return "Unexpected error occurred. Please try again.";
    }
  }

  Future<void> logout(BuildContext context) async {
  try {
    // 1️⃣ Sign out from Supabase
    await supabase.auth.signOut();

    // 2️⃣ Clear local state
    _user = null;
    _session = null;
    _profile = null;
    notifyListeners();

    // 3️⃣ Navigate to LoginPage and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  } catch (e) {
    debugPrint("Logout error: $e");
    // Optionally show a SnackBar here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to logout. Try again.")),
    );
  }
}

}
