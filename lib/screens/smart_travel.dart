import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/input_fields.dart';
import '../components/date_fields.dart';

class SmartTravel extends StatefulWidget {
  const SmartTravel({super.key});

  @override
  State<SmartTravel> createState() => _SmartTravelState();
}

class _SmartTravelState extends State<SmartTravel> {
  List<String> _selectedCategories = [];

  void _showCategoryDialog() {
    final List<String> options = ["Accommodation", "Transportation", "Tour"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Categories"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    options.map((option) {
                      return CheckboxListTile(
                        value: _selectedCategories.contains(option),
                        title: Text(option),
                        onChanged: (bool? checked) {
                          setStateDialog(() {
                            if (checked == true) {
                              _selectedCategories.add(option);
                            } else {
                              _selectedCategories.remove(option);
                            }
                          });
                        },
                      );
                    }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // ریفرش صفحه اصلی
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 212, 146, 246),
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.35,
                width: screenWidth,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: Image.asset(
                        "images/pic4.jpg",
                        //height: screenHeight * 0.4,
                        //width: double.infinity,
                      ),
                    ),
                    Positioned(
                      child: Text(
                        "Plan your Trip",
                        style: GoogleFonts.dancingScript(
                          fontSize: 38,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.025,
                ),
                margin: EdgeInsets.only(
                  left: screenWidth * 0.03,
                  right: screenWidth * 0.03,
                ),
                height: screenHeight * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color.fromARGB(157, 99, 89, 169),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: screenWidth * 0.03,
                      children: [
                        Expanded(
                          child: InputFields(
                            hint_text: "Maximum Budget",
                            borderRadius: BorderRadius.circular(15),
                            hintCoolor: Colors.white,
                            fontSize: 14,
                            googleFont: GoogleFonts.davidLibre,
                            fillColor: Colors.transparent,
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _showCategoryDialog,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.transparent,
                              ),
                              child: Text(
                                _selectedCategories.isEmpty
                                    ? "Category"
                                    : _selectedCategories.join(", "),
                                style: GoogleFonts.davidLibre(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: screenWidth * 0.03,
                      children: [
                        DateFields(hint_text: "Arrival Date"),
                        DateFields(hint_text: "Departure Date"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
