import 'package:employee_manager/screens/add_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../providers/employee_provider.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLongTerm = employee.isLongTermActive;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<EmployeeProvider>().toggleEmployeeStatus(
                      employee.id,
                      employee.isActive,
                    );
              },
              backgroundColor: employee.isActive ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
              icon: employee.isActive ? Icons.person_off : Icons.person,
              label: employee.isActive ? 'Deactivate' : 'Activate',
            ),
            SlidableAction(
              onPressed: (context) {
                context.read<EmployeeProvider>().deleteEmployee(employee.id);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        
        child: GestureDetector(
          onTap: (){
             Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeeScreen(employeeToEdit: employee),
            ),
          );
          },
          child: Card(
            elevation: 2,
            color: isLongTerm
                ? theme.colorScheme.primaryContainer
                : theme.cardColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        employee.name,
                        style: theme.textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: employee.isActive
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          employee.isActive ? 'Active' : 'Inactive',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${employee.employeeId}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Joined: ${DateFormat('MMM dd, yyyy').format(employee.joinDate)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (isLongTerm) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Long-term Employee',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
