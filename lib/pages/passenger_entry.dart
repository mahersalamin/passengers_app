import 'package:flutter/material.dart';
import 'package:passengers/firestore.dart';


class PassengerEntry extends StatefulWidget {
  final date;
  const PassengerEntry({Key? key, this.date}) : super(key: key);

  @override
  _PassengerEntryState createState() => _PassengerEntryState();
}

class _PassengerEntryState extends State<PassengerEntry> {
  List<GlobalKey<_PassengerFormFieldState>> _passengerKeys = [GlobalKey<_PassengerFormFieldState>()];
  FireStoreService firestore = FireStoreService();
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < _passengerKeys.length; index++)
          Row(
            children: [
              Expanded(child: PassengerFormField(key: _passengerKeys[index])),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _passengerKeys.removeAt(index);
                  });
                },
              ),
            ],
          ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _passengerKeys.add(GlobalKey<_PassengerFormFieldState>());
                });
              },
              child: const Text('إضافة راكب'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('ذهاب'),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('عودة'),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                        print("Button value: $value");
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                List<Map<String, String>> passengerData = [];
                for (var key in _passengerKeys) {
                  passengerData.add(key.currentState!.getPassengerData());
                }


                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('تم الحفظ'),
                ));
                firestore.addPassengers(widget.date,selectedOption,passengerData);

              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ],
    );
  }
}

class PassengerFormField extends StatefulWidget {
  const PassengerFormField({Key? key}) : super(key: key);

  @override
  _PassengerFormFieldState createState() => _PassengerFormFieldState();
}

class _PassengerFormFieldState extends State<PassengerFormField> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController infoController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    infoController.dispose();
    super.dispose();
  }

  Map<String, String> getPassengerData() {
    return {
      'name': nameController.text,
      'info': infoController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'الإسم'),
        ),
        TextFormField(
          controller: infoController,
          decoration: const InputDecoration(labelText: 'المعلومات'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}


