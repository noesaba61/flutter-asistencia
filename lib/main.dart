import 'package:flutter/material.dart';

import 'package:charts_flutter/flutter.dart' as charts;

void main() {

  runApp(AutocenterApp());
}

class AutocenterStaff {
  final String name;
  final double salary;
  final String department;
  List<DateTime> attendance = [];

  AutocenterStaff({required this.name, required this.salary, required this.department});
}

class AutocenterApp extends StatelessWidget {
  final List<AutocenterStaff> staffList = [
    AutocenterStaff(name: "Noelia Sabanay", salary: 2000, department: "Logistica"),
    AutocenterStaff(name: "Jesus", salary: 3000, department: "Almacen"),
    AutocenterStaff(name: "Steven Vega", salary: 2300, department: "Ventas"),
    AutocenterStaff(name: "Fabiana", salary: 1500, department: "Logistica")
    ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistencia Personal Autocenter',
      home: StaffListScreen(staffList: staffList),
    );
  }
}

//lista del personal-pantalla principal
class StaffListScreen extends StatefulWidget {
  final List<AutocenterStaff> staffList;

  StaffListScreen({required this.staffList});

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  @override
  Widget build(BuildContext context) {
    //estructura pantalla
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Autocenter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.staffList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.staffList[index].name),
                    subtitle: Text('Sueldo: \$${widget.staffList[index].salary.toString()}'),
                    trailing: Text('Departmento: ${widget.staffList[index].department}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StaffDetailsScreen(staff: widget.staffList[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),  
            // Boton agregar 
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddStaffScreen(staffList: widget.staffList),
                    ),
                  );
                },
                child: const Text('Agregar personal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//pantalla detalle de personal 
class StaffDetailsScreen extends StatelessWidget {
  final AutocenterStaff staff;

  StaffDetailsScreen({required this.staff});

  @override
  Widget build(BuildContext context) {
    // pantalla
    return Scaffold(
      appBar: AppBar(
        title: Text(staff.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Sueldo: \$${staff.salary.toString()}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Departmento: ${staff.department}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Asistencia:'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: staff.attendance.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${staff.attendance[index].day}/${staff.attendance[index].month}/${staff.attendance[index].year}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAttendanceScreen(staff: staff),
                  ),
                );
              },
              child: Text('Agregar Asistencia'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceChartScreen(staff: staff),
                  ),
                );
              },
              child: Text('Ver Tabla de Asistencia'),
            ),
          ),
        ],
      ),
    );
  }
}

//pantalla agregar personal 
class AddStaffScreen extends StatefulWidget {
  final List<AutocenterStaff> staffList;

  AddStaffScreen({required this.staffList});

  @override
  _AddStaffScreenState createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  late String _name;
  late double _salary;
  late String _department;

  @override
  Widget build(BuildContext context) {
    //pantalla
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Personal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //campos de texto
            TextField(
              onChanged: (value) {
                _name = value;
              },
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              onChanged: (value) {
                _salary = double.parse(value);
              },
              decoration: const InputDecoration(labelText: 'Sueldo'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              onChanged: (value) {
                _department = value;
              },
              decoration: InputDecoration(labelText: 'Departamento'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState((){
                  widget.staffList.add(AutocenterStaff(name: _name, salary: _salary, department: _department));
                });
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}


/// FIN





class AddAttendanceScreen extends StatefulWidget {
  final AutocenterStaff staff;

  AddAttendanceScreen({required this.staff});

  @override
  _AddAttendanceScreenState createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  late DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Asistencia'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Selecciona Fecha:'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                });
              }
            },
            child: Text('Selecciona Fecha'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.staff.attendance.add(_selectedDate);
              Navigator.pop(context);
            },
            child: Text('Agregar Asistencia'),
          ),
        ],
      ),
    );
  }
}

class AttendanceChartScreen extends StatelessWidget {
  final AutocenterStaff staff;

  AttendanceChartScreen({required this.staff});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DateTime, DateTime>> series = [
      charts.Series(
        id: 'Asistencia',
        data: staff.attendance,
        domainFn: (DateTime attendance, _) => attendance,
        measureFn: (_, __) => 1,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tabla de asistencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: charts.TimeSeriesChart(
          series,
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ),
      ),
    );
  }
}






