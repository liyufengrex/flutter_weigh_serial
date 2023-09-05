import 'package:dartx/dartx.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/transformers/backpressure/backpressure.dart';

/// device 返回的数据不连贯，需要在这里做拼接处理
class WeighStreamTransformer
    extends BackpressureStreamTransformer<int, List<int>> {
  WeighStreamTransformer()
      : super(
          WindowStrategy.firstEventOnly,
          (_) => NeverStream<void>(),
          onWindowEnd: (queue) => queue,
          startBufferEvery: 1,
          closeWindowWhen: (queue) {
            final firstItems = queue.takeFirst(3);
            final lastItems = queue.takeLast(3);
            lastItems.removeLast();
            return (firstItems.contentEquals([1, 2, 83]) ||
                    firstItems.contentEquals([1, 2, 85])) &&
                lastItems.contentEquals([3, 4]);
          },
          dispatchOnClose: false,
          maxLengthQueue: 16,
        );
}
