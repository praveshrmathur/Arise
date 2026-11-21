import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_typography.dart';
import '../constants/rank_constants.dart';
import 'rank_badge.dart';

class HunterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final HunterRank? rank;
  final int? level;
  final List<Widget>? actions;
  final bool showBack;

  const HunterAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.rank,
    this.level,
    this.actions,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: HunterColors.background,
        border: Border(
          bottom: BorderSide(color: HunterColors.borderThin, width: 0.8),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (showBack)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: HunterColors.cyan),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            else if (rank != null) ...[
              RankBadge(rank: rank!, size: 32),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: HunterTypography.systemTitle.copyWith(fontSize: 14),
                      ),
                      if (level != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: HunterColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: HunterColors.cyan, width: 0.5),
                          ),
                          child: Text(
                            'LV.$level',
                            style: HunterTypography.systemSub.copyWith(
                              fontSize: 10,
                              color: HunterColors.cyan,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: HunterTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: HunterColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
