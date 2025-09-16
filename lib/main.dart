import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:visually_impaired/routes/app_pages.dart';
import 'package:visually_impaired/services/llm_service.dart';
import 'package:visually_impaired/services/settings_service.dart';
import 'package:visually_impaired/services/speech_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();

  runApp(GetMaterialApp(
    title: 'Flutter Demo',
    getPages: AppPages.routes,
    initialRoute: AppPages.INITIAL,
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.cupertino,
    themeMode: Get.find<SettingsService>().getThemeMode(),
    theme: Get.find<SettingsService>().getWebLightTheme(),
    darkTheme: Get.find<SettingsService>().getWebDarkTheme(),
  ));
}

Future<void> initServices() async {
  Get.log('starting services ...');
  // await dotenv.load();
  await GetStorage.init();
  await Get.putAsync(() => SettingsService().init());
  await Get.putAsync(() => SpeechService().init());
  await Get.putAsync(() => LLMService().init());
  Get.log('All services started...');
}