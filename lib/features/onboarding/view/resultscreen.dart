import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../view_model/onboarding_view_model.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // final colorScheme = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    return AppScaffold(

      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 70 + bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
