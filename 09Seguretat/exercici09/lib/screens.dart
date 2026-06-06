import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import 'crypto_service.dart';
import 'app_theme.dart';
import 'subwidgets/file_picker_widget.dart';
import 'subwidgets/status_banner.dart';
import 'subwidgets/action_button.dart';

// --------------- //
// Vista Encriptar //
// --------------- //

class EncryptView extends StatefulWidget {
  const EncryptView({super.key});

  @override
  State<EncryptView> createState() => _EncryptViewState();
}

class _EncryptViewState extends State<EncryptView> {
  String? _publicKeyPath;
  String? _inputFilePath;
  Status  _status = Status.idle;
  String? _statusMsg;
  String? _outputPath;

  bool get _canEncrypt => _publicKeyPath != null && _inputFilePath != null;

  Future<void> _encrypt() async {
    if (!_canEncrypt) return;

    setState(() {
      _status    = Status.working;
      _statusMsg = 'Encriptant…';
      _outputPath = null;
    });

    try {
      // Validar que existeixen els arxius seleccionats
      if (!File(_publicKeyPath!).existsSync()) {
        throw Exception('Public key file not found.');
      }
      if (!File(_inputFilePath!).existsSync()) {
        throw Exception('Input file not found.');
      }

      final pubKey = CryptoService.loadPublicKey(_publicKeyPath!);

      // Output path: mateix directori que l'input, amb suffix .enc
      final dir     = p.dirname(_inputFilePath!);
      final base    = p.basename(_inputFilePath!);
      final outPath = p.join(dir, '$base.enc');

      await CryptoService.encryptFile(
        inputPath:  _inputFilePath!,
        outputPath: outPath,
        publicKey:  pubKey,
      );

      setState(() {
        _status     = Status.success;
        _statusMsg  = 'Arxiu encriptat amb èxit.';
        _outputPath = outPath;
      });
    } catch (e) {
      setState(() {
        _status    = Status.error;
        _statusMsg = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ENCRIPTAR', style: AppTheme.heading),
          const SizedBox(height: 20),

          // Clau pública
          FilePickerWidget(
            label: 'Clau pública  (RSA - PEM - PKCS#1/PKCS#8)',
            hint:  'Selecciona una clau…',
            encrypt: true,
            selectedPath: _publicKeyPath,
            allowedExtensions: ['pub', 'pem', 'key'],
            onPicked: (v) => setState(() {
              _publicKeyPath = v;
              _status = Status.idle;
            }),
          ),
          const SizedBox(height: 20),

          // Arxiu d'entrada
          FilePickerWidget(
            label: 'Arxiu per encriptar',
            hint:  'Selecciona un arxiu…',
            encrypt: true,
            selectedPath: _inputFilePath,
            allowAny: true,
            onPicked: (v) => setState(() {
              _inputFilePath = v;
              _status = Status.idle;
            }),
          ),
          const SizedBox(height: 8),

          // Previsualització de sortida
          if (_inputFilePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Destí: ${p.basename(_inputFilePath!)}.enc',
                style: AppTheme.caption,
              ),
            ),

          const SizedBox(height: 24),

          // Acció
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              label: 'ENCRIPTAR',
              enabled: _canEncrypt && _status != Status.working,
              onPressed: _encrypt,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Estat
          StatusBanner(
            status: _status,
            message: _statusMsg,
            outputPath: _outputPath,
          ),
        ],
      ),
    );
  }
}

// ------------------ //
// Vista Desencriptar //
// ------------------ //

class DecryptView extends StatefulWidget {
  const DecryptView({super.key});

  @override
  State<DecryptView> createState() => _DecryptViewState();
}

class _DecryptViewState extends State<DecryptView> {
  String? _privateKeyPath;
  String? _encryptedFilePath;
  String? _outputFilePath;
  Status  _status = Status.idle;
  String? _statusMsg;

  bool get _canDecrypt =>
      _privateKeyPath != null &&
      _encryptedFilePath != null &&
      _outputFilePath != null;

  Future<void> _decrypt() async {
    if (!_canDecrypt) return;

    setState(() {
      _status    = Status.working;
      _statusMsg = 'Desencriptant…';
    });

    try {
      if (!File(_privateKeyPath!).existsSync()) {
        throw Exception('Clau privada no trobada.');
      }
      if (!File(_encryptedFilePath!).existsSync()) {
        throw Exception('Arxiu encriptat no trobat.');
      }

      final privKey = CryptoService.loadPrivateKey(_privateKeyPath!);

      await CryptoService.decryptFile(
        inputPath:  _encryptedFilePath!,
        outputPath: _outputFilePath!,
        privateKey: privKey,
      );

      setState(() {
        _status    = Status.success;
        _statusMsg = 'Arxiu desencriptat amb èxit.';
      });
    } catch (e) {
      setState(() {
        _status    = Status.error;
        _statusMsg = e.toString();
      });
    }
  }

  // Suggerir un output path basat en l'arxiu encriptat seleccionat
  void _suggestOutputPath(String encPath) {
    var suggested = encPath;
    if (suggested.endsWith('.enc')) {
      suggested = suggested.substring(0, suggested.length - 4);
    } else {
      suggested = '$suggested.dec';
    }
    setState(() => _outputFilePath = suggested);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DESENCRIPTAR', style: AppTheme.heading),
          const SizedBox(height: 20),

          // Clau privada
          FilePickerWidget(
            label: 'Clau privada  (RSA - PEM - PKCS#1/PKCS#8)',
            hint:  'Selecciona una clau…',
            encrypt: false,
            selectedPath: _privateKeyPath,
            allowedExtensions: ['pem', 'key'],
            allowAny: true, // id_rsa has no extension
            onPicked: (v) => setState(() {
              _privateKeyPath = v;
              _status = Status.idle;
            }),
          ),
          const SizedBox(height: 20),

          // Arxiu encriptat
          FilePickerWidget(
            label: 'Arxiu encriptat  (.enc)',
            hint:  'Selecciona un arxiu…',
            encrypt: false,
            selectedPath: _encryptedFilePath,
            allowedExtensions: ['enc'],
            allowAny: true,
            onPicked: (v) {
              setState(() {
                _encryptedFilePath = v;
                _status = Status.idle;
              });
              _suggestOutputPath(v);
            },
          ),
          const SizedBox(height: 20),

          // Arxiu destí
          FilePickerWidget(
            label: 'Arxiu destí',
            hint:  'Selecciona un destí…',
            encrypt: false,
            selectedPath: _outputFilePath,
            allowAny: true,
            forSave: true,
            defaultPath: _encryptedFilePath != null ? p.dirname(_encryptedFilePath!) : null,
            saveDefaultName: _encryptedFilePath != null
                ? p.basename(_encryptedFilePath!.endsWith('.enc')
                    ? _encryptedFilePath!.substring(
                        0, _encryptedFilePath!.length - 4)
                    : '${_encryptedFilePath!}.dec')
                : 'arxiu_desencriptat',
            onPicked: (v) => setState(() {
              _outputFilePath = v;
              _status = Status.idle;
            }),
          ),
          const SizedBox(height: 24),

          // Acció
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              label: 'DESENCRIPTAR',
              enabled: _canDecrypt && _status != Status.working,
              onPressed: _decrypt,
              color: AppTheme.secondary,
            ),
          ),
          const SizedBox(height: 16),

          // Estat
          StatusBanner(
            status: _status,
            message: _statusMsg,
            outputPath: _status == Status.success ? _outputFilePath : null,
          ),
        ],
      ),
    );
  }
}