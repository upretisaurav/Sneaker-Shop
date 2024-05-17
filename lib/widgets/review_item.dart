import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:priority_soft_test/models/review.dart';
import 'package:priority_soft_test/utils/constants/sizes.dart';

Widget buildReviewItem(Review review) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(review.profilePictureUrl),
        ),
        const SizedBox(width: Sizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(review.timestamp),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: Sizes.fontSize12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.xs),
              Row(
                children: List.generate(
                  review.rating,
                  (index) => const Icon(Icons.star, color: Colors.amber),
                ),
              ),
              const SizedBox(height: Sizes.sm),
              Text(
                review.comment,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
