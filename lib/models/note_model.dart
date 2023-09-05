
class Note{
  int? id;
  String? title;
  DateTime? date;
  String? priority;
  int? status;
  Note( {this.title, this.date, this.priority, this.status});


  Note.withId({this.id, this.title,
    this.date, this.priority, this.status});

  // Convert Note into a Map.
  Map<String, dynamic>toMap(){
    final map = Map<String, dynamic>();

    if(id != null){
      map['id'] = id;
    }

     map['title'] = title;
    map['priority'] = priority;
    map['status'] = status;
    map['title'] = title;
    map['date'] = date!.toIso8601String();
    return map;
  }

//Convert map to Note object
  factory Note.fromMap( Map<String, dynamic> map){
    return Note.withId(
    id: map['id'],
  title: map['title'],
  date: DateTime.parse(map['date']),
  status: map['status'],
      priority: map['priority']
  );
  }

}