import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tambah.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _get = [];

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "http://localhost/mobile/laundry/backend/list.php"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future delete(String id_pemasukan) async {
    try {
      final response = await http.post(
          Uri.parse("http://localhost/mobile/laundry/backend/hapus.php"),
          body: {"id_pemasukan": id_pemasukan});
      // if response successful
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
    }
  }

  SingleChildScrollView _tabelBarang() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Tanggal')),
            DataColumn(label: Text('Nama Customer')),
            DataColumn(label: Text('Jenis Laundry')),
            DataColumn(label: Text('Jumlah')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Action')),
          ],
          rows: _get.map((item) {
            return DataRow(cells: <DataCell>[
              DataCell(Text(item['tanggal'])),
              DataCell(Text(item['nm_customer'])),
              DataCell(Text(item['mcm_laundry'])),
              DataCell(Text(item['jumlah'])),
              DataCell(Text("Rp. " + item['total'])),
              DataCell(Wrap(
                children: <Widget>[
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content: Text("Yakin Ingin Menghapus Data ?"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        delete(item['id_pemasukan'])
                                            .then((value) {
                                          if (value) {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  'Data Berhasil di Hapus'),
                                            );
                                          } else {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  'Data Gagal di Hapus'),
                                            );
                                          }
                                        });
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    HomePage())),
                                            (route) => false);
                                      },
                                      child: Text("Delete")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Batal "))
                                ],
                              );
                            }));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.blueGrey,
                      )),
                ],
              )),
            ]);
          }).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'List Pemasukan',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 110, 187, 141),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                //routing into add page
                MaterialPageRoute(builder: (context) => TambahPage()));
          },
        ),
        body: Container(
          // width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(40),
          child: ListView(
            children: <Widget>[
              Text(
                'Data Pemasukan',
                // textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              _tabelBarang(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
