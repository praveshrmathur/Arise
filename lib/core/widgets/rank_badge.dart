import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_typography.dart';
import '../constants/rank_constants.dart';

class RankBadge extends StatelessWidget {
  final HunterRank rank;
  final bool showTitle;
  final double size;

  const RankBadge({
    super.key,
    required this.rank,
    this.showTitle = false,
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: rank.color.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(
          color: rank.color,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: rank.color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        rank.code,
        style: HunterTypography.displaySmall.copyWith(
          color: rank.color,
          fontSize: size * 0.45,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    if (!showTitle) return badge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RANK ${rank.code}',
              style: HunterTypography.systemSub.copyWith(
                color: rank.color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              rank.title,
              style: HunterTypography.bodySmall.copyWith(
                color: HunterColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
