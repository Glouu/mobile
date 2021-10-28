import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloou/screens/camera/story_camera/story_camera.dart';
import 'package:gloou/screens/log_in/log_in.dart';
import 'package:gloou/screens/story_page/story_page.dart';
import 'package:gloou/shared/api_environment/api_utils.dart';
import 'package:gloou/shared/colors/colors.dart';
import 'package:gloou/shared/models/commentlikeModel/commentlikeModel.dart';
import 'package:gloou/shared/models/commentreplyModel/commentreplyModel.dart';
import 'package:gloou/shared/models/postcommentModel/postcommentModel.dart';
import 'package:gloou/shared/models/postidModel/postidModel.dart';
import 'package:gloou/shared/token/token.dart';
import 'package:gloou/shared/utilities/convert_image.dart';
import 'package:gloou/widgets/add_story_widget.dart';
import 'package:gloou/widgets/feed_image_widget.dart';
import 'package:gloou/widgets/feed_pdf_widget.dart';
import 'package:gloou/widgets/feed_text_widget.dart';
import 'package:gloou/widgets/feed_video_widget.dart';
import 'package:gloou/widgets/story_widget.dart';
import 'package:gloou/widgets/svg_icon_widget.dart';
import 'package:gloou/widgets/text_icon_widget.dart';
import 'package:gloou/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:http/http.dart' as http;

class Feeds extends StatefulWidget {
  // const Feeds({Key? key}) : super(key: key);
  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  PageController pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.7,
  );

  final TokenLogic tokenLogic = TokenLogic();

  final ConvertImage convertImage = ConvertImage();
  final commentFormKey = GlobalKey<FormState>();

  TextEditingController contentController = TextEditingController();
  SheetController _sheetController = SheetController();

  final FocusNode contentNode = FocusNode();

  bool isPostCircular = true;
  bool isProfileCircular = true;
  bool isStoryCircular = true;
  bool isImage = false;
  bool isSubmit = false;
  late bool isPostEmpty;
  late bool isStoryEmpty;

  // for comments
  late String commentValue;
  late String postId;
  bool _isLoadingComments = true;

  late Uint8List mediaData;

  bool isHeartAnimating = false;

  late Map<String, dynamic> userInfo;

  late String token;

  late List stories;

  late List posts;

  late List comments = [];

  late PostidModel _postidModel;
  late PostcommentModel _postcommentModel;
  late CommentreplyModel _commentreplyModel;
  late CommentlikeModel _commentlikeModel;

  fetchStory({int page = 1, int limit = 10}) async {
    var token = await tokenLogic.getToken();
    this.token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/Story/GetFeed');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {}
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  fetchPost({int page = 1, int limit = 10}) async {
    var token = await tokenLogic.getToken();
    this.token = await tokenLogic.getToken();
    if (token != null) {
      var url =
          Uri.parse(ApiUtils.API_URL + '/Post/GetFeed?limit=$limit&page=$page');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {}
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  getProfile() async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url = Uri.parse(ApiUtils.API_URL + '/User/GetUser');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // var jsonError = jsonDecode(response.body);
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  getComments(String postId) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url =
          Uri.parse(ApiUtils.API_URL + '/Post/Comment/GetAll?postID=$postId');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {}
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LogIn(),
        ),
        (route) => false,
      );
    }
  }

  _onRefresh() async {
    var list = await fetchPost(page: 1);
    var listData = list['data'];

    posts.clear();
    page = 1;

    setState(() {
      if (list != null) {
        if (listData.length > 0) {
          posts.addAll(listData);
          isPostCircular = false;
          isPostEmpty = false;
        } else {
          posts.addAll(listData);
          isPostCircular = false;
          isPostEmpty = true;
        }
      } else {
        posts.addAll(listData);
        isPostCircular = false;
        isPostEmpty = true;
      }
      _refreshController.refreshCompleted();
    });
  }

  _onLoading() async {
    page++;
    var list = await fetchPost(page: page);
    var listData = list['data'];

    setState(() {
      if (list != null) {
        if (listData.length > 0) {
          posts.addAll(listData);
          isPostCircular = false;
          isPostEmpty = false;
        } else {
          status = 'success';
          message = 'No more post to see';
          displayToast();
          isPostCircular = false;
          isPostEmpty = false;
        }
      } else {
        // posts.addAll(listData);
        status = 'success';
        message = 'No more post to see';
        displayToast();
        isPostCircular = false;
        isPostEmpty = true;
      }
      _refreshController.loadComplete();
    });
  }

  getCommentsByPostId({required String postId}) async {
    var token = await tokenLogic.getToken();
    if (token != null) {
      var url =
          Uri.parse(ApiUtils.API_URL + '/Post/Comment/GetAll?postID=$postId');
      var httpClient = http.Client();
      var response = await httpClient.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      } else {}
    } else {
      setState(() {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
          (route) => false,
        );
      });
    }
  }

  int page = 1;
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  // GlobalKey _contentKey = GlobalKey();
  GlobalKey _refreshKey = GlobalKey();

  late String status, message;

  final toast = FToast();

  void displayToast() => toast.showToast(
        child: ToastMessage(status: status, message: message),
        gravity: ToastGravity.TOP,
      );

  @override
  void initState() {
    toast.init(context);
    getProfile().then((data) {
      setState(() {
        userInfo = data['data'];
        isProfileCircular = false;
        fetchStory().then((storyRes) {
          setState(() {
            var storyData = storyRes['data'];
            if (storyRes != null) {
              if (storyData.length > 0) {
                stories = storyData;
                isStoryCircular = false;
                isStoryEmpty = false;
                fetchPost().then((data) {
                  setState(() {
                    var postData = data['data'];
                    if (data != null) {
                      if (postData.length > 0) {
                        posts = postData;
                        isPostCircular = false;
                        isPostEmpty = false;
                      } else {
                        isPostCircular = false;
                        isPostEmpty = true;
                      }
                    } else {
                      isPostCircular = false;
                      isPostEmpty = true;
                    }
                  });
                });
              } else {
                isStoryCircular = false;
                isStoryEmpty = true;
                fetchPost().then((data) {
                  setState(() {
                    var postData = data['data'];
                    if (data != null) {
                      if (postData.length > 0) {
                        posts = postData;
                        isPostCircular = false;
                        isPostEmpty = false;
                      } else {
                        isPostCircular = false;
                        isPostEmpty = true;
                      }
                    } else {
                      isPostCircular = false;
                      isPostEmpty = true;
                    }
                  });
                });
              }
            } else {
              isStoryCircular = false;
              isStoryEmpty = true;
              fetchPost().then((data) {
                setState(() {
                  var postData = data['data'];
                  if (data != null) {
                    if (postData.length > 0) {
                      posts = postData;
                      isPostCircular = false;
                      isPostEmpty = false;
                    } else {
                      isPostCircular = false;
                      isPostEmpty = true;
                    }
                  } else {
                    isPostCircular = false;
                    isPostEmpty = true;
                  }
                });
              });
            }
          });
        });
      });
    });

    contentController.addListener(() {
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SmartRefresher(
      key: _refreshKey,
      controller: _refreshController,
      enablePullUp: true,
      physics: BouncingScrollPhysics(),
      footer: ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
      ),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: isProfileCircular
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 25,
                      right: 10,
                      left: 20,
                    ),
                    child: CircularProgressIndicator(),
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoryCamera()),
                          );
                        },
                        child: AddStoryWidget(
                          img: convertImage.formatBase64(userInfo['image']),
                          username: userInfo['userName'],
                        ),
                      ),
                      isStoryCircular
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 25,
                                right: 10,
                                left: 20,
                              ),
                              child: CircularProgressIndicator(),
                            )
                          : isStoryEmpty
                              ? Row()
                              : Row(
                                  children: List.generate(stories.length, (i) {
                                    return Bounce(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StoryPage(
                                              userData: stories,
                                              singleUserData: stories[i],
                                              token: token,
                                            ),
                                          ),
                                        );
                                      },
                                      duration: Duration(milliseconds: 100),
                                      child: StoryWidget(
                                        img: convertImage.formatBase64(
                                            stories[i]['userImage']),
                                        username: stories[i]['userName'],
                                      ),
                                    );
                                  }),
                                ),
                    ],
                  ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
          ),
          SingleChildScrollView(
            child: isPostCircular
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : isPostEmpty
                    ? Center(
                        child: Text('You don\'t have any post'),
                      )
                    : Column(
                        children: List.generate(posts.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: posts[i]['isText']
                                ? Wrap(
                                    children: [
                                      FeedTextWidget(
                                        profileImagePost:
                                            convertImage.formatBase64(
                                                posts[i]['userImage']),
                                        username: posts[i]['userName'],
                                        name: posts[i]['firstName'] +
                                            ' ' +
                                            posts[i]['lastName'],
                                        texPost: posts[i]['caption'],
                                        onPressLike: () {
                                          posts[i]['isLiked']
                                              ? onSubmitLike(
                                                  posts[i]['id'], i, false)
                                              : onSubmitLike(
                                                  posts[i]['id'], i, true);
                                        },
                                        onPressComment: () {
                                          setState(() {
                                            if (comments.isNotEmpty) {
                                              comments.clear();
                                            }
                                            commentValue = posts[i]['caption'];
                                            postId = posts[i]['id'];
                                            getComments(postId).then((data) {
                                              setState(() {
                                                comments = data['data'];
                                                _isLoadingComments = false;
                                                _sheetController.rebuild();
                                              });
                                            });
                                          });
                                          showSheet();
                                        },
                                        onPressShare: () {
                                          posts[i]['isReposted']
                                              ? onSubmitShare(
                                                  posts[i]['id'], i, false)
                                              : onSubmitShare(
                                                  posts[i]['id'], i, true);
                                        },
                                        onPressSave: () {
                                          posts[i]['isSaved']
                                              ? onSubmitSave(
                                                  posts[i]['id'], i, false)
                                              : onSubmitSave(
                                                  posts[i]['id'], i, true);
                                        },
                                        isLike: posts[i]['isLiked'],
                                        isShare: posts[i]['isReposted'],
                                        isSave: posts[i]['isSaved'],
                                        countLikes: posts[i]['numberOfLikes']
                                            .toString(),
                                        countComments: posts[i]
                                                ['numberOfComments']
                                            .toString(),
                                        countShare: posts[i]['numberOfReposts']
                                            .toString(),
                                      )
                                    ],
                                  )
                                : Wrap(
                                    children: [
                                      posts[i]['files'][0]['fileType'] ==
                                              'image/jpeg'
                                          ? Container(
                                              height: (size.height) / 1.8,
                                              child: Stack(
                                                children: [
                                                  // if(posts[i]['files'][0][])
                                                  Column(
                                                    children: List.generate(
                                                        posts[i]['files']
                                                            .length, (j) {
                                                      return FeedImageWidget(
                                                          fileName: posts[i]
                                                                  ['files'][j]
                                                              ['fileName'],
                                                          token: token);
                                                    }),
                                                  ),
                                                  Container(
                                                    height: (size.height) / 1.8,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(
                                                                  0.25),
                                                          Colors.black
                                                              .withOpacity(0),
                                                        ],
                                                        begin: Alignment
                                                            .bottomCenter,
                                                        end:
                                                            Alignment.topCenter,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 20,
                                                        bottom: 10,
                                                        top: 10,
                                                        right: 10,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Positioned(
                                                            right: 10,
                                                            child: IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .more_horiz_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            MemoryImage(
                                                                          convertImage.formatBase64(posts[i]
                                                                              [
                                                                              'userImage']),
                                                                        ),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        posts[i]['firstName'] +
                                                                            ' ' +
                                                                            posts[i]['lastName'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Text(
                                                                        '@' +
                                                                            posts[i]['userName'],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                posts[i]
                                                                    ['caption'],
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  TextIconWidget(
                                                                    icons: posts[i]
                                                                            [
                                                                            'isLiked']
                                                                        ? Icons
                                                                            .favorite
                                                                        : Icons
                                                                            .favorite_border_rounded,
                                                                    iconSize:
                                                                        28,
                                                                    value: posts[i]
                                                                            [
                                                                            'numberOfLikes']
                                                                        .toString(),
                                                                    onPress:
                                                                        () {
                                                                      posts[i][
                                                                              'isLiked']
                                                                          ? onSubmitLike(
                                                                              posts[i][
                                                                                  'id'],
                                                                              i,
                                                                              false)
                                                                          : onSubmitLike(
                                                                              posts[i]['id'],
                                                                              i,
                                                                              true);
                                                                    },
                                                                    color: posts[i]
                                                                            [
                                                                            'isLiked']
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                  SvgIconWidget(
                                                                    imageLoc:
                                                                        'assets/images/comment.svg',
                                                                    value: posts[i]
                                                                            [
                                                                            'numberOfComments']
                                                                        .toString(),
                                                                    onPress:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (comments
                                                                            .isNotEmpty) {
                                                                          comments
                                                                              .clear();
                                                                        }
                                                                        commentValue =
                                                                            posts[i]['caption'];
                                                                        postId =
                                                                            posts[i]['id'];
                                                                        getComments(postId)
                                                                            .then((data) {
                                                                          setState(
                                                                              () {
                                                                            comments =
                                                                                data['data'];
                                                                            _isLoadingComments =
                                                                                false;
                                                                            _sheetController.rebuild();
                                                                          });
                                                                        });
                                                                      });
                                                                      showSheet();
                                                                    },
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  TextIconWidget(
                                                                    icons: Icons
                                                                        .cached_rounded,
                                                                    iconSize:
                                                                        30,
                                                                    value: posts[i]
                                                                            [
                                                                            'numberOfReposts']
                                                                        .toString(),
                                                                    onPress:
                                                                        () {
                                                                      posts[i][
                                                                              'isReposted']
                                                                          ? onSubmitShare(
                                                                              posts[i][
                                                                                  'id'],
                                                                              i,
                                                                              false)
                                                                          : onSubmitShare(
                                                                              posts[i]['id'],
                                                                              i,
                                                                              true);
                                                                    },
                                                                    color: posts[i]
                                                                            [
                                                                            'isReposted']
                                                                        ? mainColor
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                  Bounce(
                                                                    onPressed:
                                                                        () {
                                                                      posts[i][
                                                                              'isSaved']
                                                                          ? onSubmitSave(
                                                                              posts[i][
                                                                                  'id'],
                                                                              i,
                                                                              false)
                                                                          : onSubmitSave(
                                                                              posts[i]['id'],
                                                                              i,
                                                                              true);
                                                                    },
                                                                    child: Icon(
                                                                      posts[i][
                                                                              'isSaved']
                                                                          ? Icons
                                                                              .bookmark
                                                                          : Icons
                                                                              .bookmark_border_rounded,
                                                                      color: posts[i]
                                                                              [
                                                                              'isSaved']
                                                                          ? mainColor
                                                                          : Colors
                                                                              .white,
                                                                    ),
                                                                    duration: Duration(
                                                                        milliseconds:
                                                                            500),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : posts[i]['files'][0]['fileType'] ==
                                                  'application/pdf'
                                              ? Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 10,
                                                      top: 20,
                                                      bottom: 10,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        image: MemoryImage(
                                                                          convertImage.formatBase64(posts[i]
                                                                              [
                                                                              'userImage']),
                                                                        ),
                                                                        fit: BoxFit.cover),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      posts[i][
                                                                              'firstName'] +
                                                                          ' ' +
                                                                          posts[i]
                                                                              [
                                                                              'lastName'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Text(
                                                                      '@' +
                                                                          posts[i]
                                                                              [
                                                                              'userName'],
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                Icons
                                                                    .more_horiz_rounded,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Column(
                                                          children: List.generate(
                                                              posts[i]['files']
                                                                  .length, (j) {
                                                            return FeedPdfWidget(
                                                              fileName: posts[i]
                                                                      ['files'][
                                                                  j]['fileName'],
                                                              mainFileName: posts[
                                                                          i][
                                                                      'files'][j]
                                                                  [
                                                                  'mainFileName'],
                                                            );
                                                          }),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            TextIconWidget(
                                                              icons: posts[i][
                                                                      'isLiked']
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border_rounded,
                                                              iconSize: 28,
                                                              value: posts[i][
                                                                      'numberOfLikes']
                                                                  .toString(),
                                                              color: posts[i][
                                                                      'isLiked']
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black,
                                                              onPress: () {
                                                                posts[i][
                                                                        'isLiked']
                                                                    ? onSubmitLike(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        false)
                                                                    : onSubmitLike(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        true);
                                                              },
                                                            ),
                                                            SvgIconWidget(
                                                              imageLoc:
                                                                  'assets/images/comment.svg',
                                                              value: posts[i][
                                                                      'numberOfComments']
                                                                  .toString(),
                                                              onPress: () {
                                                                setState(() {
                                                                  if (comments
                                                                      .isNotEmpty) {
                                                                    comments
                                                                        .clear();
                                                                  }
                                                                  commentValue =
                                                                      posts[i][
                                                                          'caption'];
                                                                  postId =
                                                                      posts[i][
                                                                          'id'];
                                                                  getComments(
                                                                          postId)
                                                                      .then(
                                                                          (data) {
                                                                    setState(
                                                                        () {
                                                                      comments =
                                                                          data[
                                                                              'data'];
                                                                      _isLoadingComments =
                                                                          false;
                                                                      _sheetController
                                                                          .rebuild();
                                                                    });
                                                                  });
                                                                });
                                                                showSheet();
                                                              },
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            TextIconWidget(
                                                              icons: Icons
                                                                  .cached_rounded,
                                                              iconSize: 30,
                                                              value: posts[i][
                                                                      'numberOfReposts']
                                                                  .toString(),
                                                              onPress: () {
                                                                posts[i][
                                                                        'isReposted']
                                                                    ? onSubmitShare(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        false)
                                                                    : onSubmitShare(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        true);
                                                              },
                                                              color: posts[i][
                                                                      'isReposted']
                                                                  ? mainColor
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            Bounce(
                                                              onPressed: () {
                                                                posts[i][
                                                                        'isSaved']
                                                                    ? onSubmitSave(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        false)
                                                                    : onSubmitSave(
                                                                        posts[i]
                                                                            [
                                                                            'id'],
                                                                        i,
                                                                        true);
                                                              },
                                                              child: Icon(
                                                                posts[i][
                                                                        'isSaved']
                                                                    ? Icons
                                                                        .bookmark
                                                                    : Icons
                                                                        .bookmark_border_rounded,
                                                                color: posts[i][
                                                                        'isSaved']
                                                                    ? mainColor
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : posts[i]['files'][0]
                                                          ['fileType'] ==
                                                      'video/mp4'
                                                  ? Container(
                                                      height:
                                                          (size.height) / 1.8,
                                                      child: Stack(
                                                        children: [
                                                          // if(posts[i]['files'][0][])
                                                          Column(
                                                            children: List.generate(
                                                                posts[i][
                                                                        'files']
                                                                    .length,
                                                                (j) {
                                                              return FeedVideoWidget(
                                                                  fileName: posts[
                                                                              i]
                                                                          [
                                                                          'files'][j]
                                                                      [
                                                                      'fileName'],
                                                                  token: token);
                                                            }),
                                                          ),
                                                          Container(
                                                            height:
                                                                (size.height) /
                                                                    1.8,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.25),
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0),
                                                                ],
                                                                begin: Alignment
                                                                    .bottomCenter,
                                                                end: Alignment
                                                                    .topCenter,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                bottom: 10,
                                                                top: 10,
                                                                right: 10,
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    right: 10,
                                                                    child:
                                                                        IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .more_horiz_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                40,
                                                                            height:
                                                                                40,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                image: MemoryImage(
                                                                                  convertImage.formatBase64(posts[i]['userImage']),
                                                                                ),
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                15,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                posts[i]['firstName'] + ' ' + posts[i]['lastName'],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 20,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 3,
                                                                              ),
                                                                              Text(
                                                                                '@' + posts[i]['userName'],
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        posts[i]
                                                                            [
                                                                            'caption'],
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              14,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          TextIconWidget(
                                                                            icons: posts[i]['isLiked']
                                                                                ? Icons.favorite
                                                                                : Icons.favorite_border_rounded,
                                                                            iconSize:
                                                                                28,
                                                                            value:
                                                                                posts[i]['numberOfLikes'].toString(),
                                                                            onPress:
                                                                                () {
                                                                              posts[i]['isLiked'] ? onSubmitLike(posts[i]['id'], i, false) : onSubmitLike(posts[i]['id'], i, true);
                                                                            },
                                                                            color: posts[i]['isLiked']
                                                                                ? Colors.red
                                                                                : Colors.white,
                                                                          ),
                                                                          SvgIconWidget(
                                                                            imageLoc:
                                                                                'assets/images/comment.svg',
                                                                            value:
                                                                                posts[i]['numberOfComments'].toString(),
                                                                            onPress:
                                                                                () {
                                                                              setState(() {
                                                                                if (comments.isNotEmpty) {
                                                                                  comments.clear();
                                                                                }
                                                                                commentValue = posts[i]['caption'];
                                                                                postId = posts[i]['id'];
                                                                                getComments(postId).then((data) {
                                                                                  setState(() {
                                                                                    comments = data['data'];
                                                                                    _isLoadingComments = false;
                                                                                    _sheetController.rebuild();
                                                                                  });
                                                                                });
                                                                              });
                                                                              showSheet();
                                                                            },
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          TextIconWidget(
                                                                            icons:
                                                                                Icons.cached_rounded,
                                                                            iconSize:
                                                                                30,
                                                                            value:
                                                                                posts[i]['numberOfReposts'].toString(),
                                                                            onPress:
                                                                                () {
                                                                              posts[i]['isReposted'] ? onSubmitShare(posts[i]['id'], i, false) : onSubmitShare(posts[i]['id'], i, true);
                                                                            },
                                                                            color: posts[i]['isReposted']
                                                                                ? mainColor
                                                                                : Colors.white,
                                                                          ),
                                                                          Bounce(
                                                                            onPressed:
                                                                                () {
                                                                              posts[i]['isSaved'] ? onSubmitSave(posts[i]['id'], i, false) : onSubmitSave(posts[i]['id'], i, true);
                                                                            },
                                                                            duration:
                                                                                Duration(milliseconds: 500),
                                                                            child:
                                                                                Icon(
                                                                              posts[i]['isSaved'] ? Icons.bookmark : Icons.bookmark_border_rounded,
                                                                              color: posts[i]['isSaved'] ? mainColor : Colors.white,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                    ],
                                  ),
                          );
                        }),
                      ),
          ),
        ],
      ),
    );
  }

  Future showSheet() => showSlidingBottomSheet(
        context,
        builder: (context) => SlidingSheetDialog(
          controller: _sheetController,
          cornerRadius: 15,
          avoidStatusBar: true,
          snapSpec: SnapSpec(
            snappings: [0.7, 1],
            initialSnap: 0.7,
            onSnap: (state, snap) {
              snap == 0.0
                  ? contentController.text = ''
                  : contentController.text;
              snap == 0.0 ? _isLoadingComments = true : comments.length;
              _sheetController.rebuild();
            },
          ),
          builder: buildMainSheet,
          headerBuilder: buildSheetHeader,
          footerBuilder: buildSheetFooter,
        ),
      );

  Widget buildMainSheet(context, state) {
    var size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Material(
          child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 10,
              ),
              _isLoadingComments
                  ? Container(
                      height: (size.height) / 2,
                      child: Center(child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      child: Column(
                        children: List.generate(comments.length, (i) {
                          // print(comments[i]['image']);
                          return comments.length > 0
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: MemoryImage(
                                                    convertImage.formatBase64(
                                                        comments[i]['image'])),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '@' +
                                                          comments[i]
                                                              ['userName'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(comments[i]['content'])
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Bounce(
                                          child: comments[i]['isLikedByMe']
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : Icon(Icons
                                                  .favorite_border_rounded),
                                          duration: Duration(milliseconds: 300),
                                          onPressed: () {
                                            comments[i]['isLikedByMe']
                                                ? onSubmitCommentLike(
                                                    comments[i]['id'], i, false)
                                                : onSubmitCommentLike(
                                                    comments[i]['id'], i, true);
                                          },
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                )
                              : Container(
                                  child: Text('No comment for this post'),
                                );
                        }),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget buildSheetHeader(context, state) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: 5,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: (size.width) / 1,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                ),
                SizedBox(
                  width: (size.width) / 3.5,
                ),
                Text(
                  'Comment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSheetFooter(context, state) {
    var size = MediaQuery.of(context).size;
    bool showButton = false;
    return StatefulBuilder(
      builder: (
        BuildContext context,
        void Function(void Function()) setModalState,
      ) {
        return Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: (size.width) / 1,
                height: (size.height) / 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: commentFormKey,
                    child: Stack(
                      children: [
                        TextFormField(
                          controller: contentController,
                          focusNode: contentNode,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: (value) {
                            setModalState(() {
                              value.length > 0
                                  ? showButton = true
                                  : showButton = false;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            hintText: 'Add comment',
                            filled: true,
                            fillColor: Color(0xFFE3E5EA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: showButton
                                ? ElevatedButton(
                                    onPressed: isSubmit
                                        ? null
                                        : () {
                                            setModalState(() {
                                              isSubmit = true;
                                              onSubmitComment(postId);
                                            });
                                          },
                                    child: isSubmit
                                        ? CircularProgressIndicator()
                                        : Icon(Icons.send_rounded),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onSubmitLike(
    String postId,
    int i,
    bool isCreate,
  ) async {
    setState(() {
      posts[i]['isLiked'] = !posts[i]['isLiked'];
    });
    var token = await tokenLogic.getToken();

    _postidModel = PostidModel(postId: postId);

    var likeUrl = isCreate
        ? Uri.parse(ApiUtils.API_URL + '/Post/Like/Create')
        : Uri.parse(ApiUtils.API_URL + '/Post/Like/Remove');
    var httpClient = http.Client();
    var likeResponse = isCreate
        ? await httpClient.post(
            likeUrl,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          )
        : await httpClient.delete(
            likeUrl,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          );

    if (likeResponse.statusCode == 200) {
      var likeResponseDecode = jsonDecode(likeResponse.body);
      setState(() {
        if (likeResponseDecode['data']['total'] != null) {
          posts[i]['numberOfLikes'] = likeResponseDecode['data']['total'];
        } else {
          posts[i]['numberOfLikes'] = posts[i]['numberOfLikes'] - 1;
        }
      });
    } else {
      setState(() {
        posts[i]['isLike'] = !posts[i]['isLiked'];
      });
    }
  }

  void onSubmitComment(
    String postId,
  ) async {
    var token = await tokenLogic.getToken();

    _postcommentModel = PostcommentModel(
      postId: postId,
      content: contentController.text,
    );

    if (token != null) {
      var commentUrl = Uri.parse(ApiUtils.API_URL + '/Post/Comment/Create');
      var httpClient = http.Client();
      var commentResponse = await httpClient.post(
        commentUrl,
        body: jsonEncode(_postcommentModel.toJson()),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );

      if (commentResponse.statusCode == 200) {
        setState(() {
          isSubmit = false;
          contentController.text = '';
          _sheetController.rebuild();
        });
      } else {
        setState(() {
          isSubmit = false;
        });
      }
    }
  }

  void onSubmitCommentLike(
    String commentId,
    int i,
    bool isCreate,
  ) async {
    setState(() {
      comments[i]['isLikedByMe'] = !comments[i]['isLikedByMe'];
      _sheetController.rebuild();
    });

    var token = await tokenLogic.getToken();
    _commentlikeModel = CommentlikeModel(
      commentId: commentId,
      postId: postId,
    );
    print(_commentlikeModel.commentId);

    var url = isCreate
        ? Uri.parse(ApiUtils.API_URL + '/Post/Comment/Like')
        : Uri.parse(ApiUtils.API_URL + '/Post/Comment/Like');
    var httpClient = http.Client();
    var response = isCreate
        ? await httpClient.post(
            url,
            body: jsonEncode(_commentlikeModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          )
        : await httpClient.delete(
            url,
            body: jsonEncode(_commentlikeModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          );

    if (response.statusCode == 200) {
      var responseDecode = jsonEncode(response.body);
    } else {
      setState(() {
        comments[i]['isLikedByMe'] = !comments[i]['isLikedByMe'];
      });
    }
  }

  void onSubmitCommentReply(
    String commentId,
  ) async {}

  void onSubmitShare(
    String postId,
    int i,
    bool isCreate,
  ) async {
    setState(() {
      posts[i]['isReposted'] = !posts[i]['isReposted'];
    });
    var token = await tokenLogic.getToken();

    _postidModel = PostidModel(postId: postId);

    var shareUrl = isCreate
        ? Uri.parse(ApiUtils.API_URL + '/Post/Repost/Create')
        : Uri.parse(ApiUtils.API_URL + '/Post/Repost/Remove');
    print(shareUrl);
    var httpClient = http.Client();
    var shareResponse = isCreate
        ? await httpClient.post(
            shareUrl,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          )
        : await httpClient.post(
            shareUrl,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          );

    if (shareResponse.statusCode == 200) {
      var shareResponseDecode = jsonDecode(shareResponse.body);
      setState(() {
        if (shareResponseDecode['data']['total'] != null) {
          posts[i]['numberOfReposts'] = shareResponseDecode['data']['total'];
        } else {
          posts[i]['numberOfReposts'] = posts[i]['numberOfReposts'] - 1;
        }
      });
    } else {
      setState(() {
        posts[i]['isReposted'] = !posts[i]['isReposted'];
      });
    }
  }

  void onSubmitSave(
    String postId,
    int i,
    bool isCreate,
  ) async {
    setState(() {
      posts[i]['isSaved'] = !posts[i]['isSaved'];
    });
    var token = await tokenLogic.getToken();

    _postidModel = PostidModel(postId: postId);

    var url = isCreate
        ? Uri.parse(ApiUtils.API_URL + '/Post/Save/Create')
        : Uri.parse(ApiUtils.API_URL + '/Post/Save/Remove');
    var httpClient = http.Client();
    var saveResponse = isCreate
        ? await httpClient.post(
            url,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          )
        : await httpClient.delete(
            url,
            body: jsonEncode(_postidModel.toJson()),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $token'
            },
          );

    if (saveResponse.statusCode == 200) {
    } else {
      setState(() {
        posts[i]['isSaved'] = !posts[i]['isSaved'];
      });
    }
  }
}
