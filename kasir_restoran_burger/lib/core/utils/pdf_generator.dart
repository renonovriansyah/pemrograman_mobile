import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../features/cart/cart_model.dart';

class PdfGenerator {
  // Fungsi Utama: Generate & Print
  static Future<void> printReceipt(List<CartItem> items, double total, String paymentMethod) async {
    final doc = pw.Document();
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final now = DateTime.now();
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(now);

    // Muat font (Optional, pake default dulu biar ringan)
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Format Kertas Struk (80mm)
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text('SIZZLE BURGER', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              pw.Text('Jln. Rasa Juara No. 1', style: const pw.TextStyle(fontSize: 10)),
              pw.Text('Telp: 0812-3456-7890', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),
              
              // Info Transaksi
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Tgl: $dateStr', style: const pw.TextStyle(fontSize: 9)),
                pw.Text('Kasir: Admin', style: const pw.TextStyle(fontSize: 9)),
              ]),
              pw.Divider(thickness: 0.5),

              // List Item
              ...items.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${item.quantity}x ', style: const pw.TextStyle(fontSize: 10)),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.product.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                            if (item.selectedVariants.isNotEmpty)
                              pw.Text(_formatVariants(item), style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                          ]
                        )
                      ),
                      pw.Text(currency.format(item.totalPrice), style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }),

              pw.Divider(thickness: 0.5),

              // Total
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
              pw.Text('Silakan Datang Kembali', style: const pw.TextStyle(fontSize: 8)),
            ],
          );
        },
      ),
    );

    // Membuka Dialog Print Browser
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
      name: 'Struk_SizzleBurger_${now.millisecondsSinceEpoch}',
    );
  }

  static String _formatVariants(CartItem item) {
    final List<String> details = [];
    item.selectedVariants.forEach((k, v) => details.add(v.name));
    for (var m in item.selectedModifiers) {
      details.add(m.name);
    }
    return details.join(", ");
  }
}