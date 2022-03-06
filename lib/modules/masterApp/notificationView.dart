import 'package:demo_b/configs/svg_constants.dart';

import '../../constants/appColor.dart';
import '../../constants/appStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/notification/notification_bloc.dart';
import '../../models/notification/notification_api.dart';
import '../../utils/screenUtil.dart';
import '../../utils/toast.dart';
import '../roomMeetingDetail/room_meeting_detail.dart';

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  BuildContext currentContext;
  int currentPage = 1;
  final lsData = <NotificationModel>[];
  int maxPage = 0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('Load more data...');
      if (currentPage < maxPage) {
        currentPage += 1;
        print('currentPage = $currentPage');
        if (currentContext != null) {
          BlocProvider.of<NotificationBloc>(currentContext)
              .add(NotificationFetchEvent(page: currentPage));
        }
      }
    }
  }

  _setSetData() {
    maxPage = 0;
    currentPage = 1;
    lsData.clear();
    if (currentContext != null) {
      BlocProvider.of<NotificationBloc>(currentContext)
          .add(NotificationFetchEvent(page: currentPage));
    }
  }

  Widget _buildView(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationFetchDoneState) {
          lsData.addAll(state.data.data);
          maxPage = state.data?.metaData?.totalPage ?? 0;
        }
        if (state is NotificationFetchFailState) {
          Toast.error(message: state.message ?? '');
        }
        if (state is NotificationExceptionState) {
          Toast.error(message: state.message ?? '');
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          currentContext = context;
          return Material(
            color: AppColor.backgroundLight,
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    _setSetData();
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List.generate(
                          lsData.length,
                          (index) {
                            final item = lsData[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  final _meetingId =
                                      item?.data?.meetingId ?? '';
                                  if (_meetingId.isNotEmpty) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RoomMeetingDetail(
                                          meetingId: _meetingId,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: ListTile(
                                  leading: SvgIcon(
                                    SvgIcons.smartMeeting,
                                    size: 30,
                                    color: AppColor.primary,
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        item?.title ?? '',
                                        style: AppStyle.h5,
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        item?.title ?? '',
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    item?.body ?? '',
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.info_rounded,
                                        size: 20.0,
                                        color: AppColor.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: (state is NotificationWaitingState)
                      ? Center(child: CupertinoActivityIndicator())
                      : SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (context) =>
          NotificationBloc()..add(NotificationFetchEvent(page: currentPage)),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Scaffold(
            body: _buildView(context),
          ),
        ],
      ),
    );
  }
}
