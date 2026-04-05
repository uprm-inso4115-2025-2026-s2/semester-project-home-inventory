import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DASHBOARD TEST SCREEN")),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return Column(
              children: [
                // 🔹 FILTER SECTION
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildFilters(context),
                ),

                // 🔹 ITEMS LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(title: Text(item.toString()));
                    },
                  ),
                ),
              ],
            );
          }
          if (state is DashboardError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    String? selectedCategory;
    String? selectedRoom;
    DateTime? startDate;
    DateTime? endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Category"),
          items: ["Electronics", "Furniture", "Clothing"]
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
          onChanged: (value) {
            selectedCategory = value;
          },
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Room"),
          items: ["Living Room", "Bedroom", "Kitchen"]
              .map((room) => DropdownMenuItem(value: room, child: Text(room)))
              .toList(),
          onChanged: (value) {
            selectedRoom = value;
          },
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<DashboardCubit>().applyFilters(
                  category: selectedCategory,
                  room: selectedRoom,
                  startDate: startDate,
                  endDate: endDate,
                );
              },
              child: const Text("Apply Filters"),
            ),

            const SizedBox(width: 12),

            OutlinedButton(
              onPressed: () {
                context.read<DashboardCubit>().clearFilters();
              },
              child: const Text("Clear"),
            ),
          ],
        ),
      ],
    );
  }
}
