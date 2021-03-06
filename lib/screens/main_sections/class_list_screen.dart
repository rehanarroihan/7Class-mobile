import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sevenclass/bloc/classes/bloc.dart';
import 'package:sevenclass/helpers/app_color.dart';
import 'package:sevenclass/helpers/constant_helper.dart';
import 'package:sevenclass/models/my_classes_model.dart';
import 'package:sevenclass/screens/classroom/main_screen.dart';
import 'package:sevenclass/screens/join_class_screen.dart';
import 'package:sevenclass/widgets/base/app_alert_dialog.dart';
import 'package:sevenclass/widgets/base/toast.dart';
import 'package:sevenclass/widgets/modules/classes/new_class_form.dart';

class ClassListScreen extends StatelessWidget {
  ClassesBloc _classesBloc;
  BuildContext context;

  _showDeleteAlert(String idClass) {
    AppAlertDialog(
      title: 'Delete',
      message: 'Are you sure want to delete the class ? all content inside will be deleted',
      leftButtonText: 'Cancel',
      onLeftButtonClick: () => Navigator.of(context).pop(),
      rightButtonText: 'Yes, delete',
      rightButtonColor: Colors.red,
      onRightButtonClick: () {
        _classesBloc.add(DeleteClassEvent(idClass: idClass));
        Navigator.pop(context);
      },
    ).show(context);
  }

  _showLeaveAlert() {
    AppAlertDialog(
      title: 'Leave',
      message: 'Are you sure want to leave the class ?',
      leftButtonText: 'Cancel',
      onLeftButtonClick: () => Navigator.of(context).pop(),
      rightButtonText: 'Yes, leave',
      rightButtonColor: Colors.red,
      onRightButtonClick: () {},
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    _classesBloc = BlocProvider.of<ClassesBloc>(context);
    this.context = context;

    return BlocListener(
      bloc: _classesBloc,
      listener: (context, state) {
        if (state is CreateNewClassSuccessState) {
          showToast("Create class failed");
        } else if (state is CreateNewClassFailedState) {
          _classesBloc.add(GetMyClassEvent());
          showToast("Class created successfully");
          Navigator.pop(context);
        } else if (state is DeleteClassFailedState) {
          showToast(state.message);
        } else if (state is DeleteClassSuccessState) {
          showToast("Delete class success");
          _classesBloc.add(GetMyClassEvent());
        }
      },
      child: BlocBuilder(
        bloc: _classesBloc,
        builder: (context, state) => Scaffold(
          backgroundColor: AppColors.blueBackground,
          appBar: _appBar(),
          body: _body(),
          floatingActionButton: _fab(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 2.5,
      backgroundColor: AppColors.white,
      title: Text(
        'My Classes',
        style: TextStyle(
          fontFamily: ConstantHelper.PRIMARY_FONT,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          _classList(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FlatButton(
              onPressed: () => _showCreateNewClassDialog(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  Text(
                    'Buat Kelas Baru'
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _showCreateNewClassDialog() {
    showModalBottomSheet(
      context: this.context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        child: Text(
                          'Buat Kelas Baru',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                NewClassForm()
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _classList() {
    return ListView.builder(
      itemCount: _classesBloc.classList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection:  Axis.vertical,
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16
      ),
      itemBuilder: (BuildContext context, index) {
        Classes item = _classesBloc.classList[index];
        return _classItem(item);
      },
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      tooltip: 'Join class',
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => JoinClassScreen()
        ));
      },
      child: Icon(Icons.subdirectory_arrow_right),
      backgroundColor: Colors.blue,
    );
  }

  Widget _classItem(Classes item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0XFFD3D6DA).withAlpha(50),
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 1
          )
        ]
      ),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen())
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              bottom: 16
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: TextStyle(
                            fontFamily: ConstantHelper.PRIMARY_FONT,
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontFamily: ConstantHelper.PRIMARY_FONT,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _popUpMenu(item),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _popUpMenu(Classes classes) {
    return Column(
      children: <Widget>[
        PopupMenuButton<Choice>(
          onSelected: (item) {
            if (item.title == "Leave Class") {
              _showLeaveAlert();
            } else if (item.title == "Delete Class") {
              _showDeleteAlert(classes.id.toString());
            }
          },
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Row(
                  children: <Widget>[
                    Icon(
                      choice.icon,
                      size: 20,
                      color: choice.title == "Delete Class"
                          ? Colors.red
                          : Colors.black,
                    ),
                    SizedBox(width: 8),
                    Text(
                      choice.title,
                      style: TextStyle(
                        color: choice.title == "Delete Class"
                            ? Colors.red
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Leave Class', icon: Icons.exit_to_app),
    const Choice(title: 'Delete Class', icon: Icons.delete)
  ];
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}