import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raggalo/models/reserved_feedstuff.dart';
import 'package:raggalo/services/firebase.dart';

class FarmerReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.firestore
            .collection("reserved_feedstuffs")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Text("No reports found!"),
            );
          }
          var items = snapshot.data.docs
              .map((item) => ReservedFeedstuff.fromJson(item.data()))
              .toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.network(
                  items[index].image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(items[index].name),
                subtitle: Text("${items[index].quantity.toString()} Kgs"),
                trailing: Text(DateFormat("m/d/y")
                    .format(DateTime.parse(items[index].createAt))),
                onTap: () {},
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Create a new PDF document.
      //     final PdfDocument document = PdfDocument();
      //     // Add a PDF page and draw text.
      //     document.pages.add().graphics.drawString(
      //         'Welcome!', PdfStandardFont(PdfFontFamily.helvetica, 12),
      //         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      //         bounds: const Rect.fromLTWH(0, 0, 150, 20));
      //     // Save the document.
      //     File('raggalo.pdf').writeAsBytes(document.save());
      //     // Dispose the document.
      //     document.dispose();
      //   },
      //   child: Icon(Icons.picture_as_pdf),
      // ),
    );
  }
}
