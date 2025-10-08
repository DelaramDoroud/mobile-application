import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateFields extends StatefulWidget {
  final String hint_text;
  final ValueChanged<DateTime>? onDateSelected;
  const DateFields({super.key, required this.hint_text, this.onDateSelected});

  @override
  State<DateFields> createState() => _DateFieldsState();
}

class _DateFieldsState extends State<DateFields> {
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            controller: startDateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.hint_text,
              prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
              hintStyle: GoogleFonts.davidLibre(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  startDateController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                });
                if (widget.onDateSelected != null) {
                  widget.onDateSelected!(pickedDate);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
