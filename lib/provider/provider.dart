

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_readjson_datatable/interfaces/noticias.dart';
import 'dart:convert' as convert;



class _ProviderNoticias {
Future<List<Noticias>> cargarNoticias() async {
    List<Noticias> data=[];
    final _datosJson = await rootBundle.loadString('database/table.json');
    List<dynamic> datosList = convert.jsonDecode(_datosJson);
return datosList.map((e) => Noticias.fromJson(e)).toList();
  }
}

final listNoticias = _ProviderNoticias();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Noticias DataTable'),
        ),
        body: DataTableDemo(),
      ),
    );
  }
}

class DataTableDemo extends StatefulWidget {
  @override
  _DataTableDemoState createState() => _DataTableDemoState();
}

class _DataTableDemoState extends State<DataTableDemo> {
  late Future<List<Noticias>> _noticias;

  @override
  void initState() {
    super.initState();
    _noticias = listNoticias.cargarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Noticias>>(
      future: _noticias,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar las noticias'),
          );
        } else {
          List<Noticias> noticias = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Título')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Imagen')),
                DataColumn(label: Text('Fecha de Publicación')),
              ],
              rows: noticias.map((noticia) {
                return DataRow(cells: [
                  DataCell(Text(noticia.titulo)),
                  DataCell(Text(noticia.descripcion)),
                  DataCell(Image.network(noticia.imagen)),
                  DataCell(Text(noticia.fechaPublicacion ?? 'N/A')),
                ]);
              }).toList(),
            ),
          );
        }
      },
    );
  }
}