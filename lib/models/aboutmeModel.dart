class AboutMeFormData {
  final String aboutMe;
  final String otherInfo;
  final List<String> selectedSizes;
  final List<String> selectedPetNumbers;
  final List<String> selectedSkills;

  AboutMeFormData({
    required this.aboutMe,
    required this.otherInfo,
    required this.selectedSizes,
    required this.selectedPetNumbers,
    required this.selectedSkills,
  });

  Map<String, dynamic> toMap() {
    return {
      'aboutMe': aboutMe,
      'otherInfo': otherInfo,
      'selectedSizes': selectedSizes,
      'selectedPetNumbers': selectedPetNumbers,
      'selectedSkills': selectedSkills,
    };
  }

  factory AboutMeFormData.fromMap(Map<String, dynamic> map) {
    return AboutMeFormData(
      aboutMe: map['aboutMe'] ?? '',
      otherInfo: map['otherInfo'] ?? '',
      selectedSizes: List<String>.from(map['selectedSizes'] ?? []),
      selectedPetNumbers: List<String>.from(map['selectedPetNumbers'] ?? []),
      selectedSkills: List<String>.from(map['selectedSkills'] ?? []),
    );
  }
}
