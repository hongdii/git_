import 'package:flutter/material.dart';
import 'package:donut_1/MoreScreen.dart';
import 'package:donut_1/friends.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:platform/platform.dart';

void main() {
  KakaoContext.clientId = "cfc90a0a9f916d05a0a207404f0915df";
  KakaoContext.javascriptClientId = "ded66fc3f6bb090106a975f15fee7801";

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity:  VisualDensity.adaptivePlatformDensity,
    ),
    home: KakaoLogin(),
  ));
}

class MyApp extends StatefulWidget {
  final String title = 'untitled_app';
  MyAppState createState() => MyAppState();

}

class KakaoLogin extends StatefulWidget {
  @override
  _KakaoLoginState createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    _initKakaoTalkInstalled();
    super.initState();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toString(token);
      print(token);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MoreScreen(),
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var token = await await UserApi.instance.loginWithKakaoAccount();
      print("token : ${token.accessToken}");
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: InkWell(
              onTap: () async {
                if(_isKakaoTalkInstalled) {
                  try {
                    final token = await UserApi.instance.loginWithKakaoTalk(prompts: [Prompt.LOGIN]);
                    print(token.accessToken);
                    User user = await UserApi.instance.me();
                    print(user.kakaoAccount);
                  }catch(e) {
                    print('error : $e');
                  }
                }else {
                  _loginWithKakao();
                }
              },
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble, color: Colors.black54),
                      SizedBox(width: 10,),
                      Text(
                        '??????????????? ?????????',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
              ),
            )
        )
    ),
    );
  }
}

class AccessTokenStore {
  static var instance;
}

class MyAppState extends State<MyApp> {
  List<Todo> todos = [];
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'untitled_app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        accentColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Donut'),
            centerTitle: true,
            elevation:0.0,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
          ),
          drawer: Drawer(
              child:ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                  )
                ],
              )
          ),
          body: TabBarView(
            children: <Widget>[
              MoreScreen(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  SafeArea(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // ?????? ???????????? ????????? ???
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black,
                            ),
                          ),
                          Container(
                            child: Text(DateTime.now().toString().substring(0,10)),
                          ),
                        ]),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Done List',
                    ),
                    controller: myController,
                  ),
                  RaisedButton(
                    child: Text('Add'),
                    onPressed: () {
                      setState((){
                        final todo = new Todo(myController.value.text);
                        todos.add(todo);
                        myController.clear();
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.lightGreen,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            leading: Icon(
                              Icons.check_circle_outline,
                              color: Colors.black,
                            ),
                            trailing: Icon(Icons.search),

                              title: Text(todos[index].toString()),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(todo: todos[index]))
                                );
                              }
                          );
                        }
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State createState() => LoginState();
}

class LoginState extends State<Login> {
  String userName = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          makeRowContainer('?????????', true),
          makeRowContainer('????????????', false),
          Container(
            child: RaisedButton(
              child: Text('?????????', style: TextStyle(fontSize: 21)),
              onPressed: () {
                // ????????? ????????? ??????????????? ???????????????!
                if(userName == 'donut' && password == '1234') {
                  // ????????? ???????????? ?????? ????????? build ?????? ?????? ???????????????
                  // ???????????? ???????????? ?????????????????? ??? ???????????? ???????????????.
                  setState(() {
                    userName = '';
                    password = '';
                  });
                  runApp(MyApp());
                }
                else
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('???????????? ????????????!')));
              }
          ),
            margin: EdgeInsets.only(top: 12),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget makeRowContainer(String title, bool isUserName) {
    return Container(
      child: Row(
        children: <Widget>[
          makeText(title),
          makeTextField(isUserName),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: EdgeInsets.only(left: 60, right: 60, top: 8, bottom: 8),
    );
  }

  // Cascade ?????? ??????. ???????????? ?????? ???????????? ..??? ????????? ??? ??? ????????? ?????? ??????.
  // Cascade ????????? ???????????? ?????? ????????????.
  Widget makeText(String title) {
    // var paint = Paint();
    // paint.color = Colors.green;

    return Text(
      title,
      style: TextStyle(
        fontSize: 21,
        //background: Paint()..color = Colors.green,
        // background: paint,
      ),
    );
  }

  Widget makeTextField(bool isUserName) {
    // TextField ????????? ????????? ???????????? padding??? ????????? Container ?????? ??????.
    // TextField ?????????????????? ??? ??? ??????.
    return Container(
      child: TextField(
        // TextField ???????????? ?????? ????????? ?????? ?????? ??????, TextEditingController ???????????? ??????.
        // ?????? ????????? ????????? ?????? controller.text?????? ?????? ??????.
        // ???????????? ???????????? ???????????? ??? ???????????? ?????? ???????????? ????????????. ???????????? ???????????? ??? ?????? ??????.
        // controller: TextEditingController()..text = '?????????',
        controller: TextEditingController(),
        style: TextStyle(fontSize: 21, color: Colors.black),
        textAlign: TextAlign.center,
        // ????????? ??????. enabledBorder ????????? ???????????? ????????? ?????? ??????.
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blue,
                width: 2.0
            ),
          ),
          contentPadding: EdgeInsets.all(12),
        ),
        onChanged: (String str) {
          // ????????? ????????? ????????? ????????? ???????????? ?????? ????????? ?????? ?????? ??????
          // ???????????? ???????????? ????????? ????????? ????????????.
          if(isUserName)
            userName = str;
          else
            password = str;
        },
      ),
      // TextField ????????? ????????? ??????????????? Container ????????? ????????? ????????? ??????.
      // ??????????????? ????????? ?????????????????? ????????? ??????.
      width: 200,
      padding: EdgeInsets.only(left: 16),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Todo todo;

  // ???????????? ???????????? ???????????? ????????? ??????
  const DetailScreen({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todo.task)), // ???????????? title??? title ??????
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(todo.task), // ???????????? ???????????? body ??????
      ),
    );
  }
}

class Todo{
  final String task;

  Todo(this.task);
}
