import 'package:flutter/material.dart';
import 'package:garen/components/app_bar.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/pages/adicionarInstalacao.dart';
import 'package:garen/components/forms/card_input.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/components/forms/card_dropbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:currency_text_input_mask/currency_text_input_mask.dart';

class CalculadoraOrcamento extends StatefulWidget {
  @override
  _CalculadoraOrcamentoState createState() => _CalculadoraOrcamentoState();
}

class _CalculadoraOrcamentoState extends State<CalculadoraOrcamento> {
  LocalizacaoServico _locate = new LocalizacaoServico();
  var fm;
  var lm;

  double valorVistaVi = 0;
  double valorVistaSi = 0;
  double valorEntradaVi = 0;
  double valorEntradaSi = 0;

  double valorPaymentsVi = 0;
  double valorPaymentsSi = 0;

  double money = 0;

  double moneySi = 0;
  double moneyVi = 0;

  double credito = 0;
  double debito = 0;

  double debitoVi = 0;
  double debitoSi = 0;

  double creditoSi = 0;
  double creditoVi = 0;

  double valorDinheiro = 0;
  double valorDebitoJuros = 0;
  double valorDebitoTotal = 0;
  double valorCreditoJuros = 0;
  double valorCreditoTotal = 0;
  double valorCreditoTxAdm = 0;
  double valorCreditosParcelas = 0;
  double valorTotalPrazo = 0;
  double txpercentJurosDebito = 0;
  double txpercentJurosCredito = 0;

  int numParcela;
  List lstTxJuros = [2.5, 3.8, 5, 6.3, 7.5, 8.8, 10, 11.3, 12.5, 13.8];
  int parcela = 0;

  double valorLucro = 0;

  var sUser;

  double equipGanho = 0;

  double ceVi = 0;
  double fiVi = 0;

  double odVi = 0;
  double poVi = 0;

  double ceSi = 0;
  double fiSi = 0;
  double othSi = 0;
  double odSi = 0;

  double ceViPo = 0;
  double fiViPo = 0;
  double odViPo = 0;

  double txCa = 0;

  String msgDebito;
  String msgCredito;

  bool parcelaDisabled = true;

  String tipoOrcamento;

  // TextEditingController _controllerOutros = TextEditingController();
  // TextEditingController _controllerEquipamento = TextEditingController();
  // TextEditingController _controllerInsfraEstrutura = TextEditingController();
  // TextEditingController _controllerTxCartao = TextEditingController();
  // TextEditingController _controllerDespesas = TextEditingController();
  // TextEditingController _controllerGanho = TextEditingController();
  CurrencyTextInputMaskController _controllerOutros =
      CurrencyTextInputMaskController();
  CurrencyTextInputMaskController _controllerEquipamento =
      CurrencyTextInputMaskController();
  CurrencyTextInputMaskController _controllerInsfraEstrutura =
      CurrencyTextInputMaskController();
  TextEditingController _controllerTxCartao = TextEditingController();
  CurrencyTextInputMaskController _controllerDespesas =
      CurrencyTextInputMaskController();
  TextEditingController _controllerGanho = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selecionado = "Dinheiro";

// Aparecer os botões após selecinar qual tipo de orçamento
//-----------------------------------------
  bool _venda = false;
  bool _instalacao = false;
  bool _parcelas = false;
  bool _todos = false;
  bool _txCartao = false;
//-----------------------------------------

  String dropdownValueEquipamento;
  String dropdownValueParcela;

  String opcao = "Escolha.";
  String abreviacao = "m";
  String escolhido;

  double resultadoInstalacao = 0;
  double resultadoVendasInstalacao = 0;

  String typeInst;

  bool showFieldsSI = false;
  bool showFieldsVI = false;
  bool showTypePagto = false;

  bool carregado = false;

  bool mostraCredito = false;

  int selectedRadioTile;
  int selectedRadio = 0;
  bool selectedRadioselected = false;

  var installmentsList;
  var iList;

  var gatesList;
  var gList;

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);

    super.initState();

    txpercentJurosCredito = 0.04;
    txpercentJurosDebito = 0.00;
    selecionado = "Dinheiro";
    debito = 0;
    credito = 0;
    selectedRadio = 1;
    selectedRadioTile = 0;
    selectedRadioselected = false;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  _calcular() async {
    await fillMoneyValue();
    if (_instalacao == true) {
      _calcBudgetSI(context);
    } else {
      _calcBudgetVI(context);
    }
  }

  _carregar(bool carregado) {
    if (escolhido == null &&
        dropdownValueEquipamento == null &&
        dropdownValueParcela == null) {
      try {
        escolhido = iList[0];
        dropdownValueParcela = iList[0];
        dropdownValueEquipamento = gList[0];
       setSelectedRadioTile(1);
      } catch (e) {
        print(e);
      }

      if (escolhido == null &&
          dropdownValueEquipamento == null &&
          dropdownValueParcela == null) {
        print("Não Carregou");
        return carregando = false;
      } else {
        print("Carregado");
        return carregando = true;
      }
    }
  }

  _calcBudgetVI(context) {
    double valorVista;
    valorVista = valorVistaVi;

    valorPaymentsVi = money + debito + credito;

    //valorEntradaVi = 0.40 * valorPaymentsVi;

    double valorTotal = ceVi + fiVi + odVi;
    valorLucro = (valorTotal * ((poVi / 100) + 1)) - valorTotal;
    double ce;

    if (tipoOrcamento == 'VI') {
      ce = ceVi;
    } else {
      ce = othSi;
    }

    if (valorVistaVi == valorPaymentsVi) {
      if (money > 0) {
        valorTotalPrazo = money;
        mostraCredito = false;

        _showConfirmAlertVI(
          context,
          ceVi,
          fiVi,
          odVi,
          valorVista,
          0,
          0,
          valorTotalPrazo,
          tipoOrcamento,
          mostraCredito,
          "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
          "${_locate.locale['BUDGET']['cash_value']}",
          "${_locate.locale['BUDGET']['or']}",
          "${_locate.locale['BUDGET']['term_total']}",
          "${_locate.locale['BUDGET']['installments_of']}",
          "${_locate.locale['BUDGET']['show_to_customer']}",
          "${_locate.locale['BUDGET']['close']}",
          "${_locate.locale['BUDGET']['budget']}",
          "${_locate.locale['BUDGET']['equipment_cost']}",
          "${_locate.locale['BUDGET']['infrastructure_costs']}",
          "${_locate.locale['BUDGET']['other_expenses']}",
          "${_locate.locale['BUDGET']['pay_in_full']}",
          "${_locate.locale['BUDGET']['approved']}",
          "${_locate.locale['BUDGET']['not_approved']}",
          "${_locate.locale['BUDGET']['back']}",
        );
      }

      if (debito > 0) {
        valorDebitoJuros = debito * txpercentJurosDebito;
        valorDebitoTotal = debito + valorDebitoJuros;
        valorTotalPrazo = valorTotalPrazo + valorDebitoTotal;
        mostraCredito = false;

        _showConfirmAlertVI(
            context,
            ce,
            fiVi,
            odVi,
            valorVista,
            0,
            0,
            valorTotalPrazo,
            tipoOrcamento,
            mostraCredito,
            "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
            "${_locate.locale['BUDGET']['cash_value']}",
            "${_locate.locale['BUDGET']['or']}",
            "${_locate.locale['BUDGET']['term_total']}",
            "${_locate.locale['BUDGET']['installments_of']}",
            "${_locate.locale['BUDGET']['show_to_customer']}",
            "${_locate.locale['BUDGET']['close']}",
            "${_locate.locale['BUDGET']['budget']}",
            "${_locate.locale['BUDGET']['equipment_cost']}",
            "${_locate.locale['BUDGET']['infrastructure_costs']}",
            "${_locate.locale['BUDGET']['other_expenses']}",
            "${_locate.locale['BUDGET']['pay_in_full']}",
            "${_locate.locale['BUDGET']['approved']}",
            "${_locate.locale['BUDGET']['not_approved']}",
            "${_locate.locale['BUDGET']['back']}");
      }

      if (credito > 0) {
        //credito = credito - valorEntradaVi;
        //valorCreditoTxAdm = credito * txpercentJurosCredito;

        if (parcela > 0) {
          valorCreditoJuros = credito * (txCa / 100);
          valorCreditoTotal = valorCreditoJuros + credito;
          valorCreditosParcelas = valorCreditoTotal / parcela;
          valorTotalPrazo = valorCreditoTotal;
          mostraCredito = true;

          _showConfirmAlertVI(
              context,
              ce,
              fiVi,
              odVi,
              valorVista,
              parcela,
              valorCreditosParcelas,
              valorTotalPrazo,
              tipoOrcamento,
              mostraCredito,
              "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
              "${_locate.locale['BUDGET']['cash_value']}",
              "${_locate.locale['BUDGET']['or']}",
              "${_locate.locale['BUDGET']['term_total']}",
              "${_locate.locale['BUDGET']['installments_of']}",
              "${_locate.locale['BUDGET']['show_to_customer']}",
              "${_locate.locale['BUDGET']['close']}",
              "${_locate.locale['BUDGET']['budget']}",
              "${_locate.locale['BUDGET']['equipment_cost']}",
              "${_locate.locale['BUDGET']['infrastructure_costs']}",
              "${_locate.locale['BUDGET']['other_expenses']}",
              "${_locate.locale['BUDGET']['pay_in_full']}",
              "${_locate.locale['BUDGET']['approved']}",
              "${_locate.locale['BUDGET']['not_approved']}",
              "${_locate.locale['BUDGET']['back']}");
        }
      }
    } else {
      // this.showErrorScreen();

    }
  }

  _calcBudgetSI(context) {
    double valorVista;

    valorVista = valorVistaSi;

    valorPaymentsSi = money + debito + credito;

    //valorEntradaVi = 0.40 * valorPaymentsVi;

    double valorTotal = othSi + fiSi + odSi;
    valorLucro = (valorTotal * ((txCa / 100) + 1)) - valorTotal;

    double ce;

    if (tipoOrcamento == 'VI') {
      ce = ceVi;
    } else {
      ce = othSi;
    }

    if (valorVistaSi == valorPaymentsSi) {
      if (money > 0) {
        valorTotalPrazo = money;
        mostraCredito = false;

        _showConfirmAlertVI(
            context,
            ce,
            fiSi,
            odSi,
            valorVista,
            0,
            0,
            valorTotalPrazo,
            tipoOrcamento,
            mostraCredito,
            "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
            "${_locate.locale['BUDGET']['cash_value']}",
            "${_locate.locale['BUDGET']['or']}",
            "${_locate.locale['BUDGET']['term_total']}",
            "${_locate.locale['BUDGET']['installments_of']}",
            "${_locate.locale['BUDGET']['show_to_customer']}",
            "${_locate.locale['BUDGET']['close']}",
            "${_locate.locale['BUDGET']['budget']}",
            "${_locate.locale['BUDGET']['equipment_cost']}",
            "${_locate.locale['BUDGET']['infrastructure_costs']}",
            "${_locate.locale['BUDGET']['other_expenses']}",
            "${_locate.locale['BUDGET']['pay_in_full']}",
            "${_locate.locale['BUDGET']['approved']}",
            "${_locate.locale['BUDGET']['not_approved']}",
            "${_locate.locale['BUDGET']['back']}");
      }

      if (debito > 0) {
        valorDebitoJuros = debito * txpercentJurosDebito;
        valorDebitoTotal = debito + valorDebitoJuros;
        valorTotalPrazo = valorTotalPrazo + valorDebitoTotal;

        mostraCredito = false;

        _showConfirmAlertVI(
            context,
            ce,
            fiSi,
            odSi,
            valorVista,
            0,
            0,
            valorTotalPrazo,
            tipoOrcamento,
            mostraCredito,
            "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
            "${_locate.locale['BUDGET']['cash_value']}",
            "${_locate.locale['BUDGET']['or']}",
            "${_locate.locale['BUDGET']['term_total']}",
            "${_locate.locale['BUDGET']['installments_of']}",
            "${_locate.locale['BUDGET']['show_to_customer']}",
            "${_locate.locale['BUDGET']['close']}",
            "${_locate.locale['BUDGET']['budget']}",
            "${_locate.locale['BUDGET']['equipment_cost']}",
            "${_locate.locale['BUDGET']['infrastructure_costs']}",
            "${_locate.locale['BUDGET']['other_expenses']}",
            "${_locate.locale['BUDGET']['pay_in_full']}",
            "${_locate.locale['BUDGET']['approved']}",
            "${_locate.locale['BUDGET']['not_approved']}",
            "${_locate.locale['BUDGET']['back']}");
      }

      if (credito > 0) {
        //credito = credito - valorEntradaVi;
        //valorCreditoTxAdm = credito * txpercentJurosCredito;

        if (parcela > 0) {
          valorCreditoJuros = credito * (txCa / 100);
          valorCreditoTotal = valorCreditoJuros + credito;
          valorCreditosParcelas = valorCreditoTotal / parcela;
          valorTotalPrazo = valorCreditoTotal;
          mostraCredito = true;

          _showConfirmAlertVI(
              context,
              ce,
              fiSi,
              odSi,
              valorVista,
              parcela,
              valorCreditosParcelas,
              valorTotalPrazo,
              tipoOrcamento,
              mostraCredito,
              "${_locate.locale['BUDGET']['suggested_end_customer_price']}",
              "${_locate.locale['BUDGET']['cash_value']}",
              "${_locate.locale['BUDGET']['or']}",
              "${_locate.locale['BUDGET']['term_total']}",
              "${_locate.locale['BUDGET']['installments_of']}",
              "${_locate.locale['BUDGET']['show_to_customer']}",
              "${_locate.locale['BUDGET']['close']}",
              "${_locate.locale['BUDGET']['budget']}",
              "${_locate.locale['BUDGET']['equipment_cost']}",
              "${_locate.locale['BUDGET']['infrastructure_costs']}",
              "${_locate.locale['BUDGET']['other_expenses']}",
              "${_locate.locale['BUDGET']['pay_in_full']}",
              "${_locate.locale['BUDGET']['approved']}",
              "${_locate.locale['BUDGET']['not_approved']}",
              "${_locate.locale['BUDGET']['back']}");
        }
      }
    } else {
      // this.showErrorScreen();

    }
  }

  _somenteVendas(context) {
    setState(() {
      opcao = "${_locate.locale['BUDGET']['installation_only']}";
      _instalacao = true;
      _venda = false;
      _todos = true;
      _controllerOutros.text = "";
      _controllerEquipamento.text = "";
      _controllerInsfraEstrutura.text = "";
      _controllerTxCartao.text = "";
      _controllerDespesas.text = "";
      _controllerGanho.text = "";
      Navigator.pop(context);
    });
  }

  _vendaInstalacoes(context) {
    setState(() {
      opcao = "${_locate.locale['BUDGET']['sale+installation']}";
      _venda = true;
      _instalacao = false;
      _todos = true;
      _controllerOutros.text = "";
      _controllerEquipamento.text = "";
      _controllerInsfraEstrutura.text = "";
      _controllerTxCartao.text = "";
      _controllerDespesas.text = "";
      _controllerGanho.text = "";
      Navigator.pop(context);
    });
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "${_locate.locale['BUDGET']['budget_type']}",
              style: TextStyle(
                  fontSize: 18 * MediaQuery.of(context).textScaleFactor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      "${_locate.locale['BUDGET']['sale+installation']}",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      _vendaInstalacoes(context);
                      tipoOrcamento = 'VI';
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text(
                      "${_locate.locale['BUDGET']['installation_only']}",
                      style: TextStyle(
                          fontSize:
                              16 * MediaQuery.of(context).textScaleFactor),
                    ),
                    onTap: () {
                      _somenteVendas(context);
                      tipoOrcamento = 'SI';
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  fillMoneyValue() {
    ceVi = _controllerEquipamento.doubleValue ?? 0;
    fiVi = _controllerInsfraEstrutura.doubleValue ?? 0;
    odVi = _controllerDespesas.doubleValue ?? 0;
    poVi = double.tryParse(_controllerGanho.text) ?? 0;
    ceSi = _controllerEquipamento.doubleValue ?? 0;
    fiSi = _controllerInsfraEstrutura.doubleValue ?? 0;
    othSi = _controllerOutros.doubleValue ?? 0;
    odSi = _controllerDespesas.doubleValue ?? 0;

    txCa = double.tryParse(_controllerTxCartao.text) ?? 0;

    if (ceVi != null) {
      // custo equipamento

      valorVistaVi = ceVi;
      ceViPo = ceVi * (poVi / 100) + ceVi; // custo equipamento * porcentagem

    } else {
      ceVi = 0;
      ceViPo = 0;
    }

    if (fiVi != null) {
      // custo infraestrutura

      valorVistaVi = ceVi + fiVi; // custo equipamento + infraestrutura
      fiViPo = fiVi * (poVi / 100) + fiVi; // infraestrutura + porcentagem

    } else {
      fiVi = 0;
      fiViPo = 0;
    }

    if (odVi != null) {
      // Outras Despesas

      valorVistaVi = ceVi +
          fiVi +
          odVi; // custo equipamento + custo infraestrutura + Outras despesas
      odViPo = odVi * (poVi / 100) + odVi; // outras despesas + porcentagem

    } else {
      odVi = 0;
      odViPo = 0;
    }

    if (poVi != null) {
      // ganho porcentagem

      double totalVi = (ceVi + fiVi + odVi);
      valorVistaVi = totalVi * (poVi / 100) +
          totalVi; //custo equipamento + valor infra + outras desp + porcentagem

    } else {
      poVi = 0;
    }

    if (valorVistaVi != null) {
      double totalVI = (ceVi + fiVi + odVi);
      moneyVi = totalVI * (poVi / 100) + totalVI;
    }

    if (othSi != null) {
      valorVistaSi = othSi; //Outro Valor

    } else {
      othSi = 0;
    }

    if (fiSi != null) {
      // infraestrutura

      var fiSi2 = fiSi; // valor infraestrutura
      valorVistaSi = othSi + fiSi2; // Outro valor + infraestrutura

    } else {
      fiSi = 0;
    }

    if (odSi != null) {
      var odSi2 = odSi; // Outras dispesas (Somente Instalção)
      valorVistaSi = othSi + fiSi + odSi2; // outas desp. + infra + outro valor

    } else {
      odSi = 0;
    }

    if (valorVistaSi != null) {
      moneySi = valorVistaSi;
    }
  }

  bool carregando = false;

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    if (carregado == false) {
      _carregar(carregado);
    }

    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        installmentsList = _locate.locale['BUDGET']['installments_list'];
        gatesList = _locate.locale['BUDGET']['gates_list'];
        installmentsList = _locate.locale['BUDGET']['installments_list'];
        iList = List<String>.from(installmentsList);
        gList = List<String>.from(gatesList);
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: AppBarComponent(
              backgroundColor: "004370",
              centerTitle: true,
              visivel: true,
              onpressed: () {
                setState(() {
                  resultadoInstalacao = 0;
                  _controllerOutros.text = "";
                  _controllerEquipamento.text = "";
                  _controllerInsfraEstrutura.text = "";
                  _controllerTxCartao.text = "";
                  _controllerDespesas.text = "";
                  _controllerGanho.text = "";
                });
              },
            ),
          ),
          body: Container(
            width: double.infinity,
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_azul.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: tamanho.height * 0.05),
                          child: Text(
                              "${_locate.locale['BUDGET']['budget_calculator_line_1']}",
                              style: GoogleFonts.audiowide(
                                  fontSize: 18 *
                                      MediaQuery.of(context).textScaleFactor,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),

                      Text(
                          "${_locate.locale['BUDGET']['budget_calculator_line_2']}",
                          style: GoogleFonts.audiowide(
                              fontSize:
                                  28 * MediaQuery.of(context).textScaleFactor,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),

                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "${_locate.locale['BUDGET']['set_the_optimal_value']}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  14 * MediaQuery.of(context).textScaleFactor,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(bottom: tamanho.height * 0.02),
                        child: GestureDetector(
                          onTap: () => {
                            _showChoiceDialog(context),
                          },
                          child: Container(
                            width: tamanho.width * 0.875,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xfffe0000),
                              border: Border.all(
                                  color: Color(0xff9e0301), width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,

                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: Text(
                                    "${_locate.locale['BUDGET']['budget_type']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: GestureDetector(
                                    onTap: () => {
                                      _showChoiceDialog(context),
                                    },
                                    child: Text(
                                      opcao,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13 *
                                              MediaQuery.of(context)
                                                  .textScaleFactor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card Dropdown Equipamentos
                      Visibility(
                        visible: _instalacao,
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: tamanho.height * 0.02),
                                child: Container(
                                  width: tamanho.width * 0.875,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xfffe0000),
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: FadeInUp(
                                    0,
                                    CardDropboxComponente(
                                      titulo:
                                          '${_locate.locale['BUDGET']['equipment']}',
                                      height: 50,
                                      hintTexto:
                                          '${_locate.locale['ACCREDITATION']['select_an_option']}',
                                      dropdownValue: dropdownValueEquipamento,
                                      onchanged: (String newValue) {
                                        setState(() {
                                          dropdownValueEquipamento = newValue;

                                          switch (gList
                                              .indexOf(newValue)
                                              .toString()) {
                                            case '0':
                                              break;
                                            case '1':
                                              break;
                                            case '2':
                                              break;
                                            case '3':
                                              break;
                                            case '4':
                                              break;

                                            default:
                                          }
                                        });
                                      },
                                      items: gList,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Card Dropdown Equipamentos

                      Visibility(
                          visible: _venda,
                          child: FadeInUp(
                              1,
                              CardInputComponente(
                                controller: _controllerEquipamento,
                                keyboardType: TextInputType.number,
                                titulo:
                                    "${_locate.locale['BUDGET']['equipment_cost']}",
                                dica:
                                    "${_locate.locale['BUDGET']['equipment_cost']}",
                                prefixTexto: 'R\$',
                                onchanged: (_) {
                                  fillMoneyValue();
                                  switch (selectedRadio) {
                                    case 1:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = 0;
                                          credito = 0;
                                          money = valorVistaVi;
                                        } else {
                                          debito = 0;
                                          credito = 0;
                                          money = valorVistaSi;
                                        }
                                      });
                                      break;
                                    case 2:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = valorVistaSi;
                                          credito = 0;
                                          money = 0;
                                        } else {
                                          debito = valorVistaSi;
                                          credito = 0;
                                          money = 0;
                                        }
                                      });
                                      break;
                                    case 3:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = 0;
                                          credito = valorVistaSi;
                                          money = 0;
                                        } else {
                                          debito = 0;
                                          credito = valorVistaSi;
                                          money = 0;
                                        }
                                      });
                                      break;
                                    default:
                                  }
                                },
                                validator: (val) {
                                  if (val.isEmpty && tipoOrcamento == 'VI') {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${_locate.locale['ACCREDITATION']['warn_required']}'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }

                                  return null;
                                },
                                inputFormatters: [],
                              ))),

                      Visibility(
                          visible: _instalacao,
                          child: FadeInUp(
                              2,
                              CardInputComponente(
                                controller: _controllerOutros,
                                keyboardType: TextInputType.number,
                                titulo:
                                    "${_locate.locale['BUDGET']['equipment_cost']}",
                                dica:
                                    "${_locate.locale['BUDGET']['equipment_cost']}",
                                prefixTexto: 'R\$',
                                onchanged: (_) {
                                  fillMoneyValue();
                                  switch (selectedRadio) {
                                    case 1:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = 0;
                                          credito = 0;
                                          money = valorVistaVi;
                                        } else {
                                          debito = 0;
                                          credito = 0;
                                          money = valorVistaSi;
                                        }
                                      });
                                      break;
                                    case 2:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = valorVistaSi;
                                          credito = 0;
                                          money = 0;
                                        } else {
                                          debito = valorVistaSi;
                                          credito = 0;
                                          money = 0;
                                        }
                                      });
                                      break;
                                    case 3:
                                      setState(() {
                                        if (tipoOrcamento == 'VI') {
                                          debito = 0;
                                          credito = valorVistaSi;
                                          money = 0;
                                        } else {
                                          debito = 0;
                                          credito = valorVistaSi;
                                          money = 0;
                                        }
                                      });
                                      break;
                                    default:
                                  }
                                },
                                validator: (val) {
                                  if (val.isEmpty) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${_locate.locale['ACCREDITATION']['warn_required']}'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }

                                  return null;
                                },
                                inputFormatters: [],
                              ))),

                      Visibility(
                        visible: _todos,
                        child: FadeInUp(
                            3,
                            CardInputComponente(
                              controller: _controllerInsfraEstrutura,
                              keyboardType: TextInputType.number,
                              titulo:
                                  "${_locate.locale['BUDGET']['infrastructure_costs']}",
                              dica:
                                  "${_locate.locale['BUDGET']['obs_infrastructure_costs']}",
                              prefixTexto: 'R\$',
                              onchanged: (_) {
                                fillMoneyValue();
                                switch (selectedRadio) {
                                  case 1:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaVi;
                                      } else {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaSi;
                                      }
                                    });
                                    break;
                                  case 2:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      } else {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  case 3:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      } else {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  default:
                                }
                              },
                              validator: (val) {
                                if (val.isEmpty && tipoOrcamento == 'VI') {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        '${_locate.locale['ACCREDITATION']['warn_required']}'),
                                    backgroundColor: Colors.red,
                                  ));
                                }

                                return null;
                              },
                              inputFormatters: [],
                            )),
                      ),

                      Visibility(
                        visible: _todos,
                        child: FadeInUp(
                            4,
                            CardInputComponente(
                              controller: _controllerDespesas,
                              keyboardType: TextInputType.number,
                              titulo:
                                  "${_locate.locale['BUDGET']['other_expenses']}",
                              dica:
                                  "${_locate.locale['BUDGET']['obs_other_expenses']}",
                              prefixTexto: 'R\$',
                              onchanged: (_) {
                                fillMoneyValue();
                                switch (selectedRadio) {
                                  case 1:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaVi;
                                      } else {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaSi;
                                      }
                                    });
                                    break;
                                  case 2:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      } else {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  case 3:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      } else {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  default:
                                }
                              },
                              validator: (val) {
                                if (val.isEmpty && tipoOrcamento == 'VI') {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        '${_locate.locale['ACCREDITATION']['warn_required']}'),
                                    backgroundColor: Colors.red,
                                  ));
                                }

                                return null;
                              },
                              inputFormatters: [],
                            )),
                      ),

                      Visibility(
                        visible: _venda,
                        child: FadeInUp(
                            5,
                            CardInputComponente(
                              controller: _controllerGanho,
                              titulo:
                                  "${_locate.locale['BUDGET']['gain_percentage']}",
                              keyboardType: TextInputType.number,
                              dica: "",
                              prefixTexto: '%',
                              onchanged: (_) {
                                fillMoneyValue();
                                switch (selectedRadio) {
                                  case 1:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaVi;
                                      } else {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaSi;
                                      }
                                    });
                                    break;
                                  case 2:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      } else {
                                        debito = valorVistaSi;
                                        credito = 0;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  case 3:
                                    setState(() {
                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      } else {
                                        debito = 0;
                                        credito = valorVistaSi;
                                        money = 0;
                                      }
                                    });
                                    break;
                                  default:
                                }
                              },
                              inputFormatters: [],
                            )),
                      ),

                      Visibility(
                        visible: _todos,
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: tamanho.height * 0.02),
                          child: Container(
                            width: tamanho.width * 0.875,
                            height: 220,
                            decoration: BoxDecoration(
                              color: Color(0xfffe0000),
                              border: Border.all(
                                  color: Color(0xff9e0301), width: 3),
                              borderRadius: BorderRadius.all(
                                Radius.circular(13),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: Text(
                                    "${_locate.locale['BUDGET']['choose_payment_method']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18 *
                                            MediaQuery.of(context)
                                                .textScaleFactor),
                                  ),
                                ),

                                // Dinheiro selecionado.
                                Container(
                                  color: Colors.white,
                                  child: RadioListTile(
                                    value: 1,
                                    groupValue: selectedRadioTile,
                                    title: Text(
                                        "${_locate.locale['BUDGET']['cash_amount']}"),
                                    onChanged: (val) {
                                      setSelectedRadioTile(val);

                                      selecionado = "Dinheiro";

                                      _controllerTxCartao.text = "0";

                                      _txCartao = false;

                                      _parcelas = false;

                                      parcela = 1;

                                      debito = 0;

                                      credito = 0;

                                      setState(() {
                                        escolhido = iList[0];
                                      });

                                      if (tipoOrcamento == 'VI') {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaVi;
                                      } else {
                                        debito = 0;
                                        credito = 0;
                                        money = valorVistaSi;
                                      }

                                      if (val == 1) {
                                        selectedRadio = 1;
                                      }

                                      FocusScope.of(context).unfocus();
                                    },
                                    activeColor: Colors.blue,
                                    selected: selectedRadio == 1 ? true : false,
                                  ),
                                ),
                                // Dinheiro selecionado.

                                // Debito selecionado.
                                Container(
                                  color: Colors.white,
                                  child: RadioListTile(
                                    value: 2,
                                    groupValue: selectedRadioTile,
                                    title: Text(
                                        "${_locate.locale['BUDGET']['debit_amount']}"),
                                    onChanged: (val) {
                                      setSelectedRadioTile(val);

                                      selecionado = "Débito";

                                      _controllerTxCartao.text = "0";

                                      _txCartao = false;

                                      _parcelas = false;

                                      parcela = 1;

                                      // fillRadio('typeDebito');

                                      money = 0;

                                      credito = 0;

                                      setState(() {
                                        escolhido = iList[0];
                                      });

                                      if (tipoOrcamento == 'VI') {
                                        money = 0;
                                        credito = 0;
                                        debito = valorVistaVi;
                                      } else {
                                        money = 0;
                                        credito = 0;
                                        debito = valorVistaSi;
                                      }

                                      if (val == 2) {
                                        selectedRadio = 2;
                                      }

                                      FocusScope.of(context).unfocus();
                                    },
                                    activeColor: Colors.blue,
                                    selected: selectedRadio == 2 ? true : false,
                                  ),
                                ),
                                // Debito selecionado.

                                // Credito selecionado.
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(0),
                                          bottomRight: Radius.circular(9.5),
                                          bottomLeft: Radius.circular(9.5),
                                          topLeft: Radius.circular(0)),
                                      border: Border.all(
                                          color: Colors.transparent)),
                                  child: RadioListTile(
                                    value: 3,
                                    groupValue: selectedRadioTile,
                                    title: Text(
                                        "${_locate.locale['BUDGET']['credit_amount']}"),
                                    onChanged: (val) {
                                      setSelectedRadioTile(val);

                                      selecionado = "Crédito";

                                      _parcelas = true;

                                      money = 0;

                                      debito = 0;

                                      if (tipoOrcamento == 'VI') {
                                        money = 0;

                                        debito = 0;

                                        credito = valorVistaVi;
                                      } else {
                                        money = 0;

                                        debito = 0;

                                        credito = valorVistaSi;
                                      }

                                      if (val == 3) {
                                        selectedRadio = 3;
                                      }

                                      FocusScope.of(context).unfocus();
                                    },
                                    activeColor: Colors.blue,
                                    selected: selectedRadio == 3 ? true : false,
                                  ),
                                ),
                                // Credito selecionado.
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card Dropdown Parcelas
                      Visibility(
                        visible: _parcelas,
                        child: Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: tamanho.height * 0.02),
                                child: Container(
                                  width: tamanho.width * 0.875,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Color(0xfffe0000),
                                    border: Border.all(
                                        color: Color(0xff9e0301), width: 3),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(13),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,

                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardDropboxComponente(
                                        height: 50,
                                        titulo:
                                            '${_locate.locale['BUDGET']['installments']}',
                                        hintTexto:
                                            '${_locate.locale['ACCREDITATION']['select_an_option']}:',
                                        dropdownValue: escolhido,
                                        onchanged: (String newValue) {
                                          setState(() {
                                            dropdownValueParcela = newValue;

                                            switch (iList
                                                .indexOf(newValue)
                                                .toString()) {
                                              case '0':
                                                _txCartao = false;
                                                parcela = 1;
                                                _controllerTxCartao.text = "0";
                                                setState(() {
                                                  escolhido = iList[0];
                                                });

                                                break;
                                              case '1':
                                                _txCartao = true;
                                                parcela = 2;
                                                setState(() {
                                                  escolhido = iList[1];
                                                });
                                                break;
                                              case '2':
                                                _txCartao = true;
                                                parcela = 3;
                                                setState(() {
                                                  escolhido = iList[2];
                                                });
                                                break;
                                              case '3':
                                                _txCartao = true;
                                                parcela = 4;
                                                setState(() {
                                                  escolhido = iList[3];
                                                });
                                                break;
                                              case '4':
                                                _txCartao = true;
                                                parcela = 5;
                                                setState(() {
                                                  escolhido = iList[4];
                                                });
                                                break;
                                              case '5':
                                                _txCartao = true;
                                                parcela = 6;
                                                setState(() {
                                                  escolhido = iList[5];
                                                });
                                                break;
                                              case '6':
                                                _txCartao = true;
                                                parcela = 7;
                                                setState(() {
                                                  escolhido = iList[6];
                                                });
                                                break;
                                              case '7':
                                                _txCartao = true;
                                                parcela = 8;
                                                setState(() {
                                                  escolhido = iList[7];
                                                });
                                                break;
                                              case '8':
                                                _txCartao = true;
                                                parcela = 9;
                                                setState(() {
                                                  escolhido = iList[8];
                                                });
                                                break;
                                              case '9':
                                                _txCartao = true;
                                                parcela = 10;
                                                setState(() {
                                                  escolhido = iList[9];
                                                });
                                                break;
                                              case '10':
                                                _txCartao = true;
                                                parcela = 11;
                                                setState(() {
                                                  escolhido = iList[10];
                                                });
                                                break;
                                              case '11':
                                                _txCartao = true;
                                                parcela = 12;
                                                setState(() {
                                                  escolhido = iList[11];
                                                });

                                                break;

                                              default:
                                            }
                                          });
                                        },
                                        items: iList,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // Card Dropdown Parcelas
                      Visibility(
                          visible: _txCartao,
                          child: FadeInUp(
                              1,
                              CardInputComponente(
                                controller: _controllerTxCartao,
                                keyboardType: TextInputType.number,
                                titulo: "${_locate.locale['BUDGET']['tax']}",
                                dica: "${_locate.locale['BUDGET']['tax_hint']}",
                                prefixTexto: '%',
                                onchanged: (_) {
                                  fillMoneyValue();
                                },
                                validator: (val) {
                                  if (val.isEmpty && tipoOrcamento == 'VI') {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '${_locate.locale['BUDGET']['tax_warn']}'),
                                      backgroundColor: Colors.red,
                                    ));
                                  }

                                  return null;
                                },
                                inputFormatters: [],
                              ))),

                      // Botão Calcular
                      Visibility(
                        visible: _todos,
                        child: Padding(
                          padding: EdgeInsets.only(top: tamanho.height * 0.015),
                          child: GestureDetector(
                            onTap: () => {
                              _calcular(),
                            },
                            child: Container(
                              width: tamanho.width * 0.875,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 10,

                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${_locate.locale['CALC']['btn_calculate']}",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Botão calcular
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

_showConfirmAlertVI(
    BuildContext context,
    double ceVi,
    double fiVi,
    double odVi,
    double valorVista,
    int parcela,
    double valorCreditosParcelas,
    double valorTotalPrazo,
    String tipoOrcamento,
    bool mostraCredito,
    String nome,
    String avista,
    String ou,
    String totalPrazo,
    String parcelasDe,
    String mostrarCli,
    String fechar,
    String budget,
    String equipCost,
    String infraCost,
    String otherexpe,
    String payFull,
    String approved,
    String notApproved,
    String back) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(nome),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "$avista R\$ ",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "R\$ ${valorVista.toStringAsFixed(2) != null ? valorVista.toStringAsFixed(2) : '0,00'}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey),
                ),
              ]),
              Visibility(
                  visible: mostraCredito,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(ou, style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                            text: ' ',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey,
                                fontSize: 16),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${parcela}x ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey,
                                    fontSize: 20),
                              ),
                              TextSpan(
                                text: parcelasDe,
                                style: TextStyle(color: Colors.grey),
                              ),
                              TextSpan(
                                text:
                                    'R\$ ${valorCreditosParcelas.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey,
                                    fontSize: 20),
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              totalPrazo,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "R\$ " + valorTotalPrazo.toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey),
                            ),
                          ]),
                    ],
                  ))
            ],
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          _alertaClienteVisualizacao(
                              context,
                              "Oçamento",
                              ceVi,
                              fiVi,
                              odVi,
                              valorVista,
                              parcela,
                              valorCreditosParcelas,
                              valorTotalPrazo,
                              tipoOrcamento,
                              mostraCredito,
                              budget,
                              equipCost,
                              infraCost,
                              otherexpe,
                              payFull,
                              approved,
                              notApproved,
                              back,
                              ou,
                              totalPrazo,
                              parcelasDe),
                        },
                    child: Text(mostrarCli)),
                FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text(fechar)),
              ],
            )
          ],
        );
      });
}

_alertaClienteVisualizacao(
    BuildContext context,
    String nome,
    double ceVi,
    double fiVi,
    double odVi,
    double valorVista,
    int parcela,
    double valorCreditosParcelas,
    double valorTotalPrazo,
    String tipoOrcamento,
    bool mostraCredito,
    String budget,
    String equipCost,
    String infraCost,
    String otherexpe,
    String payFull,
    String approved,
    String notApproved,
    String back,
    String ou,
    String totalPrazo,
    String parcelasDe) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(budget),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    equipCost,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "R\$ ${ceVi.toStringAsFixed(2) != null ? ceVi.toStringAsFixed(2) : '0,00'}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    infraCost,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "R\$ ${fiVi.toStringAsFixed(2) != null ? fiVi.toStringAsFixed(2) : '0,00'}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    otherexpe,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "R\$ ${odVi.toStringAsFixed(2) != null ? odVi.toStringAsFixed(2) : '0,00'}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    payFull,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "R\$ ${valorVista.toStringAsFixed(2) != null ? valorVista.toStringAsFixed(2) : '0,00'}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey),
                  ),
                ]),
                Visibility(
                    visible: mostraCredito,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(ou, style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                              text: '',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey,
                                  fontSize: 16),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '${parcela}x',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey,
                                      fontSize: 18),
                                ),
                                TextSpan(
                                  text: parcelasDe,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text:
                                      'R\$ ${valorCreditosParcelas.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.grey,
                                      fontSize: 18),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          Text(
                            totalPrazo,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey),
                          ),
                          Text(
                            "R\$ ${valorTotalPrazo.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.grey),
                          ),
                        ]),
                      ],
                    ))
              ],
            ),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdicionarInstalacao(
                                        valorPagar: valorTotalPrazo,
                                        aprovado: false,
                                        editar: false,
                                      )))
                        },
                    child: Text(notApproved)),
                FlatButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdicionarInstalacao(
                                      tipoInstalacao: tipoOrcamento,
                                      valorPagar: valorTotalPrazo,
                                      aprovado: true,
                                      editar: false)))
                        },
                    child: Text(approved)),
                FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text(back)),
              ],
            )
          ],
        );
      });
}
