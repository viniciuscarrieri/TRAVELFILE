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

class AviaoPage extends StatefulWidget {
  const AviaoPage({super.key});

  @override
  State<AviaoPage> createState() => _AviaoPageState();
}

class _AviaoPageState extends State<AviaoPage> {
  final auth = FirebaseAuth.instance;
  List<firebase_storage.Reference> aviaoFiles = [];
  late Future<void> _futureListar;

  @override
  void initState() {
    super.initState();
    _futureListar = listarDocumentos();
  }

  Future<void> listarDocumentos() async {
    final ref = firebase_storage.FirebaseStorage.instance.ref().child(
      'files/${auth.currentUser!.uid}/aviao',
    );
    final listResult = await ref.listAll();

    setState(() {
      aviaoFiles = listResult.items;
    });
    //aviaoFiles = listResult.items;
  }

  Future<void> _deleteFile(firebase_storage.Reference ref) async {
    await ref.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Arquivo excluído com sucesso!')),
    );

    await listarDocumentos();
  }

  static Future<void> save(firebase_storage.Reference fileRef) async {
    String? directory = await FilePicker.platform.getDirectoryPath();
    if (directory != null) {
      final File file = File('$directory/${fileRef.name}');
      if (file.existsSync()) await file.delete();
      await fileRef.writeToFile(file);
      OpenFile.open(file.path);
    }
  }

  void _openPDF(BuildContext context, File file) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed('/cad_aviao');
          if (result == true) {
            setState(() async => _futureListar = listarDocumentos());
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Adicionar',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: FutureBuilder<void>(
        future: _futureListar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const EmptyStateWidget(
              icon: Icons.cloud_off_rounded,
              message: 'Erro ao carregar arquivos.\nVerifique sua conexão.',
            );
          }
          if (aviaoFiles.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.airplanemode_active,
              message: 'Nenhum documento aéreo\nencontrado.',
              actionLabel: 'Adicionar agora',
              onAction: () async {
                final result = await Navigator.of(
                  context,
                ).pushNamed('/cad_aviao');
                if (result == true)
                  setState(() => _futureListar = listarDocumentos());
              },
            );
          }
          return RefreshIndicator(
            onRefresh:
                () async => setState(() => _futureListar = listarDocumentos()),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: aviaoFiles.length,
              itemBuilder: (context, index) {
                final file = aviaoFiles[index];
                return FileCard(
                  fileRef: file,
                  onTap: () async {
                    final ref = firebase_storage.FirebaseStorage.instance.ref(
                      file.fullPath,
                    );
                    final url = await ref.getDownloadURL();
                    final localFile = await PDFAPI.loadNetwork(url);
                    if (context.mounted) _openPDF(context, localFile);
                  },
                  onDownload: () => save(file),
                  onDelete: () => _showDeleteDialog(context, file),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, firebase_storage.Reference ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Excluir arquivo'),
            content: Text('Deseja excluir "${ref.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _deleteFile(ref);
                },
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}
