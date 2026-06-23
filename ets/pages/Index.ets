import { Index1_Plog } from './Index1_Plog'
import { Index4_My } from './Index4_My'
import { Index2_ShowAccounts } from './Index2_ShowAccounts'
import { Index3_RelaxAppHomePage } from './Index3_RelaxAppHome'
import { router } from '@kit.ArkUI';
import { StorageUtil } from '../utils/StorageUtil';
/**
 * 主页面-配置底部导航栏
 */
// 底部导航项数据结构
class NavItem {
  id: string;
  text: string;
  activeIcon: ResourceStr; // 新增：选中状态的图标
  unactiveIcon: ResourceStr; // 新增：未选中状态的图标

  constructor(id: string, unactiveIcon: ResourceStr, activeIcon: ResourceStr, text: string) {
    this.id = id;
    this.unactiveIcon = unactiveIcon;
    this.activeIcon = activeIcon;
    this.text = text;
  }
}

interface RouteParams {
  token: string;
  account: string;
}


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private tabsController: TabsController = new TabsController()
  @State currentIndex: number = 0; // 新增：当前选中的索引
  @State receivedToken: string = '';
  @State receivedAccount: string = '';
  // 底部导航数据 - 需要你为每个图标准备两种状态（选中和未选中）
  @State navList: NavItem[] = [
    new NavItem('1', $r('app.media.shouye'), $r('app.media.shouye1'), '首页'),
    new NavItem('2', $r('app.media.jizhang'), $r('app.media.jizhang1'), '记账'),
    new NavItem('3', $r('app.media.fangsong'), $r('app.media.fangsong1'), '放松'),
    new NavItem('4', $r('app.media.wode'), $r('app.media.wode1'), '我的')
  ];

  onPageShow() {
    const params = router.getParams() as RouteParams; // 类型断言
    if (params) {
      this.receivedToken = params.token; // 使用点符号访问
      this.receivedAccount = params.account;
    }
  }



  aboutToAppear() {
    // 应用启动时检查是否已登录
    this.checkLoginOnStart();
  }


  // 自定义TabBar构建函数
  @Builder TabBarBuilder(item: NavItem, index: number) {
    Column({ space: 4 }) {
      // 根据是否选中显示不同的图标
      Image(this.currentIndex === index ? item.activeIcon : item.unactiveIcon)
        .width(24)
        .height(24)
        // .backgroundColor(Color.Red)
        .objectFit(ImageFit.Auto)
      // 根据是否选中设置不同的文字颜色
      Text(item.text)
        .fontSize(14)
        .fontColor(this.currentIndex === index ? '#007DFF' : '#ff000000') // 选中时蓝色，未选中时黑色
    }

    .width('100%')
    .padding({ left: 8, right: 8, top: 4 })
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击时切换到对应的Tab
      this.currentIndex = index;
      this.tabsController.changeIndex(index);
    })
  }



  // Index.ets - 修改 checkLoginOnStart 方法
  checkLoginOnStart() {
    const token = StorageUtil.getToken();
    const userId = StorageUtil.getUserId();

    console.info('启动检查 - Token:', token ? '有' : '无');
    console.info('启动检查 - 用户ID:', userId);

    // 修改这里：优先检查本地存储的token
    if (!token) {
      console.info('未登录，跳转到登录页');
      // 延迟跳转，避免界面闪烁
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/LoginPage'
        });
      }, 100);
    } else {
      console.info('已保存登录信息，可以跳过登录');
      // 如果通过路由参数收到了新的token，也保存到本地
      if (this.receivedToken && this.receivedAccount) {
        StorageUtil.saveToken(this.receivedToken);
        StorageUtil.saveUserId(this.receivedAccount);
        console.info('保存了路由传递的token和账号');
      }
    }
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {
        Column() {
          Index1_Plog()
        }
      }.tabBar(this.TabBarBuilder(this.navList[0], 0))

      TabContent() {
        Column() {
          Index2_ShowAccounts()
        }
      }.tabBar(this.TabBarBuilder(this.navList[1], 1))

      TabContent() {
        Column() {
          Index3_RelaxAppHomePage()
        }
      }.tabBar(this.TabBarBuilder(this.navList[2], 2))

      TabContent() {
        Column() {
          Index4_My()
        }
      }.tabBar(this.TabBarBuilder(this.navList[3], 3))
    }
    .scrollable(false)
  }
}