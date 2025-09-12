// import 'package:flutter/material.dart';
// import 'package:wheelbase/models/vehicles_model.dart';
// import 'package:wheelbase/screens/vehicle/add_vehicle.dart';

// class VehiclePagerScreen extends StatefulWidget {
//   final List<VehicleModel> vehicles;
//   final int initialIndex;
//   final bool startInEditMode;

//   const VehiclePagerScreen({
//     super.key,
//     required this.vehicles,
//     required this.initialIndex,
//     this.startInEditMode = false,
//   });

//   @override
//   State<VehiclePagerScreen> createState() => _VehiclePagerScreenState();
// }

// class _VehiclePagerScreenState extends State<VehiclePagerScreen> {
//   late PageController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = PageController(initialPage: widget.initialIndex);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView.builder(
//         controller: _controller,
//         itemCount: widget.vehicles.length,
//         itemBuilder: (context, index) {
//           return AddVehiclePage(
//             vehicle: widget.vehicles[index],
//             // we can add a param to control edit/view mode
//             EditMode: widget.startInEditMode,
//           );
//         },
//       ),
//     );
//   }
// }
