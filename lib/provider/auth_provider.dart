import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/models/user_profile_model.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Session? _session;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _session != null;

  AuthProvider() {
    _session = _supabase.auth.currentSession;
    _user = _supabase.auth.currentUser;
  }

  /// Signup
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      // final Uuid uuid = Uuid();

      if (response.user == null) {
        return "Signup failed";
      }

      final cleanEmail = email.replaceAll(RegExp(r'[^a-zA-Z0-9@.]'), '');
      // final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
      // final customUid = "$cleanEmail+$cleanPhone"; // just mixup
      final customUid = cleanEmail; // just email only

      await _supabase.from('users').insert({
        'auth_uuid': response.user!.id,
        'email': email,
        'name': name,
        'phone': phone,
        'uuid': customUid,
        'password': password,
      });

      _session = response.session;
      _user = response.user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserProfileModel?> fetchUserProfile(String authUuid) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('auth_uuid', authUuid)
        .maybeSingle();

    if (response != null) {
      return UserProfileModel.fromMap(response);
    }
    return null;
  }

  /// Login
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final profile = await fetchUserProfile(response.user!.id);
      // ignore: avoid_print
      print('User Profile: $profile');
      // if (response.user == null || profile == null) {
      //   return "Login failed";
      // }

      _session = response.session;
      _user = response.user;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Forgot password
  Future<String?> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Change password (requires logged-in session)
  Future<String?> changePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
    _session = null;
    _user = null;
    notifyListeners();
  }
}
