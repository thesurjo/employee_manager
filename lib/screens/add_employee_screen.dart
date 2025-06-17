import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employeeToEdit;

  const AddEmployeeScreen({
    super.key, 
    this.employeeToEdit,
  });

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.employeeToEdit != null) {
      _employeeIdController.text = widget.employeeToEdit!.employeeId;
      _nameController.text = widget.employeeToEdit!.name;
      _selectedDate = widget.employeeToEdit!.joinDate;
      _isActive = widget.employeeToEdit!.isActive;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employeeToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Employee' : 'Add New Employee'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Employee'),
                    content: const Text('Are you sure you want to delete this employee?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<EmployeeProvider>()
                              .deleteEmployee(widget.employeeToEdit!.id);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _employeeIdController,
              decoration: const InputDecoration(
                labelText: 'Employee ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter employee ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Join Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active Status'),
              value: _isActive,
              onChanged: (bool value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedDate != null) {
                  final employee = Employee(
                    id: isEditing ? widget.employeeToEdit!.id : '', 
                    employeeId: _employeeIdController.text,
                    name: _nameController.text,
                    joinDate: _selectedDate!,
                    isActive: _isActive,
                  );
                  
                  if (isEditing) {
                    context.read<EmployeeProvider>()
                        .updateEmployee(widget.employeeToEdit!.id, employee);
                  } else {
                    context.read<EmployeeProvider>().addEmployee(employee);
                  }
                  Navigator.pop(context);
                } else if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a join date'),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEditing ? 'Update Employee' : 'Add Employee'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
