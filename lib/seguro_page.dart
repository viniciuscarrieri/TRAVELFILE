import 'package:flutter/material.dart';

class SeguroPage extends StatefulWidget {
  const SeguroPage({super.key});

  @override
  State<SeguroPage> createState() => _SeguroPageState();
}

class _SeguroPageState extends State<SeguroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/cad_seguro');
        },
      ),
      body: const Center(child: Text('Seguro')),
    );
  }
}
