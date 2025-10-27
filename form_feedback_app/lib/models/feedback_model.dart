// Data model class to hold all feedback information submitted by the user.
class FeedbackData {
  final String name;
  final String comment;
  final double rating;
  final String email;
  final String role;
  final String productQuality;
  final String customerSupportRating;
  
  FeedbackData({
    required this.name,
    required this.comment,
    required this.rating,
    required this.email,
    required this.role,
    required this.productQuality,
    required this.customerSupportRating,
  });
}