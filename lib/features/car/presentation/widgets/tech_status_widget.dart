import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';

class TechStatusWidget extends StatelessWidget {
  const TechStatusWidget({
    super.key,
    required this.oilChangeProgress,
    required this.oilChangeKmLeft,
    required this.insuranceDaysLeft,
    this.insurancePdfPath,
    this.techInspectionDaysLeft,
    this.techInspectionFilePath,
    this.onOilTap,
    this.onInsuranceTap,
    this.onInsuranceRemove,
    this.onTechInspectionTap,
    this.onTechInspectionRemove,
  });

  final double oilChangeProgress;
  final int oilChangeKmLeft;
  final int? insuranceDaysLeft;
  final String? insurancePdfPath;
  final int? techInspectionDaysLeft;
  final String? techInspectionFilePath;

  final VoidCallback? onOilTap;
  final VoidCallback? onInsuranceTap;
  final VoidCallback? onInsuranceRemove;
  final VoidCallback? onTechInspectionTap;
  final VoidCallback? onTechInspectionRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Ряд 1: масло + страховка
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onOilTap,
                  child: _StatusCard(
                    icon: Icons.oil_barrel_rounded,
                    title: 'Масло',
                    progress: oilChangeProgress,
                    accentColor: _oilColor(oilChangeProgress),
                    valueText: _oilValueText(oilChangeKmLeft),
                    statusLabel: oilChangeKmLeft > 0 ? 'до замены' : 'просрочено',
                    isWarning: oilChangeKmLeft <= 0,
                    hasTap: onOilTap != null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DocumentCard(
                  icon: Icons.shield_rounded,
                  iconOutlined: Icons.shield_outlined,
                  title: 'Страховка',
                  progress: _daysProgress(insuranceDaysLeft),
                  accentColor: _daysColor(insuranceDaysLeft),
                  valueText: _daysValueText(insuranceDaysLeft),
                  statusLabel: _daysStatusLabel(insuranceDaysLeft, hasFile: insurancePdfPath != null),
                  isWarning: insuranceDaysLeft != null && insuranceDaysLeft! <= 30,
                  hasFile: insurancePdfPath != null,
                  onTap: onInsuranceTap,
                  onRemove: onInsuranceRemove,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Ряд 2: техосмотр (полная ширина)
          _DocumentCard(
            icon: Icons.fact_check_rounded,
            iconOutlined: Icons.fact_check_outlined,
            title: 'Техосмотр',
            progress: _daysProgress(techInspectionDaysLeft),
            accentColor: _daysColor(techInspectionDaysLeft),
            valueText: _daysValueText(techInspectionDaysLeft),
            statusLabel: _daysStatusLabel(techInspectionDaysLeft, hasFile: techInspectionFilePath != null),
            isWarning: techInspectionDaysLeft != null && techInspectionDaysLeft! <= 30,
            hasFile: techInspectionFilePath != null,
            onTap: onTechInspectionTap,
            onRemove: onTechInspectionRemove,
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Color _oilColor(double p) {
    if (p < 0.7) return AppColors.green;
    if (p < 0.9) return AppColors.yellow;
    return AppColors.red;
  }

  Color _daysColor(int? days) {
    if (days == null) return AppColors.text3;
    if (days > 30) return AppColors.green;
    if (days > 7) return AppColors.yellow;
    return AppColors.red;
  }

  double _daysProgress(int? days) {
    if (days == null) return 0.0;
    return (1.0 - days / 365.0).clamp(0.0, 1.0);
  }

  String _oilValueText(int kmLeft) {
    if (kmLeft <= 0) return _fmtKm(kmLeft.abs());
    return _fmtKm(kmLeft);
  }

  String _daysValueText(int? days) {
    if (days == null) return '—';
    if (days <= 0) return 'Истёк';
    return '$days\u00a0д';
  }

  String _daysStatusLabel(int? days, {required bool hasFile}) {
    if (days == null) return hasFile ? 'нет даты' : 'нажмите, чтобы добавить';
    if (days <= 0) return 'истёк';
    if (days <= 7) return 'критично';
    if (days <= 30) return 'скоро конец';
    return 'действует';
  }

  String _fmtKm(int km) {
    if (km >= 1000) {
      final k = km / 1000;
      final s = k.truncateToDouble() == k
          ? '${k.toInt()}\u00a0тыс.'
          : '${k.toStringAsFixed(1)}\u00a0тыс.';
      return '$s\u00a0км';
    }
    return '$km\u00a0км';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Карточка одного индикатора
// ─────────────────────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.progress,
    required this.accentColor,
    required this.valueText,
    required this.statusLabel,
    required this.isWarning,
    this.hasTap = false,
  });

  final IconData icon;
  final String title;
  final double progress;
  final Color accentColor;
  final String valueText;
  final String statusLabel;
  final bool isWarning;
  final bool hasTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bg1,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isWarning
              ? accentColor.withAlpha(70)
              : AppColors.border1,
          width: isWarning ? 1 : 0.5,
        ),
        boxShadow: isWarning
            ? [
                BoxShadow(
                  color: accentColor.withAlpha(30),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Иконка + заголовок
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: accentColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasTap)
                Icon(Icons.chevron_right_rounded,
                    size: 16, color: AppColors.text3),
            ],
          ),

          const SizedBox(height: 16),

          // Главное значение
          Text(
            valueText,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: -0.5,
              height: 1.0,
            ),
          ),

          const SizedBox(height: 4),

          // Подпись статуса
          Text(
            statusLabel,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.text3,
            ),
          ),

          const SizedBox(height: 14),

          // Прогресс-бар
          _ArcProgressBar(progress: progress, color: accentColor),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Интерактивная карточка документа (страховка / техосмотр)
// ─────────────────────────────────────────────────────────────────────────────

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.icon,
    required this.iconOutlined,
    required this.title,
    required this.progress,
    required this.accentColor,
    required this.valueText,
    required this.statusLabel,
    required this.isWarning,
    required this.hasFile,
    this.fullWidth = false,
    this.onTap,
    this.onRemove,
  });

  final IconData icon;
  final IconData iconOutlined;
  final String title;
  final double progress;
  final Color accentColor;
  final String valueText;
  final String statusLabel;
  final bool isWarning;
  final bool hasFile;
  final bool fullWidth;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.bg1,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isWarning ? accentColor.withAlpha(70) : AppColors.border1,
            width: isWarning ? 1 : 0.5,
          ),
          boxShadow: isWarning
              ? [BoxShadow(color: accentColor.withAlpha(30),
                  blurRadius: 20, offset: const Offset(0, 4))]
              : null,
        ),
        child: fullWidth
            ? Row(
                children: [
                  // Левая часть: иконка + значение + статус
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34, height: 34,
                              decoration: BoxDecoration(
                                color: accentColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(hasFile ? icon : iconOutlined,
                                  size: 17, color: accentColor),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(title,
                                style: GoogleFonts.manrope(fontSize: 13,
                                    fontWeight: FontWeight.w600, color: AppColors.text2),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (hasFile && onRemove != null)
                              GestureDetector(
                                onTap: onRemove,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(Icons.delete_outline_rounded,
                                      size: 16, color: AppColors.red.withAlpha(180)),
                                ),
                              ),
                            if (!hasFile)
                              Icon(Icons.add_circle_outline_rounded,
                                  size: 16, color: AppColors.text3),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(valueText,
                              style: GoogleFonts.manrope(fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: accentColor, letterSpacing: -0.5, height: 1.0)),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(statusLabel,
                                style: GoogleFonts.manrope(fontSize: 11,
                                    fontWeight: FontWeight.w500, color: AppColors.text3)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _ArcProgressBar(progress: progress, color: accentColor),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34, height: 34,
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(hasFile ? icon : iconOutlined,
                            size: 17, color: accentColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title,
                          style: GoogleFonts.manrope(fontSize: 13,
                              fontWeight: FontWeight.w600, color: AppColors.text2),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasFile && onRemove != null)
                        GestureDetector(
                          onTap: onRemove,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(Icons.delete_outline_rounded,
                                size: 16, color: AppColors.red.withAlpha(180)),
                          ),
                        ),
                      if (!hasFile)
                        Icon(Icons.add_circle_outline_rounded,
                            size: 16, color: AppColors.text3),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(valueText,
                    style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800,
                        color: accentColor, letterSpacing: -0.5, height: 1.0)),
                  const SizedBox(height: 4),
                  Text(statusLabel,
                    style: GoogleFonts.manrope(fontSize: 11,
                        fontWeight: FontWeight.w500, color: AppColors.text3)),
                  const SizedBox(height: 14),
                  _ArcProgressBar(progress: progress, color: accentColor),
                ],
              ),
      ),
    );
  }
}

/// Тонкий прогресс-бар с сегментацией и свечением.
class _ArcProgressBar extends StatelessWidget {
  const _ArcProgressBar({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final w = constraints.maxWidth;
      final filled = (w * progress).clamp(0.0, w);
      return Stack(
        children: [
          // Трек
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.bg3,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // Заполненная часть + свечение
          Container(
            width: filled,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: LinearGradient(
                colors: [color.withAlpha(160), color],
              ),
              boxShadow: filled > 4
                  ? [
                      BoxShadow(
                        color: color.withAlpha(100),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
      );
    });
  }
}
