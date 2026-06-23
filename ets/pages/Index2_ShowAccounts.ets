import { promptAction, router } from '@kit.ArkUI';
import { kvStoreUtils } from '../common/KVStoreUtils';
import { Top } from '../components/Top';
import { Bill } from './Two_KeepAccounts';

/**
 * 账单展示
 */
@Entry
@Component
export struct Index2_ShowAccounts {
  @State listData: Bill[] = []
  @State PlanExpense: number = 1800
  @State totalExpense: number = 560
  @State rivalExpense: number = this.PlanExpense - this.totalExpense

  //异步
  // aboutToAppear() {
  //   kvStoreUtils.init(getContext())  // 注入上下文
  //   kvStoreUtils.createKVStore()     // 创建存储实例
  //   this.onPageShow()
  //   this.refresh()
  // }
  //
  //
  async aboutToAppear() {
    kvStoreUtils.init(getContext())
    kvStoreUtils.createKVStore().then(async () => { // 添加Promise链式调用
      // this.onPageShow()
      this.getData(async (success: boolean, data: string) => {
        if (success && data) {
          console.log('获取到的数据:', data)
          this.listData = JSON.parse(data) as Bill[]
          console.log('解析后的listData:', this.listData)

        } else {
          this.listData = []
        }

      })

    }).catch((err: Error) => {
      console.error('KVStore初始化失败:', err)
    })
  }

  build() {
    Column({ space: 5 }) {
      //卡片展示
      this.CardPage()
      // 列表区域
      this.ListPage()
      // 底部按钮刷新数据
      this.ButtonPage()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
  }

  //卡片展示
  @Builder
  ButtonPage() {
    Row() {
      Button('刷新')
      .height('100%')
        .layoutWeight(1)
        .onClick(() => {
          console.log('在刷新页面')
          this.onPageShow()
          this.ComputeBill()
        })
        .backgroundColor('#FFE0A4')
    }
    .width(80)
    .height(50)
  }

  //列表展示记账信息
  @Builder
  ListPage() {
    List({ space: 10 }) {
      ForEach(this.listData, (item: Bill, index: number) => {
        ListItem() {
          Column() {
            Text('日期')
              .height('25')
            Row() {
              // 图标 - 使用图片而不是文字
              Column() {
                Image(this.getImageResource(item.imageName))
                  .width(30)
                  .height(30)

              }
              .width(40)
              .height(40)
              .backgroundColor('#FFE0A4')
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
              .borderRadius(90)

              // 信息
              Column({ space: 5 }) {
                Text(item.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                Text(item.text) // 显示记账类型文字
                  .fontSize(12)
                  .fontColor('#666')
              }
              .layoutWeight(1)
              .margin({ left: 10 })
              .padding({ left: 10 })
              .alignItems(HorizontalAlign.Start)

              //金额
              Text(item.isIncome ? '+' + item.price : '-' + item.price)
                .fontSize(20)
                .fontColor(item.isIncome ? '#fff8a402' : '#ffbe2727')
                .width(60)
                .layoutWeight(1)
                .height(30)
                .textAlign(TextAlign.Center)
              // 删除按钮
              Button('删除')
                .fontSize(12)
                .width(60)
                .height(30)
                .backgroundColor('#FFE0A4')
                .onClick(() => {
                  this.deleteItem(index)
                })
            }
            .width('100%')
            .layoutWeight(1)
            .padding(10)
            .backgroundColor(Color.White)
            .margin({ top: 2, bottom: 2 })
            .borderRadius(8)
          }
          .border({
            width: 2,
            color: '#ccc',
            radius: '30'
          })
          .height('100')
        }
      }, (item: Bill, index: number) => item.name + index)
    }
    .layoutWeight(1)
    .width('100%')
    .padding(10)

  }

  //卡片展示
  @Builder
  CardPage() {
    Column() {
      //顶部-返回-标题栏
      Top({ title: '账本' })
      // 收支统计卡片
      Column({ space: 8 }) {
        Text('本月预算  '+'1800'+'￥')
          .fontSize(18)
          .fontColor('#000')
          .margin({bottom:5})
        Text(`已消费  ${this.totalExpense}￥`)
          .fontSize(16)
          .fontColor('#ffbe2727')
        Text(`剩余额度  ${this.rivalExpense}￥`)
          .fontSize(16)
          .fontColor('#fff8a402')



        Button('记录')
          .width('60%')
          .height(35)
          .backgroundColor('#FFE0B2')
          .fontColor('#000')
          .borderRadius(20)
          .margin({ top: 10 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Two_KeepAccounts' })
          })
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#FFF')
      .borderRadius(10)
      .shadow({ radius: 3, color: '#00000010', offsetY: 2 })
    }
    .width('100%')
    .backgroundColor('#FFE0B2')
    .padding({ bottom: 20 })
  }

  //计算剩余额度
  // 修改后的计算方法
  ComputeBill() {
    let sum = 0;  // 创建临时累加变量
    this.listData.forEach((item: Bill) => {
      if (!item.isIncome) {
        sum += parseFloat(item.price.toString());  // 确保数值类型转换
      }
    });
    this.totalExpense = sum;  // 状态变量统一赋值
    this.rivalExpense = this.PlanExpense - this.totalExpense;  // 自动更新剩余额度
  }



  // 删除项目
  deleteItem(index: number) {
    let newList = [...this.listData]
    newList.splice(index, 1)
    this.listData = newList
    // 更新数据库
    let jsonStr = JSON.stringify(newList)
    kvStoreUtils.putData('keepAccountsKey', jsonStr)
  }

  //获得数据后解析
  onPageShow(): void {
    this.getData((success: boolean, data: string) => {
      if (success && data) {
        console.log('获取到的数据:', data)
        this.listData = JSON.parse(data) as Bill[]
        console.log('解析后的listData:', this.listData)
      } else {
        this.listData = []
      }
    })

  }

  //从kvStoreUtils中获得数据
  getData(result: (success: boolean, data: string) => void) {
    kvStoreUtils.getData('keepAccountsKey', (data: boolean | string | number | Uint8Array) => {
      if (data) {
        result(true, data as string)
        this.ComputeBill()
      } else {
        result(false, '')
      }
    }, (e: Error) => {
      result(false, '')
    })

  }

  // 根据imageName获取对应的图片资源
  getImageResource(imageName: string): Resource {
    switch (imageName) {
      case 'cy':
        return $r('app.media.cy')
      case 'gw':
        return $r('app.media.gw')
      case 'ryp':
        return $r('app.media.ryp')
      case 'jt':
        return $r('app.media.jt')
      case 'gz':
        return $r('app.media.gz')
      case 'jz':
        return $r('app.media.jz')
      case 'lc':
        return $r('app.media.lc')
      case 'qt':
        return $r('app.media.qt')
      default:
        return $r('app.media.qt') // 默认图标
    }
  }
}