import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserListSkeleton extends StatelessWidget {
  const UserListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color baseColor = Colors.grey[800]!;
    final Color highlightColor = Colors.grey[700]!;
    final Color containerColor = Colors.grey[900]!;

    return Expanded(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              child: Row(
                children: [
                  // Avatar with status dot placeholder
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(color: containerColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 16),
                  // Name and Message
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 80,
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 140,
                          decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(4)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
