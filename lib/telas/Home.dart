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

  //Usuario usuario;
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore db = Firestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _validarCampos() {
    //Recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validar campos
    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 5) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);
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
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    setState(() {
      _carregando = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      _redirecionaPainelPorTipoUsuario(firebaseUser.user.uid);
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

  _redirecionaPainelPorTipoUsuario(String idUsuario) async {
    Firestore db = Firestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(idUsuario).get();

    Map<String, dynamic> dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];
    int status = dados["status"];

    setState(() {
      _carregando = false;
    });
    print(dados["status"]);
    //String s = dados["status"];
    if (status == 2) {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Olá, ${dados["nome"]}, Seja bem vindo!'),
            backgroundColor: Colors.green));
        _carregando = false;
      });
 print(tipoUsuario);
      switch (tipoUsuario) {
        case "Entregador":
          Navigator.pushReplacementNamed(context, "/painel-entregador");
          break;
        case "Restaurante":
          Navigator.pushReplacementNamed(context, "/painel-restaurante");
          break;
      }
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
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      _redirecionaPainelPorTipoUsuario(idUsuario);
    }
  }

  @override
  void initState() {
    super.initState();
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
