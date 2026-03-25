import 'package:get_it/get_it.dart';
import 'package:src/core/data/services/supabase_service.dart';
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
import 'package:src/features/reports/domain/repositories/supabase_report_repository.dart';
import 'package:src/features/reports/domain/repositories/report_repositories.dart';
import 'package:src/features/reports/presentation/cubit/report_list_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// The dependencies of the features might be a bit interleaved because
  /// they're not 100% standalone.

  /// Core Inventory
  // ...

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
