import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_todo/database/database.dart';
import 'package:my_todo/models/note_model.dart';
import 'package:my_todo/screens/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
   final Note? note;
   final Function? updateNoteList;
  const AddNoteScreen({super.key, this.note, this.updateNoteList});

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

  @override
  void initState(){
    super.initState();
    if(widget.note != null){
      _title = widget.note!.title!;
    _date =widget.note!.date!;
    _priority = widget.note!.priority!;

    setState(() {
      btnText = 'Update Note';
      titleText = 'Update Note';
    });
    }else{
      setState(() {
        btnText = 'Add Note';
        titleText = 'Add Note';
      });
    }
    _dateController.text = _dateFormatter.format(_date);
  }

  @override
  void dispose(){
    _dateController.dispose();
    super.dispose();
  }

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

  _submit(){
if(_formKey.currentState!.validate()){
  _formKey.currentState!.save();
  print('$_title, $_date, $_priority');
  Note note = Note(
      title: _title,
      date: _date,
      priority: _priority);
  if(widget.note == null){
    note.status = 0;
    DatabaseHelper.instance.insertNote(note);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
    const HomeScreen(),
    ),
    );
  }else{
    note.id = widget.note!.id;
    note.status = widget.note!.status;
    DatabaseHelper.instance.updateNote(note);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
        const HomeScreen(),
    ),
    );

  }
  widget.updateNoteList!();
}
  }

  _delete(){
    DatabaseHelper.instance.deleteNote(widget.note!.id!);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
    const HomeScreen(),
    ),
    );
    widget.updateNoteList!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.blueAccent ,
      body: GestureDetector(
        //This will enable the keyboard to disappear
        // when the addnote screen is tapped
        onTap: () => FocusScope.of(context).unfocus(),
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
              Text(titleText,
                style: const TextStyle(
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
                    validator: (input)=>
                    input!.trim().isEmpty ? 'Please enter title': null,
                    onSaved: (input)=> _title = input!,
                    initialValue: _title,
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
                      isDense: true,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      iconSize: 22.0,
                      iconEnabledColor: Theme.of(context).primaryColor,
                      items: _priorities.map((String priority){
                        return DropdownMenuItem(
                          value: priority,
                          child: Text(priority,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),),);
                      }).toList(),
                      style:  const TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        labelStyle: const TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (input)=> _priority == null
                          ? 'Please select a priority': null,
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
                    child: ElevatedButton(onPressed: _submit,
                        child: Text(btnText,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        ),
                    ),
                  ),
                  widget.note != null ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:  ElevatedButton(
                      child: Text('delete Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ) ,
                      ),
                      onPressed: _delete,
                    ),
                  ) : SizedBox.shrink(),
                ],
              ),),
            ]),
          ),
        ),
      ),

    );
  }
}
