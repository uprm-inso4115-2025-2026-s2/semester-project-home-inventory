import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/report_list_cubit.dart';
import '/../config/injection_dependencies.dart'; // Ajusta la ruta según tu proyecto

//Only for Testing Purposes, not oficial Report Page

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportListCubit>()..loadReports(),
      child: const _ReportListView(),
    );
  }
}

class _ReportListView extends StatefulWidget {
  const _ReportListView();

  @override
  State<_ReportListView> createState() => _ReportListViewState();
}

class _ReportListViewState extends State<_ReportListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<ReportListCubit>().search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or description...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // Forzar búsqueda vacía
                          context.read<ReportListCubit>().search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ReportListCubit, ReportListState>(
        builder: (context, state) {
          if (state is ReportListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReportListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ReportListLoaded) {
            final reports = state.reports;
            if (reports.isEmpty) {
              return const Center(
                child: Text('No reports found.'),
              );
            }
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  title: Text(report.title),
                  subtitle: Text(report.description),
                  onTap: () {
                    // Navegar a detalle del reporte (opcional)
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}