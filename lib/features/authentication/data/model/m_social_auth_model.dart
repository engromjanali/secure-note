enum SocialMediaType { google, apple, github, discord }

class MSocialAuth {
  final SocialMediaType socialMediaType;
  final String id;
  final String? picture;
  final String? firstName;
  final String? lastName;
  final String? email;

  MSocialAuth({
    required this.socialMediaType,
    required this.id,
    this.picture,
    this.firstName,
    this.lastName,
    this.email,
  });

  Map<String, dynamic> toJson() {
    final String provider = switch (socialMediaType) {
      SocialMediaType.google => "google",
      SocialMediaType.apple => "apple",
      SocialMediaType.github => "githubId",
      SocialMediaType.discord => "discordId",
    };

    return {
      "provider": provider,
      "email": email,
      "providerId": id,
      "name": "${firstName ?? ""} ${lastName ?? ""}",
      "image": picture,
    };
  }
}
