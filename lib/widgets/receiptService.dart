import 'package:shared_preferences/shared_preferences.dart';

class ReceiptService {
  static const String _receiptKey = 'receiptNumber';

  Future<int> _getNextReceiptNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int currentNumber = prefs.getInt(_receiptKey) ?? 0;
    int nextNumber = currentNumber + 1;
    await prefs.setInt(_receiptKey, nextNumber);
    return nextNumber;
  }

  Future<void> generateReceipt(Map<String, dynamic> sale) async {
    int receiptNumber = await _getNextReceiptNumber();
    sale['receiptNumber'] = receiptNumber;

    // Continue with the generation of the receipt
    // e.g., create PDF, save data, etc.
  }
}
