import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;

  // ignore: use_super_parameters
  const PDFViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  PDFViewController? controller;
  int pages = 0;
  int indexpage = 0;

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    final text = "${indexpage + 1} of $pages";

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions:
            pages >= 2
                ? [
                  Center(child: Text(text)),
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 32),
                    onPressed: () {
                      final index = indexpage == 0 ? pages : indexpage - 1;
                      controller!.setPage(index - 1);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 32),
                    onPressed: () {
                      final index = indexpage == pages - 1 ? 0 : indexpage + 1;
                      controller!.setPage(index);
                    },
                  ),
                ]
                : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageSnap: true,
        pageFling: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        onRender:
            (pages) => setState(() {
              this.pages = pages!;
            }),
        onViewCreated:
            (controller) => setState(() {
              this.controller = controller;
            }),
        onPageChanged:
            (indexpage, _) => setState(() {
              this.indexpage = indexpage!;
            }),
        preventLinkNavigation:
            false, // if set to true the link is handled in flutter
      ),
    );
  }
}
