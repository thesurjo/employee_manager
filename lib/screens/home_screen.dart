import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../models/employee.dart';
import 'add_employee_screen.dart';
import '../widgets/employee_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Manager'),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<Employee>>(
        stream: context.watch<EmployeeProvider>().employees,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final employees = snapshot.data ?? [];

          if (employees.isEmpty) {
            return const Center(
              child: Text(
                'No employees yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return EmployeeCard(employee: employee);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployeeScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
