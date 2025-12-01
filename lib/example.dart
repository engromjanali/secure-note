import 'package:flutter/material.dart';

class MultiFabDemo extends StatefulWidget {
  const MultiFabDemo({super.key});

  @override
  State<MultiFabDemo> createState() => _MultiFabDemoState();
}

class _MultiFabDemoState extends State<MultiFabDemo>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fabAnimation;
  late Animation<double> _fadeAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fabAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multiple FAB Demo")),
      body: const Center(child: Text("Your Content Here")),

      floatingActionButton: _buildMultiFab(),
    );
  }

  Widget _buildMultiFab() {
    return SizedBox(
      height: 180,
      width: 60,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 🟢 FAB 1
          Positioned(
            bottom: 120,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FloatingActionButton.small(
                  heroTag: "fab1",
                  onPressed: () {
                    debugPrint("FAB 1 pressed");
                  },
                  child: const Icon(Icons.edit),
                ),
              ),
            ),
          ),

          // 🔵 FAB 2
          Positioned(
            bottom: 65,
            child: ScaleTransition(
              scale: _fabAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FloatingActionButton.small(
                  heroTag: "fab2",
                  onPressed: () {
                    debugPrint("FAB 2 pressed");
                  },
                  child: const Icon(Icons.camera_alt),
                ),
              ),
            ),
          ),

          // ⚫ Main FAB
          FloatingActionButton(
            heroTag: "main",
            onPressed: _toggle,
            child: AnimatedRotation(
              turns: _isOpen ? 0.125 : 0.0, // + to X
              duration: const Duration(milliseconds: 250),
              child: const Icon(Icons.add, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
