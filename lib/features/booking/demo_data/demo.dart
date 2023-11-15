import 'dart:math';

const showTimesByWeekDay = [
  ShowTimeWeeks(
      weekDays: [
        1,
        2,
        3,
        4
      ], //Mon - Thu
      showTimes: [
        ShowTime(
          id: 1,
          cinema: "Cinetech",
          screen: "hall 1",
          time: "11:30",
          regularRate: 50,
          vipRate: 150,
          points: 2500,
        ),
        ShowTime(
          id: 2,
          cinema: "Cinetech",
          screen: "hall 1",
          time: "14:00",
          regularRate: 80,
          vipRate: 200,
          points: 3000,
        ),
      ]),
  ShowTimeWeeks(
      weekDays: [
        5,
        6,
        7
      ], //Fri - Sun
      showTimes: [
        ShowTime(
          id: 4,
          cinema: "Cinetech",
          screen: "hall 1",
          time: "10:00",
          regularRate: 80,
          vipRate: 170,
          points: 2000,
        ),
        ShowTime(
          id: 5,
          cinema: "Cinetech",
          screen: "hall 2",
          time: "11:00",
          regularRate: 70,
          vipRate: 150,
          points: 2000,
        ),
        ShowTime(
          id: 6,
          cinema: "Cinetech",
          screen: "hall 1",
          time: "13:30",
          regularRate: 110,
          vipRate: 300,
          points: 4000,
        ),
        ShowTime(
          id: 7,
          cinema: "Cinetech",
          screen: "hall 1",
          time: "18:00",
          regularRate: 150,
          vipRate: 450,
          points: 4500,
        ),
      ])
];

List<ShowTime> getShowTimes(DateTime date) {
  int weekDay = date.weekday;
  for (var item in showTimesByWeekDay) {
    if (item.weekDays.contains(weekDay)) {
      return item.showTimes;
    }
  }
  return [];
}

class ShowTime {
  final int id;
  final String cinema;
  final String screen;
  final String time;
  final int regularRate;
  final int vipRate;
  final int points;

  const ShowTime.empty({
    this.id = 0,
    this.cinema = "",
    this.screen = "",
    this.time = "",
    this.regularRate = 0,
    this.vipRate = 0,
    this.points = 0,
  });
  const ShowTime({
    required this.id,
    required this.cinema,
    required this.screen,
    required this.time,
    required this.regularRate,
    required this.vipRate,
    required this.points,
  });
}

class ShowTimeWeeks {
  final List<int> weekDays;
  final List<ShowTime> showTimes;
  const ShowTimeWeeks({
    required this.weekDays,
    required this.showTimes,
  });
}

class Seats {
  final int
      seatNo; //a zero value indicates a vaccant space in the seating arrangement
  final int row;
  final bool isVipSeat;
  bool isBooked;
  Seats(
      {required this.seatNo,
      required this.row,
      required this.isVipSeat,
      this.isBooked = false});

  @override
  bool operator ==(covariant Seats other) {
    if (identical(this, other)) return true;

    return other.seatNo == seatNo &&
        other.row == row &&
        other.isVipSeat == isVipSeat;
  }

  @override
  int get hashCode => seatNo.hashCode ^ row.hashCode ^ isVipSeat.hashCode;
}

CinemaScreen getCinemaScreen(String name) {
  for (var screen in cinemaScreens) {
    if (screen.screenName == name) {
      return screen;
    }
  }
  return const CinemaScreen.empty();
}

final cinemaScreens = [
  CinemaScreen(screenName: "hall 1", seatingArrangement: {
    1: List.generate(
      27,
      (index) {
        int seatNo =
            [0, 1, 2, 5, 21, 24, 25, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 1,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    2: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 2,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    3: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 3,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    4: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 4,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    5: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 5,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    6: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 6,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    7: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 7,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    8: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 8,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    9: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 9,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    10: List.generate(
      27,
      (index) {
        int seatNo =
            [0, 4, 5, 6, 13, 20, 21, 22, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 10,
            isVipSeat: true,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
  }),
  CinemaScreen(screenName: "hall 2", seatingArrangement: {
    1: List.generate(
      27,
      (index) {
        int seatNo =
            [0, 1, 2, 5, 21, 24, 25, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 1,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    2: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 2,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    3: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 3,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    4: List.generate(
      27,
      (index) {
        int seatNo = [0, 5, 21, 26].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 4,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    5: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 5,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    6: List.generate(
      27,
      (index) {
        return Seats(
            seatNo: 0,
            row: 6,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    7: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 7,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    8: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 8,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    9: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 9,
            isVipSeat: false,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
    10: List.generate(
      27,
      (index) {
        int seatNo = [5, 21].contains(index) ? 0 : index + 1;
        return Seats(
            seatNo: seatNo,
            row: 10,
            isVipSeat: true,
            isBooked: Random().nextDouble() <= 0.3);
      },
    ),
  }),
];

class CinemaScreen {
  final String screenName;
  final Map<int, List<Seats>> seatingArrangement;

  const CinemaScreen.empty(
      {this.screenName = "", this.seatingArrangement = const {}});
  const CinemaScreen(
      {required this.screenName, required this.seatingArrangement});
}
