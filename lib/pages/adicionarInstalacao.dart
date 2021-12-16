import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garen/components/form_input.dart';
import 'package:garen/models/orcamento_model.dart';
import 'package:garen/components/ProgressHUD.dart';
import 'package:garen/pages/agendaInstalacao.dart';
import 'package:garen/provider/orcamento_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/components/date-picker.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:garen/components/animation.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/localizacao_widget.dart';
import 'package:garen/utils/validators/email.dart';

import 'package:currency_text_input_mask/currency_text_input_mask.dart';

class AdicionarInstalacao extends StatefulWidget {
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
  final bool aprovado;
  final String nome;
  final String telefone;
  final String email;
  final String endereco;
  final String comentario;
  final String tipoInstalacao;
  final bool editar;

  const AdicionarInstalacao(
      {Key key,
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
  _AdicionarInstalacaoState createState() => _AdicionarInstalacaoState();
}

class _AdicionarInstalacaoState extends State<AdicionarInstalacao> {
  LocalizacaoServico _locate = new LocalizacaoServico();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerComentario = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  CurrencyTextInputMaskController _controllerValor =
      CurrencyTextInputMaskController();

  final formatter = NumberFormat.simpleCurrency();
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  DateTime _dataInstalacao = DateTime.now();
  DateTime now = DateTime.now();

  TimeOfDay _hora = new TimeOfDay.now();

  String _dataAgendada;

  bool status = false;
  bool aprovado = false;
  bool botaovisivel = true;

  bool isApiCallProcess = false;

  String titulo = "Adicionar Instalação";

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

  @override
  void initState() {
    if (widget.editar) {
      if (widget.nome == null) {
      } else {
        _controllerNome.text = widget.nome;

        if (widget.telefone == null) {
        } else {
          _controllerTelefone.text = widget.telefone;

          if (widget.email == null) {
          } else {
            _controllerEmail.text = widget.email;
            if (widget.comentario == null) {
            } else {
              _controllerComentario.text = widget.comentario;
              if (widget.valorPagar == null) {
              } else {
                _controllerValor.text = widget.valorPagar.toStringAsFixed(2);
              }
            }
          }
        }
      }
    } else {
      if (widget.valorPagar == null) {
      } else {
        _controllerValor.text = widget.valorPagar.toStringAsFixed(2);
      }
    }
    _locate.iniciaLocalizacao(context);
    status = widget.aprovado;

    if (widget.editar == true) {
      botaovisivel = false;
    } else {}

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
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
                              ]
                          )
                      ),
                      height: MediaQuery.of(context).size.height * 0.007),

                  //Acima do Card
                  Consumer<OrcamantoManager>(
                      builder: (_, orcamentoManager, __) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                          padding: EdgeInsets.only(top: tamanho.height * 0.007),
                          child: Container(
                              width: tamanho.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/bg_azul.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 50),
                                    child: Text(
                                      "${_locate.locale['SCHEDULE']['add_installation']}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: "Garen-Font",
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),

                                  FadeInUp(
                                    1,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerNome,
                                      dica:
                                          "${_locate.locale['ACCREDITATION']['name']}*",
                                      icone: Icons.person,
                                      enable: true,
                                      onchanged: (_) {},
                                      validator: (cep) {
                                        if (cep.isEmpty)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_your_name']}';
                                        else if (cep.length < 9)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_your_name']}';
                                        return null;
                                      },
                                      inputFormatters: [],
                                    ),
                                  ),

                                  FadeInUp(
                                    2,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerTelefone,
                                      dica:
                                          "${_locate.locale['ACCREDITATION']['cell_phone']}*",
                                      icone: Icons.phone_android,
                                      keyboardType: TextInputType.number,
                                      enable: true,
                                      onchanged: (_) {},
                                      validator: (phone) {
                                        if (phone.isEmpty)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_valid_phone']}';
                                        else if (phone.length < 14)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_valid_phone']}';
                                        return null;
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TelefoneInputFormatter()
                                      ],
                                    ),
                                  ),
                                  FadeInUp(
                                    3,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerEndereco,
                                      dica:
                                          "${_locate.locale['SCHEDULE']['address']}*",
                                      icone: Icons.map,
                                      enable: true,
                                      onchanged: (_) {},
                                      validator: (cep) {
                                        if (cep.isEmpty)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_zip_code']}';
                                        else if (cep.length < 5)
                                          return '${_locate.locale['ACCREDITATION']['please_enter_zip_code']}';
                                        return null;
                                      },
                                      inputFormatters: [],
                                    ),
                                  ),

                                  FadeInUp(
                                    3,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerEmail,
                                      dica:
                                          "${_locate.locale['ACCREDITATION']['email']}*",
                                      icone: Icons.email,
                                      validator: (email) {
                                        if (email.isEmpty)
                                          return '${_locate.locale['SIGNUP']['warn_email']}';
                                        else if (!emailValid(email))
                                          return '${_locate.locale['ACCREDITATION']['please_enter_valid_email']}';
                                        return null;
                                      },
                                      enable: true,
                                      onchanged: (_) {},
                                      inputFormatters: [],
                                    ),
                                  ),

                                  FadeInUp(
                                    4,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerValor,
                                      dica:
                                          "${_locate.locale['SCHEDULE']['amount_charged']}*",
                                      icone: Icons.attach_money,
                                      keyboardType: TextInputType.number,
                                      enable: true,
                                      onchanged: (_) {},
                                      validator: (cep) {
                                        if (cep.isEmpty)
                                          return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                        else if (cep.length < 1)
                                          return '${_locate.locale['BUDGET']['set_the_optimal_value']}';
                                        return null;
                                      },
                                      inputFormatters: [],
                                    ),
                                  ),

                                  FadeInUp(
                                    5,
                                    FormInput(
                                      tamanho: tamanho,
                                      controller: _controllerComentario,
                                      dica:
                                          "${_locate.locale['SCHEDULE']['comments_equipment_used']}",
                                      icone: Icons.comment,
                                    ),
                                  ),

                                  FadeInUp(
                                    6,
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: tamanho.width * 0.91,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          border: Border.all(
                                              color: Color(0xffffffff),
                                              width: 0),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 10,

                                              offset: Offset(0,
                                                  0), // changes position of shadow
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
                                                  alignment:
                                                      AlignmentDirectional
                                                          .centerStart,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    child: Text(
                                                      "${_locate.locale['SCHEDULE']['date']}*",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Flexible(

                                                flex: 2,

                                                child: Row(

                                                  mainAxisAlignment: MainAxisAlignment.end,

                                                  children: [

                                                    Align(

                                                        alignment: AlignmentDirectional.centerEnd,

                                                        child: Padding(

                                                            padding: EdgeInsets.only(

                                                              right: 10

                                                            ),

                                                            child: Text(

                                                              _dataAgendada 

                                                                == null

                                                                ? "${_locate.locale['SCHEDULE']['select_date']}"

                                                                : _dataAgendada.toString(),

                                                              style: TextStyle(fontSize: 18),

                                                            )

                                                        )
                                                        
                                                    )

                                                  ],

                                                ),

                                              ),

                                            ],

                                          ),

                                        ),

                                      ),

                                    ),

                                  ),

                                  FadeInUp(

                                    6,

                                    Padding(

                                      padding: EdgeInsets.only(top: 10),

                                      child: Container(

                                        width: tamanho.width * 0.91,

                                        height: 50,

                                        decoration: BoxDecoration(

                                          color: Color(0xffffffff),

                                          border: Border.all(

                                            color: Color(0xffffffff),

                                            width: 0

                                          ),

                                          borderRadius: BorderRadius.all(Radius.circular(0),

                                          ),
                                          boxShadow: [

                                            BoxShadow(

                                              color: Colors.black.withOpacity(0.5),

                                              spreadRadius: 3,

                                              blurRadius: 10,

                                              offset: Offset(0, 0),

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

                                                  alignment: AlignmentDirectional.centerStart,
                                                  
                                                  child: Padding(

                                                    padding: const EdgeInsets.only(left: 15.0),

                                                    child: Text(

                                                      "${_locate.locale['SCHEDULE']['hour']}",

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
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerEnd,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: Text(
                                                              _hora == null
                                                                  ? "${_locate.locale['SCHEDULE']['select_time']}"
                                                                  : '${_hora.hour} : ${_hora.minute.toString().padLeft(2, '0')}',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            )))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  FadeInUp(
                                    7,
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Container(
                                        width: tamanho.width * 0.91,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          border: Border.all(
                                              color: Color(0xffffffff),
                                              width: 0),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                                alignment: AlignmentDirectional.centerStart,

                                                child: Padding(

                                                  padding: const EdgeInsets.only(left: 15.0),
                                                  child: Text("${_locate.locale['SCHEDULE']['approved?']}*",
                                                    style: TextStyle(

                                                        color: Colors.black,

                                                        fontSize: 16

                                                    ),

                                                  ),

                                                ),

                                              ),

                                            ),

                                            Flexible(

                                              flex: 2,

                                              child: Row(

                                                mainAxisAlignment: MainAxisAlignment.end,

                                                children: [
                                                  Align(

                                                    alignment: AlignmentDirectional.centerEnd,

                                                    child: Switch(

                                                      activeColor: Colors.green[900],

                                                      value: status,

                                                      onChanged: (value) {

                                                        setState(() {

                                                          status = value;

                                                        });
                                                        
                                                      },

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

                                  FadeInUp(

                                    8,

                                    Padding(

                                      padding: const EdgeInsets.only(

                                        left: 20.0,

                                        top: 10,

                                        right: 20.0,

                                        bottom: 5

                                      ),

                                      child: Text(
                                        
                                        "${_locate.locale['SCHEDULE']['correctly_fill_field']}*",
                                        
                                        style: TextStyle(

                                          color: Colors.white

                                        ),

                                      ),

                                    ),

                                  ),

                                  // botão salvar
                                  FadeInUp(

                                    9,

                                    Visibility(

                                      visible: botaovisivel,

                                      child: Padding(

                                        padding: EdgeInsets.only(

                                            top: tamanho.height * 0.015,

                                            bottom: 10

                                        ),
                                        
                                        child: GestureDetector(

                                          onTap: () => {

                                            salvaOrcamento(orcamentoManager)

                                          },

                                          child: Container(

                                            width: tamanho.width * 0.91,

                                            height: 35,

                                            decoration: BoxDecoration(

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

                                                Padding(padding:const EdgeInsets.all(5.0),

                                                  child: Text(
                                                    
                                                    "${_locate.locale['SCHEDULE']['save']}",

                                                    style: TextStyle(

                                                      color: Colors.green[900],

                                                      fontWeight: FontWeight.bold,

                                                      fontSize: 20

                                                    ),

                                                  ),

                                                ),

                                              ],

                                            ),

                                          ),

                                        ),

                                      ),

                                    ),

                                  ),

                                  // botão salvar

                                  SizedBox(

                                    height: 30,

                                  )

                                ]),

                              )

                          )

                      ),
                      
                    );

                  }),

                ]),

              ),

            ),

          ),

          inAsyncCall: isApiCallProcess,

          opacity: 0.3,

        );

      }),

    );

  }

  salvaOrcamento(orcamentoManager) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_formKey.currentState.validate()) {

      if (

        _controllerComentario.text != "" ||

        _controllerEmail.text != "" ||
        
        _controllerEndereco.text != "" ||
        
        _controllerNome.text != "" ||
        
        _controllerTelefone.text != "" ||
        
        _controllerValor.text != "" ||
        
        _hora != null

      ) {
        
        if( _dataAgendada != null){
          
          setState(() {

            isApiCallProcess = true;

          });

          orcamentoManager.salvaOrcamento(

            orcamento: OrcamentoModel(

                orcINSNCodigo: prefs.getString("ins_n_codigo"),

                orcCUserUid: prefs.getString("ins_c_uid"),

                orcDDataCriaccao: now.toString(),

                orcDDataCriacaoMs: now.toString(),

                orcBStatus: widget.aprovado.toString(),

                orcCAppointmentUid: orcCAppointmentUid,

                orcCTipoInstalacao: widget.tipoInstalacao,

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

                dialogType: DialogType.SUCCES,

                animType: AnimType.BOTTOMSLIDE,

                title: "${_locate.locale['AWESOMEDIALOG']['congrats']}",

                 desc: "${_locate.locale['AWESOMEDIALOG']['registered']}",

                btnCancelText: '${_locate.locale['BUDGET']['close']}',

                btnCancelOnPress: () {

                  // Navigator.push(

                  //   context,

                  //   MaterialPageRoute(

                  //     builder: (context) => AgendaInstalacao()

                  //   )

                  // );

                  // Navigator.popAndPushNamed(context, '/agendaInstalacao');

                  // Navigator.of(context).pushNamedAndRemoveUntil('/screen4', ModalRoute.withName('/screen1'));

                  Navigator.pop(context);

                }

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

                title: "${_locate.locale['AWESOMEDIALOG']['title_2']}",

                desc:  "${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}",

                btnCancelText: "${_locate.locale['BUDGET']['close']}",

                btnCancelOnPress: () {

                  Navigator.pop(context, true);
                },
                
              )..show();

              setState(() {

                isApiCallProcess = false;

              });

            });

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

        
      } else {

        AwesomeDialog(

          context: context,

          dialogType: DialogType.ERROR,

          animType: AnimType.BOTTOMSLIDE,

          title: "${_locate.locale['AWESOMEDIALOG']['title_2']}",

          desc: "${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}",

          btnCancelText: "${_locate.locale['AWESOMEDIALOG']['btn_close']}",

          btnCancelOnPress: () {},

        )..show();

      }
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
      });

    }

  }

  TimeOfDay stringToTimeOfDay(String tod) {

    final format = DateFormat.jm(); //"6:00 AM"

    return TimeOfDay.fromDateTime(format.parse(tod));

  }
}
