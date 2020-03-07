import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fast_delivery/util/StatusRequisicao.dart';
import 'package:fast_delivery/util/UsuarioFirebase.dart';

class PainelEntregador extends StatefulWidget {
  @override
  _PainelEntregadorState createState() => _PainelEntregadorState();
}

class _PainelEntregadorState extends State<PainelEntregador> {
  List<String> itensMenu = ["Configurações", "Deslogar"];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUsuario();
        break;
      case "Configurações":
        break;
    }
  }

  Stream<QuerySnapshot> _adicionarListenerRequisicoes() {
    final stream = db
        .collection("requisicoes")
        .where("status", isEqualTo: StatusRequisicao.AGUARDANDO)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperaRequisicaoAtivaMotorista() async {
    //Recupera dados do usuario logado

    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();

    //Recupera requisicao ativa
    DocumentSnapshot documentSnapshot = await db
        .collection("requisicao_ativa_motorista")
        .document(firebaseUser.uid)
        .get();

    var dadosRequisicao = documentSnapshot.data;

    if (dadosRequisicao == null) {
      _adicionarListenerRequisicoes();
    } else {
      String idRequisicao = dadosRequisicao["id_requisicao"];
      Navigator.pushReplacementNamed(context, "/corrida",
          arguments: idRequisicao);
    }
  }

  _bemVindo() async {
    DocumentSnapshot user;
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    user = await db.collection("usuarios").document(firebaseUser.uid).get();
    setState(() {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Olá, ${user["nome"]}, Seja bem vindo!'),
          backgroundColor: Colors.green));
    });
  }

  @override
  void initState() {
    super.initState();
    _bemVindo();
    /*
    Recupera requisicao ativa para verificar se motorista está
    atendendo alguma requisição e envia ele para tela de corrida
    */
    _recuperaRequisicaoAtivaMotorista();
  }

  @override
  Widget build(BuildContext context) {
    var mensagemCarregando = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando requisições"),
          CircularProgressIndicator()
        ],
      ),
    );

    var mensagemNaoTemDados = Center(
      child: Text(
        "Você não tem nenhuma requisição :( ",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Painel Entregador"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return mensagemCarregando;
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text("Erro ao carregar os dados!");
                } else {
                  QuerySnapshot querySnapshot = snapshot.data;
                  if (querySnapshot.documents.length == 0) {
                    return mensagemNaoTemDados;
                  } else {
                    return ListView.separated(
                        itemCount: querySnapshot.documents.length,
                        separatorBuilder: (context, indice) => Divider(
                              height: 2,
                              color: Colors.grey,
                            ),
                        itemBuilder: (context, indice) {
                          List<DocumentSnapshot> requisicoes =
                              querySnapshot.documents.toList();
                          DocumentSnapshot item = requisicoes[indice];

                          String idRequisicao = item["id"];
                          String nomePassageiro = item["passageiro"]["nome"];
                          String rua = item["destino"]["rua"];
                          String numero = item["destino"]["numero"];

                          return ListTile(
                            title: Text(nomePassageiro),
                            subtitle: Text("destino: $rua, $numero"),
                            onTap: () {
                              Navigator.pushNamed(context, "/corrida",
                                  arguments: idRequisicao);
                            },
                          );
                        });
                  }
                }

                break;
            }
          }),
    );
  }
}
