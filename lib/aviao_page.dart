import 'package:flutter/material.dart';

class AviaoPage extends StatefulWidget {
  const AviaoPage({super.key});

  @override
  State<AviaoPage> createState() => _AviaoPageState();
}

class _AviaoPageState extends State<AviaoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/cad_aviao');
        },
      ),

      body: const Center(child: Text('Avião')),
    );
  }
}
