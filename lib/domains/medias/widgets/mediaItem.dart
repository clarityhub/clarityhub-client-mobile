import 'package:clarityhub/domains/app/redux/store/appState.dart';
import 'package:clarityhub/domains/medias/models/media.dart';
import 'package:clarityhub/domains/medias/redux/actions/actions.dart';
import 'package:clarityhub/domains/medias/widgets/mediaAudioPlayer.dart';
import 'package:clarityhub/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MediaItem extends StatelessWidget {
  final String mediaId;

  MediaItem({ this.mediaId });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new StoreConnector(
          onInit: (Store<AppState> store) {
            Media media = store.state.mediaState.medias[mediaId];
            if (media == null) {
                store.dispatch(getMedia(mediaId));
            }
          },
          converter: (Store<AppState> store) {
            Media media = store.state.mediaState.medias[mediaId];

            return _MediaItemViewModel(
              media: media,
              isLoading: (store.state.mediaState.isLoading && media != null) || media == null,
              error: store.state.mediaState.error,
              mediaError: store.state.mediaState.mediaErrors[mediaId],
            );
          },
          builder: (context, _MediaItemViewModel viewModel) {
            if (viewModel.error != null || viewModel.mediaError != null) {
              return Column(
                children: [
                  new ErrorCard(
                    error: viewModel.error != null ? viewModel.error : viewModel.mediaError
                  )
                ]
              );
            }

            if (viewModel.isLoading || viewModel.media.status != 'complete') {
              return new CircularProgressIndicator();
            }

            if (viewModel.media.fileType.startsWith('image')) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Image.network(
                        viewModel.media.presignedUrl,
                      )
                    )
                  )
                )
              );
            } else if (viewModel.media.fileType.startsWith('audio')) {
              // if (viewModel.media.fileType == 'audio/wav' && Platform.isIOS) {
              //   return Padding(
              //     padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              //     child: UnsupportedAudio(
              //       viewModel.media
              //     )
              //   );
              // }

              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: MediaAudioPlayer(
                  viewModel.media,
                )
              );
            }

            // Default
            return Text('');
          },
        ),
      ],
    );
  }
}

class _MediaItemViewModel {
  final Media media;
  final isLoading;
  final error;
  final mediaError;

  _MediaItemViewModel({
    this.media,
    this.isLoading,
    this.error,
    this.mediaError
  });
}