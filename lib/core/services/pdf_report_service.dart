import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../features/car/domain/entities/car.dart';
import '../../features/expense/domain/entities/expense.dart';
import '../../features/refueling/domain/entities/refueling.dart';

class PdfReportService {
  const PdfReportService();

  /// Генерирует PDF-отчёт и открывает системный диалог «Поделиться».
  Future<void> generateAndShare({
    required Car car,
    required List<Refueling> refuelings,
    required List<Expense> expenses,
    required String currencySymbol,
    double? avgConsumption,
  }) async {
    final bytes = await _buildPdf(
      car: car,
      refuelings: refuelings,
      expenses: expenses,
      currency: currencySymbol,
      avgConsumption: avgConsumption,
    );

    final dir = await getTemporaryDirectory();
    final filename =
        'mycar_report_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf';
    final file = File(p.join(dir.path, filename));
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'Отчёт по расходам — ${car.displayName}',
    );
  }

  Future<List<int>> _buildPdf({
    required Car car,
    required List<Refueling> refuelings,
    required List<Expense> expenses,
    required String currency,
    double? avgConsumption,
  }) async {
    // Загружаем шрифты с поддержкой кириллицы
    final regularData =
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final boldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    final ttfRegular = pw.Font.ttf(regularData);
    final ttfBold = pw.Font.ttf(boldData);

    final baseStyle = pw.TextStyle(font: ttfRegular, fontSize: 10);
    final boldStyle = pw.TextStyle(font: ttfBold, fontSize: 10);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: ttfRegular, bold: ttfBold),
    );

    // Объединяем и сортируем по дате (новые сначала)
    final allOps = <_OpRow>[];
    for (final r in refuelings) {
      allOps.add(_OpRow(
        date: r.date,
        type: 'Заправка',
        title: r.stationName ?? '—',
        odometer: r.odometer,
        amount: r.totalCost,
      ));
    }
    for (final e in expenses) {
      allOps.add(_OpRow(
        date: e.date,
        type: e.category.label,
        title: e.title,
        odometer: null,
        amount: e.cost,
      ));
    }
    allOps.sort((a, b) => b.date.compareTo(a.date));

    final totalSpend = allOps.fold(0.0, (s, r) => s + r.amount);
    final now = DateTime.now();
    final dateFmt = DateFormat('dd.MM.yyyy');
    final timeFmt = DateFormat('dd.MM.yyyy HH:mm');

    // Цвета
    const headerBg = PdfColor.fromInt(0xFF1A2B4A);
    const rowEven = PdfColor.fromInt(0xFFF7F9FC);
    const rowOdd = PdfColors.white;
    const accentBlue = PdfColor.fromInt(0xFF3D7EFF);
    const textDark = PdfColor.fromInt(0xFF1C1C1E);
    const textGray = PdfColor.fromInt(0xFF8E8E93);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        build: (pw.Context ctx) {
          return [
            // ── Шапка ──────────────────────────────────────────────────────
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: headerBg,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Отчёт по расходам',
                          style: pw.TextStyle(
                            font: ttfBold,
                            color: PdfColors.white,
                            fontSize: 22,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          car.displayName,
                          style: baseStyle.copyWith(
                            color: const PdfColor.fromInt(0xFF8AB4F8),
                            fontSize: 14,
                          ),
                        ),
                        if (car.licensePlate != null)
                          pw.Text(
                            car.licensePlate!.toUpperCase(),
                            style: baseStyle.copyWith(
                              color: const PdfColor.fromInt(0xFF8AB4F8),
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Дата: ${dateFmt.format(now)}',
                        style: baseStyle.copyWith(
                          color: const PdfColor.fromInt(0xFFAAAAAA),
                          fontSize: 10,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Пробег: ${_fmtOdo(car.currentOdometer)} км',
                        style: baseStyle.copyWith(
                          color: const PdfColor.fromInt(0xFFAAAAAA),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // ── Блок статистики ─────────────────────────────────────────────
            pw.Row(
              children: [
                _statCard(
                  'Всего потрачено',
                  '${_fmtCost(totalSpend)} $currency',
                  accentBlue,
                  ttfRegular,
                  ttfBold,
                ),
                pw.SizedBox(width: 12),
                _statCard(
                  'Операций',
                  '${allOps.length}',
                  textDark,
                  ttfRegular,
                  ttfBold,
                ),
                pw.SizedBox(width: 12),
                _statCard(
                  'Ср. расход',
                  avgConsumption != null
                      ? '${avgConsumption.toStringAsFixed(1)} л/100 км'
                      : 'Нет данных',
                  textDark,
                  ttfRegular,
                  ttfBold,
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            // ── Таблица операций ────────────────────────────────────────────
            pw.Text(
              'История операций',
              style: boldStyle.copyWith(fontSize: 14, color: textDark),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(
                color: const PdfColor.fromInt(0xFFE5E5EA),
                width: 0.5,
              ),
              columnWidths: {
                0: const pw.FixedColumnWidth(60), // Дата
                1: const pw.FixedColumnWidth(70), // Тип
                2: const pw.FlexColumnWidth(), // Название
                3: const pw.FixedColumnWidth(60), // Пробег
                4: const pw.FixedColumnWidth(70), // Сумма
              },
              children: [
                // Заголовок таблицы
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: headerBg),
                  children:
                      ['Дата', 'Тип', 'Описание', 'Пробег', 'Сумма']
                          .map((h) => pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                child: pw.Text(
                                  h,
                                  style: boldStyle.copyWith(
                                    color: PdfColors.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ))
                          .toList(),
                ),
                // Строки данных
                ...allOps.indexed.map(((int, _OpRow) entry) {
                  final (i, op) = entry;
                  final bg = i.isEven ? rowEven : rowOdd;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: bg),
                    children: [
                      _cell(dateFmt.format(op.date), textDark, ttfRegular),
                      _cell(op.type, textGray, ttfRegular),
                      _cell(op.title, textDark, ttfRegular),
                      _cell(
                        op.odometer != null
                            ? '${_fmtOdo(op.odometer!)} км'
                            : '—',
                        textGray,
                        ttfRegular,
                      ),
                      _cell(
                        '${_fmtCost(op.amount)} $currency',
                        accentBlue,
                        ttfBold,
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 20),

            // ── Подвал ──────────────────────────────────────────────────────
            pw.Divider(color: const PdfColor.fromInt(0xFFE5E5EA)),
            pw.SizedBox(height: 6),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Сгенерировано MyCar · ${timeFmt.format(now)}',
                  style: baseStyle.copyWith(fontSize: 8, color: textGray),
                ),
                pw.Text(
                  'Итого: ${_fmtCost(totalSpend)} $currency',
                  style: boldStyle.copyWith(fontSize: 10, color: textDark),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _statCard(
    String label,
    String value,
    PdfColor valueColor,
    pw.Font regular,
    pw.Font bold,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFFF7F9FC),
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(
            color: const PdfColor.fromInt(0xFFE5E5EA),
            width: 0.5,
          ),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                font: regular,
                fontSize: 9,
                color: const PdfColor.fromInt(0xFF8E8E93),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                font: bold,
                fontSize: 13,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _cell(String text, PdfColor color, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: 9, color: color),
      ),
    );
  }

  static String _fmtOdo(int km) =>
      NumberFormat('#,##0', 'ru_RU').format(km).replaceAll(',', '\u00A0');

  static String _fmtCost(double cost) =>
      NumberFormat('#,##0', 'ru_RU').format(cost.round()).replaceAll(',', '\u00A0');
}

class _OpRow {
  const _OpRow({
    required this.date,
    required this.type,
    required this.title,
    required this.odometer,
    required this.amount,
  });
  final DateTime date;
  final String type;
  final String title;
  final int? odometer;
  final double amount;
}
