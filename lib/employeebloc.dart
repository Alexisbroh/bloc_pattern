import 'dart:async';
import 'employee.dart';

class EmployeeBloc {
  final List<Employee> _employeeList = [
    Employee(1, "Bobo", 1453.20),
    Employee(2, "Lea", 1234.50),
    Employee(3, "Bart", 12482.30),
  ];

  final _employeeListStreamController = StreamController<List<Employee>>.broadcast();
  final _employeeSalaryIncrementStreamController = StreamController<Employee>();
  final _employeeSalaryDecreaseStreamController = StreamController<Employee>();

  Stream<List<Employee>> get employeeListStream => _employeeListStreamController.stream;

  StreamSink<Employee> get employeeSalaryIncrement => _employeeSalaryIncrementStreamController.sink;
  StreamSink<Employee> get employeeSalaryDecrease => _employeeSalaryDecreaseStreamController.sink;

  EmployeeBloc() {
    // Initialize the stream with the current employee list
    _employeeListStreamController.add(_employeeList);

    _employeeSalaryIncrementStreamController.stream.listen(_incrementSalary);
    _employeeSalaryDecreaseStreamController.stream.listen(_decreaseSalary);
  }

  void _incrementSalary(Employee employee) {
    double actualSalary = employee.salary;
    double salaryIncrement = actualSalary * 0.2; // Increment by 20%
    employee.salary = actualSalary + salaryIncrement;
    _employeeListStreamController.add(_employeeList); // Update the stream
  }

  void _decreaseSalary(Employee employee) {
    double actualSalary = employee.salary;
    double salaryDecrement = actualSalary * 0.2; // Decrease by 20%
    employee.salary = actualSalary - salaryDecrement;
    _employeeListStreamController.add(_employeeList); // Update the stream
  }

  void dispose() {
    _employeeListStreamController.close();
    _employeeSalaryIncrementStreamController.close();
    _employeeSalaryDecreaseStreamController.close();
  }
}
