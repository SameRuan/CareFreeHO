// LoginPage.ets
import  axios, { AxiosRequestConfig, AxiosResponse } from '@ohos/axios';
import { prompt, promptAction, router } from '@kit.ArkUI';
import { StorageUtil } from '../utils/StorageUtil';

// 响应数据接口
// 定义data字段的结构
interface LoginResultData {
  user_id: string;
  token: string;
  tokenExpires: string; // 统一用字符串类型处理日期
  createdAt: string;
  loginTime: string;
}

// 定义整体响应结构
interface ResData {
  success: boolean;
  code: number;
  message: string;
  data?: LoginResultData; // 可选属性
}

@Entry
@Component
struct LoginPage {
  @State account: string = '';
  @State password: string = '';
  @State agreeToTerms: boolean = false;
  @State passwordVisible: boolean = false;

  build() {
    Column() {
      // 上半部分：黄色背景，没有内容
      // 上半部分：人物图片隐入背景色
      Stack() {
        // 黄色背景层
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#00ffc759')  // 黄色背景

        // PNG人物图片（必须是有透明背景的PNG）
        Image($r('app.media.beijing'))  // 使用你提供的图片
          .width('70%')      // 调整合适的大小
          .height('80%')
          .objectFit(ImageFit.Cover)  // 保持比例，完整显示
          .blendMode(BlendMode.SRC_OVER)  // 正常混合模式
          .align(Alignment.Center)      // 居中放置
      }
      .width('100%')
      .height('30%')



      // 下半部分：白色圆角面板，包含所有内容
      Column({ space: 20 }) {
        // 标题放在下半部分顶部
        Text('Welcome')
          .fontSize(40)
          .fontColor('#c7333333')
          .margin({ top: 20, bottom: 15 })

        // 账号输入框
        // 账号输入框 - 使用Stack叠加图标
        Stack() {
          // 输入框
          TextInput({ placeholder: '请输入账号' })
          // 或者同时设置输入文字的字体大小
            .fontSize(16)                   // 设置输入文字的大小也为16px
            .fontColor('black')
            .width('100%')
            .height(50)
            .padding({ left: 0 })  // 左边留出图标空间
            .backgroundColor('#8cffc759')
            .borderRadius(25)
            .border({
              width: 1,
              color: '#ff8c8c83'
            })
            .shadow({
              radius: 8,
              color: '#ff7e7c75',
              offsetX: 6,
              offsetY: 6
            })
            .textAlign(TextAlign.Center)
            .onChange((value: string) => {
              this.account = value;
            })

          // 图标叠加在输入框内部左侧
          Image($r('app.media.yonghu'))
            .width(24)
            .height(24)
            .position({ x: 20, y: 13 })  // 绝对定位在输入框内部
        }
        .width('90%')
        .height(50)
        .margin({
          top: 0,      // 添加上边距
          bottom: 10,   // 添加下边距
          left: 20,     // 添加左边距
          right: 20     // 添加右边距
        })



        // 密码输入框

        // 密码输入框 - 使用Stack在内部添加图标
        Stack() {
          // 输入框
          TextInput({ placeholder: '请输入密码' })
            .width('100%')
            .height(50)
            .padding(10)  // 左边留出图标空间
            .backgroundColor('#8cffc759')  // 黄色背景
            .borderRadius(25)  // 椭圆形
            .border({
              width: 1,
              color: '#ff7e7d77'  // 黄色边框
            })
            .shadow({
              radius: 8,
              color: '#ff7a7974',
              offsetX: 6,
              offsetY: 6
            })
            .type(InputType.Password)  // 密码类型
            .textAlign(TextAlign.Center)  // 文字居中
            .onChange((value: string) => {
              this.password = value;
            })

          // 图标叠加在输入框内部左侧
          Image($r('app.media.suo'))  // 请替换为你的图标资源
            .width(24)
            .height(24)
            .margin({ left: 15 })  // 距离左侧15px
            .position({ y: 13 })  // 垂直居中 (50-24)/2≈13
            .objectFit(ImageFit.Contain)
        }
        .width('90%')
        .height(50)
        .margin({
          top: 0,      // 添加上边距
          bottom: 0,   // 添加下边距
          left: 20,     // 添加左边距
          right: 20     // 添加右边距
        })


        // 协议勾选框
        Row() {
          Checkbox()
            .select(this.agreeToTerms)
            .onChange((value: boolean) => {
              this.agreeToTerms = value;
            })
          Text('我已阅读并同意《用户协议》和《隐私政策》')
            .fontSize(14)
            .fontColor('#E99D42')
            .fontWeight(FontWeight.Bold)
        }
        .width('90%')
        .margin({ top: 10 })

        // 登录按钮
        Button('登录')
          .width('90%')
          .height(50)
          .fontSize(18)
          .backgroundColor(this.agreeToTerms ? '#FFC759' : '#CCCCCC')  // 使用黄色
          .fontColor(this.agreeToTerms ? '#FFFFFF' : '#888888')
          .enabled(this.agreeToTerms)
          .onClick(() => {
            console.log('账号:', this.account, '密码:', this.password);
            this.userlogin()
            // router.pushUrl({
            //   url:'pages/Index'
            // })

          })
          .margin({ top: 20 })

        // 底部链接
        Blank()
        Row() {
          Text('注册账户')
            .fontSize(18)
            .fontColor('#E99D42')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              // 跳转注册页面
              router.pushUrl({
                url:'pages/RegisterPage'
              })
            })
          Blank()

          Text('忘记密码')
            .fontSize(18)
            .fontColor('#E99D42')
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              // 跳转忘记密码页面
            })
        }
        .width("90%")
        .justifyContent(FlexAlign.SpaceBetween)

        .margin({ top: 20 })
      }
      .width('100%')
      .height('70%')  // 下半部分占70%高度
      .backgroundColor(Color.White)
      .borderRadius({
        topLeft: 50,
        topRight: 50,
        bottomLeft: 0,
        bottomRight: 0
      })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#8cffc759')  // 整体背景色为黄色
  }
  // 登录逻辑 - 使用你原来的结构，但加上错误消息
  async userlogin() {
    await axios("http://172.20.128.177:3003/login", {
      method: 'post',
      data: {
        user_id: this.account,
        user_password: this.password
      },
      headers: {
        'Content-Type': 'application/json'
      }
    } as AxiosRequestConfig)
      .then((response: AxiosResponse) => {
        console.info('请求成功，状态码:', response.status);

        const res: ResData = response.data; // 类型声明为接口
        if (res.success && res.data) {
          console.log('=======Token:', res.data.token);
        }

        // LoginPage.ets - 修改登录成功部分
        if (res.success) {
          // 新增：保存token和用户信息到本地存储
          if (res.data) {
            StorageUtil.saveToken(res.data.token);
            StorageUtil.saveUserId(res.data.user_id);
            console.info('Token已保存到本地:', res.data.token.substring(0, 10) + '...');
          }

          // 登录成功
          prompt.showToast({
            message: `${res.message}，欢迎用户: ${this.account}`,
            duration: 3000
          });

          console.info('获取到token:', res.data?.token);

          setTimeout(() => {
            router.pushUrl({
              url: 'pages/Index',
              params: {
                token: res.data?.token || '', // 安全取值操作
                account: this.account
              }
            });
          }, 3000);
        }
      })
      .catch((err: Error) => {
        console.error('登录请求失败，错误码:', err.message);

        // 更详细的错误提示
        let errorMessage = '登录失败，请检查网络连接或稍后重试';
        if (err.message.includes('Network Error')) {
          errorMessage = '网络连接失败，请检查服务器是否启动';
        }

        prompt.showToast({
          message: errorMessage,
          duration: 3000
        });
      });
  }
}