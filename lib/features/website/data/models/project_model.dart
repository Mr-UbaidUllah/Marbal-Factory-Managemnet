import 'package:factory_management/features/website/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.projectType,
    super.completionDate,
    required super.coverImage,
    required super.galleryImages,
    required super.materialsUsed,
    required super.featured,
    required super.active,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      projectType: json['projectType'] as String,
      completionDate: json['completionDate'] != null 
          ? DateTime.parse(json['completionDate'] as String) 
          : null,
      coverImage: json['coverImage'] as String,
      galleryImages: List<String>.from(json['galleryImages'] as List),
      materialsUsed: List<String>.from(json['materialsUsed'] as List),
      featured: json['featured'] as bool,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'projectType': projectType,
      'completionDate': completionDate?.toIso8601String(),
      'coverImage': coverImage,
      'galleryImages': galleryImages,
      'materialsUsed': materialsUsed,
      'featured': featured,
      'active': active,
    };
  }
}
