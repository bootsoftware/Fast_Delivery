class FinanceiroModel {
  String idFinanceiro;
  String idRequisiacao;
  double valorPedido;
  String formaPagamento;
  double valorViagem;
  double valorRecebido;
  double taxaApp;
  double valorGanho;

  FinanceiroModel(
      {this.idFinanceiro,
      this.idRequisiacao,
      this.valorPedido,
      this.formaPagamento,
      this.valorViagem,
      this.valorRecebido,
      this.taxaApp,
      this.valorGanho}) {
    this.idFinanceiro ??= '';
    this.idRequisiacao ??= '';
    this.valorPedido ??= 0.0;
    this.formaPagamento ??= '';
    this.valorViagem ??= 0.0;
    this.valorRecebido ??= 0.0;
    this.taxaApp ??= 0.0;
    this.valorGanho ??= 0.0;
  }

  FinanceiroModel.map(dynamic obj, {String documentID}) {
    this.idFinanceiro = documentID;
    this.idRequisiacao = obj["idRequisiacao"];
    this.valorPedido = obj["valorPedido"];
    this.formaPagamento = obj["formaPagamento"];
    this.valorViagem = obj["valorViagem"];
    this.valorRecebido = obj["valorRecebido"];
    this.taxaApp = obj["taxaApp"];
    this.valorGanho = obj["valorGanho"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["idRequisiacao"] = this.idRequisiacao;
    map["valorPedido"] = this.valorPedido;
    map["formaPagamento"] = this.formaPagamento;
    map["valorViagem"] = this.valorViagem;
    map["valorRecebido"] = this.valorRecebido;
    map["taxaApp"] = this.taxaApp;
    map["valorGanho"] = this.valorGanho;

    return map;
  }
}
