import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/profile_screens/presentation/cubit/profile_cubit.dart';
import 'package:src/features/profile_screens/presentation/cubit/profile_state.dart';
import 'package:src/features/profile_screens/presentation/routes.dart';
import 'package:src/features/profile_screens/presentation/widgets/profile_avatar.dart';

const _kCardBg = Color(0xFFEDE8DC);
const _kRed = Color(0xFFC1440E);

class ProfileMenuPage extends StatelessWidget {
  const ProfileMenuPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel',
                style: TextStyle(color: AppTheme.mutedText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProfileCubit>().signOut();
              // TODO: navigate to auth landing after sign out
              context.go('/auth');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account',
            style: TextStyle(fontWeight: FontWeight.w700, color: _kRed)),
        content: const Text(
            'This action is permanent and cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel',
                style: TextStyle(color: AppTheme.mutedText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // TODO: call delete account use case
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: _kRed),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final displayName = state is ProfileLoaded
                ? (state.user.name ?? state.user.email)
                : 'User';
            final avatarUrl =
                state is ProfileLoaded ? state.user.profilePictureUrl : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => context.go('/home'),
                          child: const Icon(Icons.arrow_back_ios,
                              color: AppTheme.primaryText, size: 20),
                        ),
                      ),
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProfileAvatar(size: 100, imageUrl: avatarUrl),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () =>
                        context.go(ProfileRoutes.accountInfoPath),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _MenuRow(
                    label: 'Account information',
                    onTap: () =>
                        context.go(ProfileRoutes.accountInfoPath),
                  ),
                  _MenuRow(
                    label: 'Notifications',
                    onTap: () {
                      // TODO: navigate to Notifications screen
                    },
                  ),
                  _MenuRow(
                    label: 'Settings',
                    onTap: () =>
                        context.go(ProfileRoutes.settingsPath),
                  ),
                  _MenuRow(
                    label: 'Help',
                    onTap: () => context.go(ProfileRoutes.helpPath),
                  ),
                  _MenuRow(
                    label: 'Invite roommates',
                    onTap: () => context.go(ProfileRoutes.inviteRoommatePath),
                  ),
                  const SizedBox(height: 20),
                  _PrimaryButton(
                    label: 'Log Out',
                    onTap: () => _showLogoutDialog(context),
                  ),
                  const SizedBox(height: 4),
                  _PrimaryButton(
                    label: 'Delete Account',
                    color: _kRed,
                    onTap: () => _showDeleteDialog(context),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            Text(
              '>',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.mutedText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
