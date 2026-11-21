import 'package:flutter/material.dart';
import '../../app/theme/hunter_colors.dart';
import '../../app/theme/hunter_typography.dart';

class HunterBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HunterBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: HunterColors.surfacePrimary,
        border: Border(
          top: BorderSide(
            color: HunterColors.borderThin,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                label: 'HOME',
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                onTap: () => onTap(0),
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                label: 'QUESTS',
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                onTap: () => onTap(1),
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                label: 'TRAINING',
                icon: Icons.fitness_center_outlined,
                activeIcon: Icons.fitness_center,
                onTap: () => onTap(2),
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                label: 'STATUS',
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                onTap: () => onTap(3),
              ),
              _NavItem(
                index: 4,
                currentIndex: currentIndex,
                label: 'PROFILE',
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: HunterColors.cyanGlow,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? HunterColors.cyan.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(color: HunterColors.cyan.withOpacity(0.4), width: 1)
                    : null,
              ),
              child: Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? HunterColors.cyan : HunterColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: HunterTypography.systemSub.copyWith(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? HunterColors.cyan : HunterColors.textMuted,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
