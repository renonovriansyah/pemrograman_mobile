import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../features/cart/cart_model.dart';

class PdfGenerator {
  
  // --- 1. PRINT DARI KERANJANG (New Transaction) ---
  static Future<void> printReceipt(List<CartItem> items, double total, String paymentMethod) async {
    try {
      final doc = pw.Document();
      final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      final now = DateTime.now();
      final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(now);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context context) {
            return _buildReceiptLayout(
              title: 'SIZZLE BURGER',
              subtitle: 'Jln. Rasa Juara No. 1',
              dateStr: dateStr,
              transactionId: '-',
              itemsWidget: items.map((item) {
                return _buildItemRow(
                  qty: item.quantity,
                  name: item.product.name,
                  detail: _formatVariantsCart(item),
                  price: item.totalPrice,
                  currency: currency,
                );
              }).toList(),
              total: total,
              paymentMethod: paymentMethod,
              currency: currency,
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'Struk_SizzleBurger_${now.millisecondsSinceEpoch}',
      );
    } catch (e) {
      debugPrint("ERROR PRINT RECEIPT: $e");
      rethrow;
    }
  }

  // --- 2. CETAK ULANG DARI HISTORY (Reprint) ---
  static Future<void> reprint(Map<String, dynamic> transactionData, String transactionId) async {
    // KITA HAPUS TRY-CATCH AGAR ERROR MUNCUL DI LAYAR HP/BROWSER
    final doc = pw.Document();
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // 1. Debugging Data (Cek di Console Browser F12)
    debugPrint("Mulai Reprint ID: $transactionId");
    debugPrint("Raw Data: $transactionData");

    // 2. Safe Parsing Timestamp
    DateTime timestamp;
    if (transactionData['timestamp'] != null) {
      if (transactionData['timestamp'] is Timestamp) {
        timestamp = (transactionData['timestamp'] as Timestamp).toDate();
      } else if (transactionData['timestamp'] is String) {
        // Jaga-jaga kalau formatnya string ISO8601
        timestamp = DateTime.parse(transactionData['timestamp']); 
      } else {
        timestamp = DateTime.now();
      }
    } else {
      timestamp = DateTime.now();
    }
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);

    // 3. Safe Parsing Angka
    final total = (transactionData['totalAmount'] as num? ?? 0).toDouble();
    final paymentMethod = transactionData['paymentMethod']?.toString() ?? '-';

    // 4. Parsing Items
    final rawItems = transactionData['items'] as List<dynamic>? ?? [];

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return _buildReceiptLayout(
            title: 'SIZZLE BURGER',
            subtitle: '(COPY STRUK)',
            dateStr: dateStr,
            transactionId: transactionId.length > 8 ? transactionId.substring(0, 8).toUpperCase() : transactionId,
            itemsWidget: rawItems.map((e) {
              final itemMap = e as Map<String, dynamic>;
              // Parsing item level
              final qty = (itemMap['quantity'] as num? ?? 1).toInt();
              final name = itemMap['productName']?.toString() ?? 'Item';
              final subTotal = (itemMap['totalPrice'] as num? ?? 0).toDouble();
              String details = _formatVariantsHistory(itemMap);

              return _buildItemRow(
                qty: qty,
                name: name,
                detail: details,
                price: subTotal,
                currency: currency,
              );
            }).toList(),
            total: total,
            paymentMethod: paymentMethod,
            currency: currency,
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Copy_Struk_$transactionId',
    );
  }
  
  // --- LAYOUT (Sama seperti sebelumnya) ---
  static pw.Widget _buildReceiptLayout({
    required String title,
    required String subtitle,
    required String dateStr,
    required String transactionId,
    required List<pw.Widget> itemsWidget,
    required double total,
    required String paymentMethod,
    required NumberFormat currency,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
        pw.Text(subtitle, style: const pw.TextStyle(fontSize: 10)),
        if (transactionId != '-') pw.Text('ID: $transactionId', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 0.5),
        
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Tgl: $dateStr', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('Kasir: Admin', style: const pw.TextStyle(fontSize: 9)),
        ]),
        pw.Divider(thickness: 0.5),

        ...itemsWidget,

        pw.Divider(thickness: 0.5),

        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.Text(currency.format(total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Bayar ($paymentMethod)', style: const pw.TextStyle(fontSize: 10)),
            pw.Text(currency.format(total), style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Text('Terima Kasih!', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildItemRow({
    required int qty,
    required String name,
    required String detail,
    required double price,
    required NumberFormat currency,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('$qty x ', style: const pw.TextStyle(fontSize: 10)),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                if (detail.isNotEmpty)
                  pw.Text(detail, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
              ],
            ),
          ),
          pw.Text(currency.format(price), style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  static String _formatVariantsCart(CartItem item) {
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    if (item.notes != null && item.notes!.isNotEmpty) details.add("Note: ${item.notes}");
    return details.join(", ");
  }

  static String _formatVariantsHistory(Map<String, dynamic> item) {
    List<String> details = [];
    
    // Gunakan try-catch kecil agar satu item error tidak merusak semua
    try {
      // Variants
      if (item['variants'] != null && item['variants'] is Map) {
        final variants = item['variants'] as Map;
        variants.forEach((k, v) => details.add(v.toString()));
      }
      
      // Modifiers
      if (item['modifiers'] != null && item['modifiers'] is List) {
        final modifiers = item['modifiers'] as List;
        details.addAll(modifiers.map((e) => e.toString()));
      }
      
      // Note
      if (item['note'] != null && item['note'].toString().isNotEmpty) {
        details.add("Note: ${item['note']}");
      }
    } catch (e) {
      // Ignore parsing error for detail string
    }
    
    return details.join(", ");
  }
}