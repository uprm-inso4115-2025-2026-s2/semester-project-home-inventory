import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/router.dart';
import 'package:src/config/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class InviteRoommateScreen extends StatefulWidget {
  const InviteRoommateScreen({super.key});

  @override
  State<InviteRoommateScreen> createState() => _InviteRoommateScreenState();
}

class _InviteRoommateScreenState extends State<InviteRoommateScreen> {
  static const List<String> roleOptions = <String>[
    'Roommate',
    'Parent',
    'Child',
    'Sibling',
    'Other',
  ];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _submitted = false;
  bool _inviteSent = false;
  String? _selectedRole;
  String _sentUsername = '';
  String _sentPhone = '';
  String _sentRole = '';
  Timer? _navigationTimer;
  bool isPressed = false;

  void handleViewInvitesPressed() {
    setState(() {
      isPressed = true;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        isPressed = false;
      });

      final username = Uri.encodeComponent(_sentUsername);
      final phone = Uri.encodeComponent(_sentPhone);
      final role = Uri.encodeComponent(_sentRole);

      context.go('/home/invite_roommate/view_invites?username=$username&phone=$phone&role=$role');
    });
  }
  @override




  void dispose() {
    _navigationTimer?.cancel();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool get _isUsernameValid {
    final String trimmed = _usernameController.text.trim();
    final RegExp regex = RegExp(r'^[a-zA-Z0-9._-]{3,30}$');
    return regex.hasMatch(trimmed);
  }

  bool get _isPhoneValid {
    final String digitsOnly = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length >= 7 && digitsOnly.length <= 15;
  }

  bool get _showError => _submitted && !_inviteSent && (!_isUsernameValid || !_isPhoneValid);

  void _handleSendInvite() {
    setState(() {
      _submitted = true;
    });

    if (!_isUsernameValid || !_isPhoneValid) {
      return;
    }

    final String roleToSend = _selectedRole ?? 'Other';
    _sentUsername = _usernameController.text.trim();
    _sentPhone = _phoneController.text.trim();
    _sentRole = roleToSend;

    setState(() {
      _inviteSent = true;
    });

    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted) return;

      final username = Uri.encodeComponent(_sentUsername);
      final phone = Uri.encodeComponent(_sentPhone);
      final role = Uri.encodeComponent(_sentRole);

      context.go('/home/invite_roommate/view_invites?username=$username&phone=$phone&role=$role');
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFBF7EF);

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: backgroundColor,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 24,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Image.asset(
                              'assets/images/homeinventorylogo.png',

                              width: 140,
                              height: 100,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Invite Roommate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  border: Border.all(color: const Color(0xFFE7E0D6), width: 4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: _inviteSent ? _buildSuccessView() : _buildFormView(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildSuccessView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Invite Sent!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Text(
          'Stay Tuned for Updates',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: handleViewInvitesPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isPressed
                  ? const Color(0xFFA3B18A)
                  : const Color(0xFF3A5A40),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'View Invites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildInput(
          controller: _usernameController,
          hintText: 'Username or Email',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _buildInput(
          controller: _phoneController,
          hintText: 'Phone Number',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s().]')),
          ],
        ),
        if (_showError) ...<Widget>[
          const SizedBox(height: 2),
          const Text(
            'Invalid Username or Phone Number',
            style: TextStyle(
              color: Color(0xFFFF0000),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        const SizedBox(height: 14),
        const Text(
          'Select the role that fits best',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 14,
          children: roleOptions.map((String role) {
            final bool isSelected = _selectedRole == role;

            return SizedBox(
              width: double.infinity,
              height: 60,
              //width: (MediaQuery.of(context).size.width - 24 - 24 - 20 - 20 - 12) / 2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRole = role;
                  });
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 54),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFA3B18A) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFA3B18A),
                      width: 3,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    role,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected ? Colors.white : const Color(0xFF4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _handleSendInvite,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A5A40),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Send Invite',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return SizedBox(
      height: 64,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Color.fromRGBO(75, 85, 99, 0.4),
            fontWeight: FontWeight.w700,
          ),
          filled: true,
          fillColor: const Color.fromRGBO(58, 90, 64, 0.3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF3A5A40), width: 1.5),
          ),
        ),
        onChanged: (_) {
          if (_submitted) {
            setState(() {});
          }
        },
      ),
    );
  }
}