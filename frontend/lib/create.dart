import 'package:flutter/material.dart';
import 'package:frontend/services/api.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  CreateScreenState createState() {
    return CreateScreenState();
  }
}

class CreateScreenState extends State<CreateScreen> {
  var namaController = TextEditingController();
  var nimController = TextEditingController();
  var jurusanController = TextEditingController();

  bool _isLoading = false;

  // Validasi input
  bool _validateInputs() {
    if (namaController.text.isEmpty || 
        nimController.text.isEmpty || 
        jurusanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return false;
    }
    return true;
  }

  // Reset semua controller
  void _resetFields() {
    namaController.clear();
    nimController.clear();
    jurusanController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.greenAccent],
                ),
              ),
            ),
            // Header Text
            Container(
              padding: const EdgeInsets.only(left: 20, top: 50),
              child: const Text(
                "Create Person Data",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Main Input Container
            Center(
              child: SingleChildScrollView(  // Tambahan untuk keyboard overflow
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text Fields
                      _buildTextField(namaController, "Nama"),
                      const SizedBox(height: 15),
                      _buildTextField(nimController, "NIM"),
                      const SizedBox(height: 15),
                      _buildTextField(jurusanController, "Jurusan"),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (_validateInputs()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    var data = {
                                      "nama": namaController.text,
                                      "nim": nimController.text,
                                      "jurusan": jurusanController.text,
                                    };
                                    await Api.addPerson(data);
                                    _resetFields();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Data berhasil ditambahkan!')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Terjadi kesalahan: $e')),
                                    );
                                  } finally {
                                    setState(() => _isLoading = false);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a text field
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.blueAccent),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        prefixIcon: Icon(
          hintText == "Nama" ? Icons.person :
          hintText == "NIM" ? Icons.numbers :
          Icons.school,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}