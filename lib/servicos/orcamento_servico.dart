import 'package:dio/dio.dart';
import 'package:garen/global/global.dart';
import 'package:garen/models/orcamento_model.dart';
import 'package:garen/utils/request.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class OrcamentoServico {
  var uuid = Uuid();

  OrcamentoModel orcamento = new OrcamentoModel();
  RequestUtil _request = new RequestUtil();

  String idInstalador;

  Future<Map<String, dynamic>> getOrcamento({OrcamentoModel orcamento}) async {
    Response response;

    Dio dio = new Dio();

    dynamic data;

    idInstalador = await _request.obterIdInstaladorShared();

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointListaOrcamento,
          queryParameters: {
            "orc_ins_n_codigo": idInstalador,
            "orc_b_aprovado": orcamento.orcBAprovado
          });

      if (response.statusCode == 200) {
        data = json.decode(response.data);
      }

      if (response.data == false) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;
  }

  Future<Map<String, dynamic>> recuperaOrcamento(
      {OrcamentoModel orcamento}) async {
    Response response;

    Dio dio = new Dio();

    dynamic data;

    idInstalador = await _request.obterIdInstaladorShared();

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointRecuperaOrcamento,
          queryParameters: {"orc_n_codigo": orcamento.orcNCodigo});

      if (response.statusCode == 200) {
        data = json.decode(response.data);
      }

      if (response.data == false) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;
  }

  Future<Map<String, dynamic>> salvaOrcamento(
      {OrcamentoModel orcamento}) async {
    Response response;
    Dio dio = new Dio();
    dynamic data;

    try {
      response = await dio.get(

          Global.linkGlobal + Global.endPointSalvaOrcamento,

          queryParameters: {

            "orc_ins_n_codigo": orcamento.orcINSNCodigo,

            "orc_c_userUid": orcamento.orcCUserUid,

            "orc_c_tipoInstalacao": orcamento.orcCTipoInstalacao,

            "orc_d_dataCriaccao": orcamento.orcDDataCriaccao,

            "orc_d_dataCriacaoMs": orcamento.orcDDataCriacaoMs,

            "orc_b_status": orcamento.orcBStatus,

            "orc_c_appointmentUid": orcamento.orcCAppointmentUid,

            "orc_n_valor_vista_vi": orcamento.orcNValorVistaVi,

            "orc_n_valorVista_si": orcamento.orcNValorVistaSi,
            
            "orc_n_valorPagamento_vi": orcamento.orcNValorPagamentoVi,

            "orc_n_valorPagamento_si": orcamento.orcNValorPagamentoSi,

            "orc_n_valorEntrada_vi": orcamento.orcNValorEntradaVi,

            "orc_n_valorEntrada_si": orcamento.orcNValorEntradaSi,

            "orc_n_dinheiro": orcamento.orcNDinheiro,

            "orc_b_debito": orcamento.orcBDebito,

            "orc_n_valor_debito_juros": orcamento.orcNValorDebitoJuros,

            "orc_n_valor_debito_total": orcamento.orcNValorDebitoTotal,

            "orc_n_valorCreditoTaxaAdm": orcamento.orcNValorCreditoTaxaAdm,

            "orc_n_parcela": orcamento.orcNParcela,

            "orc_n_juros": orcamento.orcNJuros,

            "orc_n_valorCreditoJuros": orcamento.orcNValorCreditoJuros,

            "orc_n_valorCreditoTotal": orcamento.orcNValorCreditoTotal,

            "orc_n_valorTotalPrazo": orcamento.orcNValorTotalPrazo,

            "orc_n_lucro": orcamento.orcNLucro,

            "orc_n_ce_vi_CustaEquipamento": orcamento.orcNCeViCustaEquipamento,

            "orc_n_ce_vi_po_CustoEquipamento": orcamento.orcNCeViPoCustoEquipamento,

            "orc_n_fi_vi_CustoInfra": orcamento.orcNFiViCustoInfra,

            "orc_n_fi_vi_po_OutrasDesp": orcamento.orcNFiViPoOutrasDesp,

            "orc_n_od_vi_OutrasDesp": orcamento.orcNOdViOutrasDesp,

            "orc_n_oth_si_OutroValor": orcamento.orcNOthSiOutroValor,

            "orc_n_fi_si_CustoInfra": orcamento.orcNFiSiCustoInfra,

            "orc_n_od_si_OutrasDesp": orcamento.orcNOdViOutrasDesp,

            "orc_c_tittulo": orcamento.orcCTittulo,

            "orc_d_dataEvento": orcamento.orcDDataEvento,

            "orc_d_dataEventoHora": orcamento.orcDDataEventoHora,

            "orc_c_cliente": orcamento.orcCCliente,

            "orc_c_celular": orcamento.orcCCelular,
            
            "orc_c_endereco": orcamento.orcCEndereco,

            "orc_c_valor": orcamento.orcCValor,

            "orc_c_notas": orcamento.orcCNotas,

            "orc_c_email": orcamento.orcCEmail,

            "orc_b_aprovado": orcamento.orcBAprovado

          });

      if (response.statusCode == 200) {

        data = json.decode(response.data);

      }

      if (response.data == false) {

        data = null;


      }
    } on DioError catch (e) {
      
      print(e.request);

      print(e.message);
      
    }

    return data;
  }

  Future<Map<String, dynamic>> atualizaOrcamento({OrcamentoModel orcamento}) async {

    Response response;

    Dio dio = new Dio();

    dynamic data;

    idInstalador = await _request.obterIdInstaladorShared();

    try {
      response = await dio
          .post(Global.linkGlobal + Global.endPointAtualizaOrcamento, data: {
        "orc_n_codigo": orcamento.orcNCodigo,
        "orc_ins_n_codigo": idInstalador,
        "orc_c_userUid": orcamento.orcCUserUid,
        "orc_c_tipoInstalacao": orcamento.orcCTipoInstalacao,
        "orc_d_dataCriaccao": orcamento.orcDDataCriaccao,
        "orc_d_dataCriacaoMs": orcamento.orcDDataCriacaoMs,
        "orc_b_status": orcamento.orcBStatus,
        "orc_c_appointmentUid": orcamento.orcCAppointmentUid,
        "orc_n_valor_vista_vi": orcamento.orcNValorVistaVi,
        "orc_n_valorVista_si": orcamento.orcNValorVistaSi,
        "orc_n_valorPagamento_vi": orcamento.orcNValorPagamentoVi,
        "orc_n_valorPagamento_si": orcamento.orcNValorPagamentoSi,
        "orc_n_valorEntrada_vi": orcamento.orcNValorEntradaVi,
        "orc_n_valorEntrada_si": orcamento.orcNValorEntradaSi,
        "orc_n_dinheiro": orcamento.orcNDinheiro,
        "orc_b_debito": orcamento.orcBDebito,
        "orc_n_valor_debito_juros": orcamento.orcNValorDebitoJuros,
        "orc_n_valor_debito_total": orcamento.orcNValorDebitoTotal,
        "orc_n_valorCreditoTaxaAdm": orcamento.orcNValorCreditoTaxaAdm,
        "orc_n_parcela": orcamento.orcNParcela,
        "orc_n_juros": orcamento.orcNJuros,
        "orc_n_valorCreditoJuros": orcamento.orcNValorCreditoJuros,
        "orc_n_valorCreditoTotal": orcamento.orcNValorCreditoTotal,
        "orc_n_valorTotalPrazo": orcamento.orcNValorTotalPrazo,
        "orc_n_lucro": orcamento.orcNLucro,
        "orc_n_ce_vi_CustaEquipamento": orcamento.orcNCeViCustaEquipamento,
        "orc_n_ce_vi_po_CustoEquipamento": orcamento.orcNCeViPoCustoEquipamento,
        "orc_n_fi_vi_CustoInfra": orcamento.orcNFiViCustoInfra,
        "orc_n_fi_vi_po_OutrasDesp": orcamento.orcNFiViPoOutrasDesp,
        "orc_n_od_vi_OutrasDesp": orcamento.orcNOdViOutrasDesp,
        "orc_n_oth_si_OutroValor": orcamento.orcNOthSiOutroValor,
        "orc_n_fi_si_CustoInfra": orcamento.orcNFiSiCustoInfra,
        "orc_n_od_si_OutrasDesp": orcamento.orcNOdViOutrasDesp,
        "orc_c_tittulo": orcamento.orcCTittulo,
        "orc_d_dataEvento": orcamento.orcDDataEvento,
        "orc_d_dataEventoHora": orcamento.orcDDataEventoHora,
        "orc_c_cliente": orcamento.orcCCliente,
        "orc_c_celular": orcamento.orcCCelular,
        "orc_c_endereco": orcamento.orcCEndereco,
        "orc_c_valor": orcamento.orcCValor,
        "orc_c_notas": orcamento.orcCNotas,
        "orc_c_email": orcamento.orcCEmail,
        "orc_b_aprovado": orcamento.orcBAprovado
      });

      if (response.statusCode == 200) {
        data = json.decode(response.data);
      }

      if (response.data == false) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;
  }

  Future<Map<String, dynamic>> deletaOrcamento(
      {OrcamentoModel orcamento}) async {
    Response response;

    Dio dio = new Dio();

    dynamic data;

    idInstalador = await _request.obterIdInstaladorShared();

    try {
      response = await dio.get(
          Global.linkGlobal + Global.endPointDeletaOrcamento,
          queryParameters: {"orc_n_codigo": orcamento.orcNCodigo});

      if (response.statusCode == 200) {
        data = json.decode(response.data);
      }

      if (response.data == false) {
        data = null;
      }
    } on DioError catch (e) {
      print(e.request);
      print(e.message);
    }

    return data;
  }
}
