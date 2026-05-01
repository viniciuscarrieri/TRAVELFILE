import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:travelfile/app_theme.dart';

// ─── Empty State ────────────────────────────────────────
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accent.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppTheme.accent),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── File Card para listas ───────────────────────────────
class FileCard extends StatelessWidget {
  final firebase_storage.Reference fileRef;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onDelete;

  const FileCard({
    super.key,
    required this.fileRef,
    this.onTap,
    this.onDownload,
    this.onDelete,
  });

  Color _extensionColor(String ext) {
    switch (ext) {
      case '.pdf':
        return AppTheme.danger;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return AppTheme.accent;
      case '.doc':
      case '.docx':
        return const Color(0xFF2B579A);
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _extensionIcon(String ext) {
    switch (ext) {
      case '.pdf':
        return Icons.picture_as_pdf_rounded;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image_rounded;
      case '.doc':
      case '.docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = extension(fileRef.name).toLowerCase();
    final color = _extensionColor(ext);
    final iconData = _extensionIcon(ext);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(iconData, color: color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileRef.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withAlpha(20),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ext.toUpperCase().replaceAll('.', ''),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download_rounded,
                          color: AppTheme.accent, size: 22),
                      onPressed: onDownload,
                      tooltip: 'Baixar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          color: AppTheme.danger, size: 22),
                      onPressed: onDelete,
                      tooltip: 'Excluir',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Selected File Card para upload ─────────────────────
class SelectedFileCard extends StatelessWidget {
  final String name;
  final String ext;
  final int size;
  final VoidCallback onRemove;

  const SelectedFileCard({
    super.key,
    required this.name,
    required this.ext,
    required this.size,
    required this.onRemove,
  });

  Color get _color {
    switch (ext) {
      case '.pdf':
        return AppTheme.danger;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return AppTheme.accent;
      case '.doc':
      case '.docx':
        return const Color(0xFF2B579A);
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData get _icon {
    switch (ext) {
      case '.pdf':
        return Icons.picture_as_pdf_rounded;
      case '.jpg':
      case '.jpeg':
      case '.png':
        return Icons.image_rounded;
      case '.doc':
      case '.docx':
        return Icons.description_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  String get _sizeLabel {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _sizeLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                color: AppTheme.danger, size: 20),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
