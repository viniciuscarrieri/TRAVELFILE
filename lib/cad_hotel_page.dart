import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class CadHotelPage extends StatefulWidget {
  const CadHotelPage({super.key});

  @override
  State<CadHotelPage> createState() => _CadHotelPageState();
}

class _CadHotelPageState extends State<CadHotelPage> {
  List arquivosfile = [];

  final auth = FirebaseAuth.instance;

  selectFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        arquivosfile = result.files.map((file) => File(file.name)).toList();
      });
    }
  }

  uploadFile() async {
    for (var file in arquivosfile) {
      final path = 'files/${auth.currentUser!.uid}/hotel/${file.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
    }
  }
  /*
  uploadFile() async {
    final path = 'files/${auth.currentUser!.uid}/hotel/${arquivosfile.name}';
    final file = File(arquivosfile.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro Hotel")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Selecione o arquivo', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectFile,
              child: Text('Selecionar arquivo'),
            ),
            SizedBox(height: 20),
            arquivosfile.isNotEmpty
                ? ListView.builder(
                  itemCount: arquivosfile.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => OpenFile.open(arquivosfile[index]),
                      child: Card(
                        child: ListTile(
                          leading: returnlogo(arquivosfile[index]),
                          subtitle: Text(
                            'File: ${arquivosfile[index].path}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadFile();
              },
              child: Text('Enviar arquivo'),
            ),
          ],
        ),
      ),
    );
  }

  returnlogo(file) {
    var ex = extension(file.path);
    if (ex == '.jpg') {
      return Icon(Icons.image, color: Colors.blue);
    } else if (ex == '.pdf') {
      return Icon(Icons.picture_as_pdf, color: Colors.red);
    } else if (ex == '.doc') {
      return Icon(Icons.description, color: Colors.green);
    } else {
      return Icon(Icons.file_present, color: Colors.grey);
    }
  }
}
