import 'dart:convert';
import 'dart:developer';

import '../../blocs/room/room_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../blocs/meeting_type/meeting_type_bloc.dart';
import '../../constants/appColor.dart';
import '../../core/locales/i18nKey.dart';
import '../../core/routes/routeName.dart';
import '../../models/meeting/meeting_model.dart';
import '../../repositories/meeting/meeting_res.dart';
import '../../utils/screenUtil.dart';
import '../../utils/toast.dart';
import '../../widgets/appAppBar.dart';
import '../../widgets/appButton.dart';
import '../../widgets/appInput.dart';
import '../../widgets/appSpinner.dart';
import '../../widgets/orderRoomTile.dart';
import '../../widgets/selectRepeatTile.dart';
import '../../widgets/selectRoomTile.dart';
import '../base/baseView.dart';
import 'addMeetingModel.dart';
import 'selectParticipant/selectParticipantView.dart';
import 'selectRepeat/selectRepeatView.dart';
import 'selectRoom/selectRoomView.dart';

class AddMeetingView extends StatefulWidget {
  const AddMeetingView({Key key, this.initModel, this.navigator})
      : super(key: key);

  final MeetingModel initModel;
  final Function navigator;

  @override
  _AddMeetingViewState createState() => _AddMeetingViewState();
}

class _AddMeetingViewState extends State<AddMeetingView> {
  final txtNote = TextEditingController();
  final txtTitle = TextEditingController();

  @override
  void dispose() {
    txtTitle.dispose();
    txtNote.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.initModel != null) {
      txtTitle.text = widget.initModel.name;
      txtNote.text = widget.initModel.note;
    }
    super.initState();
  }

  String _checkValid(AddMeetingModel model) {
    if (txtTitle.text.isEmpty) {
      return 'Vui lòng nhập tiêu đề';
    } else if (model.model.type == null) {
      return 'Vui lòng chọn kịch bản';
    } else if (model.model.room == null) {
      return 'Vui lòng chọn phòng họp';
    } else if (model.model.startTime == null) {
      return 'Vui lòng chọn bắt đầu';
    } else if (model.model.endTime == null) {
      return 'Vui lòng chọn kết thúc';
    } else if (model.model.repeat == null) {
      return 'Vui lòng chọn lặp lại';
    } else if ((model?.model?.members?.length ?? 0) == 0) {
      return 'Vui lòng chọn người tham gia';
    } else if (!((model?.model?.startTime ?? 0) <
        (model?.model?.endTime ?? 0))) {
      return 'Thời gian cuộc họp không hợp lệ';
    }
    return null;
  }

  Widget _buildView(BuildContext context, AddMeetingModel model) {
    return BlocListener<MeetingTypeBloc, MeetingTypeState>(
      listener: (context, state) {
        if (state is MeetingTypeFetchDoneState) {
          model.updateMeetingType(state.lsData);
          if (widget.initModel != null) {
            model.onDropdownChanged(widget.initModel?.type);
          } else {
            model.onDropdownChanged(state.lsData.first.id);
          }
        }

        if (state is MeetingTypeFetchFailState) {
          Toast.error(message: state.message ?? '');
        } else if (state is MeetingTypeExceptionState) {
          Toast.error(message: state.message ?? '');
        }
      },
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: AppInput(
                          hintText: '${ScreenUtil.t(I18nKey.enterTitle)}',
                          controller: txtTitle,
                        ),
                      ),
                      BlocBuilder<MeetingTypeBloc, MeetingTypeState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Container(
                              color: AppColor.white,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(
                                        'Kịch bản',
                                        style: TextStyle(color: AppColor.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 12, right: 12, left: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 0),
                                                decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  value: model.dropdownValue,
                                                  items: model.dropdownList
                                                      .map((value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    _missFocus();
                                                    model.onDropdownChanged(
                                                        value);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            _buildTile(context, model, index),
                        itemCount: model.items.length,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: AppInput(
                          hintText: '${ScreenUtil.t(I18nKey.note)}',
                          multiline: 6,
                          controller: txtNote,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButton(
                      contained: true,
                      title: '${ScreenUtil.t(I18nKey.cancel)}',
                      onPressed: () {
                        widget.navigator != null
                            ? widget.navigator()
                            : Navigator.of(context).pop();
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppButton(
                      contained: true,
                      primary: true,
                      title: '${ScreenUtil.t(I18nKey.orderRoom)}',
                      onPressed: () async {
                        model.model.name = txtTitle.text;
                        model.model.note = txtNote.text;
                        final res = _checkValid(model);
                        if (res == null) {
                          //handle create or update meeting
                          final jsonData = model.model.toJson();
                          jsonData.removeWhere((key, value) => value == null);
                          debugPrint('Model to add: ${jsonEncode(jsonData)}');
                          bool res;
                          model.setLoading(true);
                          if (widget.initModel == null) {
                            res = await MeetingRes()
                                .createNewMeeting(model.model);
                          } else {
                            res = await MeetingRes()
                                .updateNewMeeting(model.model);
                          }
                          model.setLoading(false);
                          if (res ?? false) {
                            Toast.success(message: 'Thành công!');
                            Future.delayed(Duration(milliseconds: 300), () {
                              BlocProvider.of<RoomBloc>(context).add(
                                RoomChangeTabEvent(model.model.room as String),
                              );
                              widget.navigator != null
                                  ? widget.navigator()
                                  : Navigator.of(context).pop(true);
                            });
                          } else {
                            Toast.error(message: 'Thất bại!');
                          }
                        } else {
                          Toast.warn(message: res);
                        }
                      },
                    ),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, AddMeetingModel model, int index) {
    return OrderRoomTile(
      title: model.items[index].title,
      content: model.data[index],
      onPressed: navigate(context, index, model),
    );
  }

  Function navigate(
    BuildContext context,
    int index,
    AddMeetingModel model,
  ) {
    switch (index) {
      case 0:
        return () async {
          // Navigator.of(context).pushNamed(RouteName.selectRoom);
          _missFocus();
          final res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SelectRoomView(
                initRoom: widget.initModel?.room as String,
              ),
            ),
          );
          log('res = $res');
          if (res != null) {
            final room = res as SelectRoomItem;
            model.updateRoom(room.name);
            model.model.room = room.id;
          }
        };
      case 1:
        return () {
          _missFocus();
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            onChanged: (date) {
              print('change $date');
            },
            onConfirm: (date) {
              print('startDate $date');
              model.updateStart(date);
            },
            currentTime: DateTime.now(),
            locale: LocaleType.vi,
          );
        };
      case 2:
        return () {
          _missFocus();
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now(),
            onChanged: (date) {
              print('change $date');
            },
            onConfirm: (date) {
              print('endDate  $date');
              model.updateEnd(date);
            },
            currentTime: DateTime.now(),
            locale: LocaleType.vi,
          );
        };
      case 3:
        return () async {
          // Navigator.of(context).pushNamed(RouteName.selectRepeat);
          _missFocus();
          final res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SelectRepeatView(
                init: widget.initModel?.repeat ?? 0,
              ),
            ),
          );
          log('res = $res');
          if (res != null) {
            final repeat = res as SelectRepeatItem;
            model.updaterepeat(ScreenUtil.t(repeat.title));
            model.model.repeat = repeat.value;
          }
        };
      case 4:
        return () async {
          // Navigator.of(context).pushNamed(RouteName.selectParticipant);
          _missFocus();
          final res = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SelectParticipantView(
                lsSelected: widget.initModel?.members ?? [],
              ),
            ),
          );
          log('res = $res');
          if (res != null) {
            model.model.members = res;
            model.updateMember(model.model.members.length);
          }
        };
      default:
        return () {
          _missFocus();
          Navigator.of(context).pushNamed(RouteName.selectRoom);
        };
    }
  }

  _missFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (context) => MeetingTypeBloc()..add(MeetingTypeFetchEvent()),
      child: BaseView<AddMeetingModel>(
        model: AddMeetingModel(context)..init(initModel: widget.initModel),
        builder: (context, model, _) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Scaffold(
                appBar: widget.initModel != null
                    ? AppAppBar(
                        centerTitle: true,
                        title: 'Chỉnh sửa',
                        leading: InkWell(
                          child: Icon(
                            Icons.close,
                            color: AppColor.black,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    : null,
                body: GestureDetector(
                    onTap: () {
                      _missFocus();
                    },
                    child: _buildView(context, model)),
              ),
              model.loading ? AppSpinner() : Container()
            ],
          );
        },
      ),
    );
  }
}
