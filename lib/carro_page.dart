import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/pdf_api.dart';
import 'package:travelfile/pdf_view_page.dart';
import 'package:travelfile/shared_widgets.dart';

class CarroPage extends StatefulWidget {
  const CarroPage({super.key});
  @override
  State<CarroPage> createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final auth = FirebaseAuth.instance;
  List<firebase_storage.Reference> carroFiles = [];
  late Future<void> _futureListar;

  @override
  void initState() { super.initState(); _futureListar = listarDocumentos(); }

  Future<void> listarDocumentos() async {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child('files/${auth.currentUser!.uid}/carro');
    carroFiles = (await ref.listAll()).items;
  }

  Future<void> _deleteFile(firebase_storage.Reference ref) async {
    await ref.delete();
    setState(() => _futureListar = listarDocumentos());
  }

  static Future<void> save(firebase_storage.Reference fileRef) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null) { final f = File('$dir/${fileRef.name}'); if (f.existsSync()) await f.delete(); await fileRef.writeToFile(f); OpenFile.open(f.path); }
  }

  void _openPDF(BuildContext ctx, File file) => Navigator.of(ctx).push(MaterialPageRoute(builder: (_) => PDFViewerPage(file: file)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async { await Navigator.of(context).pushNamed('/cad_carro'); setState(() => _futureListar = listarDocumentos()); },
        icon: const Icon(Icons.add_rounded),
        label: Text('Adicionar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: FutureBuilder<void>(
        future: _futureListar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return const EmptyStateWidget(icon: Icons.cloud_off_rounded, message: 'Erro ao carregar arquivos.\nVerifique sua conexão.');
          if (carroFiles.isEmpty) return EmptyStateWidget(icon: Icons.directions_car, message: 'Nenhum documento de carro\nencontrado.', actionLabel: 'Adicionar agora', onAction: () => Navigator.of(context).pushNamed('/cad_carro').then((_) => setState(() => _futureListar = listarDocumentos())));
          return RefreshIndicator(
            onRefresh: () async => setState(() => _futureListar = listarDocumentos()),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: carroFiles.length,
              itemBuilder: (context, index) {
                final file = carroFiles[index];
                return FileCard(
                  fileRef: file,
                  onTap: () async { final ref = firebase_storage.FirebaseStorage.instance.ref(file.fullPath); final url = await ref.getDownloadURL(); final lf = await PDFAPI.loadNetwork(url); if (context.mounted) _openPDF(context, lf); },
                  onDownload: () => save(file),
                  onDelete: () => showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Excluir'), content: Text('Excluir "${file.name}"?'), actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger), onPressed: () { Navigator.of(ctx).pop(); _deleteFile(file); }, child: const Text('Excluir'))])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
