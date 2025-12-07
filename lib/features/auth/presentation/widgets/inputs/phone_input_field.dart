import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Phone number input field with country code selector
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  static const List<Map<String, String>> countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+61', 'country': 'AU'},
    {'code': '+55', 'country': 'BR'},
    {'code': '+7', 'country': 'RU'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country code dropdown
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCountryCode,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              items: countryCodes.map((country) {
                return DropdownMenuItem(
                  value: country['code'],
                  child: Text(
                    '${country['code']} ${country['country']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onCountryCodeChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Phone number input
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter your phone number',
              prefixIcon: const Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
