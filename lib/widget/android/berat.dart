import 'package:flutter/material.dart';

class Weight extends StatelessWidget {
  const Weight({Key? key, required TextEditingController weightController})
      : _weight = weightController,
        super(key: key);
  final TextEditingController _weight;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _weight,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Berat',
              suffixText: 'KG',
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
