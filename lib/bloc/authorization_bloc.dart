import 'package:garen/models/user_session.dart';
import 'package:garen/provider/shared_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationBlock {
  UserSession user;

  final PublishSubject _isSessionValid = PublishSubject<bool>();
  Stream<bool> get isSessionValid => _isSessionValid.stream;
  SharedPref sharedPref = SharedPref();

  void dispose() {
    _isSessionValid.close();
  }

  void restoreSession() async {
    try {
      user = UserSession.fromJson(await sharedPref.read('user'));
      _isSessionValid.sink.add(true);
    } catch (e) {
      print(e);
      _isSessionValid.sink.add(false);
    }
  }

  void openSession(UserSession user) async {
    sharedPref.save("user", user);
    this.user = user;
    _isSessionValid.sink.add(true);
  }

  void closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
    _isSessionValid.sink.add(false);
  }
}

final authBloc = AuthorizationBlock();
