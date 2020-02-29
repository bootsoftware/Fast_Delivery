import 'package:flutter/material.dart';
import 'package:fast_delivery/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerSobreNome = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerConfirmarSenha = TextEditingController();

  bool _tipoUsuario = false;
  bool _carregando = false;
  Usuario usuario = Usuario();
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _validarCampos() {
    //validar campos
    if (usuario.nome.isNotEmpty) {
      print(usuario.nome);
      if (usuario.email.isNotEmpty && usuario.email.contains("@")) {
        if (usuario.senha.isNotEmpty && usuario.senha.length >= 6) {
          if (usuario.senha == _controllerConfirmarSenha) {
            usuario.tipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);

            setState(() {
              _carregando = true;
            });

            _cadastrarUsuario();
            _verificarUsuarioLogado();

            setState(() {
              _carregando = false;
            });
          } else {
            setState(() {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  'Preencha a senha! digite mais de 5 caracteres!',
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Colors.red,
              ));
            });
          }
        } else {
          setState(() {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(
                'senhas não conferem!',
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Colors.red,
            ));
            //_mensagemErro = "Preencha o E-mail válido";
          });
        }
      } else {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Preencha o E-mail válido!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red,
          ));
          //_mensagemErro = "Preencha o E-mail válido";
        });
      }
    } else {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Preencha o Nome',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ));

        // _mensagemErro = "Preencha o Nome";
      });
    }
  }

  _loadUser() {
    usuario.nome = _controllerNome.text;
    usuario.sobreNome = _controllerSobreNome.text;
    usuario.email = _controllerEmail.text;
    usuario.cpf = _controllerCpf.text;
    usuario.celular = _controllerCelular.text;
    usuario.senha = _controllerSenha.text;
  }

  _cadastrarUsuario() async {
    await auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      usuario.idUsuario = firebaseUser.user.uid;
      db
          .collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());

      //redireciona para o painel, de acordo com o tipoUsuario
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Cadastro realizado com Sucesso! \n\n Agradecemos o seu interesse em fazer parte da nossa equipe! \n\n Aguarde a liberação no seu e-mail!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ));
      });
      // _deslogarUsuario();
      // Navigator.pushReplacementNamed(context, "/");

      /* showDialog(
          context: context,
          builder: (contex) {
            return AlertDialog(
              title: Text("Confirmação de Cadastro",
                  style: TextStyle(color: Colors.green)),
              content: Text(_mensagemOk),
              contentPadding: EdgeInsets.all(16),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Confirmar",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    _deslogarUsuario();
                    Navigator.pushReplacementNamed(context, "/");
                  },
                )
              ],
            );
          });*/
    }).catchError((error) {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Erro ao cadastrar usuário, verifique os campos e tente novamente!',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ));
      });
      // _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente!";
    });
  }

  _verificarUsuarioLogado() async {
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {
      _deslogarUsuario();
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    usuario.toMap().clear();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _controllerNome,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerSobreNome,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Sobre Nome",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerCpf,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "CPF",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerCelular,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Celular",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                TextField(
                  controller: _controllerConfirmarSenha,
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Confirmar a Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text("Restaurante"),
                      Switch(
                          value: _tipoUsuario,
                          onChanged: (bool valor) {
                            setState(() {
                              _tipoUsuario = valor;
                            });
                          }),
                      Text("Entregador"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xff1ebbd8),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _loadUser();
                        _validarCampos();
                      }),
                ),
                _carregando
                    ? Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ))
                    : Container(),
                /* Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
