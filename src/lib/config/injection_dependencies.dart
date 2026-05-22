import 'package:get_it/get_it.dart';
import 'package:src/core/data/services/auth_service.dart';
import 'package:src/core/data/services/supabase_service.dart';
import 'package:src/features/auth/data/datasources/auth_data_sources.dart';
import 'package:src/features/auth/data/datasources/supabase_auth_data_sources.dart';
import 'package:src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:src/features/auth/domain/repositories/auth_repository.dart';
import 'package:src/features/auth/domain/usecases/get_current_user.dart';
import 'package:src/features/auth/domain/usecases/sign_in.dart';
import 'package:src/features/auth/domain/usecases/sign_out.dart';
import 'package:src/features/auth/domain/usecases/sign_up.dart';
import 'package:src/features/auth/domain/usecases/watch_current_user.dart';
import 'package:src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:src/features/example_feature/data/data_sources/todo_data_source.dart';
import 'package:src/features/example_feature/data/repositories/todo_repository_impl.dart';
import 'package:src/features/example_feature/domain/repositories/todo_repository.dart';
import 'package:src/features/example_feature/domain/usecases/create_todo.dart';
import 'package:src/features/example_feature/domain/usecases/mark_todo_completed.dart';
import 'package:src/features/example_feature/domain/usecases/remove_todo.dart';
import 'package:src/features/example_feature/domain/usecases/stream_todos.dart';
import 'package:src/features/example_feature/domain/usecases/unmark_todo_completed.dart';
import 'package:src/features/example_feature/domain/usecases/update_todo.dart';
import 'package:src/features/example_feature/presentation/cubits/todo_cubit.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';
import 'package:src/features/reports/domain/repositories/supabase_report_repository.dart';
import 'package:src/features/reports/domain/repositories/report_repositories.dart';
import 'package:src/features/reports/presentation/cubit/report_list_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:src/features/core_inventory/data/data_sources/inventory_supabase_datasource.dart';
import 'package:src/features/core_inventory/data/data_sources/product_supabase_datasource.dart';
import 'package:src/features/core_inventory/data/repositories/inventory_repository_impl.dart';
import 'package:src/features/core_inventory/data/repositories/product_repository_impl.dart';
import 'package:src/features/core_inventory/domain/repositories/inventory_repositories.dart';
import 'package:src/features/core_inventory/domain/repositories/product_repository.dart';
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items.dart';
import 'package:src/features/core_inventory/domain/usecases/get_inventory_items_by_identifier.dart';
import 'package:src/features/core_inventory/domain/usecases/add_inventory_item.dart';
import 'package:src/features/core_inventory/domain/usecases/update_inventory_item.dart';
import 'package:src/features/core_inventory/domain/usecases/delete_inventory_item.dart';
import 'package:src/features/core_inventory/presentation/cubits/inventory_cubit.dart';
import 'package:src/features/dashboard/domain/repositories/dashboard_repositories.dart';
import 'package:src/features/dashboard/data/dashboard_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initializing backend specifics
  await Supabase.initialize(
    url: 'https://qieckuegdgcefdkqnsav.supabase.co',
    anonKey: 'sb_publishable_1w1-TrfGRbG2nvDv-UUMVQ_EE2lj-HB',
  );

  // Register SupabaseClient (FIX: added this line)
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Registering the app's Services
  sl.registerSingleton<SupabaseService>(
    SupabaseService(Supabase.instance.client),
  );

  /// AUTH

  sl.registerSingleton<AuthService>(AuthService(sl()));

  sl.registerSingleton<AuthDataSource>(SupabaseAuthDataSource(sl()));

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(dataSource: sl()));

  sl.registerSingleton<SignIn>(SignIn(sl()));
  sl.registerSingleton<SignOut>(SignOut(sl()));
  sl.registerSingleton<SignUp>(SignUp(sl()));
  sl.registerSingleton<GetCurrentUser>(GetCurrentUser(sl()));
  sl.registerSingleton<WatchCurrentUser>(WatchCurrentUser(sl()));

  sl.registerSingleton<AuthCubit>(
    AuthCubit(
      signInUseCase: sl(),
      signOutUseCase: sl(),
      signUpUseCase: sl(),
      getCurrentUserUseCase: sl(),
      watchCurrentUserUseCase: sl(),
    ),
  );

  // Initialize AuthCubit so it loads current auth state and starts
  // watching for auth changes at app startup.
  sl<AuthCubit>().initialize();

  /// SAMPLE FEATURE

  // Data Sources
  sl.registerSingleton<TodoDataSource>(TodoDataSource(sl()));

  // Repositories
  sl.registerSingleton<TodoRepository>(TodoRepositoryImpl(sl()));

  // Use-cases
  sl.registerSingleton<StreamTodos>(StreamTodos(sl()));
  sl.registerSingleton<CreateTodo>(CreateTodo(sl()));
  sl.registerSingleton<RemoveTodo>(RemoveTodo(sl()));
  sl.registerSingleton<UpdateTodo>(UpdateTodo(sl()));
  sl.registerSingleton<MarkTodoCompleted>(MarkTodoCompleted(sl()));
  sl.registerSingleton<UnmarkTodoCompleted>(UnmarkTodoCompleted(sl()));

  // Blocs/Cubits
  sl.registerSingleton<TodoCubit>(
    TodoCubit(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  sl.registerSingleton<GroceryListCubit>(GroceryListCubit());

  /// The dependencies of the features might be a bit interleaved because
  /// they're not 100% standalone.

  /// Core Inventory
  // Data Sources
  sl.registerLazySingleton<ProductSupabaseDataSource>(
    () => ProductSupabaseDataSource(sl()),
  );
  sl.registerLazySingleton<InventorySupabaseDataSource>(
    () => InventorySupabaseDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      sl<InventorySupabaseDataSource>(),
      sl<ProductRepository>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton<GetInventoryItems>(() => GetInventoryItems(sl()));
  sl.registerLazySingleton<GetInventoryItemsByIdentifier>(
    () => GetInventoryItemsByIdentifier(sl()),
  );
  sl.registerLazySingleton<AddInventoryItem>(() => AddInventoryItem(sl()));
  sl.registerLazySingleton<UpdateInventoryItem>(
    () => UpdateInventoryItem(sl()),
  );
  sl.registerLazySingleton<DeleteInventoryItem>(
    () => DeleteInventoryItem(sl()),
  );

  // Cubit
  sl.registerLazySingleton<InventoryCubit>(
    () => InventoryCubit(
      getInventoryItems: sl(),
      getInventoryItemsByIdentifier: sl(),
      addInventoryItem: sl(),
      updateInventoryItem: sl(),
      deleteInventoryItem: sl(),
    ),
  );

  /// Alerts and Restock
  // ...

  /// Sharing and Budget
  // ...

  /// Reports and Insights
  sl.registerLazySingleton<ReportRepository>(
    () => SupabaseReportRepository(sl<SupabaseClient>()),
  );

  sl.registerFactory<ReportListCubit>(
    () => ReportListCubit(sl<ReportRepository>()),
  );
}
