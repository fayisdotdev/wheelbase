import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelbase/provider/auth_provider.dart';
import 'package:wheelbase/themes/app/apploaders.dart';
import 'package:wheelbase/themes/app/appbar.dart';
import 'package:wheelbase/themes/app/cards.dart';
import 'package:wheelbase/utils/date_utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.profile == null) {
      return const Scaffold(body: AppLoader());
    }

    final user = authProvider.profile!;
    // Use centralized date formatting
    String createdAt = DateUtilsWB.formatDate(user.createdAt);

    return Scaffold(
      appBar: const AppAppBar(titleText: "My Profile"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${user.name}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text(
                "Email: ${user.email}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "Phone: ${user.phone}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                "UUID: ${user.uuid}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                "Created At: $createdAt",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
