// import 'package:flutter/material.dart';
// import 'package:wheelbase/models/vehicles_model.dart';
// import 'package:wheelbase/themes/app/buttons.dart';
// import 'package:wheelbase/themes/app/cards.dart';
// import 'package:wheelbase/themes/appfonts.dart';

// class AppVehicleCard extends StatelessWidget {
//   final VehicleModel vehicle;
//   final VoidCallback onEdit;
//   final String? imageUrl;

//   const AppVehicleCard({
//     super.key,
//     required this.vehicle,
//     required this.onEdit,
//     this.imageUrl,
//   });

//   String formatDate(DateTime? dt) =>
//       dt != null ? "${dt.toLocal().toString().split(' ')[0]}" : "N/A";

//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("${vehicle.vehicleName} (${vehicle.vehicleYear})", style: AppFonts.heading2),
//           const SizedBox(height: 4),
//           // Text("Owner: ${vehicle.ownerName}", style: AppFonts.body),
//           Text("Number: ${vehicle.vehicleNumber}", style: AppFonts.body),
//           Text("Service KM: ${vehicle.serviceKm}", style: AppFonts.body),
//           Text("Insurance: ${formatDate(vehicle.insuranceStarts)} - ${formatDate(vehicle.insuranceEnds)}", style: AppFonts.body),
//           Text("Pollution: ${formatDate(vehicle.pollutionStarts)} - ${formatDate(vehicle.pollutionEnds)}", style: AppFonts.body),
//           if (vehicle.battery != null) Text("Battery: ${vehicle.battery}", style: AppFonts.body),
//           if (vehicle.alignment != null) Text("Alignment: ${vehicle.alignment}", style: AppFonts.body),
//           if (vehicle.notes != null) Text("Notes: ${vehicle.notes}", style: AppFonts.body),
//           const SizedBox(height: 8),
//           if (imageUrl != null)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(imageUrl!, height: 120, width: double.infinity, fit: BoxFit.cover),
//             ),
//           const SizedBox(height: 12),
//           Align(
//             alignment: Alignment.centerRight,
//             child: AppButton.elevated(label: "Edit", icon: Icons.edit, onPressed: onEdit),
//           )
//         ],
//       ),
//     );
//   }
// }
