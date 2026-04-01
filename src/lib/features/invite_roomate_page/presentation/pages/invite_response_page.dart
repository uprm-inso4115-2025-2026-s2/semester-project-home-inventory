import 'package:flutter/material.dart';
import 'package:src/config/router.dart';

enum InvitationDecision { pending, accepted, declined, error }

class InviteResponseScreen extends StatefulWidget {
  final String inviterUsername;
  final String inviterPhone;
  final String inviterRole;

  const InviteResponseScreen({
    super.key,
    required this.inviterUsername,
    required this.inviterPhone,
    required this.inviterRole,
  });

  @override
  State<InviteResponseScreen> createState() => _InviteResponseScreenState();
}

class _InviteResponseScreenState extends State<InviteResponseScreen> {
  InvitationDecision decision = InvitationDecision.pending;
  String message = '';

  void _setDecision(InvitationDecision value) {
    setState(() {
      decision = value;
      switch (decision) {
        case InvitationDecision.accepted:
          message = 'You have accepted the invitation. Welcome to the shared inventory!';
          break;
        case InvitationDecision.declined:
          message = 'You declined the invitation. You can ask to join again later.';
          break;
        case InvitationDecision.pending:
          message = '';
          break;
        case InvitationDecision.error:
          message = 'There was an issue processing your response. Please try again.';
          break;
      }
    });
  }

  Widget _buildBody() {
    if (widget.inviterUsername.isEmpty || widget.inviterPhone.isEmpty || widget.inviterRole.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Invalid invitation data.',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 8),
            const Text('Please return to the sender and ask for a new invite.',textAlign: TextAlign.center),
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () => AppRouter.goTo(context, '/home'),
            //   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A5A40), foregroundColor: Colors.white),
            //   child: const Text('Back Home'),
            // ),
          ],
        ),
      );
    }

    if (decision != InvitationDecision.pending) {
      final icon = decision == InvitationDecision.accepted
          ? Icons.check_circle_outline
          : Icons.cancel_outlined;
      final color = decision == InvitationDecision.accepted ? Colors.green : Colors.red;

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 12),
            Text(
              decision == InvitationDecision.accepted
                  ? 'Accepted: ${widget.inviterUsername} has been added to your shared inventory.'
                  : 'Declined: invitation removed. You can request a new invite later.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => AppRouter.goTo(context, 'home'),
            //   style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A5A40), foregroundColor: Colors.white),
            //   child: const Text('Back to Home'),
            // ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Invitation from ${widget.inviterUsername}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3A5A40)),
        ),
        const SizedBox(height: 12),
        Text('Role: ${widget.inviterRole}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text('Phone: ${widget.inviterPhone}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 16),
        const Text('You have been invited to collaborate on a shared home inventory.', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _setDecision(InvitationDecision.accepted),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A5A40),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Accept'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _setDecision(InvitationDecision.declined),
                style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3A5A40),
                    side: const BorderSide(color: Color(0xFF3A5A40)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Decline'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7EF),
      appBar: AppBar(
        title: const Text('Roommate Invitation'),
        backgroundColor: const Color(0xFF3A5A40),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildBody(),
      ),
    );
  }
}
