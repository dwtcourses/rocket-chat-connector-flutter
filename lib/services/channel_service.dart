import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rocket_chat_connector_flutter/models/channel.dart';
import 'package:rocket_chat_connector_flutter/models/channel_counters.dart';
import 'package:rocket_chat_connector_flutter/models/channel_messages.dart';
import 'package:rocket_chat_connector_flutter/models/filters/channel_counters_filter.dart';
import 'package:rocket_chat_connector_flutter/models/filters/channel_filter.dart';
import 'package:rocket_chat_connector_flutter/models/filters/channel_history_filter.dart';
import 'package:rocket_chat_connector_flutter/models/new/channel_new.dart';
import 'package:rocket_chat_connector_flutter/models/response/channel_new_response.dart';
import 'package:rocket_chat_connector_flutter/models/response/response.dart';
import 'package:rocket_chat_connector_flutter/services/http_service.dart';

class ChannelService {
  HttpService _httpService;

  ChannelService(this._httpService);

  Future<ChannelNewResponse> create(ChannelNew channelNew) async {
    http.Response response = await _httpService.post(
        '/api/v1/channels.create', jsonEncode(channelNew.toMap()));

    if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
      return ChannelNewResponse.fromMap(jsonDecode(response.body));
    }
    return null;
  }

  Future<ChannelMessages> messages(Channel channel) async {
    http.Response response = await _httpService.getWithFilter(
        '/api/v1/channels.messages', ChannelFilter(channel));

    if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
      return ChannelMessages.fromMap(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> markAsRead(Channel channel) async {
    Map<String, String> body = {"rid": channel.id};

    http.Response response =
        await _httpService.post('/api/v1/subscriptions.read', jsonEncode(body));
    if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
      return Response.fromMap(jsonDecode(response.body)).success == true;
    }
    return false;
  }

  Future<ChannelMessages> history(ChannelHistoryFilter filter) async {
    http.Response response =
        await _httpService.getWithFilter('/api/v1/channels.history', filter);

    if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
      return ChannelMessages.fromMap(jsonDecode(response.body));
    }
    return null;
  }

  Future<ChannelCounters> counters(ChannelCountersFilter filter) async {
    http.Response response =
        await _httpService.getWithFilter('/api/v1/channels.counters', filter);

    if (response?.statusCode == 200 && response.body?.isNotEmpty == true) {
      return ChannelCounters.fromMap(jsonDecode(response.body));
    }
    return null;
  }
}
