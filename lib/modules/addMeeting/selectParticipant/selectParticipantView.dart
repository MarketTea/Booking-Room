import 'package:demo_b/models/user/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user_bloc/user_bloc.dart';
import '../../../constants/appColor.dart';
import '../../../core/locales/i18nKey.dart';
import '../../../utils/screenUtil.dart';
import '../../../utils/toast.dart';
import '../../../widgets/appAppBar.dart';
import '../../../widgets/appInput.dart';
import '../../../widgets/appSpinner.dart';
import '../../../widgets/selectParticipantTitle.dart';
import '../../base/baseView.dart';
import 'selectParticipantModel.dart';

class SelectParticipantView extends StatefulWidget {
  final List<String> lsSelected;

  const SelectParticipantView({
    Key key,
    this.lsSelected = const [],
  }) : super(key: key);
  @override
  _SelectParticipantViewState createState() => _SelectParticipantViewState();
}

class _SelectParticipantViewState extends State<SelectParticipantView> {
  List<SelectParticipantItem> participantList = [];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BlocProvider(
      create: (context) => UserBloc()..add(UserFetchEvent()),
      child: BaseView<SelectParticipantModel>(
        model: SelectParticipantModel(),
        builder: (context, model, _) {
          return WillPopScope(
            onWillPop: () {
              Navigator.of(context).pop(model.items
                  .where((e) => e.selected)
                  .toList()
                  .map((e) => e.id)
                  .toList());
              return Future.value(false);
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Scaffold(
                  appBar: AppAppBar(
                    centerTitle: true,
                    title: '${ScreenUtil.t(I18nKey.participant)}',
                    allowBack: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pop(model.items
                            .where((e) => e.selected)
                            .toList()
                            .map((e) => e.id)
                            .toList());
                      },
                    ),
                  ),
                  body: _buildView(context, model),
                ),
                model.loading ? AppSpinner() : Container()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildView(BuildContext context, SelectParticipantModel model) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserFetchDoneState) {
          model.items.clear();
          model.items.addAll(
            state.lsData
                .map((e) => SelectParticipantItem(
                      id: e.id,
                      title: e.email,
                      selected: widget.lsSelected.contains(e.id),
                    ))
                .toList(),
          );
          participantList = model.items;
        }
        if (state is UserFetchFailState) {
          Toast.error(message: state.message ?? '');
        } else if (state is UserExceptionState) {
          Toast.error(message: state.message ?? '');
        }
      },
      child: Container(
        color: AppColor.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: AppInput(
                outlined: true,
                hintText: '${ScreenUtil.t(I18nKey.search)}',
                search: true,
                onChanged: (text) {
                  setState(() {
                    if (text.trim().isEmpty || text == null) {
                      participantList = model.items;
                    } else {
                      participantList = model.items
                          .where((e) => e.title.contains(text.trim()))
                          .toList();
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: (state is UserFetchDoneState)
                        ? participantList.length > 0
                            ? ListView.builder(
                                itemBuilder: (context, index) =>
                                    _buildTile(model, index, participantList),
                                itemCount: participantList.length,
                              )
                            : Text('No result')
                        : (state is UserFetchFailState ||
                                state is UserExceptionState)
                            ? InkWell(
                                onTap: () {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UserFetchEvent());
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              )
                            : Center(
                                child: CupertinoActivityIndicator(),
                              ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    SelectParticipantModel model,
    int index,
    List<SelectParticipantItem> items,
  ) {
    return SelectParticipantTile(
      title: items[index].title,
      avatar: items[index].avatar,
      selected: items[index].selected,
      onChanged: (value) {
        items[index].selected = value;
        model.onChangedSelectItem(items[index], value);
      },
    );
  }
}
