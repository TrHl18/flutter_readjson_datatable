import 'package:flutter/material.dart';
import 'package:flutter_readjson_datatable/interfaces/noticias.dart';
import 'package:flutter_readjson_datatable/provider/provider.dart';
void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Noticias DataTable'),
        ),
        body: Center(
          child: showDataTable(),
        ),
      ),
    );
  }

  Widget showDataTable() {
    return FutureBuilder<List<Noticias>>(
      future: listNoticias.cargarNoticias(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<Noticias>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error al cargar las noticias');
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