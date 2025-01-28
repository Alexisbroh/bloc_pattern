import 'package:flutter/material.dart';
import 'employee.dart';
import 'employeebloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EmployeeBloc _employeeBloc = EmployeeBloc();

  @override
  void dispose() {
    _employeeBloc.dispose(); // Properly dispose of the bloc
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee App"),
      ),
      body: StreamBuilder<List<Employee>>(
        stream: _employeeBloc.employeeListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No employees available."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final employee = snapshot.data![index];
              return Card(
                elevation: 5.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "${employee.id}.",
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            employee.name,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            "\$${employee.salary.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      color: Colors.green,
                      onPressed: () {
                        _employeeBloc.employeeSalaryIncrement.add(employee);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down),
                      color: Colors.red,
                      onPressed: () {
                        _employeeBloc.employeeSalaryDecrease.add(employee);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
