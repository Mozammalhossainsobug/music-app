import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../../../core/constants/text_style.dart';
import '../riverpod/audio_player_provider.dart';

class PlayerPage extends ConsumerStatefulWidget {
  const PlayerPage(
      {super.key, required this.songModel, required this.songIndex});

  final List<SongModel> songModel;
  final int songIndex;

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future((){
      ref.read(audioPlayerProvider.notifier).playSongs(widget.songModel[widget.songIndex].uri, widget.songIndex,widget.songModel[widget.songIndex]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(audioPlayerProvider.notifier);
    final state = ref.watch(audioPlayerProvider);

    final duration = ref.watch(durationProvider);
    final position = ref.watch(positionProvider);
    final value = ref.watch(valueProvider);
    final max = ref.watch(maxProvider);

    return Scaffold(
      backgroundColor: const Color(0xff7360a0),
      body: Column(
        children: [
          // First section
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xff141414),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: AssetImage('images/music-3.gif'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20.h),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: Text(
                    widget.songModel[state.playIndex].displayNameWOExt,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.textStyleOne(
                        Colors.white, 22, FontWeight.w500),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.only(top: 5.h),
                  width: double.infinity,
                  child: Text(
                    '${widget.songModel[state.playIndex].artist}',
                    maxLines: 1,
                    style: AppTextStyle.textStyleOne(
                        Colors.white, 16, FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 15.h,
                    bottom: 15.h,
                  ),
                  child: Row(
                    children: [
                      Text(
                        position.toString(),
                        style: AppTextStyle.textStyleOne(
                            Colors.white, 16, FontWeight.w500),
                      ),
                      Expanded(
                          child: Slider(
                              min: const Duration(seconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: max,
                              value: value,
                              onChanged: (value) {
                                notifier.changeDurationToSeconds(value.toInt());
                                value = value;
                              })),
                      Text(
                        duration.toString(),
                        style: AppTextStyle.textStyleOne(
                            Colors.white, 16, FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          notifier.playPrevious(widget.songModel[state.playIndex == 0 ? 0 : state.playIndex - 1].uri, state.playIndex,widget.songModel[state.playIndex - 1]);
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),

                      // Play/Pause Button

                      IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          if (state.isPlaying == true) {
                            notifier.isPlaying(state.playIndex, false);
                          } else {
                            notifier.isPlaying(state.playIndex, true);
                          }
                        },
                        icon: state.isPlaying == true
                            ? const Icon(
                                Icons.pause,
                                color: Colors.white,
                                size: 35,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 35,
                              ),
                      ),

                      // Forward Button
                      IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          notifier.playForward(widget.songModel[state.playIndex + 1].uri,state.playIndex,widget.songModel.length,widget.songModel[state.playIndex + 1]);
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
