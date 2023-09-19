import 'package:animations/animations.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ContainerTransitionSample extends StatefulWidget {
  const ContainerTransitionSample({super.key});

  @override
  State<ContainerTransitionSample> createState() => _ContainerTransitionSampleState();
}

class _ContainerTransitionSampleState extends State<ContainerTransitionSample> {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
