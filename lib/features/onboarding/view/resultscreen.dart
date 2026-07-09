// this file to just that what we are collection for onboarding and then we will use this data to show the result in the result screen
// after mentor review this will be removed

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:move_your_body/features/ai_inference/repositories/tag_setup_repository.dart';
import '../repository/user_repository.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);

    return AppScaffold(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Collected Onboarding Data',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            _DataTile(
              title: 'Username',
              value: state.username?.toString() ?? '',
            ),

            _DataTile(title: 'Age', value: state.age?.toString() ?? ''),

            _DataTile(title: 'Height', value: '${state.height ?? ''} cm'),

            _DataTile(title: 'Weight', value: '${state.weight ?? ''} kg'),

            _DataTile(title: 'Goals', value: state.goalTags.join(', ')),

            _DataTile(title: 'Custom Goal', value: state.customGoal),

            _DataTile(
              title: 'Health Issues',
              value: state.healthIssueTags.join(', '),
            ),

            _DataTile(
              title: 'Custom Health Issue',
              value: state.customHealthIssue,
            ),

            _DataTile(title: 'Difficulty', value: state.difficulty ?? ''),

            _DataTile(title: 'Intensity', value: state.intensity ?? ''),

            _DataTile(
              title: 'Target Body Region',
              value: state.targetBodyRegion.join(', '),
            ),

            _DataTile(title: 'Equipments', value: state.equipments.join(', ')),
            ElevatedButton(
              onPressed: () async {
                await ref.read(userRepositoryProvider).deleteUserData();
                await ref
                    .read(tagSetupRepositoryProvider)
                    .debugPrintAllCachedTags(); 
                // await UserRepository().debugPrintUserData();

              },
              child: const Text('Get Tags details from DB'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataTile extends StatelessWidget {
  const _DataTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 6),

            Text(value.isEmpty ? 'Not Provided' : value),
          ],
        ),
      ),
    );
  }
}
