import 'package:flutter/material.dart';

class ConversionApp extends StatefulWidget {
  @override
  _ConversionApp createState() => _ConversionApp();
}

class _ConversionApp extends State<ConversionApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Conversor de Divisas'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Ingrese el valor en moneda extranjera',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: 'USD',
                  onChanged: (newValue) {},
                  items: ['USD', 'EUR', 'GBP', 'JPY'].map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {},
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
                    itemCount: 5, // Número arbitrario de elementos para mostrar
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Elemento $index'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
