import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:raggalo/pages/admin_report.dart';
import 'package:raggalo/pages/breeds.dart';
import 'package:raggalo/pages/farmer_feedstuff.dart';
import 'package:raggalo/pages/farmer_report.dart';
import 'package:raggalo/pages/farmer_vets.dart';
import 'package:raggalo/pages/feedstuffs.dart';
import 'package:raggalo/pages/requests.dart';
import 'package:raggalo/pages/users.dart';
import 'package:raggalo/pages/vet_breeds.dart';
import 'package:raggalo/pages/vet_report.dart';
import 'package:raggalo/providers/filter_requests.dart';
import 'package:raggalo/providers/menu.dart';
import 'package:raggalo/providers/profile.dart';
import 'package:raggalo/widgets/navigation.dart';

import 'package:flutter/cupertino.dart';
import 'package:raggalo/widgets/zoom.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _drawerController = ZoomDrawerController();

  var navigationsFarmer = [
    MenuItem("Feedstuff", Icons.list, 0, FarmerFeedstuffPage()),
    MenuItem("Vet services", Icons.card_giftcard, 1, VetServicesPage()),
    MenuItem("Orders", Icons.report, 2, FarmerReportPage()),
  ];

  var navigationsVet = [
    MenuItem("Breeds", Icons.list, 0, VetBreedsPage()),
    MenuItem("Consultations", Icons.card_giftcard, 1, RequestsPage()),
    MenuItem("Reports", Icons.report, 2, VetReportPage()),
  ];

  var navigationsAdmin = [
    MenuItem("Breeds", Icons.list, 0, BreedsPage()),
    MenuItem("Feedstuff", Icons.list, 1, FeedstuffsPage()),
    MenuItem("Users", Icons.card_giftcard, 2, UsersPage()),
    MenuItem("Reports", Icons.report, 3, AdminReportPage()),
  ];

  int _currentPage = 0;
  List<MenuItem> navigations = [];
  Profile _profile;
  int selectedIndex = 0;

  void _updatePage(index) {
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    if (_drawerController != null) {
      _drawerController.toggle();
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _profile = Provider.of<Profile>(context, listen: false);
      switch (_profile.user.role) {
        case "Farmer":
          setState(() {
            navigations = navigationsFarmer;
          });
          break;
        case "Vet":
          setState(() {
            navigations = navigationsVet;
          });
          break;
        case "Admin":
          setState(() {
            navigations = navigationsAdmin;
          });
          break;
        default:
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _profile = Provider.of<Profile>(context);
    var _status = Provider.of<FilterProvider>(context);
    var menuProvider = Provider.of<MenuProvider>(context);
    final rtl = ZoomDrawer.isRTL();
    return navigations.length > 0
        ? ZoomDrawer(
            controller: _drawerController,
            menuScreen: NavigationWidget(
              navigations,
              callback: _updatePage,
              current: _currentPage,
            ),
            mainScreen: Builder(builder: (_context) {
              return ValueListenableBuilder<DrawerState>(
                valueListenable: ZoomDrawer.of(_context).stateNotifier,
                builder: (context, state, child) {
                  return AbsorbPointer(
                    absorbing: state != DrawerState.closed,
                    child: child,
                  );
                },
                child: GestureDetector(
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          ZoomDrawer.of(_context).toggle();
                        },
                      ),
                      title: Text(navigations[menuProvider.currentPage].title),
                      actions: [
                        if (menuProvider.currentPage == 1 &&
                            _profile.user.role == "Vet")
                          PopupMenuButton<String>(
                            icon: Icon(Icons.filter_alt_outlined),
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Text(
                                    "All",
                                    style: TextStyle(
                                      color: _status.currentStatus == "All"
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                  ),
                                  value: "All",
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    "Accepted",
                                    style: TextStyle(
                                      color: _status.currentStatus == "Accepted"
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                  ),
                                  value: "Accepted",
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    "Rejected",
                                    style: TextStyle(
                                      color: _status.currentStatus == "Rejected"
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                  ),
                                  value: "Rejected",
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    "Pending",
                                    style: TextStyle(
                                      color: _status.currentStatus == "Pending"
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                  ),
                                  value: "Pending",
                                ),
                              ];
                            },
                            onSelected: (String value) {
                              _status.updateCurrentStatus(value);
                            },
                          )
                      ],
                    ),
                    body: navigations[menuProvider.currentPage].view,
                  ),
                  onPanUpdate: (details) {
                    if (details.delta.dx < 6 && !rtl ||
                        details.delta.dx < -6 && rtl) {
                      if (ZoomDrawer.of(context) != null) {
                        ZoomDrawer.of(context).toggle();
                      }
                    }
                  },
                ),
              );
            }),
            borderRadius: 24.0,
            showShadow: false,
            angle: 0.0,
            backgroundColor: Colors.grey[300],
            slideWidth: MediaQuery.of(context).size.width *
                (ZoomDrawer.isRTL() ? .45 : 0.65),
          )
        : Center(child: CircularProgressIndicator());
  }
}
