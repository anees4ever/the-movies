import 'package:flutter/material.dart';
import 'package:the_movies/features/booking/demo_data/demo.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';

class BookingProvider extends ChangeNotifier {
  DateTime bookingDate = DateTime.now();
  int bookingDateIndex = 0;

  ShowTime showTime = const ShowTime.empty();
  int showTimeIndex = 0;

  MovieInfo? movieInfo;
  List<Seats> selectedSeats = [];

  init() {
    movieInfo = null;
    selectedSeats = [];
    notifyListeners();
  }

  initSeats() {
    selectedSeats = [];
    notifyListeners();
  }

  updateBookingData(
      int dateIndex, DateTime date, int showIndex, ShowTime show) {
    bookingDateIndex = dateIndex;
    bookingDate = date;
    showTimeIndex = showIndex;
    showTime = show;
    notifyListeners();
  }

  updateSlot(int index, ShowTime show) {
    showTimeIndex = index;
    showTime = show;
    notifyListeners();
  }

  toggleSeat(Seats seat) {
    if (selectedSeats.contains(seat)) {
      removeSeat(seat);
    } else {
      selectedSeats.add(seat);
      selectedSeats.sort(
        (a, b) => "${a.row}_${a.seatNo}".compareTo("${b.row}_${b.seatNo}"),
      );
      notifyListeners();
    }
  }

  removeSeat(Seats seat) {
    if (selectedSeats.remove(seat)) {
      notifyListeners();
    }
  }

  int getTotal() {
    int amountToPay = 0;
    for (var seat in selectedSeats) {
      amountToPay += seat.isVipSeat ? showTime.vipRate : showTime.regularRate;
    }
    return amountToPay;
  }

  bool get enoughToBook => bookingDateIndex >= 0 && showTimeIndex >= 0;
  bool get seatsSelected => selectedSeats.isNotEmpty;
}
