import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex_vote/consts/conts.dart';
import 'package:nex_vote/pages/history_page.dart';
import 'package:nex_vote/pages/home_page.dart';
import 'package:nex_vote/pages/proposal_page.dart';
import 'package:nex_vote/pages/vote_page.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void _navigateToPage(int index) {
    pageController.jumpToPage(index);
  }

  List<CollapsibleItem> _buildCollapsibleItems() {
    return [
      CollapsibleItem(
        text: 'Home',
        icon: Icons.home,
        onPressed: () => _navigateToPage(0),
        isSelected: true,
      ),
      CollapsibleItem(
        text: 'Elections',
        icon: Icons.history_edu_sharp,
        onPressed: () => _navigateToPage(1),
      ),
      CollapsibleItem(
        text: 'Vote',
        icon: Icons.how_to_vote_sharp,
        onPressed: () => _navigateToPage(2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColorsHome.backgroundColor,
      body: Stack(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 70),
              child: PageView(
                controller: pageController,
                children: [
                  HomePage(),
                  ProposalPage(),
                  VotePage(),
                ],
              ),
            ),
          ),
          CollapsibleSidebar(
            items: _buildCollapsibleItems(),
            showTitle: false,
            sidebarBoxShadow: [],
            borderRadius: 0,
            screenPadding: 0,
            body: SizedBox.shrink(),
            backgroundColor: ThemeColorsHome.backgroundColor,
            avatarBackgroundColor: ThemeNavColors.cardBackgroundColor!,
            selectedIconBox: ThemeNavColors.selectedIconBox,
            selectedIconColor: ThemeNavColors.selectedIconColor,
            selectedTextColor: ThemeNavColors.selectedTextColor,
            unselectedIconColor: ThemeNavColors.unselectedIconColor,
            unselectedTextColor: ThemeNavColors.unselectedTextColor,
            badgeBackgroundColor: ThemeNavColors.badgeBackgroundColor,
            badgeTextColor: ThemeNavColors.badgeTextColor,
            minWidth: 70,
            maxWidth: 250,
            iconSize: 30,
            textStyle: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            toggleTitleStyle: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),

        ],
      ),
    );
  }
}
