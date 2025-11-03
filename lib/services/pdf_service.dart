import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Service class for generating PDF reports in the application
class PdfService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generates a PDF report for users
  Future<pw.Document> generateUsersReport() async {
    final pw.Document pdf = pw.Document();
    final List<Map<String, dynamic>> users = await _fetchUsers();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        // Header
        pw.Header(
          level: 0,
          child: pw.Text('Users Report',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Text('Generated on: ${DateTime.now().toString()}',
            style: pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 20),

        // Summary Statistics
        pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          padding: pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Summary Statistics',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Total Users: ${users.length}'),
              pw.Text(
                  'Students: ${users.where((user) => user['role'] == 'Student').length}'),
              pw.Text(
                  'Professors: ${users.where((user) => user['role'] == 'Professor').length}'),
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Users Table
        pw.Header(
          level: 1,
          text: 'Registered Users',
        ),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Name', 'Email', 'Role', 'Registration Date'],
          data: users.map((user) {
            return [
              '${user['firstName']} ${user['lastName']}',
              user['email'],
              user['role'],
              user['registrationDate']?.toDate().toString() ?? 'N/A'
            ];
          }).toList(),
          border: pw.TableBorder.all(width: 1),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
        ),
      ],
    ));

    return pdf;
  }

  /// Generates a PDF report for courses
  Future<pw.Document> generateCoursesReport() async {
    final pw.Document pdf = pw.Document();
    final List<Map<String, dynamic>> courses = await _fetchCourses();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        // Header
        pw.Header(
          level: 0,
          child: pw.Text('Courses Report',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Text('Generated on: ${DateTime.now().toString()}',
            style: pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 20),

        // Summary Statistics
        pw.Container(
          decoration: pw.BoxDecoration(
            color: PdfColors.grey300,
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          padding: pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Summary Statistics',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Total Courses: ${courses.length}'),
              // Add more statistics as needed
            ],
          ),
        ),
        pw.SizedBox(height: 20),

        // Courses Table
        pw.Header(
          level: 1,
          text: 'Available Courses',
        ),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          headers: ['Title', 'Professor', 'Category', 'Enrolled Students'],
          data: courses.map((course) {
            return [
              course['title'],
              course['professorName'],
              course['category'],
              course['enrolledStudents']?.toString() ?? '0'
            ];
          }).toList(),
          border: pw.TableBorder.all(width: 1),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellHeight: 30,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
          },
        ),
      ],
    ));

    return pdf;
  }

  /// Fetches all users from Firestore
  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  /// Fetches all courses from Firestore
  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('courses').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }
}
