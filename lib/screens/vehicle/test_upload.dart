// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class TestUploadPage extends StatefulWidget {
//   const TestUploadPage({super.key});

//   @override
//   State<TestUploadPage> createState() => _TestUploadPageState();
// }

// class _TestUploadPageState extends State<TestUploadPage> {
//   final _nameController = TextEditingController();
//   File? _imageFile;
//   bool _loading = false;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => _imageFile = File(picked.path));
//       print("✅ Picked image: ${picked.path}");
//     } else {
//       print("⚠️ No image picked");
//     }
//   }

//   Future<void> _save() async {
//     if (_nameController.text.isEmpty || _imageFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter name and pick image")),
//       );
//       print("⚠️ Validation failed: Name or image missing");
//       return;
//     }

//     setState(() => _loading = true);

//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       if (user == null) {
//         print("❌ No logged-in user");
//         throw "Not logged in";
//       }
//       print("👤 Current user: ${user.id}");

//       final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
//       final filePath = "${user.id}/$fileName"; // 👈 folder = user.id

//       await Supabase.instance.client.storage
//           .from("test-images")
//           .upload(filePath, _imageFile!);

//       final imageUrl = Supabase.instance.client.storage
//           .from("test-images")
//           .getPublicUrl(filePath); // 👈 use filePath, not fileName

//       print("🌐 Image public URL: $imageUrl");

//       // insert into table
//       final response = await Supabase.instance.client.from("test").insert({
//         "user_auth_uuid": user.id,
//         "name": _nameController.text.trim(),
//         "image_url": imageUrl,
//       });

//       print("✅ Inserted into test table: $response");

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Saved successfully!")));
//       _nameController.clear();
//       setState(() => _imageFile = null);
//     } catch (e, st) {
//       print("❌ Error during save: $e");
//       print("📌 Stack trace: $st");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     } finally {
//       setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Test Upload")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//             const SizedBox(height: 16),
//             _imageFile != null
//                 ? Image.file(_imageFile!, height: 120)
//                 : Container(
//                     height: 120,
//                     width: 120,
//                     color: Colors.grey.shade300,
//                     child: const Icon(Icons.image),
//                   ),
//             const SizedBox(height: 12),
//             ElevatedButton.icon(
//               onPressed: _pickImage,
//               icon: const Icon(Icons.upload),
//               label: const Text("Pick Image"),
//             ),
//             const SizedBox(height: 20),
//             _loading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(onPressed: _save, child: const Text("Save")),
//           ],
//         ),
//       ),
//     );
//   }
// }
