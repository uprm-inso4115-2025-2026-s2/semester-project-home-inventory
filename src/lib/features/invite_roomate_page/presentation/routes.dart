import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';
import 'package:src/features/invite_roomate_page/presentation/pages/Invite_Roomates_Page.dart';
import 'package:src/features/invite_roomate_page/presentation/pages/invite_response_page.dart';

import '../../../config/injection_dependencies.dart';

var inviteRoommateRoutes = GoRoute(
  path: 'invite_roommate',
  builder: (_, __) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: sl<TodoCubit>())],
      child: const InviteRoommateScreen(),
    );
  },
  routes: [
    GoRoute(
      path: 'view_invites',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        final username = queryParams['username'] ?? '';
        final phone = queryParams['phone'] ?? '';
        final role = queryParams['role'] ?? '';
        return InviteResponseScreen(
          inviterUsername: username,
          inviterPhone: phone,
          inviterRole: role,
        );
      },
    ),
  ],
);
