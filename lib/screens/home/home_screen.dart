import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/screens/profile/profile_page.dart';
import 'package:wheelbase/screens/vehicle/add_vehicle.dart';
import 'package:wheelbase/screens/vehicle/vehicle_list.dart';
import 'package:wheelbase/themes/app/appbar.dart';
import 'package:wheelbase/themes/app/apploaders.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.profile == null) {
      return const Scaffold(body: AppLoader());
    }

    final user = authProvider.profile!;

    return Scaffold(
      appBar: AppAppBar(
        titleText: "WheelBase Home",
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Hi, ${user.name} 👋",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          // Use Expanded so the VehicleListPage scrolls properly inside Column
          const Expanded(child: VehicleListPage()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddVehiclePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
