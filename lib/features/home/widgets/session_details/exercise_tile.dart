import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class ExerciseTile extends StatelessWidget {
  final String title;
  final int durationSeconds;
  final ValueChanged<int>? onDurationChanged;
  final VoidCallback? onInfoTap;

  const ExerciseTile({
    super.key,
    required this.title,
    required this.durationSeconds,
    this.onDurationChanged,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _DurationInput(
                  seconds: durationSeconds,
                  onChanged: onDurationChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onInfoTap,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationInput extends StatefulWidget {
  final int seconds;
  final ValueChanged<int>? onChanged;

  const _DurationInput({required this.seconds, this.onChanged});

  @override
  State<_DurationInput> createState() => _DurationInputState();
}

class _DurationInputState extends State<_DurationInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.seconds.toString());
  }

  @override
  void didUpdateWidget(covariant _DurationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seconds != widget.seconds) {
      final currentText = _controller.text;
      if (currentText != widget.seconds.toString()) {
        _controller.text = widget.seconds.toString();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    widget.onChanged?.call(widget.seconds + 5);
  }

  void _decrement() {
    if (widget.seconds > 5) {
      widget.onChanged?.call(widget.seconds - 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(
          icon: Icons.remove,
          onTap: _decrement,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 48,
          height: 32,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 6,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0) {
                widget.onChanged?.call(parsed);
              } else {
                _controller.text = widget.seconds.toString();
              }
            },
            onTapOutside: (_) {
              final parsed = int.tryParse(_controller.text);
              if (parsed != null && parsed > 0) {
                widget.onChanged?.call(parsed);
              } else {
                _controller.text = widget.seconds.toString();
              }
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "sec",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        _StepperButton(
          icon: Icons.add,
          onTap: _increment,
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 16),
      ),
    );
  }
}
