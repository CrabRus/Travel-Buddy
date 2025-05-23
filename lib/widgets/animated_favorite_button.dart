import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool initiallySaved;

  const FavoriteButton({
    super.key,
    this.onPressed,
    this.initiallySaved = false,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initiallySaved;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSave() {
    setState(() {
      _isSaved = !_isSaved;
    });
    _controller.forward().then((_) => _controller.reverse());
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: ElevatedButton.icon(
        onPressed: _toggleSave,
        icon: Icon(
          _isSaved ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
        label: Text(_isSaved ? 'Збережено' : 'Зберегти'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 243, 33, 33),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
