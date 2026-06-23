import router from '@ohos.router';
import { prompt, promptAction } from '@kit.ArkUI';
import axios, { AxiosRequestConfig, AxiosResponse } from '@ohos/axios';
import { TopBack } from '../components/TopBack';

// ==================== 类型定义 ====================
interface UserInfo {
  password: string;
  isFirstLogin: boolean;
}

interface CheckResult {
  available: boolean;
  message: string;
}

interface RegisterResult {
  success: boolean;
  message: string;
}


// ==================== 注册页面组件 ====================
@Entry
@Component
struct RegisterPage {
  // 注册表单状态
  @State username: string = "";
  @State password: string = "";
  @State confirmPassword: string = "";
  @State agreeToTerms: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = "";
  @State successMessage: string = "";

  register(){
    // 1. 验证输入
    if (!this.username.trim()) {
      this.errorMessage = '用户名不能为空';
      promptAction.showToast({
        message: '用户名不能为空',
        duration: 2000
      });
      return;
    }
    if (!this.password.trim()) {
      this.errorMessage = '密码不能为空';
      promptAction.showToast({
        message: '密码不能为空',
        duration: 2000
      });
      return;
    }

    if (!this.confirmPassword.trim()) {
      this.errorMessage = '请确认密码';
      promptAction.showToast({
        message: '请确认密码',
        duration: 2000
      });
      return;
    }
    // // 2. 检查用户名是否已验证
    // if (!this.usernameChecked) {
    //   this.errorMessage = '请先检查用户名是否可用';
    //   promptAction.showToast({
    //     message: '请先检查用户名',
    //     duration: 2000
    //   });
    //   return;
    // }

    // 3. 验证密码长度
    if (this.password.length < 6) {
      this.errorMessage = '密码至少6个字符';
      promptAction.showToast({
        message: '密码至少6个字符',
        duration: 2000
      });
      return;
    }

    // 4. 验证密码一致性
    if (this.password !== this.confirmPassword) {
      this.errorMessage = '两次输入的密码不一致';
      promptAction.showToast({
        message: '密码不一致',
        duration: 2000
      });
      return;
    }
    // 5. 验证用户协议
    if (!this.agreeToTerms) {
      this.errorMessage = '请同意用户协议';
      promptAction.showToast({
        message: '请同意用户协议',
        duration: 2000
      });
      return;
    }
    console.log('bbbbb'+this.password + this.confirmPassword)
    // 登录逻辑
    // 在组件方法中调用
    const uiContext = this.getUIContext();
    if(this.password.length > 5 && this.password == this.confirmPassword){
      console.log('账号:', this.username, '密码:', this.password);
      // 新版请求语法
      // 修改后（添加请求体）
      axios("http://172.20.128.177:3003/login", {
        method: 'post',  // 直接使用字符串，不要用 http.RequestMethod.POST
        data: {
          user_id: this.username,      // 改为user_id
          user_password: this.password // 改为user_password
        },
        headers: {
          'Content-Type': 'application/json'
        }
      } as AxiosRequestConfig)  // 添加类型断言
        .then((response: AxiosResponse) => {

          prompt.showToast({ message: '注册成功' });
          console.info('请求成功，状态码:', response.status);
          console.info('响应数据:', response.data.message);
          try {
            if (uiContext) {
              uiContext.getPromptAction().showToast({
                message: `注册成功`,
                duration: 3000
              });
            }
          } catch (error) {
            // TODO: Implement error handling.
          };
          setTimeout(() => {
            this.goBackToLogin()
          }, 3000);

        })
        .catch((err: Error) => {
          console.error('登录请求失败，错误码:', err.message);
          prompt.showToast({ message: '登录失败，请检查网络连接或稍后重试' });
        });
    }else {
      console.log(this.errorMessage)
    }

  }
  goBackToLogin(){
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/LoginPage'
    }).catch(() => {
      // TODO: Implement error handling.
    });
  }
  // 页面生命周期
  aboutToAppear(): void {
    console.log('注册页面: 初始化');
    // 获取从登录页面传递的参数
    const params = router.getParams();
    if (params) {
      console.log('从登录页面接收到的参数:', params);
    }

  }

  build() {
    Column() {

      // 上半部分：背景区域
      this.toptitle()
      // 下半部分：圆角面板
      Column() {
        //表单提交
        this.inputPart()
        //底部链接
        Row() {
          Text('已有账户？')
            .fontSize(16)
            .fontColor('#666666')

          Text('立即登录')
            .fontSize(16)
            .fontColor('#FF9500')
            .fontWeight(FontWeight.Bold)
            .margin({ left: 5 })
            .onClick(() => {
              this.goBackToLogin();
            })
        }
        .margin({ top: 10, bottom: 20 })
      }
      .width('100%')
      .height('72%')
      .backgroundColor(Color.White)
      .borderRadius({
        topLeft: 40,
        topRight: 40,
        bottomLeft: 0,
        bottomRight: 0
      })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#8cffc759')
  }


  @Builder
  inputPart(){
    // 标题
    Text('用户注册')
      .fontSize(30)
      .fontColor('#333333')
      .margin({ top: 30, bottom: 20 })

    // ========== 用户名输入框 ==========
    Stack() {
      // 输入框
      TextInput({
        placeholder: '请输入用户名',
        text: this.username
      })
        .fontSize(16)
        .fontColor('black')
        .width('100%')
        .height(50)
        .padding({ left: 45 })
        .backgroundColor('#8cffc759')
        .borderRadius(25)
        .border({ width: 1, color: '#ff8c8c83' })
        .shadow({ radius: 8, color: '#fff7e7c75', offsetX: 6, offsetY: 6 })
        .textAlign(TextAlign.Start)
        .onChange((value: string) => {
          this.username = value;
          this.errorMessage = '';
        })

      // 用户图标
      Image($r('app.media.yonghu') || $r('sys.media.waveform_folder_fill'))
        .width(24)
        .height(24)
        .position({ x: 15, y: 13 })
    }
    .width('85%')
    .height(50)
    .margin({ bottom: 10 })

    // ========== 密码输入框 ==========
    Stack() {
      TextInput({
        placeholder: '请输入密码（至少6位）',
        text: this.password
      })
        .fontSize(16)
        .fontColor('black')
        .width('100%')
        .height(50)
        .padding({ left: 45 })
        .backgroundColor('#8cffc759')
        .borderRadius(25)
        .border({ width: 1, color: '#fff7e7d77' })
        .shadow({ radius: 8, color: '#fff7a7974', offsetX: 6, offsetY: 6 })
        .type(InputType.Password)
        .textAlign(TextAlign.Start)
        .onChange((value: string) => {
          this.password = value;
          this.errorMessage = '';
        })

      // 锁图标
      Image($r('app.media.suo') )
        .width(24)
        .height(24)
        .position({ x: 15, y: 13 })
    }
    .width('85%')
    .height(50)
    .margin({top:10, bottom: 0 })
    // ========== 确认密码输入框 ==========
    Stack() {
      TextInput({
        placeholder: '请再次输入密码',
        text: this.confirmPassword
      })
        .fontSize(16)
        .fontColor('black')
        .width('100%')
        .height(50)
        .padding({ left: 45 })
        .backgroundColor('#8cffc759')
        .borderRadius(25)
        .border({ width: 1, color: '#fff7e7d77' })
        .shadow({ radius: 8, color: '#fff7a7974', offsetX: 6, offsetY: 6 })
        .type(InputType.Password)
        .textAlign(TextAlign.Start)
        .onChange((value: string) => {
          this.confirmPassword = value;
          this.errorMessage = '';
        })

      // 确认图标
      Text('✓')
        .fontSize(20)
        .fontColor('#666666')
        .position({ x: 15, y: 13 })
    }
    .width('85%')
    .height(50)
    .margin({ top:20,bottom: 15 })

    // 密码匹配提示
    if (this.password && this.confirmPassword) {
      Row() {
        if (this.password === this.confirmPassword) {
          Text('✓ 密码匹配')
            .fontSize(14)
            .fontColor('#34C759')
            .fontWeight(FontWeight.Medium)
        } else {
          Text('✗ 密码不匹配')
            .fontSize(14)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Medium)
        }
      }
      .width('85%')
      .justifyContent(FlexAlign.Start)
      .margin({ bottom: 10 })
    }

    // ========== 用户协议 ==========
    Row() {
      Checkbox()
        .select(this.agreeToTerms)
        .onChange((value: boolean) => {
          this.agreeToTerms = true;
        })
        .margin({ right: 10 })

      Column({ space: 2 }) {
        Text('我已阅读并同意《用户协议》和《隐私政策》')
          .fontSize(14)
          .fontColor('#E99D42')
          .fontWeight(FontWeight.Bold)

      }
    }
    .width('85%')
    .justifyContent(FlexAlign.Start)
    .margin({ bottom: 20 })

    // ========== 注册按钮 ==========
    Button(this.isLoading ? '注册中...' : '立即注册')
      .width('85%')
      .height(50)
      .fontSize(18)
      .backgroundColor('#a8ff9500')
      .fontColor('#7a000000')
      .enabled(!this.isLoading && !!this.username && !!this.password &&
        !!this.confirmPassword && this.password === this.confirmPassword && this.agreeToTerms)
      .onClick(() => {
        this.register();
      })
      .margin({ bottom: 15 })

    // ========== 错误信息 ==========
    if (this.errorMessage) {
      Text(this.errorMessage)
        .fontSize(14)
        .fontColor('#7eff7230')
        .width('85%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 10 })
    }

    // ========== 成功信息 ==========
    if (this.successMessage) {
      Column() {
        Text('🎉 注册成功！')
          .fontSize(16)
          .fontColor('#34C759')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 5 })

        Text(`用户名: ${this.username}`)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 5 })

        Text('3秒后自动返回登录页面')
          .fontSize(12)
          .fontColor('#999999')
      }
      .width('70%')
      .padding(15)
      .backgroundColor('#F0FFF0')
      .borderRadius(15)
      .border({ width: 1, color: '#34C759' })
      .margin({ bottom: 10 })
    }
  }
  @Builder
  toptitle(){
    Stack() {
      // 黄色背景层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#00ffc759')



      // 注册图标/文字
      Column() {
        Text('Welcome')
          .fontSize(36)
          .fontColor('#333333')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        Text('校园通')
          .fontSize(16)
          .fontColor('#666666')
      }
      .align(Alignment.Center)
    }
    .width('100%')
    .height('28%')
  }
}
