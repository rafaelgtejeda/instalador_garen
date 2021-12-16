
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:garen/bloc/auth_bloc.dart';
import 'package:garen/pages/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garen/pages/agendaInstalacao.dart';
import 'package:garen/bloc/authorization_bloc.dart';
import 'package:garen/provider/banner_provider.dart';
import 'package:garen/provider/orcamento_provider.dart';
import 'package:garen/provider/altera_senha_provider.dart';
import 'package:garen/provider/notificacoes_provider.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:garen/servicos/firebase/firebase_notification.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:garen/provider/editar_perfil_provider.dart';
import 'package:garen/provider/distribuidor_provider.dart';
import 'package:garen/utils/apple_sign_in_available.dart';
import 'package:garen/provider/woocomerce_provider.dart';
import 'package:garen/provider/catalogo_provider.dart';
import 'package:garen/provider/user_provider.dart';
import 'package:garen/pages/notificacao.dart';
import 'package:garen/pages/cadastro.dart';
import 'package:garen/pages/login.dart';
import 'components/splash_screen.dart';
import 'package:intl/intl.dart';

class GarenApp extends StatefulWidget {
  @override
  _GarenAppState createState() => _GarenAppState();
}

class _GarenAppState extends State<GarenApp> {
  
  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  final routes = <String, WidgetBuilder>{
    
                      "/login": (BuildContext context) => LoginPage(),    
                "/cadastro": (BuildContext context) => CadastroPage(),    
              "/dashboard": (BuildContext context) => DashboardPage(),    
         "/notificacao": (BuildContext context) => NotificacoesPage(),
    "/agendaInstalacao": (BuildContext context) => AgendaInstalacao(),

  };

  @override
  Widget build(BuildContext context) {

    Intl.defaultLocale = 'pt';

    authBloc.restoreSession();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => NotificacoesManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => OrcamantoManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => AlteraSenhaManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => EditarPerfilManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => CatalogoManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => BannerManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => DistribuidorManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => WoocommerceProvider(),
          lazy: false,
        ),
        Provider(create: (_) => AuthBloc()),
        Provider(create: (_) => AppleSignInAvailable)
      ],
      child: ConnectivityAppWrapper(
        app: MaterialApp(
            title: 'Instalador Garen',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('pt', 'PT'), // Português PT
              const Locale('en', 'EN'), // English EN
              const Locale('es', 'ES'), // Espanhol ES
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.white,
              backgroundColor: Colors.blue[900],
              scaffoldBackgroundColor: Colors.blue[900],
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: SplashScreen(),
            routes: routes),
      ),
    );
  }

  Future initFirebase() async {
    await Firebase.initializeApp();
    FirebaseNotifications().setupUpFirebase();
  }
}
