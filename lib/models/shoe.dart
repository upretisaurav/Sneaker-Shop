import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:priority_soft_test/models/review.dart';
import 'package:priority_soft_test/models/shoe_color.dart';

class Shoe {
  final String id; // Document ID
  final DocumentReference brandRef; // Reference to brand document
  final List<DocumentReference> colorRefs; // References to color documents
  final String description;
  final String imageUrl;
  final String name;
  final double price;
  final List<DocumentReference> reviewRefs; // References to review documents
  final List<double> sizes; // Available sizes
  final int totalReviews;

  Shoe({
    required this.id,
    required this.brandRef,
    required this.colorRefs,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.reviewRefs,
    required this.sizes,
    required this.totalReviews,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      id: json['id'],
      brandRef: json['brand'] as DocumentReference,
      colorRefs: (json['colors'] as List)
          .map((color) => color as DocumentReference)
          .toList(),
      description: json['description'],
      imageUrl: json['image_url'],
      name: json['name'],
      price: json['price'].toDouble(),
      reviewRefs: (json['reviews'] as List)
          .map((review) => review as DocumentReference)
          .toList(),
      sizes: (json['sizes'] as List)
          .map<double>((size) => size.toDouble())
          .toList(),
      totalReviews: json['total_reviews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brandRef,
      'colors': colorRefs,
      'description': description,
      'image_url': imageUrl,
      'name': name,
      'price': price,
      'reviews': reviewRefs,
      'sizes': sizes,
      'total_reviews': totalReviews,
    };
  }

  Future<String?> loadImageUrl() async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<String?> loadBrandLogoUrl(DocumentReference brandRef) async {
    try {
      DocumentSnapshot snapshot = await brandRef.get();
      String logoUrl = snapshot['logo_grey_url'];
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(logoUrl);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<double> calculateAverageRating() async {
    if (reviewRefs.isEmpty) {
      return 0;
    }

    double totalRating = 0;

    for (DocumentReference reference in reviewRefs) {
      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        totalRating += snapshot['rating'];
      }
    }

    return totalRating / reviewRefs.length;
  }

  Future<List<Review>> fetchReviews({int? limit}) async {
    List<Review> reviews = [];
    try {
      int numberOfReviewsToFetch = limit ?? reviewRefs.length;
      for (int i = 0;
          i < numberOfReviewsToFetch && i < reviewRefs.length;
          i++) {
        DocumentSnapshot snapshot = await reviewRefs[i].get();
        if (snapshot.exists) {
          reviews.add(Review.fromMap(snapshot.data() as Map<String, dynamic>));
        }
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
    return reviews;
  }

  Future<List<ShoeColor>> getShoeColors() async {
    List<ShoeColor> shoeColors = [];
    try {
      for (DocumentReference colorRef in colorRefs) {
        final snapshot = await colorRef.get();
        if (snapshot.exists) {
          final colorData = snapshot.data() as Map<String, dynamic>;
          final shoeColor = ShoeColor.fromMap(colorData);
          shoeColors.add(shoeColor);
        }
      }
    } catch (e) {
      print('Error getting shoe colors: $e');
    }
    return shoeColors;
  }
}
