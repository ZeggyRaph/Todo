import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/screens/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _priority = 'Low';
  DateTime _date = DateTime.now();
  String btnText = 'Add Note';
  String titleText = 'Add Note';

  final TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy' );
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  _handleDatePicker() async{
    final DateTime? date = await showDatePicker(context: context, initialDate: _date,
        firstDate: DateTime(2000), lastDate: DateTime(2100));
    if(date != null && date != _date ){
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.blueAccent ,
      body: GestureDetector(
        onTap: (){},
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40.0,
                vertical: 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget> [

              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen(),),),
                child: Icon(Icons.arrow_back,
                size: 30.0,
                color: Theme.of(context).primaryColor,),
              ),
              const SizedBox(height: 20.0,),
              const Text('Add Note',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold
                ),),
              const SizedBox(height: 10.0,),
              Form(
                key: _formKey,
              child: Column(
                children:  [
                  Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize:18.0 ),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      readOnly: true,
                      controller: _dateController,
                      onTap: _handleDatePicker,
                      style: const TextStyle(
                          fontSize:18.0 ),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        labelStyle: const TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                       ),
                      ),
                    ),),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(
                    vertical: 20.0
                  ),
                    child: DropdownButtonFormField(
                      items: _priorities.map((String priority){
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),),);
                      }).toList(),
                      style: const TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        labelStyle: const TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value.toString();
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(onPressed: (){},
                        child: Text(btnText,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),),),
                  ),
                ],
              ),),
            ]),
          ),
        ),
      ),

    );
  }
}
