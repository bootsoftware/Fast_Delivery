import 'package:flutter/material.dart';
import 'package:fast_delivery/telas/Cadastro.dart';
import 'package:fast_delivery/telas/Corrida.dart';
import 'package:fast_delivery/telas/Home.dart';
import 'package:fast_delivery/telas/PainelEntregador.dart';
import 'package:fast_delivery/telas/PainelRestaurante.dart';
import 'package:fast_delivery/telas/PainelEntregas.dart';

class Rotas {

  static Route<dynamic> gerarRotas(RouteSettings settings){

    final args = settings.arguments;

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/cadastro" :
        return MaterialPageRoute(
            builder: (_) => Cadastro()
        );
      case "/painel-entregador" :
        return MaterialPageRoute(
            builder: (_) => PainelEntregador()
        );
      case "/painel-restaurante" :
        return MaterialPageRoute(
            builder: (_) => PainelRestaurante()
        );
      case "/corrida" :
        return MaterialPageRoute(
            builder: (_) => Corrida(
                args
            )
        );
           case "/painel-entregas" :
        return MaterialPageRoute(
            builder: (_) => PainelEntregas(
                args
            )
        );

        
      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!"),),
            body: Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        }
    );

  }

}