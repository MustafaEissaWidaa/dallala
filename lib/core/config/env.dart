/// Build-time configuration, injected with
/// `flutter run --dart-define-from-file=.env`. Only public values belong here:
/// the Supabase anon key is safe to ship; the service-role key never is.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
