import 'package:get/get.dart';
import 'contoller/nerworkControllerr.dart';


class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}