import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

  // TODO: хардкод
  Sign sign = Sign.taurus;
  Talker talker = GetIt.I<Talker>();

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
                      setState(() {
                        waitingResponse = true;
                        status = 'pending';
                        responseText = status == 'good'
                            ? allow
                            : status == 'bad'
                                ? bad
                                : status == 'neutral'
                                    ? doubt
                                    : status == 'pending'
                                        ? loading
                                        : error;
                      });
                      try {
                        Map<String, dynamic> signData =
                            await loadDaySignData(sign);
                        setState(() {
                          status = signData['status'];
                          comment = signData['comment'];
                          html = signData['html'];
                          responseText = status == 'good'
                              ? allow
                              : status == 'bad'
                                  ? bad
                                  : status == 'neutral'
                                      ? doubt
                                      : status == 'pending'
                                          ? loading
                                          : error;
                        });
                      } catch (e, st) {
                        talker.handle(e, st);
                        responseText = error;
                        comment = '(На самом деле что-то сломалось)';
                      }
                    },
                    child: Stack(
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/big_ellipse.png'),
                        Image.asset('assets/images/small_ellipse.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            comment.isEmpty
                ? Padding(
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
                  )
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
                  ),
          ],
        ),
      ),
    );
  }
}
