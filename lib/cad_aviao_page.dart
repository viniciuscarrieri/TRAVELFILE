import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadAviaoPage extends StatefulWidget {
  const CadAviaoPage({super.key});

  @override
  State<CadAviaoPage> createState() => _CadAviaoPageState();
}

class _CadAviaoPageState extends State<CadAviaoPage> {
  String sigla_aero_partida = '';
  String sigla_aero_chegada = '';
  String aero_partida = '';
  String aero_chegada = '';
  String cid_partida = '';
  String cid_chegada = '';
  String data_partida = '';
  String data_chegada = '';
  String reserva = '';
  String nro_voo = '';
  String emp_aero = '';
  String terminal_emb = '';
  String grupo_emb = '';
  String hora_emb_inicio = '';
  String hora_emb_fim = '';
  String acento_emb = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro Avião')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (text) {
                          sigla_aero_partida = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Sigla Aeroporto Partida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          sigla_aero_chegada = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Sigla Aeroporto Chegada',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          aero_partida = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Aeroporto Partida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          aero_chegada = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Aeroporto Chegada',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          cid_partida = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Cidade Partida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          cid_chegada = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Cidade Chegada',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          data_partida = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Data Partida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          data_chegada = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Data Chegada',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          reserva = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Reserva',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          nro_voo = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nro Voo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          emp_aero = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Empresa Aerea',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          terminal_emb = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Terminal Embarque',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          grupo_emb = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Grupo Embarque',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          hora_emb_inicio = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Hora do Inicio do Embarque',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          hora_emb_fim = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Hora do Fim do Embarque',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        onChanged: (text) {
                          acento_emb = text;
                        },
                        decoration: InputDecoration(
                          labelText: 'Acento',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (aero_partida != "") {
                        try {
                          store
                              .collection(
                                'VOOS/${auth.currentUser!.uid}/$hashCode',
                              )
                              .add({
                                'uid': auth.currentUser!.uid,
                                'sigla_aero_partida': sigla_aero_partida,
                                'sigla_aero_chegada': sigla_aero_chegada,
                                'aero_partida': aero_partida,
                                'aero_chegada': aero_chegada,
                                'cid_partida': cid_partida,
                                'cid_chegada': cid_chegada,
                                'data_partida': data_partida,
                                'data_chegada': data_chegada,
                                'reserva': reserva,
                                'nro_voo': nro_voo,
                                'emp_aero': emp_aero,
                                'terminal_emb': terminal_emb,
                                'grupo_emb': grupo_emb,
                                'hora_emb_inicio': hora_emb_inicio,
                                'hora_emb_fim': hora_emb_fim,
                                'acento_emb': acento_emb,
                                'dataCadastro': DateTime.now(),
                                'status': 'ativo',
                              });
                          AlertDialog();
                          Navigator.of(context).pushReplacementNamed('/home');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-email") {
                            debugPrint("Digite um email válido");
                          } else if (e.code == "invalid-credential") {
                            debugPrint("Digite a senha Correta!");
                          } else if (e.code == "channel-error") {
                            debugPrint("Campo vazio!");
                          }
                          debugPrint("Mensagem pega ${e.message}");
                          debugPrint("Código pego ${e.code}");
                        }
                      }
                    },
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
