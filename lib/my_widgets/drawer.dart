// import 'package:flutter/material.dart';
// import 'package:pearlnew/config/constants.dart';
// import 'package:pearlnew/config/theme_config.dart';

// class MyDrawer extends StatefulWidget {
//   final List<BreakDown> breakdowns;
//   final Map<String, Function> menu;

//   const MyDrawer({super.key, required this.menu, required this.breakdowns});

//   @override
//   State<MyDrawer> createState() => _MyDrawerState();
// }

// class _MyDrawerState extends State<MyDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.center,
//             height: 250,
//             color: primaryColor,
//             child: const Text(
//               appName,
//               style: TextStyle(
//                 color: bubbleColorWhiteMax,
//                 fontSize: textMedium,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.home_rounded,
//               color: primaryColor,
//             ),
//             title: const Text("Home"),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           const Divider(height: 1),
//           ListTile(
//             leading: const Icon(
//               Icons.qr_code_scanner_rounded,
//               color: primaryColor,
//             ),
//             title: const Text("QR Scanner"),
//             onTap: () {
//               Navigator.pushNamed(context, '/scanner');
//             },
//           ),
//           // const Divider(height: 1),
//           // ListTile(
//           //   leading: const Icon(
//           //     Icons.notifications_rounded,
//           //     color: primaryColor,
//           //   ),
//           //   title: const Text("Notifications"),
//           //   onTap: () {
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(
//           //         builder: (context) => MyNotifications(
//           //           breakdowns: widget.breakdowns,
//           //         ),
//           //       ),
//           //     );
//           //   },
//           // ),
//           const Divider(height: 1),
//           Expanded(
//             child: Container(),
//           ),
//           ListTile(
//             leading: const Icon(
//               Icons.power_settings_new_rounded,
//               color: errorColor,
//             ),
//             title: const Text(
//               "Sign out",
//               style: TextStyle(
//                 color: errorColor,
//               ),
//             ),
//             onTap: () {
//               Navigator.pushReplacementNamed(context, "/login");
//             },
//           ),
//           Divider(),
//           const Text(
//             "Developed by Right Click",
//             style: TextStyle(color: primaryColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
