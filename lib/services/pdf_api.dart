import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<File> generateTable(
      List<dynamic> headers,
      List<List<dynamic>> data,
      String header,
      String desc,
      String number) async {
    final pdf = Document();

    // final headers = ['Student Name', 'Faculty'];
    // final students = await PdfApi().getStudentList();
    // final data = students
    //     .map((student) => [student['name'], student['specialty']])
    //     .toList();

    pdf.addPage(Page(
        build: (context) => Column(
              children: [
                SizedBox(height: 50),
                Text(
                  header,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),
                Text(
                  desc,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text('$number ${data.length}',
                    style: const TextStyle(fontSize: 16)),
                SizedBox(height: 40),
                Text(
                  ' This Report Is Generated on ${DateTime.now().toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            )));

    pdf.addPage(Page(
      build: (context) => TableHelper.fromTextArray(
        headers: headers,
        data: data,
      ),
    ));

    return saveDocument(name: 'report.pdf', pdf: pdf);
  }

  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();

    pdf.addPage(Page(
      build: (context) => Center(
        child: Text(text, style: const TextStyle(fontSize: 48)),
      ),
    ));

    return saveDocument(name: 'report.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    try {
      final bytes = await pdf.save();
      print("PDF bytes generated: ${bytes.length}");

      final dir = await getApplicationDocumentsDirectory();
      print("Documents directory: ${dir.path}");

      final file = File('${dir.path}/$name');
      print("Saving to: ${file.path}");

      await file.writeAsBytes(bytes);
      print("PDF saved successfully");

      return file;
    } catch (e) {
      print("Error saving PDF: $e");
      rethrow;
    }
  }

  static Future openFile(File file) async {
    try {
      final url = file.path;
      print("Opening PDF at: $url");

      // Check if file exists
      if (!await file.exists()) {
        print("Error: PDF file does not exist at $url");
        throw Exception("PDF file not found");
      }

      print("File size: ${await file.length()} bytes");

      final result = await OpenFile.open(url);
      print("OpenFile result: ${result.message}");
    } catch (e) {
      print("Error opening PDF: $e");
      rethrow;
    }
  }
}

class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});
}
