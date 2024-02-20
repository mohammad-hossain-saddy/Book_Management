import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  String _jsonData = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    File file = await _getLocalFile();
    if (await file.exists()) {
      String jsonData = await file.readAsString();
      setState(() {
        _jsonData = jsonData;
      });
    } else {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://github.com/mohammad-hossain-saddy/Book_Management/blob/main/myjson.json"));
      if (response.statusCode == 201) {
        File file = await _getLocalFile();
        await file.writeAsString(response.body);
        setState(() {
          _jsonData = response.body.toString();
        });
      } else {
        throw Exception('Failed to fetch data form Network');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Json Data'),
      ),
      body: Center(
        child: _jsonData.isEmpty
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Text(_jsonData),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: const Icon(Icons.sync),
      ),
    );
  }
}
