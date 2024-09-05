import 'package:flutter/material.dart';
import 'package:gestion_stock/models/InventoryResult.dart';

class InventoryTable extends StatelessWidget {
  final List<InventoryResult> inventoryList;

  InventoryTable({required this.inventoryList});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Product')),
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Purchased Quantity')),
        DataColumn(label: Text('Sales Quantity')),
        DataColumn(label: Text('Remaining Quantity')),
      ],
      rows: inventoryList.map((item) {
        return DataRow(cells: [
          DataCell(Text(item.productName)),
          DataCell(Text(item.categoryName)),
          DataCell(Text(item.purchaseQuantity.toString())),
          DataCell(Text(item.salesQuantity.toString())),
          DataCell(Text(item.remainingQuantity.toString())),
        ]);
      }).toList(),
    );
  }
}
