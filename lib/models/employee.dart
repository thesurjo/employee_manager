import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String employeeId;
  final String name;
  final DateTime joinDate;
  final bool isActive;

  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.joinDate,
    required this.isActive,
  });

  // Check if employee has been active for more than 5 years
  bool get isLongTermActive {
    final now = DateTime.now();
    final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);
    return isActive && joinDate.isBefore(fiveYearsAgo);
  }

  // Convert Firestore document to Employee object
  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      employeeId: data['employeeId'] ?? '',
      name: data['name'] ?? '',
      joinDate: (data['joinDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? false,
    );
  }

  // Convert Employee object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'name': name,
      'joinDate': Timestamp.fromDate(joinDate),
      'isActive': isActive,
    };
  }
}
