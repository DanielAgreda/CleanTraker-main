import 'package:go_router/go_router.dart';
import '../features/auth/auth_screen.dart';
import '../features/auth/tracker_provider.dart';
import '../features/home/home_tracker_screen.dart';
import '../features/routes_search/search_route_screen.dart';

class AppRouter {
  static GoRouter createRouter(TrackerProvider provider) {
    return GoRouter(
      initialLocation: '/home',
      refreshListenable: provider,
      redirect: (context, state) {
        final loggedIn = provider.isAuthenticated;
        final goingToAuth = state.matchedLocation == '/auth';

        if (!loggedIn && !goingToAuth) {
          return '/auth';
        }
        if (loggedIn && goingToAuth) {
          return provider.selectedAddress != null ? '/home' : '/search-route';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/search-route',
          builder: (context, state) => const SearchRouteScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeTrackerScreen(),
        ),
      ],
    );
  }
}
