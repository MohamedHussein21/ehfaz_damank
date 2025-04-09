
import 'package:flutter/material.dart';

class CountryCodeScreen extends StatelessWidget {
  final Function(String) onSelect;
  CountryCodeScreen({super.key, required this.onSelect});

  final List<String> countryCodes = ["+20", "+1", "+44", "+971"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختر كود الدولة")),
      body: ListView.builder(
        itemCount: countryCodes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(countryCodes[index]),
            onTap: () {
              onSelect(countryCodes[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
