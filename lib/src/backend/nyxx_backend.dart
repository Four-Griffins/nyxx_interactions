import 'dart:async';
import 'dart:convert';

import 'package:nyxx/nyxx.dart';

import 'interaction_backend.dart';

class WebsocketInteractionBackend implements InteractionBackend {
  @override
  INyxxWebsocket client;

  late final StreamController<ApiData> _streamController;
  late final Stream<ApiData> _stream;

  WebsocketInteractionBackend(this.client);

  @override
  void setup() {
    _streamController = StreamController.broadcast();
    _stream = _streamController.stream;

    client.options.dispatchRawShardEvent = true;
    client.eventsWs.onReady.first.then((_) {
      client.shardManager.rawEvent.map((event) => event.rawData).pipe(_streamController);
    });
  }

  @override
  Stream<ApiData> getStream() => _stream;

  @override
  StreamController<ApiData> getStreamController() => _streamController;
}
