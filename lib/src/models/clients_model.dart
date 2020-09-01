class GetCliente {
  String idCliente, nombreCliente;

  GetCliente({this.idCliente, this.nombreCliente});

  factory GetCliente.fromJson(Map<String, dynamic> json) {
    return GetCliente(idCliente: json['id_c'], nombreCliente: json['nombre']);
  }
}
