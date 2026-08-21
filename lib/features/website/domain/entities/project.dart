import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final String location;
  final String projectType;
  final DateTime? completionDate;
  final String coverImage;
  final List<String> galleryImages;
  final List<String> materialsUsed;
  final bool featured;
  final bool active;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.projectType,
    this.completionDate,
    required this.coverImage,
    required this.galleryImages,
    required this.materialsUsed,
    required this.featured,
    required this.active,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        projectType,
        completionDate,
        coverImage,
        galleryImages,
        materialsUsed,
        featured,
        active,
      ];
}
