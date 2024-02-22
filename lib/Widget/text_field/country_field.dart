import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountryField extends StatelessWidget {
  final String? label;
  final String hint;
  final String? selectedCountry;
  final ValueChanged<Country?> onCountryChanged;

  CountryField({
    this.label,
    required this.hint,
    this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    String displayCountry = selectedCountry ?? 'Pakistan';

    // Extract and display only the country name
    if (displayCountry.contains('(')) {
      displayCountry = displayCountry.split('(')[0].trim();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Color(0xFFC2C2C2),
            width: 1,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            _openCountryPicker(context);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: label,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(displayCountry),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      exclude: ['EN', 'PL', 'ES'],
      showPhoneCode: false,
      onSelect: onCountryChanged,
    );
  }
}
