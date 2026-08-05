part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class ToggleSidebarEvent extends NavigationEvent {}

class UpdateBreadcrumbsEvent extends NavigationEvent {
  final List<String> breadcrumbs;

  const UpdateBreadcrumbsEvent(this.breadcrumbs);

  @override
  List<Object?> get props => [breadcrumbs];
}

class SelectMenuItemEvent extends NavigationEvent {
  final String menuItem;

  const SelectMenuItemEvent(this.menuItem);

  @override
  List<Object?> get props => [menuItem];
}
