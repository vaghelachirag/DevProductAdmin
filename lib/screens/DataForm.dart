import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataFormPage extends StatefulWidget {
  @override
  _DataFormPageState createState() => _DataFormPageState();
}

class _DataFormPageState extends State<DataFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _msgController = TextEditingController();

  final String scriptUrl = "https://script.google.com/macros/s/AKfycbyFBbdFeKt2sW1Y3qyPpCYx38kF6Nk8-HBz5QL4Y1S2w6c0jKyZ9EBU8_DjbuPv5NTa/exec";

  Future<void> _sendData() async {
    var body = jsonEncode({
      "name": _nameController.text,
      "email": _emailController.text,
      "message": _msgController.text,
    });

    try {
      final response = await http.post(
        Uri.parse(scriptUrl),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data sent successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter → Google Script Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _msgController, decoration: const InputDecoration(labelText: "Message")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendData,
              child: const Text("Send to Google Sheet"),
            ),
          ],
        ),
      ),
    );
  }
}