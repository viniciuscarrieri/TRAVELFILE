import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:travelfile/app_theme.dart';
import 'package:travelfile/cad_aviao_page.dart' show CadUploadPage;
import 'package:travelfile/services/user_service.dart';

class CadHotelPage extends StatefulWidget {
  const CadHotelPage({super.key});
  @override
  State<CadHotelPage> createState() => _CadHotelPageState();
}

class _CadHotelPageState extends State<CadHotelPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium!',
            ),
          ),
        );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null)
      setState(
        () => _selectedFiles = result.files.map((f) => File(f.path!)).toList(),
      );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/hotel')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium para enviar mais arquivos!',
              ),
            ),
          );
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final task = FirebaseStorage.instance
            .ref(
              'files/${auth.currentUser!.uid}/hotel/${p.basename(file.path)}',
            )
            .putFile(file);
        task.snapshotEvents.listen((e) {
          if (mounted)
            setState(
              () =>
                  _uploadProgress =
                      (i + e.bytesTransferred / e.totalBytes) /
                      _selectedFiles.length,
            );
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CadUploadPage(
    title: 'Documentos de Hotel',
    subtitle: 'Vouchers, reservas, comprovantes',
    icon: Icons.hotel,
    selectedFiles: _selectedFiles,
    isUploading: _isUploading,
    uploadProgress: _uploadProgress,
    onSelectFile: _isUploading ? null : _selectFile,
    onUpload: _isUploading ? null : _uploadFiles,
    onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
  );
}

class CadCarroPage extends StatefulWidget {
  const CadCarroPage({super.key});
  @override
  State<CadCarroPage> createState() => _CadCarroPageState();
}

class _CadCarroPageState extends State<CadCarroPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium para enviar mais arquivos!',
            ),
          ),
        );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null)
      setState(
        () => _selectedFiles = result.files.map((f) => File(f.path!)).toList(),
      );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/carro')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium para enviar mais arquivos!',
              ),
            ),
          );
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final task = FirebaseStorage.instance
            .ref(
              'files/${auth.currentUser!.uid}/carro/${p.basename(file.path)}',
            )
            .putFile(file);
        task.snapshotEvents.listen((e) {
          if (mounted)
            setState(
              () =>
                  _uploadProgress =
                      (i + e.bytesTransferred / e.totalBytes) /
                      _selectedFiles.length,
            );
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CadUploadPage(
    title: 'Documentos de Carro',
    subtitle: 'Locação, apólices, comprovantes',
    icon: Icons.directions_car,
    selectedFiles: _selectedFiles,
    isUploading: _isUploading,
    uploadProgress: _uploadProgress,
    onSelectFile: _isUploading ? null : _selectFile,
    onUpload: _isUploading ? null : _uploadFiles,
    onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
  );
}

class CadIngressosPage extends StatefulWidget {
  const CadIngressosPage({super.key});
  @override
  State<CadIngressosPage> createState() => _CadIngressosPageState();
}

class _CadIngressosPageState extends State<CadIngressosPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium para enviar mais arquivos!',
            ),
          ),
        );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null)
      setState(
        () => _selectedFiles = result.files.map((f) => File(f.path!)).toList(),
      );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/ingressos')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium para enviar mais arquivos!',
              ),
            ),
          );
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final task = FirebaseStorage.instance
            .ref(
              'files/${auth.currentUser!.uid}/ingressos/${p.basename(file.path)}',
            )
            .putFile(file);
        task.snapshotEvents.listen((e) {
          if (mounted)
            setState(
              () =>
                  _uploadProgress =
                      (i + e.bytesTransferred / e.totalBytes) /
                      _selectedFiles.length,
            );
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CadUploadPage(
    title: 'Ingressos',
    subtitle: 'Shows, passeios, eventos',
    icon: Icons.confirmation_number,
    selectedFiles: _selectedFiles,
    isUploading: _isUploading,
    uploadProgress: _uploadProgress,
    onSelectFile: _isUploading ? null : _selectFile,
    onUpload: _isUploading ? null : _uploadFiles,
    onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
  );
}

class CadSeguroPage extends StatefulWidget {
  const CadSeguroPage({super.key});
  @override
  State<CadSeguroPage> createState() => _CadSeguroPageState();
}

class _CadSeguroPageState extends State<CadSeguroPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium para enviar mais arquivos!',
            ),
          ),
        );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null)
      setState(
        () => _selectedFiles = result.files.map((f) => File(f.path!)).toList(),
      );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/seguro')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium para enviar mais arquivos!',
              ),
            ),
          );
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final task = FirebaseStorage.instance
            .ref(
              'files/${auth.currentUser!.uid}/seguro/${p.basename(file.path)}',
            )
            .putFile(file);
        task.snapshotEvents.listen((e) {
          if (mounted)
            setState(
              () =>
                  _uploadProgress =
                      (i + e.bytesTransferred / e.totalBytes) /
                      _selectedFiles.length,
            );
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CadUploadPage(
    title: 'Seguros de Viagem',
    subtitle: 'Apólices, coberturas, certificados',
    icon: Icons.health_and_safety_outlined,
    selectedFiles: _selectedFiles,
    isUploading: _isUploading,
    uploadProgress: _uploadProgress,
    onSelectFile: _isUploading ? null : _selectFile,
    onUpload: _isUploading ? null : _uploadFiles,
    onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
  );
}

class CadTransferPage extends StatefulWidget {
  const CadTransferPage({super.key});
  @override
  State<CadTransferPage> createState() => _CadTransferPageState();
}

class _CadTransferPageState extends State<CadTransferPage> {
  List<File> _selectedFiles = [];
  final auth = FirebaseAuth.instance;
  bool _isUploading = false;
  double _uploadProgress = 0;

  Future<void> _selectFile() async {
    final isPremium = await UserService.isUserPremium();
    if (!isPremium && _selectedFiles.isNotEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Usuários gratuitos podem enviar apenas 1 arquivo. Assine o Premium para enviar mais arquivos!',
            ),
          ),
        );
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: isPremium,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null)
      setState(
        () => _selectedFiles = result.files.map((f) => File(f.path!)).toList(),
      );
  }

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) return;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    final isPremium = await UserService.isUserPremium();
    if (!isPremium) {
      final listResult =
          await FirebaseStorage.instance
              .ref('files/${auth.currentUser!.uid}/transfer')
              .listAll();
      if (listResult.items.length + _selectedFiles.length > 1) {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Você já atingiu o limite de 1 arquivo. Assine o Premium para enviar mais arquivos!',
              ),
            ),
          );
        setState(() {
          _isUploading = false;
        });
        return;
      }
    }
    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });
    try {
      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        final task = FirebaseStorage.instance
            .ref(
              'files/${auth.currentUser!.uid}/transfer/${p.basename(file.path)}',
            )
            .putFile(file);
        task.snapshotEvents.listen((e) {
          if (mounted)
            setState(
              () =>
                  _uploadProgress =
                      (i + e.bytesTransferred / e.totalBytes) /
                      _selectedFiles.length,
            );
        });
        await task;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedFiles.length} arquivo(s) enviado(s)!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: AppTheme.danger),
        );
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => CadUploadPage(
    title: 'Transfer / Translado',
    subtitle: 'Vouchers, comprovantes, reservas',
    icon: Icons.directions_bus,
    selectedFiles: _selectedFiles,
    isUploading: _isUploading,
    uploadProgress: _uploadProgress,
    onSelectFile: _isUploading ? null : _selectFile,
    onUpload: _isUploading ? null : _uploadFiles,
    onRemoveFile: (i) => setState(() => _selectedFiles.removeAt(i)),
  );
}
