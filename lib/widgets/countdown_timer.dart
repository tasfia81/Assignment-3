import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime targetDateTime;
  final bool isExpanded;
  final VoidCallback? onTimerFinished;

  const CountdownTimer({
    super.key,
    required this.targetDateTime,
    this.isExpanded = false,
    this.onTimerFinished,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetDateTime != widget.targetDateTime) {
      _calculateTimeRemaining();
    }
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    if (widget.targetDateTime.isAfter(now)) {
      _timeRemaining = widget.targetDateTime.difference(now);
    } else {
      _timeRemaining = Duration.zero;
      widget.onTimerFinished?.call();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _calculateTimeRemaining();
          if (_timeRemaining == Duration.zero) {
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    final int hours = _timeRemaining.inHours;
    final int minutes = _timeRemaining.inMinutes.remainder(60);
    final int seconds = _timeRemaining.inSeconds.remainder(60);

    if (!widget.isExpanded) {
      // Compact mode for Feed Product Cards
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(3.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt, size: 11.r, color: Colors.white),
            Text(
              '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    // Expanded mode for Detail Screen Banner
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeBox(_twoDigits(hours)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildTimeBox(_twoDigits(minutes)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Text(
            ':',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildTimeBox(_twoDigits(seconds)),
      ],
    );
  }

  Widget _buildTimeBox(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
