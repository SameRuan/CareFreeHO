import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { Top } from '../components/Top';
import { TopBack } from '../components/TopBack';

@Entry
@Component
struct Four_PersonalInfoEdit {
  // 从路由参数接收的数据
  @State username: string = '';
  @State userPassword: string = '';

  // 编辑状态
  @State editingUsername: string = '';
  @State editingPassword: string = '';
  @State selectedAvatar: Resource = $r('app.media.tx');

  // 页面状态
  @State showSaveSuccess: boolean = false;

  aboutToAppear(): void {
    console.log('基本信息编辑页面: 开始接收参数');

    const params = router.getParams() as Record<string, string> | undefined;

    if (params) {
      if (params['username']) {
        this.username = params['username'];
        this.editingUsername = params['username'];
      }

      if (params['password']) {
        this.userPassword = params['password'];
        this.editingPassword = params['password'];
      }

      console.log('接收到的用户信息:', {
        username: this.username,
        password: this.userPassword
      });
    }
  }

  build() {
    Column({space:'6'}) {
      // 顶部标题栏
      TopBack({title:'编辑基本信息'})
      Scroll() {
        Column({ space: 6 }) {
          // 头像选择区域
          this.AvatarSelectionBuilder()

          // 用户名编辑区域
          this.UsernameInputBuilder()

          // 密码编辑区域
          this.PasswordInputBuilder()

          // 保存按钮
          this.SaveButtonBuilder()

        }
        .width('100%')
      }
      .width('95%')
      .height('100%')

      // 保存成功提示
      this.SaveSuccessBuilder()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFE0A4')
  }
  /**
   * 保存用户信息
   */
  private saveUserInfo(): void {
    console.log('保存用户信息');

    // 验证输入
    if (!this.editingUsername.trim()) {
      console.error('用户名不能为空');
      return;
    }

    if (!this.editingPassword.trim()) {
      console.error('密码不能为空');
      return;
    }

    // 更新信息
    this.username = this.editingUsername;
    this.userPassword = this.editingPassword;

    console.log('信息已更新:', {
      username: this.username,
      password: this.userPassword
    });

    // 显示保存成功提示
    this.showSaveSuccess = true;

    // 2秒后隐藏提示
    setTimeout(() => {
      this.showSaveSuccess = false;
    }, 2000);
  }

  // 头像选择Builder
  @Builder
  AvatarSelectionBuilder() {
    Column({space:8}) {
      Text('选择头像')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ top:'15',left:'25' })


      // 当前选择的头像
      Column() {
        Image(this.selectedAvatar)
          .width(100)
          .height(100)
          .borderRadius(60)
          .border({ width: 3, color: '#FF9900' })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 头像选项
      Row({ space: 20 }) {
        this.AvatarOptionBuilder($r('app.media.Banner2'), '默认')
        this.AvatarOptionBuilder($r('app.media.Banner1'), '头像1')
        this.AvatarOptionBuilder($r('app.media.Banner2'), '头像2')
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height(260)
    .backgroundColor('#FFFFFF')
    .borderRadius(15)
    .border({ width: 1, color: '#FFCC00' })
    .shadow({ radius: 8, color: '#20000000', offsetX: 0, offsetY: 4 })
  }

  // 头像选项Builder
  @Builder
  AvatarOptionBuilder(avatar: Resource, label: string) {
    Column() {
      Image(avatar)
        .width(70)
        .height(70)
        .borderRadius(35)
        .border({
          width: this.selectedAvatar === avatar ? 4 : 2,
          color: this.selectedAvatar === avatar ? '#FF9900' : '#CCCCCC'
        })
        .onClick(() => {
          this.selectedAvatar = avatar;
        })
      Text(label)
        .fontSize(14)
        .fontColor('#333333')
        .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Center)
  }

  // 用户名输入Builder
  @Builder
  UsernameInputBuilder() {
    Column() {
      Text('修改用户名')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 15 })

      TextInput({ placeholder: '请输入新用户名', text: this.editingUsername })
        .width('100%')
        .height(45)
        .backgroundColor('#FFF8E1')
        .borderRadius(10)
        .padding({ left: 15, right: 15 })
        .fontSize(17)
        .border({ width: 1, color: '#FFCC00' })
        .onChange((value: string) => {
          this.editingUsername = value;
        })
    }
    .height(118)
    .width('100%')
    .padding(25)
    .backgroundColor('#FFFFFF')
    .borderRadius(15)
    .border({ width: 1, color: '#FFCC00' })
    .shadow({ radius: 8, color: '#20000000', offsetX: 0, offsetY: 4 })
  }

  // 密码输入Builder
  @Builder
  PasswordInputBuilder() {
    Column({space:8}) {
      Text('修改密码')
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ bottom: 15 })
      TextInput({ placeholder: '请输入旧密码', text: this.editingPassword })
        .type(InputType.Password)
        .width('100%')
        .height(45)
        .backgroundColor('#FFF8E1')
        .borderRadius(10)
        .padding({ left: 15, right: 15 })
        .fontSize(17)
        .border({ width: 1, color: '#FFCC00' })
        .onChange((value: string) => {
          this.editingPassword = value;
        })
      TextInput({ placeholder: '请输入新密码', text: this.editingPassword })
        .type(InputType.Password)
        .width('100%')
        .height(45)
        .backgroundColor('#FFF8E1')
        .borderRadius(10)
        .padding({ left: 15, right: 15 })
        .fontSize(17)
        .border({ width: 1, color: '#FFCC00' })
        .onChange((value: string) => {
          this.editingPassword = value;
        })
    }
    .height(180)
    .width('100%')
    .padding(25)
    .backgroundColor('#FFFFFF')
    .borderRadius(15)
    .border({ width: 1, color: '#FFCC00' })
    .shadow({ radius: 8, color: '#20000000', offsetX: 0, offsetY: 4 })
  }

  // 保存按钮Builder
  @Builder
  SaveButtonBuilder() {
    Column() {
      Column(){
        Text('保存修改')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .padding({ top: 18, bottom: 18 })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('150')
      .backgroundColor('#bcefbf75')
      .borderRadius(12)
      .border({ width: 2, color: '#70ffa666' })
      .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 6 })
      .onClick(() => {
        this.saveUserInfo();
      })
    }
    .layoutWeight(1)
  }

  // 保存成功提示Builder
  @Builder
  SaveSuccessBuilder() {
    if (this.showSaveSuccess) {
      Column() {
        Text('保存成功 ✓')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .padding({ top: 15, bottom: 15, left: 30, right: 30 })
      }
      .backgroundColor('#4CAF50')
      .borderRadius(25)
      .border({ width: 2, color: '#388E3C' })
      .shadow({ radius: 8, color: '#40000000', offsetX: 0, offsetY: 4 })
      .position({ x: '50%', y: '50%' })
      .translate({ x: -70, y: -50 })
    }
  }

}
