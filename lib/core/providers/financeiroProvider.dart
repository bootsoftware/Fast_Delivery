import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_delivery/core/model/financeiroModel.dart';
import 'package:fast_delivery/core/providers/apiProvider.dart';

class FinanceiroProvider {
  ApiProvider _apiProvider = ApiProvider('financeiro');

  Future<FinanceiroModel> getFinanceiro(String idFinanceiro) async {
    await _apiProvider.streamDataCollectionById(idFinanceiro).listen((dados) {
      FinanceiroModel _financeiro = FinanceiroModel.map(dados.data);
      print("Retorno  provider " + _financeiro.toMap().toString());
      return _financeiro;
    });
  }

  void create(FinanceiroModel financeiro) {
    _apiProvider.create(financeiro.toMap());
  }

  void update(FinanceiroModel financeiro) {
    _apiProvider.update(financeiro.toMap(), financeiro.idFinanceiro);
  }

  void delete(FinanceiroModel financeiro) {
    _apiProvider.delete(financeiro.idFinanceiro);
  }
}
