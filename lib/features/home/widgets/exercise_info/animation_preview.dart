import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:move_your_body/core/model/exercise_data.dart';
import 'package:move_your_body/features/home/view_model/session_details_view_model.dart';
import 'package:move_your_body/core/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class AnimationPreview extends ConsumerStatefulWidget {
  final Exercise exercise;
  final double? height;

  const AnimationPreview({super.key, required this.exercise, this.height = 280});

  @override
  ConsumerState<AnimationPreview> createState() => _AnimationPreviewState();
}

class _AnimationPreviewState extends ConsumerState<AnimationPreview> {
  VideoPlayerController? _videoController;
  File? _animationFile;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (!widget.exercise.isLottie && widget.exercise.animationLink.isNotEmpty) {
      _loadAnimation();
    }
  }

  @override
  void didUpdateWidget(AnimationPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.exerciseId != widget.exercise.exerciseId) {
      final oldController = _videoController;
      _videoController = null;
      _animationFile = null;
      _hasError = false;
      
      oldController?.dispose();

      if (!widget.exercise.isLottie && widget.exercise.animationLink.isNotEmpty) {
        _loadAnimation();
      }
    }
  }

  Future<void> _loadAnimation() async {
    try {
      final file = await ref.read(
        animationFileProvider(widget.exercise.animationLink).future,
      );

      _animationFile = file;

      final url = widget.exercise.animationLink.toLowerCase();

      if (url.endsWith('.mp4')) {
        _videoController = VideoPlayerController.file(file);

        await _videoController!.initialize();
        await _videoController!.setLooping(true);
        await _videoController!.setVolume(0);
        await _videoController!.play();
      }

      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height, 
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (widget.exercise.isLottie) {
      return Lottie.asset(
        'assets/animations/${widget.exercise.exerciseId}.json',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _placeholder('Animation not available'),
      );
    }

    if (widget.exercise.animationLink.isEmpty) {
      return _placeholder('No animation available');
    }

    if (_hasError) {
      return _placeholder('Failed to load animation');
    }

    if (_animationFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final url = widget.exercise.animationLink.toLowerCase();

    if (url.endsWith('.png')) {
      return Image.file(_animationFile!, fit: BoxFit.contain);
    }

    if (url.endsWith('.mp4')) {
      if (_videoController == null || !_videoController!.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    return _placeholder('Unsupported animation format');
  }

  Widget _placeholder(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center_rounded,
            color: AppColors.primary.withValues(alpha: 0.4),
            size: 64,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
