import 'package:flutter/material.dart';

class CarroPage extends StatefulWidget {
  const CarroPage({super.key});

  @override
  State<CarroPage> createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/cad_carro');
        },
      ),
      body: const Center(child: Text('Carro')),
    );
  }
}
