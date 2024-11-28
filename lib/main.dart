import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _selectedImageBytes; // Armazena os bytes da imagem
  String _statusMessage = ''; // Armazena o status da ação

  // Função para selecionar a imagem
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result == null) {
        setState(() {
          _statusMessage = 'Nenhuma imagem selecionada.';
        });
        return;
      }

      // Obtemos os bytes do arquivo selecionado
      final imageBytes = result.files.single.bytes;

      if (imageBytes == null) {
        setState(() {
          _statusMessage = 'Erro ao ler o conteúdo da imagem.';
        });
        return;
      }

      setState(() {
        _selectedImageBytes = imageBytes; // Armazena os bytes da imagem
        _statusMessage = 'Imagem selecionada com sucesso!';
      });
    } catch (e) {
      print("Erro ao selecionar a imagem: $e");
      setState(() {
        _statusMessage = 'Erro ao selecionar a imagem.';
      });
    }
  }

  // Função para enviar a imagem (simulação)
  void _sendImage() {
    if (_selectedImageBytes != null) {
      setState(() {
        _statusMessage = 'Imagem enviada com sucesso!';
      });
    } else {
      setState(() {
        _statusMessage = 'Por favor, selecione uma imagem primeiro.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Verifica se a imagem foi selecionada para exibir
            if (_selectedImageBytes != null)
              Image.memory(
                _selectedImageBytes!, // Exibe a imagem a partir dos bytes
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            // Botão para selecionar a imagem
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Selecionar Imagem'),
            ),
            const SizedBox(height: 20),
            // Botão para enviar a imagem
            ElevatedButton(
              onPressed: _sendImage,
              child: const Text('Enviar Imagem'),
            ),
            const SizedBox(height: 20),
            // Exibe a mensagem de status (seleção ou envio)
            Text(
              _statusMessage,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
