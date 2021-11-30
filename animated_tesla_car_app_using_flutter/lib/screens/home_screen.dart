import 'package:animated_tesla_car_app_using_flutter/components/battery_status.dart';
import 'package:animated_tesla_car_app_using_flutter/components/door_lock.dart';
import 'package:animated_tesla_car_app_using_flutter/components/tesla_bottom_navigationbar.dart';
import 'package:animated_tesla_car_app_using_flutter/constraint.dart';
import 'package:animated_tesla_car_app_using_flutter/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController _homeController = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;

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

  @override
  void initState() {
    setupBatteryAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([_homeController, _batteryAnimationController]),
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              if (index == 1) {
                _batteryAnimationController.forward();
              } else if (_homeController.selectedBottomTab == 1 && index != 1) {
                _batteryAnimationController.reverse(from: 0.7);
              }
              _homeController.onBottomNavigationTabChange(index);
            },
            selectedTab: _homeController.selectedBottomTab,
          ),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.1),
                    child: SvgPicture.asset(
                      "assets/icons/Car.svg",
                      width: double.infinity,
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
                        child: BatteryStatus(constraints: constraints)),
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
