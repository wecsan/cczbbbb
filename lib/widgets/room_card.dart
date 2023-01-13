import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hot_live/model/liveroom.dart';
import 'package:hot_live/pages/live_play/live_play.dart';
import 'package:hot_live/widgets/keep_alive_wrapper.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({
    Key? key,
    required this.room,
    this.onLongPress,
    this.dense = false,
  }) : super(key: key);

  final RoomInfo room;
  final Function()? onLongPress;
  final bool dense;

  void onTap(BuildContext context) async {
    if (room.liveStatus == LiveStatus.live) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LivePlayPage(room: room)),
      );
    } else {
      String info = '${room.nick} is offline.';
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              info,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeepAliveWrapper(
        child: Card(
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(7.5, 7.5, 7.5, 7.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () => onTap(context),
        onLongPress: onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  color: Theme.of(context).focusColor,
                  elevation: 0,
                  child: room.liveStatus.name == 'live'
                      ? CachedNetworkImage(
                          imageUrl: room.cover,
                          fit: BoxFit.fill,
                          errorWidget: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(Icons.live_tv_rounded, size: 48),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.tv_off_rounded, size: 48),
                              Text("Offline",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w500,
                                  ))
                            ],
                          ),
                        )),
            ),
            ListTile(
              dense: dense,
              contentPadding:
                  dense ? const EdgeInsets.only(left: 8, right: 10) : null,
              horizontalTitleGap: dense ? 8 : null,
              leading: CircleAvatar(
                foregroundImage: room.avatar.isNotEmpty
                    ? CachedNetworkImageProvider(room.avatar)
                    : null,
                radius: 20,
                backgroundColor: Theme.of(context).disabledColor,
              ),
              title: Text(
                room.title,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                room.nick,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Text(
                room.platform,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
            )
          ],
        ),
      ),
    ));
  }
}