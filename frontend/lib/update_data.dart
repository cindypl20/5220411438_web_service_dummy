import 'package:flutter/material.dart';
import 'package:frontend/services/Api.dart';
import 'package:frontend/edit_data.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen> {
  List<dynamic> personData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPersonData();
  }

 final Api api = Api(); // Membuat instance Api

  void deletePerson(String id) async {
    try {
      await api.deletePerson(id); // Panggil deletePerson melalui instance
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
      fetchPersonData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  Future<void> fetchPersonData() async {
    try {
      var data = await Api.getPerson();
      setState(() {
        personData = data['persons'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Person Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchPersonData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchPersonData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : personData.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No person data available."),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: personData.length,
                    itemBuilder: (context, index) {
                      final person = personData[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              "Nama: ${person['nama'] ?? 'N/A'}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("NIM: ${person['nim'] ?? 'N/A'}"),
                                Text("Jurusan: ${person['jurusan'] ?? 'N/A'}"),
                              ],
                            ),
                            leading: CircleAvatar(
                              child: const Icon(Icons.person),
                              backgroundColor: Colors.blue[100],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => EditDataScreen(
                                          initialName: person['nama'],
                                          initialNIM: person['nim'],
                                          initialJurusan: person['jurusan'],
                                          id: person['id'],
                                          onUpdate: fetchPersonData,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Konfirmasi'),
                                        content: const Text('Yakin ingin menghapus data ini?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              deletePerson(person['id']);
                                            },
                                            child: const Text('Hapus'),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
