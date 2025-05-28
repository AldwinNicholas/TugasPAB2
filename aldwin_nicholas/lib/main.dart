import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "default",
      appId: "default",
      messagingSenderId: "default",
      projectId: "tugaspab2",
      databaseURL: "https://console.firebase.google.com/u/1/project/tugaspab2/database/tugaspab2-default-rtdb/data/~2F?fb_gclid=CjwKCAjw6NrBBhB6EiwAvnT_roYb79s7U5TBJVY5WZEP3Xs29FuGvtlsXgT8D2p49r0HIY5n6NWEfBoCa1gQAvD_BwE", // Contoh: "https://project-id.firebaseio.com"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Mahasiswa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const InputBiodata(),
    );
  }
}

class InputBiodata extends StatefulWidget {
  const InputBiodata({super.key});

  @override
  State<InputBiodata> createState() => _InputBiodataState();
}

class _InputBiodataState extends State<InputBiodata> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _visiController = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('mahasiswa');

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _database.push().set({
          'npm': _npmController.text,
          'nama': _namaController.text,
          'visi': _visiController.text,
          'timestamp': ServerValue.timestamp,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!')),
        );
        _formKey.currentState!.reset();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biodata Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _npmController,
                decoration: const InputDecoration(labelText: 'NPM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NPM wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _visiController,
                decoration: const InputDecoration(
                  labelText: 'Visi 5 Tahun Kedepan',
                  hintText: 'Contoh: Menjadi ahli data science di perusahaan multinasional'
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Visi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _simpanData,
                child: const Text('Simpan Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}