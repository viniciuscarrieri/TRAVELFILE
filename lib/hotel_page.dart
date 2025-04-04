import 'package:flutter/material.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/cad_hotel');
        },
      ),
      body: const Center(child: Text('Hotel')),
    );
  }
}
