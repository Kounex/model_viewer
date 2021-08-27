import 'package:model_viewer/views/model/widgets/model_viewer/classes/tuple.dart';
import 'package:vector_math/vector_math_64.dart' as VectorMath;

class Edge {
  Tuple<VectorMath.Vector3, VectorMath.Vector3> vertices;

  Edge(VectorMath.Vector3 vertex1, VectorMath.Vector3 vertex2)
      : this.vertices = Tuple(vertex1, vertex2);

  Edge.fromTupel(this.vertices);
}
