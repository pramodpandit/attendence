import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:office/utils/constants.dart';

class StackedUserList extends StatelessWidget {
  final List users;
  final double avatarSize, avatarDiff;
  final int numberOfUsersToShow, totalUser;
  const StackedUserList({Key? key, required this.users, this.avatarSize = 28, this.avatarDiff = 8, this.numberOfUsersToShow = 4, required this.totalUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double containerWidth =
        ((avatarSize - avatarDiff) * numberOfUsersToShow) + avatarDiff;
    return SizedBox(
      width: containerWidth.w,
      height: avatarSize.h,
      // color: Colors.red,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          for (int i = 0;
          // i < numberOfUsersToShow;
          i < (numberOfUsersToShow>users.length ? numberOfUsersToShow : users.length);
          i++)
            Positioned(
              left: (i * (avatarSize - avatarDiff)).w,
              child: _buildUserAvatar(user: i+1 == numberOfUsersToShow && numberOfUsersToShow>users.length ? null : users[i],
                  // showText: i+1 == numberOfUsersToShow && totalUser > users.length
                  showText: i+1 == numberOfUsersToShow && numberOfUsersToShow>users.length),
            ),
          // if(numberOfUsersToShow!=totalUser) Positioned(
          //   left: (numberOfUsersToShow * (avatarSize - avatarDiff)).w,
          //   child: _buildUserAvatar(EnrolledStudent(), showText: true),
          // ),
        ],
      ),
    );
  }

  _buildUserAvatar({ user, bool showText = false}) {
    return Container(
      width: avatarSize.w,
      height: avatarSize.w,
      decoration: BoxDecoration(
        color: Colors.white, //K.colorList[Random().nextInt(K.colorList.length-1)],//color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
          )
        ],
        border: showText ? null : Border.all(
          color: Colors.white,
          width: 2.r,
        ),
      ),
      child: showText
          ? Center(
        child: Text(
          '+${totalUser - users.length}',
          //'+${users.length - numberOfUsersToShow}',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: K.themeColorPrimary.withOpacity(0.7),
          ),
        ),
      )
          : Container(
        height: 0,
        width: 0,
        child: ClipOval(
          child: Image.network(
            // "${user?.image}",
            user,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) {
              return Icon(PhosphorIcons.user_bold, color: Colors.grey[500], size: 15,);
            },
          ),
        ),
      ),
    );
  }
}