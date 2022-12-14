import 'package:flutter_riverpod/flutter_riverpod.dart';

class IndexState extends StateNotifier<int> {
  IndexState() : super(0);

  void setIndex(int value) {
    state = value;
  }
}

final indexStateProvider =
    StateNotifierProvider<IndexState, int>((ref) => IndexState());
