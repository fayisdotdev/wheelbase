import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/screens/profile/profile_page.dart';
import 'package:wheelbase/screens/vehicle/add_vehicle.dart';
import 'package:wheelbase/screens/vehicle/fetch_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authProvider.profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout(context); // ✅ pass the context
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hi, ${user.name} 👋",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
              child: const Text("View Profile"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddVehiclePage()),
                );
              },
              child: const Text("Add New"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VehicleListPage()),
                );
              },
              child: const Text("View Vehicles"),
            ),

          ],
        ),
      ),
    );
  }
}
