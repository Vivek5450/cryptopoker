import 'package:cryptopoker/screen/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LobbyView extends StatefulWidget {
  const LobbyView({super.key});

  @override
  State<LobbyView> createState() => _LobbyViewState();
}

class _LobbyViewState extends State<LobbyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,// allows background to touch the top of the screen
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/lobby_bg.png',
              fit: BoxFit.cover,
            ),

            // Content (Header + others)
            Column(
              children: [
                _buildHeader(),
                _buildTitle(),
                _playerBlindList(),
                // Your lobby content will go here
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double iconSize = MediaQuery.of(context).size.height * 0.025;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT SECTION — Back Button (touches top)
        Container(
          color: const Color.fromARGB(255, 53, 53, 53),
          height: statusBarHeight + 70,
          padding: EdgeInsets.only(top: statusBarHeight),
          child: Center(
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Image.asset(
                'assets/images/back.png',
                height: iconSize,
              ),
            ),
          ),
        ),

        // MIDDLE SECTION — Gradient Background (touches top)
        Expanded(
          child: Container(
            height: statusBarHeight + 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 52, 52, 52),
                  Color.fromARGB(255, 46, 46, 46),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 1,),
                Image.asset(
                  'assets/images/Logo.png',
                  height: MediaQuery.of(context).size.height * 0.028,
                ),
                const Text(
                  'Lobby',
                  textScaleFactor: 1.0, // keeps text size consistent
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 1,)
              ],
            ),
          ),
        ),

        // RIGHT SECTION — Balance, Settings, Logout
        Container(
          color: const Color.fromARGB(255, 53, 53, 53),
          height: statusBarHeight + 70,
          padding: EdgeInsets.only(
            top: statusBarHeight + 3,
            right: 8,
            left: 8,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Balance \$45.43',
                textScaleFactor: 1.0,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/settings.png',
                      height: iconSize * 0.9,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/logout.png',
                      height: iconSize * 0.9,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(){
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 20),
        child: Row(
          children: [
            SizedBox(width: 20,),
            Text('NAME',style: TextStyle(color: Colors.white),),
            SizedBox(width: 80,),
            Text('BLINDS',style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }

  Widget _playerBlindList(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  SizedBox(width: 20,),
                 Column(
                   children: [
                     Text('Jack Randy',style: TextStyle(color: Colors.white),),
                   ],
                 ),
                  SizedBox(width: 50,),
                  Column(
                    children: [
                      Text('\$ 0.25/0.500',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                SizedBox(width: 40,),
                Column(
                  children: [
                    GestureDetector(
                        onTap: ()=>Get.to(()=>DashboardView()),
                        child: Image.asset('assets/images/lets_play.png',height: 20,)),
                  ],
                )
                ],
              )
            ],
          ),
          Divider(thickness: 0.1,)
        ],
      ),
    );
  }
}
