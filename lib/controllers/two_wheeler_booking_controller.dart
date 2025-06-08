import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/response/response_model.dart';
import '../data/models/response/two_wheeler_booking_details_model.dart';
import '../data/models/response/two_wheeler_booking_list_model.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/user_repo.dart';

class TwoWheelerBookingController extends GetxController
    implements GetxService {
  final AuthRepo authRepo;
  final UserRepo userRepo;

  TwoWheelerBookingController({required this.userRepo, required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Pending Order
  bool _ismapcreated = false;
  bool get ismapcreated => _ismapcreated;

  LatLng? currentMapLatLng;
  void updateismapcreated() {
    _ismapcreated = true;
    update();
  }

  void onCameraMove(LatLng position) {
    currentMapLatLng = position;
    log("Map moved to: $position");
  }

  void onCameraIdle() {
    log("Map movement ended at: $currentMapLatLng");
  }

  final List<String> messages = [
    "Finding nearby driver...",
    "Almost there...",
    "Hang tight, your order is on the way!",
  ];

  Timer? _messageTimer;
  late Timer _progressTimer;

  int _currentMessageIndex = 0;
  int get currentMessageIndex => _currentMessageIndex;

  int _passedSeconds = 0;
  int get passedSeconds => _passedSeconds;

  final int _totalSeconds = 30;
  bool _timerCompleted = false;
  bool get timerCompleted => _timerCompleted;

  void startCountdown() {
    _currentMessageIndex = 0;
    _passedSeconds = 0;
    _timerCompleted = false;

    _messageTimer?.cancel();
    _progressTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_passedSeconds < _totalSeconds) {
        _passedSeconds++;
        update();
      } else {
        _timerCompleted = true;
        _progressTimer.cancel();
        update();
      }
    });

    _messageTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      _currentMessageIndex = (_currentMessageIndex + 1) % messages.length;
      update();
    });
  }

  void stopCountdown() {
    _messageTimer?.cancel();
    _progressTimer.cancel();
  }

  List<TwoWheelerBookingListModel> _twowheelerbookingList = [];
  List<TwoWheelerBookingListModel> get twowheelerbookingList =>
      _twowheelerbookingList;

  // Get List of Two Wheeler Booking Data and pagination
  final ScrollController twowheelerscrollController = ScrollController();

  bool _isPaginating = false;
  bool get isPaginating => _isPaginating;

  int page = 1;

  void updatepage() {
    page = 1;
    update();
  }

  void twowheelerscrollListener() {
    if (twowheelerscrollController.position.pixels >=
        twowheelerscrollController.position.maxScrollExtent * 0.7) {
      if (!_isPaginating) {
        fetchNextTwoWheelerBookingsPage();
      }
    }
  }

  Future<ResponseModel> cancelTwoWheelerOrder(String id) async {
    log("gettwowheelerbookingsById called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.cancelTwoWheelerOrder(id);

      if (response.statusCode == 200) {
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT gettwowheelerbookingsById()!");
      log(e.toString(), name: "ERROR AT gettwowheelerbookingsById()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getTwoWheelerBookings() async {
    log("getTwoWheelerBookings called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await userRepo.gettwowheelerbookings();
      if (response.statusCode == 200) {
        log(jsonEncode(response.body), name: "Booking List");

        _twowheelerbookingList = twoWheelerBookingListModelFromJson(
            jsonEncode(response.body['data']['data']));

        log(_twowheelerbookingList.toString(), name: "TwoWheelerBookingList");
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _isLoading = false;
        update();
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "ERROR AT getTwoWheelerBookings()!");
      log(e.toString(), name: "ERROR AT getTwoWheelerBookings()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchNextTwoWheelerBookingsPage() async {
    if (_isPaginating) return;
    _isPaginating = true;
    update();

    try {
      page++;
      log(page.toString(), name: "Page No");
      Response response = await userRepo.gettwowheelerBookingsByPageUrl(page);
      if (response.statusCode == 200) {
        List<TwoWheelerBookingListModel> newBookings =
            twoWheelerBookingListModelFromJson(
                jsonEncode(response.body['data']['data']));
        _twowheelerbookingList.addAll(newBookings);
        update();
      } else {
        log("Pagination error: ${response.body['message']}");
      }
    } catch (e) {
      log(e.toString(), name: "ERROR AT fetchNextBookingsPage()");
    }

    _isPaginating = false;
    update();
  }

  // Two Wheeler Booking Detials Page
  TwoWheelerBookingDetailsModel? _twowheelerbookingdetailsModel;
  TwoWheelerBookingDetailsModel? get twowheelerbookingdetailsModel =>
      _twowheelerbookingdetailsModel;

  List<bool> _expandedStates = [];

  List<bool> get expandedStates => _expandedStates;

  void expandedpickupdrop(int idx) {
    _expandedStates[idx] = !_expandedStates[idx];
    update();
  }

  Future<ResponseModel> gettwowheelerbookingsById(String id) async {
    log("gettwowheelerbookingsById called");
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      _twowheelerbookingdetailsModel = null;
      Response response = await userRepo.gettwowheelerbookingsById(id);

      log(jsonEncode(response.body['data']), name: "abc");
      if (response.statusCode == 200) {
        _twowheelerbookingdetailsModel =
            await twoWheelerBookingDetailsModelFromJson(
                jsonEncode(response.body['data']));
        responseModel =
            ResponseModel(true, '${response.body['msg']}', response.body);
        _expandedStates = List.generate(
            twowheelerbookingdetailsModel!.locations!.length, (index) => false);
        log(_twowheelerbookingdetailsModel.toString(),
            name: "TwoWheelerBookingDetailsModel");
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
    } catch (e) {
      responseModel =
          ResponseModel(false, "ERROR AT gettwowheelerbookingsById()!");
      log(e.toString(), name: "ERROR AT gettwowheelerbookingsById()");
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  // In TwoWheelerBookingController
  LatLng? driverLatLng;

  void updateDriverLocation(double lat, double lng) {
    driverLatLng = LatLng(lat, lng);
    update(); // this triggers the UI rebuild
  }

  @override
  void onClose() {
    twowheelerscrollController.dispose();
    stopCountdown();
    ismapcreated;
    _timer?.cancel();

    super.onClose();
  }

  int remainingtime = 30;
  Timer? _timer;

  void remainingtimeforcancel() {
    if (_twowheelerbookingdetailsModel?.accepted == null) {
      log('Accepted time not available');
      return;
    }

    final DateTime acceptedTime = _twowheelerbookingdetailsModel!.accepted!;
    final Duration difference = DateTime.now().difference(acceptedTime);
    int timediff = difference.inSeconds;

    if (timediff >= 30) {
      remainingtime = 0;
      update();
      return;
    }

    remainingtime = 30 - timediff;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingtime > 0) {
        remainingtime--;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  // MovingLineContainer place
  bool animationInitialized = false;

  late AnimationController fillController;
  late Animation<double> fillAnimation;

  late AnimationController slideController;
  late Animation<Offset> slideAnimation;

  bool hideContainer = false;
  int remaining = 30;

  void initAnimationControllers(TickerProvider vsync) {
    fillController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: vsync,
    );
    fillController.value = 0.0;

    fillController.animateTo(1.0,
        duration: Duration(seconds: remaining), curve: Curves.linear);

    slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );

    slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: slideController,
      curve: Curves.easeInOut,
    ));

    fillController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        slideController.forward().then((_) {
          hideContainer = true;
          update(); // Notify listeners
        });
      }
    });
    animationInitialized = true;
    update();
  }

  void startTiming() {
    log("Starting animation", name: "Animation Started");

    hideContainer = false;
    fillController.forward(from: 0);
  }

  void disposeAnimations() {
    fillController.dispose();
    slideController.dispose();
  }

  // bool shouldShowContainer = true;
  void checkIfShouldShowContainer(DateTime acceptedTime) {
    final Duration difference = DateTime.now().difference(acceptedTime);
    int timediff = difference.inSeconds;
    const int totalDuration = 30;

    log(timediff.toString(), name: "Timediff");

    if (timediff >= totalDuration) {
      hideContainer = true;
      update();
    } else {
      hideContainer = false;
      startTiming();
      // Cancel any previous animation
      // fillController.stop();

      // Calculate remaining time
      remaining = totalDuration - timediff;

      // Adjust the fill animation to start from current progress
      // double startValue = timediff / totalDuration;

      // fillController.value = startValue;

      // fillController.animateTo(
      //   1.0,
      //   duration: Duration(seconds: remaining),
      //   curve: Curves.linear,
      // );

      update();
    }
  }

  // timerdismissble controller part

  // late AnimationController slideanimationController;
  // late Animation<Offset> offsetAnimation;
  // late int remainingSeconds;
  // bool isVisible = true;
  //
  // void inittimerdismissbleController(TickerProvider vsync,DateTime accepted) {
  //   slideanimationController = AnimationController(
  //     vsync: vsync,
  //     duration: Duration(milliseconds: 500),
  //   );
  //
  //   offsetAnimation = Tween<Offset>(
  //     begin: Offset.zero,
  //     end: Offset(0, 1), // Slide down
  //   ).animate(CurvedAnimation(
  //     parent: slideanimationController,
  //     curve: Curves.easeInOut,
  //   ));
  //   _startTimer(accepted);
  //   update();
  // }
  //
  // void _startTimer(DateTime accepted) {
  //   final now = DateTime.now();
  //   final elapsed = now.difference(accepted).inSeconds;
  //   remainingSeconds = (30 - elapsed).clamp(0, 30);
  //   if (remainingSeconds <= 0) {
  //     isVisible = false;
  //     return;
  //   }
  //
  //   Future.delayed(Duration(seconds: remainingSeconds), () {
  //     slideanimationController.forward();
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       isVisible = false;
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   slideanimationController.dispose();
  //   super.dispose();
  // }




  late AnimationController slideAnimationController;
  late Animation<Offset> offsetAnimation;

  int remainingSeconds = 0;
  bool isVisible = true;

  Timer? _dismissTimer;

  void initTimedDismissible({
    required DateTime accepted,
    required TickerProvider vsync,
  }) {
    final now = DateTime.now();
    final elapsed = now.difference(accepted).inSeconds;
    remainingSeconds = (30 - elapsed).clamp(0, 30);

    slideAnimationController = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 500),
    );

    offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: slideAnimationController,
      curve: Curves.easeInOut,
    ));

    if (remainingSeconds <= 0) {
      isVisible = false;
      update();
      return;
    }

    isVisible = true;

    _dismissTimer?.cancel();
    _dismissTimer = Timer(Duration(seconds: remainingSeconds), () {
      slideAnimationController.forward().then((_) {
        isVisible = false;
        update();
      });
    });

    update();
  }

  void disposeTimedDismissible() {
    slideAnimationController.dispose();
    _dismissTimer?.cancel();
  }
}
