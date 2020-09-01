import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:realtime_update/src/models/clients_model.dart';

List<GetCliente> listaClientes;

class PedidoPage extends StatefulWidget {
  @override
  PedidoPageState createState() => PedidoPageState();
}

class PedidoPageState extends State<PedidoPage> {
  Future<List<GetCliente>> fetchClients() async {
    /*try {
      final result = await InternetAddress.lookup("www.google.com");*/

    //if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    var response = await http
        .get("https://pruebasbotanax.000webhostapp.com/getClients.php");

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      listaClientes = items.map<GetCliente>((json) {
        return GetCliente.fromJson(json);
      }).toList();

      //print(listOfProducts);

    } else {
      throw Exception('Failed to load internet');
    }
    /*}
    } on SocketException catch (_) {
      Dialogos dialogo = new Dialogos();
      dialogo.connectionDialog(context);
    }*/

    return listaClientes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: createFunctions(),
    );
  }

  Widget createFunctions() {
    /*return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[Text("Hola mundo")],
        )
      ],
    );*/

    return FutureBuilder<List<GetCliente>>(
      future: fetchClients(),
      builder:
          (BuildContext context, AsyncSnapshot<List<GetCliente>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return Text('${snapshot.data[index].nombreCliente}');
            /*return Column(
            children: <Widget>[
              // Widget to display the list of project
            ],
          );*/
          },
        );
      },
    );
  }
}
