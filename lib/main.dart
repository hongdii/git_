import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donut_1/MoreScreen.dart';
import 'package:donut_1/friends.dart';
import 'package:kakao_flutter_sdk/all.dart';

void main() {
  KakaoContext.clientId = "cfc90a0a9f916d05a0a207404f0915df";
  KakaoContext.javascriptClientId = "ded66fc3f6bb090106a975f15fee7801";

  runApp(MaterialApp(
    title: '로그인',
    home: Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Login(),

    ),
  ));
}

class MyApp extends StatefulWidget {
  final String title = 'untitled_app';
  MyAppState createState() => MyAppState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity:  VisualDensity.adaptivePlatformDensity,
      ),
      home: KakaoLogin(),
    );
  }
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
        builder: (context) => friends(),
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    try{
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('kakao login test'),
        ),
        body: Center(
            child: InkWell(
              onTap: () => _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao,
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
                        '카카오계정 로그인',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                            fontSize: 20
                        ),
                      ),
                    ],
                  )
              ),
            )
        )
    );
  }
}

class AccessTokenStore {
  static var instance;
}

class MyAppState extends State<MyApp> {
  List<String> items = [];
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 같은 간격만큼 공간을 둠
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
                      items.add(myController.text);
                      setState((){});
                    },
                    textColor: Colors.white,
                    color: Colors.lightGreen,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            leading: Icon(
                              Icons.check_circle_outline,
                              color: Colors.black,
                            ),
                            trailing: Icon(Icons.search),
                            title: Text(items[index]),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => friends())
                              );
                            },
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
          makeRowContainer('아이디', true),
          makeRowContainer('비밀번호', false),
          Container(child: RaisedButton(
              child: Text('로그인', style: TextStyle(fontSize: 21)),
              onPressed: () {
                // 사용자 이름과 비밀번호가 일치한다면!
                if(userName == 'donut' && password == '1234') {
                  // 세터로 초기화를 했기 때문에 build 함수 자동 호출하면서
                  // 아이디와 비밀번호 텍스트필드가 빈 문자열로 초기화된다.
                  setState(() {
                    userName = '';
                    password = '';
                  });
                  runApp(MyApp());
                }
                else
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text('일치하지 않습니다!')));
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

  // Cascade 문법 사용. 주석으로 막은 코드보다 ..을 사용한 한 줄 코드가 훨씬 낫다.
  // Cascade 문법은 아래에서 따로 설명한다.
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
    // TextField 위젯의 크기를 변경하고 padding을 주려면 Container 위젯 필요.
    // TextField 독자적으로는 할 수 없음.
    return Container(
      child: TextField(
        // TextField 클래스는 입력 내용을 갖고 있지 않고, TextEditingController 클래스에 위임.
        // 입력 내용에 접근할 때는 controller.text라고 쓰면 된다.
        // 여기서는 로그인에 성공했을 때 초기화를 위한 용도로만 사용한다. 아래처럼 초기값을 줄 수도 있다.
        // controller: TextEditingController()..text = '플러터',
        controller: TextEditingController(),
        style: TextStyle(fontSize: 21, color: Colors.black),
        textAlign: TextAlign.center,
        // 테두리 출력. enabledBorder 옵션을 사용하지 않으면 변경 불가.
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
          // 입력이 변경될 때마다 갱신이 필요하지 않기 때문에 세터 사용 안함
          // 아이디와 비밀번호 중에서 하나를 갱신한다.
          if(isUserName)
            userName = str;
          else
            password = str;
        },
      ),
      // TextField 위젯의 크기를 설정하려면 Container 위젯을 부모로 가져야 한다.
      // 컨테이너의 크기가 텍스트필드의 크기가 된다.
      width: 200,
      padding: EdgeInsets.only(left: 16),
    );
  }
}