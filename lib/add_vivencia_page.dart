import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'vivencia.dart';

class AddVivenciaPage extends StatefulWidget {
  @override
  _AddVivenciaPageState createState() => _AddVivenciaPageState();
}

class _AddVivenciaPageState extends State<AddVivenciaPage> {
  final _formKey = GlobalKey<FormState>();
  late String titulo;
  late DateTime fecha;
  late String descripcion;
  String? fotoPath;
  String? audioPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nueva Vivencia'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Título'),
              onSaved: (value) => titulo = value!,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un título';
                }
                return null;
              },
            ),
            // Aquí agregarías los otros campos para la fecha, descripción, etc.
            // ...
            ElevatedButton(
              onPressed: () async {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  _formKey.currentState!.save();
                  // Guardar nueva vivencia
                  await _saveVivencia();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future _saveVivencia() async {
    final vivencia = Vivencia(
      titulo: titulo,
      fecha: fecha,
      descripcion: descripcion,
      fotoPath: fotoPath,
      audioPath: audioPath,
    );

    await DatabaseHelper.instance.createVivencia(vivencia);
  }

  Future _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        fotoPath = pickedFile.path;
      });
    }
  }
}
