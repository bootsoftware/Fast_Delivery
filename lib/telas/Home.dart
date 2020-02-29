import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fast_delivery/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerEmail =
      TextEditingController(text: 'wanderlei.safira@gmail.com');
  TextEditingController _controllerSenha =
      TextEditingController(text: '12345678');

  bool _carregando = false;

  Usuario usuario;
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _validarCampos() {
    print('_validarCampos()');
    //Recuperar dados dos campos
    // usuario.toMap().clear();

    usuario.email = _controllerEmail.text;
    usuario.senha = _controllerSenha.text;

    //validar campos
    if (usuario.email.isNotEmpty && usuario.email.contains("@")) {
      if (usuario.senha.isNotEmpty && usuario.senha.length >= 8) {
        //_loadUser();
        _logarUsuario();
      } else {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Preencha a senha! digite mais de 8 caracteres',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red,
          ));
        });
      }
    } else {
      setState(() {
        _carregando = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Preencha o E-mail válido',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  _logarUsuario() {
    print('_logarUsuario');

    setState(() {
      _carregando = true;
    });
    print('antes auth ' + usuario.toMap().toString());
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      usuario.idUsuario = firebaseUser.user.uid;
      print('apos auth ' + usuario.toMap().toString()+'  '+firebaseUser.user.uid);
      _loadUser();

      //primeira vez ta trazendo null    ===================================

      print(usuario.toMap().toString());

      if (usuario.status == 2) {
        setState(() {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Olá, ${usuario.nome}  Seja bem vindo!'),
              backgroundColor: Colors.green));
          _carregando = false;
        });

        _redirecionaPainelPorTipoUsuario();
      } else {
        setState(() {
          _carregando = false;
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Agradecemos o seu interesse em fazer parte da nossa equipe! \n\n Aguarde a liberação no seu e-mail!',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Colors.red,
          ));
        });
      }
    }).catchError((error) {
      setState(() {
        _carregando = false;
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              'Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!'),
          backgroundColor: Colors.red,
        ));
      });
    });
  }

  _loadUser() async {
    print('_loadUser()');
    //Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(usuario.idUsuario).get();

    Map<String, dynamic> dados = snapshot.data;
//primeira vez ta vindo null    ===============================================================
    usuario.idUsuario = dados["idUsuario"];
    usuario.email = dados["email"];
    usuario.senha = dados["senha"];
    usuario.nome = dados["nome"];
    usuario.status = dados["status"];
    usuario.tipoUsuario = dados["tipoUsuario"];
    usuario.latitude = dados["latitude"];
    usuario.longitude = dados["longitude"];
  }

  _redirecionaPainelPorTipoUsuario() {
    print('_redirecionaPainelPorTipoUsuario()');

    switch (usuario.tipoUsuario) {
      case "Entregador":
        Navigator.pushReplacementNamed(context, "/painel-entregador");
        break;
      case "Restaurante":
        Navigator.pushReplacementNamed(context, "/painel-restaurante");
        break;
    }
    setState(() {
      _carregando = false;
    });
  }

  _verificarUsuarioLogado() async {
    print('_verificarUsuarioLogado()');
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {
      usuario.idUsuario = usuarioLogado.uid;

      _loadUser();
      _redirecionaPainelPorTipoUsuario();
    }
  }

  @override
  void initState() {
    super.initState();
    usuario = Usuario();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/fundo.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                TextField(
                  controller: _controllerEmail,
                  autofocus:
                      false, //----------------------------------------------------------------------
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
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 40),
                  child: RaisedButton(
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Color(0xff1ebbd8),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Center(
                  child: GestureDetector(
                    child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/cadastro");
                    },
                  ),
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
