import router from '@ohos.router';
import { PromptAction, promptAction } from '@kit.ArkUI';
import { BannerClass } from '../model/BannerClass';
import { ArticleClass } from '../model/ArticleClass';
import { Top } from '../components/Top';
import { kvStoreUtils } from '../common/KVStoreUtils';
import { PublishRecord } from '../model/PublishRecord';


@Entry
@Component
export struct Index1_Plog {
  build() {
    Stack() {
      this.Tou()
      Button('发帖子')
        .backgroundColor('#c9f8b754')
        .width('110')
        .height('40')
        .position({ x: '230.00', y: '600.00' })
        .onClick(() => {
          console.log('跳转发帖页面')
          router.pushUrl({
            url: 'pages/One_Post',
          })
        })
        .opacity(1)
    }
  }

  @Builder
  Tou() {
    Column() {
      Top({ title: '首页' })  // 顶部导航组件
      Banner()                // 轮播图组件
      Scroll() {
        Column() {
          TutorialView()      // 主要内容区域组件
        }
        .padding({ bottom: 20 })
      }
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.PARENT_FIRST
      })
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
    }
    .backgroundColor('#FFE0A4')
    .width('100%')
    .height('100%')
  }
}

// 轮播图组件
@Component
struct Banner {
  @State bannerList: Array<BannerClass> = [
    new BannerClass('pic0', $r('app.media.Banner1')),
    new BannerClass('pic1', $r('app.media.Banner2'))
  ];
  @State currentIndex: number = 0;  // 当前显示的轮播图索引

  build() {
    Column() {
      Swiper() {
        ForEach(this.bannerList, (item: BannerClass, index: number) => {
          Image(item.imageSrc)
            .objectFit(ImageFit.Cover)
            .width('100%')
            .height(162)
            .padding({ top: 11, left: 16, right: 16 })
            .borderRadius(16)
            .shadow({
              radius: 8,
              color: '#1a000000',
              offsetX: 0,
              offsetY: 2
            })
        }, (item: BannerClass, index: number) => item.id)
      }
      .autoPlay(true)        // 自动播放
      .loop(true)           // 循环播放
      .interval(3000)       // 间隔3秒
      .duration(500)        // 切换动画时长500ms
      .onChange((index: number) => {
        this.currentIndex = index;  // 更新当前索引
      })
    }
    .width('100%')
    .height(165)
    .margin({ bottom: 8 })
  }
}

// 滑动删除列表项组件
@Component
struct SwipeDeleteItem {
  // 帖子数据，从父组件传递
  @Prop tutorialItem: ArticleClass;
  // 帖子列表，双向绑定，用于删除操作
  @Link tutorialList: Array<ArticleClass>;
  // 是否为用户发布的数据（true：用户发布，false：默认数据），从父组件传递
  @Prop isPublishedData: boolean;

  // 是否正在滑动状态
  @State isSwiping: boolean = false;
  // 横向滑动偏移量
  @State offsetX: number = 0;

  // 最大滑动距离（负值表示向左滑动）
  private maxSwipeDistance: number = -160;
  // 删除阈值，滑动超过这个距离触发删除
  private deleteThreshold: number = -120;

  build() {
    Stack() {
      // 删除按钮背景（隐藏在内容后面）
      Row() {
        Column() {
          Text('🗑️')  // 删除图标（使用emoji）
            .fontSize(24)
            .margin({ right: 16 })
          Text('删除')
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ right: 16 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)  // 右侧对齐
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#ffd27874')  // 红色背景
      .borderRadius(12)
      // 根据滑动距离计算透明度（滑动越多，删除按钮越明显）
      .opacity(Math.min(Math.abs(this.offsetX) / Math.abs(this.maxSwipeDistance), 1))

      // 主内容区域（可以滑动）
      Row({ space: 4 }) {
        // 帖子图片
        Image(this.tutorialItem.imageSrc)
          .height(90)
          .width(90)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)
          .backgroundColor('#F5F5F5')  // 默认背景色

        // 帖子文字内容区域
        Column() {
          // 帖子标题
          Text(this.tutorialItem.title)
            .height(28)
            .width('100%')
            .fontSize(18)
            .textAlign(TextAlign.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontWeight(500)
            .margin({ top: 6, bottom: 1, left: 5 })
            .fontColor('#182431')

          // 帖子简介
          Text(this.tutorialItem.brief)
            .padding({
              left: '15',
              right: '15'
            })
            .layoutWeight(1)
            .width('100%')
            .fontSize(15)
            .textAlign(TextAlign.JUSTIFY)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(2)
            .fontWeight(400)
            .fontColor('rgba(0, 0, 0, 0.6)')
            .lineHeight(18)
            .margin({ top: 2 })
        }
        .height('100%')
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ right: 4 })
      }
      .width('100%')
      .height(110)
      .borderRadius(12)
      .backgroundColor(Color.White)
      .padding(8)
      .shadow({
        radius: 4,
        color: 'rgba(0, 0, 0, 0.04)',
        offsetX: 0,
        offsetY: 2
      })
      .translate({ x: this.offsetX })  // 应用滑动偏移

      // 滑动手势处理
      .gesture(
        PanGesture({ direction: PanDirection.Horizontal })  // 只检测水平滑动
          .onActionStart(() => {
            this.isSwiping = true;  // 开始滑动
          })
          .onActionUpdate((event: GestureEvent) => {
            // 只允许向左滑动（offsetX为负值）
            if (event.offsetX < 0) {
              // 限制最大滑动距离
              this.offsetX = Math.max(event.offsetX, this.maxSwipeDistance);
            }
          })
          .onActionEnd(() => {
            this.isSwiping = false;  // 滑动结束
            // 如果滑动距离超过删除阈值，执行删除
            if (this.offsetX <= this.deleteThreshold) {
              this.deleteItem();
            } else {
              // 否则回弹到原位
              this.offsetX = 0;
            }
          })
          .onActionCancel(() => {
            this.isSwiping = false;  // 手势取消
            this.offsetX = 0;       // 回到原位
          })
      )

      // 点击事件（跳转到详情页）
      .onClick(() => {
        // 如果不在滑动状态且没有滑动偏移，才触发点击
        if (!this.isSwiping && this.offsetX === 0) {
          console.log('跳转详情页面')
          router.pushUrl({
            url: 'pages/One_ArticleDetail',
            params: {
              articleData: JSON.stringify(this.tutorialItem)
            }
          })
        }
      })
    }
    .width('100%')
    .height(110)
    .clip(true)  // 裁剪超出部分，使删除按钮隐藏
  }

  // 删除帖子方法
  private async deleteItem(): Promise<void> {
    // 在列表中查找要删除的帖子的索引
    const index = this.tutorialList.findIndex(item => item.id === this.tutorialItem.id);
    if (index !== -1) {
      // 先滑动到最左边，显示删除动画
      this.offsetX = this.maxSwipeDistance;

      // 如果是用户发布的数据，从KVStore中删除
      if (this.isPublishedData && this.tutorialItem.id.startsWith('article_')) {
        await this.deleteFromKVStore();
      }

      // 延迟300ms执行删除，让用户看到删除动画
      setTimeout(() => {
        // 从列表中删除该帖子
        this.tutorialList.splice(index, 1);
        // 更新列表触发UI刷新
        this.tutorialList = [...this.tutorialList];

        // 显示删除成功提示
        promptAction.showToast({
          message: '帖子已删除',
          duration: 2000
        });

        console.log(`删除帖子: ${this.tutorialItem.title}`);
      }, 300);
    }
  }

  // 从KVStore中删除数据
  private async deleteFromKVStore(): Promise<void> {
    try {
      // 从KVStore读取所有发布记录
      const data = await new Promise<string>((resolve, reject) => {
        kvStoreUtils.getData('publish_records',
          (data) => {
            if (typeof data === 'string' && data.trim() !== '') {
              resolve(data);
            } else {
              resolve('[]');
            }
          },
          (error) => {
            console.log(`[删除] 获取KVStore数据失败`);
            resolve('[]');
          }
        );
      });

      if (data && data.trim() !== '' && data !== '[]') {
        const publishRecords: PublishRecord[] = JSON.parse(data);

        // 从帖子ID中提取时间戳（ID格式：article_时间戳）
        const timestamp = this.tutorialItem.timestamp ||
        parseInt(this.tutorialItem.id.replace('article_', ''));

        // 过滤掉要删除的记录（通过时间戳匹配）
        const filteredRecords: PublishRecord[] = publishRecords.filter((record: PublishRecord) => {
          const recordTimestamp: number = record.timestamp || 0;
          return recordTimestamp !== timestamp;  // 保留时间戳不匹配的记录
        });

        console.log(`[删除] 删除前: ${publishRecords.length}条, 删除后: ${filteredRecords.length}条`);

        // 如果数据有变化，保存回KVStore
        if (filteredRecords.length !== publishRecords.length) {
          const recordsJson = JSON.stringify(filteredRecords);
          await kvStoreUtils.putData('publish_records', recordsJson);
          console.log(`[删除] 已从KVStore删除记录`);
        }
      }
    } catch (e) {
      console.error(`[删除] 从KVStore删除失败: ${e.message}`);
    }
  }
}

// 主要内容区域组件（包含两个Tab页签）
@Component
struct TutorialView {
  uiContext: UIContext = this.getUIContext();
  promptAction: PromptAction = this.uiContext.getPromptAction();

  // 当前选中的Tab页签（0：校园帖子，1：我的）
  @State currentTab: number = 0;

  // 校园帖子列表（默认数据 + 用户发布的数据）
  @State tutorialList: Array<ArticleClass> = [
    // 默认的示例帖子数据
    new ArticleClass('1', '寻人启事：图书馆考研同学', '周一在图书馆三楼遇到的考研同学！你落下的数学复习资料在我这里，上面还有可爱的笔记贴纸📚✨ 看到请联系我呀～(๑•̀ㅂ•́)و✧', $r('app.media.Banner1'), $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('2', '表白：食堂白衬衫男生', '食堂三楼那个穿白衬衫的男生！你的笑容像阳光一样温暖☀️ 每次看到你都感觉一整天都变美好了！想认识你很久啦～(⁄ ⁄•⁄ω⁄•⁄ ⁄)', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('3', '失物招领：iPhone手机', '捡到一部黑色iPhone 13！机主一定很着急吧(；д；) 壳子是小猫图案的超可爱！请描述锁屏壁纸来领取哦～🐱', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('4', '寻物启事：高等数学书', '呜呜我的高数书丢了！里面有整整一学期的笔记啊！(╥﹏╥) 封面是蓝色的，边角有点磨损，捡到的好心人请联系我！请你喝奶茶！🥤', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('5', '表白：篮球场短发女生', '上周五在篮球场打球的短发女生！你投篮的样子太帅了吧！⚡️ 可以加个微信一起打球吗？(๑´ㅂ`๑)', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('6', '失物招领：校园卡', '捡到一张校园卡！照片上的你笑得好甜呀～☺️ 请速联系我领取，别耽误吃饭刷卡啦！(っ˘ڡ˘ς)', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('7', '寻人启事：英语角朋友', '英语角认识的美国小姐姐！和你聊天超开心！想继续练口语可以吗？👩‍🎓 我的口语需要拯救...救救孩子！(｡•́︿•̀｡)', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('8', '表白：图书馆自习姑娘', '图书馆靠窗位置的姑娘！你认真学习的样子好迷人！📖 每次看到你都忍不住多看几眼...可以认识一下吗？(◍•ᴗ•◍)❤', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('9', '寻物启事：黑色书包', '救命！我的书包不见了！里面有笔记本、充电宝和明天要交的作业！😱 黑色耐克双肩包，上面挂着小黄鸭挂件🦆 找到必有重谢！', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('10', '失物招领：钥匙串', '捡到一串钥匙！蓝色的小熊钥匙扣好可爱！🐻 失主一定很着急吧，门都进不去了(＞人＜;) 快来认领呀！', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('11', '寻人启事：指路同学', '昨天在教学楼帮我指路的同学！你真的好温柔啊！(´▽`ʃ♡ƪ) 想正式道谢并请你喝奶茶！可以给我个机会吗？', $r('app.media.Banner1'), $r('app.media.Banner1')),
    new ArticleClass('12', '表白：合唱团领唱', '合唱团的领唱小姐姐！你的声音是天籁吧！🎤 每次排练都忍不住听入迷了...可以加个微信交流音乐吗？🎵', $r('app.media.Banner1'), $r('app.media.Banner1')),
  ];

  // "我的"帖子列表（默认数据 + 用户发布的数据）
  @State myList: Array<ArticleClass> = [
    // 默认的"我的"页面示例数据
    new ArticleClass('1', '寻物启事：考研资料', '我的考研笔记啊！上面全是重点和错题整理！(;´༎ຶД༎ຶ`) 粉色活页本，里面夹着彩虹标签页🌈 捡到的好心人请联系！请你吃一个月早餐！', $r('app.media.Banner1'), $r('app.media.Banner1'), $r('app.media.Banner1')),
   ];

  // 用户发布的数据ID数组（用于识别哪些是用户发布的数据）
  @State publishedDataIds: string[] = [];

  // KVStore存储的键名
  private storeKey: string = 'publish_records';

  // 组件生命周期：当组件即将显示时调用
  aboutToAppear() {
    this.loadPublishedArticles();  // 加载用户发布的文章
  }

  build() {
    Column() {
      // Tab切换栏
      Row({ space: 0 }) {
        // "校园帖子"Tab
        Column() {
          Text('校园帖子')
            .fontSize(16)
            .fontColor(this.currentTab === 0 ? '#FFC759' : '#fff')
            .fontWeight(this.currentTab === 0 ? 600 : 400)
            .padding({ bottom: 8 })

          // 当前选中时显示下划线
          if (this.currentTab === 0) {
            Divider()
              .color('#FFC759')
              .strokeWidth(2)
              .width(24)
          }
        }
        .layoutWeight(1)
        .height(25)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.currentTab = 0  // 切换到"校园帖子"Tab
        })

        // "我的"Tab
        Column() {
          Text('我发布的')
            .fontSize(16)
            .fontColor(this.currentTab === 1 ? '#FFC759' : '#fff')
            .fontWeight(this.currentTab === 1 ? 600 : 400)
            .padding({ bottom: 8 })

          // 当前选中时显示下划线
          if (this.currentTab === 1) {
            Divider()
              .color('#FFC759')
              .strokeWidth(2)
              .width(24)
          }
        }
        .layoutWeight(1)
        .height(25)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => {
          this.currentTab = 1  // 切换到"我的"Tab
        })

        // 刷新按钮
        Row() {
          Image($r('app.media.refresh_'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
            .opacity(0.5)
        }
        .width(150)
        .height(30)
        .justifyContent(FlexAlign.End)
        .margin({ right: 16, bottom: 8 })
        .onClick(() => {
          this.handleRefresh()  // 点击刷新

        })
      }
      .width('100%')
      .height(50)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // Tab内容区域
      if (this.currentTab === 0) {
        // "校园帖子"列表
        List({ space: 15 }) {
          ForEach(this.tutorialList, (item: ArticleClass) => {
            ListItem() {
              // 使用滑动删除组件，传递相关参数
              SwipeDeleteItem({
                tutorialItem: item,
                tutorialList: $tutorialList,
                // 检查是否为用户发布的数据
                isPublishedData: this.publishedDataIds.includes(item.id)
              })
            }
          }, (item: ArticleClass) => item.id)
        }
        .scrollBar(BarState.Off)
        .padding({ left: 10, right: 10 })
        .layoutWeight(1)
        .width('100%')
        .alignListItem(ListItemAlign.Center)
      } else {
        // "我的"列表区域
        Column() {
          List({ space: 15 }) {
            ForEach(this.myList, (item: ArticleClass) => {
              ListItem() {
                // 使用滑动删除组件，传递相关参数
                // 注意："我的"列表中的用户发布数据也需要识别
                SwipeDeleteItem({
                  tutorialItem: item,
                  tutorialList: $myList,
                  // "我的"列表中的用户发布数据也需要从KVStore删除
                  isPublishedData: this.publishedDataIds.includes(item.id)
                })
              }
            }, (item: ArticleClass) => item.id)
          }
          .scrollBar(BarState.Off)
          .padding({ left: 10, right: 10 })
          .layoutWeight(1)
          .width('100%')
          .alignListItem(ListItemAlign.Center)
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
  }

  // 加载用户发布的文章
  private async loadPublishedArticles(): Promise<void> {
    try {
      // 从KVStore读取发布记录
      const data = await new Promise<string>((resolve, reject) => {
        kvStoreUtils.getData(this.storeKey,
          (data) => {
            // 增加严格类型检查与JSON预解析
            if (typeof data === 'string' && data.trim() !== '') {
              try {
                JSON.parse(data); // 验证数据有效性
                resolve(data);
              } catch (e) {
                console.error("=== [数据解析异常] 非标准JSON格式，返回空数组");
                resolve('[]');
              }
            } else {
              resolve('[]'); // 处理非字符串或空数据
            }
          },
          (error) => {
            console.error("=== [KVStore异常] 错误详情:", error);
            resolve('[]');
          }
        );
      });

      if (data && data.trim() !== '' && data !== '[]') {
        try {
          const publishRecords: PublishRecord[] = JSON.parse(data);
          console.log(`=== [加载发布文章] 读取到 ${publishRecords.length} 条发布记录`);

          // 清空之前记录的发布数据ID
          this.publishedDataIds = [];

          // 遍历每条发布记录
          publishRecords.forEach((record: PublishRecord) => {
            // 转换为ArticleClass格式
            const article = this.convertPublishDataToArticle(record);
            if (article) {
              // 记录这是用户发布的数据
              this.publishedDataIds.push(article.id);

              // 检查是否已经存在于"校园帖子"列表中，避免重复添加
              const existingIndexInTutorial = this.tutorialList.findIndex(item => item.id === article.id);
              if (existingIndexInTutorial === -1) {
                // 添加到"校园帖子"列表的最前面（最新发布的在最前面）
                this.tutorialList.unshift(article);
              }

              // 同时添加到"我的"列表中
              const existingIndexInMyList = this.myList.findIndex(item => item.id === article.id);
              if (existingIndexInMyList === -1) {
                // 添加到"我的"列表的最前面
                this.myList.unshift(article);
              }
            }
          });

          // 更新列表触发UI刷新
          this.tutorialList = [...this.tutorialList];
          this.myList = [...this.myList];

          console.log(`=== [加载发布文章] 当前校园帖子数: ${this.tutorialList.length}`);
          console.log(`=== [加载发布文章] 当前我的帖子数: ${this.myList.length}`);
          console.log(`=== [发布数据ID]`, this.publishedDataIds);

        } catch (e) {
          console.error(`=== [加载发布文章] 解析JSON失败: ${e.message}`);
        }
      }
    } catch (e) {
      console.error(`=== [加载发布文章] 加载失败: ${e.message}`);
    }
  }

  // 将PublishRecord转换为ArticleClass
  private convertPublishDataToArticle(publishData: PublishRecord): ArticleClass | null {
    try {
      // 使用时间戳作为唯一ID
      const timestamp = publishData.timestamp || Date.now();
      const id = `article_${timestamp}`;

      // 处理图片数据
      let imageSrc: ResourceStr = '';
      let imageSrc1: ResourceStr | undefined = undefined;
      let imageSrc2: ResourceStr | undefined = undefined;

      if (publishData.images && publishData.images.length > 0) {
        // 将string类型的URL转换为ResourceStr类型
        imageSrc = publishData.images[0] as string as ResourceStr;

        // 如果有第二张图片
        if (publishData.images.length > 1) {
          imageSrc1 = publishData.images[1] as string as ResourceStr;
        }

        // 如果有第三张图片
        if (publishData.images.length > 2) {
          imageSrc2 = publishData.images[2] as string as ResourceStr;
        }
      } else {
        // 如果没有上传图片，使用默认图片
        imageSrc = $r('app.media.Banner1');
      }

      // 创建ArticleClass实例
      const article = new ArticleClass(
        id,
        publishData.title || '无标题',
        publishData.content || '无内容',
        imageSrc,
        imageSrc1,
        imageSrc2
      );

      // 设置时间戳
      article.timestamp = timestamp;

      return article;
    } catch (e) {
      console.error(`=== [数据转换] 转换失败: ${e.message}`);
      return null;
    }
  }


  // 在 TutorialView 组件构造函数或 aboutToAppear 中绑定
  private handleRefresh = async (): Promise<void> => {
    try {
      await this.loadPublishedArticles();
      promptAction.showToast({ message: '刷新完成', duration: 2000 });
    } catch (error) {
      console.error("刷新异常:", error);
    }
    // 延迟1秒显示刷新完成提示
    // setTimeout(() => {
    //   this.promptAction.openToast({
    //     message: '刷新完成',
    //     duration: 2000,
    //   });
    // }, 1000);
  }
}