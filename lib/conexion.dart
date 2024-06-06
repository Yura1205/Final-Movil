import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class ConversionApp extends StatefulWidget {
  @override
  _ConversionAppState createState() => _ConversionAppState();
}

class _ConversionAppState extends State<ConversionApp> {
  final TextEditingController pesosController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedCurrency = 'USD';
  Map<String, double> exchangeRates = {};
  List<String> conversionHistory = [];

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    final String apiKey = 'eaafd4e8683df38b630200d1';
    final String apiUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/COP';

    final response = await http.get(Uri.parse(apiUrl), headers: {
      'consumer': 'Yurayny Torres Y David Sanchez',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final Map<String, dynamic> conversionRatesJson = data['conversion_rates'];
      final Map<String, double> convertedRates = {};
      conversionRatesJson.forEach((key, value) {
        convertedRates[key] = value.toDouble();
      });
      setState(() {
        exchangeRates = convertedRates;
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }

  double convertCurrency(double amount) {
    double rate = exchangeRates[selectedCurrency]!;
    double convertedAmount = amount / rate;
    convertedAmount = double.parse(convertedAmount.toStringAsFixed(2));
    String conversionResult = '$amount $selectedCurrency = $convertedAmount COP';
    setState(() {
      if (conversionHistory.length >= 5) {
        conversionHistory.removeAt(0);
      }
      conversionHistory.add(conversionResult);
    });
    return convertedAmount;
  }

  void clearHistory() {
    setState(() {
      conversionHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Divisas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: pesosController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Ingrese el valor en moneda extranjera'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un valor';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                onChanged: (newValue) {
                  setState(() {
                    selectedCurrency = newValue!;
                  });
                },
                items: exchangeRates.keys.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double amount = double.parse(pesosController.text);
                    convertCurrency(amount);
                  }
                },
                child: Text('Convertir a COP'),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Historial de Conversiones:',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: conversionHistory.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(conversionHistory[index]),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: clearHistory,
                child: Text('Eliminar Historial'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
