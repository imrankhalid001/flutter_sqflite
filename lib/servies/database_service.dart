import 'package:flutter_sqflite/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService { 



  static Database? _db;
  static final DataBaseService instance = DataBaseService._construcutre();

  final String _taskTableName = "tasks" ; 
  final String _taskIdColumnName = "id" ; 
  final String _taskContentColumnName = "content" ; 
  final String _taskStatusColumnName = "status" ; 




  DataBaseService._construcutre();


  Future<Database> get database async{

    if(_db != null) return _db!;

    _db = await getDatabase();

    return _db!;

  }

  Future<Database> getDatabase () async {

final databaseDirPath = await getDatabasesPath();
final databasePath = join(databaseDirPath , "master_db.db");
final database = await openDatabase(
  databasePath,
    version: 1,
  onCreate: (db, version){
    db.execute('''

   CREATE TABLE $_taskTableName (
   $_taskIdColumnName INTEGER PRIMARY KEY,
   $_taskContentColumnName TEXT NOT NULL,
   $_taskStatusColumnName INTEGER NOT NULL
   )


''');
  }

);

return database;

 }

 void addTask (String content) async {

  final db = await database;
  await db.insert(_taskTableName, {

    _taskContentColumnName : content,
    _taskStatusColumnName: 0,
    

  });

 }

 Future<List<Task>> getTask() async {

  final db = await database;
  final data = await db.query(_taskTableName);
  List<Task> tasks = data.map((e) => Task(id: e["id"] as int, status: e["status"] as int, content: e["content"] as String)).toList();

  return tasks;

 }

 void updateTaskStatus(int id, int status) async {
  final db = await database;
   
   await db.update(_taskTableName, {
    _taskStatusColumnName : status,
   },
   where: 'id = ?',
   whereArgs: [
    id,

   ]
   
   );
 }

 void deleteTask(int id ) async {
  final db = await database;

  await db.delete(
    _taskTableName, 
     where: 'id = ?',
   whereArgs: [
    id,

   ]

  );
  
 }


}