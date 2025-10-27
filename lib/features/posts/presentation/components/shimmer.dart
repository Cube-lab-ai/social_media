import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class PostSkeletonShimmer extends StatelessWidget {
  const PostSkeletonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final beamColor = Colors.white; // brighter for visible beam

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          return Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(12),
            //   color: baseColor,
            // ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- User info row ---
                Row(
                  children: [
                    _buildShimmerCircle(baseColor, beamColor, 40),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerLine(
                          baseColor,
                          beamColor,
                          height: 12,
                          width: 100,
                        ),
                        const SizedBox(height: 8),
                        _buildShimmerLine(
                          baseColor,
                          beamColor,
                          height: 10,
                          width: 60,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // --- Post image shimmer ---
                _buildShimmerBox(
                  baseColor,
                  beamColor,
                  height: 200,
                  width: double.infinity,
                  radius: 8,
                ),
                const SizedBox(height: 15),

                // --- Caption shimmer lines ---
                _buildShimmerLine(
                  baseColor,
                  beamColor,
                  height: 10,
                  width: double.infinity,
                ),
                const SizedBox(height: 6),
                _buildShimmerLine(baseColor, beamColor, height: 10, width: 150),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Shimmer for circular avatar
  Widget _buildShimmerCircle(Color base, Color beam, double size) {
    return Shimmer(
      duration: const Duration(seconds: 1),
      interval: const Duration(milliseconds: 1), // continuous loop
      color: beam,
      colorOpacity: 0.4, // beam visibility
      direction: const ShimmerDirection.fromLTRB(), // left to right beam
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(color: base, shape: BoxShape.circle),
      ),
    );
  }

  // 🔹 Shimmer for text lines
  Widget _buildShimmerLine(
    Color base,
    Color beam, {
    required double height,
    required double width,
  }) {
    return Shimmer(
      duration: const Duration(seconds: 1),
      interval: const Duration(milliseconds: 1),
      color: beam,
      colorOpacity: 0.4,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  // 🔹 Shimmer for large boxes (image placeholders)
  Widget _buildShimmerBox(
    Color base,
    Color beam, {
    required double height,
    required double width,
    required double radius,
  }) {
    return Shimmer(
      duration: const Duration(seconds: 1),
      interval: const Duration(milliseconds: 1),
      color: beam,
      colorOpacity: 0.4,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
