import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { kvStoreUtils } from '../common/KVStoreUtils';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // 初始化键值型数据库
    kvStoreUtils.init(this.context)
    kvStoreUtils.createKVStore()

  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  // 在EntryAbility中注入全局上下文
  onWindowStageCreate(windowStage: window.WindowStage) {
    kvStoreUtils.init(this.context)
    windowStage.loadContent('pages/EntryPage', (err, data) => {
      if (err.code) {
        // 错误处理逻辑
        return;
      }
      // 加载成功逻辑
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}