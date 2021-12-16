// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/widgets.dart';
import 'package:garen/models/login_model.dart';
import 'package:garen/servicos/banner_servico.dart';

class BannerManager extends ChangeNotifier {
  BannerManager() {
    // _getBanner();
  }

  BannerService bannerService = new BannerService();

  // ignore: unused_element
  Future<void> _getBanner(
      {
      // ignore: unused_element
      LoginModel banner,
      Function onFail,
      Function onSuccess}) async {
    try {
      onSuccess(await bannerService.getBanner());
    } catch (e) {
      onFail(await bannerService.getBanner());
    }

    notifyListeners();
  }
}
