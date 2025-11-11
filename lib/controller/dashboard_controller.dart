import 'dart:async';
import 'dart:math';
import 'package:cryptopoker/core/network/scoket_service.dart';
import 'package:cryptopoker/token_storage/token_storage.dart';
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

  final RxDouble potValue = 0.0.obs;           // total pot amount
  final RxDouble betChipProgress = 0.0.obs;    // controls chip animation
  final RxBool isChipAnimating = false.obs;    // prevent multiple animations
  final RxDouble currentBet = 0.0.obs;

  RxInt currentRound = 1.obs;
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

  RxList<bool> playerFolded = List.generate(6, (_) => false).obs;
  RxList<bool> playerPacked = List.generate(6, (_) => false).obs;

  late AnimationController zoomController;
  late Animation<double> zoomAnimation;

  RxList<String> communityCards =<String>[].obs;
  RxInt revealStage = 0.obs;

  var sliderValue = 1.0.obs; // current value in $
  final double min = 1.0;
  final double max = 100.0;
  final double step = 10.0;

  RxInt selectedIndex = 0.obs;
  RxInt completedTurns = 0.obs;


  final SocketService socketService = SocketService();


  @override
  void onInit() {
    super.onInit();
    connectSocket();
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
  void revealNextCommunityCards() {
    switch (revealStage.value) {
      case 0:
        _revealFlop();
        break;
      case 1:
        _revealTurn();
        break;
      case 2:
        _revealRiver();
        break;
      default:
        debugPrint("✅ All community cards revealed!");
    }
  }

  void _revealFlop() {
    if (communityCards.isEmpty) {
      play('cards_flip.mp3');
      communityCards.addAll(['card1', 'card2', 'card3']); // placeholder
      revealStage.value = 1;
      debugPrint("🃏 FLOP revealed!");
    }
  }

  void _revealTurn() {
    if (communityCards.length == 3) {
      play('cards_flip.mp3');
      communityCards.add('card4');
      revealStage.value = 2;
      debugPrint("🃏 TURN revealed!");
    }
  }

  void _revealRiver() {
    if (communityCards.length == 4) {
      play('cards_flip.mp3');
      communityCards.add('card5');
      revealStage.value = 3;
      debugPrint("🃏 RIVER revealed!");
    }
  }

  void startChips() {
    chipsLaid.value = true;
    play('chips_collect.mp3');
    potShown.value = false; // hide pot during chip movement
    potValue.value = 0.0;   // reset before collecting

    _chipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      chipProgress.value += 0.025;
      if (chipProgress.value >= 1.0) {
        chipProgress.value = 1.0;
        timer.cancel();

        // 💰 After chip collection finishes, add $20 from each player
        const double chipAmountPerPlayer = 20.0;
        potValue.value = totalPlayers * chipAmountPerPlayer;

        // 🕐 Add a small delay for realism before showing the pot
        Future.delayed(const Duration(milliseconds: 300), () {
          chipsLaid.value = false;
          potShown.value = true;

          // Continue to next step after a small pause
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
    foldPlayer(4);
  }

  List<Offset> playerPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;

    return [
      Offset(cx - w * 0.25, cy - h * 0.38), // Player 1 (Top-left)
      Offset(cx + w * 0.12, cy - h * 0.40), // Player 2 (Top-right)
      Offset(cx - w * 0.35, cy - h * 0.050), // Player 3 (Left mid)
      Offset(cx + w * 0.28, cy - h * 0.050), // Player 4 (Right mid)
      Offset(cx - w * 0.20, cy + h * 0.20), // Player 5 (Bottom-left)
      Offset(cx + w * 0.10, cy + h * 0.20), // Player 6 (Bottom-right)
    ];
  }

  List<Offset> cardPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;

    return [
      Offset(cx - w * 0.18, cy - h * 0.31), // Player 1 cards
      Offset(cx + w * 0.17, cy - h * 0.33), // Player 2 cards
      Offset(cx - w * 0.29, cy - h * 0.20), // Player 3 cards
      Offset(cx + w * 0.30, cy - h * 0.20), // Player 4 cards
      Offset(cx - w * 0.15, cy + h * 0.03), // Player 5 cards
      Offset(cx + w * 0.12, cy + h * 0.05), // Player 6 cards
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
    int nextIndex = (currentIndex + 1) % clockwiseOrder.length;
    while (playerFolded[clockwiseOrder[nextIndex]]) {
      nextIndex = (nextIndex + 1) % clockwiseOrder.length;
      if (playerFolded.where((f) => !f).length <= 1) {
        endRound();
        return;
      }
      if (nextIndex == currentIndex) break;
    }
    completedTurns++;

    final activePlayers = totalPlayers - playerFolded.where((f) => f).length;
    if(completedTurns.value >= activePlayers){
      print('::::=>All player turns get over');
      completedTurns.value=0;
      revealNextCommunityCards();
    }
    activePlayerIndex.value = clockwiseOrder[nextIndex];
    startTurn(activePlayerIndex.value);
  }



  void foldPlayer(int index) {
    if (index < 0 || index >= totalPlayers) return;
    if (playerFolded[index]) return;
    playerFolded[index] = true;
    playerPacked[index] = true; // 👈 hide cards too
    play('cards_flip.mp3');
    debugPrint("Player $index folded");

    if (activePlayerIndex.value == index) {
      moveToNextPlayer();
    }
  }
  void bet(int playerIndex, double amount) {
    if (isChipAnimating.value || playerFolded[playerIndex]) return;

    currentBet.value = amount;
    isChipAnimating.value = true;
    play('chips_collect.mp3');

    betChipProgress.value = 0.0;

    // Animate chips from player → pot
    _chipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      betChipProgress.value += 0.04;
      if (betChipProgress.value >= 1.0) {
         betChipProgress.value = 1.0;
        timer.cancel();
        potValue.value += amount;
        isChipAnimating.value = false;
        moveToNextPlayer();
      }
    });
  }

  void raiseBet(int playerIndex, double amount) {
    bet(playerIndex, amount); // for now, same animation but higher amount
  }


  void check(int playerIndex) {
    if (playerFolded[playerIndex]) return;
    play('check_tap.m4a'); // 👂 play a subtle sound for check
    debugPrint("Player $playerIndex checked");
    moveToNextPlayer();
  }

  void endRound() {
    timerActive.value = false;
    zoomController.stop();
    //play('winner.mp3'); // optional: add a win sound
    potShown.value = false;
    Get.snackbar(
      "Round ${currentRound.value}",
      "Winner: Player ${Random().nextInt(totalPlayers) + 1}",
      colorText: Colors.yellowAccent,
      backgroundColor: Colors.black54,
      snackPosition: SnackPosition.TOP,
    );

    Future.delayed(const Duration(seconds: 3), resetRound);
  }

  void resetRound() {
    currentRound.value++;
    countdown.value = 5;
    chipProgress.value = 0;
    dealProgress.value = 0;
    flipProgress.value = 0;
    packProgress.value = 0;
    player5Revealed.value = false;
    player5Packed.value = false;
    potShown.value = false;
    chipsLaid.value = false;
    cardsDealt.value = false;

    showCountdown.value = true;
    startCountdown(); // restart the whole cycle
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
    socketService.close();
    audio.dispose();
    zoomController.dispose();
    sliderValue.value=10.0;
    super.onClose();
  }

  Future<void> connectSocket() async {
    final token = await TokenStorage.getToken();

    await socketService.initSocket(
      'ws://157.245.212.69/ws', // your backend socket endpoint
      query: {'token': token},
    );


  }

  void sendMessage(dynamic data) {
    socketService.send(data);
  }

  void increase() {
    if (sliderValue.value + step <= max) {
      sliderValue.value += step;
    }
  }

  void decrease() {
    if (sliderValue.value - step >= min) {
      sliderValue.value -= step;
    }
  }

  void setPercentage(double percent) {
    sliderValue.value = (max * percent).clamp(min, max);
  }

}
