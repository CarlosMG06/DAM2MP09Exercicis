import 'package:flutter/material.dart';
import '../app_theme.dart';

enum Status { idle, working, success, error }

class StatusBanner extends StatelessWidget {
  final Status status;
  final String? message;
  final String? outputPath;

  const StatusBanner({
    super.key,
    required this.status,
    this.message,
    this.outputPath,
  });

  @override
  Widget build(BuildContext context) {
    if (status == Status.idle) return const SizedBox.shrink();

    final (bg, color) = switch (status) {
      Status.working => (AppTheme.surface, AppTheme.text),
      Status.success => (AppTheme.surface, AppTheme.success),
      Status.error   => (AppTheme.surface, AppTheme.error),
      Status.idle    => (AppTheme.surface, AppTheme.textSub),
    };

    final icon = switch (status) {
      Status.working => Icons.hourglass_top_rounded,
      Status.success => Icons.check_circle_rounded,
      Status.error   => Icons.error_rounded,
      Status.idle    => Icons.info_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      color: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              status == Status.working
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    )
                  : Icon(icon, size: 16, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: status == Status.error
                    ? SelectableText(
                        message ?? '',
                        style: AppTheme.body.copyWith(color: color),
                      )
                    : Text(
                        message ?? '',
                        style: AppTheme.body.copyWith(color: color),
                      ),
              ),
            ],
          ),
          if (outputPath != null && status == Status.success) ...[
            const SizedBox(height: 8),
            SelectableText('Output: $outputPath', style: AppTheme.caption),
          ],
        ],
      ),
    );
  }
}