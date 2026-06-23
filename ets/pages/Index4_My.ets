import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Top } from '../components/Top';
import { StorageUtil } from '../utils/StorageUtil';

@Entry
@Component
export  struct Index4_My {
  // 接收从登录页面传递的参数
  @State username: string = '未登录用户';
  @State userPassword: string = '********';
  @State receivedPassword: boolean = false;
  @State loginTime: string = '--:--:--';
  // 用户数据
  @State myPostsCount: number = 128;
  @State myLikesCount: number = 56;
  // 页面显示状态
  @State showLogoutConfirm: boolean = false;

  /**
   * 页面显示时调用 - 接收路由参数
   */
  aboutToAppear(): void {
    console.log('个人中心页面: 开始接收登录参数');

    // 获取路由参数
    const params = router.getParams() as Record<string, string>;

    if (params) {
      console.log('收到的参数对象:', JSON.stringify(params));

      // 检查是否有用户名参数
      if (params['username']) {
        this.username = params['username'];
        console.log('用户名参数:', this.username);
      } else {
        console.log('没有找到用户名参数');
      }

      // 检查是否有密码参数
      if (params['password']) {
        this.receivedPassword = true;
        this.userPassword = params['password'];
        console.log('密码参数: 已接收');
      } else {
        console.log('没有找到密码参数');
      }

      // 检查是否有登录时间参数
      if (params['loginTime']) {
        this.loginTime = params['loginTime'];
        console.log('登录时间:', this.loginTime);
      }
    } else {
      console.log('没有收到任何参数');
    }
  }

  build() {
    Column() {
      Top({title:'我的'})
      // 用户信息头部
      this.UserHeaderBuilder()

      // 下半部分 - 上方两个角为圆角
      Column() {
        // 我的帖子和我喜欢的
        this.MyPostsAndLikesBuilder()

        // 设置标题
        Text('设置')
          .fontSize(20)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .width('90%')
          .textAlign(TextAlign.Start)
          .margin({ top: 10, bottom: 10, left: 20 })

        // 设置框
        this.SettingsBoxBuilder()

        // 退出登录按钮
        this.LogoutButtonBuilder()
      }
      .width('100%')
      .height('70%')
      .backgroundColor(Color.White)
      .borderRadius({
        topLeft: 60,
        topRight: 60,
        bottomLeft: 0,
        bottomRight: 0
      })

      // 退出确认对话框
      this.LogoutDialogBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFE0A4 ')
  }

  /**
   * 跳转到我的帖子页面
   */
  private goToMyPosts(): void {
    console.log('跳转到我的帖子页面');

    router.pushUrl({
      url: 'pages/Index', // 这里可以替换为实际的帖子页面
      params: {
        fromPage: 'PersonalPage',
        action: 'viewPosts',
        username: this.username
      }
    }).then(() => {
      console.log('跳转到我的帖子页面成功');
    }).catch((err: string) => {
      console.error('跳转失败:', err);
    });
  }

  /**
   * 跳转到我喜欢的页面
   */
  private goToMyLikes(): void {
    console.log('跳转到我喜欢的页面');

    router.pushUrl({
      url: 'pages/Index', // 这里可以替换为实际的喜欢页面
      params: {
        fromPage: 'PersonalPage',
        action: 'viewLikes',
        username: this.username
      }
    }).then(() => {
      console.log('跳转到我喜欢的页面成功');
    }).catch((err: string) => {
      console.error('跳转失败:', err);
    });
  }


  /**
   * 跳转到关于软件页面
   */
  private goToAbout(): void {
    console.log('跳转到关于软件页面');

    router.pushUrl({
      url: 'pages/Index', // 这里可以替换为实际的关于页面
      params: {
        fromPage: 'PersonalPage',
        action: 'about',
        username: this.username
      }
    }).then(() => {
      console.log('跳转到关于软件页面成功');
    }).catch((err: string) => {
      console.error('跳转失败:', err);
    });
  }

  /**
   * 跳转到基本信息编辑页面
   */
  private goToPersonalInfoEdit(): void {
    console.log('跳转到基本信息编辑页面');
    console.log('跳转详情页面')
    router.pushUrl({
      url: 'pages/Four_PersonalInfoEdit',
      params: {
        articleData: JSON.stringify(this.username)
      }
    })

  }

  /**
   * 跳转到帮助与反馈页面
   */
  private goToHelpAndFeedback(): void {
    console.log('跳转到帮助与反馈页面');

    router.pushUrl({
      url: 'pages/Four_HelpAndFeedback'
    } as router.RouterOptions).then(() => {
      console.log('跳转到帮助与反馈页面成功');
    }).catch((error: Error) => {
      console.error('跳转失败:', error.message);
    });
  }



  /**
   * 退出登录功能
   */
  private logout(): void {
    console.log('用户退出登录');

    // 跳转到登录页面
    router.replaceUrl({
      url: 'pages/LoginPage',
      params: {
        action: 'logout',
        username: this.username,
        logoutTime: new Date().toLocaleString()
      }
    }).then(() => {
      console.log('成功跳转到登录页');
    }).catch((err: string) => {
      console.error('跳转到登录页失败:', err);
      // 如果失败，尝试其他方式
      router.clear();
      router.pushUrl({ url: 'pages/LoginPage' });
    });
  }

  /**
   * 显示退出确认框
   */
  private showLogoutDialog(): void {
    console.log('用户退出登录');

    // 清除token和用户信息
    StorageUtil.clearLoginInfo();
    console.info('已清除本地登录信息');

    // 跳转到登录页面
    router.replaceUrl({
      url: 'pages/LoginPage',
      params: {
        action: 'logout',
        username: this.username,
        logoutTime: new Date().toLocaleString()
      }
    }).then(() => {
      // 先显示点击反馈
      promptAction.showToast({
        message: `退出登录成功`,
        duration: 1000
      });
      console.log('成功跳转到登录页');
    }).catch((err: string) => {
      console.error('跳转到登录页失败:', err);
      // 如果失败，尝试其他方式
      router.clear();
      router.pushUrl({ url: 'pages/LoginPage' });
    });
  }

  /**
   * 隐藏退出确认框
   */
  private hideLogoutDialog(): void {
    this.showLogoutConfirm = false;
  }

  // 用户信息头部Builder
  @Builder
  UserHeaderBuilder() {
    Column() {
      // 用户头像
      Image($r('app.media.tx')) // 头像图片
        .width(100)
        .height(100)
        .borderRadius(50) // 圆形头像
        .border({ width: 1, color: '#BBBBBB' })
        .margin({ bottom: 15 })

      // 用户名
      Text(this.username)
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#ff372f2f')
        .margin({ bottom: 5 })

      // 用户账号信息
      Text(this.userPassword)
        .fontSize(16)
        .fontColor('#ff2b2626')
        .opacity(0.9)

      // 调试信息：显示是否收到密码
      Text('密码已接收：' + (this.receivedPassword ? '是' : '否'))
        .fontSize(12)
        .fontColor('#666666')
        .margin({ top: 5 })
    }
    .width('100%')
    .height('30%')
    // .backgroundColor('#8cffc759')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 我的帖子和我喜欢的Builder
  @Builder
  MyPostsAndLikesBuilder() {
    Row({ space: 10 }) {
      // 我的帖子 - 可点击
      Column() {
        Text('我的帖子')
          .fontSize(16)
          .fontColor('#333333')
          .margin({ bottom: 5 })
          .fontWeight(FontWeight.Bold)

        Text(this.myPostsCount.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#101010')
      }
      .width('48%')
      .height(80)
      .backgroundColor('#8cffc759')
      .borderRadius(20)
      .border({ width: 1, color: '#BBBBBB' })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        this.goToMyPosts();
      })

      // 我喜欢的 - 可点击
      Column({ space: 0 }) {
        Text('我喜欢的')
          .fontSize(16)
          .fontColor('#333333')
          .margin({ bottom: 5 })
          .fontWeight(FontWeight.Bold)

        Text(this.myLikesCount.toString())
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#101010')
      }
      .width('48%')
      .height(80)
      .backgroundColor('#8cffc759')
      .borderRadius(20)
      .border({ width: 1, color: '#BBBBBB' })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        this.goToMyLikes();
      })
    }
    .width('90%')
    .padding(20)
    .margin({ top: 20 })
  }

  // 设置项Builder
  @Builder
  SettingItemBuilder(index: number, title: string, icon: Resource, onClick: () => void) {
    Row() {
      Text(index.toString())
        .fontSize(16)
        .fontColor('#FF9500')
        .fontWeight(FontWeight.Bold)
        .margin({ right: 12 })

      Text(title)
        .fontSize(17)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)

      Image(icon)
        .width(15)
        .height(15)
    }
    .width('100%')
    .height(45)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .borderRadius(8)
    .border({ width: 1, color: '#EEEEEE' })
    .onClick(() => {
      console.log('=== 点击了设置项 ===');
      console.log('索引:', index);
      console.log('标题:', title);
      console.log('onClick函数:', onClick);
      // 再执行点击函数
      if (onClick) {
        console.log('执行onClick函数');
        onClick();
      } else {
        console.log('onClick函数为空');
      }
    })
  }
  // 设置框Builder
  @Builder
  SettingsBoxBuilder() {
    Column() {
      Scroll() {
        Column({ space: 8 }) {
          // 1. 基本信息编辑
          this.SettingItemBuilder(1, '基本信息编辑', $r('app.media.suo'), () => {
            this.goToPersonalInfoEdit();
          })

          // 2. 帮助与反馈
          // 在 SettingsBoxBuilder 或其他设置列表中：
          this.SettingItemBuilder(2, '帮助与反馈', $r('app.media.bangzu'), () => {
            this.goToHelpAndFeedback();
          })

          // 3. 关于软件
          this.SettingItemBuilder(3, '关于软件', $r('app.media.wenhao'), () => {
            this.goToAbout();
          })

          // 可以添加更多设置项用于测试滑动
          // 第4项
          this.SettingItemBuilder(4, '隐私设置', $r('app.media.suo'), () => {
            console.log('点击隐私设置');
          })

          // 第5项
          this.SettingItemBuilder(5, '账号安全', $r('app.media.suo'), () => {
            console.log('点击账号安全');
          })

          // 第6项
          this.SettingItemBuilder(6, '通知管理', $r('app.media.suo'), () => {
            console.log('点击通知管理');
          })
        }
        .width('100%')
        .padding(8)
      }
      .width('90%')
      .height(150)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .border({ width: 1, color: '#E0E0E0' })
      .shadow({ radius: 4, color: '#10000000' })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
  }

  // 退出登录按钮Builder
  @Builder
  LogoutButtonBuilder() {
    Column() {
      Text('退出登录')
        .fontSize(16)
        .fontColor('#FF110F0F')
        .padding({
          left: 30,
          right: 30,
          top: 10,
          bottom: 10
        })
        .borderRadius(8)
        .border({
          width: 1,
          color: '#ff666464'
        })
        .backgroundColor('#FFD0CECE')
    }
    .width('100%')
    .margin({ top: 50, bottom: 30 })
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      console.log('确认退出登录');
      this.showLogoutDialog();
    })
  }

  // 退出确认对话框Builder
  @Builder
  LogoutDialogBuilder() {
    if (this.showLogoutConfirm) {
      Stack() {
        // 半透明遮罩
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#000000')
          .opacity(0.5)
          .onClick(() => {
            this.hideLogoutDialog();
          })

        // 对话框内容 - 使用Column包装并居中
        Column() {
          Column() {
            // 标题
            Text('确认退出登录')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ top: 25, bottom: 15 })

            // 提示信息
            Text('确定要退出当前账号吗？')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ bottom: 25 })

            // 按钮区域
            Row() {
              // 取消按钮
              Column() {
                Text('取消')
                  .fontSize(16)
                  .fontColor('#666666')
                  .padding({ top: 10, bottom: 10 })
              }
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .border({
                width: 1,
                color: '#DDDDDD'
              })
              .layoutWeight(1)
              .onClick(() => {
                this.hideLogoutDialog();
              })

              // 间隔
              Column()
                .width(15)

              // 确认按钮
              Column() {
                Text('确认退出')
                  .fontSize(16)
                  .fontColor('#FFFFFF')
                  .padding({ top: 10, bottom: 10 })
              }
              .backgroundColor('#FF1D1D')
              .borderRadius(8)
              .layoutWeight(1)
              .onClick(() => {
                this.logout();
              })
            }
            .width('80%')
            .height(50)
          }
          .width('70%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .padding({ left: 20, right: 20, bottom: 20 })
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .position({ x: 0, y: 0 })
    }
  }

}
