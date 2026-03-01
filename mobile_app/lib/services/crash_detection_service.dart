import 'dart:async';
import 'package:flutter/foundation.dart';

class CrashDetectionService extends ChangeNotifier {
  // Threshold values based on master prompt
  final double gForceThreshold = 7.5;
  final double tiltThreshold = 60.0;
  
  bool _isCrashDetected = false;
  bool get isCrashDetected => _isCrashDetected;

  // Real data would come from sensors_plus
  // StreamSubscription<AccelerometerEvent>? _accelSub;
  // StreamSubscription<GyroscopeEvent>? _gyroSub;

  void startMonitoring() {
    if (kDebugMode) {
      print('Crash Detection Started');
    }
    // _accelSub = accelerometerEvents.listen((event) {
    //   double gForce = calculateGForce(event.x, event.y, event.z);
    //   if (gForce > gForceThreshold) {
    //      triggerCrash();
    //   }
    // });
  }

  void stopMonitoring() {
    if (kDebugMode) {
      print('Crash Detection Stopped');
    }
    // _accelSub?.cancel();
    // _gyroSub?.cancel();
  }

  void triggerCrash() {
    _isCrashDetected = true;
    notifyListeners();
  }

  void resetCrash() {
    _isCrashDetected = false;
    notifyListeners();
  }
}
