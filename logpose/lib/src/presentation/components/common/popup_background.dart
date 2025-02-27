import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupBackground extends ConsumerWidget {
  const PopupBackground({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: CupertinoColors.white),
    );
  }
}
