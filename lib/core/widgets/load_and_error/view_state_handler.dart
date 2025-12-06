import 'package:secure_note/core/extensions/ex_expanded.dart';
import 'package:secure_note/core/widgets/load_and_error/models/view_state_model.dart';
import 'package:secure_note/core/widgets/load_and_error/widgets/error_section.dart';
import 'package:secure_note/core/widgets/load_and_error/widgets/loading_widget.dart';
import 'package:secure_note/core/widgets/load_and_error/widgets/no_data_found_section.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewStateHandler extends StatelessWidget {
  final dynamic controller;
  final Function()? onRetry;
  final Widget loadedWidget;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final ViewState? viewState;
  final String? errorMessage;
  final String? emptyMessage;
  final bool Function()? hasData;

  const ViewStateHandler({
    super.key,
    required this.controller,
    required this.onRetry,
    required this.loadedWidget,
    this.loadingWidget,
    this.emptyWidget,
    this.viewState,
    this.errorMessage,
    this.emptyMessage,
    this.hasData,
  });

  Widget _buildShimmer(Widget child) {
    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentState = viewState ?? controller.viewState;
    final hasContent = hasData?.call() ?? false;
    late final Widget child;

    switch (currentState) {
      case ViewState.initial:
        child = const SizedBox.shrink().withKey(
          const ValueKey("viewStateInitial"),
        );
        break;

      case ViewState.loading:
        if (hasContent) {
          // ✅ Data already available → show shimmer on top of loaded widget
          child = _buildShimmer(
            loadedWidget,
          ).withKey(const ValueKey("viewStateLoadingWithExistingData"));
        } else {
          // ⏳ No data yet → show loading placeholder or shimmer
          child = (loadingWidget ?? _buildShimmer(WOnScreenLoading())).withKey(
            const ValueKey("viewStateLoadingNoData"),
          );
        }
        break;

      case ViewState.loaded:
        if (hasContent) {
          child = loadedWidget.withKey(const ValueKey("viewStateLoaded"));
        } else {
          child = (emptyWidget ?? WNoDataFound()).withKey(
            const ValueKey("viewStateLoadedEmpty"),
          );
        }
        break;

      case ViewState.empty:
        child = Align(
          alignment: Alignment.topCenter,
          child: (emptyWidget ?? WNoDataFound()).withKey(
            const ValueKey("viewStateEmpty"),
          ),
        );
        break;

      case ViewState.error:
        child = Center(
          key: const ValueKey("viewStateError"),
          child: WError(
            onRetry: onRetry,
            message: errorMessage ?? "Something went wrong!",
          ),
        );
        break;

      default:
        child = const SizedBox.shrink().withKey(
          const ValueKey("viewStateNone"),
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
