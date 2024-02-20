import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:office/bloc/project_bloc.dart';
import 'package:office/data/repository/project_repo.dart';
import 'package:office/ui/project/project_details.dart';
import 'package:office/ui/widget/app_bar.dart';
import 'package:office/ui/widget/stack_user_list.dart';
import 'package:office/utils/constants.dart';
import 'package:provider/provider.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late ProjectBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = ProjectBloc(context.read<ProjectRepository>());
    bloc.fetchProjects("doing");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 100,
            width: 1.sw,
            decoration: const BoxDecoration(
                color: Color(0xFF009FE3),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 56,),
                Text(
                  "Projects",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 56,
            left: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 15,
                child: Icon(Icons.arrow_back, size: 18,),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButtonFormField(
                  value: "doing",
                  items: [
                    DropdownMenuItem(child: Text("Doing"),value: "doing",),
                    DropdownMenuItem(child: Text("Total"),value: "total",),
                    DropdownMenuItem(child: Text("Incomplete"),value: "incomplete",),
                    DropdownMenuItem(child: Text("Complete"),value: "complete",)
                  ],
                  onChanged: (value) {
                    bloc.allProjects.value = null;
                    bloc.selectedProjects.value = value.toString();
                    bloc.fetchProjects(value.toString());
                  }
                ),
              ),
              ValueListenableBuilder(
                valueListenable: bloc.allProjects,
                builder: (context, projectData, child) {
                  if(projectData ==null){
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if(projectData.isEmpty){
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(child: Text("No data available")));
                  }
                return Expanded(
                  child: ListView.builder(
                    itemCount: projectData.length,
                    itemBuilder: (context, index) {
                      var data = projectData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  ProjectDetails(data: data,)));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    color: Colors.black.withOpacity(0.1))
                              ]),
                          // ignore: prefer_const_constructors
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(projectData[index]["name"] ?? "",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      // SizedBox(height: 5,),
                                      // Row(
                                      //   children: [
                                      //     Icon(PhosphorIcons.user,size: 18,),
                                      //     SizedBox(
                                      //       width: 10,
                                      //     ),
                                      //     Text('Client Name',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)
                                      //   ],
                                      // ),
                                      //  SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          const Icon(PhosphorIcons.trend_up,size: 16,),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            bloc.selectedProjects.value == "todo"?
                                            'In Process':
                                            bloc.selectedProjects.value == "incomplete"?
                                                "Not Completed":
                                                bloc.selectedProjects.value == "complete"?
                                                    "Completed": projectData[index]["status"],
                                            style: TextStyle(fontSize: 11,color: Colors.green.shade400),)
                                        ],
                                      ),
                                      const SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          const Icon(PhosphorIcons.timer,size: 16,),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(projectData[index]["created_date"].toString().splitBefore(" "),style: TextStyle(fontSize: 11,color: Colors.redAccent.withOpacity(0.9)),)
                                        ],
                                      ),
                                      const SizedBox(height: 8,),
                                      const StackedUserList(totalUser: 5,
                                        users: [
                                          'https://www.google.co.in/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fimage&psig=AOvVaw2FDh29Vf0nsix3FPxuuJ_Z&ust=1685794097080000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCOjW58TGpP8CFQAAAAAdAAAAABAE',
                                          'https://www.google.co.in/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImage&psig=AOvVaw2FDh29Vf0nsix3FPxuuJ_Z&ust=1685794097080000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCOjW58TGpP8CFQAAAAAdAAAAABAI'
                                              '','',''],
                                        numberOfUsersToShow: 5,
                                        avatarSize: 18,
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  DashedCircularProgressBar.square(
                                    dimensions: 80,
                                    progress: double.parse(projectData[index]["progress"]),
                                    startAngle: 225,
                                    sweepAngle: 270,
                                    foregroundColor: Colors.blue,
                                    backgroundColor: Color(0xffeeeeee),
                                    foregroundStrokeWidth: 10,
                                    backgroundStrokeWidth: 10,
                                    animation: true,
                                    seekSize: 8,
                                    seekColor: Colors.white,
                                    child: Center(child: Text("${projectData[index]['progress']}%",
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
                                  ),
                                ],
                              ),
                              const Divider(),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TaskContent(tittle: '15', icon: Icons.offline_bolt_outlined,),
                                  TaskContent(tittle: '5', icon: Icons.error_outline,color: Colors.blue,),
                                  TaskContent(tittle: '5', icon: Icons.check_circle_outline,color: Colors.green,),
                                  TaskContent(tittle: '5', icon: Icons.cancel_outlined,color: Colors.red,),

                                ],
                              ),
                              const SizedBox(height: 10,)
                            ],
                          ),
                        ),
                        /*Container(
                        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25,),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.1))
                            ]),
                        // ignore: prefer_const_constructors
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Aarvy Office',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    // SizedBox(height: 5,),
                                    // Row(
                                    //   children: [
                                    //     Icon(PhosphorIcons.user,size: 18,),
                                    //     SizedBox(
                                    //       width: 10,
                                    //     ),
                                    //     Text('Client Name',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),)
                                    //   ],
                                    // ),
                                    //  SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        const Icon(PhosphorIcons.trend_up,size: 18,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('In Process',style: TextStyle(fontSize: 12,color: Colors.green.shade400),)
                                      ],
                                    ),
                                     const SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        const Icon(PhosphorIcons.timer,size: 18,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('April 25, 2024',style: TextStyle(fontSize: 12,color: Colors.redAccent.withOpacity(0.9)),)
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    const StackedUserList(totalUser: 5,
                                     users: [
                                      'https://www.google.co.in/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fimage&psig=AOvVaw2FDh29Vf0nsix3FPxuuJ_Z&ust=1685794097080000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCOjW58TGpP8CFQAAAAAdAAAAABAE',
                                      'https://www.google.co.in/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImage&psig=AOvVaw2FDh29Vf0nsix3FPxuuJ_Z&ust=1685794097080000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCOjW58TGpP8CFQAAAAAdAAAAABAI'
                                      '','',''],
                                      numberOfUsersToShow: 5,
                                      avatarSize: 20,
                                     )
                                  ],
                                ),
                                const Spacer(),
                                const DashedCircularProgressBar.square(
                                  dimensions: 100,
                                  progress: 60,
                                  startAngle: 225,
                                  sweepAngle: 270,
                                  foregroundColor: Colors.blue,
                                  backgroundColor: Color(0xffeeeeee),
                                  foregroundStrokeWidth: 10,
                                  backgroundStrokeWidth: 10,
                                  animation: true,
                                  seekSize: 8,
                                  seekColor: Colors.white,
                                  child: Center(child: Text('60%',
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)),
                                ),
                              ],
                            ),
                            //  SizedBox(height: 5,),
                            // Text("Description:",style: TextStyle(fontWeight: FontWeight.w500),),
                            // Text("A project consists of a concrete and organized effort motivated by a perceived opportunity when facing a problem, a need, a desire or a source of discomfort (e.g., lack of proper ventilation in a building)."
                            // ,style: TextStyle(fontSize: 12,color: K.textGrey),)
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TaskContent(tittle: '15', icon: Icons.offline_bolt_outlined),
                                TaskContent(tittle: '5', icon: Icons.error_outline,color: Colors.blue,),
                                TaskContent(tittle: '5', icon: Icons.check_circle_outline,color: Colors.green,),
                                TaskContent(tittle: '5', icon: Icons.cancel_outlined,color: Colors.red,),
                            //     Column(
                            //       children: [
                            //         Icon(Icons.task_outlined),
                            //         SizedBox(height: 5,),
                            //         Text("15",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.blue.shade600),),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //        Icon(Icons.change_circle_outlined),
                            //         SizedBox(height: 5,),
                            //         Text("10",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.blue.shade600),),
                            //       ],
                            //     ),
                            //     Column(
                            //       children: [
                            //         Icon(Icons.check_circle_outline),
                            //         Icon(Icons.cancel_outlined),
                            //         SizedBox(height: 5,),
                            //         Text("5",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.blue.shade600),),
                            //       ],
                            //     ),
                              ],
                            ),
                          ],
                        ),
                      ),*/
                      );
                    },
                  ),
                );
              },),
            ],
          ),
        ],
      ),
    );
  }
}

class TaskContent extends StatelessWidget {
  const TaskContent({super.key, required this.tittle, required this.icon,this.color = Colors.black});
  final String tittle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon,color: color,size: 16,),
      const SizedBox(width: 5,),
      Text(tittle,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.grey),),
    ],);
  }
}