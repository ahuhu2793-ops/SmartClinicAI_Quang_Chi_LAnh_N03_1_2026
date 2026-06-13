import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  @visibleForTesting
  set database(Database? db) => _database = db;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('clinic.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = kIsWeb ? '' : await getDatabasesPath();
    final path = kIsWeb ? filePath : join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 8,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS users');
        await db.execute('DROP TABLE IF EXISTS patients');
        await db.execute('DROP TABLE IF EXISTS doctors');
        await db.execute('DROP TABLE IF EXISTS appointments');
        await db.execute('DROP TABLE IF EXISTS services');
        await db.execute('DROP TABLE IF EXISTS medications');
        await db.execute('DROP TABLE IF EXISTS supplies');
        await db.execute('DROP TABLE IF EXISTS holidays');
        await db.execute('DROP TABLE IF EXISTS work_shifts');
        await db.execute('DROP TABLE IF EXISTS duty_schedules');
        await db.execute('DROP TABLE IF EXISTS checkins');
        await db.execute('DROP TABLE IF EXISTS medical_records');
        await db.execute('DROP TABLE IF EXISTS invoices');
        await db.execute('DROP TABLE IF EXISTS base_salary_configs');
        await db.execute('DROP TABLE IF EXISTS shift_coefficients');
        await db.execute('DROP TABLE IF EXISTS complex_cases');
        await db.execute('DROP TABLE IF EXISTS payslips');
        await db.execute('DROP TABLE IF EXISTS service_prices');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const idType = 'TEXT PRIMARY KEY';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        username $textType,
        name $textType,
        email $textType,
        password $textType,
        phone $textType,
        role $textType,
        status $textType,
        patientId $textTypeNull,
        doctorId $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE patients (
        id $idType,
        name $textType,
        phoneNumber $textType,
        email $textTypeNull,
        dateOfBirth $textTypeNull,
        gender $textTypeNull,
        address $textTypeNull,
        medicalHistory $textTypeNull,
        notes $textTypeNull,
        status $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE doctors (
        id $idType,
        doctorCode $textType,
        name $textType,
        specialization $textType,
        email $textType,
        salary $doubleType,
        dateOfBirth $textType,
        workplace $textType,
        degree $textType,
        phoneNumber $textType,
        notes $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id $idType,
        appointmentCode $textType,
        patientId $textType,
        patientName $textType,
        phone $textTypeNull,
        doctorId $textTypeNull,
        doctorName $textTypeNull,
        serviceId $textTypeNull,
        serviceName $textTypeNull,
        appointmentDate $textType,
        appointmentTime $textType,
        notes $textTypeNull,
        status $textType,
        source $textType,
        confirmed INTEGER DEFAULT 0,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE services (
        id $idType,
        serviceCode $textType,
        name $textType,
        price $doubleType,
        description $textType,
        duration $integerType,
        status $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE medications (
        id $idType,
        name $textType,
        unit $textType,
        quantity $integerType,
        importPrice $doubleType,
        sellingPrice $doubleType,
        expirationDate $textTypeNull,
        notes $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE supplies (
        id $idType,
        name $textType,
        unit $textType,
        quantity $integerType,
        importPrice $doubleType,
        notes $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE checkins (
        id $idType,
        checkinCode $textType,
        patientId $textTypeNull,
        patientName $textType,
        appointmentId $textTypeNull,
        doctorId $textType,
        doctorName $textType,
        checkinDate $textType,
        checkinTime $textType,
        status $textType,
        notes $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE medical_records (
        id $idType,
        recordCode $textType,
        patientId $textType,
        patientName $textType,
        doctorId $textType,
        doctorName $textType,
        checkinId $textTypeNull,
        symptoms $textTypeNull,
        diagnosis $textType,
        treatment $textType,
        prescription $textTypeNull,
        notes $textTypeNull,
        status $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id $idType,
        invoiceCode $textType,
        patientId $textType,
        patientName $textType,
        medicalRecordId $textTypeNull,
        medicalRecordCode $textTypeNull,
        items $textType, -- Stored as JSON string
        totalAmount $doubleType,
        paymentMethod $textType,
        status $textType,
        notes $textTypeNull,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE service_prices (
        id $idType,
        priceCode $textType,
        price $doubleType,
        effectiveDate $textType,
        endDate $textTypeNull,
        status $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');
  }

  // Generic CRUD
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    final Map<String, dynamic> dbRow = Map.from(row);
    dbRow.forEach((key, value) {
      if (value is List || value is Map) {
        dbRow[key] = jsonEncode(value);
      } else if (value is bool) {
        dbRow[key] = value ? 1 : 0;
      }
    });
    return await db.insert(table, dbRow, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    final db = await database;
    final Map<String, dynamic> dbRow = Map.from(row);
    dbRow.forEach((key, value) {
      if (value is List || value is Map) {
        dbRow[key] = jsonEncode(value);
      } else if (value is bool) {
        dbRow[key] = value ? 1 : 0;
      }
    });
    final id = row['id'];
    return await db.update(table, dbRow, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
