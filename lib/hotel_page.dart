import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

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
    final firebase_storage.Reference ref = firebase_storage
        .FirebaseStorage
        .instance
        .ref(url);
    print(ref);
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File tempFile = File(appDocPath + '/' + basename(url));
    print(tempFile);
    try {
      await ref.writeToFile(tempFile);
      await tempFile.create();
      await openFile(tempFile.path);
    } on firebase_core.FirebaseException {
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

  openFile(String filePath) {
    print(filePath);
    PdfView(path: path.basename(filePath)).then((result) {
      if (result.type == ResultType.done) {
        print('File opened successfully');
      } else {
        print('Error opening file: ${result.message}');
      }
    });
    print(filePath);
  }

  final List<int> colorCodes = <int>[700, 500, 300];

  get downloadProgress => null;

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
              child: FutureBuilder<ListResult>(
                future: listarDocumentos(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: HotelFiles.length,
                    itemBuilder: (context, index) {
                      double? progress = downloadProgress[index];
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
                              subtitle:
                                  progress != null
                                      ? LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.grey,
                                        color: Colors.blue,
                                      )
                                      : null,
                              onTap: () {
                                var inst = FirebaseStorage.instance;
                                print(inst.ref(HotelFiles[index].fullPath));
                                OpenFile.open(
                                  inst
                                      .ref(HotelFiles[index].fullPath)
                                      .getDownloadURL()
                                      .toString(),
                                );
                              },
                              trailing: IconButton(
                                icon: Icon(Icons.download, color: Colors.black),
                                onPressed: () {
                                  urlToFile(HotelFiles[index]);
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
    await Dio().download(
      ref,
      file,
      onReceiveProgress: (received, total) {
        double progress = received / total;

        setState(() {
          downloadProgress[index] = progress;
        });
      },
    );

    await url.writeToFile(File(file as String));

    ScaffoldMessenger.of(
      context as BuildContext,
    ).showSnackBar(SnackBar(content: Text('Download ${url.name}')));
  }
}

extension on PdfView {
  void then(Null Function(dynamic result) param0) {}
}
