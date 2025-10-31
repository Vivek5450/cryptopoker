import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController with GetTickerProviderStateMixin {
  final countdown = 5.obs;
  final showCountdown = true.obs;
  final chipsLaid = false.obs;
  final potShown = false.obs;
  final cardsDealt = false.obs;
  final player5Revealed = false.obs;
  final player5Packed = false.obs;
  RxBool timerActive = false.obs;

  final chipProgress = 0.0.obs;
  final dealProgress = 0.0.obs;
  final flipProgress = 0.0.obs;
  final packProgress = 0.0.obs;
  RxInt activePlayerIndex = 0.obs; // Tracks whose turn it is
  RxInt turnCountdown = 10.obs;    // Example: 15 seconds per turn
  final int totalPlayers = 6;
  final AudioPlayer audio = AudioPlayer();
  final List<int> clockwiseOrder = [0, 1, 3, 5, 4, 2];
  late Timer _countdownTimer;
  late Timer _chipTimer;
  late Timer _dealTimer;
  late Timer _flipTimer;
  late Timer _packTimer;

  late AnimationController zoomController;
  late Animation<double> zoomAnimation;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    zoomAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: zoomController, curve: Curves.easeInOut),
    );
  }

  Future<void> play(String file) async {
    try {
      await audio.play(AssetSource('sounds/$file'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown.value <= 1) {
        t.cancel();
        showCountdown.value = false;
        Future.delayed(const Duration(milliseconds: 300), startChips);
      } else {
        countdown.value--;
        play('tick.mp3');
      }
    });
  }

  void startChips() {
    chipsLaid.value = true;
    play('chips_collect.mp3');

    _chipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      chipProgress.value += 0.025;
      if (chipProgress.value >= 1.0) {
        chipProgress.value = 1.0;
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 200), () {
          chipsLaid.value = false;
          potShown.value = true;
          Future.delayed(const Duration(milliseconds: 400), startDeal);
        });
      }
    });
  }

  void startDeal() {
    cardsDealt.value = true;
    play('deal_cards_1.mp3');
    dealProgress.value = 0.0;

    _dealTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      dealProgress.value += 0.02;
      if (dealProgress.value >= 1.0) {
        dealProgress.value = 1.0;
        timer.cancel();
        // ✅ Start the first player's turn ONLY after dealing completes
        startTurn(0);
      }
    });
  }

  void revealPlayer5() {
    if (player5Revealed.value) return;
    play('cards_flip.mp3');
    player5Revealed.value = true;
    flipProgress.value = 0.0;

    _flipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      flipProgress.value += 0.05;
      if (flipProgress.value >= 1.0) {
        flipProgress.value = 1.0;
        timer.cancel();
      }
    });
  }

  void packPlayer5() {
    if (player5Packed.value) return;
    play('cards_flip.mp3');
    player5Packed.value = true;

    _packTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      packProgress.value += 0.05;
      if (packProgress.value >= 1.0) {
        packProgress.value = 1.0;
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 200), () {
          player5Revealed.value = false;
        });
      }
    });
  }

  List<Offset> playerPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;

    return [
      Offset(cx - w * 0.27, cy - h * 0.40), // Player 1 (Top-left)
      Offset(cx + w * 0.17, cy - h * 0.40), // Player 2 (Top-right)
      Offset(cx - w * 0.35, cy - h * 0.0), // Player 3 (Left mid)
      Offset(cx + w * 0.28, cy - h * 0.0), // Player 4 (Right mid)
      Offset(cx - w * 0.20, cy + h * 0.30), // Player 5 (Bottom-left)
      Offset(cx + w * 0.17, cy + h * 0.30), // Player 6 (Bottom-right)
    ];
  }

  List<Offset> cardPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;

    return [
      Offset(cx - w * 0.18, cy - h * 0.30), // Player 1 cards
      Offset(cx + w * 0.22, cy - h * 0.30), // Player 2 cards
      Offset(cx - w * 0.29, cy - h * 0.17), // Player 3 cards
      Offset(cx + w * 0.35, cy - h * 0.17), // Player 4 cards
      Offset(cx - w * 0.15, cy + h * 0.13), // Player 5 cards
      Offset(cx + w * 0.20, cy + h * 0.13), // Player 6 cards
    ];
  }


  void startTurn(int playerIndex) {
    activePlayerIndex.value = playerIndex;
    turnCountdown.value = 10; // reset countdown
    timerActive.value = true;

    Future.doWhile(() async {
      if (turnCountdown.value > 0 && timerActive.value) {
        await Future.delayed(const Duration(seconds: 1));
        turnCountdown.value--;
        zoomController.repeat(reverse: true);
        return true; // continue loop
      } else {
        timerActive.value = false;
        moveToNextPlayer(); // Automatically shift turn
        return false; // stop loop
      }
    });
  }

  void endTurn() {
    timerActive.value = false;
    zoomController.stop();
  }

  void moveToNextPlayer() {
    final currentIndex = clockwiseOrder.indexOf(activePlayerIndex.value);
    final nextIndex = (currentIndex + 1) % clockwiseOrder.length;
    activePlayerIndex.value = clockwiseOrder[nextIndex];
    startTurn(activePlayerIndex.value);
  }

  void resetTimer() {
    if (_countdownTimer.isActive) {
      _countdownTimer.cancel();
    }
    startCountdown();
  }

  @override
  void onClose() {
    _countdownTimer.cancel();
    _chipTimer.cancel();
    _dealTimer.cancel();
    _flipTimer.cancel();
    _packTimer.cancel();
    audio.dispose();
    zoomController.dispose();
    super.onClose();
  }
}
