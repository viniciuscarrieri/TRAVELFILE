import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CadCarroPage extends StatefulWidget {
  const CadCarroPage({super.key});

  @override
  State<CadCarroPage> createState() => _CadCarroPageState();
}

class _CadCarroPageState extends State<CadCarroPage> {
  List arquivosfile = [];

  final auth = FirebaseAuth.instance;

  // ignore: strict_top_level_inference
  selectFile() async {
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        arquivosfile = result.files.map((file) => File(file.path!)).toList();
      });
    }
  }

  // ignore: strict_top_level_inference
  uploadFile() async {
    for (var arqFiles in arquivosfile) {
      var name = arqFiles.path.split('/').last;
      final path = 'files/${auth.currentUser!.uid}/carro/$name';
      final files = File(arqFiles.path);
      if (!files.existsSync()) {
        print('File does not exist');
      }

      //final refPDF = FirebaseStorage.instance.ref().child(path);

      try {
        //await ref.putFile(files);
        await FirebaseStorage.instance.ref(path).putFile(files);
        print('File uploaded successfully');
      } catch (e) {
        print('Error uploading file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro Carro")),
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

  // ignore: strict_top_level_inference
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
