import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart';

class EmployeeRepository {
  final CollectionReference _employeesCollection =
      FirebaseFirestore.instance.collection('employees');

  // Get stream of all employees
  Stream<List<Employee>> getEmployees() {
    return _employeesCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Employee.fromFirestore(doc))
          .toList();
    });
  }

  // Add a new employee
  Future<void> addEmployee(Employee employee) async {
    await _employeesCollection.add(employee.toMap());
  }

  // Update employee
  Future<void> updateEmployee(String id, Employee employee) async {
    await _employeesCollection.doc(id).update(employee.toMap());
  }

  // Update employee status
  Future<void> updateEmployeeStatus(String id, bool isActive) async {
    await _employeesCollection.doc(id).update({'isActive': isActive});
  }

  // Delete employee
  Future<void> deleteEmployee(String id) async {
    await _employeesCollection.doc(id).delete();
  }
}
