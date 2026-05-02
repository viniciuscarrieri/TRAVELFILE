import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/aviao_page.dart';
import 'package:travelfile/shared_widgets.dart';
import 'package:travelfile/services/user_service.dart';

class CadAviaoPage extends StatefulWidget {
  const CadAviaoPage({super.key});

  @override
  State<CadAviaoPage> createState() => _CadAviaoPageState();
}

class _CadAviaoPageState extends State<CadAviaoPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium para enviar mais arquivos.',
            ),
          ),
        );
      }
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null) {
      setState(() {
        _selectedFiles = result.files.map((f) => File(f.path!)).toList();
      });
    }
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos um arquivo.')),
      );
      return;
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/aviao')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium!',
              ),
            ),
          );
        }
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final name = p.basename(file.path);
        final path = 'files/${auth.currentUser!.uid}/aviao/$name';
        final task = FirebaseStorage.instance.ref(path).putFile(file);
        task.snapshotEvents.listen((event) {
          if (mounted) {
            setState(() {
              _uploadProgress =
                  (i + event.bytesTransferred / event.totalBytes) /
                  _selectedFiles.length;
            });
          }
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
              ],
            ),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CadUploadPage(
      title: 'Documentos Aéreos',
      subtitle: 'Passagens, check-in, boarding pass',
      icon: Icons.airplanemode_active,
      selectedFiles: _selectedFiles,
      isUploading: _isUploading,
      uploadProgress: _uploadProgress,
      onSelectFile: _isUploading ? null : _selectFile,
      onUpload: _isUploading ? null : _uploadFiles,
      onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
    );
  }
}

// ─── Widget compartilhado para todas as cad pages ───────
class CadUploadPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<File> selectedFiles;
  final bool isUploading;
  final double uploadProgress;
  final VoidCallback? onSelectFile;
  final VoidCallback? onUpload;
  final void Function(int) onRemoveFile;

  const CadUploadPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selectedFiles,
    required this.isUploading,
    required this.uploadProgress,
    required this.onSelectFile,
    required this.onUpload,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: AppTheme.accent),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onSelectFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(
                    color: AppTheme.accent.withAlpha(100),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: AppTheme.accent,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Toque para selecionar arquivos',
                      style: GoogleFonts.poppins(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, DOC, JPG, PNG',
                      style: GoogleFonts.poppins(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedFiles.isNotEmpty) ...[
              Text(
                '${selectedFiles.length} arquivo(s) selecionado(s)',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = selectedFiles[index];
                    final name = p.basename(file.path);
                    final ext = p.extension(file.path).toLowerCase();
                    final size = file.lengthSync();
                    return SelectedFileCard(
                      name: name,
                      ext: ext,
                      size: size,
                      onRemove: () => onRemoveFile(index),
                    );
                  },
                ),
              ),
            ] else
              const Spacer(),
            if (isUploading) ...[
              const SizedBox(height: 12),
              Text(
                'Enviando... ${(uploadProgress * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: uploadProgress,
                  minHeight: 8,
                  backgroundColor: AppTheme.borderColor,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
                ),
              ),
              const SizedBox(height: 16),
            ],
            GradientButton(
              label: 'Enviar arquivos',
              icon: Icons.cloud_upload_rounded,
              onPressed: isUploading ? null : onUpload,
              isLoading: isUploading,
            ),
          ],
        ),
      ),
    );
  }
}
