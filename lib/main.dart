import 'package:flutter/material.dart';

import 'encrypted_json_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Módulo 1 - Cifrado JSON',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const JsonTestScreen(),
    );
  }
}

class JsonTestScreen extends StatefulWidget {
  const JsonTestScreen({super.key});

  @override
  State<JsonTestScreen> createState() => _JsonTestScreenState();
}

class _JsonTestScreenState extends State<JsonTestScreen> {
  final EncryptedJsonStorage _storage = EncryptedJsonStorage();
  String _consola = "Esperando ejecución...";

  void _escribirArchivo() async {
    // Simulación del payload de configuración
    final Map<String, dynamic> payload = {
      "nodo_id": "ESP32_01",
      "tipo_sensor": "temperatura",
      "intervalo_segundos": 10,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await _storage.saveEncryptedJson('config_iot.json', payload);

    setState(() {
      _consola = "Escritura completada.\nArchivo cifrado con AES-256 guardado exitosamente.";
    });
  }

  void _leerArchivo() async {
    final datos = await _storage.readEncryptedJson('config_iot.json');

    setState(() {
      if (datos != null) {
        _consola =
            "Descifrado exitoso:\n\n"
            "Nodo ID: ${datos['nodo_id']}\n"
            "Sensor: ${datos['tipo_sensor']}\n"
            "Intervalo: ${datos['intervalo_segundos']}s\n"
            "Hora: ${datos['timestamp']}";
      } else {
        _consola = "Error: El archivo no existe o está corrupto.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Persistencia Segura - Módulo 1')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.lock),
              label: const Text('Generar JSON Cifrado'),
              onPressed: _escribirArchivo,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_open),
              label: const Text('Leer JSON Descifrado'),
              onPressed: _leerArchivo,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _consola,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
