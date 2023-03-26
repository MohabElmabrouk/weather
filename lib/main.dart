import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/auth/secrets.dart';
import 'model/weather_Response.dart';

void main() {
  runApp(const MaterialApp(
    home: Seplashscreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class Weatherscreen extends StatefulWidget {
  const Weatherscreen({Key? key}) : super(key: key);

  @override
  State<Weatherscreen> createState() => _WeatherscreenState();
}

class _WeatherscreenState extends State<Weatherscreen> {
  Dio? dio;
  SharedPreferences? pref;
  WeatherResponse? response;
  static const CITY = "city";
  var searchcontroller = TextEditingController();

  Map<String?, Image> weatherImge = {
    "غيوم متناثرة": Image.network(
      "https://media.istockphoto.com/id/1028827352/photo/sky.jpg?b=1&s=612x612&w=0&k=20&c=ELMxphq89_GyKemlVmY-bue8FlKh7uAcSe0dltUTH1k=",
      fit: BoxFit.fill,
    ),"غائم جزئي": Image.network(
      "https://media.istockphoto.com/id/1028827352/photo/sky.jpg?b=1&s=612x612&w=0&k=20&c=ELMxphq89_GyKemlVmY-bue8FlKh7uAcSe0dltUTH1k=",
      fit: BoxFit.fill,
    ),"غيوم متفرقة": Image.network(
      "https://media.istockphoto.com/id/893092946/photo/clouds-in-the-sky.jpg?b=1&s=612x612&w=0&k=20&c=rKuVM7zErXbNcy7KzXmksLxyvDpucbEP99_RevemERI=",
      fit: BoxFit.fill,
    ),
    "سماء صافية": Image.network(
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZDZGvlXrmfzFC3IwdJ-zaeqycrG5N7K9wwQ&usqp=CAU",
      fit: BoxFit.fill,
    ),
    "ثلوج خفيفة": Image.network(
      "https://images.unsplash.com/photo-1599152543522-0ba2d0bd43cc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjU1fHxzbm93JTIwd2VhdGhlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=400&q=60",
      fit: BoxFit.fill,
    ),
    "مطر": Image.network(
      "https://images.unsplash.com/uploads/14116603688211a68546c/30f8f30b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fHJhaW4lMjB3ZWF0aGVyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=400&q=60",
      fit: BoxFit.fill,
    ),
    "مطر خفيف": Image.network(
      "https://images.unsplash.com/uploads/14116603688211a68546c/30f8f30b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NTh8fHJhaW4lMjB3ZWF0aGVyfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=400&q=60",
      fit: BoxFit.fill,
    ),"عاصفة رعدية": Image.network(
      "https://images.pexels.com/photos/2418664/pexels-photo-2418664.jpeg?auto=compress&cs=tinysrgb&w=1600",
      fit: BoxFit.fill,
    ),
  };

  @override
  void initState() {

    super.initState();
    print("initState");
    dio = Dio(BaseOptions(contentType: "Application/json"));
    getsharepref().then((value) {
      getweather(pref?.getString(CITY) ?? "طرابلس");
    });
  }

  Future<void> getsharepref() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> setsharepref(String KEY, String city) async {
    try {
      await pref?.setString(KEY, city);
      print("seccessfule");
      print(pref?.getString(CITY));
    } catch (error) {
      print("error ");
    }
  }

  Future<void> getweather(String q) async {
    print("get weather called");
    var res = await dio?.get(
        "https://api.openweathermap.org/data/2.5/weather?q=$q&lang=ar&appid=$mySecretKey",
        queryParameters: {"units": "metric"});

    response = WeatherResponse.fromJson(res?.data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var disc = response?.weather?[0].description;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text("الطقس"),
            ),
            body: disc == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(clipBehavior: Clip.none, children: [
                          Container(
                              width: double.infinity,
                              height: 240,
                              child: weatherImge[disc]),
                          Positioned(top: 12,right: 14,left: 14,
                            child: SizedBox(
                              height: 40,

                              child: TextFormField(
                                onFieldSubmitted: (value) {
                                  setsharepref(CITY, value);
                                },
                                controller: searchcontroller,
                                decoration: InputDecoration(
                                    fillColor: Colors.black,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    prefixIcon: IconButton(
                                        onPressed: () {
                                          getweather(searchcontroller.text);
                                        },
                                        icon: const Icon(
                                          Icons.search_rounded,
                                          color: Colors.black,
                                        )),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          searchcontroller.text = "";
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.black)),
                                   hintText: "بحث",hintStyle: TextStyle(height: 3)),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                onEditingComplete: () {
                                  getweather(searchcontroller.text);
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 210,
                            left: 10,
                            right: 10,
                            child: SizedBox(
                              height: 200,
                              width: 400,
                              child: Card(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 14),
                                            child: Icon(Icons.room),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Text(
                                              "${response?.name.toString()} - ${response?.sys?.country.toString()}",
                                              style: const TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 1,thickness: 1,),
                                      const SizedBox(height: 24,),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child: Image.network(
                                                  "https://openweathermap.org/img/wn/${response?.weather?[0].icon}@2x.png"),
                                            ),
                                          ),
                                          Text(
                                            "${response?.main?.temp?.toInt().toString()}°",
                                            style:
                                                const TextStyle(fontSize: 40),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      disc.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        const Icon(
                                                          Icons.wind_power,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          "${response?.wind?.speed}m/s الرياح ",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      "${response?.main?.tempMin?.toInt()}°الصغرى / ${response?.main?.tempMax?.toInt()}° العظمى",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          )
                        ]),
                      ],
                    ),
                  )));
  }
}

class Seplashscreen extends StatefulWidget {
  const Seplashscreen({Key? key}) : super(key: key);

  @override
  State<Seplashscreen> createState() => _SeplashscreenState();
}

class _SeplashscreenState extends State<Seplashscreen> {
  
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () =>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Weatherscreen() )));

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [SizedBox(height: 250,),
            SizedBox(width:120,height:120,child: Image.asset("assets/images/hail.png")),
             SizedBox(height: 220,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
    
  }
}
