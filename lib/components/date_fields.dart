import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class DateFields extends StatefulWidget {
  const DateFields({
    super.key,
    required this.hint_text,
    this.onDateSelected,
    this.onCleared,
  });

  final String hint_text;
  final ValueChanged<DateTime>? onDateSelected;
  final VoidCallback? onCleared;

  @override
  State<DateFields> createState() => _DateFieldsState();
}

class _DateFieldsState extends State<DateFields> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = _dateController.text.isNotEmpty;

    return TextField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hint_text,
        prefixIcon: const Icon(
          Icons.calendar_today_rounded,
          color: AppColors.primary,
        ),
        fillColor: AppColors.white,
        suffixIcon:
            hasDate
                ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.muted,
                  ),
                  onPressed: () {
                    setState(() {
                      _dateController.clear();
                    });
                    widget.onCleared?.call();
                  },
                )
                : null,
      ),
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  secondary: AppColors.secondary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate == null) return;

        setState(() {
          _dateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
        });
        widget.onDateSelected?.call(pickedDate);
      },
    );
  }
}
