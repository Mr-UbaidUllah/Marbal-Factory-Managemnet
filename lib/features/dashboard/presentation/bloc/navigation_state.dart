part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  final bool isSidebarCollapsed;
  final List<String> breadcrumbs;
  final String selectedMenuItem;

  const NavigationState({
    this.isSidebarCollapsed = false,
    this.breadcrumbs = const ['Dashboard'],
    this.selectedMenuItem = 'dashboard',
  });

  NavigationState copyWith({
    bool? isSidebarCollapsed,
    List<String>? breadcrumbs,
    String? selectedMenuItem,
  }) {
    return NavigationState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      selectedMenuItem: selectedMenuItem ?? this.selectedMenuItem,
    );
  }

  @override
  List<Object?> get props => [isSidebarCollapsed, breadcrumbs, selectedMenuItem];
}
