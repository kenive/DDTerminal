import 'package:json_annotation/json_annotation.dart';
part 'host.g.dart';

@JsonSerializable()
class Host {
  String host;
  String port;
  String name;
  String pass;

  Host(
      {required this.host,
      required this.pass,
      required this.name,
      required this.port});
  @override
  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);

  Map<String, dynamic> toJson() => _$HostToJson(this);
}
