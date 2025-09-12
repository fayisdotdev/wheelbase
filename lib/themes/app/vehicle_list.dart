// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wheelbase/models/vehicles_model.dart';
// import 'package:wheelbase/provider/vehicle_provider.dart';
// import 'package:wheelbase/screens/vehicle/add_vehicle.dart';
// import 'package:wheelbase/themes/app/apploaders.dart';
// import 'package:wheelbase/themes/app/snackbars.dart';
// import 'package:wheelbase/themes/app/vehicle_card.dart';

// class VehicleListPage extends StatefulWidget {
//   const VehicleListPage({super.key});

//   @override
//   State<VehicleListPage> createState() => _VehicleListPageState();
// }

// class _VehicleListPageState extends State<VehicleListPage> {
//   late Future<List<VehicleModel>> _vehiclesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _loadVehicles();
//   }

//   void _loadVehicles() {
//     _vehiclesFuture = context.read<VehicleProvider>().fetchVehicles();
//   }

//   // ...existing code...
//   Future<void> _refreshVehicles() async {
//     setState(() {
//       _vehiclesFuture = context.read<VehicleProvider>().fetchVehicles();
//     });
//     await _vehiclesFuture;
//   }
//   // ...existing code...

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<VehicleModel>>(
//       future: _vehiclesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const AppLoader();
//         }

//         if (snapshot.hasError) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             AppSnackBar.show(context, "Error: ${snapshot.error}");
//           });
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         final vehicles = snapshot.data ?? [];

//         if (vehicles.isEmpty) {
//           return RefreshIndicator(
//             onRefresh: _refreshVehicles,
//             child: ListView(
//               physics: const AlwaysScrollableScrollPhysics(),
//               children: const [
//                 SizedBox(height: 50),
//                 Center(child: Text("No vehicles found")),
//               ],
//             ),
//           );
//         }

//         return RefreshIndicator(
//           onRefresh: _refreshVehicles,
//           child: Scrollbar(
//             child: ListView.separated(
//               padding: const EdgeInsets.all(12),
//               itemCount: vehicles.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final v = vehicles[index];

//                 return FutureBuilder<String?>(
//                   future: v.imageUrl != null
//                       ? context.read<VehicleProvider>().getSignedImageUrl(
//                           v.imageUrl!.replaceFirst(
//                             RegExp(r'^.*vehicle-images2/'),
//                             '',
//                           ),
//                         )
//                       : Future.value(null),
//                   builder: (context, snap) {
//                     String? imgUrl;
//                     if (snap.connectionState == ConnectionState.waiting) {
//                       imgUrl = null; // show placeholder if needed
//                     } else if (!snap.hasError && snap.data != null) {
//                       imgUrl = snap.data;
//                     }
//                     return AppVehicleCard(
//                       vehicle: v,
//                       imageUrl: imgUrl,
//                       onEdit: () async {
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => AddVehiclePage(vehicle: v),
//                           ),
//                         );
//                         if (result == true) setState(() => _loadVehicles());
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
