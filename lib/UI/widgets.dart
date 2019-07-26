import 'package:flutter/material.dart';

import 'sections.dart';

import 'package:percent_indicator/percent_indicator.dart';

const double kSectionIndicatorWidth = 32.0;

// The card for a single section. Displays the section's gradient and background image.
class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: section.title,
      button: true,
      child: DecoratedBox(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            section.leftColor,
            section.rightColor,
          ],
        ),
      )),
    );
  }
}

// The title is rendered with two overlapping text widgets that are vertically
// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final Section section;
  final double scale;
  final double opacity;

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Raleway',
    inherit: false,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4.0,
                child: Text(section.title, style: sectionTitleShadowStyle),
              ),
              Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity = 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: kSectionIndicatorWidth,
        height: 3.0,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

// Display a single SectionDetail.
class SectionDetailView extends StatelessWidget {
  final AttendanceDetail detail;
  SectionDetailView({this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    detail.subject,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      detail.subjectCode,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      '${detail.percentage.floor().toString()} %',
                      style: TextStyle(
                          color: detail.percentage.floor() > 85
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 25.0,
                    animationDuration: 2000,
                    percent: detail.percentage / 100,
                    center: Text(
                      '${detail.attendedClasses}/${detail.numOfClasses}',
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    linearGradient: detail.percentage.floor() > 85
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF60FE26),
                              const Color(0xFFB9FF2C)
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFF0045),
                              const Color(0xFFFF2C71)
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}