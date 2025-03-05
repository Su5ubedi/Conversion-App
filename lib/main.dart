import 'package:flutter/material.dart';

void main() {
  runApp(const ConversionApp());
}

class ConversionApp extends StatelessWidget {
  const ConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _valueController = TextEditingController();
  String _fromUnit = 'meters';
  String _toUnit = 'feet';
  double _result = 0.0;

  final Map<String, Map<String, double>> conversionRates = {
    'meters': {'feet': 3.28084, 'kilometers': 0.001, 'miles': 0.000621371},
    'feet': {'meters': 0.3048, 'miles': 0.000189394},
    'kilometers': {'miles': 0.621371, 'meters': 1000},
    'miles': {'kilometers': 1.60934, 'meters': 1609.34},
    'centimeters': {'inches': 0.393701},
    'inches': {'centimeters': 2.54},
    'kilograms': {'pounds': 2.20462},
    'pounds': {'kilograms': 0.453592},
    'grams': {'ounces': 0.035274},
    'ounces': {'grams': 28.3495},
    'celsius': {'fahrenheit': 9 / 5, 'kelvin': 1},
    'fahrenheit': {'celsius': 5 / 9},
    'kelvin': {'celsius': -273.15},
  };

  void _convert() {
    double inputValue = double.tryParse(_valueController.text) ?? 0.0;

    if (_fromUnit == 'celsius' && _toUnit == 'fahrenheit') {
      _result = (inputValue * 9 / 5) + 32;
    } else if (_fromUnit == 'fahrenheit' && _toUnit == 'celsius') {
      _result = (inputValue - 32) * 5 / 9;
    } else if (_fromUnit == 'celsius' && _toUnit == 'kelvin') {
      _result = inputValue + 273.15;
    } else if (_fromUnit == 'kelvin' && _toUnit == 'celsius') {
      _result = inputValue - 273.15;
    } else {
      _result = inputValue * (conversionRates[_fromUnit]?[_toUnit] ?? 1);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Measures Converter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown('From', _fromUnit, (String? newValue) {
                  setState(() {
                    _fromUnit = newValue!;
                  });
                }),
                _buildDropdown('To', _toUnit, (String? newValue) {
                  setState(() {
                    _toUnit = newValue!;
                  });
                }),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convert,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Convert',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _result == 0.0
                  ? ''
                  : '${_valueController.text} $_fromUnit are ${_result.toStringAsFixed(3)} $_toUnit',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            items: conversionRates.keys.map<DropdownMenuItem<String>>((String unit) {
              return DropdownMenuItem<String>(
                value: unit,
                child: Text(unit),
              );
            }).toList(),
            underline: Container(),
          ),
        ),
      ],
    );
  }
}
