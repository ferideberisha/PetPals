class userModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final String profilePicture; // Add profilePicture attribute

  userModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.profilePicture, // Initialize profilePicture
  });
}
