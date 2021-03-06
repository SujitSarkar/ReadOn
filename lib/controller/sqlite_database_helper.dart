import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:read_on/eBook/ebook_model_classes/sqlite_database_models/book_marks_model.dart';
import 'package:read_on/eBook/ebook_model_classes/chapter_model.dart';
import 'package:read_on/eBook/ebook_model_classes/sqlite_database_models/downloaded_chapter_model.dart';
import 'package:read_on/eBook/ebook_model_classes/sqlite_database_models/my_book_info_model.dart';
import 'package:read_on/eBook/ebook_model_classes/sqlite_database_models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class DatabaseHelper extends GetxController {
  final String domainName = 'https://readon.genextbd.net';

  RxList<MyBookInfoModel> myBookList = RxList<MyBookInfoModel>([]);
  RxList<DownloadedChapterModel> lessonsList =
      RxList<DownloadedChapterModel>([]);

  //bookmarksList
  RxList<BookMarksModel> bookMarksList = RxList<BookMarksModel>([]);

  //noteList
  RxList<NoteModel> noteList = RxList<NoteModel>([]);

  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance(); //Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    //This is executed only once,singleton object
    return _databaseHelper!;
  }

  String bookInfoTable = 'bookInfoTable';
  String colId = 'id';
  String colBookId = 'bookId';
  String colBookName = 'bookName';
  String colWriterName = 'writerName';
  String colThumbnail = "thumbnail";
  String chapterTable = 'chapterTable';
  String colChapterName = 'chapterName';
  String colStory = 'story';

  Future<Database> initializeDatabase() async {
    //Get the directory path for both Android and IOS
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'readOn.db';

    // Open / create the database at a given path
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  void _createDB(Database db, int version) async {
    /// bookInfo table
    await db.execute(
        'CREATE TABLE $bookInfoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colBookId TEXT, $colBookName TEXT, $colWriterName TEXT, $colThumbnail TEXT)');

    /// chapter table
    await db.execute(
        'CREATE TABLE $chapterTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' $colChapterName TEXT, $colBookId TEXT, $colStory TEXT) ');
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<int> insertPurchasedBook(MyBookInfoModel myBookInfoModel) async {
    Database db = await database;
    var result = await db.insert(bookInfoTable, myBookInfoModel.toMap());
    await getMyBookList();
    return result;
  }

  Future<List<Map<String, dynamic>>> getMyBookMapList() async {
    Database db = await database;
    var result = await db.query(bookInfoTable, orderBy: '$colId ASC');
    return result;
  }

  Future<void> getMyBookList() async {
    myBookList.clear();
    var myBookMapList = await getMyBookMapList();
    int count = myBookMapList.length;
    for (int i = 0; i < count; i++) {
      myBookList.add(MyBookInfoModel.fromMapObject(myBookMapList[i]));
      print(myBookList[i].bookId);
    }
    update();
    // ignore: avoid_print
    print("my book length = ${myBookList.length}");
  }

  Future<int> deleteDownloadedBooks(String bookId, int index) async {
    Database db = await database;
    var result = await db
        .rawDelete('DELETE FROM $bookInfoTable WHERE $colBookId = $bookId');
    // var result = await db
    //     .rawDelete('DELETE FROM $bookInfoTable WHERE $colBookId = $bookId'); conflict data

    var result2 = await db
        .rawDelete('DELETE FROM $chapterTable WHERE $colBookId = $bookId');
    myBookList.removeAt(index);
    await getMyBookList();
    update();
    return result;
  }

  Future<bool> getSpecificBook(String bookId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(bookInfoTable,
        where: '$colBookId = ?', whereArgs: [bookId], orderBy: '$colId ASC');
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getLessonsMapList(String bookId) async {
    Database db = await database;
    var result = await db.query(chapterTable,
        where: '$colBookId = ?', whereArgs: [bookId], orderBy: '$colId ASC');
    return result;
  }

  Future<void> getLessonList(String bookId) async {
    lessonsList.clear();
    var lessonMapList = await getLessonsMapList(bookId);
    int count = lessonMapList.length;
    for (int i = 0; i < count; i++) {
      lessonsList.add(DownloadedChapterModel.fromMapObject(lessonMapList[i]));
      print(lessonsList[i].chapterName);
    }
    update();
    // ignore: avoid_print
    print("lesson list length = ${lessonsList.length}");
  }
}
