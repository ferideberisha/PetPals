class userModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final String profilePicture;
  final String phoneNumber; // Add phoneNumber attribute

  userModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.profilePicture,
    required this.phoneNumber, // Initialize phoneNumber
  });
}
