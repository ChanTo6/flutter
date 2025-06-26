import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String bookId;
  const PdfViewerScreen({super.key, required this.filePath, required this.bookId});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  int? _lastPage;
  late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
    _loadLastPage();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastPage = prefs.getInt('progress_${widget.bookId}');
    });
  }

  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('progress_${widget.bookId}', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Reader')),
      body: PDFView(
        filePath: widget.filePath,
        defaultPage: _lastPage ?? 0,
        onViewCreated: (controller) {
          _pdfViewController = controller;
        },
        onPageChanged: (page, total) {
          if (page != null) _saveLastPage(page);
        },
      ),
    );
  }
}
