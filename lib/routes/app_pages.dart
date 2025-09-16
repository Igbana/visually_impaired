import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth.dart';
import '../modules/auth/views/login.dart';
import '../modules/auth/views/register.dart';
import 'app_routes.dart';

class AppPages {

  static const INITIAL = Routes.AUTH;

  static final routes = [
    // GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    // GetPage(name: Routes.REGISTER, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.AUTH, page: () => const AuthView(), binding: AuthBinding()),
  ];
}