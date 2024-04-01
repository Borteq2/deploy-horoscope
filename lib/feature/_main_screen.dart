import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum Sign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

const allow = 'Полный вперёд!';
const doubt = 'Сомнительно, но окэй';
const bad = 'Ни в коем случае';
const loading = 'Звёзды говорят...';
const error = 'Даже звёзды в замешательстве';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool waitingResponse = false;
  Map<String, dynamic> response = {'': ''};
  String responseText = '';
  String status = '';
  String comment = '';
  String html = '';

  bool isFullyLoaded = false;

  Sign? sign;
  Talker talker = GetIt.I<Talker>();

  List<Widget> signs = [
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♈', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Овен', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♉', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Телец', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♊', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Близнецы', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♋', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Рак', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♌', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Лев', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♍', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Дева', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♎', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Весы', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♏', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Скорпион', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♐', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Стрелец', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♑', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Козерог', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♒', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Водолей', style: TextStyle(fontSize: 20))),
          ],
        )),
    Card(
        color: const Color(0xFF100C2C).withOpacity(0.7),
        child: const Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('♓', style: TextStyle(fontSize: 64)),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Text('Рыбы', style: TextStyle(fontSize: 20))),
          ],
        )),
  ];

  String mapSighToSignName(Sign sign) {
    switch (sign) {
      case Sign.aries:
        return 'aries';
      case Sign.taurus:
        return 'taurus';
      case Sign.gemini:
        return 'gemini';
      case Sign.cancer:
        return 'cancer';
      case Sign.leo:
        return 'leo';
      case Sign.virgo:
        return 'virgo';
      case Sign.libra:
        return 'libra';
      case Sign.scorpio:
        return 'scorpio';
      case Sign.sagittarius:
        return 'sagittarius';
      case Sign.capricorn:
        return 'capricorn';
      case Sign.aquarius:
        return 'aquarius';
      case Sign.pisces:
        return 'pisces';
    }
  }

  Future<Map<String, dynamic>> loadDaySignData(Sign sign) async {
    String mySign = mapSighToSignName(sign);
    final response =
        await GetIt.I<Dio>().get('https://deployhoroscope.ru/api/v1/day');
    await Future.delayed(const Duration(seconds: 1));
    return response.data['result']['signs']
        .firstWhere((e) => e['id'] == mySign);
  }

  Future<void> saveSignIndexToSP(Sign sign) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sign', Sign.values.indexOf(sign));
  }

  Future<void> getSignFromSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedIndex = prefs.getInt('sign');
    if (savedIndex != null) {
      sign = Sign.values[savedIndex];
      talker.info(sign);
    } else {
      talker.warning('SP не отдал данных');
    }
    setState(() {
      isFullyLoaded = true;
    });
  }

  String getStatusFromData(Map<String, dynamic> data) {
    return data['status'];
  }

  String getCommentFromData(Map<String, dynamic> data) {
    return data['comment'];
  }

  String getHtmlFromData(Map<String, dynamic> data) {
    return data['html'];
  }

  @override
  void initState() {
    getSignFromSP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF100C2C),
              Color(0xFF000002),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (sign != null) {
                        setState(() {
                          waitingResponse = true;
                          status = 'pending';
                          setTextByStatus();
                        });
                        try {
                          Map<String, dynamic> signData =
                              await loadDaySignData(sign!);
                          setState(() {
                            status = signData['status'];
                            comment = signData['comment'];
                            html = signData['html'];
                            setTextByStatus();
                          });
                        } catch (e, st) {
                          talker.handle(e, st);
                          responseText = error;
                          comment = '(На самом деле что-то сломалось)';
                        }
                      } else {}
                    },
                    child: BallWidget(
                        waitingResponse: waitingResponse,
                        responseText: responseText),
                  ),
                  const EllipsisesWidget(),
                ],
              ),
            ),
            isFullyLoaded
                ? sign != null
                    ? comment.isEmpty
                        ? const PredictHintWidget()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Column(
                              children: [
                                IconButton(
                                    onPressed: () => setState(() {
                                          waitingResponse = false;
                                          status = '';
                                          comment = '';
                                          responseText = '';
                                        }),
                                    icon: const Icon(Icons.refresh)),
                                Text(
                                  comment,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    fontFamily: 'Gill_Sans',
                                    color: Color(0xFF727272),
                                  ),
                                ),
                              ],
                            ),
                          )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          shrinkWrap: true,
                                          itemCount: signs.length,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () => setState(() {
                                              sign = Sign.values[index];
                                              saveSignIndexToSP(
                                                  Sign.values[index]);
                                              Navigator.of(context).pop();
                                            }),
                                            child: signs[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.blur_circular),
                            ),
                            const Text(
                              'Выберите свой\nзнак зодиака',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: 'Gill_Sans',
                                color: Color(0xFF727272),
                              ),
                            ),
                          ],
                        ),
                      )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            color: Colors.transparent,
                            icon: const Icon(Icons.anchor)),
                        const Text(
                          '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: 'Gill_Sans',
                            color: Color(0xFF727272),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void setTextByStatus() {
    responseText = status == 'good'
        ? allow
        : status == 'bad'
            ? bad
            : status == 'neutral'
                ? doubt
                : status == 'pending'
                    ? loading
                    : error;
  }
}

class PredictHintWidget extends StatelessWidget {
  const PredictHintWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          IconButton(
              onPressed: () {},
              color: Colors.transparent,
              icon: const Icon(Icons.refresh)),
          const Text(
            'Нажмите на шар,\nчтобы узнать судьбу своего деплоя',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: 'Gill_Sans',
              color: Color(0xFF727272),
            ),
          ),
        ],
      ),
    );
  }
}

class EllipsisesWidget extends StatelessWidget {
  const EllipsisesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/big_ellipse.png'),
          Image.asset('assets/images/small_ellipse.png'),
        ],
      ),
    );
  }
}

class BallWidget extends StatelessWidget {
  const BallWidget({
    super.key,
    required this.waitingResponse,
    required this.responseText,
  });

  final bool waitingResponse;
  final String responseText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ball.png'),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: waitingResponse ? 0.0 : 1.0,
          child: Image.asset('assets/images/small_star.png'),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: waitingResponse ? 0.0 : 1.0,
          child: Image.asset('assets/images/star.png'),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: waitingResponse ? 1.0 : 0.0,
          child: Image.asset('assets/images/black_ball.png'),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: responseText.isNotEmpty ? 1.0 : 0.0,
          child: SizedBox(
            width: 300,
            child: Text(
              responseText,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 32,
                fontFamily: 'SaarFont',
                color: responseText == allow
                    ? Colors.green
                    : responseText == bad
                        ? Colors.red
                        : responseText == doubt
                            ? Colors.yellow
                            : responseText == error
                                ? Colors.grey
                                : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
