import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/car_home_cubit.dart';

const _kAccentColor = Color(0xFF34C759); // зелёный

class AddTechInspectionSheet extends StatefulWidget {
  const AddTechInspectionSheet._();

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
        child: const AddTechInspectionSheet._(),
      ),
    );
  }

  @override
  State<AddTechInspectionSheet> createState() => _AddTechInspectionSheetState();
}

class _AddTechInspectionSheetState extends State<AddTechInspectionSheet> {
  String? _pickedFilePath;
  String? _pickedFileName;
  bool _isImage = false;
  DateTime? _expiryDate;
  bool _loading = false;
  String? _error;

  Future<void> _pickFile() async {
    setState(() => _error = null);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'heic', 'webp'],
        withData: false,
        withReadStream: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.path == null) {
        setState(() => _error = 'Не удалось получить путь к файлу');
        return;
      }
      final ext = file.extension?.toLowerCase() ?? '';
      setState(() {
        _pickedFilePath = file.path;
        _pickedFileName = file.name;
        _isImage = ext != 'pdf';
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
            primary: _kAccentColor,
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
      setState(() => _error = 'Выберите файл или фото техосмотра');
      return;
    }
    if (_expiryDate == null) {
      setState(() => _error = 'Укажите дату окончания техосмотра');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      await context.read<CarHomeCubit>().addTechInspection(_pickedFilePath!, _expiryDate!);
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
                  color: _kAccentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fact_check_rounded, size: 20, color: _kAccentColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Техосмотр', style: GoogleFonts.manrope(
                    fontSize: 22, fontWeight: FontWeight.w800,
                    color: AppColors.text1, letterSpacing: -0.4,
                  )),
                  Text('PDF, фото или скриншот', style: GoogleFonts.manrope(
                    fontSize: 13, color: AppColors.text3,
                  )),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Кнопки выбора типа файла
          Row(
            children: [
              Expanded(
                child: _TypeButton(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'PDF',
                  selected: _pickedFilePath != null && !_isImage,
                  onTap: () async {
                    setState(() => _error = null);
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        withData: false,
                      );
                      if (result == null || result.files.isEmpty) return;
                      final file = result.files.first;
                      if (file.path == null) return;
                      setState(() {
                        _pickedFilePath = file.path;
                        _pickedFileName = file.name;
                        _isImage = false;
                      });
                    } catch (e) {
                      setState(() => _error = 'Ошибка: $e');
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TypeButton(
                  icon: Icons.photo_camera_rounded,
                  label: 'Фото / Скриншот',
                  selected: _pickedFilePath != null && _isImage,
                  onTap: () async {
                    setState(() => _error = null);
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        withData: false,
                      );
                      if (result == null || result.files.isEmpty) return;
                      final file = result.files.first;
                      if (file.path == null) return;
                      setState(() {
                        _pickedFilePath = file.path;
                        _pickedFileName = file.name;
                        _isImage = true;
                      });
                    } catch (e) {
                      setState(() => _error = 'Ошибка: $e');
                    }
                  },
                ),
              ),
            ],
          ),

          // Имя выбранного файла
          if (_pickedFileName != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _kAccentColor.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _kAccentColor.withAlpha(60), width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(
                    _isImage ? Icons.image_rounded : Icons.picture_as_pdf_rounded,
                    size: 15, color: _kAccentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pickedFileName!,
                      style: GoogleFonts.manrope(
                        fontSize: 13, color: AppColors.text1,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Выбор даты окончания
          _PickDateButton(
            label: _expiryDate != null
                ? 'Действует до: ${DateFormat('dd.MM.yyyy').format(_expiryDate!)}'
                : 'Дата окончания техосмотра',
            hasDate: _expiryDate != null,
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
                color: _loading ? AppColors.bg3 : _kAccentColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _loading ? null : [
                  BoxShadow(
                    color: _kAccentColor.withAlpha(70),
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

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _kAccentColor.withAlpha(25) : AppColors.bg2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _kAccentColor.withAlpha(100) : AppColors.border1,
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22,
                color: selected ? _kAccentColor : AppColors.text3),
            const SizedBox(height: 6),
            Text(label,
              style: GoogleFonts.manrope(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: selected ? _kAccentColor : AppColors.text3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickDateButton extends StatelessWidget {
  const _PickDateButton({
    required this.label,
    required this.hasDate,
    required this.onTap,
  });

  final String label;
  final bool hasDate;
  final VoidCallback onTap;

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
            color: hasDate ? _kAccentColor.withAlpha(80) : AppColors.border1,
            width: hasDate ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 18,
                color: hasDate ? _kAccentColor : AppColors.text3),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: hasDate ? AppColors.text1 : AppColors.text3,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.text3),
          ],
        ),
      ),
    );
  }
}
