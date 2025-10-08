import 'package:get/get.dart';
import 'package:visually_impaired/modules/reader/controllers/reader_controller.dart';

class ReaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(
      () => ReaderController(),
    );
  }
}
