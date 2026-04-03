import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src/config/theme.dart';

const kGreen = AppTheme.primaryColor;
const kBg = AppTheme.backgroundColor;
const kWhite = AppTheme.surfaceColor;
const kTextDark = AppTheme.primaryText;
const kTextMuted = AppTheme.mutedText;

class DuplicateItem {
  final String id;
  final String name;
  final String category;
  final String location;

  const DuplicateItem({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
  });
}

// ─── RESULT ENUM ─────────────────────────────────────────────────────────────
enum DuplicateAction { continueAdding, cancel, viewExisting }

// ─── DUPLICATE ICON ───────────────────────────────────────────────────────────
class DuplicateIcon extends StatelessWidget {
  final double size;

  const DuplicateIcon({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/duplicates_warning_icon.png',
      width: size,
      height: size,
    );
  }
}



Future<DuplicateAction?> showDuplicateWarning({
  required BuildContext context,
  required DuplicateItem existingItem,
}) {
  return showDialog<DuplicateAction>(
    context: context,
    barrierDismissible: false,
    builder: (_) => DuplicateWarningDialog(existingItem: existingItem),
  );
}

class DuplicateWarningDialog extends StatelessWidget {
  final DuplicateItem existingItem;

  const DuplicateWarningDialog({super.key, required this.existingItem});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: kWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            
            const DuplicateIcon(size: 56),
            const SizedBox(height: 16),

            
            Text(
              'Possible duplicate found',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: kTextDark,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'A similar item already exists in this inventory.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: kTextMuted, fontSize: 13),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // ── Existing item card ─────────────────────────────────────────
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'EXISTING ITEM',
                style: GoogleFonts.inter(
                  color: kTextMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDDDDD), width: 0.5),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Name', value: existingItem.name),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Category', value: existingItem.category),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Location', value: existingItem.location),
                ],
              ),
            ),

            // ── View existing link ─────────────────────────────────────────
            TextButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(DuplicateAction.viewExisting),
              icon: const Icon(Icons.open_in_new, size: 14, color: kGreen),
              label: Text(
                'View existing item',
                style: GoogleFonts.inter(
                  color: kGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // ── Action buttons ─────────────────────────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(DuplicateAction.cancel),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFFDDDDDD)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        color: kTextDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Continue Adding
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pop(DuplicateAction.continueAdding),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Continue adding',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HELPER WIDGET ────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.inter(color: kTextMuted, fontSize: 12)),
        Text(value,
            style: GoogleFonts.inter(
              color: kTextDark,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}
