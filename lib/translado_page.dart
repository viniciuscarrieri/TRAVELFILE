import 'package:flutter/material.dart';

class TransladoPage extends StatefulWidget {
  const TransladoPage({super.key});

  @override
  State<TransladoPage> createState() => _TransladoPageState();
}

class _TransladoPageState extends State<TransladoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: const Center(child: Text('Translado')),
    );
  }
}
