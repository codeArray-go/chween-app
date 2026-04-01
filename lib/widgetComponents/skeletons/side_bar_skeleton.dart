import 'package:flutter/material.dart';

class SideBarSkeleton extends StatelessWidget {
  const SideBarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final Color skeletonColor = Colors.grey[800]!;
    final Color searchBarColor = Colors.grey[900]!;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(color: skeletonColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4)),
                  ),
                  const Spacer(),
                  Icon(Icons.more_vert, color: skeletonColor),
                ],
              ),
            ),

            Divider(color: searchBarColor, height: 1, thickness: 1),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: searchBarColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: skeletonColor, size: 20),
                    const SizedBox(width: 12),
                    Container(
                      height: 14,
                      width: 150,
                      decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 18,
                width: 90,
                decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 8),

            // 4. The Chat List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(color: skeletonColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 14,
                                width: 100,
                                decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4)),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 12,
                                width: 160,
                                decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4)),
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
          ],
        ),
      ),
    );
  }
}