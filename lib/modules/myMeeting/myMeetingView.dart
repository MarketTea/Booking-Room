import 'dart:developer';
import 'dart:math';

// import 'package:dropdown_search/dropdown_search.dart';
import '../../constants/appStyle.dart';
import '../../models/meeting/meeting_model.dart';
import '../../modules/roomMeetingDetail/room_meeting_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:searchfield/searchfield.dart';

import '../../blocs/my_meeting/my_meeting_bloc.dart';
import '../../configs/config.dart';
import '../../constants/appColor.dart';
import '../../core/locales/i18nKey.dart';
import '../../models/room/room_model.dart';
import '../../utils/screenUtil.dart';
import '../../utils/toast.dart';
import '../../widgets/appInput.dart';
import '../../widgets/appSpinner.dart';
import '../../widgets/appTab.dart';
import '../../widgets/meetingTile.dart';
import '../../widgets/timelineTile.dart';
import '../base/baseView.dart';
import '../meetingCalendar/meetingCalendarView.dart';
import 'myMeetingModel.dart';

class MyMeetingView extends StatefulWidget {
  @override
  _MyMeetingViewState createState() => _MyMeetingViewState();
}

class _MyMeetingViewState extends State<MyMeetingView> {
  DateTime currentDate = DateTime.now();
  List<List<MeetingModel>> lsData = [];
  final rand = Random();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getBackgroundColor() {
    final num = rand.nextInt(3);
    switch (num) {
      case 1:
        return Color(0xffEDEDF8);
      case 2:
        return Color(0xffFCF3E4);
      default:
        return Color(0xffEBFAED);
    }
  }

  Widget _buildView(BuildContext context, MyMeetingModel model) {
    return BlocListener<MyMeetingBloc, MyMeetingState>(
      listener: (context, state) {
        // Check for the loading indicator
        // if (state is MyMeetingWaitingState) {
        //   model.setLoading(true);
        // } else {
        //   model.setLoading(false);
        // }
        if (state is MyMeetingFetchDoneState) {
          lsData = state.lsData;
        }
        if (state is MyMeetingExceptionState) {
          Toast.error(message: state.message ?? '');
        }
      },
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child:
                        /* AppInput(
                      outlined: true,
                      hintText: '${ScreenUtil.t(I18nKey.search)}',
                      search: true,
                      onSearch: () {},
                    ) */
                        BlocBuilder<MyMeetingBloc, MyMeetingState>(
                      builder: (context, state) {
                        return TypeAheadField<MeetingModel>(
                          textFieldConfiguration: TextFieldConfiguration(
                              // autofocus: true,
                              textInputAction: TextInputAction.done,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {},
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8)),
                                hintText: '${ScreenUtil.t(I18nKey.search)}',
                                hintStyle: AppStyle.title2Secondary,
                              )),
                          suggestionsCallback: (search) async {
                            // return await BackendService.getSuggestions(pattern);
                            final ls = <MeetingModel>[
                              for (final item in lsData)
                                for (final item2 in item)
                                  if (item2.name
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                                    item2
                            ];
                            return ls;
                          },
                          itemBuilder: (context, suggestion) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          suggestion.name,
                                          style: AppStyle.h4,
                                        ),
                                      ),
                                      Text(
                                        (suggestion.room as RoomModel).name,
                                        style: AppStyle.content,
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: getBackgroundColor(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RoomMeetingDetail(
                                  meetingId: suggestion.id,
                                ),
                              ),
                            );
                          },
                          noItemsFoundBuilder: (context) => SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Không có kết quả!'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      // Navigator.of(context)
                      //     .pushNamed(RouteName.meetingCalendar);
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MeetingCalendarView(),
                        ),
                      );
                      if (res != null) {
                        currentDate = res as DateTime;
                        if (model.currentTab == 0) {
                          BlocProvider.of<MyMeetingBloc>(context)
                              .add(MyMeetingFetchEvent(
                            startTime: DateTime(currentDate.year,
                                    currentDate.month, currentDate.day, 0, 0, 0)
                                .millisecondsSinceEpoch,
                            endTime: DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day,
                                    23,
                                    59,
                                    59)
                                .millisecondsSinceEpoch,
                          ));
                        } else {
                          BlocProvider.of<MyMeetingBloc>(context)
                              .add(MyMeetingIBookedFetchEvent(
                            startTime: DateTime(currentDate.year,
                                    currentDate.month, currentDate.day, 0, 0, 0)
                                .millisecondsSinceEpoch,
                            endTime: DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day,
                                    23,
                                    59,
                                    59)
                                .millisecondsSinceEpoch,
                          ));
                        }
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: AppTab(
                        title: 'Liên quan đến tôi',
                        selected: model.currentTab == 0,
                        onPressed: () {
                          model.changeTab(0);
                          BlocProvider.of<MyMeetingBloc>(context)
                              .add(MyMeetingFetchEvent(
                            startTime: DateTime(currentDate.year,
                                    currentDate.month, currentDate.day, 0, 0, 0)
                                .millisecondsSinceEpoch,
                            endTime: DateTime(
                                    currentDate.year,
                                    currentDate.month,
                                    currentDate.day,
                                    23,
                                    59,
                                    59)
                                .millisecondsSinceEpoch,
                          ));
                        },
                      ),
                    ),
                    AppTab(
                      title: 'Lịch họp tôi đặt',
                      selected: model.currentTab == 1,
                      onPressed: () {
                        model.changeTab(1);
                        BlocProvider.of<MyMeetingBloc>(context)
                            .add(MyMeetingIBookedFetchEvent(
                          startTime: DateTime(currentDate.year,
                                  currentDate.month, currentDate.day, 0, 0, 0)
                              .millisecondsSinceEpoch,
                          endTime: DateTime(currentDate.year, currentDate.month,
                                  currentDate.day, 23, 59, 59)
                              .millisecondsSinceEpoch,
                        ));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MyMeetingBloc, MyMeetingState>(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: (state is MyMeetingFetchDoneState)
                          ? SizedBox.expand(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  if (model.currentTab == 0) {
                                    BlocProvider.of<MyMeetingBloc>(context)
                                        .add(MyMeetingFetchEvent(
                                      startTime: DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day,
                                              0,
                                              0,
                                              0)
                                          .millisecondsSinceEpoch,
                                      endTime: DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day,
                                              23,
                                              59,
                                              59)
                                          .millisecondsSinceEpoch,
                                    ));
                                  } else {
                                    BlocProvider.of<MyMeetingBloc>(context)
                                        .add(MyMeetingIBookedFetchEvent(
                                      startTime: DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day,
                                              0,
                                              0,
                                              0)
                                          .millisecondsSinceEpoch,
                                      endTime: DateTime(
                                              currentDate.year,
                                              currentDate.month,
                                              currentDate.day,
                                              23,
                                              59,
                                              59)
                                          .millisecondsSinceEpoch,
                                    ));
                                  }
                                },
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final meetings =
                                        state?.lsData?.elementAt(index);
                                    return (meetings?.length ?? 0) == 0
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25),
                                            child: Center(
                                                child: Text(
                                              'Không có dữ liệu',
                                              style: TextStyle(
                                                  color: Colors.blueGrey),
                                            )),
                                          )
                                        : TimelineTile(
                                            time: AppConfig.dateFormat.format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        meetings
                                                                ?.elementAt(0)
                                                                ?.startTime ??
                                                            0)),
                                            data: List.generate(
                                                meetings?.length ?? 0,
                                                (index2) {
                                              RoomModel room = meetings[index2]
                                                  .room as RoomModel;
                                              final meeting =
                                                  meetings.elementAt(index2);
                                              return MeetingItem(
                                                start: AppConfig.timeFormat
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meeting?.startTime ??
                                                                0)),
                                                end: AppConfig.timeFormat
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meeting?.endTime ??
                                                                0)),
                                                title: meeting?.name ?? '',
                                                room: room?.name ?? '',
                                                meetingId: meeting?.id ?? '',
                                              );
                                            }),
                                            type: index % 3,
                                          );
                                  },
                                  itemCount: state.lsData?.length ??
                                      0, // length list of list
                                ),
                              ),
                            )
                          : Center(
                              child: CupertinoActivityIndicator(),
                            ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BlocProvider(
      create: (context) => MyMeetingBloc()
        ..add(MyMeetingFetchEvent(
          startTime: DateTime(
                  currentDate.year, currentDate.month, currentDate.day, 0, 0, 0)
              .millisecondsSinceEpoch,
          endTime: DateTime(currentDate.year, currentDate.month,
                  currentDate.day, 23, 59, 59)
              .millisecondsSinceEpoch,
        )),
      child: BaseView<MyMeetingModel>(
        model: MyMeetingModel(),
        builder: (context, model, _) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: Scaffold(
                  body: _buildView(context, model),
                ),
              ),
              model.loading ? AppSpinner() : Container()
            ],
          );
        },
      ),
    );
  }
}
