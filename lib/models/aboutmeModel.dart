import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petpals/models/userModel.dart';

class AboutMeFormData {
  String? userId; // Make userId nullable

  String aboutMe;
  String otherInfo; // New field for other information
  List<String> selectedSizes;
  List<String> selectedPetNumbers;
  List<String> selectedSkills;

  // Updated constructor to accept nullable userId
  AboutMeFormData({
    required this.aboutMe,
    required this.otherInfo,
    required this.selectedSizes,
    required this.selectedPetNumbers,
    required this.selectedSkills,
    this.userId, // Make userId nullable
  });

  // Convert AboutMeFormData to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'aboutMe': aboutMe,
      'otherInfo': otherInfo,
      'selectedSizes': selectedSizes,
      'selectedPetNumbers': selectedPetNumbers,
      'selectedSkills': selectedSkills,
    };
  }

  // Create AboutMeFormData object from Firestore snapshot
  factory AboutMeFormData.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AboutMeFormData(
      userId: data['userId'] ?? '',
      aboutMe: data['aboutMe'] ?? '',
      otherInfo: data['otherInfo'] ?? '',
      selectedSizes: List<String>.from(data['selectedSizes'] ?? []),
      selectedPetNumbers: List<String>.from(data['selectedPetNumbers'] ?? []),
      selectedSkills: List<String>.from(data['selectedSkills'] ?? []),
    );
  }

  // Named constructor to create AboutMeFormData with userId from UserModel
  factory AboutMeFormData.fromUserModel(UserModel user, {
    required String aboutMe,
    required String otherInfo,
    required List<String> selectedSizes,
    required List<String> selectedPetNumbers,
    required List<String> selectedSkills,
  }) {
    return AboutMeFormData(
      userId: user.uid,
      aboutMe: aboutMe,
      otherInfo: otherInfo,
      selectedSizes: selectedSizes,
      selectedPetNumbers: selectedPetNumbers,
      selectedSkills: selectedSkills,
    );
  }
}
