// // // this one can handle images.
// // import 'package:archive/config/globals.dart';
// // import 'package:archive/config/theme.dart';
// // import 'package:archive/models/my_file.dart';
// // import 'package:archive/my_widgets/alerts.dart';
// // import 'package:archive/my_widgets/context_menu.dart';
// // import 'package:archive/screens/loading_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';

// // class FileView extends StatefulWidget {
// //   final MyFile file;

// //   const FileView({super.key, required this.file});

// //   @override
// //   State<FileView> createState() => _FileViewState();
// // }

// // class _FileViewState extends State<FileView> {
// //   bool imageTapped = false;

// //   void showContextAction(dynamic item) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       showDragHandle: true,
// //       constraints: BoxConstraints(maxHeight: screenSize.height * .5),
// //       builder: (_) => MyContextMenuSheet(item: item),
// //     );
// //   }

// //   void openExternally() async {
// //     try {
// //       if (!await launchUrl(Uri.parse(widget.file.path))) {
// //         if (mounted) {
// //           alertFunction(context, "Could not launch file", () {
// //             Navigator.pop(context);
// //             Navigator.pop(context);
// //           });
// //         }
// //       } else {
// //         // ignore: use_build_context_synchronously
// //         Navigator.pop(context);
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         alertFunction(context, "Could not launch file ${e.toString()}", () {
// //           Navigator.pop(context);
// //           Navigator.pop(context);
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Stack(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   imageTapped = !imageTapped;
// //                 });
// //               },
// //               onLongPress: () {
// //                 showContextAction(widget.file);
// //               },
// //               child: Container(
// //                 color: Colors.transparent,
// //                 child: Column(
// //                   children: [
// //                     Expanded(
// //                       child: InteractiveViewer(
// //                         child: Center(
// //                           // Add this Center widget
// //                           child: Image.network(
// //                             widget.file.path,
// //                             fit: BoxFit
// //                                 .contain, // Also add this line for better fitting
// //                             loadingBuilder: (context, child, loadingProgress) {
// //                               if (loadingProgress == null) {
// //                                 return child;
// //                               }
// //                               return const LoadingScreen(
// //                                 loadingMessage:
// //                                     "Retrieving your file from cloud...",
// //                               );
// //                             },
// //                             errorBuilder: (context, error, stackTrace) {
// //                               Future.delayed(Duration.zero, openExternally);
// //                               return const LoadingScreen(
// //                                 loadingMessage: "Opening file externally...",
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             if (!imageTapped)
// //               ListTile(
// //                 leading: const BackButton(),
// //                 title: Text(widget.file.name),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   vertical: AppTheme.sMedium,
// //                 ),
// //                 trailing: IconButton(
// //                   onPressed: () => showContextAction(widget.file),
// //                   icon: const Icon(Icons.more_vert_rounded),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'package:archive/config/globals.dart';
// // import 'package:archive/config/theme.dart';
// // import 'package:archive/models/my_file.dart';
// // import 'package:archive/my_widgets/alerts.dart';
// // import 'package:archive/my_widgets/context_menu.dart';
// // import 'package:archive/screens/loading_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'dart:io';
// // import 'package:path/path.dart' as p;

// // class FileView extends StatefulWidget {
// //   final MyFile file;

// //   const FileView({super.key, required this.file});

// //   @override
// //   State<FileView> createState() => _FileViewState();
// // }

// // class _FileViewState extends State<FileView> {
// //   bool imageTapped = false;
// //   bool isImage = false;
// //   bool isPdf = false;
// //   bool isTxt = false;
// //   String? downloadedFilePath;
// //   String? fileContent;

// //   void showContextAction(dynamic item) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       showDragHandle: true,
// //       constraints: BoxConstraints(maxHeight: screenSize.height * .5),
// //       builder: (_) => MyContextMenuSheet(item: item),
// //     );
// //   }

// //   void openExternally() async {
// //     try {
// //       if (!await launchUrl(Uri.parse(widget.file.path))) {
// //         if (mounted) {
// //           alertFunction(context, "Could not launch file", () {
// //             Navigator.pop(context);
// //             Navigator.pop(context);
// //           });
// //         }
// //       } else {
// //         if (mounted) Navigator.pop(context);
// //       }
// //     } catch (e) {
// //       if (mounted) {
// //         alertFunction(context, "Could not launch file ${e.toString()}", () {
// //           Navigator.pop(context);
// //           Navigator.pop(context);
// //         });
// //       }
// //     }
// //   }

// //   Future<void> downloadFile() async {
// //     try {
// //       final response = await http.get(Uri.parse(widget.file.path));
// //       final tempDir = await getTemporaryDirectory();
// //       final filePath = p.join(tempDir.path, widget.file.name);
// //       final file = File(filePath);
// //       await file.writeAsBytes(response.bodyBytes);
// //       setState(() {
// //         downloadedFilePath = filePath;
// //       });
// //     } catch (e) {
// //       if (mounted) openExternally();
// //     }
// //   }

// //   Future<void> downloadTextFile() async {
// //     try {
// //       final response = await http.get(Uri.parse(widget.file.path));
// //       setState(() {
// //         fileContent = response.body;
// //       });
// //     } catch (e) {
// //       if (mounted) openExternally();
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     final fileExt = p.extension(widget.file.name).toLowerCase();

// //     isImage =
// //         ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(fileExt);
// //     isPdf = ['.pdf'].contains(fileExt);
// //     isTxt = ['.txt'].contains(fileExt);

// //     if (isPdf) {
// //       downloadFile();
// //     } else if (isTxt) {
// //       downloadTextFile();
// //     } else if (!isImage) {
// //       Future.delayed(Duration.zero, openExternally);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Stack(
// //           children: [
// //             GestureDetector(
// //               onTap: () {
// //                 setState(() {
// //                   imageTapped = !imageTapped;
// //                 });
// //               },
// //               onLongPress: () {
// //                 showContextAction(widget.file);
// //               },
// //               child: Container(
// //                 color: Colors.transparent,
// //                 child: Column(
// //                   children: [
// //                     Expanded(
// //                       child: Builder(
// //                         builder: (_) {
// //                           if (isImage) {
// //                             return InteractiveViewer(
// //                               child: Center(
// //                                 child: Image.network(
// //                                   widget.file.path,
// //                                   fit: BoxFit.contain,
// //                                   loadingBuilder: (context, child, progress) {
// //                                     if (progress == null) return child;
// //                                     return const LoadingScreen(
// //                                         loadingMessage:
// //                                             "Retrieving your file from cloud...");
// //                                   },
// //                                   errorBuilder: (context, error, stackTrace) {
// //                                     Future.delayed(
// //                                         Duration.zero, openExternally);
// //                                     return const LoadingScreen(
// //                                         loadingMessage:
// //                                             "Opening externally...");
// //                                   },
// //                                 ),
// //                               ),
// //                             );
// //                           } else if (isPdf && downloadedFilePath != null) {
// //                             return PDFView(
// //                               filePath: downloadedFilePath!,
// //                             );
// //                           } else if (isTxt && fileContent != null) {
// //                             return SingleChildScrollView(
// //                               padding: const EdgeInsets.all(16),
// //                               child: Text(fileContent ?? ''),
// //                             );
// //                           } else {
// //                             return const LoadingScreen(
// //                                 loadingMessage: "Opening file...");
// //                           }
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             if (!imageTapped)
// //               ListTile(
// //                 leading: const BackButton(),
// //                 title: Text(widget.file.name),
// //                 contentPadding: EdgeInsets.symmetric(
// //                   vertical: AppTheme.sMedium,
// //                 ),
// //                 trailing: IconButton(
// //                   onPressed: () => showContextAction(widget.file),
// //                   icon: const Icon(Icons.more_vert_rounded),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures, deprecated_member_use

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:archive/config/globals.dart';
// // // import 'package:archive/config/theme.dart';
// // import 'package:archive/models/my_file.dart';
// // import 'package:archive/my_widgets/alerts.dart';
// // import 'package:archive/my_widgets/context_menu.dart';
// // import 'package:archive/screens/loading_screen.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:path/path.dart' as p;
// // import 'package:url_launcher/url_launcher.dart';

// // class FileView extends StatefulWidget {
// //   final MyFile file;
// //   const FileView({super.key, required this.file});

// //   @override
// //   State<FileView> createState() => _FileViewState();
// // }

// // class _FileViewState extends State<FileView> {
// //   bool _showOverlay = true;
// //   bool _isImage = false, _isPdf = false, _isTxt = false;
// //   String? _localPdfPath, _txtContent;

// //   static const _imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
// //   static const _pdfExts = ['.pdf'];
// //   static const _txtExts = ['.txt'];

// //   @override
// //   void initState() {
// //     super.initState();
// //     final ext = p.extension(widget.file.name).toLowerCase();
// //     _isImage = _imageExts.contains(ext);
// //     _isPdf = _pdfExts.contains(ext);
// //     _isTxt = _txtExts.contains(ext);

// //     if (_isPdf) {
// //       _downloadPdf();
// //     } else if (_isTxt) {
// //       _downloadTxt();
// //     } else if (!_isImage) {
// //       // non-image/non-pdf/non-txt: open externally immediately
// //       WidgetsBinding.instance.addPostFrameCallback((_) => _openExternally());
// //     }
// //   }

// //   Future<void> _downloadPdf() async {
// //     try {
// //       final resp = await http.get(Uri.parse(widget.file.path));
// //       final dir = await getTemporaryDirectory();
// //       final file = File(p.join(dir.path, widget.file.name));
// //       await file.writeAsBytes(resp.bodyBytes);
// //       if (mounted) setState(() => _localPdfPath = file.path);
// //     } catch (e) {
// //       _openExternally();
// //     }
// //   }

// //   Future<void> _downloadTxt() async {
// //     try {
// //       final resp = await http.get(Uri.parse(widget.file.path));
// //       if (mounted) setState(() => _txtContent = resp.body);
// //     } catch (e) {
// //       _openExternally();
// //     }
// //   }

// //   Future<void> _openExternally() async {
// //     final uri = Uri.parse(widget.file.path);
// //     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
// //       alertFunction(context, "Could not open file", () {
// //         Navigator.pop(context);
// //         Navigator.pop(context);
// //       });
// //     } else {
// //       Navigator.pop(context);
// //     }
// //   }

// //   void _toggleOverlay() {
// //     setState(() => _showOverlay = !_showOverlay);
// //   }

// //   void _showMenu() {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       showDragHandle: true,
// //       constraints: BoxConstraints(maxHeight: screenSize.height * .5),
// //       builder: (_) => MyContextMenuSheet(item: widget.file),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: GestureDetector(
// //           onTap: _toggleOverlay,
// //           onLongPress: _showMenu,
// //           child: Stack(
// //             children: [
// //               // --- MAIN CONTENT AREA ---
// //               Positioned.fill(
// //                 child: Builder(builder: (_) {
// //                   if (_isImage) {
// //                     return InteractiveViewer(
// //                       child: Center(
// //                         child: Image.network(
// //                           widget.file.path,
// //                           fit: BoxFit.contain,
// //                           loadingBuilder: (c, child, p) {
// //                             if (p == null) return child;
// //                             return const LoadingScreen(
// //                               loadingMessage: "Loading image…",
// //                             );
// //                           },
// //                           errorBuilder: (_, __, ___) {
// //                             // if network fails, fallback external
// //                             WidgetsBinding.instance.addPostFrameCallback((_) {
// //                               _openExternally();
// //                             });
// //                             return const LoadingScreen(
// //                               loadingMessage: "Opening externally…",
// //                             );
// //                           },
// //                         ),
// //                       ),
// //                     );
// //                   }

// //                   if (_isPdf) {
// //                     if (_localPdfPath != null) {
// //                       return PDFView(filePath: _localPdfPath!);
// //                     }
// //                     return const LoadingScreen(
// //                       loadingMessage: "Loading PDF…",
// //                     );
// //                   }

// //                   if (_isTxt) {
// //                     if (_txtContent != null) {
// //                       return SingleChildScrollView(
// //                         padding: const EdgeInsets.all(16),
// //                         child: Text(_txtContent!),
// //                       );
// //                     }
// //                     return const LoadingScreen(
// //                       loadingMessage: "Loading text…",
// //                     );
// //                   }

// //                   // catch-all: show loader while redirecting externally
// //                   return const LoadingScreen(
// //                     loadingMessage: "Opening file…",
// //                   );
// //                 }),
// //               ),

// //               // --- TOP BAR OVERLAY ---
// //               if (_showOverlay)
// //                 Positioned(
// //                   top: 0,
// //                   left: 0,
// //                   right: 0,
// //                   child: ListTile(
// //                     leading: const BackButton(),
// //                     title: Text(widget.file.name,
// //                         maxLines: 1, overflow: TextOverflow.ellipsis),
// //                     trailing: IconButton(
// //                       onPressed: _showMenu,
// //                       icon: const Icon(Icons.more_vert_rounded),
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:archive/config/globals.dart';
// // import 'package:archive/models/my_file.dart';
// // import 'package:archive/my_widgets/alerts.dart';
// // import 'package:archive/my_widgets/context_menu.dart';
// // import 'package:archive/screens/loading_screen.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:path/path.dart' as p;
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// // import 'package:video_player/video_player.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // // import 'package:webview_flutter/webview_flutter.dart';

// // class FileView extends StatefulWidget {
// //   final MyFile file;
// //   const FileView({super.key, required this.file});

// //   @override
// //   State<FileView> createState() => _FileViewState();
// // }

// // class _FileViewState extends State<FileView> {
// //   bool _showOverlay = true;
// //   bool _isImage = false, _isPdf = false, _isTxt = false;
// //   bool _isVideo = false, _isAudio = false, _isOffice = false;
// //   String? _localPdfPath, _txtContent;
// //   VideoPlayerController? _videoController;
// //   ChewieController? _chewieController;
// //   AudioPlayer? _audioPlayer;
// //   WebViewController? _officeController;

// //   static const _imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
// //   static const _pdfExts = ['.pdf'];
// //   static const _txtExts = ['.txt'];
// //   static const _videoExts = [
// //     '.mp4',
// //     '.mov',
// //     '.wmv',
// //     '.avi',
// //     '.flv',
// //     '.mkv',
// //     '.webm'
// //   ];
// //   static const _audioExts = ['.mp3', '.wav', '.aac', '.ogg', '.m4a'];
// //   static const _officeExts = [
// //     '.doc',
// //     '.docx',
// //     '.xls',
// //     '.xlsx',
// //     '.ppt',
// //     '.pptx'
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     final ext = p.extension(widget.file.name).toLowerCase();

// //     _isImage = _imageExts.contains(ext);
// //     _isPdf = _pdfExts.contains(ext);
// //     _isTxt = _txtExts.contains(ext);
// //     _isVideo = _videoExts.contains(ext);
// //     _isAudio = _audioExts.contains(ext);
// //     _isOffice = _officeExts.contains(ext);
// //     _isOffice =
// //         ['.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx'].contains(ext);

// //     if (_isOffice) {
// //       final viewerUrl = Uri.encodeFull(
// //         'https://docs.google.com/gview?embedded=true&url=${widget.file.path}',
// //       );
// //       _officeController = WebViewController()
// //         ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //         ..loadRequest(Uri.parse(viewerUrl));
// //     }

// //     if (_isPdf)
// //       _downloadPdf();
// //     else if (_isTxt)
// //       _downloadTxt();
// //     else if (_isVideo)
// //       _initVideo();
// //     else if (_isAudio)
// //       _initAudio();
// //     else if (_isOffice) {
// //       final viewerUrl = Uri.encodeFull(
// //         'https://docs.google.com/gview?embedded=true&url=${widget.file.path}',
// //       );
// //       _officeController = WebViewController()
// //         ..setJavaScriptMode(JavaScriptMode.unrestricted)
// //         ..loadRequest(Uri.parse(viewerUrl));
// //     } else {
// //       // anything else: open externally
// //       WidgetsBinding.instance.addPostFrameCallback((_) => _openExternally());
// //     }
// //   }

// //   Future<void> _downloadPdf() async {
// //     try {
// //       final resp = await http.get(Uri.parse(widget.file.path));
// //       final dir = await getTemporaryDirectory();
// //       final file = File(p.join(dir.path, widget.file.name));
// //       await file.writeAsBytes(resp.bodyBytes);
// //       if (mounted) setState(() => _localPdfPath = file.path);
// //     } catch (_) {
// //       _openExternally();
// //     }
// //   }

// //   Future<void> _downloadTxt() async {
// //     try {
// //       final resp = await http.get(Uri.parse(widget.file.path));
// //       if (mounted) setState(() => _txtContent = resp.body);
// //     } catch (_) {
// //       _openExternally();
// //     }
// //   }

// //   void _initVideo() {
// //     _videoController = VideoPlayerController.network(widget.file.path)
// //       ..initialize().then((_) {
// //         _chewieController = ChewieController(
// //           videoPlayerController: _videoController!,
// //           autoPlay: false,
// //           looping: false,
// //         );
// //         setState(() {});
// //       });
// //   }

// //   void _initAudio() {
// //     _audioPlayer = AudioPlayer();
// //     // you could start buffering, or await _audioPlayer!.setUrl(widget.file.path)
// //     // for simplicity, we’ll just call play when user hits a button
// //   }

// //   Future<void> _openExternally() async {
// //     final uri = Uri.parse(widget.file.path);
// //     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
// //       alertFunction(context, "Could not open file", () {
// //         Navigator.pop(context);
// //         Navigator.pop(context);
// //       });
// //     } else {
// //       Navigator.pop(context);
// //     }
// //   }

// //   void _toggleOverlay() => setState(() => _showOverlay = !_showOverlay);
// //   void _showMenu() => showModalBottomSheet(
// //         context: context,
// //         isScrollControlled: true,
// //         showDragHandle: true,
// //         constraints: BoxConstraints(maxHeight: screenSize.height * .5),
// //         builder: (_) => MyContextMenuSheet(item: widget.file),
// //       );

// //   @override
// //   void dispose() {
// //     _videoController?.dispose();
// //     _chewieController?.dispose();
// //     _audioPlayer?.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: GestureDetector(
// //           onTap: _toggleOverlay,
// //           onLongPress: _showMenu,
// //           child: Stack(
// //             children: [
// //               // ─── MAIN CONTENT ───────────────────────────────
// //               Positioned.fill(child: Builder(builder: (_) {
// //                 if (_isImage) {
// //                   return InteractiveViewer(
// //                     child: Center(
// //                       child: Image.network(
// //                         widget.file.path,
// //                         fit: BoxFit.contain,
// //                         loadingBuilder: (c, child, p) {
// //                           if (p == null) return child;
// //                           return const LoadingScreen(
// //                               loadingMessage: "Loading image…");
// //                         },
// //                       ),
// //                     ),
// //                   );
// //                 }

// //                 if (_isPdf) {
// //                   if (_localPdfPath != null) {
// //                     return PDFView(filePath: _localPdfPath!);
// //                   }
// //                   return const LoadingScreen(loadingMessage: "Loading PDF…");
// //                 }

// //                 if (_isTxt) {
// //                   if (_txtContent != null) {
// //                     return SingleChildScrollView(
// //                       padding: const EdgeInsets.all(16),
// //                       child: Text(_txtContent!),
// //                     );
// //                   }
// //                   return const LoadingScreen(loadingMessage: "Loading text…");
// //                 }

// //                 if (_isVideo && _chewieController != null) {
// //                   return Chewie(controller: _chewieController!);
// //                 }

// //                 if (_isAudio) {
// //                   return Center(
// //                     child: IconButton(
// //                       iconSize: 64,
// //                       icon: const Icon(Icons.play_arrow),
// //                       onPressed: () =>
// //                           _audioPlayer?.play(UrlSource(widget.file.path)),
// //                     ),
// //                   );
// //                 }

// //                 if (_isOffice && _officeController != null) {
// //                   return WebViewWidget(controller: _officeController!);
// //                 }

// //                 // fallback: in case we’re redirecting externally
// //                 return const LoadingScreen(loadingMessage: "Opening file…");
// //               })),

// //               // ─── OVERLAY ────────────────────────────────────
// //               if (_showOverlay)
// //                 Positioned(
// //                   top: 0,
// //                   left: 0,
// //                   right: 0,
// //                   child: ListTile(
// //                     leading: const BackButton(),
// //                     title: Text(widget.file.name,
// //                         maxLines: 1, overflow: TextOverflow.ellipsis),
// //                     trailing: IconButton(
// //                       onPressed: _showMenu,
// //                       icon: const Icon(Icons.more_vert_rounded),
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // lib/my_widgets/file_view.dart

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:archive/config/globals.dart';
import 'package:archive/models/my_file.dart';
import 'package:archive/my_widgets/alerts.dart';
import 'package:archive/my_widgets/context_menu.dart';
import 'package:archive/screens/loading_screen.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';

class FileView extends StatefulWidget {
  final MyFile file;
  const FileView({super.key, required this.file});

  @override
  State<FileView> createState() => _FileViewState();
}

class _FileViewState extends State<FileView> {
  bool _showOverlay = true;

  // type flags
  bool _isImage = false, _isPdf = false, _isTxt = false;
  bool _isVideo = false, _isAudio = false, _isOffice = false;

  // downloaded data
  String? _localPdfPath;
  String? _txtContent;

  // controllers
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  AudioPlayer? _audioPlayer;
  WebViewController? _officeController;

  // allowed extensions
  static const _imageExts = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
  static const _pdfExts = ['.pdf'];
  static const _txtExts = ['.txt'];
  static const _videoExts = [
    '.mp4',
    '.mov',
    '.wmv',
    '.avi',
    '.flv',
    '.mkv',
    '.webm'
  ];
  static const _audioExts = ['.mp3', '.wav', '.aac', '.ogg', '.m4a'];
  static const _officeExts = [
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.ppt',
    '.pptx'
  ];

  @override
  void initState() {
    super.initState();
    final ext = p.extension(widget.file.name).toLowerCase();

    _isImage = _imageExts.contains(ext);
    _isPdf = _pdfExts.contains(ext);
    _isTxt = _txtExts.contains(ext);
    _isVideo = _videoExts.contains(ext);
    _isAudio = _audioExts.contains(ext);
    _isOffice = _officeExts.contains(ext);

    if (_isPdf) {
      _downloadPdf();
    } else if (_isTxt) {
      _downloadTxt();
    } else if (_isVideo) {
      _initVideo();
    } else if (_isAudio) {
      _initAudio();
    } else if (_isOffice) {
      final viewerUrl = Uri.encodeFull(
        'https://docs.google.com/gview?embedded=true&url=${widget.file.path}',
      );
      _officeController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(viewerUrl));
    } else if (!_isImage) {
      // everything else jumps straight to external
      WidgetsBinding.instance.addPostFrameCallback((_) => _openExternally());
    }
  }

  Future<void> _downloadPdf() async {
    try {
      final resp = await http.get(Uri.parse(widget.file.path));
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, widget.file.name));
      await file.writeAsBytes(resp.bodyBytes);
      if (mounted) setState(() => _localPdfPath = file.path);
    } catch (_) {
      _openExternally();
    }
  }

  Future<void> _downloadTxt() async {
    try {
      final resp = await http.get(Uri.parse(widget.file.path));
      if (mounted) setState(() => _txtContent = resp.body);
    } catch (_) {
      _openExternally();
    }
  }

  void _initVideo() {
    _videoController = VideoPlayerController.network(widget.file.path)
      ..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
        );
        setState(() {});
      });
  }

  void _initAudio() {
    _audioPlayer = AudioPlayer();
    // optionally preload or just play on demand
  }

  Future<void> _openExternally() async {
    final uri = Uri.parse(widget.file.path);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      alertFunction(context, "Could not open file", () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _toggleOverlay() => setState(() => _showOverlay = !_showOverlay);
  void _showMenu() => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: BoxConstraints(maxHeight: screenSize.height * .5),
        builder: (_) => MyContextMenuSheet(
          item: widget.file,
          rootContext: context,
        ),
      );

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleOverlay,
          onLongPress: _showMenu,
          child: Stack(
            children: [
              // ─── MAIN CONTENT ───────────────────────────────
              Positioned.fill(
                child: Builder(builder: (_) {
                  if (_isImage) {
                    return InteractiveViewer(
                      child: Center(
                        child: Image.network(
                          widget.file.path,
                          fit: BoxFit.contain,
                          loadingBuilder: (c, child, prog) {
                            if (prog == null) return child;
                            return const LoadingScreen(
                              loadingMessage: "Loading image…",
                            );
                          },
                          errorBuilder: (c, e, st) {
                            // fallback to external on any image load error
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _openExternally());
                            return const LoadingScreen(
                              loadingMessage: "Opening externally…",
                            );
                          },
                        ),
                      ),
                    );
                  }

                  if (_isPdf) {
                    if (_localPdfPath != null) {
                      return PDFView(filePath: _localPdfPath!);
                    }
                    return const LoadingScreen(
                      loadingMessage: "Loading PDF…",
                    );
                  }

                  if (_isTxt) {
                    if (_txtContent != null) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Text(_txtContent!),
                      );
                    }
                    return const LoadingScreen(
                      loadingMessage: "Loading text…",
                    );
                  }

                  if (_isVideo && _chewieController != null) {
                    return Chewie(controller: _chewieController!);
                  }

                  if (_isAudio) {
                    return Center(
                      child: IconButton(
                        iconSize: 64,
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () =>
                            _audioPlayer?.play(UrlSource(widget.file.path)),
                      ),
                    );
                  }

                  if (_isOffice && _officeController != null) {
                    return WebViewWidget(controller: _officeController!);
                  }

                  // catch-all: show loader while redirecting
                  return const LoadingScreen(
                    loadingMessage: "Opening file…",
                  );
                }),
              ),

              // ─── TOP BAR OVERLAY ───────────────────────────
              if (_showOverlay)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ListTile(
                    leading: const BackButton(),
                    title: Text(
                      widget.file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: _showMenu,
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:archive/config/globals.dart';
// import 'package:archive/config/theme.dart';
// import 'package:archive/models/my_file.dart';
// import 'package:archive/my_widgets/alerts.dart';
// import 'package:archive/my_widgets/context_menu.dart';
// import 'package:archive/screens/loading_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';
// import 'package:path/path.dart' as p;

// class FileView extends StatefulWidget {
//   final MyFile file;

//   const FileView({super.key, required this.file});

//   @override
//   State<FileView> createState() => _FileViewState();
// }

// class _FileViewState extends State<FileView> {
//   bool imageTapped = false;
//   bool isImage = false;
//   bool isPdf = false;
//   bool isTxt = false;
//   String? downloadedFilePath;
//   String? fileContent;

//   void showContextAction(dynamic item) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       showDragHandle: true,
//       constraints: BoxConstraints(maxHeight: screenSize.height * .5),
//       builder: (_) => MyContextMenuSheet(
//         item: item,
//         rootContext: context,
//       ),
//     );
//   }

//   void openExternally() async {
//     try {
//       if (!await launchUrl(Uri.parse(widget.file.path))) {
//         if (mounted) {
//           alertFunction(context, "Could not launch file", () {
//             Navigator.pop(context);
//             Navigator.pop(context);
//           });
//         }
//       } else {
//         if (mounted) Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) {
//         alertFunction(context, "Could not launch file ${e.toString()}", () {
//           Navigator.pop(context);
//           Navigator.pop(context);
//         });
//       }
//     }
//   }

//   Future<void> downloadFile() async {
//     try {
//       final response = await http.get(Uri.parse(widget.file.path));
//       final tempDir = await getTemporaryDirectory();
//       final filePath = p.join(tempDir.path, widget.file.name);
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);
//       setState(() {
//         downloadedFilePath = filePath;
//       });
//     } catch (e) {
//       if (mounted) openExternally();
//     }
//   }

//   Future<void> downloadTextFile() async {
//     try {
//       final response = await http.get(Uri.parse(widget.file.path));
//       setState(() {
//         fileContent = response.body;
//       });
//     } catch (e) {
//       if (mounted) openExternally();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     final fileExt = p.extension(widget.file.name).toLowerCase();

//     isImage =
//         ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(fileExt);
//     isPdf = ['.pdf'].contains(fileExt);
//     isTxt = ['.txt'].contains(fileExt);

//     if (isPdf) {
//       downloadFile();
//     } else if (isTxt) {
//       downloadTextFile();
//     } else if (!isImage) {
//       Future.delayed(Duration.zero, openExternally);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   imageTapped = !imageTapped;
//                 });
//               },
//               onLongPress: () {
//                 showContextAction(widget.file);
//               },
//               child: Container(
//                 color: Colors.transparent,
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Builder(
//                         builder: (_) {
//                           if (isImage) {
//                             return InteractiveViewer(
//                               child: Center(
//                                 child: Image.network(
//                                   widget.file.path,
//                                   fit: BoxFit.contain,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return const LoadingScreen(
//                                         loadingMessage:
//                                             "Retrieving your file from cloud...");
//                                   },
//                                   errorBuilder: (context, error, stackTrace) {
//                                     Future.delayed(
//                                         Duration.zero, openExternally);
//                                     return const LoadingScreen(
//                                         loadingMessage:
//                                             "Opening externally...");
//                                   },
//                                 ),
//                               ),
//                             );
//                           } else if (isPdf && downloadedFilePath != null) {
//                             return PDFView(
//                               filePath: downloadedFilePath!,
//                             );
//                           } else if (isTxt && fileContent != null) {
//                             return SingleChildScrollView(
//                               padding: const EdgeInsets.all(16),
//                               child: Text(fileContent ?? ''),
//                             );
//                           } else {
//                             return const LoadingScreen(
//                                 loadingMessage: "Opening file...");
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (!imageTapped)
//               ListTile(
//                 leading: const BackButton(),
//                 title: Text(widget.file.name),
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: AppTheme.sMedium,
//                 ),
//                 trailing: IconButton(
//                   onPressed: () => showContextAction(widget.file),
//                   icon: const Icon(Icons.more_vert_rounded),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
