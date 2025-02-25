import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Regresar a la pantalla anterior
            Navigator.pop(context);
          },
          child: const Text("Volver a la pantalla anterior"),
        ),
      ),
    );
  }
}


//hola bebes como estan 2 