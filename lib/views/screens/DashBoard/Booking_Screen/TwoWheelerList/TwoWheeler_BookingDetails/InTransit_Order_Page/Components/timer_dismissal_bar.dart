import 'package:flutter/material.dart';

class TimedDismissibleBar extends StatefulWidget {
  final DateTime accepted;
  const TimedDismissibleBar({super.key, required this.accepted});

  @override
  State<TimedDismissibleBar> createState() => _TimedDismissibleBarState();
}

class _TimedDismissibleBarState extends State<TimedDismissibleBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _offsetAnimation;
  late int remainingSeconds;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 1), // Slide down
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _startTimer();
  }

  void _startTimer() {
    final now = DateTime.now();
    final elapsed = now.difference(widget.accepted).inSeconds;
    remainingSeconds = (30 - elapsed).clamp(0, 30);
    if (remainingSeconds <= 0) {
      setState(() => isVisible = false);
      return;
    }

    Future.delayed(Duration(seconds: remainingSeconds), () {
      if (mounted) {
        _slideController.forward();
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) setState(() => isVisible = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return SizedBox();

    double initialProgress = (1 - (remainingSeconds / 30)).clamp(0.0, 1.0);

    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        height: 60,
        color: Colors.red,
        child: Stack(
          children: [
            Container(
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: initialProgress, end: 1.0),
              duration: Duration(seconds: remainingSeconds),
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            Center(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
