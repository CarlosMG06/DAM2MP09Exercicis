import 'dart:io';
import 'package:basic_utils/basic_utils.dart';

/// Criptografia amb RSA
/// Simple, no recomanat per a ús real
class CryptoService {
  /// Carrega una clau pública RSA (PKCS#1/PKCS#8) des d'un arxiu PEM.
  static RSAPublicKey loadPublicKey(String pemPath) {
    final content = File(pemPath).readAsStringSync().trim();
    // Detecta format OpenSSH
    if (content.startsWith('ssh-rsa')) {
      throw UnsupportedError(
        'Format OpenSSH detectat. Fes servir claus PEM. Genera-les així:\n'
        'openssl genrsa -out private_key.pem 2048\n'
        'openssl rsa -in private_key.pem -pubout -out public_key.pem',
      );
    }
    return CryptoUtils.rsaPublicKeyFromPem(content);
  }

  /// Carrega una clau privada RSA (PKCS#1/PKCS#8) des d'un arxiu PEM.
  static RSAPrivateKey loadPrivateKey(String pemPath) {
    final pem = File(pemPath).readAsStringSync();
    // Detecta format OpenSSH
    if (pem.contains('BEGIN OPENSSH PRIVATE KEY')) {
      throw UnsupportedError(
        'Format OpenSSH detectat. Fes servir claus PEM. Genera-les així:\n'
        'openssl genrsa -out private_key.pem 2048\n'
        'openssl rsa -in private_key.pem -pubout -out public_key.pem',
      );
    }
    return CryptoUtils.rsaPrivateKeyFromPem(pem);
  }

  /// Encripta [inputPath] amb [publicKey] i escriu el resultat a [outputPath].
  static Future<String> encryptFile({
    required String inputPath,
    required String outputPath,
    required RSAPublicKey publicKey,
  }) async {
    final plaintext = await File(inputPath).readAsString();
    final encrypted = CryptoUtils.rsaEncrypt(plaintext, publicKey);
    await File(outputPath).writeAsString(encrypted);
    return outputPath;
  }

  /// Desencripta [inputPath] amb [privateKey] i escriu el text clar a [outputPath].
  static Future<String> decryptFile({
    required String inputPath,
    required String outputPath,
    required RSAPrivateKey privateKey,
  }) async {
    final plaintext = await File(inputPath).readAsString();
    final decrypted = CryptoUtils.rsaDecrypt(plaintext, privateKey);
    await File(outputPath).writeAsString(decrypted);
    return outputPath;
  }
}