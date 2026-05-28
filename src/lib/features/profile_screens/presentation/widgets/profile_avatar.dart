import 'package:flutter/material.dart';
import 'package:src/config/theme.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final bool editable;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.size = 90,
    this.imageUrl,
    this.editable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: editable ? onTap : null,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(size / 2),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Icon(Icons.person, size: size * 0.55, color: Colors.white70)
                : null,
          ),
          if (editable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.34,
                height: size * 0.34,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: size * 0.19,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
