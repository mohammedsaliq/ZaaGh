import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rhthemix/core/utils/dynamic_size.dart';
import 'package:rhthemix/data/data_source/get_local_audio_files_impl.dart';
import 'package:rhthemix/presentation/pages/song_playing_page/song_playing_page.dart';
import 'package:rhthemix/presentation/widget/app_title.dart';
import 'package:rhthemix/presentation/widget/drawer_widget.dart';
import 'package:rhthemix/presentation/widget/local_song_tile.dart';

class LocalHomePage extends ConsumerWidget {
  const LocalHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(getLocalAudioProvider);

    return Scaffold(
      appBar: AppBar(
        title: AppTitle(
            textstyle: const TextStyle(),
            imgwidth: context.w(30),
            image: "assets/image/music_img.png",
            titileText: "Local Songs"),
      ),
      drawer: const DrawerWidget(),
      body: song.when(
        data: (data) {
          final List<AudioSource> audioSources = data
              .map(
                (source) => AudioSource.file(
                  source.data,
                  tag: MediaItem(
                    id: '1',
                    title: source.title,
                    artist: source.artist,
                  ),
                ),
              )
              .toList();
          // create playlist
          final ConcatenatingAudioSource playlist =
              ConcatenatingAudioSource(children: audioSources);
          return song.value == null
              ? const Center(
                  child: Text('song empty'),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => LocalSongTile(
                        data: song.value!,
                        index: index,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              log(song.value![index].data.toString());
                              log(song.value.toString());
                              return SongPlayingPage(
                                data: song.value!,
                                index: index,
                                playlist: playlist,
                              );
                            },
                          ));
                        },
                      ),
                  separatorBuilder: (context, index) => SizedBox(
                        height: context.h(10),
                      ),
                  itemCount: song.value!.length);
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
