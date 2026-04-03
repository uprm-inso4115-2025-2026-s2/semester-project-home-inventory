import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavTab {
  final String label;
  final IconData icon;
  final String rootPath;

  const MainNavTab({
    required this.label,
    required this.icon,
    required this.rootPath,
  });
}

class MainNavShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<MainNavTab> tabs;

  const MainNavShell({
    super.key,
    required this.navigationShell,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navBarHeight = 80.0 + bottomInset;
    final navLabelStyle =
        theme.textTheme.labelSmall?.copyWith(
          color: theme.scaffoldBackgroundColor,
          fontWeight: FontWeight.w700,
        ) ??
        TextStyle(color: theme.scaffoldBackgroundColor);
    final currentPath = _normalizePath(GoRouterState.of(context).uri.path);
    final shouldShowNavBar = tabs.any(
      (tab) => _normalizePath(tab.rootPath) == currentPath,
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubicEmphasized,
          color: theme.colorScheme.secondary,
          height: shouldShowNavBar ? navBarHeight : 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubicEmphasized,
            offset: shouldShowNavBar ? Offset.zero : const Offset(0, 0.25),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              opacity: shouldShowNavBar ? 1 : 0,
              child: IgnorePointer(
                ignoring: !shouldShowNavBar,
                child: NavigationBar(
                  backgroundColor: theme.colorScheme.secondary,
                  indicatorColor: theme.colorScheme.primary,
                  labelTextStyle: MaterialStatePropertyAll(navLabelStyle),
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                  destinations: tabs
                      .map(
                        (tab) => NavigationDestination(
                          icon: Icon(
                            tab.icon,
                            color: theme.scaffoldBackgroundColor,
                          ),
                          label: tab.label,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _normalizePath(String path) {
    if (path == '/') return path;
    return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
  }
}
