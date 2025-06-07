// 📁 파일 위치: lib/admob/presentation/widgets/admob_action_button_widget.dart
// 🔘 Study나 Review 완료 버튼 위젯 (안전장치 강화)
// 버튼을 누르면 카운터가 증가하고 필요시 전면광고를 보여줘요
// 시뮬레이터에서도 안전하게 작동하도록 에러 처리가 추가되었어요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/admob_context_model.dart';
import '../providers/admob_counter_provider.dart';

class AdMobActionButtonWidget extends ConsumerWidget {
  // 버튼에 표시할 텍스트
  final String text;

  // Study인지 Review인지
  final AdMobContextType contextType;

  // 어디서 호출되었는지 (디버깅용)
  final String? location;

  // 버튼을 눌렀을 때 추가로 할 일
  final VoidCallback? onPressed;

  const AdMobActionButtonWidget({
    super.key,
    required this.text,
    required this.contextType,
    this.location,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          print('🔘 버튼 클릭됨: $text');

          // 🔧 먼저 추가 동작 실행 (안전하게)
          if (onPressed != null) {
            try {
              onPressed!();
              print('✅ 추가 동작 완료');
            } catch (e) {
              print('⚠️ 추가 동작 중 오류: $e');
            }
          }

          // 🔧 그 다음 광고 카운터 처리 (안전하게)
          try {
            final counterActions = ref.read(adMobCounterProvider);
            counterActions.showInterstitialIfNeeded(
              contextType,
              from: location ?? text,
            );
            print('✅ 광고 카운터 처리 완료');
          } catch (e) {
            print('⚠️ 광고 카운터 처리 중 오류: $e');
            print('💡 시뮬레이터에서는 광고 기능이 제한될 수 있습니다');
          }

          // 🔧 사용자 피드백 (선택적)
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$text 완료!'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        } catch (e, stackTrace) {
          print('❌ 버튼 동작 중 전체 오류: $e');
          print('스택 트레이스: $stackTrace');

          // 오류가 발생해도 사용자에게 알림
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('동작 중 오류가 발생했습니다'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: contextType == AdMobContextType.study ? Colors.green : Colors.orange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}
