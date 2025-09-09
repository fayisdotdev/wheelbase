import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wheelbase/provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://djwptkgaqdvotprtaobg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqd3B0a2dhcWR2b3RwcnRhb2JnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNTkwNDUsImV4cCI6MjA3MjgzNTA0NX0.wTwN-isaYUajlhQFwoVRa34iJT0armZqy2-69shro80',
  );

  runApp(const ProviderWrapper());
}
