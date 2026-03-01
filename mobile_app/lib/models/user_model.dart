class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String bloodType;
  final String medicalNotes;
  final List<String> emergencyContacts;

  const UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.bloodType,
    required this.medicalNotes,
    required this.emergencyContacts,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      bloodType: map['bloodType'] as String,
      medicalNotes: map['medicalNotes'] as String,
      emergencyContacts: List<String>.from(map['emergencyContacts'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'bloodType': bloodType,
      'medicalNotes': medicalNotes,
      'emergencyContacts': emergencyContacts,
    };
  }
}
