import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { TopBack } from '../components/TopBack';

@Entry
@Component
struct Four_HelpAndFeedback {
  // 反馈内容
  @State feedbackText: string = '';
  @State contactInfo: string = '';
  @State selectedProblemType: string = '功能问题';

  // 问题类型选项
  private problemTypes: string[] = ['功能问题', '体验建议', 'BUG反馈'];
  build() {
    Column() {
      TopBack({title:"帮助与反馈"})
      // 内容区域
      Scroll() {
        Column({ space: 20 }) {
          // 反馈表单
          this.FeedbackFormBuilder()
          // 提交按钮
          Button('提交反馈')
            .width('100%')
            .height(48)
            .fontSize(18)
            .fontColor('#FFFFFF')
            .backgroundColor('#8cffc759')
            .borderRadius(8)
            .onClick(() => {
              this.submitFeedback();
            })
          // 常见问题
          this.FAQBuilder()
          // 联系我们 - 放在最后
          this.ContactServiceBuilder()
        }
        .width('100%')
        .padding(16)
        .margin({ bottom: 30 })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 返回上一页
  private goBack(): void {
    console.log('返回个人页面');
    router.back();
  }

  // 提交反馈
  private submitFeedback(): void {
    console.log('提交反馈');

    // 检查输入
    if (this.feedbackText.trim() === '') {
      promptAction.showToast({
        message: '请填写反馈内容',
        duration: 2000
      });
      return;
    }

    console.log('反馈信息:', {
      问题类型: this.selectedProblemType,
      反馈内容: this.feedbackText,
      联系方式: this.contactInfo || '未填写',
      提交时间: new Date().toLocaleString()
    });

    // 显示成功提示
    promptAction.showToast({
      message: '感谢您的反馈！',
      duration: 2000
    });

    // 清空表单
    this.feedbackText = '';
    this.contactInfo = '';
  }

  // 反馈表单Builder
  @Builder
  FeedbackFormBuilder() {
    Column({ space: 15 }) {
      Text('问题反馈')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')

      // 问题类型选择
      Column({ space: 8 }) {
        Text('问题类型')
          .fontSize(16)
          .fontColor('#666666')

        // 类型选项
        Row({ space: 10 }) {
          ForEach(this.problemTypes, (type: string) => {
            Column() {
              Text(type)
                .fontSize(14)
                .fontColor(this.selectedProblemType === type ? '#ff161515' : '#666666')
                .padding({ top: 6, bottom: 6, left: 12, right: 12 })
            }
            .backgroundColor(this.selectedProblemType === type ? '#8cffc579' : '#F5F5F5')
            .borderRadius(15)
            .border({
              width: 1,
              color: this.selectedProblemType === type ? '#8cffc759' : '#DDDDDD'
            })
            .onClick(() => {
              this.selectedProblemType = type;
            })
          })
        }
        .width('100%')
      }

      // 反馈内容
      Column({ space: 8 }) {
        Text('反馈内容 *')
          .fontSize(16)
          .fontColor('#666666')

        TextInput({
          placeholder: '请详细描述您遇到的问题或建议...',
          text: this.feedbackText
        })
          .height(120)
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .padding(12)
          .fontSize(15)
          .border({ width: 1, color: '#DDDDDD' })
          .onChange((value: string) => {
            this.feedbackText = value;
          })
      }

      // 联系方式
      Column({ space: 8 }) {
        Text('联系方式')
          .fontSize(16)
          .fontColor('#666666')

        TextInput({
          placeholder: '邮箱/手机号（选填）',
          text: this.contactInfo
        })
          .height(50)
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .padding(12)
          .fontSize(15)
          .border({ width: 1, color: '#DDDDDD' })
          .onChange((value: string) => {
            this.contactInfo = value;
          })



      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#8cffc759')
    .borderRadius(12)
    .border({ width: 1, color: '#EEEEEE' })
    .shadow({ radius: 5, color: '#10000000', offsetX: 0, offsetY: 2 })
  }

  // 常见问题Builder
  @Builder
  FAQBuilder() {
    Column({ space: 12 }) {
      Text('常见问题')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')

      Column({ space: 8 }) {
        this.FAQItemBuilder('如何修改个人信息？', '在个人中心页面点击"基本信息编辑"进行修改。')
        this.FAQItemBuilder('如何退出登录？', '在个人中心页面底部点击"退出登录"按钮。')
        this.FAQItemBuilder('忘记密码怎么办？', '请联系客服或通过注册邮箱找回密码。')
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#8cffc759')
    .borderRadius(12)
    .border({ width: 1, color: '#EEEEEE' })
  }

  // 常见问题项Builder
  @Builder
  FAQItemBuilder(question: string, answer: string) {
    Column({ space: 6 }) {
      Row() {
        Text('Q：')
          .fontSize(15)
          .fontColor('#FF6B00')
          .fontWeight(FontWeight.Bold)

        Text(question)
          .fontSize(15)
          .fontColor('#333333')
          .layoutWeight(1)
      }
      .width('100%')

      Row() {
        Text('A：')
          .fontSize(14)
          .fontColor('#4CAF50')
          .fontWeight(FontWeight.Bold)

        Text(answer)
          .fontSize(14)
          .fontColor('#666666')
          .layoutWeight(1)
      }
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F9F9F9')
    .borderRadius(8)
    .onClick(() => {
      console.log('点击问题:', question);
    })
  }

  // 联系客服Builder - 放在最后
  @Builder
  ContactServiceBuilder() {
    Column({ space: 15 }) {
      Text('联系我们')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .width('100%')

      // 客服信息
      Column({ space: 10 }) {
        Row({ space: 12 }) {
          Text('📞')
            .fontSize(20)

          Column({ space: 2 }) {
            Text('客服电话')
              .fontSize(14)
              .fontColor('#666666')
            Text('400-123-4567')
              .fontSize(16)
              .fontColor('#007DFF')
              .fontWeight(FontWeight.Bold)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F9F9F9')
        .borderRadius(8)
        .onClick(() => {
          promptAction.showToast({
            message: '客服电话：400-123-4567',
            duration: 2000
          });
        })

        Row({ space: 12 }) {
          Text('📧')
            .fontSize(20)

          Column({ space: 2 }) {
            Text('客服邮箱')
              .fontSize(14)
              .fontColor('#666666')
            Text('support@example.com')
              .fontSize(16)
              .fontColor('#007DFF')
              .fontWeight(FontWeight.Bold)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding(12)
        .backgroundColor('#F9F9F9')
        .borderRadius(8)
        .onClick(() => {
          promptAction.showToast({
            message: '客服邮箱：support@example.com',
            duration: 2000
          });
        })
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#8cffc759')
    .borderRadius(12)
    .border({ width: 1, color: '#EEEEEE' })
  }



}
