import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:garen/servicos/auth_service.dart';
import 'package:garen/utils/request.dart';
import 'package:garen/models/usuario_cadastro.dart';
import 'package:garen/servicos/cadastro_servico.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignIn = GoogleSignIn(scopes: ['openid', 'email', 'profile']);
  final fb = FacebookLogin();

  CadastroService cadastroService = new CadastroService();
  UsuarioCadastroModel cadastroModel = new UsuarioCadastroModel();
  RequestUtil _requestUtil = RequestUtil();

  Stream<User> get currentUserGoogle => authService.currentUserGoogle;
  Stream<User> get currentUserFacebook => authService.currentUserFacebook;
  Stream<User> get currentUserApple => authService.currentUserApple;

  // ignore: close_sinks
  final PublishSubject _isExisteSessaoAtiva = PublishSubject<bool>();
  Stream<bool> get isSessionValid => _isExisteSessaoAtiva.stream;

  verificaUsuarioLogado() async {
    var idInstalador = await _requestUtil.obterIdInstaladorShared();

    if (idInstalador == null) {
      _isExisteSessaoAtiva.sink.add(false);
    } else {
      _isExisteSessaoAtiva.sink.add(true);
    }
  }

  loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final result = await authService.signInWithCredencial(credential);

      print("${result.user.displayName}");

      UsuarioCadastroModel model = UsuarioCadastroModel(
        insCNome: result.user.displayName,
        insCEmail: result.user.email,
        insCTelefone: result.user.phoneNumber,
        insCUid: result.user.uid,
        insBRedeSocia: true,
        insBNovoCadastro: true,
        insCIdGoogle: result.user.uid,
      );

      cadastroUsuarioApi(model);
    } catch (error) {
      print(error);
    }
  }

  loginFacebook() async {
    print('Starting Facebook Login');

    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print('It worked');

        //Get Token
        final FacebookAccessToken fbToken = res.accessToken;

        //Convert to Auth Credential
        final OAuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);

        //User Credential to Sign in with Firebase
        final result = await authService.signInWithCredentail(credential);

        UsuarioCadastroModel model = UsuarioCadastroModel(
          insCNome: result.user.displayName,
          insCEmail: result.user.email,
          insCTelefone: result.user.phoneNumber,
          insCUid: result.user.uid,
          insBRedeSocia: true,
          insBNovoCadastro: true,
          insCIdFacebook: result.user.uid,
        );

        cadastroUsuarioApi(model);

        break;
      case FacebookLoginStatus.Cancel:
        print('O usuário cancelou o login.');
        break;
      case FacebookLoginStatus.Error:
        print('Aqui estava um erro.');
        break;
    }
  }

  Future<User> loginApple() async {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.fullName, Scope.email])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        {
          final appleIdCredential = result.credential;

          final AuthCredential credential = OAuthProvider('apple.com')
              .credential(
                  accessToken:
                      String.fromCharCodes(appleIdCredential.authorizationCode),
                  idToken:
                      String.fromCharCodes(appleIdCredential.identityToken));

          final firebaseUser =
              (await authService.signInWithCredencial(credential)).user;

          UsuarioCadastroModel model = UsuarioCadastroModel(
              insCNome: firebaseUser.displayName,
              insCEmail: firebaseUser.email,
              insCTelefone: firebaseUser.phoneNumber,
              insCUid: firebaseUser.uid,
              insBRedeSocia: true,
              insBNovoCadastro: true,
              insCIdApple: firebaseUser.getIdToken().toString());

          cadastroUsuarioApi(model);

          return firebaseUser;
        }
      case AuthorizationStatus.error:
        {
          throw PlatformException(
              code: 'ERROR_AUTHORIZATION_DENIED',
              message: result.error.toString());
        }
      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }

    return null;
  }

  void cadastroUsuarioApi(UsuarioCadastroModel model) async {
    _requestUtil.saveEmailInstaladorShared(emailInstalador: model.insCEmail);
    _requestUtil.saveNomeInstaladorShared(nomeInstalador: model.insCNome);

    await cadastroService
        .cadastro(cadastroModel: model)
        .then((value) => {salvarDados(value)});
  }

  salvarDados(Map value) async {
    await _requestUtil.saveIdInstaladorShared(
        codigoInstalador: value['retorno']['ins_n_codigo'].toString());
    await _requestUtil.saveEmailInstaladorShared(
        emailInstalador: value['retorno']['ins_c_email']);
    await _requestUtil.saveNomeInstaladorShared(
        nomeInstalador: value['retorno']['ins_c_nome']);
    await _requestUtil.saveRedeSocialInstaladorShared(
        redeSocial: value['retorno']['ins_b_redeSocia']);
    await _requestUtil.saveNovoCadastroShared(
        cadastroInstalador: value['retorno']['ins_b_novoCadastro'].toString());
    _isExisteSessaoAtiva.sink.add(true);
  }

  logout() async {
    await authService.logout();
    await authService.logoutFacebook();
    await authService.logoutApple();
  }
}
