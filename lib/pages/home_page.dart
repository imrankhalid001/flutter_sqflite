import 'package:flutter/material.dart';
import 'package:flutter_sqflite/models/task.dart';
import 'package:flutter_sqflite/servies/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
final DataBaseService _dataBaseService = DataBaseService.instance;
String? _task = null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: _addtaskButton(),
      body: _taskList(),


    );

  }

Widget _addtaskButton(){
  return FloatingActionButton(onPressed: () {
    showDialog(context: context, builder: (_)=>AlertDialog(
      title:  Text('Add Task'),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        children: [ 
          TextField(
            onChanged: (value){
              setState(() {
                  _task = value;
              });

            },


            decoration:  InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Text'
              

            ),
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: (){
              if(_task == null || _task == "") return ;
              _dataBaseService.addTask(_task!);
              setState(() {
                _task = null;
              });
              Navigator.pop(context);

            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),

            
            )
        ],
      ),
    ),
    );
  }, child: const 
  Icon(Icons.add, ),

  
  
  );
}

Widget _taskList(){

  return FutureBuilder(future: _dataBaseService.getTask(), builder: (context , snapshot){
    return ListView.builder(
      
      itemCount: snapshot.data?.length ?? 0 ,
      itemBuilder: (context, index){
        Task task = snapshot.data![index];
        return ListTile(
          onLongPress: (){
            _dataBaseService.deleteTask(task.id);
            setState(() {
            
            });
          },
          title: 
          Text(task.content),
           trailing: Checkbox(
            value:  task.status == 1,
          onChanged: (value) {
            _dataBaseService.updateTaskStatus(task.id, value == true ? 1 : 0 );

            setState(() {
              
            });


          },
          ),
        );
      },
      
    );
  });
}




}