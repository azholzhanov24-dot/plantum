import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: context.dividerLineColor, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.circular(24.0),
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
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimaryColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),

                  // Range Badge with arrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
                    decoration: BoxDecoration(
                      color: context.subtleSurfaceColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          valueText,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: context.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '>',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: context.textSecondaryColor,
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
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
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
                color: context.textSecondaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            context.strings.adjustCondition(widget.title),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.strings.conditionHelper,
            style: TextStyle(
              fontSize: 13,
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),

          // Range indicator chip
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: context.subtleSurfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: context.dividerLineColor),
              ),
              child: Text(
                '${_values.start.round()} - ${_values.end.round()} ${widget.unit}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.brandGreenColor,
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
            activeColor: context.brandGreenColor,
            inactiveColor: context.subtleSurfaceColor,
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
                backgroundColor: context.brandGreenColor,
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
              child: Text(
                context.strings.saveTargetCondition,
                style: const TextStyle(
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
