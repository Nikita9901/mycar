import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_cubit.dart';

class AddInsuranceSheet extends StatefulWidget {
  const AddInsuranceSheet._();

  static void show(BuildContext context) {
    final cubit = context.read<CarHomeCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const AddInsuranceSheet._(),
      ),
    );
  }

  @override
  State<AddInsuranceSheet> createState() => _AddInsuranceSheetState();
}

class _AddInsuranceSheetState extends State<AddInsuranceSheet> {
  String? _pickedFilePath;
  String? _pickedFileName;
  DateTime? _expiryDate;
  bool _loading = false;
  String? _error;

  Future<void> _pickPdf() async {
    setState(() => _error = null);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: false,
        withReadStream: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.path == null) {
        setState(() => _error = 'Не удалось получить путь к файлу');
        return;
      }
      setState(() {
        _pickedFilePath = file.path;
        _pickedFileName = file.name;
      });
    } catch (e) {
      setState(() => _error = 'Ошибка выбора файла: $e');
    }
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now.add(const Duration(days: 365)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 10)),
      locale: const Locale('ru', 'RU'),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.blue,
            surface: AppColors.bg2,
            onSurface: AppColors.text1,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  Future<void> _save() async {
    if (_pickedFilePath == null) {
      setState(() => _error = 'Выберите PDF-файл страховки');
      return;
    }
    if (_expiryDate == null) {
      setState(() => _error = 'Укажите дату окончания страховки');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await context.read<CarHomeCubit>().addInsurance(_pickedFilePath!, _expiryDate!);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() { _error = 'Ошибка сохранения: $e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Заголовок
          Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFBF5AF2).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield_rounded, size: 20,
                    color: Color(0xFFBF5AF2)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Страховка', style: GoogleFonts.manrope(
                    fontSize: 22, fontWeight: FontWeight.w800,
                    color: AppColors.text1, letterSpacing: -0.4,
                  )),
                  Text('Загрузите PDF-полис', style: GoogleFonts.manrope(
                    fontSize: 13, color: AppColors.text3,
                  )),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Кнопка выбора PDF
          _PickButton(
            label: _pickedFileName ?? 'Выбрать PDF-файл',
            hasFile: _pickedFilePath != null,
            onTap: _pickPdf,
          ),

          const SizedBox(height: 14),

          // Выбор даты окончания
          _PickButton(
            label: _expiryDate != null
                ? 'Действует до: ${DateFormat('dd.MM.yyyy').format(_expiryDate!)}'
                : 'Дата окончания страховки',
            hasFile: _expiryDate != null,
            icon: Icons.calendar_today_rounded,
            onTap: _pickExpiryDate,
          ),

          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: GoogleFonts.manrope(
              fontSize: 12, color: AppColors.red,
            )),
          ],

          const SizedBox(height: 24),

          // Кнопка сохранить
          GestureDetector(
            onTap: _loading ? null : _save,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 52,
              decoration: BoxDecoration(
                color: _loading ? AppColors.bg3 : const Color(0xFFBF5AF2),
                borderRadius: BorderRadius.circular(14),
                boxShadow: _loading ? null : [
                  BoxShadow(
                    color: const Color(0xFFBF5AF2).withAlpha(70),
                    blurRadius: 16, offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.text2))
                    : Text('Сохранить', style: GoogleFonts.manrope(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickButton extends StatelessWidget {
  const _PickButton({
    required this.label,
    required this.hasFile,
    required this.onTap,
    this.icon = Icons.picture_as_pdf_rounded,
  });

  final String label;
  final bool hasFile;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile
                ? const Color(0xFFBF5AF2).withAlpha(80)
                : AppColors.border1,
            width: hasFile ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18,
                color: hasFile ? const Color(0xFFBF5AF2) : AppColors.text3),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: hasFile ? AppColors.text1 : AppColors.text3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.text3),
          ],
        ),
      ),
    );
  }
}
