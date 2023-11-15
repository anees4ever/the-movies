import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movies/app/extensions/dateformat.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/features/booking/demo_data/demo.dart';
import 'package:the_movies/features/booking/provider/booking_provider.dart';
import 'package:the_movies/features/booking/ui/booking_seats.dart';
import 'package:the_movies/features/movies/model/movie_data_model.dart';

class BookingSlotsPage extends StatefulWidget {
  static const String routeName = "/booking/slots";
  const BookingSlotsPage({super.key, required this.movieInfo});

  final MovieInfo movieInfo;

  @override
  State<BookingSlotsPage> createState() => _BookingSlotsPageState();
}

class _BookingSlotsPageState extends State<BookingSlotsPage> {
  List<DateTime> weekDates = [];
  List<ShowTime> showTimes = [];

  @override
  void initState() {
    weekDates =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    showTimes = getShowTimes(weekDates[0]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BookingProvider provider = context.read<BookingProvider>();
      provider.init();
      provider.movieInfo = widget.movieInfo;
      provider.bookingDate = weekDates[0];
      provider.bookingDateIndex = 0;
      provider.showTimeIndex = showTimes.isEmpty ? -1 : 0;
      provider.showTime =
          showTimes.isEmpty ? const ShowTime.empty() : showTimes[0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movieInfo.data.id <= 0) {
      return const ErrorPage(
        title: "Movie Details not found...",
        error: "No movie found in the response.",
      );
    }

    return Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
      double boxWidth = MediaQuery.of(context).size.width * 0.6;
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 76,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: textColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Column(
            children: [
              Center(
                child: Text(
                  widget.movieInfo.data.title,
                  style: text16BoldStyle,
                ),
              ),
              Center(
                child: Text(
                  "In Theaters ${widget.movieInfo.data.releaseDateFormatted}",
                  style: text12BlueStyle,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        extendBody: true,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 60, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Date",
                      style: text16BoldStyle,
                    ),
                    SizedBox(
                      height: 32,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                selected:
                                    index == bookingProvider.bookingDateIndex,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                label: Text(
                                    weekDates[index].quickFormat("d MMM"),
                                    style: index ==
                                            bookingProvider.bookingDateIndex
                                        ? text12DarkStyle
                                        : text12Style),
                                disabledColor: colorIcons,
                                backgroundColor: colorDivider,
                                selectedColor: colorSecondary,
                                shadowColor: colorDivider,
                                showCheckmark: false,
                                pressElevation: 8.0,
                                elevation: 2.0,
                                side: BorderSide.none,
                                onSelected: (value) {
                                  showTimes = getShowTimes(weekDates[index]);
                                  bookingProvider.updateBookingData(
                                      index,
                                      weekDates[index],
                                      showTimes.isEmpty ? -1 : 0,
                                      showTimes.isEmpty
                                          ? const ShowTime.empty()
                                          : showTimes[0]);
                                },
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (showTimes.isEmpty)
                      Text(
                        "No Shows on ${bookingProvider.bookingDate.quickFormat("EEE dd, MMM")}",
                        style: text16RedStyle,
                      ),
                    if (showTimes.isNotEmpty)
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: showTimes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                bookingProvider.updateSlot(
                                    index, showTimes[index]);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 16.0),
                                width: boxWidth,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          showTimes[index].time.toString(),
                                          style: text12BoldStyle,
                                        ),
                                        Text(
                                          " ${showTimes[index].cinema.toString()} + ${showTimes[index].screen.toString()}",
                                          style: text12Style,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16)),
                                        border: Border.all(
                                            color: index ==
                                                    bookingProvider
                                                        .showTimeIndex
                                                ? colorSecondary
                                                : colorIcons),
                                      ),
                                      child: ScreenSeatArrangementView(
                                        cinemaScreen: getCinemaScreen(
                                            showTimes[index].screen),
                                        scaledView: true,
                                        boxWidth: boxWidth,
                                        boxHeight: 180,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "From ",
                                          style: text12Style,
                                        ),
                                        Text(
                                          "${showTimes[index].regularRate.toString()}\$",
                                          style: text12BoldStyle,
                                        ),
                                        const Text(
                                          " or ",
                                          style: text12Style,
                                        ),
                                        Text(
                                          "${showTimes[index].points.toString()} bonus",
                                          style: text12BoldStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: bookingProvider.enoughToBook
                    ? getPrimaryButton(
                        height: 50,
                        isBig: true,
                        title: "Select Seats",
                        onPressed: () => Navigator.of(context)
                            .pushNamed(BookingSeatsPage.routeName),
                      )
                    : getSecondaryButton(
                        height: 50,
                        isBig: true,
                        title: "Select Seats",
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
