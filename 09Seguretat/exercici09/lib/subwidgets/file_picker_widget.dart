import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../app_theme.dart';

class FilePickerWidget extends StatelessWidget {
  final String label;
  final String hint;
  final bool encrypt; // determina color del botó
  final String? selectedPath;
  final List<String>? allowedExtensions; // ex: ['pem','pub']
  final bool allowAny;
  final bool forSave;
  final String? defaultPath;
  final String? saveDefaultName;
  final ValueChanged<String> onPicked;

  const FilePickerWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.encrypt,
    required this.onPicked,
    this.selectedPath,
    this.allowedExtensions,
    this.allowAny = false,
    this.forSave = false,
    this.defaultPath,
    this.saveDefaultName,
  });

  Future<void> _pick(BuildContext ctx) async {
    try {
      if (forSave) {
        final result = await FilePicker.saveFile(
          dialogTitle: hint,
          fileName: saveDefaultName,
          type: allowedExtensions != null ? FileType.custom : FileType.any,
          allowedExtensions: allowedExtensions,
        );
        if (result != null) onPicked(result);
      } else {
        final type = allowAny
            ? FileType.any
            : (allowedExtensions != null ? FileType.custom : FileType.any);
        final result = await FilePicker.pickFiles(
          dialogTitle: hint,
          type: type,
          allowedExtensions: type == FileType.custom ? allowedExtensions : null,
          initialDirectory: defaultPath,
        );
        if (result != null && result.files.single.path != null) {
          onPicked(result.files.single.path!);
        }
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('No es pot obrir el selector d\'arxius: $e',
                style: AppTheme.body),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.label),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),        
                child: Text(
                  selectedPath ?? hint,
                  style: AppTheme.body.copyWith(
                    color: selectedPath != null ? AppTheme.text : AppTheme.textSub,
                    backgroundColor:AppTheme.surface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _pick(context),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(encrypt ? AppTheme.primary : AppTheme.secondary),
              ),
              child: const Text('Navega…'),
            ),
          ],
        ),
      ],
    );
  }
}