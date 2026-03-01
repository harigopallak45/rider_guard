class TripModel {
  final String tripId;
  final String tripName;
  final String createdBy;
  final List<String> members;
  final String status; // 'active' | 'ended'
  final DateTime createdAt;

  const TripModel({
    required this.tripId,
    required this.tripName,
    required this.createdBy,
    required this.members,
    required this.status,
    required this.createdAt,
  });

  factory TripModel.fromMap(Map<String, dynamic> map) {
    return TripModel(
      tripId: map['tripId'] as String,
      tripName: map['tripName'] as String,
      createdBy: map['createdBy'] as String,
      members: List<String>.from(map['members'] ?? []),
      status: map['status'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'tripName': tripName,
      'createdBy': createdBy,
      'members': members,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
