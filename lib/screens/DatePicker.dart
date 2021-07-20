import 'package:flutter/material.dart';

class DatePickerClass extends StatefulWidget {
  @override
  _DatePickerClassState createState() => _DatePickerClassState();
}

class _DatePickerClassState extends State<DatePickerClass> {

  //DateTimes
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
    {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              'Pick a date',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Text(
              "${selectedDate.toLocal()}".split(' ')[0],
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () => _selectDate(context), // Refer step 3
              child: Text(
                'Pick Date',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
