import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';

class ProjectShowcase extends StatelessWidget {
  const ProjectShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {
        'title': 'The Grand Plaza Hotel',
        'location': 'Dubai, UAE',
        'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=1000&auto=format&fit=crop',
        'category': 'Commercial',
      },
      {
        'title': 'Luxury Villa Skyline',
        'location': 'Doha, Qatar',
        'image': 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=1000&auto=format&fit=crop',
        'category': 'Residential',
      },
      {
        'title': 'Modern Office Complex',
        'location': 'Riyadh, Saudi Arabia',
        'image': 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=1000&auto=format&fit=crop',
        'category': 'Office',
      },
      {
        'title': 'Royal Mosque Marble',
        'location': 'Abu Dhabi, UAE',
        'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=1000&auto=format&fit=crop',
        'category': 'Religious',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
      color: Colors.white,
      child: Column(
        children: [
          FadeInUp(
            child: Column(
              children: [
                Text(
                  "OUR PORTFOLIO",
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Iconic Projects Delivered",
                  style: AppTextStyles.h2.copyWith(fontSize: 42, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 1.5,
            ),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                delay: Duration(milliseconds: 200 * index),
                child: _ProjectCard(project: projects[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 800),
              child: Image.network(
                widget.project['image'],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(isHovered ? 0.8 : 0.4),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 40,
              right: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.project['category'].toUpperCase(),
                      style: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.project['title'],
                    style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 32),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        widget.project['location'],
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                  if (isHovered)
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("View Project Details"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
