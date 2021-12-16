import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garen/components/form_input.dart';
import 'package:garen/models/orcamento_model.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/provider/orcamento_provider.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garen/components/carregando_garen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/components/date-picker.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_mask/currency_text_input_mask.dart';

import 'agendaInstalacao.dart';

class EditarInstalacao extends StatefulWidget {
  final double ceVi;
  final double fiVi;
  final double odVi;
  final int poVi;

  final double ceSi;
  final double fiSi;
  final double othSi;
  final double odSi;

  final double ceViPo;
  final double fiViPo;
  final double odViPo;

  final int parcelas;

  final double valorPagar;
  final String telefone;
  final bool aprovado;
  final String email;
  final String nome;
  final bool editar;
  final String codigo;
  final String endereco;
  final String comentario;
  final String tipoInstalacao;

  const EditarInstalacao(
      {Key key,
      this.codigo,
      this.ceVi,
      this.fiVi,
      this.odVi,
      this.poVi,
      this.ceSi,
      this.fiSi,
      this.othSi,
      this.odSi,
      this.ceViPo,
      this.fiViPo,
      this.odViPo,
      this.parcelas,
      this.valorPagar,
      this.comentario,
      this.endereco,
      this.email,
      this.nome,
      this.editar,
      this.telefone,
      this.aprovado,
      this.tipoInstalacao})
      : super(key: key);

  @override
  _EditarInstalacaoState createState() => _EditarInstalacaoState();
}

class _EditarInstalacaoState extends State<EditarInstalacao> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  //TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerComentario = TextEditingController();
  CurrencyTextInputMaskController _controllerValor =
      CurrencyTextInputMaskController();
  LocalizacaoServico _locate = new LocalizacaoServico();
  String nome;
  String telefone;
  String email;
  String endereco;
  String valor;
  String comentario;
  // TextEditingController _controllerEndereco = TextEditingController();

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  DateTime _dataInstalacao = DateTime.now();
  DateTime now = DateTime.now();

  TimeOfDay _hora = new TimeOfDay.now();
  bool isApiCallProcess = false;
  String _dataAgendada;
  bool status = false;
  bool aprovado = false;
  bool botaovisivel = true;
  bool carregar = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String orcCUserUid = "0.00.0";

  String orcDDataCriaccao = "0.00";
  String orcDDataCriacaoMs = "0.00";
  String orcBStatus = "0";
  String orcCAppointmentUid = "0.00.0";
  String orcNValorVistaVi = "0.00";
  String orcNValorVistaSi = "0.00";
  String orcNValorPagamentoVi = "0.00";
  String orcNValorPagamentoSi = "0.00";
  String orcNValorEntradaVi = "0.00";
  String orcNValorEntradaSi = "0.00";
  String orcNDinheiro = "0.00";
  String orcBDebito = "0.00";
  String orcNValorDebitoJuros = "0.00";
  String orcNValorDebitoTotal = "0.00";
  String orcNValorCreditoTaxaAdm = "0.00";
  String orcNParcela = "1";
  String orcNJuros = "0.00";
  String orcNValorCreditoJuros = "0.00";
  String orcNValorCreditoTotal = "0.00";
  String orcNValorTotalPrazo = "0.00";
  String orcNLucro = "0.00";
  String orcNCeViCustaEquipamento = "0.00";
  String orcNCeViPoCustoEquipamento = "0.00";
  String orcNFiViCustoInfra = "0.00";
  String orcNFiViPoOutrasDesp = "0.00";
  String orcNOdViOutrasDesp = "0.00";
  String orcNOthSiOutroValor = "0.00";
  String orcNFiSiCustoInfra = "0.00";
  String orcNOdSiOutrasDesp = "0.00";
  String orcCValor = "0.00";
  String titulo;

  @override
  void initState() {
    _locate.iniciaLocalizacao(context);
    status = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return LocalizacaoWidget(
          child: StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            return ProgressHUD(
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  backgroundColor: HexColor("004370"),
                  centerTitle: true,
                  title: Image.asset(
                    "assets/images/logo-branco.png",
                    fit: BoxFit.cover,
                    width: 100,
                  ),
                ),
                body: Center(
                  child: IntrinsicHeight(
                    child: Stack(children: <Widget>[
                      // Fundo da appBar(Container) com cores gradiant.
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                 colors: [
                                Color(0xff8e1729),
                                Color(0xff4d1627),
                                Color(0xff00141c),
                                Color(0xff4d1627),
                                Color(0xff8e1729),
                              ])),
                          height: MediaQuery.of(context).size.height * 0.007),

                      //Acima do Card
                      IntrinsicHeight(
                        child: Consumer<OrcamantoManager>(
                            builder: (_, orcamentoManager, __) {
                          return FutureBuilder(
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.none &&
                                    snapshot.hasData == null) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Sem dados.',
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white)),
                                    ),
                                  );
                                } else if (snapshot.hasData == false &&
                                    snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                  return CarregandoScreen(
                                      color: Colors.blue[900], opacity: 0.5);
                                }

                                if (carregar == false) {
                                  carregar = true;

                                  _controllerNome.text = snapshot.data == null
                                      ? ""
                                      : snapshot.data["data"][0]["orc_c_cliente"];
                                  _controllerEmail.text = snapshot.data == null
                                      ? ""
                                      : snapshot.data["data"][0]["orc_c_email"];
                                  _controllerTelefone.text =
                                      snapshot.data == null
                                          ? ""
                                          : snapshot.data == null
                                              ? ""
                                              : snapshot.data["data"][0]["orc_c_celular"];
                                  _controllerEndereco.text =
                                      snapshot.data == null
                                          ? ""
                                          : snapshot.data["data"][0]
                                              ["orc_c_endereco"];
                                  _controllerValor.text = double.parse(
                                          snapshot.data["data"][0]["orc_c_valor"] 
                                          == "null"
                                              ? "0.00"
                                              : snapshot.data["data"][0]["orc_c_valor"]).toStringAsFixed(2);

                                  _controllerComentario.text = snapshot.data 
                                      == null
                                      ? ""
                                      : snapshot.data["data"][0]["orc_c_notas"];

                                  String dataRetorno = snapshot.data['data'][0]['orc_d_dataEvento'] 
                                      == null
                                      ? "14/01/21"
                                      : snapshot.data['data'][0]['orc_d_dataEvento'];

                                  String horaRetorno = snapshot.data['data'][0]['orc_d_dataEventoHora'] 
                                      == null
                                      ? "13:59"
                                      : snapshot.data['data'][0]['orc_d_dataEventoHora'];

                                    String _ano = "${dataRetorno.substring(6,10)}";
                                    String _mes = "${dataRetorno.substring(3,5)}";
                                    String _dia = "${dataRetorno.substring(0,2)}";

                                   String _data = "$_ano-$_mes-$_dia";

                                  _dataAgendada = DateFormat.yMd().format(DateTime.parse(_data));
                                          _hora = stringToTimeOfDay(horaRetorno.substring(11, 19));

                                  if (snapshot.data['data'][0]["orc_b_aprovado"] == "True") {
                                    status = true;
                                  } else {
                                    status = !status;
                                  }
                                }
                                return IntrinsicHeight(
                                  child: Form(
                                    key: _formKey,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: tamanho.height * 0.007),
                                        child: Container(
                                            width: tamanho.width,
                                            height: 1050,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage("assets/images/bg_azul.png"),
                                                  fit: BoxFit.cover,
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 20, bottom: 50),
                                                  child: Text(
                                                    widget.editar != true

                                                        ? "${_locate.locale['SCHEDULE']['add_installation']}"
                                                        : "${_locate.locale['SCHEDULE']['update_installation']}",

                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontFamily: "Garen-Font",
                                                        fontWeight: FontWeight.w900),
                                                  ),
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller: _controllerNome,
                                                  dica: nome ?? "${_locate.locale['ACCREDITATION']['name']}",
                                                  icone: Icons.person,
                                                  enable: true,
                                                  onchanged: (_) {},
                                                  validator: (nome) {

                                                    if (nome.isEmpty)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    else if (nome.length < 1)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    return null;

                                                  },
                                                  inputFormatters: [],
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller:
                                                      _controllerTelefone,
                                                  dica: telefone ??
                                                      "${_locate.locale['ACCREDITATION']['cell_phone']}",
                                                  icone: Icons.phone_android,
                                                  enable: true,
                                                  onchanged: (_) {},
                                                  validator: (telefone) {
                                                    if (telefone.isEmpty)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    else if (telefone.length <
                                                        1)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    return null;
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    TelefoneInputFormatter()
                                                  ],
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller: _controllerEmail,
                                                  dica: email ??
                                                      "${_locate.locale['SCHEDULE']['email']}",
                                                  icone: Icons.email,
                                                  enable: true,
                                                  onchanged: (_) {},
                                                  validator: (email) {
                                                    if (email.isEmpty)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    else if (email.length < 1)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    return null;
                                                  },
                                                  inputFormatters: [],
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller:
                                                      _controllerEndereco,
                                                  dica: endereco ??
                                                      "${_locate.locale['SCHEDULE']['address']}",
                                                  icone: Icons.map,
                                                  enable: true,
                                                  onchanged: (_) {},
                                                  validator: (endereco) {
                                                    if (endereco.isEmpty)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    else if (endereco.length <
                                                        1)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    return null;
                                                  },
                                                  inputFormatters: [],
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller: _controllerValor,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  dica: valor ??
                                                      "${_locate.locale['SCHEDULE']['amount_charged']}",
                                                  icone: Icons.attach_money,
                                                  enable: true,
                                                  onchanged: (_) {},
                                                  validator: (valor) {
                                                    if (valor.isEmpty)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    else if (valor.length < 1)
                                                      return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                                    return null;
                                                  },
                                                  inputFormatters: [],
                                                ),

                                                FormInput(
                                                  tamanho: tamanho,
                                                  controller:
                                                      _controllerComentario,
                                                  dica:
                                                      "${_locate.locale['SCHEDULE']['comments_equipment_used']}",
                                                  icone: Icons.comment,
                                                ),

                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Container(
                                                    width: tamanho.width * 0.91,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      border: Border.all(
                                                        color: Color(0xffffffff),
                                                        width: 0
                                                      ),
                                                      borderRadius:
                                                        BorderRadius.all(Radius.circular(0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          spreadRadius: 3,
                                                          blurRadius: 10,

                                                          offset: Offset(0, 0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _selecionaData(context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: AlignmentDirectional.centerStart,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 15.0),
                                                                child: Text("${_locate.locale['SCHEDULE']['date']}",
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 16
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(right: 10),
                                                                        child: Text(
                                                                          _dataAgendada == null
                                                                              ? "${_locate.locale['SCHEDULE']['select_date']}"
                                                                              : _dataAgendada.toString(),
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        )))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Container(
                                                    width: tamanho.width * 0.91,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      border: Border.all(
                                                          color:
                                                              Color(0xffffffff),
                                                          width: 0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 3,
                                                          blurRadius: 10,

                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        _selecionaHora(context);
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Flexible(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .centerStart,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0),
                                                                child: Text(
                                                                  "${_locate.locale['SCHEDULE']['hour']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .centerEnd,
                                                                    child: Padding(
                                                                        padding: EdgeInsets.only(right: 10),
                                                                        child: Text(
                                                                          _hora == null
                                                                              ? "${_locate.locale['SCHEDULE']['select_time']}"
                                                                              : '${_hora.hour} : ${_hora.minute.toString().padLeft(2, '0')}',
                                                                          style:
                                                                              TextStyle(fontSize: 18),
                                                                        )))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Container(
                                                    width: tamanho.width * 0.91,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      border: Border.all(
                                                          color:
                                                              Color(0xffffffff),
                                                          width: 0),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          spreadRadius: 3,
                                                          blurRadius: 10,

                                                          offset: Offset(0,
                                                              0), // changes position of shadow
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerStart,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          15.0),
                                                              child: Text(
                                                                "${_locate.locale['SCHEDULE']['approved?']}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 2,
                                                          child: Container(
                                                            width:
                                                                tamanho.width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .centerEnd,
                                                                  child: Switch(
                                                                    activeColor:
                                                                        Colors.green[
                                                                            900],
                                                                    value:
                                                                        status,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        status =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0,
                                                          top: 10,
                                                          bottom: 5),
                                                  child: Text(
                                                    "${_locate.locale['SCHEDULE']['correctly_fill_field']}",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: tamanho.height *
                                                            0.015),
                                                    child: GestureDetector(
                                                      onTap: () => {
                                                        if (_formKey
                                                                .currentState
                                                                .validate() ==
                                                            true)
                                                          {
                                                            salvaOrcamento(
                                                                orcamentoManager)
                                                          }
                                                        else
                                                          {}
                                                      },
                                                      child: Container(
                                                        width: tamanho.width *
                                                            0.91,
                                                        height: tamanho.height *
                                                            0.05,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffffffff),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 3,
                                                              blurRadius: 10,

                                                              offset: Offset(0,
                                                                  0), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                              .green[
                                                                          900]),
                                                                  Text(
                                                                    "${_locate.locale['SCHEDULE']['update']}",
                                                                    style: TextStyle(
                                                                        color: Colors.green[
                                                                            900],
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // botão editar

                                                // botão apagar
                                                Visibility(

                                                  visible: true,

                                                  child: Padding(

                                                    padding: EdgeInsets.only(top: tamanho.height * 0.015),

                                                    child: GestureDetector(

                                                      onTap: () => {

                                                        AwesomeDialog(
                                                          
                                                          context: context,
                                                          
                                                          useRootNavigator: true,
                                                          
                                                          dialogType: DialogType.WARNING,
                                                          
                                                          animType: AnimType.BOTTOMSLIDE,
                                                                                                                    
                                                          title: '${_locate.locale['BUDGET']['attention']}',
                                                          
                                                          desc: '${_locate.locale['AWESOMEDIALOG']['attention']}',
                                                                                                                    
                                                          btnOkText: '${_locate.locale['AWESOMEDIALOG']['btn_cancel']}',
                                                          
                                                          btnOkOnPress: () {},

                                                          btnCancelText: '${_locate.locale['AWESOMEDIALOG']['delete']}',
                                                          
                                                          btnCancelOnPress: () {

                                                            orcamentoManager.deletaOrcamento(

                                                              orcamento: OrcamentoModel(orcNCodigo: widget.codigo),

                                                              onSuccess: (v) {

                                                               Navigator.pop(context);

                                                               // Navigator.popAndPushNamed(context, '/agendaInstalacao');

                                                              },

                                                              onFail: (v) {

                                                                Navigator.pop(context, false);

                                                              }

                                                            );

                                                          },

                                                        )..show()

                                                      },

                                                      child: Container(

                                                        width: tamanho.width * 0.91,

                                                        height: tamanho.height * 0.05,

                                                        decoration:

                                                          BoxDecoration(

                                                          color: Color(0xffffffff),

                                                          boxShadow: [

                                                            BoxShadow(

                                                              color: Colors.black.withOpacity(0.5),

                                                              spreadRadius: 3,

                                                              blurRadius: 10,

                                                              offset: Offset(0, 0),

                                                            ),

                                                          ],

                                                        ),

                                                        child: Row(

                                                          crossAxisAlignment: CrossAxisAlignment.center,

                                                          mainAxisAlignment: MainAxisAlignment.center,

                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),

                                                              child: Row(

                                                                children: [

                                                                  Icon(

                                                                    Icons.delete,

                                                                    color: Colors.red[900],

                                                                  ),
                                                                  
                                                                  Text("${_locate.locale['SCHEDULE']['delete']}",

                                                                    style: TextStyle(

                                                                      color: Colors.red[900],

                                                                      fontWeight: FontWeight.bold,

                                                                      fontSize: 20

                                                                    ),

                                                                  ),

                                                                ],

                                                              ),

                                                            ),

                                                          ],

                                                        ),

                                                      ),

                                                    ),

                                                  ),

                                                ),

                                                SizedBox(

                                                  height: 30,

                                                )

                                              ]),

                                            )

                                        )

                                    ),

                                  ),
                                  
                                );

                              },

                              future: orcamentoManager.orcamentoService.recuperaOrcamento(orcamento: OrcamentoModel(orcNCodigo: widget.codigo)

                            )

                          );

                        }),
                      ),

                      SizedBox(

                        height: 30,

                      )  

                    ]),

                  ),

                ),

              ),

              inAsyncCall: isApiCallProcess,

              opacity: 0.3,

            );

          }),

        );

      }),

    );

  }

  salvaOrcamento(orcamentoManager) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if( _dataAgendada != null){
          
      if (_formKey.currentState.validate()) {

      setState(() {
        isApiCallProcess = true;
      });

      orcamentoManager.atualizaOrcamento(

          orcamento: OrcamentoModel(

              orcNCodigo: widget.codigo,

              orcINSNCodigo: prefs.getString("ins_n_codigo"),

              orcCUserUid: prefs.getString("ins_c_uid"),

              orcCTipoInstalacao: widget.tipoInstalacao,

              orcDDataCriaccao: now.toString(),

              orcDDataCriacaoMs: now.toString(),

              orcBStatus: widget.aprovado.toString(),

              orcCAppointmentUid: orcCAppointmentUid,

              orcNValorVistaVi: widget.ceViPo.toString(),

              orcNValorVistaSi: widget.valorPagar.toString(),

              orcNValorPagamentoVi: orcNValorPagamentoVi,

              orcNValorPagamentoSi: orcNValorPagamentoSi,

              orcNValorEntradaVi: orcNValorEntradaVi,

              orcNValorEntradaSi: orcNValorEntradaSi,

              orcNDinheiro: widget.valorPagar.toString(),

              orcBDebito: widget.valorPagar.toString(),

              orcNValorDebitoJuros: orcNValorDebitoJuros,

              orcNValorDebitoTotal: widget.valorPagar.toString(),

              orcNValorCreditoTaxaAdm: orcNValorCreditoTaxaAdm,

              orcNParcela: widget.parcelas.toString(),

              orcNJuros: widget.poVi.toString(),

              orcNValorCreditoJuros: widget.valorPagar.toString(),
              
              orcNValorCreditoTotal: widget.valorPagar.toString(),
              
              orcNValorTotalPrazo: widget.valorPagar.toString(),
              
              orcNLucro: orcNLucro,
              
              orcNCeViCustaEquipamento: widget.ceVi.toString(),
              
              orcNFiViCustoInfra: widget.fiVi.toString(),
              
              orcNCeViPoCustoEquipamento: widget.ceViPo.toString(),
              
              orcNFiViPoOutrasDesp: widget.fiViPo.toString(),
              
              orcNOdViOutrasDesp: widget.odViPo.toString(),
              
              orcNOthSiOutroValor: widget.othSi.toString(),
              
              orcNFiSiCustoInfra: widget.fiSi.toString(),
              
              orcNOdSiOutrasDesp: widget.odSi.toString(),
              
              orcCTittulo: "",
              
              orcDDataEvento: _dataAgendada.toString(),
              
              orcDDataEventoHora: '${_hora.hour.toString().padLeft(2, '0')} : ${_hora.minute.toString().padLeft(2, '0')}',
              
              orcCCliente: _controllerNome.text,
              
              orcCCelular: _controllerTelefone.text,
              
              orcCEndereco: _controllerEndereco.text,
              
              orcCValor: widget.valorPagar.toString() != null ? _controllerValor.doubleValue.toString() : widget.valorPagar.toString(),
              
              orcCNotas: _controllerComentario.text,
              
              orcCEmail: _controllerEmail.text,
              
              orcBAprovado: status.toString()),
              
          onSuccess: (v) {

            AwesomeDialog(

              context: context,

              useRootNavigator: true,

              dialogType: DialogType.SUCCES,

              animType: AnimType.BOTTOMSLIDE,

              title: '${_locate.locale['AWESOMEDIALOG']['congrats']}',

              desc: '${_locate.locale['AWESOMEDIALOG']['registered']}',

              btnOkText: '${_locate.locale['BUDGET']['close']}',

              btnOkOnPress: () {
                  
                Navigator.pop(context);              

              },

            )..show();

            setState(() {

              isApiCallProcess = false;

            });
          },
          onFail: (v) {

            AwesomeDialog(

              context: context,

              dialogType: DialogType.ERROR,

              animType: AnimType.BOTTOMSLIDE,

              useRootNavigator: true,

              title: 'Ops!!!',

              desc: '${_locate.locale['BUDGET']['error']}',

              btnCancelText: '${_locate.locale['BUDGET']['close']}',

              btnCancelOnPress: () {

                Navigator.pop(context, true);

              },

            )..show();

            setState(() {

              isApiCallProcess = false;

            });

          });

     }

    } else {

      AwesomeDialog(

        context: context,

        dialogType: DialogType.ERROR,

        animType: AnimType.BOTTOMSLIDE,

        useRootNavigator: true,

        title: 'Ops!!!',

        desc: '${_locate.locale['SCHEDULE']['select_date']}',

        btnCancelText: '${_locate.locale['BUDGET']['close']}',

        btnCancelOnPress: () {},


      )..show();

    }

  }

  Future<Null> _selecionaData(BuildContext context) async {

    final DateTime dataSelecionada = await DatePickerUtil().datePicker(context: context, dataInicial: _dataInstalacao);

    if (dataSelecionada != null && dataSelecionada != _dataInstalacao) {

      if (DateTime.now().isBefore(_dataInstalacao)) {

      } else {

        setState(() {

          _dataInstalacao = dataSelecionada;

          _dataAgendada = DateFormat.yMd().format(DateTime.parse(_dataInstalacao.toString()));

        });

      }

    }

  }

  Future<Null> _selecionaHora(BuildContext context) async {

    final TimeOfDay selecionadoHora = await showTimePicker(context: context, initialTime: _hora);

    if (selecionadoHora != null && selecionadoHora != _hora) {

      setState(() {

        _hora = selecionadoHora;

        print('${_hora.hour.toString().padLeft(2, '0')} : ${_hora.minute.toString().padLeft(2, '0')}');

      });

    }

  }

  TimeOfDay stringToTimeOfDay(String tod) {

    final format = DateFormat.jm(); //"6:00 AM"

    return TimeOfDay.fromDateTime(format.parse(tod));

  }

}
