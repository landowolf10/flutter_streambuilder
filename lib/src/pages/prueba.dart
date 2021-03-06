import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String status, estatusPedido = "No hay ninguna orden";
  StreamController _streamController = StreamController();
  Timer _timer;

  Future getData() async {
    var url = "https://pruebasbotanax.000webhostapp.com/Pedidos/getPedidoID.php";
    final response = await http.post(url,
      body: {
        "nombre": "Luis Orlando Avila Garcia",
        "pedido": "Pasta, Tiritas de pescado, Yoli"
      });

    var data = jsonDecode(response.body);

    print(data);

    status = data[0]["estatus"];

    print(status);

    switch (status) {
      case "1": estatusPedido = "Orden recibida";
        break;
      case "2": estatusPedido = "Preparando la orden";
        break;
    }

    print(estatusPedido);

    //Add your data to stream
    _streamController.add(data);
  }

  void updateOrder() {}

  @override
  void initState() {
    getData();

    //Check the server every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) => getData());

    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: _streamController.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData)
          return ListView(
            children: snapshot.data.map<Widget>((value) {
              return ListTile(
                //title: Text(value['id_c']),
                title: Text(estatusPedido),
              );
            }).toList(),
          );
        return Text('Loading...');
      },
    ) /*StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData)
            return ListView(
              children: snapshot.data.map<Widget>((value) {
                return ListTile(
                  //title: Text(value['id_c']),
                  title: Text(value['nombre']),
                );
              }).toList(),
            );
          return Text('Loading...');
        },
      ),*/
        );
  }
}
