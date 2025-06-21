enum PostType {
  petAppreciation,
  pawsomeExperience,
  protectOurPets,
  communityAnnouncement,
  missingPets,
  foundPets,
  petsForRescue,
  petAdoption,
  petCareInsights,
  callForAid,
  unknown; // Fallback empty

  static PostType fromString(String type) {
    switch (type) {
      case 'Pet Appreciation':
        return PostType.petAppreciation;
      case 'Paw-some Experience':
        return PostType.pawsomeExperience;
      case 'Protect Our Pets: Report Abuse':
        return PostType.protectOurPets;
      case 'Community Announcement':
        return PostType.communityAnnouncement;
      case 'Missing Pets':
        return PostType.missingPets;
      case 'Found Pets':
        return PostType.foundPets;
      case 'Pets For Rescue':
        return PostType.petsForRescue;
      case 'Pet Adoption':
        return PostType.petAdoption;
      case 'Pet Care Insights':
        return PostType.petCareInsights;
      case 'Call for Aid':
        return PostType.callForAid;
      default:
        return PostType.unknown;
    }
  }
}