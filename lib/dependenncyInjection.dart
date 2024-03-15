import 'package:get/get.dart'; // Importing the Get package for dependency injection.
import 'contoller/nerworkControllerr.dart'; // Importing the custom NetworkController class.

// A class responsible for initializing dependencies using GetX dependency injection.
class DependencyInjection {
  
  // A static method to initialize dependencies.
  static void init() {
    // Registering NetworkController as a singleton dependency.
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
