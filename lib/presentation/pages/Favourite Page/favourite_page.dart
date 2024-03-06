import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/core/utils/dynamic_size.dart';
import 'package:music_app/data/data_source/get_local_audio_files_impl.dart';
import 'package:music_app/data/model/object_box_model.dart';
import 'package:music_app/presentation/pages/song_playing_page/song_playing_page.dart';
import 'package:music_app/presentation/provider/db_provider.dart';
import 'package:music_app/presentation/widget/song_tile.dart';

class FavouritePage extends ConsumerWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(getLocalAudioProvider);

    final List<SongsEntity> favsong = ref.watch(addsongProvider);
    final List<AudioSource> audioSources = song.value!
        .map(
          (source) => AudioSource.file(source.data),
        )
        .toList();
    // create playlist
    final ConcatenatingAudioSource playlist =
        ConcatenatingAudioSource(children: audioSources);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8 * 2),
        child: favsong.isEmpty
            ? const Center(
                child: Text("No favourite songs"),
              )
            : ListView.separated(
                itemCount: favsong.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: context.h(17),
                ),
                itemBuilder: (context, index) => SongTile(
                  iconColor: Colors.red,
                  title: "${favsong[index].title}",
                  subtitle: '',
                  // AudioSource.file(song.value![index].data),
                  onListTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongPlayingPage(
                          index: index,
                          data: song.value,
                          playlist: playlist,
                        ),
                      )),
                  ontap: () {
                    ref
                        .watch(addsongProvider.notifier)
                        .removing(id: favsong[index].id);
                  },
                ),
              ),
      ),
    );
  }
}
