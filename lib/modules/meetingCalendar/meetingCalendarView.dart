import 'dart:developer';

import '../base/baseView.dart';
import 'meetingCalendarModel.dart';
import '../../utils/screenUtil.dart';
import '../../widgets/appAppBar.dart';
import '../../widgets/appSpinner.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MeetingCalendarView extends StatefulWidget {
  @override
  _MeetingCalendarViewState createState() => _MeetingCalendarViewState();
}

class _MeetingCalendarViewState extends State<MeetingCalendarView> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BaseView<MeetingCalendarModel>(
      model: MeetingCalendarModel(),
      builder: (context, model, _) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Scaffold(
              appBar: AppAppBar(
                allowBack: true,
              ),
              body: _buildView(context, model),
            ),
            model.loading ? AppSpinner() : Container()
          ],
        );
      },
    );
  }

  Widget _buildView(BuildContext context, MeetingCalendarModel model) {
    return SfCalendar(
      view: CalendarView.month,
      onTap: (cal) {
        log('on tap ${cal.date}');
        Navigator.of(context).pop(cal?.date);
      },
      // onSelectionChanged: (cal) {
      //   log('onSelectionChanged: ${cal.date}');
      // },
    );
  }
}
