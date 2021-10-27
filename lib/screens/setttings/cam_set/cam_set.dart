import 'package:flutter/material.dart';
import 'package:gloou/shared/secure_storage/secure_storage.dart';
import 'package:gloou/widgets/toggle_widget.dart';

class CamSet extends StatefulWidget {
  const CamSet({Key? key}) : super(key: key);

  @override
  _CamSetState createState() => _CamSetState();
}

class _CamSetState extends State<CamSet> {
  final FocusNode toggleNode = FocusNode();

  late bool allowComments;
  late bool saveToGallery;
  late bool allowReplay;
  bool isLoading = true;
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    var isAllowComments = await secureStorage.readSecureData('isAllowComments');
    var isSaveToGallery = await secureStorage.readSecureData('isSaveToGallery');
    var isAllowReplay = await secureStorage.readSecureData('isAllowReplay');
    setState(() {
      if (isAllowComments != null) {
        if (isAllowComments == 'true') {
          allowComments = true;
        } else {
          allowComments = false;
        }
      } else {
        allowComments = true;
      }
      if (isSaveToGallery != null) {
        if (isSaveToGallery == 'true') {
          saveToGallery = true;
        } else {
          saveToGallery = false;
        }
      } else {
        saveToGallery = false;
      }
      if (isAllowReplay != null) {
        if (isAllowReplay == 'true') {
          allowReplay = true;
        } else {
          allowReplay = false;
        }
      } else {
        allowReplay = true;
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
          'Camera',
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
                  text: 'Allow comments',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                          'isAllowComments', value.toString());
                      this.allowComments = value;
                    });
                  },
                  value: allowComments,
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Save to Gallery',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                          'isSaveToGallery', value.toString());
                      this.saveToGallery = value;
                    });
                  },
                  value: saveToGallery,
                ),
                SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                  text: 'Allow comments',
                  onToggleChanged: (value) {
                    setState(() {
                      secureStorage.writeSecureData(
                          'isAllowReplay', value.toString());
                      this.allowReplay = value;
                    });
                  },
                  value: allowReplay,
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
