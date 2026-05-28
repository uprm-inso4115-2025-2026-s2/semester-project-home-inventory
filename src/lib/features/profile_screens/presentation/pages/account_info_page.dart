import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:src/config/theme.dart';
import 'package:src/features/profile_screens/presentation/cubit/profile_cubit.dart';
import 'package:src/features/profile_screens/presentation/cubit/profile_state.dart';
import 'package:src/features/profile_screens/presentation/widgets/profile_avatar.dart';

const _kCardBg = Color(0xFFEDE8DC);
const _kRed = Color(0xFFC1440E);

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({super.key});

  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  bool _editing = false;
  late final TextEditingController _nameCtrl;

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Library'),
              onTap: () {
                Navigator.pop(context);
                // TODO: implement image picker
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: implement camera
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Remove Photo',
                  style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    final user = state is ProfileLoaded ? state.user : null;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _usernameCtrl = TextEditingController();
    _emailCtrl = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: ctrl,
        enabled: _editing,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppTheme.mutedText, fontSize: 14),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.primaryText,
          fontWeight: FontWeight.w500,
        ),
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
            final avatarUrl =
                state is ProfileLoaded ? state.user.profilePictureUrl : null;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios,
                              color: AppTheme.primaryText, size: 20),
                        ),
                      ),
                      const Text(
                        'Account information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProfileAvatar(
                    size: 90,
                    imageUrl: avatarUrl,
                    editable: _editing,
                    onTap: _showPhotoOptions,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      if (_editing) {
                        // TODO: call update profile use case with _nameCtrl, _usernameCtrl, _emailCtrl values
                      }
                      setState(() => _editing = !_editing);
                    },
                    child: Text(
                      _editing ? 'Save' : 'Edit',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildField('Name', _nameCtrl),
                  _buildField('Username', _usernameCtrl),
                  _buildField('Email', _emailCtrl),
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to change password screen
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: _kCardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text('>',
                              style: TextStyle(
                                  color: AppTheme.mutedText, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _PrimaryButton(
                    label: 'Log Out',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 4),
                  _PrimaryButton(
                    label: 'Delete Account',
                    color: _kRed,
                    onTap: () {},
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
              borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
