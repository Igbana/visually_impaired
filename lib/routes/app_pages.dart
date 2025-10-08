import 'package:get/get.dart';
import 'package:visually_impaired/modules/reader/bindings/reader_binding.dart';
import 'package:visually_impaired/modules/reader/views/reader_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth.dart';
// import '../modules/auth/views/login.dart';
// import '../modules/auth/views/register.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.READER;

  static final routes = [
    // GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    // GetPage(name: Routes.REGISTER, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(
        name: Routes.AUTH,
        page: () => const AuthView(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.READER,
        page: () => const ReaderView(),
        binding: ReaderBinding()),
  ];
}
