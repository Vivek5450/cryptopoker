// dashboard_controller.dart (COMPLETE FILE)
import 'dart:async';
import 'dart:math';
import 'package:cryptopoker/core/network/scoket_service.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController
    with GetTickerProviderStateMixin {
  // card assets (constant)
  static const List<String> allCardImagesConst = [
    // Clubs (clover)
    'assets/images/cards/clover_a.png',
    'assets/images/cards/clover_two.png',
    'assets/images/cards/clover_three.png',
    'assets/images/cards/clover_four.png',
    'assets/images/cards/clover_five.png',
    'assets/images/cards/clover_six.png',
    'assets/images/cards/clover_seven.png',
    'assets/images/cards/clover_eight.png',
    'assets/images/cards/clover_nine.png',
    'assets/images/cards/clover_ten.png',
    'assets/images/cards/clover_j.png',
    'assets/images/cards/clover_q.png',
    'assets/images/cards/clover_k.png',

    // Diamonds
    'assets/images/cards/diamond_A.png',
    'assets/images/cards/diamond_two.png',
    'assets/images/cards/diamond_three.png',
    'assets/images/cards/diamond_four.png',
    'assets/images/cards/diamond_five.png',
    'assets/images/cards/diamond_six.png',
    'assets/images/cards/diamond_seven.png',
    'assets/images/cards/diamond_eight.png',
    'assets/images/cards/diamond_nine.png',
    'assets/images/cards/diamond_ten.png',
    'assets/images/cards/diamond_J.png',
    'assets/images/cards/diamond_Q.png',
    'assets/images/cards/diamond_K.png',

    // Hearts
    'assets/images/cards/heart_A.png',
    'assets/images/cards/heart_two.png',
    'assets/images/cards/heart_three.png',
    'assets/images/cards/heart_four.png',
    'assets/images/cards/heart_five.png',
    'assets/images/cards/heart_six.png',
    'assets/images/cards/heart_seven.png',
    'assets/images/cards/heart_eight.png',
    'assets/images/cards/heart_nine.png',
    'assets/images/cards/heart_ten.png',
    'assets/images/cards/heart_J.png',
    'assets/images/cards/heart_Q.png',
    'assets/images/cards/heart_K.png',

    // Spades / leaf in your naming
    'assets/images/cards/leaf_A.png',
    'assets/images/cards/leaf_two.png',
    'assets/images/cards/leaf_three.png',
    'assets/images/cards/leaf_four.png',
    'assets/images/cards/leaf_five.png',
    'assets/images/cards/leaf_six.png',
    'assets/images/cards/leaf_seven.png',
    'assets/images/cards/leaf_eight.png',
    'assets/images/cards/leaf_nine.png',
    'assets/images/cards/leaf_ten.png',
    'assets/images/cards/leaf_J.png',
    'assets/images/cards/leaf_Q.png',
    'assets/images/cards/leaf_K.png',
  ];

  /// the runtime deck (shuffled copy of allCardImagesConst)
  final RxList<String> deck = <String>[].obs;

  /// draw random card and remove from deck (refills & reshuffles when empty)
  String drawRandomCard() {
    if (deck.isEmpty) {
      // refill and shuffle
      deck.addAll(allCardImagesConst);
      deck.shuffle();
    }
    final idx = Random().nextInt(deck.length);
    final card = deck.removeAt(idx);
    return card;
  }

  // These will store 2 random cards (player's hole cards)
  final RxString card1 = ''.obs;
  final RxString card2 = ''.obs;

  // CALL THIS to generate two new random cards (no duplicates)
  void getRandomCards() {
    // ensure deck has enough cards; if not, refill & shuffle
    if (deck.length < 2) {
      deck.clear();
      deck.addAll(allCardImagesConst);
      deck.shuffle();
    }
    card1.value = drawRandomCard();
    card2.value = drawRandomCard();
  }

  // NEW: First & Second Serve Flags
  RxBool isFirstServe = true.obs;
  RxBool isSecondServe = false.obs;
  RxBool secondDealInProgress = false.obs;
  final secondDealProgress = 0.0.obs;
  Timer? _secondDealTimer;

  // existing game variables
  final countdown = 5.obs;
  final showCountdown = true.obs;
  final chipsLaid = false.obs;
  final potShown = false.obs;
  final cardsDealt = false.obs;
  final player5Revealed = false.obs;
  final player5Packed = false.obs;
  RxBool timerActive = false.obs;

  final RxDouble potValue = 0.0.obs;
  final RxDouble betChipProgress = 0.0.obs;
  final RxBool isChipAnimating = false.obs;
  final RxDouble currentBet = 0.0.obs;

  RxInt currentRound = 1.obs;
  final chipProgress = 0.0.obs;
  final dealProgress = 0.0.obs;
  final flipProgress = 0.0.obs;
  final packProgress = 0.0.obs;
  RxInt activePlayerIndex = 0.obs;
  RxInt turnCountdown = 10.obs;
  final int totalPlayers = 7;
  final AudioPlayer audio = AudioPlayer();
  final List<int> clockwiseOrder = [0, 2, 4, 6, 5, 3, 1];

  // make timers nullable to avoid cancel errors if not created
  Timer? _countdownTimer;
  Timer? _chipTimer;
  Timer? _dealTimer;
  Timer? _flipTimer;
  Timer? _packTimer;
  Timer? _turnTimer;

  RxList<bool> playerFolded = List.generate(7, (_) => false).obs;
  RxList<bool> playerPacked = List.generate(7, (_) => false).obs;

  late AnimationController zoomController;
  late Animation<double> zoomAnimation;

  RxList<String> communityCards = <String>[].obs;
  RxInt revealStage = 0.obs;

  var sliderValue = 1.0.obs;
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

    // seed deck initially
    deck.clear();
    deck.addAll(allCardImagesConst);
    deck.shuffle();

    // Animation controller created but not auto-repeating here
    zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    zoomAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: zoomController, curve: Curves.easeInOut));

    // start initial countdown flow
    startCountdown();
  }

  Future<void> play(String file) async {
    try {
      await audio.play(AssetSource('sounds/$file'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  void startCountdown() {
    // cancel any existing before creating new
    _countdownTimer?.cancel();
    countdown.value = 5;
    showCountdown.value = true;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdown.value <= 1) {
        t.cancel();
        showCountdown.value = false;

        // small delay then start the chip collect
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

      communityCards.add(drawRandomCard());
      communityCards.add(drawRandomCard());
      communityCards.add(drawRandomCard());

      revealStage.value = 1;
      debugPrint("🃏 FLOP revealed! -> ${communityCards.join(', ')}");
    }
  }

  void _revealTurn() {
    if (communityCards.length == 3) {
      play('cards_flip.mp3');
      communityCards.add(drawRandomCard());
      revealStage.value = 2;
      debugPrint("🃏 TURN revealed! -> ${communityCards.join(', ')}");
    }
  }

  void _revealRiver() {
    if (communityCards.length == 4) {
      play('cards_flip.mp3');
      communityCards.add(drawRandomCard());
      revealStage.value = 3;
      debugPrint("🃏 RIVER revealed! -> ${communityCards.join(', ')}");
    }
  }

  void startChips() {
    chipsLaid.value = true;
    play('chips_collect.mp3');
    potShown.value = false;
    potValue.value = 0.0;

    _chipTimer?.cancel();
    chipProgress.value = 0.0;

    _chipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      chipProgress.value += 0.025;
      if (chipProgress.value >= 1.0) {
        chipProgress.value = 1.0;
        timer.cancel();

        const double chipAmountPerPlayer = 20.0;
        potValue.value = totalPlayers * chipAmountPerPlayer;

        Future.delayed(const Duration(milliseconds: 300), () {
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

    _dealTimer?.cancel();

    _dealTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      dealProgress.value += 0.02;
      if (dealProgress.value >= 1.0) {
        dealProgress.value = 1.0;
        timer.cancel();

        // draw player's hole cards BEFORE first player's turn
        getRandomCards();

        // First serve complete, ekhon 2 second wait then second serve
        if (isFirstServe.value) {
          isFirstServe.value = false;

          // 2 second wait korar por second deal start
          Future.delayed(const Duration(seconds: 2), () {
            startSecondDeal();
          });
        } else {
          // Normal flow - start turn (2nd round onwards)
          startTurn(clockwiseOrder.isNotEmpty ? clockwiseOrder[0] : 0);
        }
      }
    });
  }

  // NEW METHOD - Second deal animation
  void startSecondDeal() {
    secondDealInProgress.value = true;
    play('deal_cards_1.mp3'); // Same sound or different sound
    secondDealProgress.value = 0.0;

    _secondDealTimer?.cancel();

    _secondDealTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      secondDealProgress.value += 0.02;
      if (secondDealProgress.value >= 1.0) {
        secondDealProgress.value = 1.0;
        timer.cancel();

        // Second serve complete
        isSecondServe.value = true;
        secondDealInProgress.value = false;

        // Ekhon player turn start
        Future.delayed(const Duration(milliseconds: 300), () {
          startTurn(clockwiseOrder.isNotEmpty ? clockwiseOrder[0] : 0);
        });
      }
    });
  }

  void revealPlayer5() {
    if (player5Revealed.value) return;
    play('cards_flip.mp3');
    player5Revealed.value = true;
    flipProgress.value = 0.0;

    _flipTimer?.cancel();
    _flipTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      flipProgress.value += 0.05;
      if (flipProgress.value >= 1.0) {
        flipProgress.value = 1.0;
        timer.cancel();
      }
    });
  }

  void packPlayer5() {
    // user/player 5 -> fold index 5
    foldPlayer(5);
  }

  List<Offset> playerPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;
    return [
      Offset(cx - w * 0.02, cy - h * 0.33),
      Offset(cx - w * 0.30, cy - h * 0.30),
      Offset(cx + w * 0.25, cy - h * 0.30),
      Offset(cx - w * 0.35, cy - h * 0.0),
      Offset(cx + w * 0.28, cy - h * 0.020),
      Offset(cx - w * 0.20, cy + h * 0.20),
      Offset(cx + w * 0.10, cy + h * 0.20),
    ];
  }

  List<Offset> cardPositions(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;
    return [
      Offset(cx - w * -0.002, cy - h * 0.48),
      Offset(cx - w * 0.28, cy - h * 0.45),
      Offset(cx + w * 0.27, cy - h * 0.45),
      Offset(cx - w * 0.33, cy - h * 0.15),
      Offset(cx + w * 0.30, cy - h * 0.17),
      Offset(cx - w * 0.19, cy + h * 0.03),
      Offset(cx + w * 0.12, cy + h * 0.05),
    ];
  }

  void startTurn(int playerIndex) {
    // Cancel any existing turn timer
    _turnTimer?.cancel();

    activePlayerIndex.value = playerIndex;
    turnCountdown.value = 10;
    timerActive.value = true;

    // start zoom animation for active player
    zoomController.repeat(reverse: true);

    // start a periodic timer for the player's turn countdown
    _turnTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!timerActive.value) {
        timer.cancel();
        zoomController.stop();
        return;
      }

      if (turnCountdown.value > 0) {
        turnCountdown.value--;
        // play tick sound if you want
        play('tick.mp3');
      } else {
        // Time up: stop timer, stop zoom, and move to next player
        timer.cancel();
        timerActive.value = false;
        zoomController.stop();
        moveToNextPlayer();
      }
    });
  }

  void endTurn() {
    timerActive.value = false;
    _turnTimer?.cancel();
    zoomController.stop();
  }

  void moveToNextPlayer() {
    final currentIndex = clockwiseOrder.indexOf(activePlayerIndex.value);
    int nextIndex = (currentIndex + 1) % clockwiseOrder.length;

    // find next non-folded player
    int attempts = 0;
    while (playerFolded[clockwiseOrder[nextIndex]] &&
        attempts < clockwiseOrder.length) {
      nextIndex = (nextIndex + 1) % clockwiseOrder.length;
      attempts++;
      if (playerFolded.where((f) => !f).length <= 1) {
        // one or zero players remain -> end round
        endRound();
        return;
      }
    }

    // increment completed turns safely
    completedTurns.value++;

    final activePlayers = totalPlayers - playerFolded.where((f) => f).length;
    if (completedTurns.value >= activePlayers) {
      debugPrint('::::=>All player turns get over');
      completedTurns.value = 0;
      revealNextCommunityCards();
    }

    activePlayerIndex.value = clockwiseOrder[nextIndex];
    // start next player's turn
    startTurn(activePlayerIndex.value);
  }

  void foldPlayer(int index) {
    if (index < 0 || index >= totalPlayers) return;
    if (playerFolded[index]) return;
    playerFolded[index] = true;
    playerPacked[index] = true;
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
    _chipTimer?.cancel();

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
    bet(playerIndex, amount);
  }

  void check(int playerIndex) {
    if (playerFolded[playerIndex]) return;
    play('check_tap.m4a');
    debugPrint("Player $playerIndex checked");
    moveToNextPlayer();
  }

  void endRound() {
    timerActive.value = false;
    _turnTimer?.cancel();
    zoomController.stop();
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
    // reset flags for players
    playerFolded = List.generate(totalPlayers, (_) => false).obs;
    playerPacked = List.generate(totalPlayers, (_) => false).obs;
    completedTurns.value = 0;
    revealStage.value = 0;
    communityCards.clear();

    secondDealProgress.value = 0.0;
    secondDealInProgress.value = false;
    // Note: isFirstServe and isSecondServe remain false after first round

    // refill & shuffle the deck for the next round
    deck.clear();
    deck.addAll(allCardImagesConst);
    deck.shuffle();

    // clear player's hole cards
    card1.value = '';
    card2.value = '';

    startCountdown();
  }

  void resetTimer() {
    _countdownTimer?.cancel();
    startCountdown();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _chipTimer?.cancel();
    _dealTimer?.cancel();
    _flipTimer?.cancel();
    _packTimer?.cancel();
    _turnTimer?.cancel();
    _secondDealTimer?.cancel();
    audio.dispose();
    zoomController.dispose();
    sliderValue.value = 10.0;
    super.onClose();
  }

  Future<void> connectSocket() async {
    await socketService.initSocket('ws://157.245.212.69/ws');
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
