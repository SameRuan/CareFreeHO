import prompt from '@ohos.promptAction';
import router from '@ohos.router';
import picker from '@ohos.file.picker';
import { kvStoreUtils } from '../common/KVStoreUtils'; // 引入KVStore工具类
import { PublishData } from '../model/PublishData';
import { ArticleClass } from '../model/ArticleClass'; // 引入ArticleClass
import { TopBack } from '../components/TopBack';

@Entry
@Component
struct One_Post {
  // 内容状态
  @State titleInput: string = ''  // 标题框内的输入内容
  @State content: string = '请详细描述你要发布的内容……'  // 大框内的内容
  @State publishType: string = ''  // 发布类型右边的可输入内容
  @State publishTime: string = ''  // 发布时间右边的可输入内容
  @State publishLocation: string = ''  // 发布地点右边的可输入内容
  @State selectedImages: string[] = []

  // 用于强制UI更新的key
  @State inputKey: number = 0

  // 颜色定义
  private COLOR_BORDER = '#BBBBBB'  // 边框灰色
  private COLOR_TEXT_PRIMARY = '#333333'
  private COLOR_PLACEHOLDER = '#999999'
  private storeKey: string = 'publish_records';

  async aboutToAppear() {
    try {
      console.log('=== [Index] 开始初始化KVStore...');
      // 获取Context并初始化KVStore
      const context = getContext(this);
      kvStoreUtils.init(context);

      // 创建KVStore
      await kvStoreUtils.createKVStore();
      console.log('=== [Index] KVStore初始化成功');
      // 验证：读取所有历史记录
      await this.verifyKVStoreData();
    } catch (err) {
      console.error(`=== [Index] KVStore初始化失败: ${JSON.stringify(err)}`);
    }
  }

  // 验证KVStore数据的方法
  async verifyKVStoreData() {
    try {
      const data = await new Promise<string>((resolve, reject) => {
        kvStoreUtils.getData(this.storeKey,
          (data) => {
            if (typeof data === 'string') {
              resolve(data);
            } else {
              resolve('[]');
            }
          },
          (error) => {
            console.log(`=== [数据验证] 获取数据失败，可能首次使用`);
            resolve('[]');
          }
        );
      });

      const records: PublishData[] = JSON.parse(data || '[]');
      console.log(`=== [数据验证] 从KVStore读取到 ${records.length} 条历史记录`);

      if (records.length > 0) {
        // 打印所有记录
        records.forEach((record, index) => {
          console.log(`=== [记录${index + 1}] 标题: ${record.title}, 用户输入时间: ${record.publishTime}`);
        });

        // 提示用户
        prompt.showToast({
          message: `已加载${records.length}条历史记录`,
          duration: 2000
        });
      } else {
        console.log('=== [数据验证] 没有历史记录，首次使用');
      }
    } catch (e) {
      console.error('=== [数据验证] 验证失败:', e);
    }
  }

  build() {

    Column() {
      // 顶部导航栏
      TopBack({title:'发表帖子'})

      // 滚动内容区域
      Scroll() {
        Column({ space: 20 }) {
          // 标题框
          this.buildTitleBox()

          // 大的内容框 - 确保边框完整
          this.buildContentBox()

          // 发布选项区域
          this.buildPublishOptions()
        }
        .width('100%')
        .padding({ top: 20, bottom: 100 })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      // 发布按钮
      this.buildPublishButton()

      // 历史记录按钮
      this.buildHistoryButton()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 标题框
  @Builder
  buildTitleBox() {
    Row() {
      Text('标题')
        .fontSize(16)
        .fontColor(this.COLOR_TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ left: 16 })

      TextInput({
        text: this.titleInput,
        placeholder: '点击输入标题'
      })
        .layoutWeight(1)
        .height(40)
        .margin({ left: 10, right: 16 })
        .backgroundColor(Color.White)
        .fontSize(16)
        .fontColor(this.COLOR_TEXT_PRIMARY)
        .placeholderColor(this.COLOR_PLACEHOLDER)
        .onChange((value: string) => {
          this.titleInput = value
          console.log(`=== [标题输入] 内容: "${value}"`);
        })
    }
    .width('90%')
    .height(56)
    .backgroundColor(Color.White)
    .border({
      width: 1,
      color: this.COLOR_BORDER
    })
  }

  // 大的内容框
  @Builder
  buildContentBox() {
    Column() {
      // 内容输入区
      TextArea({
        text: this.content,
        placeholder: ''
      })
        .width('100%')
        .height(120)
        .padding({ left: 30, right: 16, top: 16, bottom: 16 })
        .backgroundColor(Color.White)
        .fontSize(16)
        .fontColor(this.content === '请详细描述你要发布的内容……' ? this.COLOR_PLACEHOLDER : this.COLOR_TEXT_PRIMARY)
        .onChange((value: string) => {
          this.content = value
          console.log(`=== [内容输入] 内容: "${value.substring(0, 50)}${value.length > 50 ? '...' : ''}"`);
        })
        .onClick(() => {
          if (this.content === '请详细描述你要发布的内容……') {
            this.content = ''
            console.log('=== [内容区域] 点击清空默认文本');
          }
        })

      // 上传图片区域
      Row() {
        Column() {
          if (this.selectedImages.length > 0) {
            Stack() {
              Image(this.selectedImages[0])
                .width(70)
                .height(70)
                .objectFit(ImageFit.Cover)

              Column() {
                Text('×')
                  .fontSize(14)
                  .fontColor(Color.White)
                  .backgroundColor(Color.Red)
                  .width(20)
                  .height(20)
                  .textAlign(TextAlign.Center)
              }
              .position({ x: 50, y: -5 })
              .onClick(() => {
                if (this.selectedImages.length > 0) {
                  this.selectedImages.splice(0, 1)
                  this.selectedImages = [...this.selectedImages]
                }
              })
            }
          } else {
            Column({ space: 5 }) {
              Text('+')
                .fontSize(24)
                .fontColor('#CCCCCC')
              Text('上传')
                .fontSize(12)
                .fontColor('#999999')
            }
            .width(90)
            .height(90)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .backgroundColor(Color.White)
            .border({
              width: 1,
              color: this.COLOR_BORDER,
              style: BorderStyle.Dashed
            })
          }
        }
        .onClick(() => {
          this.selectLocalImage()
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ left: 30, top: 0, bottom: 16 })
    }
    .width('90%')
    .backgroundColor(Color.White)
    .border({
      width: 1,
      color: this.COLOR_BORDER
    })
  }

  // 发布选项区域
  @Builder
  buildPublishOptions() {
    Column({ space: 12 }) {
      // 发布类型
      this.buildPublishOption('type', this.publishType, '发布类型')

      // 发布时间
      this.buildPublishOption('time', this.publishTime, '发布时间')

      // 发布地点
      this.buildPublishOption('location', this.publishLocation, '发布地点')
    }
    .width('90%')
  }

  // 单个发布选项
  @Builder
  buildPublishOption(type: string, value: string, label: string) {
    Row() {
      Column() {
        if (type === 'type') {
          Image($r('app.media.leixing'))
            .width(24)
            .height(24)
        } else if (type === 'time') {
          Image($r('app.media.time'))
            .width(24)
            .height(24)
        } else {
          Image($r('app.media.local'))
            .width(24)
            .height(24)
        }
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 16 })

      Text(label)
        .fontSize(16)
        .fontColor(this.COLOR_TEXT_PRIMARY)
        .margin({ left: 10 })
        .width(80)

      TextInput({
        text: value,
        placeholder: '点击输入'
      })
        .layoutWeight(1)
        .height(40)
        .margin({ left: 10, right: 16 })
        .backgroundColor(Color.White)
        .fontSize(16)
        .fontColor(this.COLOR_TEXT_PRIMARY)
        .placeholderColor(this.COLOR_PLACEHOLDER)
        .key(`${type}_${this.inputKey}`)
        .onChange((inputValue: string) => {
          console.log(`=== [${label}输入] 内容: "${inputValue}"`);
          this.updateOption(type, inputValue)
        })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .border({
      width: 1,
      color: this.COLOR_BORDER
    })
  }

  // 发布按钮
  @Builder
  buildPublishButton() {
    Column() {
      Button() {
        Text('发布')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
      }
      .width(200)
      .height(50)
      .backgroundColor('#FFE0A4')
      .borderRadius(35)
      .onClick(() => {
        console.log('=== [发布按钮] 点击发布按钮');
        this.onPublish()
      })
    }
    .width('100%')
    .height(100)
    .backgroundColor(Color.Transparent)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .position({ y: '100% - 100px' })
  }

  // 历史记录查看按钮
  @Builder
  buildHistoryButton() {
    Column() {
      Button() {
        Text('查看历史记录')
          .fontSize(14)
          .fontColor(Color.White)
      }
      .width(120)
      .height(36)
      .backgroundColor('#4CAF50')
      .borderRadius(18)
      .onClick(() => {
        this.viewHistoryRecords()
      })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 更新选项值
  updateOption(type: string, value: string) {
    console.log(`=== [更新选项] type: ${type}, value: "${value}"`);
    if (type === 'type') {
      this.publishType = value
    } else if (type === 'time') {
      this.publishTime = value
    } else if (type === 'location') {
      this.publishLocation = value
    }
  }

  // 选择本地图片
  async selectLocalImage() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions()
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.maxSelectNumber = 1

      const photoPicker = new picker.PhotoViewPicker()
      const photoSelectResult = await photoPicker.select(photoSelectOptions)
      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        const imageUri = photoSelectResult.photoUris[0]
        console.log('[Index] 选择的图片URI:', imageUri);
        this.selectedImages.push(imageUri)
        this.selectedImages = [...this.selectedImages]

        prompt.showToast({
          message: '图片选择成功',
          duration: 2000
        })
      }
    } catch (err) {
      console.error('选择图片失败:', err)
      prompt.showToast({
        message: '选择图片失败',
        duration: 2000
      })
    }
  }

  // 保存数据到KVStore
  async saveDataToKVStore(publishData: PublishData): Promise<boolean> {
    try {
      console.log('=== [数据保存] 开始保存数据到KVStore...');

      const existingData = await this.getAllRecords();
      console.log(`=== [数据保存] 现有记录数: ${existingData.length}`);

      const dataWithTimestamp: PublishData = {
        title: publishData.title,
        content: publishData.content,
        publishType: publishData.publishType,
        publishTime: publishData.publishTime,
        publishLocation: publishData.publishLocation,
        images: publishData.images,
        timestamp: Date.now()
      };

      existingData.push(dataWithTimestamp);
      const recordsJson = JSON.stringify(existingData);
      await kvStoreUtils.putData(this.storeKey, recordsJson);

      console.log('=== [数据保存] 数据保存成功');
      return true;
    } catch (err) {
      console.error(`=== [数据保存] 保存数据失败: ${JSON.stringify(err)}`);
      return false;
    }
  }

  // 将PublishData转换为ArticleClass
  private convertToArticleClass(publishData: PublishData): ArticleClass {
    // 生成唯一的ID（使用时间戳）
    const id = `article_${Date.now()}`;

    // 处理图片：确保至少有一张图片
    let imageSrc: ResourceStr = '';
    let imageSrc1: ResourceStr | undefined = undefined;
    let imageSrc2: ResourceStr | undefined = undefined;

    if (publishData.images.length > 0) {
      // 第一张图片作为imageSrc（必须的）
      imageSrc = publishData.images[0] as ResourceStr;

      // 如果有第二张图片，作为imageSrc1
      if (publishData.images.length > 1) {
        imageSrc1 = publishData.images[1] as ResourceStr;
      }

      // 如果有第三张图片，作为imageSrc2
      if (publishData.images.length > 2) {
        imageSrc2 = publishData.images[2] as ResourceStr;
      }
    } else {
      // 如果没有上传图片，使用默认图片
      imageSrc = $r('app.media.beijing'); // 确保有这个资源
    }

    // 创建ArticleClass实例
    const article = new ArticleClass(
      id,
      publishData.title,
      publishData.content, // content作为brief
      imageSrc,
      imageSrc1,
      imageSrc2
    );

    // 可选：设置时间戳
    article.timestamp = Date.now();

    // 可选：将发布类型等信息可以存储在brief中或添加额外字段
    // 如果需要，可以修改brief包含更多信息
    // article.brief = `${publishData.publishType ? `【${publishData.publishType}】` : ''}${publishData.content}`;

    return article;
  }

  // 获取所有记录
  async getAllRecords(): Promise<PublishData[]> {
    try {
      const data = await new Promise<string>((resolve, reject) => {
        kvStoreUtils.getData(this.storeKey,
          (data) => {
            if (typeof data === 'string' && data.trim() !== '') {
              resolve(data);
            } else {
              resolve('[]');
            }
          },
          (error) => {
            console.log(`=== [数据获取] 获取数据失败，返回空数组`);
            resolve('[]');
          }
        );
      });

      if (data && data.trim() !== '' && data !== '[]') {
        try {
          return JSON.parse(data);
        } catch (e) {
          console.error(`=== [数据解析] 解析JSON失败: ${e.message}`);
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      console.error(`=== [数据获取] 获取记录失败: ${e.message}`);
      return [];
    }
  }

  // 查看历史记录
  async viewHistoryRecords() {
    try {
      const records = await this.getAllRecords();

      if (records.length === 0) {
        prompt.showToast({
          message: '暂无历史记录',
          duration: 2000
        });
        return;
      }

      let historyText = `共 ${records.length} 条记录\n\n`;
      records.forEach((record, index) => {
        const systemTimeStr = record.timestamp ? new Date(record.timestamp).toLocaleString() : '未知时间';
        historyText += `记录 ${index + 1}:\n`;
        historyText += `  标题：${record.title}\n`;
        historyText += `  内容：${record.content.substring(0, 30)}${record.content.length > 30 ? '...' : ''}\n`;
        historyText += `  发布类型：${record.publishType}\n`;
        historyText += `  发布时间(用户输入)：${record.publishTime}\n`;
        historyText += `  发布地点：${record.publishLocation}\n`;
        historyText += `  系统记录时间：${systemTimeStr}\n\n`;
      });

      prompt.showDialog({
        title: '历史发布记录',
        message: historyText,
        buttons: [{ text: '确定', color: '#000000' }]
      });

      console.log('=== [历史记录] 所有记录:', records);
    } catch (e) {
      console.error('=== [历史记录] 读取失败:', e);
    }
  }

  // 发布操作 - 修改后的方法
  async onPublish() {
    console.log('=== [发布流程] ====== 开始发布流程 ======');
    console.log(`=== [发布流程] 标题: "${this.titleInput}"`);
    console.log(`=== [发布流程] 内容: "${this.content}"`);
    console.log(`=== [发布流程] 类型: "${this.publishType}"`);
    console.log(`=== [发布流程] 时间(用户输入): "${this.publishTime}"`);
    console.log(`=== [发布流程] 地点: "${this.publishLocation}"`);
    console.log(`=== [发布流程] 图片数量: ${this.selectedImages.length}`);

    // 验证标题
    if (!this.titleInput || this.titleInput.trim() === '') {
      console.log('=== [发布验证] 发布失败：标题为空');
      prompt.showToast({
        message: '请输入标题',
        duration: 2000
      })
      return
    }

    // 验证内容
    if (!this.content || this.content.trim() === '' || this.content === '请详细描述你要发布的内容……') {
      console.log('=== [发布验证] 发布失败：内容为空');
      prompt.showToast({
        message: '请输入详细内容',
        duration: 2000
      })
      return
    }

    console.log('=== [发布验证] 表单验证通过');

    // 构建发布数据
    const publishData: PublishData = {
      title: this.titleInput,
      content: this.content,
      publishType: this.publishType,
      publishTime: this.publishTime,
      publishLocation: this.publishLocation,
      images: this.selectedImages
    }

    console.log('=== [数据构建] 构建发布数据完成');

    // 转换为ArticleClass
    const articleData = this.convertToArticleClass(publishData);
    console.log('=== [数据转换] 转换为ArticleClass完成:', articleData);

    // 保存到KVStore
    const saveSuccess = await this.saveDataToKVStore(publishData);

    if (saveSuccess) {
      console.log('=== [发布结果] 发布成功！');

      // 导航到文章详情页面，传递ArticleClass数据
      router.pushUrl({
        url: 'pages/One_ArticleDetail', // 根据你的实际页面路径调整
        params: {
          articleData: JSON.stringify(articleData)
        }
      }).then(() => {
        console.log('=== [页面跳转] 成功跳转到文章详情页面');
      }).catch((err:Error) => {
        console.error('=== [页面跳转] 跳转失败:', err);
      });

      // 清空表单
      this.clearForm();
    } else {
      console.error('=== [发布结果] 发布失败：保存数据失败');
      prompt.showToast({
        message: '发布失败，请重试',
        duration: 2000
      })
    }
  }

  // 清空表单
  clearForm() {
    console.log('=== [表单重置] ====== 开始重置表单 ======');

    this.titleInput = '';
    this.content = '请详细描述你要发布的内容……';
    this.publishType = '';
    this.publishTime = '';
    this.publishLocation = '';
    this.selectedImages = [];

    this.inputKey += 1;

    console.log('=== [表单重置] 表单重置完成');
  }
}