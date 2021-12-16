import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garen/servicos/ibge_estado_servico.dart';
import 'package:garen/provider/editar_perfil_provider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:garen/servicos/localizacao/Localizacao_servico.dart';
import 'package:garen/servicos/localizacao/Localizacao_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:garen/servicos/viacep_servico.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'dart:typed_data';
import 'package:garen/components/animation.dart';
import 'package:garen/utils/request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class EditarPerfil extends StatefulWidget {
  final String nome;
  final String email;
  final String telefone;
  final String cep;
  final Uint8List image;

  EditarPerfil(
      {Key key,
      @required this.nome,
      this.email,
      this.telefone,
      this.image,
      this.cep})
      : super(key: key);

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  File imageFile;
  String base64Image;
  RequestUtil _requestUtil = new RequestUtil();

  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  var maskFormatterPhone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  File image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _openGallary(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
        print(base64Image);
      } else {}
      print("No Image Selected");
    });
    Navigator.of(context).pop();
  }

  Future _openCamera(BuildContext context) async {
    var picture = await picker.getImage(source: ImageSource.camera);
    var status = await Permission.camera.status;
    if (status.isGranted) {
      this.setState(() {
        if (picture != null) {
          imageFile = File(picture.path);
          List<int> imageBytes = imageFile.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
          print(base64Image);
        } else {}
        print("no image selected");
      });
      Navigator.of(context).pop();
    } else if (status.isUndetermined) {
      this.setState(() {
        if (picture != null) {
          imageFile = File(picture.path);
          List<int> imageBytes = imageFile.readAsBytesSync();
          base64Image = base64Encode(imageBytes);
          print(base64Image);
        } else {}
        print("no image selected");
      });
      Navigator.of(context).pop();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Camera Permission'),
                content: Text(
                    'This app needs camera access to take pictures for upload user profile photo'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('Deny'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text('Settings'),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    }
    
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text("${_locate.locale['ACCREDITATION']['select_an_option']}"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child:
                        Text("${_locate.locale['ACCREDITATION']['gallery']}"),
                    onTap: () {
                      _openGallary(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("${_locate.locale['ACCREDITATION']['camera']}"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerEstado = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cidCod;
  String estCod;
  String estado = "API";
  String fotoCod;

  String _result;

  LocalizacaoServico _locate = new LocalizacaoServico();

  void initState() {

    _locate.iniciaLocalizacao(context);

        _controllerNome.text = widget.nome;
    _controllerTelefone.text = widget.telefone;

    // if (widget.cep != null) {
    //   _controllerCEP.text = widget.cep;
    //   _searchCep();
    // } else { }

    super.initState();
  }

  _decideImageView() {

    if (widget.image.isEmpty) {

      if (imageFile == null) {

        return AssetImage("assets/images/foto.png");

      } else {

        return FileImage(imageFile);
        
      }
    } else {
      if (imageFile == null) {
        return MemoryImage(widget.image);
      } else {
        return FileImage(imageFile);
      }
    }
  }

  void _searching(bool enable) {

    setState(() {
      _result = enable ? '' : _result;
    });

  }

  Future _searchCep() async {

    _searching(true);

    final cep = _controllerCEP.text;
    
    final resultCep = await ViaCepService.fetchCep(cep: cep);

    String logradouro = resultCep.logradouro;
    String bairro = resultCep.bairro;
    String localidade = resultCep.localidade;
    String uf = resultCep.uf;

    cidCod = resultCep.ibge;

    if (resultCep.uf == null) {

      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Erro',
          desc: 'Insira um Cep Valido',
          btnCancelText: 'Ok',
          btnCancelOnPress: () {})
        ..show();

      setState(() {

        _controllerCEP.text = "";

      });
      
    }

    print(resultCep.localidade);

    setState(() {
      _result = resultCep.toJson();
    });

    if (_result.isNotEmpty) {
      print(localidade + bairro + logradouro + uf);
      _controllerCidade.text = localidade;
      _searchIBGE(uf);
    }

    _searching(false);
  }

  Future _searchIBGE(String uf) async {
    _searching(true);
    final estado = uf;
    final resultIbge = await IbgeEstadoService.fetchIBGE(ibge: estado);
    int id = resultIbge.id;
    String sigla = resultIbge.sigla;
    String nome = resultIbge.nome;
    estCod = resultIbge.id.toString();

    print(resultIbge.id.toString() + resultIbge.sigla + resultIbge.nome);

    setState(() {
      _result = resultIbge.toJson();
    });

    if (_result.isNotEmpty) {
      print(id.toString() + sigla + nome);

      _controllerEstado.text = nome;
    }

    _searching(false);
  }

  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;
    return LocalizacaoWidget(
      child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor("#004370"),
              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              title: Image.asset(
                "assets/images/logo-branco.png",
                fit: BoxFit.cover,
                width: 100,
              ),
              centerTitle: true,
              actions: <Widget>[],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.005),
                child: Container(
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
                    height: 5
                ),
              ),
            ),
            body: Container(
              child: new Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: HexColor("002d52"),
                ),
                child: Center(
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
                      Container(
                        width: tamanho.width,
                        height: 800,
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
                                    padding: EdgeInsets.only(
                                        top: tamanho.height * 0.02,
                                        bottom: tamanho.height * 0.02),
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          image: _decideImageView(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: 90,
                                      height: 90,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 50.0, top: 57),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            size: 25,
                                          ),
                                          color: Colors.white,
                                          onPressed: () =>
                                              _showChoiceDialog(context),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    1,
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: tamanho.width * 0.045,
                                          right: tamanho.width * 0.045,
                                          top: tamanho.height * 0.015),
                                      child: TextFormField(
                                        validator: (name) {
                                          if (name.isEmpty)
                                            return '${_locate.locale['SIGNUP']['warn_name']}';
                                          else if (name
                                                  .trim()
                                                  .split(' ')
                                                  .length <=
                                              1)
                                            return '${_locate.locale['ACCREDITATION']['plase_enter_your_name']}';
                                          return null;
                                        },
                                        controller: _controllerNome,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText:
                                              "${_locate.locale['ACCREDITATION']['name']}",
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[300]),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Icon(Icons.person,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    2,
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: tamanho.width * 0.045,
                                          right: tamanho.width * 0.045,
                                          top: tamanho.height * 0.015),
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _controllerEmail,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText: widget.email,
                                          hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey[400]),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey[500],
                                              width: 1,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.grey[500],
                                              width: 1,
                                            ),
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Icon(Icons.email,
                                                color: Colors.grey[500]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    3,
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: tamanho.width * 0.045,
                                          right: tamanho.width * 0.045,
                                          top: tamanho.height * 0.015),
                                      child: TextFormField(
                                        validator: (phone) {
                                          if (phone.isEmpty)
                                            return '${_locate.locale['SIGNUP']['warn_cell_phone']}';
                                          else if (phone.length < 15)
                                            return '${_locate.locale['ACCREDITATION']['please_enter_valid_phone']}';
                                          return null;
                                        },
                                        controller: _controllerTelefone,
                                        inputFormatters: [maskFormatterPhone],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText:
                                              "${_locate.locale['ACCREDITATION']['cell_phone']}",
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[300]),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Icon(Icons.phone,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInUp(
                                    4,
                                    Padding(
                                      padding: EdgeInsets.only(

                                        left: tamanho.width * 0.045,
                                        right: tamanho.width * 0.045,
                                        top: tamanho.height * 0.015

                                      ),

                                      child: TextFormField(

                                        validator: (cep) {

                                          if (cep.isEmpty)
                                            return '${_locate.locale['ACCREDITATION']['please_enter_zip_code']}';
                                          else if (cep.length < 9)
                                            return '${_locate.locale['ACCREDITATION']['please_enter_zip_code']}';
                                          return null;

                                        },

                                        controller: _controllerCEP,

                                        inputFormatters: [maskFormatter],

                                        onChanged: (String value) async {

                                          if (value.length < 9) {

                                            setState(() {
                                              _controllerCidade.text = "";
                                              _controllerEstado.text = "";
                                            });

                                          } else {

                                            _searchCep();

                                          }

                                          if (value.length == 1) {}

                                        },
                                        style: TextStyle(color: Colors.white, fontSize: 17),
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          hintText: "CEP",
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[300]),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            borderSide: BorderSide(
                                              color: Theme.of(context).primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(left: 15, right: 15),
                                            child: Icon(Icons.map, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: tamanho.width,
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: FadeInUp(
                                            7,
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: tamanho.width * 0.045,
                                                  right: 2,
                                                  top: tamanho.height * 0.015),
                                              child: TextField(
                                                enabled: false,
                                                controller: _controllerCidade,
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 15),
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  hintText:
                                                      "${_locate.locale['ACCREDITATION']['city']}",
                                                  hintStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey[400]),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey[500],
                                                      width: 1,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    child: Icon(Icons.map,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: FadeInUp(
                                            6,
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 1,
                                                  right: tamanho.width * 0.045,
                                                  top: tamanho.height * 0.015),
                                              child: TextField(
                                                enabled: false,
                                                controller: _controllerEstado,
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 15),
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  hintText:
                                                      "${_locate.locale['ACCREDITATION']['state']}",
                                                  hintStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.grey[400]),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey[500],
                                                      width: 1,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(15),
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: Colors.grey[500],
                                                      width: 1,
                                                    ),
                                                  ),
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    child: Icon(Icons.map,
                                                        color:
                                                            Colors.grey[500]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  FadeInUp(
                                    7,
                                    Consumer<EditarPerfilManager>(
                                        builder: (_, editarPerfilManager, __) {
                                      return Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 35),
                                              child: GestureDetector(
                                                onTap: () => {
                                                  if (_formKey.currentState
                                                      .validate())
                                                    {
                                                      if (_controllerNome
                                                                  .text ==
                                                              null ||
                                                          _controllerTelefone
                                                                  .text ==
                                                              null ||
                                                          _controllerCEP
                                                                  .text.length <
                                                              9)
                                                        {
                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .ERROR,
                                                            animType: AnimType
                                                                .BOTTOMSLIDE,
                                                            title:
                                                                '${_locate.locale['AWESOMEDIALOG']['error']}',
                                                            desc:
                                                                '${_locate.locale['AWESOMEDIALOG']['empty_fields']}',
                                                            btnCancelText:
                                                                '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                            btnCancelOnPress:
                                                                () {},
                                                          )..show()
                                                        }
                                                      else
                                                        {
                                                          editarPerfilManager
                                                              .getAtualiza(
                                                                  nome:
                                                                      _controllerNome
                                                                          .text,
                                                                  email: widget
                                                                      .email,
                                                                  cep: _controllerCEP
                                                                      .text,
                                                                  telefone:
                                                                      _controllerTelefone
                                                                          .text,
                                                                  image: base64Image ??
                                                                      fotoCod,
                                                                  cidCod:
                                                                      cidCod,
                                                                  estCod:
                                                                      estCod,
                                                                  onSuccess:
                                                                      (v) async {
                                                                    if (v['retorno'] ==
                                                                        "true") {
                                                                      _requestUtil.saveImageInstaladorShared(
                                                                          imageInstalador:
                                                                              fotoCod);

                                                                      AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        dialogType:
                                                                            DialogType.SUCCES,
                                                                        animType:
                                                                            AnimType.BOTTOMSLIDE,
                                                                        title:
                                                                            '${_locate.locale['AWESOMEDIALOG']['congrats']}',
                                                                        desc:
                                                                            "${_locate.locale['AWESOMEDIALOG']['changes']}",
                                                                        btnOkText:
                                                                            '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                                        btnOkOnPress:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              true);
                                                                        },
                                                                      )..show();
                                                                    } else {
                                                                      AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        dialogType:
                                                                            DialogType.SUCCES,
                                                                        animType:
                                                                            AnimType.BOTTOMSLIDE,
                                                                        title:
                                                                            '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                                                        desc:
                                                                            "${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}",
                                                                        btnCancelText:
                                                                            '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                                        btnCancelOnPress:
                                                                            () {},
                                                                      )..show();
                                                                    }
                                                                  },
                                                                  onFail: (v) {
                                                                    AwesomeDialog(
                                                                      context:
                                                                          context,
                                                                      dialogType:
                                                                          DialogType
                                                                              .ERROR,
                                                                      animType:
                                                                          AnimType
                                                                              .BOTTOMSLIDE,
                                                                      title:
                                                                          '${_locate.locale['AWESOMEDIALOG']['title_2']}',
                                                                      desc:
                                                                          "${_locate.locale['AWESOMEDIALOG']['something_go_wrong']}",
                                                                      btnCancelText:
                                                                          '${_locate.locale['AWESOMEDIALOG']['btn_close']}',
                                                                      btnCancelOnPress:
                                                                          () {},
                                                                    )..show();
                                                                  })
                                                        }
                                                    }
                                                },
                                                child: Container(
                                                  width: tamanho.width * 0.9,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffffffff),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        spreadRadius: 3,
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
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
                                                        child: Text(
                                                          "${_locate.locale['FORGOT']['btn_send']}",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ));
      }),
    );
  }
}
