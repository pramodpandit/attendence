import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/ui/auth/LoginScreen.dart';

class IntroductionPage extends StatefulWidget {
  static const route = "/IntroductionPage";
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int delta) {
    _pageController.animateToPage(
        _currentIndex + delta,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 1.sh,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _handlePageChanged,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100,right: 20,left: 20,bottom: 10),
                      child: Column(
                        children: [
                          if(index==0)Image.asset("images/intro1.png"),
                          if(index==1)Image.asset("images/into2.png"),
                          if(index==2)Image.asset("images/intro3.png"),
                          if(index==0)const Text(
                            "Smart and Fast",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),),
                          if(index==1)const Text(
                            "Approve or Reject Request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),),
                          if(index==2)const Text(
                            "Track Attendance and Manage Shift",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),),
                          const SizedBox(height: 5,),
                          if(index==0)Text(
                            "Instantly Check in-check out with easy\none step",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          if(index==1)Text(
                            "All it takes is a single tap for employee to submit leaves request and manager to approves them",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          if(index==2) Text(
                            "Manage and Track your employee shift and access their weekly/monthly attendance report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          const SizedBox(height: 50,),
                          if(index==0)Row(
                            children: [
                              const Spacer(),
                              Container(
                                height: 5,
                                width: 30,
                                decoration: const BoxDecoration(
                                    color: Color(0xff00A0E6),
                                  borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          if(index==1)Row(
                            children: [
                              const Spacer(),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 30,
                                decoration: const BoxDecoration(
                                    color: Color(0xff00A0E6),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          if(index==2)Row(
                            children: [
                              const Spacer(),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 15,
                                decoration: const BoxDecoration(
                                    color: Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 5,
                                width: 30,
                                decoration: const BoxDecoration(
                                    color: Color(0xff00A0E6),
                                    borderRadius: BorderRadius.all(Radius.circular(100))
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 50,),
                          Column(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Color(0xff00A0E6),
                                        Color(0xff127FAE),
                                      ]),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ElevatedButton(
                                  onPressed:(){
                                    if(index==0){
                                      _nextPage(1);
                                    }
                                    else if(index==1){
                                      _nextPage(1);
                                    }
                                    else{
                                      Navigator.pushReplacement(context,
                                          PageRouteBuilder(pageBuilder: (context, animation1, animation2) => const LoginScreen()));
                                    }
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) =>LoginOTP()),
                                    //MaterialPageRoute(builder: (context) =>HomeSecond()),
                                    // );
                                    // login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(), backgroundColor: Colors.transparent,
                                    elevation: 3,
                                    disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                                    disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                                    shadowColor: Colors.transparent,
                                    fixedSize: const Size(280,50),
                                  ),
                                  child: Text(
                                    index==2?"Login":"Next",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "outfit2",
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(index==0||index==1)const SizedBox(height: 30,),
                          if(index==0||index==1)GestureDetector(
                            onTap: () {
                              _nextPage(2);
                              // _currentIndex=2;
                              // _nextPage(_currentIndex);
                            },
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.7,
                                  color: Color(0xff009FE3),
                                  fontSize: 13
                              ),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
               /* physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100,right: 20,left: 20,bottom: 10),
                      child: Column(
                        children: [
                          Image.asset("images/intro1.png"),
                          Text("Smart and Fast",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                          ),),
                          const SizedBox(height: 5,),
                          Text(
                            "Instantly Check in-check out with easy\none step",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          SizedBox(height: 100,),
                          Container(
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Color(0xff00A0E6),
                                          Color(0xff127FAE),
                                        ]),
                                    borderRadius: BorderRadius.circular(30),

                                  ),
                                  child: ElevatedButton(
                                    onPressed:(){
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) =>LoginOTP()),
                                        //MaterialPageRoute(builder: (context) =>HomeSecond()),
                                      // );
                                      // login();
                                    },
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "outfit2",
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), backgroundColor: Colors.transparent,
                                      elevation: 3,
                                      disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                                      disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                                      shadowColor: Colors.transparent,
                                      fixedSize: Size(280,50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Text(
                            "Skip",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                                color: Color(0xff009FE3),
                                fontSize: 13
                            ),),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100,right: 20,left: 20,bottom: 10),
                      child: Column(
                        children: [
                          Image.asset("images/into2.png"),
                          Text(
                            "Approve or Reject Request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),),
                          const SizedBox(height: 5,),
                          Text(
                            "All it takes is a single tap for employee to submit leaves request and manager to approves them",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          SizedBox(height: 100,),
                          Container(
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Color(0xff00A0E6),
                                          Color(0xff127FAE),
                                        ]),
                                    borderRadius: BorderRadius.circular(30),

                                  ),
                                  child: ElevatedButton(
                                    onPressed:(){
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) =>LoginOTP()),
                                      //MaterialPageRoute(builder: (context) =>HomeSecond()),
                                      // );
                                      // login();
                                    },
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "outfit2",
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), backgroundColor: Colors.transparent,
                                      elevation: 3,
                                      disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                                      disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                                      shadowColor: Colors.transparent,
                                      fixedSize: Size(280,50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30,),
                          Text(
                            "Skip",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                                color: Color(0xff009FE3),
                                fontSize: 13
                            ),),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100,right: 20,left: 20,bottom: 10),
                      child: Column(
                        children: [
                          Image.asset("images/intro3.png"),
                          Text(
                            "Track Attendance and Manage Shift",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),),
                          const SizedBox(height: 5,),
                          Text(
                            "Manage and Track your employee shift and access their weekly/monthly attendance report",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 13
                            ),),
                          SizedBox(height: 100,),
                          Container(
                            child: Column(
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter,
                                        colors: [
                                          Color(0xff00A0E6),
                                          Color(0xff127FAE),
                                        ]),
                                    borderRadius: BorderRadius.circular(30),

                                  ),
                                  child: ElevatedButton(
                                    onPressed:(){
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) =>LoginOTP()),
                                      //MaterialPageRoute(builder: (context) =>HomeSecond()),
                                      // );
                                      // login();
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "outfit2",
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: StadiumBorder(), backgroundColor: Colors.transparent,
                                      elevation: 3,
                                      disabledForegroundColor: Colors.transparent.withOpacity(0.38),
                                      disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                                      shadowColor: Colors.transparent,
                                      fixedSize: Size(280,50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],*/
              ),
            )
          ],
        ),
      ),
    );
  }
}
