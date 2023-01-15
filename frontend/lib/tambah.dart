import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  //inisialize field
  TextEditingController tanggal = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController jasa = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController total = TextEditingController();

  Future onSubmit() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/mobile/laundry/backend/tambah.php"),
        body: {
          "y-m-d": tanggal.text,
          "nm_customer": nama.text,
          "mcm_laundry": jasa.text,
          "jumlah": jumlah.text,
          "total": total.text,
        },
      ).then((value) {
        //print message after insert to database
        //you can improve this message with alert dialog
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    tanggal.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Tambah Data'),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Text(
              'Masukkan Data Laundry',
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: tanggal,
              decoration: InputDecoration(
                  labelText: "Tanggal",
                  icon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030));
                if (picked != null) {
                  String formatDate = DateFormat('dd-MM-yyyy').format(picked);
                  setState(() {
                    tanggal.text = formatDate;
                    // selectedDate = picked;
                  });
                } else {
                  print("");
                }
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: nama,
              decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Nama Customer",
                  hintText: "nama customer",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextField(
              controller: jasa,
              decoration: InputDecoration(
                  icon: Icon(Icons.breakfast_dining_outlined),
                  labelText: "Jenis Jasa",
                  hintText: "Nb: Cuci+Setrika   Cuci Kering   Setrika",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextField(
              controller: jumlah,
              decoration: InputDecoration(
                  icon: Icon(Icons.balance),
                  labelText: "Jumlah",
                  hintText: "jumlah",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            TextField(
              controller: total,
              decoration: InputDecoration(
                  icon: Icon(Icons.calculate_outlined),
                  labelText: "Total",
                  hintText: "total",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                onSubmit();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
