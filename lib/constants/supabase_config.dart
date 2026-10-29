// Konfigurasi Supabase (Tahap 10 & Tahap 17: Security Check)
// KEAMANAN (Security Checklist):
// 1. Hanya gunakan publishable/anon key pada aplikasi mobile client.
// 2. Jangan pernah menyimpan service_role key di repository atau source code client.
// 3. Hak akses (SELECT/INSERT/UPDATE/DELETE) sepenuhnya dikendalikan oleh Row Level Security (RLS) di PostgreSQL.
// 4. Validasi antarmuka (UI) bukan pengganti validasi dan otorisasi backend.

class SupabaseConfig {
  static const String url = 'https://kffkooavwdswvjkbgisr.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtmZmtvb2F2d2Rzd3Zqa2JnaXNyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMjkwMzcsImV4cCI6MjEwODcwNTAzN30.aEnYSOWBtUhn7s0W2Y_OeGHfkztrZWiTqHLHTlbU0kk';
}
