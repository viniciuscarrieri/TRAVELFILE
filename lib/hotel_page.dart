import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelfile/pdf_api.dart';
import 'package:travelfile/pdf_view_page.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final auth = FirebaseAuth.instance;
  List HotelFiles = [];

  listarDocumentos() async {
    final ref = FirebaseStorage.instance.ref().child(
      'files/${auth.currentUser!.uid}/hotel',
    );
    final listResult = await ref.listAll();

    for (var item in listResult.items) {
      HotelFiles.add(item);
      print(item.name);
    }
  }

  urlToFile(String url) async {
    final ref = FirebaseStorage.instance.ref(url);
    print("AQUI 1");
    print(ref);
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File tempFile = File('$appDocPath/${basename(url)}');
    print("AQUI 2");
    print(tempFile);
    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await openFile(tempFile.path);
    } on FirebaseException {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(
          content: Text(
            'Error, file tidak bisa diunduh',
            style: Theme.of(context as BuildContext).textTheme.bodyLarge,
          ),
        ),
      );
    }
  }

  static Future<void> save(String fileName) async {
    String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory != null) {
      final File file = File('$directory/$fileName');
      if (file.existsSync()) {
        await file.delete();
      }
    }
    OpenFile.open(fileName);
  }

  openFile(String filePath) async {
    firebase_storage.Reference pdfRef = firebase_storage
        .FirebaseStorage.instanceFor(
      bucket: 'gs://viagens-7973d.firebasestorage.app',
    ).refFromURL(filePath);
    print("AQUI 3");
    print(pdfRef);
    OpenFile.open(pdfRef as String?).then((result) {
      print(result.message);
      print(result.type);
    });
    print(filePath);
  }

  final List<int> colorCodes = <int>[700, 500, 300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/cad_hotel');
        },
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: listarDocumentos(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: HotelFiles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        //color: Colors.blue[colorCodes[index % 3]],
                        child: GestureDetector(
                          child: Card(
                            child: ListTile(
                              leading: returnlogo(HotelFiles[index]),
                              title: Text(
                                HotelFiles[index].name,
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () async {
                                final ref = FirebaseStorage.instance.ref(
                                  HotelFiles[index].fullPath,
                                );
                                final url = await ref.getDownloadURL();
                                final file = await PDFAPI.loadNetwork(url);
                                openPDF(context, file);
                                //openFile(HotelFiles[index].fullPath);
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.download, color: Colors.black),
                                onPressed: () {
                                  save(HotelFiles[index]);
                                },
                              ),
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Excluir arquivo'),
                                        content: Text(
                                          'Deseja excluir o arquivo ${HotelFiles[index].name}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              FirebaseStorage.instance
                                                  .ref(
                                                    HotelFiles[index].fullPath,
                                                  )
                                                  .delete();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Sim'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Não'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    shrinkWrap: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  returnlogo(file) {
    var ex = extension(file.name);
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

  Future downloadFile(int index, Reference url) async {
    final ref = await url.getDownloadURL();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$url.name');

    await url.writeToFile(File(file as String));

    ScaffoldMessenger.of(
      context as BuildContext,
    ).showSnackBar(SnackBar(content: Text('Download ${url.name}')));
  }

  void openPDF(BuildContext context, File file) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)));
}
