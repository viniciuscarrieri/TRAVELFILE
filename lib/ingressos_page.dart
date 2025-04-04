import 'package:flutter/material.dart';

class IngressosPage extends StatefulWidget {
  const IngressosPage({super.key});

  @override
  State<IngressosPage> createState() => _IngressosPageState();
}

class _IngressosPageState extends State<IngressosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: const Center(child: Text('Ingressos')),
    );
  }
}
