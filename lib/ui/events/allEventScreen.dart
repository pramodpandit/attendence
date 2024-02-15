// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:office/ui/events/eventsScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../bloc/holiday_bloc.dart';
// import '../../data/repository/holiday_repo.dart';
//
// class AllEventScreen extends StatefulWidget {
//   const AllEventScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AllEventScreen> createState() => _AllEventScreenState();
// }
//
// class _AllEventScreenState extends State<AllEventScreen> {
//   late HolidayEventBloc holidayBloc;
//   @override
//   void initState() {
//     holidayBloc = HolidayEventBloc(context.read<HolidayEventRepository>());
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: 100,
//             width: 1.sw,
//             decoration: const BoxDecoration(
//                 color: Color(0xFF009FE3),
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20),
//                     bottomRight: Radius.circular(20))
//             ),
//             child: const Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 56,),
//                 Text(
//                   "All Events",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 56,
//             left: 10,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: const CircleAvatar(
//                 backgroundColor: Colors.white,
//                 radius: 15,
//                 child: Icon(Icons.arrow_back, size: 18,),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: Column(
//               children: [
//                 const SizedBox(height: 110,),
//                 ValueListenableBuilder(
//                     valueListenable: holidayBloc.startEventYear,
//                     builder: (context, DateTime? date, _) {
//                       return InkWell(
//
//                         onTap: () async {
//                           int? selectedYear = await showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text("Select Year"),
//                                 content: DropdownButton<int>(
//                                   value: date?.year ?? DateTime.now().year,
//                                   items: List.generate(30, (index) {
//                                     return DropdownMenuItem<int>(
//                                       value: DateTime.now().year - 15 + index,
//                                       child: Text((DateTime.now().year - 15 + index).toString()),
//                                     );
//                                   }),
//                                   onChanged: (int? value) {
//                                     Navigator.pop(context, value);
//                                   },
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context, date?.year ?? DateTime.now().year);
//                                     },
//                                     child: Text('Select'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//
//                           if (selectedYear != null) {
//                             DateTime selectedDate = DateTime(selectedYear);
//                             await holidayBloc.updateStartEventYear(selectedDate);
//                             print("$selectedDate");
//                           }
//                         },
//
//                         child: Container(
//                           height: 50,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[100],
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(PhosphorIcons.clock),
//                               const SizedBox(width: 15),
//                               Text(date==null ?  DateFormat('yyyy').format(DateTime.now()) : DateFormat('yyyy').format(date), style: const TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),),
//                             ],
//                           ),
//                         ),
//                       );
//                     }
//                 ),
//                 Expanded(
//                     child: ListView.builder(
//                       itemCount: 10,
//                         padding: const EdgeInsets.only(top: 10,bottom: 10),
//                         shrinkWrap: true,
//                         itemBuilder: (context,index){
//                           return Column(
//                             children: [
//                               Container(
//                                 margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         spreadRadius: 0,
//                                         blurRadius: 3,
//                                         color: Colors.black.withOpacity(0.1))
//                                   ],
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: const BorderRadius.only(
//                                         topRight: Radius.circular(10),
//                                         topLeft: Radius.circular(10),
//                                       ),
//                                       child: Image.network(
//                                         "https://images.wallpaperscraft.com/image/single/laptop_keys_gradient_167934_1920x1080.jpg",
//                                         fit: BoxFit.fill,
//                                         width: double.infinity,
//                                         height: 150,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Text(
//                                         "Lorem ipsum",
//                                         style: const TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                                       child: Html(
//                                         data: 'ipsum dolore amit languafe huhfe uyfb yfgyfr vcgye vyugb vyrgfb ',
//                                         style: {
//                                           "body": Style(
//                                             color: Colors.black87,
//                                             // fontWeight: FontWeight.w500,
//                                             fontFamily: "Poppins",
//                                             display: Display.inline,
//                                             // fontSize: FontSize(13),
//                                           ),
//                                           "p": Style(
//                                             color: Colors.black87,
//                                             padding: HtmlPaddings.zero,
//                                             margin: Margins.zero,
//                                             // fontWeight: FontWeight.w500,
//                                             fontFamily: "Poppins",
//                                             display: Display.inline,
//                                             // fontSize: FontSize(13),
//                                           ),
//                                         },
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     EventContent(
//                                       icon: PhosphorIcons.link,
//                                       tittle: "www.google.com",
//                                       color: Colors.blue,
//                                       isHtml: false,
//                                       onTap: () async {
//                                         final Uri url = Uri.parse(
//                                             'www.google.com');
//                                         try {
//                                           await launchUrl(url);
//                                         } catch (e) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                               content: Text(
//                                                   'www.google.com does not exist')));
//                                         }
//                                       },
//                                     ),
//                                     EventContent(
//                                       icon: PhosphorIcons.link,
//                                       tittle: "www.google.com",
//                                       color: Colors.blue,
//                                       isHtml: false,
//                                       onTap: () async {
//                                         final Uri url = Uri.parse(
//                                             'www.google.com');
//                                         try {
//                                           await launchUrl(url);
//                                         } catch (e) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                               content: Text(
//                                                   'www.google.com does not exist')));
//                                         }
//                                       },
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                                       child: Row(
//                                         children: [
//                                           const Icon(
//                                             PhosphorIcons.calendar,
//                                             size: 22,
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                             "22 Nov, 6:15 PM",
//                                             style: const TextStyle(
//                                               color: Colors.green,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           const Spacer(),
//                                           // if (isEqual != true)
//                                             const Icon(
//                                               PhosphorIcons.calendar,
//                                               size: 22,
//                                             ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           // if (isEqual != true)
//                                             Text(
//                                               "13 Dec 2023",
//                                               style: const TextStyle(
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 10,
//                               ),
//                             ],
//                           );
//                         }
//                     )
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
