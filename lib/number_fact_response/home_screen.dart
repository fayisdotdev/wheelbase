// import 'package:flutter/material.dart';
// import 'package:wheelbase/number_fact_response/apis.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final numberController = TextEditingController();
//   String displayFact = "Type a number and get a fact!";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Number Facts"),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: numberController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: "Enter a number",
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: () async {
//                   final enteredNumber = numberController.text;
//                   final parsedNumber = int.tryParse(enteredNumber) ?? 0;
//                   final response = await getnumbers(number: parsedNumber);
//                   setState(() {
//                     displayFact = response.text ?? "No Fact Found";
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                 ),
//                 child: const Text("Get Fact"),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 displayFact,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
