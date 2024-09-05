import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/design.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();

  String? _selectedCategory;
  String? _selectedProduct;
  List<String> _categories = [];
  List<String> _products = [];
  double _totalSales = 0.0;
  int _availableStock = 0; // Ajout de cette variable

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchTotalSales();
  }

  Future<void> _fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> categories = json.decode(response.body);
      setState(() {
        _categories = categories
            .map((category) => category['catName'].toString())
            .toList();
      });
    } else {
      print('Failed to load categories: ${response.body}');
    }
  }

  Future<void> _fetchProducts(String category) async {
    final response = await http.get(
        Uri.parse('http://localhost:5009/api/products?category=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      setState(() {
        _products = products
            .map((product) => product['productName'].toString())
            .toList();
      });
    } else {
      print('Failed to load products: ${response.body}');
    }
  }

  Future<void> _fetchProductPrice(String productName) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5009/api/sales/GetProductPrice?productName=$productName'));

    if (response.statusCode == 200) {
      setState(() {
        _unitPriceController.text = response.body;
      });
    } else {
      print('Failed to load product price: ${response.body}');
    }
  }

  Future<void> _fetchProductStock(String productName) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5009/api/sales/GetProductStock?productName=$productName'));

    if (response.statusCode == 200) {
      setState(() {
        _availableStock = int.parse(response.body);
      });
    } else {
      print('Failed to load product stock: ${response.body}');
    }
  }

  Future<void> _fetchTotalSales() async {
    final response = await http
        .get(Uri.parse('http://localhost:5009/api/sales/GetTotalSales'));

    if (response.statusCode == 200) {
      setState(() {
        _totalSales = double.parse(response.body);
      });
    } else {
      print('Failed to load total sales: ${response.body}');
    }
  }

  Future<void> _generateReceipt(Map<String, dynamic> sale) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Afrik Créances',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Reçu N°: ${sale['receiptNumber']}',
                          style: pw.TextStyle(fontSize: 14)),
                      pw.Text(
                          'Date: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
                          style: pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text('Nom du Client: ${sale['clientName']}'),
              pw.SizedBox(height: 16),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Désignation'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Quantité'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Prix unitaire'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Prix total'),
                    ),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(sale['productName']),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text(sale['quantity'].toString()),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('${sale['unitPrice']}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('${sale['total']}'),
                    ),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<Map<String, dynamic>> _getLatestSale() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/sales/latest'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load latest sale');
    }
  }

  Future<void> _addSale() async {
    if (_selectedCategory == null ||
        _selectedProduct == null ||
        _clientNameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _unitPriceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Veuillez remplir tous les champs obligatoires')),
      );
      return;
    }

    int enteredQuantity = int.parse(_quantityController.text);

    if (_availableStock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('La quantité disponible est de 0. Vente impossible.')),
      );
      return;
    }

    if (enteredQuantity > _availableStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Quantité insuffisante en stock. Vente bloquée.')),
      );
      return;
    }

    final currentDate = DateTime.now();
    double total = enteredQuantity * double.parse(_unitPriceController.text);

    final saleData = {
      'companyName': _companyNameController.text,
      'productName': _selectedProduct!,
      'catName': _selectedCategory!,
      'quantity': enteredQuantity,
      'unitPrice': double.parse(_unitPriceController.text),
      'total': total,
      'date': currentDate.toIso8601String(),
      'clientName': _clientNameController.text,
    };

    final response = await http.post(
      Uri.parse('http://localhost:5009/api/sales'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(saleData),
    );

    if (response.statusCode == 201) {
      final saleResponse = jsonDecode(response.body);
      _quantityController.clear();
      _unitPriceController.clear();
      _clientNameController.clear();
      _companyNameController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedProduct = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vente ajoutée avec succès.')),
      );

      // Generate and print the receipt
      _generateReceipt({
        ...saleData,
        'receiptNumber': saleResponse['receiptNumber'],
      });

      // Update total sales
      _fetchTotalSales();
    } else {
      print('Failed to add sale: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> _getSales() async {
    final response =
        await http.get(Uri.parse('http://localhost:5009/api/sales'));

    if (response.statusCode == 200) {
      final List<dynamic> sales = json.decode(response.body);
      return sales.cast<Map<String, dynamic>>();
    } else {
      print('Failed to load sales: ${response.body}');
      return [];
    }
  }

  Widget _buildSalesTable(List<Map<String, dynamic>> sales) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Card(
          color: Colors.white,
          elevation: 12,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Produit')),
              DataColumn(label: Text('Catégorie')),
              DataColumn(label: Text('Quantité')),
              DataColumn(label: Text('Prix Unitaire')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Client')),
              DataColumn(label: Text('Date')),
            ],
            rows: sales.map((sale) {
              double quantity = double.parse(sale['quantity'].toString());
              double unitPrice = double.parse(sale['unitPrice'].toString());
              double total = quantity * unitPrice;
              return DataRow(cells: [
                DataCell(Text(sale['productName'].toString())),
                DataCell(Text(sale['catName'].toString())),
                DataCell(Text(sale['quantity'].toString())),
                DataCell(Text(sale['unitPrice'].toString())),
                DataCell(Text(total.toStringAsFixed(2))),
                DataCell(Text(sale['clientName'].toString())),
                DataCell(Text(sale['date'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchProduct(String category) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5009/api/products/Getonly?categoryName=$category'));

    if (response.statusCode == 200) {
      final List<dynamic> products = json.decode(response.body);
      setState(() {
        _products = products
            .map((product) => product['productName'].toString())
            .toList();
      });
    } else {
      print('Failed to load products: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    if (_quantityController.text.isNotEmpty &&
        _unitPriceController.text.isNotEmpty) {
      total = int.parse(_quantityController.text) *
          double.parse(_unitPriceController.text);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ventes'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: CirclePainter(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text("Enregistrement de vente",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 30, 28, 185),
                                  fontSize: 25,
                                )),
                          ),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                                "Vous pouvez enregistrer une vente effectuée ici.",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 119, 118, 161),
                                  fontSize: 16,
                                )),
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: 500,
                        child: Card(
                          color: Colors.white,
                          elevation: 12,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCategory,
                                  hint: Text('Sélectionner une catégorie *'),
                                  items: _categories.map((String category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                      _selectedProduct = null;
                                      _products.clear();
                                      _fetchProduct(newValue!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedProduct,
                                  hint: Text('Sélectionner un produit *'),
                                  items: _products.map((String product) {
                                    return DropdownMenuItem<String>(
                                      value: product,
                                      child: Text(product),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedProduct = newValue;
                                      _fetchProductPrice(newValue!);
                                      _fetchProductStock(newValue!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Quantité *',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer la quantité';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _unitPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Prix Unitaire *',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _clientNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nom du Client *',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer le nom du client';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () async {
                                  await _addSale();

                                  final print = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Impression du reçu'),
                                      content: Text(
                                          'Voulez-vous imprimer le reçu ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Non'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text('Oui'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (print == true) {
                                    // Fetch the latest sale and print receipt
                                    final sale = await _getLatestSale();
                                    _generateReceipt(sale);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 30, 28, 185),
                                ),
                                child: Text(
                                  'Ajouter Vente',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getSales(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else {
                        final sales = snapshot.data ?? [];
                        return _buildSalesTable(sales);
                      }
                    },
                  ),
                ),
                // Text(
                //   'Total des Ventes: $_totalSales',
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
