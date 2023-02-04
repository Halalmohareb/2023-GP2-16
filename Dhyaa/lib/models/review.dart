class Review {
  late String id;
  late String userId;
  late String reviewerId;
  late String reviewerName;
  late String stars;
  late String review;
  late String createdAt;

  Review(
    this.userId,
    this.reviewerId,
    this.reviewerName,
    this.stars,
    this.review,
    this.createdAt,
  );

  Review.fromMap(dynamic obj) {
    userId = obj['userId'];
    reviewerId = obj['reviewerId'];
    reviewerName = obj['reviewerName'];
    stars = obj['stars'];
    review = obj['review'];
    createdAt = obj['createdAt'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['userId'] = this.userId;
    map['reviewerId'] = this.reviewerId;
    map['reviewerName'] = this.reviewerName;
    map['stars'] = this.stars;
    map['review'] = this.review;
    map['createdAt'] = this.createdAt;
    return map;
  }
}
