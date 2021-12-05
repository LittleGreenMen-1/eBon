import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ViewReceipt extends StatefulWidget {
  final String url;

  const ViewReceipt({Key? key, required this.url}) : super(key: key);

  @override
  _ViewReceiptState createState() => _ViewReceiptState();
}

class _ViewReceiptState extends State<ViewReceipt> {
  late PDFDocument _pdf;
  bool _isLoading = true;

  void _loadFile() async {
    _pdf = await PDFDocument.fromURL(widget.url);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: _pdf,
            ),
    );
  }
}
