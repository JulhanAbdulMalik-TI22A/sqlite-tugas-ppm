import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'models/mahasiswa_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MahasiswaListScreen(),
    );
  }
}

class MahasiswaListScreen extends StatefulWidget {
  @override
  _MahasiswaListScreenState createState() => _MahasiswaListScreenState();
}

class _MahasiswaListScreenState extends State<MahasiswaListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<MahasiswaModel> _mahasiswa = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMahasiswa();
  }

  Future<void> _fetchMahasiswa() async {
    try {
      final mahasiswa = await _dbHelper.getMahasiswa();
      setState(() {
        _mahasiswa = mahasiswa;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error fetching mahasiswa: $e');
    }
  }

  Future<void> _addMahasiswa() async {
    try {
      final newMahasiswa = MahasiswaModel(
        name: 'Julhan A Malik',
        email: 'julhan.abdul_ti22@nusaputra.ac.id',
        jurusan: 'Teknik Informatika',
      );
      await _dbHelper.insertMahasiswa(newMahasiswa);
      _fetchMahasiswa();
    } catch (e) {
      _showErrorDialog('Error adding mahasiswa: $e');
    }
  }

  Future<void> _deleteMahasiswa(int nim) async {
    try {
      await _dbHelper.deleteMahasiswa(nim);
      _fetchMahasiswa();
    } catch (e) {
      _showErrorDialog('Error deleting mahasiswa: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Mahasiswa - SQLite')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _mahasiswa.isEmpty
              ? Center(child: Text('Tidak ada Mahasiswa'))
              : ListView.builder(
                  itemCount: _mahasiswa.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = _mahasiswa[index];
                    return ListTile(
                      title: Text(mahasiswa.name),
                      subtitle: Text(
                          '${mahasiswa.email} \n${mahasiswa.jurusan} - ${mahasiswa.nim}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMahasiswa(mahasiswa.nim!),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addMahasiswa,
      ),
    );
  }
}
