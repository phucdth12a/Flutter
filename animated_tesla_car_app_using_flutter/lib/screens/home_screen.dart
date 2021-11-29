import 'package:animated_tesla_car_app_using_flutter/components/door_lock.dart';
import 'package:animated_tesla_car_app_using_flutter/components/tesla_bottom_navigationbar.dart';
import 'package:animated_tesla_car_app_using_flutter/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _homeController,
      builder: (context, _) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {},
            selectedTab: 0,
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
                  Positioned(
                    right: constraints.maxWidth * 0.05,
                    child: DoorLock(
                      isLock: _homeController.isRightDoorLock,
                      press: _homeController.updateRightDoorLock,
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * 0.05,
                    child: DoorLock(
                      isLock: _homeController.isLeftDoorLock,
                      press: _homeController.updateLeftDoorLock,
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.13,
                    child: DoorLock(
                      isLock: _homeController.isBonnetDoorLock,
                      press: _homeController.updateBonnetDoorLock,
                    ),
                  ),
                  Positioned(
                    bottom: constraints.maxHeight * 0.17,
                    child: DoorLock(
                      isLock: _homeController.isTrunkDoorLock,
                      press: _homeController.updateTrunkDoorLock,
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
