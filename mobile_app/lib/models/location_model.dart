class LocationModel {
  final String userId;
  final double latitude;
  final double longitude;
  final double speedKph;
  final DateTime timestamp;

  const LocationModel({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.speedKph,
    required this.timestamp,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      userId: map['userId'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      speedKph: (map['speedKph'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'speedKph': speedKph,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
