import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:move_your_body/core/theme/app_colors.dart';

class TimingSettingsCard extends StatelessWidget {
  final int preparationTime;
  final int restTime;
  final ValueChanged<int> onPreparationTimeChanged;
  final ValueChanged<int> onRestTimeChanged;

  const TimingSettingsCard({
    super.key,
    required this.preparationTime,
    required this.restTime,
    required this.onPreparationTimeChanged,
    required this.onRestTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Timing Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _TimingRow(
            label: "Preparation Time",
            seconds: preparationTime,
            onChanged: onPreparationTimeChanged,
          ),
          const SizedBox(height: 16),
          _TimingRow(
            label: "Rest Time",
            seconds: restTime,
            onChanged: onRestTimeChanged,
          ),
        ],
      ),
    );
  }
}

class _TimingRow extends StatefulWidget {
  final String label;
  final int seconds;
  final ValueChanged<int> onChanged;

  const _TimingRow({
    required this.label,
    required this.seconds,
    required this.onChanged,
  });

  @override
  State<_TimingRow> createState() => _TimingRowState();
}

class _TimingRowState extends State<_TimingRow> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.seconds.toString());
  }

  @override
  void didUpdateWidget(covariant _TimingRow oldWidget) {
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

  void _increment() => widget.onChanged(widget.seconds + 5);

  void _decrement() {
    if (widget.seconds > 0) {
      widget.onChanged((widget.seconds - 5).clamp(0, 9999));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        _StepperBtn(icon: Icons.remove, onTap: _decrement),
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
              if (parsed != null && parsed >= 0) {
                widget.onChanged(parsed);
              } else {
                _controller.text = widget.seconds.toString();
              }
            },
            onTapOutside: (_) {
              final parsed = int.tryParse(_controller.text);
              if (parsed != null && parsed >= 0) {
                widget.onChanged(parsed);
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
        _StepperBtn(icon: Icons.add, onTap: _increment),
      ],
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperBtn({required this.icon, required this.onTap});

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
