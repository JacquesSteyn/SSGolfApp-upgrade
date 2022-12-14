import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/state/bottom_navbar_index.provider.dart';

class BottomNavbar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexState = ref.watch(indexStateProvider);
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[900]!)),
        // borderRadius: BorderRadius.circular(12),
        // color: Colors.orange,
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Stats',
            icon: Icon(Icons.bar_chart),
          ),
          BottomNavigationBarItem(
            label: 'Rewards',
            icon: ImageIcon(AssetImage('assets/images/ticket_icon.png')),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: indexState,
        onTap: ref.read(indexStateProvider.notifier).setIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 5,
        backgroundColor:
            Colors.black, //  Color(0xFF232233), //  Color(0xFF1E1A2D),
        // fixedColor: Colors.black,
      ),
    );
  }
}
