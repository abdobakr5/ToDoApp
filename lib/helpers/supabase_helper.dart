import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseHelper {
  static const String projectUrl = 'https://qdqeglnzkmlawmvmjfax.supabase.co';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFkcWVnbG56a21sYXdtdm1qZmF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyNjQwMDYsImV4cCI6MjA3MDg0MDAwNn0.uwcnWZUmVoTrSlL8v8TC8xlbg3jRh5A-ZRbXtRizIX0';

  static Future init() async {
    await Supabase.initialize(url: projectUrl, anonKey: apiKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
