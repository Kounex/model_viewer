import 'edge.dart';

class Face {
  List<Edge> edges;

  Face(this.edges) : assert(edges.length >= 3);
}
