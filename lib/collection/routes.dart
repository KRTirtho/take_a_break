import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:take_a_break/pages/all-set/all_set.dart';
import 'package:take_a_break/pages/break/break.dart';
import 'package:take_a_break/pages/home/home.dart';
import 'package:take_a_break/pages/setup/setup.dart';
import 'package:take_a_break/pages/shell.dart';
import 'package:take_a_break/providers/break_provider.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: "/",
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: "/",
            redirect: (context, state) {
              final breakState = ref.read(breakProvider);
              if (breakState == null) {
                return "/setup";
              }
              return "/home";
            },
            routes: [
              GoRoute(
                path: "setup",
                builder: (context, state) => const SetupPage(),
              ),
              GoRoute(
                path: "home",
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          GoRoute(
            path: "/all-set",
            builder: (context, state) => const AllSetPage(),
          ),
        ],
      ),
      GoRoute(
        path: "/break",
        builder: (context, state) => const BreakPage(),
      ),
    ],
  ),
);
