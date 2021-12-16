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
                        child: Text("TERMOS DE USO E POLÍTICA DE PRIVACIDADE",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A seguir estão descritas as regras aplicáveis à utilização do aplicativo Instalador Garen (“Aplicativo”) disponibilizado em dispositivos móveis com sistemas Android e iOS pela GAREN AUTOMACAO S/A. (“GAREN”), sediada na RUA SÃO PAULO, 760, Garça, SP, CEP 17.400-000, CNPJ/MF nº 13.246.724/0001-61.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Ao realizar o cadastro para utilização do Aplicativo, o Usuário se submeterá automaticamente às regras e condições destes Termos de Uso.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O Aplicativo permite que o Usuário tenha acesso a informações e conteúdos relacionados aos produtos e notícias da GAREN, além de ter acesso a outras funcionalidades disponibilizadas pelo Aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O cadastro para uso do Aplicativo é realizado no primeiro acesso do Usuário que deverá inserir seu email de usuário e senha, e inserir demais informações do seu perfil como nome completo e telefone celular. É de inteira responsabilidade dos usuários o fornecimento de informações corretas e completas.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "Será permitido um único cadastramento por Usuário, devendo o acesso, visualização e uso do Aplicativo ser feito pelo Usuário em caráter pessoal e intransferível. Não é permitido compartilhamento do Aplicativo em qualquer site ou ambiente virtual.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "No caso de menores de 18 anos ou outras pessoas que necessitem de representação na forma da lei, o cadastramento deverá ser realizado com a assistência dos pais ou dos representantes legais",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "É proibida a realização de mais de um cadastro por Usuário, bem como, o Usuário se utilizar do cadastro de outro Usuário.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN poderá, sem prévio aviso, bloquear e cancelar o acesso ao aplicativo quando verificar que o Usuário praticou algum ato ou mantenha conduta que (I) viole as leis e regulamentos federais, estaduais e/ou municipais, (II) contrarie as regras destes Termos de Uso, ou (III) viole os princípios da moral e dos bons costumes. Toda e qualquer ação executada pelo Usuário durante o uso do aplicativo será de sua exclusiva e integral responsabilidade, devendo isentar e indenizar a GAREN de quaisquer reclamações, prejuízos, perdas e danos causados à GAREN, em decorrência de tais ações ou manifestações.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "O Usuário autoriza a GAREN ou terceiros por ela indicados, a utilizar, por prazo indeterminado, as informações fornecidas no ato do cadastro e durante o uso do aplicativo, para fins estatísticos e envio de material publicitário, newsletters, informes, etc.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN se reserva o direito de incluir, excluir ou alterar os conteúdos e funcionalidades do aplicativo, bem como suspendê-lo temporariamente ou cancelá-lo, a qualquer momento, independentemente de aviso-prévio ao Usuário. Da mesma forma, poderá modificar estes Termos de Uso, cuja versão mais recente estará sempre disponível para consulta no aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "As sugestões de orçamentos, e o cálculo para construção de portões, ou qualquer outra informação visa tão somente colaborar com o trabalho do Usuário. O Usuário é exclusivamente responsável por todo e qualquer inserção de dados ou obtenção de orientações pelo aplicativo.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "A GAREN SE EXIME DE TODA E QUALQUER RESPONSABILIDADE PELOS DANOS E PREJUÍZOS DE QUALQUER NATUREZA QUE POSSAM DECORRER DO ACESSO, INTERCEPTAÇÃO, ELIMINAÇÃO, ALTERAÇÃO, MODIFICAÇÃO OU MANIPULAÇÃO, POR TERCEIROS NÃO AUTORIZADOS, DOS DADOS DO USUÁRIO DURANTE A UTILIZAÇÃO DO APLICATIVO.",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            "As informações solicitadas ao Usuário no momento do cadastro serão utilizadas pela GAREN somente para os fins previstos nestes Termos de Uso e em nenhuma circunstância, tais informações serão cedidas ou compartilhadas com terceiros, exceto por ordem judicial ou de autoridade competente. Fica eleito o Foro da Comarca da cidade de São Paulo, Estado de São Paulo, para dirimir quaisquer questões decorrentes destes Termos de Uso, que será regido pelas leis brasileiras.",
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
