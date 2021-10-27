import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/toggle_widget.dart';

class PushNotification extends StatefulWidget {
  const PushNotification({Key? key}) : super(key: key);

  @override
  _PushNotificationState createState() => _PushNotificationState();
}

class _PushNotificationState extends State<PushNotification> {
  final FocusNode toggleNode = FocusNode();

  late bool likeValue;
  late bool messageValue;
  late bool commentValue;
  bool isLoading = true;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    var isLikeNotify = await secureStorage.readSecureData('isLikeNotify');
    var isMessageNotify = await secureStorage.readSecureData('isMessageNotify');
    var isCommentNotify = await secureStorage.readSecureData('isCommentNotify');
    setState(() {
      if (isLikeNotify != null) {
        if (isLikeNotify == 'true') {
          likeValue = true;
        } else {
          likeValue = false;
        }
      } else {
        likeValue = false;
      }
      if (isMessageNotify != null) {
        if (isMessageNotify == 'true') {
          messageValue = true;
        } else {
          messageValue = false;
        }
      } else {
        messageValue = false;
      }
      if (isCommentNotify != null) {
        if (isCommentNotify == 'true') {
          commentValue = true;
        } else {
          commentValue = false;
        }
      } else {
        commentValue = false;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Push Notification',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: EdgeInsets.all(15),
              children: [
                buildMenuItem(
                  text: 'Likes',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                        'isLikeNotify',
                        value.toString(),
                      );
                      this.likeValue = value;
                    });
                  },
                  value: likeValue,
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Messages',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                        'isMessageNotify',
                        value.toString(),
                      );
                      this.messageValue = value;
                    });
                  },
                  value: messageValue,
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Comments',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                        'isCommentNotify',
                        value.toString(),
                      );
                      this.commentValue = value;
                    });
                  },
                  value: commentValue,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }

  Widget buildMenuItem({
    required String text,
    bool value = false,
    double toggleSize = 1,
    double textSize = 16,
    required ValueChanged onToggleChanged,
  }) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: textSize,
        ),
      ),
      trailing: ToggleWidget(
        value: value,
        onChanged: onToggleChanged,
        sizeNumber: toggleSize,
        toggleNode: toggleNode,
      ),
    );
  }
}
