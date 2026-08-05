import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<ToggleSidebarEvent>((event, emit) {
      emit(state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed));
    });
    on<UpdateBreadcrumbsEvent>((event, emit) {
      emit(state.copyWith(breadcrumbs: event.breadcrumbs));
    });
    on<SelectMenuItemEvent>((event, emit) {
      emit(state.copyWith(selectedMenuItem: event.menuItem));
    });
  }
}
