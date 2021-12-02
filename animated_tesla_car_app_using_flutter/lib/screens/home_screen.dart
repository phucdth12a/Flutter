import 'package:animated_tesla_car_app_using_flutter/components/battery_status.dart';
import 'package:animated_tesla_car_app_using_flutter/components/door_lock.dart';
import 'package:animated_tesla_car_app_using_flutter/components/temp_details.dart';
import 'package:animated_tesla_car_app_using_flutter/components/tesla_bottom_navigationbar.dart';
import 'package:animated_tesla_car_app_using_flutter/components/typres.dart';
import 'package:animated_tesla_car_app_using_flutter/components/tyre_psi_card.dart';
import 'package:animated_tesla_car_app_using_flutter/constraint.dart';
import 'package:animated_tesla_car_app_using_flutter/home_controller.dart';
import 'package:animated_tesla_car_app_using_flutter/models/typre_psi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _homeController = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationCoolGlow;

  late AnimationController _tyreAnimationController;
  late Animation<double> _animationTyre1Psi;
  late Animation<double> _animationTyre2Psi;
  late Animation<double> _animationTyre3Psi;
  late Animation<double> _animationTyre4Psi;

  late List<Animation<double>> _tyreAnimation;

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.6, 1.0),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.2, 0.4),
    );

    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.45, 0.65),
    );

    _animationCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.7, 1),
    );
  }

  void setupTyreAnimation() {
    _tyreAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationTyre1Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.34, 0.5),
    );
    _animationTyre2Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.5, 0.66),
    );
    _animationTyre3Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.66, 0.82),
    );
    _animationTyre4Psi = CurvedAnimation(
      parent: _tyreAnimationController,
      curve: const Interval(0.82, 1),
    );
  }

  @override
  void initState() {
    setupBatteryAnimation();
    setupTempAnimation();
    setupTyreAnimation();
    _tyreAnimation = [
      _animationTyre1Psi,
      _animationTyre2Psi,
      _animationTyre3Psi,
      _animationTyre4Psi
    ];
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tyreAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _homeController,
        _batteryAnimationController,
        _tempAnimationController,
        _tyreAnimationController,
      ]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_homeController.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }
              if (index == 2) {
                _tempAnimationController.forward();
              } else if (_homeController.selectedBottomTab == 2 && index != 2) {
                _tempAnimationController.reverse(from: 0.4);
              }
              if (index == 3) {
                _tyreAnimationController.forward();
              } else if (_homeController.selectedBottomTab == 3 && index != 3) {
                _tyreAnimationController.reverse();
              }
              _homeController.showTyreController(index);
              _homeController.tyreStatusController(index);
              _homeController.onBottomNavigationTabChange(index);
            },
            selectedTab: _homeController.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  ),
                  Positioned(
                    left: constraints.maxWidth / 2 * _animationCarShift.value,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.1),
                      child: SvgPicture.asset(
                        "assets/icons/Car.svg",
                        width: double.infinity,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    right: _homeController.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.05
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _homeController.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _homeController.isRightDoorLock,
                        press: _homeController.updateRightDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    left: _homeController.selectedBottomTab == 0
                        ? constraints.maxWidth * 0.05
                        : constraints.maxWidth / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _homeController.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _homeController.isLeftDoorLock,
                        press: _homeController.updateLeftDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    top: _homeController.selectedBottomTab == 0
                        ? constraints.maxHeight * 0.13
                        : constraints.maxHeight / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _homeController.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _homeController.isBonnetDoorLock,
                        press: _homeController.updateBonnetDoorLock,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    bottom: _homeController.selectedBottomTab == 0
                        ? constraints.maxHeight * 0.17
                        : constraints.maxHeight / 2,
                    child: AnimatedOpacity(
                      duration: defaultDuration,
                      opacity: _homeController.selectedBottomTab == 0 ? 1 : 0,
                      child: DoorLock(
                        isLock: _homeController.isTrunkDoorLock,
                        press: _homeController.updateTrunkDoorLock,
                      ),
                    ),
                  ),
                  // Batter
                  Opacity(
                    opacity: _animationBattery.value,
                    child: SvgPicture.asset("assets/icons/Battery.svg",
                        width: constraints.maxWidth * 0.45),
                  ),
                  Positioned(
                    top: 50 * (1 - _animationBatteryStatus.value),
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Opacity(
                      opacity: _animationBatteryStatus.value,
                      child: BatteryStatus(constraints: constraints),
                    ),
                  ),
                  // Temp
                  Positioned(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    top: 60 * (1 - _animationTempShowInfo.value),
                    child: Opacity(
                      opacity: _animationTempShowInfo.value,
                      child: TempDetails(homeController: _homeController),
                    ),
                  ),
                  Positioned(
                    right: -180 * (1 - _animationCoolGlow.value),
                    child: AnimatedSwitcher(
                      duration: defaultDuration,
                      child: _homeController.isCoolSelected
                          ? Image.asset(
                              "assets/images/Cool_glow_2.png",
                              key: UniqueKey(),
                              width: 200,
                            )
                          : Image.asset(
                              "assets/images/Hot_glow_4.png",
                              key: UniqueKey(),
                              width: 200,
                            ),
                    ),
                  ),
                  // Tyre
                  if (_homeController.isShowTyre) ...tyres(constraints),
                  if (_homeController.isShowTyreStatus)
                    GridView.builder(
                      itemCount: 4,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: defaultPadding,
                        crossAxisSpacing: defaultPadding,
                        childAspectRatio:
                            constraints.maxWidth / constraints.maxHeight,
                      ),
                      itemBuilder: (context, index) => ScaleTransition(
                        scale: _tyreAnimation[index],
                        child: TyrePsiCard(
                          isBottomTyre: index > 1,
                          tyrePsi: demoPsiList[index],
                        ),
                      ),
                    ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
