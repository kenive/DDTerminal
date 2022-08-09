import 'package:json_annotation/json_annotation.dart';
part 'host.g.dart';

@JsonSerializable()
class Host {
  int? id;
  String host;
  String port;
  String name;
  String pass;

  Host(
      {this.id,
      required this.host,
      required this.pass,
      required this.name,
      required this.port});
  @override
  factory Host.fromJson(Map<String, dynamic> json) => _$HostFromJson(json);

  Map<String, dynamic> toJson() => _$HostToJson(this);

  @override
  String toString() {
    return 'Host{id:$id,host:$host, name:$name, password:$pass, port:$port}';
  }
}
