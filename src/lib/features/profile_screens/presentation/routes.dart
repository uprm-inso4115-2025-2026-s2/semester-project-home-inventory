import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:src/config/injection_dependencies.dart';
import 'package:src/features/auth/domain/usecases/get_current_user.dart';
import 'package:src/features/auth/domain/usecases/sign_out.dart';
import 'package:src/features/invite_roomate_page/presentation/routes.dart';
import 'cubit/profile_cubit.dart';
import 'pages/account_info_page.dart';
import 'pages/help_page.dart';
import 'pages/profile_menu_page.dart';
import 'pages/settings_page.dart';

abstract final class ProfileRoutes {
  static const String menuName = 'profile_menu';
  static const String accountInfoName = 'profile_account_info';
  static const String settingsName = 'profile_settings';
  static const String helpName = 'profile_help';

  static const String menuPath = '/profile';
  static const String accountInfoSegment = 'account-info';
  static const String settingsSegment = 'settings';
  static const String helpSegment = 'help';

  static const String accountInfoPath = '$menuPath/$accountInfoSegment';
  static const String settingsPath = '$menuPath/$settingsSegment';
  static const String helpPath = '$menuPath/$helpSegment';
  static const String inviteRoommatePath = '$menuPath/invite_roommate';
}

ProfileCubit _buildCubit() => ProfileCubit(
      getCurrentUserUseCase: sl<GetCurrentUser>(),
      signOutUseCase: sl<SignOut>(),
    )..loadProfile();

final GoRoute profileRoutes = GoRoute(
  path: ProfileRoutes.menuPath,
  name: ProfileRoutes.menuName,
  builder: (context, state) => BlocProvider(
    create: (_) => _buildCubit(),
    child: const ProfileMenuPage(),
  ),
  routes: [
    GoRoute(
      path: ProfileRoutes.accountInfoSegment,
      name: ProfileRoutes.accountInfoName,
      builder: (context, state) => BlocProvider(
        create: (_) => _buildCubit(),
        child: const AccountInfoPage(),
      ),
    ),
    GoRoute(
      path: ProfileRoutes.settingsSegment,
      name: ProfileRoutes.settingsName,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: ProfileRoutes.helpSegment,
      name: ProfileRoutes.helpName,
      builder: (context, state) => const HelpPage(),
    ),
    inviteRoommateRoutes,
  ],
);
