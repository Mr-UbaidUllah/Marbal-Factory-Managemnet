import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';
import 'package:animate_do/animate_do.dart';

class WebsiteProjectDetailsPage extends StatefulWidget {
  final String projectId;
  const WebsiteProjectDetailsPage({super.key, required this.projectId});

  @override
  State<WebsiteProjectDetailsPage> createState() => _WebsiteProjectDetailsPageState();
}

class _WebsiteProjectDetailsPageState extends State<WebsiteProjectDetailsPage> {
  int selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<WebsiteBloc>().add(GetProjectDetailsEvent(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text("Project Details", style: AppTextStyles.h3.copyWith(color: Colors.black)),
      ),
      body: BlocBuilder<WebsiteBloc, WebsiteState>(
        builder: (context, state) {
          if (state.status == WebsiteStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WebsiteStatus.failure || state.selectedProject == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Unable to load project details"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<WebsiteBloc>().add(GetProjectDetailsEvent(widget.projectId)),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final project = state.selectedProject!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGallery(project),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 900) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildProjectInfo(project)),
                            const SizedBox(width: 60),
                            Expanded(flex: 1, child: _buildProjectSidebar(project)),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProjectInfo(project),
                            const SizedBox(height: 40),
                            _buildProjectSidebar(project),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGallery(Project project) {
    final images = project.galleryImages.isNotEmpty ? project.galleryImages : [project.coverImage];
    
    return Column(
      children: [
        Container(
          height: 600,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              images[selectedImageIndex],
              key: ValueKey(images[selectedImageIndex]),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        if (images.length > 1)
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 80),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = selectedImageIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedImageIndex = index),
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? AppColors.gold : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(images[index], fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProjectInfo(Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInLeft(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              project.projectType.toUpperCase(),
              style: AppTextStyles.label.copyWith(color: AppColors.gold, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInLeft(
          delay: const Duration(milliseconds: 200),
          child: Text(
            project.title,
            style: AppTextStyles.h1.copyWith(fontSize: 48),
          ),
        ),
        const SizedBox(height: 30),
        FadeInLeft(
          delay: const Duration(milliseconds: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overview", style: AppTextStyles.h3),
              const SizedBox(height: 15),
              Text(
                project.description,
                style: AppTextStyles.bodyLarge.copyWith(height: 1.8, color: Colors.grey[800]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        if (project.materialsUsed.isNotEmpty)
          FadeInLeft(
            delay: const Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Materials Used", style: AppTextStyles.h3),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: project.materialsUsed.map((material) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Text(material, style: AppTextStyles.bodyMedium),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProjectSidebar(Project project) {
    return FadeInRight(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(Icons.location_on_outlined, "Location", project.location),
            const Divider(height: 40),
            _buildDetailItem(Icons.category_outlined, "Project Type", project.projectType),
            const Divider(height: 40),
            if (project.completionDate != null) ...[
              _buildDetailItem(
                Icons.calendar_today_outlined,
                "Completion Date",
                "${project.completionDate!.day}/${project.completionDate!.month}/${project.completionDate!.year}",
              ),
              const Divider(height: 40),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                   context.go('/quote-request');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Request a Similar Project", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 24),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
