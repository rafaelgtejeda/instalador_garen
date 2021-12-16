class OrcamentoModel {
  String orcNCodigo;
  String orcINSNCodigo;
  String orcCUserUid;
  String orcCTipoInstalacao;
  String orcDDataCriaccao;
  String orcDDataCriacaoMs;
  String orcBStatus;
  String orcCAppointmentUid;
  String orcNValorVistaVi;
  String orcNValorVistaSi;
  String orcNValorPagamentoVi;
  String orcNValorPagamentoSi;
  String orcNValorEntradaVi;
  String orcNValorEntradaSi;
  String orcNDinheiro;
  String orcBDebito;
  String orcNValorDebitoJuros;
  String orcNValorDebitoTotal;
  String orcNValorCreditoTaxaAdm;
  String orcNParcela;
  String orcNJuros;
  String orcNValorCreditoJuros;
  String orcNValorCreditoTotal;
  String orcNValorTotalPrazo;
  String orcNLucro;
  String orcNCeViCustaEquipamento;
  String orcNCeViPoCustoEquipamento;
  String orcNFiViCustoInfra;
  String orcNFiViPoOutrasDesp;
  String orcNOdViOutrasDesp;
  String orcNOthSiOutroValor;
  String orcNFiSiCustoInfra;
  String orcNOdSiOutrasDesp;
  String orcCTittulo;
  String orcDDataEvento;
  String orcDDataEventoHora;
  String orcCCliente;
  String orcCCelular;
  String orcCEndereco;
  String orcCValor;
  String orcCNotas;
  String orcCEmail;
  String orcBAprovado;

  OrcamentoModel(
      {this.orcNCodigo,
      this.orcINSNCodigo,
      this.orcCUserUid,
      this.orcCTipoInstalacao,
      this.orcDDataCriaccao,
      this.orcDDataCriacaoMs,
      this.orcBStatus,
      this.orcCAppointmentUid,
      this.orcNValorVistaVi,
      this.orcNValorVistaSi,
      this.orcNValorPagamentoVi,
      this.orcNValorPagamentoSi,
      this.orcNValorEntradaVi,
      this.orcNValorEntradaSi,
      this.orcNDinheiro,
      this.orcBDebito,
      this.orcNValorDebitoJuros,
      this.orcNValorDebitoTotal,
      this.orcNValorCreditoTaxaAdm,
      this.orcNParcela,
      this.orcNJuros,
      this.orcNValorCreditoJuros,
      this.orcNValorCreditoTotal,
      this.orcNValorTotalPrazo,
      this.orcNLucro,
      this.orcNCeViCustaEquipamento,
      this.orcNCeViPoCustoEquipamento,
      this.orcNFiViCustoInfra,
      this.orcNFiViPoOutrasDesp,
      this.orcNOdViOutrasDesp,
      this.orcNOthSiOutroValor,
      this.orcNFiSiCustoInfra,
      this.orcNOdSiOutrasDesp,
      this.orcCTittulo,
      this.orcDDataEvento,
      this.orcDDataEventoHora,
      this.orcCCliente,
      this.orcCCelular,
      this.orcCEndereco,
      this.orcCValor,
      this.orcCNotas,
      this.orcCEmail,
      this.orcBAprovado});

  OrcamentoModel.fromJson(Map<String, dynamic> json) {
    orcNCodigo = json['orc_n_codigo'];
    orcINSNCodigo = json['orc_ins_n_codigo'];
    orcCUserUid = json['orc_c_userUid'];
    orcCTipoInstalacao = json['orc_c_tipoInstalacao'];
    orcDDataCriaccao = json['orc_d_dataCriaccao'];
    orcDDataCriacaoMs = json['orc_d_dataCriacaoMs'];
    orcBStatus = json['orc_b_status'];
    orcCAppointmentUid = json['orc_c_appointmentUid'];
    orcNValorVistaVi = json['orc_n_valor_vista_vi'];
    orcNValorVistaSi = json['orc_n_valorVista_si'];
    orcNValorPagamentoVi = json['orc_n_valorPagamento_vi'];
    orcNValorPagamentoSi = json['orc_n_valorPagamento_si'];
    orcNValorEntradaVi = json['orc_n_valorEntrada_vi'];
    orcNValorEntradaSi = json['orc_n_valorEntrada_si'];
    orcNDinheiro = json['orc_n_dinheiro'];
    orcBDebito = json['orc_b_debito'];
    orcNValorDebitoJuros = json['orc_n_valor_debito_juros'];
    orcNValorDebitoTotal = json['orc_n_valor_debito_total'];
    orcNValorCreditoTaxaAdm = json['orc_n_valorCreditoTaxaAdm'];
    orcNParcela = json['orc_n_parcela'];
    orcNJuros = json['orc_n_juros'];
    orcNValorCreditoJuros = json['orc_n_valorCreditoJuros'];
    orcNValorCreditoTotal = json['orc_n_valorCreditoTotal'];
    orcNValorTotalPrazo = json['orc_n_valorTotalPrazo'];
    orcNLucro = json['orc_n_lucro'];
    orcNCeViCustaEquipamento = json['orc_n_ce_vi_CustaEquipamento'];
    orcNCeViPoCustoEquipamento = json['orc_n_ce_vi_po_CustoEquipamento'];
    orcNFiViCustoInfra = json['orc_n_fi_vi_CustoInfra'];
    orcNFiViPoOutrasDesp = json['orc_n_fi_vi_po_OutrasDesp'];
    orcNOdViOutrasDesp = json['orc_n_od_vi_OutrasDesp'];
    orcNOthSiOutroValor = json['orc_n_oth_si_OutroValor'];
    orcNFiSiCustoInfra = json['orc_n_fi_si_CustoInfra'];
    orcNOdSiOutrasDesp = json['orc_n_od_si_OutrasDesp'];
    orcCTittulo = json['orc_c_tittulo'];
    orcDDataEvento = json['orc_d_dataEvento'];
    orcDDataEventoHora = json['orc_d_dataEventoHora'];
    orcCCliente = json['orc_c_cliente'];
    orcCCelular = json['orc_c_celular'];
    orcCEndereco = json['orc_c_endereco'];
    orcCValor = json['orc_c_valor'];
    orcCNotas = json['orc_c_notas'];
    orcCEmail = json['orc_c_email'];
    orcBAprovado = json['orc_b_aprovado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orc_n_codigo'] = this.orcNCodigo;
    data['orc_ins_n_codigo'] = this.orcINSNCodigo;
    data['orc_c_userUid'] = this.orcCUserUid;
    data['orc_c_tipoInstalacao'] = this.orcCTipoInstalacao;
    data['orc_d_dataCriaccao'] = this.orcDDataCriaccao;
    data['orc_d_dataCriacaoMs'] = this.orcDDataCriacaoMs;
    data['orc_b_status'] = this.orcBStatus;
    data['orc_c_appointmentUid'] = this.orcCAppointmentUid;
    data['orc_n_valor_vista_vi'] = this.orcNValorVistaVi;
    data['orc_n_valorVista_si'] = this.orcNValorVistaSi;
    data['orc_n_valorPagamento_vi'] = this.orcNValorPagamentoVi;
    data['orc_n_valorPagamento_si'] = this.orcNValorPagamentoSi;
    data['orc_n_valorEntrada_vi'] = this.orcNValorEntradaVi;
    data['orc_n_valorEntrada_si'] = this.orcNValorEntradaSi;
    data['orc_n_dinheiro'] = this.orcNDinheiro;
    data['orc_b_debito'] = this.orcBDebito;
    data['orc_n_valor_debito_juros'] = this.orcNValorDebitoJuros;
    data['orc_n_valor_debito_total'] = this.orcNValorDebitoTotal;
    data['orc_n_valorCreditoTaxaAdm'] = this.orcNValorCreditoTaxaAdm;
    data['orc_n_parcela'] = this.orcNParcela;
    data['orc_n_juros'] = this.orcNJuros;
    data['orc_n_valorCreditoJuros'] = this.orcNValorCreditoJuros;
    data['orc_n_valorCreditoTotal'] = this.orcNValorCreditoTotal;
    data['orc_n_valorTotalPrazo'] = this.orcNValorTotalPrazo;
    data['orc_n_lucro'] = this.orcNLucro;
    data['orc_n_ce_vi_CustaEquipamento'] = this.orcNCeViCustaEquipamento;
    data['orc_n_ce_vi_po_CustoEquipamento'] = this.orcNCeViPoCustoEquipamento;
    data['orc_n_fi_vi_CustoInfra'] = this.orcNFiViCustoInfra;
    data['orc_n_fi_vi_po_OutrasDesp'] = this.orcNFiViPoOutrasDesp;
    data['orc_n_od_vi_OutrasDesp'] = this.orcNOdViOutrasDesp;
    data['orc_n_oth_si_OutroValor'] = this.orcNOthSiOutroValor;
    data['orc_n_fi_si_CustoInfra'] = this.orcNFiSiCustoInfra;
    data['orc_n_od_si_OutrasDesp'] = this.orcNOdSiOutrasDesp;
    data['orc_c_tittulo'] = this.orcCTittulo;
    data['orc_d_dataEvento'] = this.orcDDataEvento;
    data['orc_d_dataEventoHora'] = this.orcDDataEventoHora;
    data['orc_c_cliente'] = this.orcCCliente;
    data['orc_c_celular'] = this.orcCCelular;
    data['orc_c_endereco'] = this.orcCEndereco;
    data['orc_c_valor'] = this.orcCValor;
    data['orc_c_notas'] = this.orcCNotas;
    data['orc_c_email'] = this.orcCEmail;
    data['orc_b_aprovado'] = this.orcBAprovado;
    return data;
  }
}
