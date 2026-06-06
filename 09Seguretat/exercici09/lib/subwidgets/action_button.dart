import 'package:flutter/material.dart';
import '../app_theme.dart';


class ActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const ActionButton({
    super.key, 
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ButtonStyle(
        backgroundColor: .resolveWith((states) {
          return states.contains(WidgetState.disabled) ? AppTheme.surface : AppTheme.primary;
        }),
        foregroundColor: .resolveWith((states) {
          return states.contains(WidgetState.disabled) ? AppTheme.textSub : AppTheme.bg;
        }),
        padding: .all(const EdgeInsets.symmetric(vertical: 14, horizontal: 16)),
        elevation: .all(0),
        shape: .all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
      ),
      child: Center(
        child: Text(label),
      ),
    );
  }
}