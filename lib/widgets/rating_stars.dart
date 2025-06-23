import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final bool showRating;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.showRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Estrelas
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            final isFilled = rating >= starValue;
            
            return Icon(
              isFilled ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: size,
            );
          }),
        ),
        
        // Rating numérico (opcional)
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
} 