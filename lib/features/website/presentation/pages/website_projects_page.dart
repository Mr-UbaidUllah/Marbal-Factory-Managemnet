import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:factory_management/core/router/route_paths.dart';
import 'package:factory_management/core/theme/app_colors.dart';
import 'package:factory_management/core/theme/app_text_styles.dart';
import 'package:factory_management/features/website/presentation/bloc/website_bloc.dart';
import 'package:factory_management/features/website/presentation/bloc/website_event.dart';
import 'package:factory_management/features/website/presentation/bloc/website_state.dart';
import 'package:factory_management/features/website/domain/entities/project.dart';
import 'package:animate_do/animate_do.dart';

class WebsiteProjectsPage extends StatefulWidget {
  const WebsiteProjectsPage({super.key});

  @override
  State<WebsiteProjectsPage> createState() => _WebsiteProjectsPageState();
}

class _WebsiteProjectsPageState extends State<WebsiteProjectsPage> {
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    context.read<WebsiteBloc>().add(GetProjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<WebsiteBloc, WebsiteState>(
        builder: (context, state) {
          if (state.status == WebsiteStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == WebsiteStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Unable to load projects"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<WebsiteBloc>().add(GetProjectsEvent()),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          final allProjects = state.projects;
          if (allProjects.isEmpty) {
            return const Center(child: Text("No projects available yet."));
          }

          final filters = ['All', ...allProjects.map((e) => e.projectType).toSet()];
          final filteredProjects = selectedFilter == 'All'
              ? allProjects
              : allProjects.where((p) => p.projectType == selectedFilter).toList();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeader(context),
              ),
              SliverToBoxAdapter(
                child: _buildFilters(filters),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 40),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = filteredProjects[index];
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        child: _ProjectCard(project: project),
                      );
                    },
                    childCount: filteredProjects.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            child: Text(
              "OUR PROJECTS",
              style: AppTextStyles.label.copyWith(
                color: AppColors.gold,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            child: Text(
              "Showcasing Excellence in Marble & Granite",
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(fontSize: 42, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 20),
          FadeInDown(
            delay: const Duration(milliseconds: 400),
            child: Text(
              "Explore our portfolio of completed residential and commercial projects across the Middle East.",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> filters) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Wrap(
        spacing: 15,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => selectedFilter = filter);
            },
            selectedColor: AppColors.gold,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          );
        }).toList(),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }
}

class _ProjectCard extends StatefulWidget {
  final Project project;
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
      child: GestureDetector(
        onTap: () => context.go('${RoutePaths.projects}/${widget.project.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.1 : 0.05),
                blurRadius: isHovered ? 20 : 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.project.coverImage,
                        fit: BoxFit.cover,
                      ),
                      if (widget.project.featured)
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "FEATURED",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.projectType.toUpperCase(),
                        style: AppTextStyles.label.copyWith(color: AppColors.gold, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.project.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.h3.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            widget.project.location,
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        widget.project.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
