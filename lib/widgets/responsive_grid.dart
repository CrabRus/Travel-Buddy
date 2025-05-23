import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int portraitCount;
  final int landscapeCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final List<Widget> children;

  const ResponsiveGrid({
    Key? key,
    required this.children,
    this.portraitCount = 1,
    this.landscapeCount = 2,
    this.childAspectRatio = 3,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final crossAxisCount =
        orientation == Orientation.portrait ? portraitCount : landscapeCount;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
