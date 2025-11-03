// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PdfViewerScreen extends StatefulWidget {
//   final Uint8List pdfData;
//   final String title;

//   const PdfViewerScreen({
//     super.key,
//     required this.pdfData,
//     required this.title,
//   });

//   @override
//   State<PdfViewerScreen> createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   int? _totalPages;
//   int _currentPage = 0;
//   bool _isReady = false;
//   PDFViewController? _pdfViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               // Implement sharing functionality if needed
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.grey,
//               ),
//               child: PDFView(
//                 pdfData: widget.pdfData,
//                 enableSwipe: true,
//                 swipeHorizontal: false,
//                 autoSpacing: true,
//                 pageFling: true,
//                 onRender: (pages) {
//                   setState(() {
//                     _totalPages = pages;
//                     _isReady = true;
//                   });
//                 },
//                 onViewCreated: (PDFViewController pdfViewController) {
//                   _pdfViewController = pdfViewController;
//                 },
//                 onPageChanged: (page, total) {
//                   setState(() {
//                     _currentPage = page!;
//                   });
//                 },
//                 onError: (error) {
//                   print('Error loading PDF: $error');
//                 },
//               ),
//             ),
//           ),
//           if (_isReady)
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('${_currentPage + 1}/$_totalPages'),
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.chevron_left),
//                         onPressed: () {
//                           if (_currentPage > 0 && _pdfViewController != null) {
//                             _pdfViewController!.setPage(_currentPage - 1);
//                           }
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.chevron_right),
//                         onPressed: () {
//                           if (_currentPage < _totalPages! - 1 &&
//                               _pdfViewController != null) {
//                             _pdfViewController!.setPage(_currentPage + 1);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
