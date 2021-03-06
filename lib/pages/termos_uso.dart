import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TermosUso extends StatefulWidget {
  @override
  _TermosUsoState createState() => _TermosUsoState();
}

class _TermosUsoState extends State<TermosUso> {
  @override
  Widget build(BuildContext context) {
    Size tamanho = MediaQuery.of(context).size;

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
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.005),
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
              height: 5),
        ),
      ),
      body: Container(
        width: tamanho.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_azul.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TERMOS DE ",
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                        Text(
                          "USO",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("APP INSTALADOR GAREN",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("TERMOS DE USO E POL??TICA DE PRIVACIDADE",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A seguir est??o descritas as regras aplic??veis ?? utiliza????o do aplicativo Instalador Garen (???Aplicativo???) disponibilizado em dispositivos m??veis com sistemas Android e iOS pela GAREN AUTOMACAO S/A. (???GAREN???), sediada na RUA S??O PAULO, 760, Gar??a, SP, CEP 17.400-000, CNPJ/MF n?? 13.246.724/0001-61.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Ao realizar o cadastro para utiliza????o do Aplicativo, o Usu??rio se submeter?? automaticamente ??s regras e condi????es destes Termos de Uso.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O Aplicativo permite que o Usu??rio tenha acesso a informa????es e conte??dos relacionados aos produtos e not??cias da GAREN, al??m de ter acesso a outras funcionalidades disponibilizadas pelo Aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O cadastro para uso do Aplicativo ?? realizado no primeiro acesso do Usu??rio que dever?? inserir seu email de usu??rio e senha, e inserir demais informa????es do seu perfil como nome completo e telefone celular. ?? de inteira responsabilidade dos usu??rios o fornecimento de informa????es corretas e completas.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Ser?? permitido um ??nico cadastramento por Usu??rio, devendo o acesso, visualiza????o e uso do Aplicativo ser feito pelo Usu??rio em car??ter pessoal e intransfer??vel. N??o ?? permitido compartilhamento do Aplicativo em qualquer site ou ambiente virtual.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "No caso de menores de 18 anos ou outras pessoas que necessitem de representa????o na forma da lei, o cadastramento dever?? ser realizado com a assist??ncia dos pais ou dos representantes legais",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "?? proibida a realiza????o de mais de um cadastro por Usu??rio, bem como, o Usu??rio se utilizar do cadastro de outro Usu??rio.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN poder??, sem pr??vio aviso, bloquear e cancelar o acesso ao aplicativo quando verificar que o Usu??rio praticou algum ato ou mantenha conduta que (I) viole as leis e regulamentos federais, estaduais e/ou municipais, (II) contrarie as regras destes Termos de Uso, ou (III) viole os princ??pios da moral e dos bons costumes. Toda e qualquer a????o executada pelo Usu??rio durante o uso do aplicativo ser?? de sua exclusiva e integral responsabilidade, devendo isentar e indenizar a GAREN de quaisquer reclama????es, preju??zos, perdas e danos causados ?? GAREN, em decorr??ncia de tais a????es ou manifesta????es.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O Usu??rio autoriza a GAREN ou terceiros por ela indicados, a utilizar, por prazo indeterminado, as informa????es fornecidas no ato do cadastro e durante o uso do aplicativo, para fins estat??sticos e envio de material publicit??rio, newsletters, informes, etc.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN se reserva o direito de incluir, excluir ou alterar os conte??dos e funcionalidades do aplicativo, bem como suspend??-lo temporariamente ou cancel??-lo, a qualquer momento, independentemente de aviso-pr??vio ao Usu??rio. Da mesma forma, poder?? modificar estes Termos de Uso, cuja vers??o mais recente estar?? sempre dispon??vel para consulta no aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "As sugest??es de or??amentos, e o c??lculo para constru????o de port??es, ou qualquer outra informa????o visa t??o somente colaborar com o trabalho do Usu??rio. O Usu??rio ?? exclusivamente respons??vel por todo e qualquer inser????o de dados ou obten????o de orienta????es pelo aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN SE EXIME DE TODA E QUALQUER RESPONSABILIDADE PELOS DANOS E PREJU??ZOS DE QUALQUER NATUREZA QUE POSSAM DECORRER DO ACESSO, INTERCEPTA????O, ELIMINA????O, ALTERA????O, MODIFICA????O OU MANIPULA????O, POR TERCEIROS N??O AUTORIZADOS, DOS DADOS DO USU??RIO DURANTE A UTILIZA????O DO APLICATIVO.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "As informa????es solicitadas ao Usu??rio no momento do cadastro ser??o utilizadas pela GAREN somente para os fins previstos nestes Termos de Uso e em nenhuma circunst??ncia, tais informa????es ser??o cedidas ou compartilhadas com terceiros, exceto por ordem judicial ou de autoridade competente. Fica eleito o Foro da Comarca da cidade de S??o Paulo, Estado de S??o Paulo, para dirimir quaisquer quest??es decorrentes destes Termos de Uso, que ser?? regido pelas leis brasileiras.",
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
