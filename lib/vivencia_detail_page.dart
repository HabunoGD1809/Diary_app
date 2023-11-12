import 'package:flutter/material.dart';
import 'vivencia.dart';

class VivenciaDetailPage extends StatelessWidget {
  final Vivencia vivencia;

  const VivenciaDetailPage({
    Key? key,
    required this.vivencia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vivencia.titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Si hay una foto, mostrarla, si no, mostrar un placeholder
            vivencia.fotoPath != null
                ? Image.file(File(vivencia.fotoPath!))
                : Image.asset('assets/placeholder.png'),
            // Aquí iría el reproductor de audio, si hay una nota de voz
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                vivencia.descripcion,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            // Otras propiedades de la vivencia si desearas agregar más
          ],
        ),
      ),
    );
  }
}
