// import 'package:cryptkey/data/boxes.dart';
// import 'package:cryptkey/data/passwordManagerModel.dart';
// import 'package:cryptkey/data/uniquePlatforms.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';

// class HomePageTest extends StatefulWidget {
//   const HomePageTest({super.key});

//   @override
//   State<HomePageTest> createState() => _HomePageTestState();
// }

// class _HomePageTestState extends State<HomePageTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ValueListenableBuilder<List<String>>(
//         valueListenable: UniquePlatforms.uniquePlatforms(),
//         builder: (context, platforms, child) {
//           return ListView.builder(
//             itemCount: platforms.length,
//             itemBuilder: (context, index) {
//               final platformName = platforms[index];
//               return ListTile(
//                 title: Text(platformName),
//                 // You can add additional details or actions here if needed
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
