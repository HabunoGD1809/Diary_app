import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'vivencia.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diario de Vivencias',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VivenciasListPage(),
    );
  }
}

class VivenciasListPage extends StatefulWidget {
  @override
  _VivenciasListPageState createState() => _VivenciasListPageState();
}

class _VivenciasListPageState extends State<VivenciasListPage> {
  late List<Vivencia> vivencias;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshVivencias();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close();
    super.dispose();
  }

  Future refreshVivencias() async {
    setState(() => isLoading = true);

    this.vivencias = await DatabaseHelper.instance.readAllVivencias();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Vivencias'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : vivencias.isEmpty
          ? Text('No hay vivencias registradas.')
          : buildVivencias(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}, // Aquí iría la navegación al formulario de registro
      ),
    );
  }

  Widget buildVivencias() => ListView.builder(
    itemCount: vivencias.length,
    itemBuilder: (context, index) {
      final vivencia = vivencias[index];

      return ListTile(
        leading: Image.asset(vivencia.fotoPath ?? 'assets/placeholder.png'),
        title: Text(vivencia.titulo),
        subtitle: Text(vivencia.fecha.toString()),
        onTap: () {}, // Aquí iría la navegación al detalle de la vivencia
      );
    },
  );
}
