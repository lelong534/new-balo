import 'package:flutter/material.dart';
import 'package:flutter_zalo_bloc/friends/widgets/contact.dart';
import 'package:flutter_zalo_bloc/message/widgets/widgets.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_zalo_bloc/post/widgets/posts.dart';
import 'package:flutter_zalo_bloc/search/widgets/search_screen.dart';
import 'package:flutter_zalo_bloc/settings/widgets/more.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.blue,
                Colors.blue.shade300,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Icon(EvaIcons.searchOutline),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm theo tên, số điện thoại ...",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                ),
                onTap: () {
                  showSearch(context: context, delegate: SearchScreen());
                },
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: [
          MessageHomeScreen(),
          Contact(),
          Posts(),
          More(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.messageCircleOutline),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.globe2Outline),
            label: 'Danh bạ',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.calendarOutline),
            label: 'Nhật ký',
          ),
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.settings2Outline),
            label: 'Thêm',
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black26,
        iconSize: 32,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        selectedFontSize: 12,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
