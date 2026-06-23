// 账单查询页面 - 主色调 #FFE0A4
// 已移除底部导航栏，适配您自己的导航结构
// 优化按钮颜色与点击效果
import { promptAction } from '@kit.ArkUI';
import { kvStoreUtils } from '../common/KVStoreUtils';
import { TopBack } from '../components/top';
import { Bill } from './Two_KeepAccounts';

@Entry
@Component
export struct One {
  // 原始账单数据
  @State private bills: Bill[] = [];
  // 过滤后的账单数据
  @State private filteredBills: Bill[] = [];
  // 查询条件
  @State private startDate: string = '';
  @State private endDate: string = '';
  @State private selectedType: string = 'all'; // all, expense, income
  @State private minAmount: string = '';
  @State private maxAmount: string = '';
  @State private keyword: string = '';

  async aboutToAppear() {
    kvStoreUtils.init(getContext())
    kvStoreUtils.createKVStore().then(() => {
      console.log('KVStore初始化成功')
    }).catch((err: Error) => {
      console.error('KVStore初始化失败:', err)
    })
    this.getData(async (success: boolean, data: string) => {
      if (success && data) {
        console.log('获取到的数据:', data)
        this.bills = JSON.parse(data) as Bill[]
        this.filterBills();
      } else {
        console.log('no')
        this.bills = []
        this.filterBills();
      }
    })
  }

  //获得数据后解析
  onPageShow(): void {
    this.getData((success: boolean, data: string) => {
      if (success && data) {
        console.log('获取到的数据:', data)
        this.bills = JSON.parse(data) as Bill[]
        this.filterBills();
      } else {
        this.bills = []
        this.filterBills();
      }
    })
  }

  getData(result: (success: boolean, data: string) => void) {
    kvStoreUtils.getData('keepAccountsKey', (data: boolean | string | number | Uint8Array) => {
      if (data) {
        result(true, data as string)
      } else {
        result(false, '')
      }
    }, (e: Error) => {
      result(false, '')
    })
  }

  // 查询过滤逻辑 - 修正版
  filterBills() {
    let filtered = [...this.bills];

    // 日期范围过滤
    if (this.startDate && this.startDate !== '') {
      filtered = filtered.filter(item => item.date >= this.startDate);
    }
    if (this.endDate && this.endDate !== '') {
      filtered = filtered.filter(item => item.date <= this.endDate);
    }

    // 收支类型过滤 - 根据 isIncome 字段
    if (this.selectedType === 'expense') {
      filtered = filtered.filter(item => !item.isIncome);
    } else if (this.selectedType === 'income') {
      filtered = filtered.filter(item => item.isIncome);
    }

    // 金额区间过滤
    const min = this.minAmount !== '' ? parseFloat(this.minAmount) : null;
    const max = this.maxAmount !== '' ? parseFloat(this.maxAmount) : null;
    if (min !== null && !isNaN(min)) {
      filtered = filtered.filter(item => item.price >= min);
    }
    if (max !== null && !isNaN(max)) {
      filtered = filtered.filter(item => item.price <= max);
    }

    // 关键词过滤
    if (this.keyword && this.keyword.trim() !== '') {
      const kw = this.keyword.trim().toLowerCase();
      filtered = filtered.filter(item =>
      item.text.toLowerCase().includes(kw) ||
        (item.name && item.name.toLowerCase().includes(kw))
      );
    }

    this.filteredBills = [...filtered];
    console.log('过滤后数据条数:', this.filteredBills.length);
  }

  // 显示日期选择器
  showDatePicker(isStart: boolean) {
    let currentDate = new Date();
    if (isStart && this.startDate) {
      currentDate = new Date(this.startDate);
    } else if (!isStart && this.endDate) {
      currentDate = new Date(this.endDate);
    }

    DatePickerDialog.show({
      start: new Date('2000-1-1'),
      end: new Date('2099-12-31'),
      selected: currentDate,
      onAccept: (value: DatePickerResult) => {
        const year = value.year;
        const month = (value.month! + 1).toString().padStart(2, '0');
        const day = value.day!.toString().padStart(2, '0');
        const dateStr = `${year}-${month}-${day}`;
        if (isStart) {
          this.startDate = dateStr;
          if (this.endDate && this.endDate < this.startDate) {
            this.endDate = '';
          }
        } else {
          this.endDate = dateStr;
          if (this.startDate && this.endDate < this.startDate) {
            this.endDate = '';
            promptAction.showToast({ message: '结束日期不能早于开始日期' });
          }
        }
        this.filterBills();
      }
    });
  }

  // 重置所有查询条件
  resetFilters() {
    this.startDate = '';
    this.endDate = '';
    this.selectedType = 'all';
    this.minAmount = '';
    this.maxAmount = '';
    this.keyword = '';
    this.filterBills();
    promptAction.showToast({ message: '已重置查询条件' });
  }

  // 格式化金额
  formatAmount(item: Bill): string {
    if (item.isIncome) {
      return `+${item.price.toFixed(2)}`;
    } else {
      return `-${item.price.toFixed(2)}`;
    }
  }

  // 格式化日期 (yyyy-mm-dd -> yyyy.m.d)
  formatDate(dateStr: string): string {
    const parts = dateStr.split('-');
    if (parts.length === 3) {
      return `${parts[0]}.${parseInt(parts[1])}.${parseInt(parts[2])}`;
    }
    return dateStr;
  }

  // 获取金额颜色
  getAmountColor(item: Bill): ResourceColor {
    return item.isIncome ? '#4CAF50' : '#FF4D4F';
  }





  // 收支类型选择 - 优化样式
  @Builder
  buildIncomeExpenseType() {
    Column() {
      Text(' 收支类型')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#5C3B1F')
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      Row() {
        this.buildTypeButton('全部账单', 'all')
        this.buildTypeButton('支出', 'expense')
        this.buildTypeButton('收入', 'income')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .padding(16)
    .margin({ bottom: 12 })
  }

  @Builder
  buildTypeButton(label: string, type: string) {
    Button(label)
      .fontSize(14)
      .height(40)
      .layoutWeight(1)
      .backgroundColor(this.selectedType === type ? '#FF9907' : '#F5F0EA')
      .fontColor(this.selectedType === type ? '#FFFFFF' : '#5C3B1F')
      .borderRadius(20)
      .margin({ left: 4, right: 4 })
      .onClick(() => {
        this.selectedType = type;
        this.filterBills();
      })
  }

  // 金额区间卡片 - 优化布局
  @Builder
  buildAmountRange() {
    Column() {
      Column() {
        Text(' 收支类型')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#5C3B1F')
          .margin({ bottom: 12 })
          .alignSelf(ItemAlign.Start)

        Row() {
          // 开始日期
          Column() {

            Row() {
              Text(this.startDate || '请选择')
                .fontSize(14)
                .fontColor(this.startDate ? '#333333' : '#999999')
                .layoutWeight(1)
              Image($r('app.media.data_riqi'))
                .width(18)
                .height(18)
            }
            .width('100%')
            .height(40)
            .backgroundColor('#F5F0EA')
            .borderRadius(8)
            .padding({ left: 12, right: 8 })
            .onClick(() => this.showDatePicker(true))
          }
          .layoutWeight(1)

          Text('至')
            .fontSize(14)
            .fontColor('#5C3B1F')
            .margin({ left: 8, right: 8 })

          // 结束日期
          Column() {

            Row() {
              Text(this.endDate || '请选择')
                .fontSize(14)
                .fontColor(this.endDate ? '#333333' : '#999999')
                .layoutWeight(1)
              Image($r('app.media.data_riqi'))
                .width(18)
                .height(18)
            }
            .width('100%')
            .height(40)
            .backgroundColor('#F5F0EA')
            .borderRadius(8)
            .padding({ left: 12, right: 8 })
            .onClick(() => this.showDatePicker(false))
          }
          .layoutWeight(1)
        }
        .width('100%')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .margin({ bottom: 12 })
      Text(' 金额范围')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#5C3B1F')
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      Row() {
        TextInput({ placeholder: '最低金额', text: this.minAmount })
          .fontSize(14)
          .height(44)
          .layoutWeight(1)
          .backgroundColor('#F5F0EA')
          .borderRadius(12)
          .type(InputType.Number)
          .textAlign(TextAlign.Center)
          .onChange((value: string) => {
            this.minAmount = value;
            this.filterBills();
          })

        Text('-')
          .fontSize(18)
          .fontColor('#5C3B1F')
          .margin({ left: 12, right: 12 })

        TextInput({ placeholder: '最高金额', text: this.maxAmount })
          .fontSize(14)
          .height(44)
          .layoutWeight(1)
          .backgroundColor('#F5F0EA')
          .borderRadius(12)
          .type(InputType.Number)
          .textAlign(TextAlign.Center)
          .onChange((value: string) => {
            this.maxAmount = value;
            this.filterBills();
          })
      }
      .width('100%')

      Text('单位：元')
        .fontSize(11)
        .fontColor('#999999')
        .margin({ top: 8 })
        .alignSelf(ItemAlign.End)
      Text('关键词搜索')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#5C3B1F')
        .margin({ bottom: 12 })
        .alignSelf(ItemAlign.Start)

      TextInput({ placeholder: '搜索项目或备注', text: this.keyword })
        .fontSize(14)
        .height(44)
        .width('100%')
        .backgroundColor('#F5F0EA')
        .borderRadius(12)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.keyword = value;
          this.filterBills();
        })
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .padding(16)
    .margin({ bottom: 12 })
  }


  // 查询和重置按钮 - 优化
  @Builder
  buildQueryButton() {
    Row() {
      Button('查询')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .height(30)
        .layoutWeight(1)
        .backgroundColor('#FF9907')
        .fontColor('#FFFFFF')
        .borderRadius(24)
        .onClick(() => {
          this.filterBills();
          promptAction.showToast({ message: `找到 ${this.filteredBills.length} 条记录` });
        })

      Button('重置')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .height(30)
        .layoutWeight(1)
        .backgroundColor('#F5F0EA')
        .fontColor('#5C3B1F')
        .borderRadius(24)
        .margin({ left: 12 })
        .onClick(() => this.resetFilters())
    }
    .width('100%')
    .margin({ bottom: 20 })
  }

  // 表格表头 - 优化
  @Builder
  buildTableHeader() {
    Row() {
      Text('项目')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5C3B1F')
        .layoutWeight(1.5)
      Text('备注')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5C3B1F')
        .layoutWeight(1.5)
      Text('金额')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5C3B1F')
        .layoutWeight(1.2)
        .textAlign(TextAlign.End)
      Text('日期')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#5C3B1F')
        .layoutWeight(1.2)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 14, bottom: 10 })
    .borderRadius({ topLeft: 12, topRight: 12 })
    .backgroundColor('#FFF4E8')
  }

  // 账单列表 - 优化显示
  @Builder
  buildDataList() {
    Column() {
      if (this.filteredBills.length === 0) {
        Column() {
          Image($r('app.media.qt')) // 可以替换为合适的空状态图标
            .width(60)
            .height(60)
            .opacity(0.5)
            .margin({ bottom: 12 })
          Text('暂无账单记录')
            .fontSize(14)
            .fontColor('#999999')
          Text('试试调整筛选条件吧')
            .fontSize(12)
            .fontColor('#CCCCCC')
            .margin({ top: 4 })
        }
        .width('100%')
        .padding(40)
        .alignItems(HorizontalAlign.Center)
      } else {
        ForEach(this.filteredBills, (item: Bill, index: number) => {
          Column() {
            Row() {
              // 类型名称
              Text(item.name)
                .fontSize(15)
                .fontColor('#333333')
                .layoutWeight(1.5)
                .fontWeight(FontWeight.Medium)

              // 备注内容
              Text(item.text || '无备注')
                .fontSize(13)
                .fontColor('#666666')
                .layoutWeight(1.5)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              // 金额
              Text(this.formatAmount(item))
                .fontSize(16)
                .fontColor(this.getAmountColor(item))
                .layoutWeight(1.2)
                .textAlign(TextAlign.End)
                .fontWeight(FontWeight.Bold)

              // 日期
              Text(this.formatDate(item.date))
                .fontSize(12)
                .fontColor('#999999')
                .layoutWeight(1.2)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .padding({ left: 12, right: 12, top: 14, bottom: 14 })
          }
          .width('100%')
          .backgroundColor(index % 2 === 0 ? '#FFFFFF' : '#FFF9F0')
          .borderRadius(index === this.filteredBills.length - 1 ? { bottomLeft: 12, bottomRight: 12 } : 0)
        }, (item: Bill, index: number) => item.name + item.date + index)
      }
    }
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }

  // 统计条数 - 优化
  @Builder
  buildTotalCount() {
    Row() {
      Text(`共 ${this.filteredBills.length} 条记录`)
        .fontSize(13)
        .fontColor('#8B5A2B')

      Blank()

      if (this.filteredBills.length > 0) {
        Text(`总计: ${this.calculateTotal().toFixed(2)}元`)
          .fontSize(13)
          .fontColor('#E68A2E')
          .fontWeight(FontWeight.Medium)
      }
    }
    .width('100%')
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .backgroundColor('#FFF9F0')
    .borderRadius(20)
    .margin({ bottom: 20 })
  }

  // 计算总计金额
  calculateTotal(): number {
    let total = 0;
    this.filteredBills.forEach(item => {
      if (item.isIncome) {
        total += item.price;
      } else {
        total -= item.price;
      }
    });
    return total;
  }

  // 主界面
  build() {
    Column() {
      TopBack({ title: '查询' })

      Scroll() {
        Column() {
          this.buildIncomeExpenseType()
          this.buildAmountRange()
          this.buildQueryButton()
          this.buildTableHeader()
          this.buildDataList()
          this.buildTotalCount()
        }
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .backgroundColor('#FDF7EC')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FDF7EC')
  }
}