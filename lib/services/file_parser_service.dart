// import 'dart:io';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// class FileParserService {
//   Future<String> parseFile(File file) async {
//     final path = file.path.toLowerCase();
//     if (path.endsWith('.txt')) {
//       return await file.readAsString();
//     } else if (path.endsWith('.pdf')) {
//       final bytes = await file.readAsBytes();
//       final document = PdfDocument(inputBytes: bytes);
//       final text = PdfTextExtractor(document).extractText();
//       document.dispose();
//       return text;
//     } else {
//       throw Exception('Unsupported file format');
//     }
//   }
// }
