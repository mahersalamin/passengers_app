import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../firestore.dart';
import 'trip_page.dart';

class HomePage extends StatelessWidget {
  FireStoreService firestore = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('مدير تسجيل الركاب'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestore.getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List passengers = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: passengers.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = passengers[index];
                    String docId = document.id;
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    var dateText = data['date'].toDate();
                    String formattedDate =
                        intl.DateFormat('yyyy-MM-dd').format(dateText);
                    print(docId);
                    print(data);
                    return ExpansionTile(
                      trailing: IconButton(
                          onPressed: () => firestore.delete(docId),
                          icon: const Icon(Icons.delete)),
                      collapsedBackgroundColor:
                          index % 2 == 0 ? Colors.black12 : Colors.white60,
                      title: Text(formattedDate.toString()),
                      leading: data['option'] == 0
                          ? const Text('ذهاب')
                          : const Text('عودة'),
                      children: List.generate(data['data'].length, (index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(data['data'][index]['name']),
                            Text(data['data'][index]['info']),
                          ],
                        );
                      }),
                    );
                  });
            } else {
              return const Text('لا توجد بيانات');
            }
          },
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TripScreen()),
            );
          },
          child: const Text('تسجيل'),
        ),
      ),
    );
  }
}
