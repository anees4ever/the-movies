import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movies/app/extensions/dateformat.dart';
import 'package:the_movies/app/theme/colors.dart';
import 'package:the_movies/app/theme/styles.dart';
import 'package:the_movies/app/widgets/buttons.dart';
import 'package:the_movies/app/widgets/error_page.dart';
import 'package:the_movies/features/booking/demo_data/demo.dart';
import 'package:the_movies/features/booking/provider/booking_provider.dart';

class BookingSeatsPage extends StatefulWidget {
  static const String routeName = "/booking/seats";
  const BookingSeatsPage({super.key});

  @override
  State<BookingSeatsPage> createState() => _BookingSeatsPageState();
}

class _BookingSeatsPageState extends State<BookingSeatsPage> {
  final ScrollController _selectedSeatScroller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BookingProvider provider = context.read<BookingProvider>();

      provider.initSeats();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
      if (bookingProvider.movieInfo == null) {
        return const ErrorPage(
          title: "Movie Details not found...",
          error: "No movie found in the response.",
        );
      } else if (bookingProvider.showTime.id == 0) {
        return const ErrorPage(
          title: "Show time not found...",
          error: "No Show found in the response.",
        );
      }

      CinemaScreen cinemaScreen =
          getCinemaScreen(bookingProvider.showTime.screen);

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
                  bookingProvider.movieInfo!.data.title,
                  style: text16BoldStyle,
                ),
              ),
              Center(
                child: Text(
                  "${bookingProvider.bookingDate.quickFormat("MMMM dd, yyyy")} | ${bookingProvider.showTime.time} ${bookingProvider.showTime.screen}",
                  style: text12BlueStyle,
                ),
              ),
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        extendBody: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: colorDivider,
                      shape: BoxShape.rectangle,
                    ),
                    child: ScreenSeatArrangementView(
                      cinemaScreen: cinemaScreen,
                      bookingProvider: bookingProvider,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
              child: Row(
                children: [
                  Image(
                    width: 20,
                    height: 20,
                    image: AssetImage(
                      "assets/icons/ic_seats_selected.png",
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text("Selected", style: text14Style),
                  Expanded(flex: 1, child: SizedBox()),
                  Image(
                    width: 20,
                    height: 20,
                    image: AssetImage(
                      "assets/icons/ic_seats_booked.png",
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text("Not available", style: text14Style),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
              child: Row(
                children: [
                  const Image(
                    width: 20,
                    height: 20,
                    image: AssetImage(
                      "assets/icons/ic_seats_vip.png",
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text("VIP (${bookingProvider.showTime.vipRate}\$)",
                      style: text14Style),
                  const Expanded(flex: 1, child: SizedBox()),
                  const Image(
                    width: 20,
                    height: 20,
                    image: AssetImage(
                      "assets/icons/ic_seats_regular.png",
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text("Regular (${bookingProvider.showTime.regularRate}\$)",
                      style: text14Style),
                  const Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _selectedSeatScroller,
                  child: SizedBox(
                    height: 52,
                    child: ListView.separated(
                      controller: _selectedSeatScroller,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 4.0),
                      itemCount: bookingProvider.selectedSeats.length,
                      itemBuilder: (context, index) => InputChip(
                        backgroundColor: colorDivider,
                        onDeleted: () {
                          bookingProvider
                              .removeSeat(bookingProvider.selectedSeats[index]);
                        },
                        side: BorderSide.none,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${bookingProvider.selectedSeats[index].seatNo} / ",
                              style: text14BoldStyle,
                            ),
                            Text(
                              "${bookingProvider.selectedSeats[index].row} row ",
                              style: text14BoldStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 30,
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(2.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: colorDivider,
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Total Price",
                            style: text10Style,
                          ),
                          Text(
                            bookingProvider.seatsSelected
                                ? "\$ ${bookingProvider.getTotal()}"
                                : "\$ 0",
                            style: text16BoldStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 70,
                    child: bookingProvider.seatsSelected
                        ? getPrimaryButton(
                            height: 50,
                            isBig: true,
                            title: "Proceed to pay",
                          )
                        : getSecondaryButton(
                            height: 50,
                            isBig: true,
                            title: "Proceed to pay",
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ScreenSeatArrangementView extends StatelessWidget {
  const ScreenSeatArrangementView({
    super.key,
    required this.cinemaScreen,
    this.bookingProvider,
    this.scaledView = false,
    this.boxWidth = 0.0,
    this.boxHeight = 0.0,
  }) : assert(!scaledView || (boxWidth > 0 && boxWidth > 0),
            "Set Box Size if scaledView set to true");

  final CinemaScreen cinemaScreen;
  final BookingProvider? bookingProvider;
  final bool scaledView;
  final double boxWidth;
  final double boxHeight;

  @override
  Widget build(BuildContext context) {
    final comWidth = (MediaQuery.of(context).size.width / 29);
    final itemWidth = (comWidth - 6).roundToDouble();
    final itemHeight = itemWidth;
    final double width =
        (cinemaScreen.seatingArrangement[1]!.length * (itemWidth + 6)) +
            (itemWidth + 6);
    final double height =
        (cinemaScreen.seatingArrangement.length * (itemHeight + 14)) + 60;

    var transformationController = TransformationController();

    if (scaledView) {
      const zoomFactor = 0.50;
      final xTranslate = (boxWidth / 8) * zoomFactor;
      final yTranslate = (boxHeight / 4) * zoomFactor;
      transformationController.value.setEntry(0, 0, zoomFactor);
      transformationController.value.setEntry(1, 1, zoomFactor);
      transformationController.value.setEntry(2, 2, zoomFactor);

      transformationController.value.setEntry(0, 3, xTranslate);
      transformationController.value.setEntry(1, 3, yTranslate);
    }

    return IgnorePointer(
      ignoring: bookingProvider == null,
      child: InteractiveViewer(
        alignment: Alignment.topLeft,
        constrained: false,
        panEnabled: bookingProvider != null,
        scaleEnabled: false,
        transformationController: transformationController,
        child: Center(
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  width: width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        left: itemWidth + 6,
                        right: 0,
                        child: const Image(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/icons/ic_screen_face.png"),
                        ),
                      ),
                      const Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Text(
                          "SCREEN",
                          style: text10TintedStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                ...cinemaScreen.seatingArrangement.keys
                    .map(
                      (row) => Row(
                        children: [
                          SizedBox(
                            width: itemWidth + 6,
                            child: Text("$row", style: text6BoldStyle),
                          ),
                          ...cinemaScreen.seatingArrangement[row]!.map(
                            (seat) {
                              bool isSelected = bookingProvider != null &&
                                  bookingProvider!.selectedSeats.contains(seat);
                              return InkWell(
                                onTap: () {
                                  if (bookingProvider == null ||
                                      seat.isBooked ||
                                      seat.seatNo == 0) {
                                    return;
                                  }
                                  bookingProvider!.toggleSeat(seat);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 3.0, vertical: 6.0),
                                  child: seat.seatNo == 0
                                      ? SizedBox(
                                          width: itemWidth,
                                          height: itemWidth,
                                        )
                                      : Image(
                                          width: itemWidth,
                                          height: itemHeight,
                                          image: AssetImage(
                                            seat.isBooked
                                                ? "assets/icons/ic_seats_booked.png"
                                                : (isSelected
                                                    ? "assets/icons/ic_seats_selected.png"
                                                    : (seat.isVipSeat
                                                        ? "assets/icons/ic_seats_vip.png"
                                                        : "assets/icons/ic_seats_regular.png")),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ).toList(),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
