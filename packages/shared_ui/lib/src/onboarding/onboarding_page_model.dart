class OnboardingPageModel {
  final String imageAsset; 
  final String title;
  final String? highlight;
  final String description;
  final double imageWidth;

  const OnboardingPageModel({
    required this.imageAsset,
    required this.title,
    required this.description,
    this.highlight,
    this.imageWidth = 260,
  });
}
