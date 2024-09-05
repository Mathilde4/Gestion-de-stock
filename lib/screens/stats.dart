import 'package:flutter/material.dart';
import 'package:gestion_stock/widgets/TotalComparisonChart.dart';
import 'package:http/http.dart' as http;

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<double> totalPurchase;
  late Future<double> totalSales;

  @override
  void initState() {
    super.initState();
    totalPurchase = fetchTotalPurchase();
    totalSales = fetchTotalSales();
  }

  Future<double> fetchTotalPurchase() async {
    final response = await http.get(
        Uri.parse('http://localhost:5009/api/purchases/GetTotalPurchasePrice'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total purchase');
    }
  }

  Future<double> fetchTotalSales() async {
    final response = await http
        .get(Uri.parse('http://localhost:5009/api/sales/GetTotalSalesPrice'));
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception('Failed to load total sales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques'),
        backgroundColor: Color.fromARGB(255, 30, 28, 185),
      ),
      body: SingleChildScrollView(
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
                        child: Text(
                            "Consultation des statistiques sur les finances",
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
                      child: Center(
                        child: Text(
                            "Ici vous pouvez consulter votre bénéfice et comparer vos achats et vos ventes",
                            style: TextStyle(
                              color: Color.fromARGB(255, 114, 113, 160),
                              fontSize: 16,
                            )),
                      ),
                    )),
              ],
            ),
            Row(
              children: [
                FutureBuilder<Map<String, double>>(
                  future: Future.wait([totalPurchase, totalSales]).then(
                    (results) => {
                      'purchase': results[0],
                      'sales': results[1],
                    },
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final double chiffreAffaires =
                          data['sales']! - data['purchase']!;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TotalComparisonChart(
                            totalPurchase: data['purchase']!,
                            totalSales: data['sales']!,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 200,
                            child: Card(
                              color: Color.fromARGB(255, 4, 72, 32),
                              elevation: 12,
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bénéfice',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${chiffreAffaires.toStringAsFixed(2)} Francs CFA',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
