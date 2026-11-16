import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized service for Supabase Authentication and Database queries.
class SupabaseService {
  SupabaseService._();

  static const String supabaseUrl = 'https://uedifyfbfnrhlazlswmx.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_04zKncisbwnOJne4I6shvA_mmng8cVB';

  /// Check whether Supabase was successfully initialized (safe for widget tests)
  static bool get isInitialized {
    try {
      return Supabase.instance.isInitialized;
    } catch (_) {
      return false;
    }
  }

  /// Safe accessor for the Supabase client
  static SupabaseClient? get client {
    if (!isInitialized) return null;
    return Supabase.instance.client;
  }

  /// Current logged-in user, if any
  static User? get currentUser => client?.auth.currentUser;

  /// Current active session, if any
  static Session? get currentSession => client?.auth.currentSession;

  /// Whether a user is currently signed in
  static bool get isAuthenticated => currentUser != null;

  // ==========================================
  // Authentication
  // ==========================================

  /// Register a new account and create their profile row
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    final cli = client;
    if (cli == null) {
      throw const AuthException('Supabase client is not initialized');
    }

    final response = await cli.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );

    final user = response.user;
    if (user != null) {
      try {
        await cli.from('profiles').upsert({
          'id': user.id,
          'username': username,
          'email': email,
        });
      } catch (e) {
        debugPrint('Could not insert profile: $e');
      }
    }

    return response;
  }

  /// Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final cli = client;
    if (cli == null) {
      throw const AuthException('Supabase client is not initialized');
    }

    return await cli.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out current session
  static Future<void> signOut() async {
    final cli = client;
    if (cli == null) return;
    await cli.auth.signOut();
  }

  /// Send password reset email
  static Future<void> resetPassword({required String email}) async {
    final cli = client;
    if (cli == null) return;
    await cli.auth.resetPasswordForEmail(email);
  }

  // ==========================================
  // User Profile Operations
  // ==========================================

  /// Fetch user profile from Supabase 'profiles' table
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final cli = client;
    if (cli == null) return null;
    final user = cli.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await cli.from('profiles').select().eq('id', user.id).maybeSingle();
      if (data != null) return data;
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }

    // Fallback: derive from auth metadata
    return {
      'id': user.id,
      'username': user.userMetadata?['username'] ?? user.email?.split('@').first ?? 'Gardener',
      'email': user.email ?? '',
    };
  }

  /// Update user's username in 'profiles' table and auth metadata
  static Future<bool> updateProfileUsername(String newUsername) async {
    final cli = client;
    if (cli == null) return false;
    final user = cli.auth.currentUser;
    if (user == null) return false;

    final trimmed = newUsername.trim();
    if (trimmed.isEmpty) return false;

    try {
      await cli.from('profiles').update({'username': trimmed}).eq('id', user.id);
      try {
        await cli.auth.updateUser(UserAttributes(data: {'username': trimmed}));
      } catch (_) {}
      return true;
    } catch (e) {
      debugPrint('Error updating profile username: $e');
      return false;
    }
  }

  // ==========================================
  // Greenhouse Database Operations
  // ==========================================

  /// Insert or deploy a new greenhouse into Supabase
  static Future<Map<String, dynamic>?> createGreenhouse({
    required String name,
    required double area,
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    final cli = client;
    if (cli == null) return null;

    final user = cli.auth.currentUser;
    final row = <String, dynamic>{
      'name': name,
      'area_sqm': area,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      if (user != null) 'user_id': user.id,
    };

    final result = await cli.from('greenhouses').insert(row).select().maybeSingle();
    return result;
  }

  /// Fetch the latest greenhouse for the authenticated user
  static Future<Map<String, dynamic>?> getUserGreenhouse() async {
    final cli = client;
    if (cli == null) return null;

    final user = cli.auth.currentUser;
    if (user == null) {
      // Fallback: check if any public row exists
      final rows = await cli.from('greenhouses').select().order('created_at', ascending: false).limit(1);
      if (rows.isNotEmpty) return rows.first;
      return null;
    }

    final row = await cli
        .from('greenhouses')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return row;
  }
}
