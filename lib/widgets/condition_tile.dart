import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Condition capsule tile widget matching Figma's "Set your conditions" rows.
class ConditionTile extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback onTap;

  const ConditionTile({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: AppColors.cardBorder, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.0),
            canRequestFocus: false,
            focusColor: Colors.transparent,
            hoverColor: Colors.black.withValues(alpha: 0.03),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Label
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),

                  // Range Badge with arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFE2E6),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          valueText,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          '>',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper to show a stylized BottomSheet dialog for updating condition ranges.
void showConditionEditorSheet({
  required BuildContext context,
  required String title,
  required String unit,
  required double currentMin,
  required double currentMax,
  required double absoluteMin,
  required double absoluteMax,
  required void Function(double newMin, double newMax) onSaved,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _ConditionEditorDialog(
        title: title,
        unit: unit,
        currentMin: currentMin,
        currentMax: currentMax,
        absoluteMin: absoluteMin,
        absoluteMax: absoluteMax,
        onSaved: onSaved,
      );
    },
  );
}

class _ConditionEditorDialog extends StatefulWidget {
  final String title;
  final String unit;
  final double currentMin;
  final double currentMax;
  final double absoluteMin;
  final double absoluteMax;
  final void Function(double newMin, double newMax) onSaved;

  const _ConditionEditorDialog({
    required this.title,
    required this.unit,
    required this.currentMin,
    required this.currentMax,
    required this.absoluteMin,
    required this.absoluteMax,
    required this.onSaved,
  });

  @override
  State<_ConditionEditorDialog> createState() => _ConditionEditorDialogState();
}

class _ConditionEditorDialogState extends State<_ConditionEditorDialog> {
  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = RangeValues(widget.currentMin, widget.currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'Adjust ${widget.title}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Target range will be maintained automatically by actuators.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Range indicator chip
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${_values.start.round()} - ${_values.end.round()} ${widget.unit}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navActiveGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Slider
          RangeSlider(
            values: _values,
            min: widget.absoluteMin,
            max: widget.absoluteMax,
            divisions: (widget.absoluteMax - widget.absoluteMin).toInt(),
            activeColor: AppColors.navActiveGreen,
            inactiveColor: Colors.grey.shade200,
            labels: RangeLabels(
              '${_values.start.round()} ${widget.unit}',
              '${_values.end.round()} ${widget.unit}',
            ),
            onChanged: (values) {
              setState(() {
                _values = values;
              });
            },
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navActiveGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                widget.onSaved(_values.start, _values.end);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save Target Condition',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
