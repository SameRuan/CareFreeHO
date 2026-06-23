import { CircleShape, LengthMetrics, router } from '@kit.ArkUI';
import { TopBack } from '../components/TopBack';
import { ArticleClass } from '../model/ArticleClass';
import { CommentClass } from '../model/CommentClass';
/**
 * 文章详情页面页面-展示帖子信息
 */
@Entry
@Component
export  struct One_ArticleDetail {
  // @State showList: ArticleClass = new ArticleClass();
  @State showList: ArticleClass = new ArticleClass('1',
    '标题', '帖子详情', $r('app.media.Banner1'),
    $r('app.media.Banner2'), $r('app.media.Banner1'))
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params?.articleData) {
      try {
        const rawData:ArticleClass = JSON.parse(params.articleData);//接受params中的articleData
        this.showList = new ArticleClass(
          rawData.id,
          rawData.title,
          rawData.brief,
          rawData.imageSrc,
          rawData.imageSrc1,
          rawData.imageSrc2
        );
      } catch (e) {
        console.error('参数解析失败:', e);
      }
    }
  }


  // @State showList: ArticleClass = new ArticleClass('1', $r('app.media.Banner1'),
  //   '掉了一部手机', '在图书馆遗失一部黑色iPhone手机，如有拾到请联系我，必有重谢！')

  // @State showList: ArticleClass = new ArticleClass('1', $r('app.media.Banner1'),
  //   '掉了一部手机', '在图书馆遗失一部黑色iPhone手机，如有拾到请联系我，必有重谢！',
  //   $r('app.media.Banner2'))
  @State lovetouch: boolean = true;
  @State message: string = '详情';
  @State type: string = '帖子类型';
  @State CommentList: Array<CommentClass> = [
    new CommentClass('评论用户1',  '6666！','1',$r('app.media.test1')),
    new CommentClass('评论用户2',  '想对那个每天在食堂三楼穿白衬衫的男生说，你的笑容真的很好看','2',$r('app.media.test1')),
    new CommentClass('评论用户3',  '在操场捡到一串钥匙，上面有哆啦A梦挂件，失主请速联系','3',$r('app.media.test2')),

  ];
  @State isExpanded: boolean = false;



  build() {
    Column({space:8}){
      //顶部-返回-标题栏
      Row(){
        //图标
        Image($r('app.media.back'))
          .width('38')
          .height('38')
          .onClick(()=>{
            router.back({
              url:'pages/Index'
            })
          })
        Text('发帖页面')
          .layoutWeight(1)
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({
            right:'38'
          })
      }
      .backgroundColor('#75ffc759')
      .height('70')
      .width('100%')
      .border({
        width:{bottom:2},
        color:{bottom: '#75ffab04' }
      })

      //评论区
      Scroll(){
        Column() {
          //展示部分`${this.showList.brief}`
          Column({space:6}){
            Text(`【${this.type}】${this.showList.title}`)
              .width('100%')
              .height('')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize('20')
            // Text(`${this.showList.brief}`)
            //   .animation({ duration: 200, curve: Curve.EaseInOut })
            //   .maxLines(this.isExpanded ? undefined : 3) // 动态控制行数
            //   .textOverflow({
            //     overflow: this.isExpanded ? TextOverflow.None : TextOverflow.Ellipsis
            //   })
            //   .onClick(() => {
            //     this.isExpanded = !this.isExpanded; // 点击切换状态
            //   })
            //   .width('100%')
            //   .height(this.isExpanded ? 'auto' : '65') // 动态调整高度
            //   .backgroundColor('#97d9a9a9')
            //   .borderRadius(5)
            //   .padding(5)
            //   .margin(10)
            Text(`${this.showList.brief}`)
              .maxLines(3)
              // .textOverflow({ overflow: TextOverflow.None })
              .width('100%')
              .lineHeight('23')
              .backgroundColor('#d3ffffff')
              .borderRadius(5)
              .padding('5')
              .margin('10')
              .animation({ duration: 200, curve: Curve.EaseInOut })
              .maxLines(this.isExpanded ? undefined : 3) // 动态控制行数
              .textOverflow({
                overflow: this.isExpanded ? TextOverflow.None : TextOverflow.Ellipsis
              })
              .onClick(() => {
                this.isExpanded = !this.isExpanded; // 点击切换状态
              })
              .height(this.isExpanded ? 'auto' : '75') // 动态调整高度
            // if (this.isExpanded) {
            //   /* 显示操作按钮 */
            //   Text(this.isExpanded ? '收起 ∧' : '展开 ∨')
            //     .fontColor(Color.Blue)
            //     .onClick(() => this.isExpanded = !this.isExpanded)
            //     .alignSelf(ItemAlign.End)
            //     .width('20')
            //     .height('20')
            // }


            Flex({justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap,
              alignContent: FlexAlign.Center ,
              space:{main:LengthMetrics.px(10),cross:LengthMetrics.px(10)}})
            {
              if (this.showList.imageSrc1 != null){
                if (this.showList.imageSrc1 != null && this.showList.imageSrc2!= null) {

                  Image(this.showList.imageSrc)
                    .height('90')
                    .width('90')
                  Image(this.showList.imageSrc1)
                    .height('90')
                    .width('90')
                  Image(this.showList.imageSrc2)
                    .height('90')
                    .width('90')
                }else{
                  Image(this.showList.imageSrc)
                    .height('90')
                    .width('90')
                  Image(this.showList.imageSrc1)
                    .height('90')
                    .width('90')
                }
              }else {
                Image(this.showList.imageSrc)
                  .height('90')
                  .width('90')
              }

            }
            .padding('5')
            .width('auto')
            .constraintSize({ maxWidth: '100%' })
            // .backgroundColor('#FFFFFF')
            .width('100%')
            .height('110')
            Row({space:10}){
              Text('发布日期')
                .layoutWeight(1)
                .fontSize('12')
              //点赞图标
              Image(this.lovetouch ? $r('app.media.loving'): $r('app.media.love'))
                .width('22')
                .height('22')
                .opacity(0.7)
                .margin('5')
                .onClick(()=>{
                  console.log('111')
                  this.lovetouch = false

                })

              // Image($r('app.media.love'))
              //   .width('22')
              //   .height('22')
              //   .opacity(0.7)
              //   .margin('5')

            }
            .justifyContent(FlexAlign.End)
            .width('100%')
            .height('30')
            .padding({left:5})

          }
          // .backgroundColor('#43ffffff')
          .padding('10')
          .margin('8')
          .border({
            width: 3,
            color: '#75ffab04',
            radius: 8  // 可选：圆角
          })
          .width('90%')
          // .height('280')
          .height(this.isExpanded ? 'auto' : '300')

          List({ space: 12 }) {
            ForEach(this.CommentList, (item: CommentClass) => {
              ListItem() {
                CommentItem({ commentItem: item })
              }
            }, (item: CommentClass, index: number) => item.id)
          }
          .nestedScroll({
            scrollForward: NestedScrollMode.SELF_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .scrollBar(BarState.Off)
          .padding({ left: 16, right: 16 })
          .width('100%')
          .height('100%')
        }


      }
      // .height('100%')
      .layoutWeight(1)
      .onScroll((xOffset: number, yOffset: number) => {
        // this.bannerHeight = Math.max(0, 165 - yOffset)
      })
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST, // 向前滚动父容器优先
        scrollBackward: NestedScrollMode.PARENT_FIRST // 向后滚动父容器优先
      })
      //发表评论
      Row(){
        Image($r('app.media.Banner2'))
          .objectFit(ImageFit.Cover)
          .width('40')
          .height('85%')
          .backgroundColor('#6affffff')
          .alignSelf(ItemAlign.Center)
          .margin('5')
        TextInput({placeholder:'请输入评论'})
          .width('260')
          .height('85%')
          .alignSelf(ItemAlign.Center)
          .margin('5')
          .border({
            width:1,
            color:'#19ffffff'
          })
          .onClick(()=>{
            console.info('输入评论')
          })
        Button({type:ButtonType.Circle}){
          Image($r('app.media.back'))
        }
        .alignSelf(ItemAlign.Center)
        .height('80%')

      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('40')
      .backgroundColor('#fff')
      // .alignItems(HorizontalAlign.End)
    }
    .layoutWeight(1)
    .backgroundColor('#FFE0A4')
    .height('100%')
    .width('100%')
  }
}


@Component
struct CommentItem {
  @Prop commentItem: CommentClass;
  build() {
    //单条评论
    Row({space:8}) {
      //评论者头像
      Image(this.commentItem.imageSrc)
        .height(50)
        .width(50)
        .objectFit(ImageFit.Cover)
        .borderRadius(90)  // 稍微减小圆角
        .margin(15)

      Column(){
        Text(this.commentItem.commentUserName)
          .height(20)
          .width('100%')
          .fontSize(16)  // 增大字体
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(500)  // 加粗
          .margin({ top: 6, bottom: 1,left:5})
          .fontColor('#182431')


        Text(this.commentItem.content)
          .width('100%')
          .height('100%')
          .maxLines(3)
          .fontSize(14)  // 增大字体
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 6, bottom: 1,right:5})
          .fontColor('#000')
          .layoutWeight(1)
      }
      .height('100%')
      .layoutWeight(1)
      // .justifyContent(FlexAlign.SpaceBetween)  // 内容均匀分布
      // .margin({ right: 8 })


    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .width(352)
    .height(100)
    // .backgroundColor('#81f1a805')
    .border({
      width:2,
      color:'#ffefca77'
    })
    .shadow({  // 添加轻微阴影
      radius: 4,
      color: 'rgba(0, 0, 0, 0.04)',
      offsetX: 0,
      offsetY: 2
    })
    .width('100%')
    .height('95')
    .justifyContent(FlexAlign.Center)
  }
}
