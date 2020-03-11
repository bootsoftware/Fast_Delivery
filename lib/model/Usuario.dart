class Usuario {
  String _idUsuario;
  String _nome;
  String _sobreNome;
  String _celular;
  String _email;
  String _cpf;
  String _senha;
  String _tipoUsuario;
  int _status;
  double _valorReceber;
  double _valorRecebido;

  double _latitude;
  double _longitude;

  Usuario();

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": this.idUsuario ??= '',
      "nome": this.nome ??= '',
      "sobreNome": this.sobreNome ??= '',
      "celular": this.celular ??= '',
      "email": this.email ??= '',
      "cpf": this.cpf ??= '',
      "tipoUsuario": this.tipoUsuario ??= '',
      "valorReceber": this.valorReceber ??= 0.0,
      "valorRecebido": this.valorRecebido ??= 0.0,
      "status": this.status ??= 1,
      "latitude": this.latitude ??= 0.0,
      "longitude": this.longitude ??= 0.0,
    };
    // print(map.toString());

    return map;
  }

  String verificaTipoUsuario(bool tipoUsuario) {
    return tipoUsuario ? "Entregador" : "Restaurante";
  }

  String get tipoUsuario => _tipoUsuario;

  set tipoUsuario(String value) {
    _tipoUsuario = value;
  }

  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get sobreNome => _sobreNome;

  set sobreNome(String value) {
    _sobreNome = value;
  }

  String get celular => _celular;

  set celular(String value) {
    _celular = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get valorReceber => _valorReceber;

  set valorReceber(double value) {
    _valorReceber = value;
  }

  double get valorRecebido => _valorRecebido;

  set valorRecebido(double value) {
    _valorRecebido = value;
  }
}
