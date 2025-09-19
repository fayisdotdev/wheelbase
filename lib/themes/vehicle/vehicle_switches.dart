import 'package:flutter/material.dart';
import 'package:wheelbase/themes/app/app_switch_title.dart';

class VehicleSwitches extends StatelessWidget {
  final bool needNotification;
  final bool sharedWith;
  final ValueChanged<bool> onNotificationChanged;
  final ValueChanged<bool> onSharedChanged;

  const VehicleSwitches({
    Key? key,
    required this.needNotification,
    required this.sharedWith,
    required this.onNotificationChanged,
    required this.onSharedChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSwitchTile(
          title: "Need Notifications",
          value: needNotification,
          onChanged: onNotificationChanged,
        ),
        AppSwitchTile(
          title: "Shared with Others",
          value: sharedWith,
          onChanged: onSharedChanged,
        ),
      ],
    );
  }
}
