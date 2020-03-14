import 'package:fast_delivery/core/model/financeiroModel.dart';
import 'package:fast_delivery/core/providers/financeiroProvider.dart';

class FinanceiroController {
  FinanceiroProvider _financeiroProvider = FinanceiroProvider();
  FinanceiroModel _financeiroModel = FinanceiroModel();

  void carregarDados(String id) {
    FinanceiroModel financeiro = FinanceiroModel();
    //financeiro = _financeiroProvider.getFinanceiro("NNbclpeNVN5iVZRUv3fz");
    String teste;
    teste = _financeiroProvider.getFinanceiro("NNbclpeNVN5iVZRUv3fz").toString();
    print(" RETORNO DA FUNCTION " + teste);
    print('carragando ' + financeiro.formaPagamento);
  }

  void createFinanceiro(
      {String idFinanceiro,
      String idRequisiacao,
      double valorPedido,
      String formaPagamento,
      double valorViagem,
      double valorRecebido,
      double taxaApp,
      double valorGanho}) {
    _financeiroModel.idFinanceiro = idFinanceiro;
    _financeiroModel.idRequisiacao = idRequisiacao;
    _financeiroModel.valorPedido = valorPedido;
    _financeiroModel.formaPagamento = formaPagamento;
    _financeiroModel.valorViagem = valorViagem;
    _financeiroModel.valorRecebido = valorRecebido;
    _financeiroModel.taxaApp = valorRecebido;
    _financeiroModel.valorGanho = valorRecebido;

    return FinanceiroProvider().create(_financeiroModel);
  }

  void deleteFinanceiro(FinanceiroModel financeiro) {
    return FinanceiroProvider().delete(financeiro);
  }
}
