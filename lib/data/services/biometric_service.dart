import 'package:health/health.dart';

class BiometricService {
  static final BiometricService _instance = BiometricService._internal();
  factory BiometricService() => _instance;
  BiometricService._internal();

  final Health _health = Health();

  Future<bool> requestPermissions() async {
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    
    // In health ^13.1.3, use requestAuthorization
    return await _health.requestAuthorization(types);
  }

  Future<List<HealthDataPoint>> getHealthData(DateTime start, DateTime end) async {
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    return await _health.getHealthDataFromTypes(
      startTime: start,
      endTime: end,
      types: types,
    );
  }

  Future<void> saveYogaSession(int minutes, double calories) async {
    final now = DateTime.now();
    await _health.writeHealthData(
      value: calories,
      type: HealthDataType.ACTIVE_ENERGY_BURNED,
      startTime: now.subtract(Duration(minutes: minutes)),
      endTime: now,
    );
  }
}
