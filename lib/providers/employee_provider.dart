import 'package:flutter/foundation.dart';
import '../models/employee.dart';
import '../services/employee_repository.dart';

class EmployeeProvider with ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();
  
  Stream<List<Employee>> get employees => _repository.getEmployees();

  Future<void> addEmployee(Employee employee) async {
    await _repository.addEmployee(employee);
  }

  Future<void> updateEmployee(String id, Employee employee) async {
    await _repository.updateEmployee(id, employee);
  }

  Future<void> toggleEmployeeStatus(String id, bool currentStatus) async {
    await _repository.updateEmployeeStatus(id, !currentStatus);
  }

  Future<void> deleteEmployee(String id) async {
    await _repository.deleteEmployee(id);
  }
}
