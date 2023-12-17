import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:ya_meet/pages/chat/page_chat_edit.dart';
import 'package:ya_meet/pages/main/page_chat.dart';
import 'package:ya_meet/pages/main/page_home.dart';
import 'package:ya_meet/pages/main/page_map.dart';
import 'package:ya_meet/pages/map/page_map_edit.dart';
import 'package:ya_meet/pages/map/page_map_detail.dart';
import 'package:ya_meet/pages/member/page_join.dart';
import 'package:ya_meet/pages/member/page_login.dart';
import 'package:ya_meet/pages/page_splash.dart';
import 'package:ya_meet/popup/pop_searchAddress.dart';

import 'common/common.dart';
import 'common/constants.dart';
import 'common/meet.dart';
import 'common/routes.dart';
import 'custom/appbar.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: "assets/config/.env");

  await ScreenUtil.ensureScreenSize();

  await NaverMapSdk.instance.initialize(
      clientId: dotenv.env['naver_map_client_id']!,
      onAuthFailed: (ex) {
        meetlog(ex.toString());
      });

  await Meet.ready();

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('ko', 'KR'),
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '오류가 발생 했습니다.',
                    style: TextStyle(
                      color: const Color(0xFF222222),
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 80.h),
                  Container(
                    margin: EdgeInsets.only(left: 80.w, right: 80.w),
                    height: 500.h,
                    child: kReleaseMode
                        ? const Text('뭔가 잘못 되었습니다.')
                        : SingleChildScrollView(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: errorDetails.exception.toString()));
                                Meet.toast("클립보드에 복사됨");
                              },
                              child: Text(
                                errorDetails.exception.toString(),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ));
  };

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppbarChange()),
    ],
    child: const YaMeet(),
  ));
}

extension MediaQueryHinge on MediaQueryData {
  DisplayFeature? get hinge {
    for (final DisplayFeature e in displayFeatures) {
      if (e.type == DisplayFeatureType.hinge) {
        return e;
      }
    }
    return null;
  }
}

class YaMeet extends StatelessWidget {
  const YaMeet({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var displayFeatures = MediaQuery.of(context).displayFeatures;
    if (displayFeatures.isNotEmpty) {
      if (displayFeatures[0].type == DisplayFeatureType.fold &&
          (displayFeatures[0].state == DisplayFeatureState.postureFlat ||
              displayFeatures[0].state == DisplayFeatureState.postureHalfOpened)) {
        Meet.isFoldTypePhone = true;
      } else {
        Meet.isFoldTypePhone = false;
      }
    } else {
      Meet.isFoldTypePhone = false;
    }

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        // 일반
        // designSize: Size(Consts.designWidth, Consts.designHeight),
        // 폴더블
        splitScreenMode: Meet.isFoldTypePhone ? false : false,
        designSize: Meet.isFoldTypePhone
            ? Size(Consts.designWidth, Consts.designHeight)
            : Size(Consts.designWidth, Consts.designHeight),
        minTextAdapt: true,
        builder: (BuildContext context, __) {
          return MaterialApp(
            title: 'Meet',
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            locale: const Locale('ko', 'KR'),
            supportedLocales: const [
              Locale('ko', 'KR'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            navigatorKey: Meet.navigatorKey,
            initialRoute: ROUTES.SPLASH,
            routes: {
              ROUTES.SPLASH: (context) {
                return const SplashPage();
              },
              ROUTES.MAIN: (context) {
                return AppMain(title: Consts.appTitle);
              },
              ROUTES.LOGIN: (context) {
                return const LoginPage();
              },
              ROUTES.JOIN: (context) {
                return const JoinPage();
              },
              ROUTES.HOME: (context) {
                return const HomePage();
              },
              ROUTES.MAP: (context) {
                return const MapPage();
              },
              ROUTES.MAP_DETAIL: (context) {
                return const DetailMapPage();
              },
              ROUTES.MAP_ADD: (context) {
                return const EditMapPage();
              },
              ROUTES.CHAT_EDIT: (context) {
                return const EditChatPage();
              },
            },
            onGenerateRoute: (settings) {
              if (settings.name == ROUTES.MAP_SEARCH) {
                return PageTransition(
                  child: SearchAddressPopup(arguments: settings.arguments as Map<String, dynamic>?),
                  type: PageTransitionType.scale,
                  alignment: Alignment.center,
                  settings: settings,
                );
              }
            },
            theme: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              popupMenuTheme: const PopupMenuThemeData(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              useMaterial3: false,
              tabBarTheme: TabBarTheme(
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp,
                ),
              ),
              // colorSchemeSeed: Colors.white
            ),
          );
        });
  }
}

class AppMain extends StatefulWidget {
  const AppMain({super.key, required this.title});

  final String title;

  @override
  State<AppMain> createState() => AppMainState();
}

class AppMainState extends State<AppMain> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController tabController;

  List<Widget> screenList = [
    const HomePage(),
    const MapPage(),
    const ChatPage(),
  ];

  Color scaffoldBackgroundColor = const Color(0xFFF7F7F7); // Colors.white;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    Meet.permissionLocationRequest();

    super.initState();

    tabController = TabController(length: 3, vsync: this, animationDuration: const Duration(milliseconds: 0));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onTap(int index) async {
    setState(() {
      Meet.tabbarSelectedIndex = index;
      tabController.index = index;
      meetlog("tab selected :{$index}");

      switch (index) {
        // 홈
        case 0:
          scaffoldBackgroundColor = Colors.white;
          break;
        // 홈
        case 1:
          scaffoldBackgroundColor = const Color(0xFFF7F7F7);
          break;
        // 채팅
        case 2:
          scaffoldBackgroundColor = Colors.white;
          break;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    Meet.appState = state;
    meetlog("didChangeAppLifecycleState: $state");
  }

  Widget meetFab(int currentIdx) {
    return Builder(
      builder: (context) {
        switch (currentIdx) {
          case 1:
            return InkWell(
              onTap: () async {
                // Navigator.pushNamed(context, ROUTES.MAP_SEARCH);
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => KpostalView(
                //       useLocalServer: true,
                //       localPort: 1024,
                //       // kakaoKey: '{Add your KAKAO DEVELOPERS JS KEY}',
                //       callback: (Kpostal result) {
                //         setState(() {
                //           // this.postCode = result.postCode;
                //           // this.address = result.address;
                //           // this.latitude = result.latitude.toString();
                //           // this.longitude = result.longitude.toString();
                //           // this.kakaoLatitude = result.kakaoLatitude.toString();
                //           // this.kakaoLongitude = result.kakaoLongitude.toString();
                //         });
                //
                //         Navigator.pushNamed(context, ROUTES.MAP_ADD);
                //       },
                //     ),
                //   ),
                // );
                Navigator.pushNamed(context, ROUTES.MAP_ADD);
              },
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(80.w),
                  boxShadow: [
                    BoxShadow(color: const Color(0x26000000), spreadRadius: 0, blurRadius: 20.r),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  size: 80.w,
                  color: Colors.blue,
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double labelBottomPadding = 10.h;

    return Scaffold(
      key: Meet.mainStateKey,
      backgroundColor: scaffoldBackgroundColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(100.h), child: appbarSelector(tabController.index)),
      body: SafeArea(
        bottom: false,
        child: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: screenList,
        ),
      ),
      floatingActionButton: meetFab(Meet.tabbarSelectedIndex),
      extendBody: true,
      drawerEnableOpenDragGesture: false,
      bottomNavigationBar: Container(
          height: Platform.isAndroid ? 130.h : 130.h + MediaQuery.of(context).padding.bottom,
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(color: const Color(0x26000000), spreadRadius: 0, blurRadius: 20.r),
            ],
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: const Color(0xff222222),
                unselectedItemColor: const Color(0xff666666),
                selectedFontSize: Consts.fontSizeTabbar,
                unselectedFontSize: Consts.fontSizeTabbar,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
                items: [
                  BottomNavigationBarItem(
                    label: '홈',
                    icon: Icon(Icons.home_outlined, size: 44.w, color: const Color(0xff666666)),
                  ),
                  BottomNavigationBarItem(
                    label: '지도',
                    icon: Icon(Icons.map_outlined, size: 44.w, color: const Color(0xff666666)),
                  ),
                  BottomNavigationBarItem(
                    label: '채팅',
                    icon: Icon(Icons.chat, size: 44.w, color: const Color(0xff666666)),
                  ),
                ],
                currentIndex: Meet.tabbarSelectedIndex,
                onTap: onTap,
              ))),
    );
  }
}
