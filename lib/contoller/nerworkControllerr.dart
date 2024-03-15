import 'package:connectivity/connectivity.dart'; // Import connectivity package for monitoring network status
import 'package:flutter/material.dart'; // Import material package for UI components
import 'package:get/get.dart'; // Import GetX for state management

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity(); // Connectivity instance to monitor network status

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus); // Listen for changes in network connectivity
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    // Function to handle network connectivity changes
    if (connectivityResult == ConnectivityResult.none) {
      // If no internet connection is available
      Get.rawSnackbar(
        messageText: const Text(
          'PLEASE CONNECT TO THE INTERNET', // Display message prompting user to connect to the internet
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        isDismissible: false, // Snackbar is not dismissible
        duration: const Duration(days: 1), // Snackbar duration set to 1 day
        backgroundColor: Colors.red[400]!, // Background color of the snackbar
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35,), // Icon indicating no internet connection
        margin: EdgeInsets.zero, // Margin of the snackbar
        snackStyle: SnackStyle.GROUNDED, // Style of the snackbar
      );
    } else {
      // If internet connection is available
      if (Get.isSnackbarOpen) {
        // Check if there is any open snackbar
        Get.closeCurrentSnackbar(); // Close the current snackbar if open
      }
    }
  }
}
