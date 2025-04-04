import 'package:flutter/material.dart';

class RotasPage extends StatefulWidget {
  const RotasPage({super.key});

  @override
  State<RotasPage> createState() => _RotasPageState();
}

class _RotasPageState extends State<RotasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: const Center(child: Text('Rotas')),
    );
  }
}
