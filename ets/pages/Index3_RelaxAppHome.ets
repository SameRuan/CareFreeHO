import { window } from "@kit.ArkUI";
import { router } from '@kit.ArkUI';
import { Top } from "../components/Top";
import {  Playlist, PlaylistManager} from "../model/SongData";



// 底部导航项数据结构
class NavItem {
  id: string;
  icon: ResourceStr;
  text: string;

  constructor(id: string, icon: ResourceStr, text: string) {
    this.id = id;
    this.icon = icon;
    this.text = text;
  }
}

// 轮播图组件
@Component
struct SimpleCarousel {
  @Prop carouselData: Resource[] = []
  @State currentIndex: number = 0
  @Prop autoPlay: boolean = true
  @Prop interval: number = 2000

  build() {
    Column() {
      Swiper() {
        ForEach(this.carouselData, (image: Resource, index: number) => {
          Image(image)
            .width('100%')
            .height(180)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
        })
      }
      .index(this.currentIndex)
      .autoPlay(this.autoPlay)
      .interval(this.interval)
      .loop(true)
      .indicator(true)
      .duration(300)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .width('100%')
      .height(180)
    }
  }
}

@Entry
@Component
export struct Index3_RelaxAppHomePage {
  windowClass?: window.Window;
  //维护当前显示的句子索引（默认0，显示第一句）
  @State currentSentenceIndex: number = 0;
  // 歌单数据
  @State playlists: Playlist[] = PlaylistManager.getAllPlaylists();
  // 底部导航数据

  // 轮播图图片
  private carouselImages: Resource[] = [
    $r('app.media.carousel1'),
    $r('app.media.carousel2'),
    $r('app.media.carousel3'),
    $r('app.media.carousel4'),
    $r('app.media.carousel5')
  ];
  //暖心句子
  private warmSentences: string[] = [
    '爱上自己的那一天\n人生才刚刚开始😘',
    '今天也是元气满满的一天～',
    '别焦虑\n慢慢来~',
    '你值得所有美好🥰',
    '今天的风吹走了昨天的烦恼😆',
    '如果学业将你击倒\n那你就幸福地躺倒😎',
    '我问小狗怎么不开心\n小狗说“忘忘忘”！',
    '心无褶皱，行至春光',
    '我们要允许自己暂时毫无斗志\n心安理得地做个废人👌',
    '累了就歇会儿\n我陪着你*<~>*',
    '春意暖暖，岁月缓缓',
    '坚持下去\n曙光就在前方*<~>*',
    '温柔对待自己呀😁'
  ];

  //刷新句子的方法：随机生成新索引（避免连续重复）
  private refreshSentence() {
    let newIndex: number;
    do {
      // 生成0到句子池长度-1的随机数
      newIndex = Math.floor(Math.random() * this.warmSentences.length);
    } while (newIndex === this.currentSentenceIndex); // 确保不与当前索引相同
    this.currentSentenceIndex = newIndex;
  }

  build() {
    Column({space:20}) {
      this.buildTopBar()
      this.MusicTime()
      this.SoupTime()


    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFE0A4')
  }

  @Builder
  buildTopBar() {
    Column() {
      Top({title:'放松'})

      Row() {
        SimpleCarousel({
          carouselData: this.carouselImages,
          autoPlay: true,
          interval: 2000
        })
          .margin({ top: 10, left: 16, right: 16 })
      }
    }
    .height('30%')
  }

  @Builder
  MusicTime() {
    Column() {
      Row() {
        Text("聆听Time！")
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .margin({ left: 30, top: 10 })
      }
      .width('100%')

      Row() {
        Column() {
          Scroll() {
            Row() {
              ForEach(this.playlists.slice(0, 4), (playlist: Playlist) => {
                PlaylistItem({ playlist: playlist })
                  .margin({ right: 12 })
              }, (playlist: Playlist) => playlist.id.toString())
            }
            .padding({ left: 16, right: 4 })
          }
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Horizontal)

          Scroll() {
            Row() {
              ForEach(this.playlists.slice(4), (playlist: Playlist) => {
                PlaylistItem({ playlist: playlist })
                  .margin({ right: 12 })
              }, (playlist: Playlist) => playlist.id.toString())
            }
            .padding({ left: 16, right: 4 })
          }
          .margin({ top: 15, bottom: 15 })
          .scrollBar(BarState.Off)
          .scrollable(ScrollDirection.Horizontal)
        }
        .width('100%')
        .padding({ top: 10 })
      }
    }
    .height('43%')
  }

  @Builder
  SoupTime() {
    Column() {
      Row() {
        Text("喝汤Time！")
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .margin({ left: 30 })
        Blank()
        Image($r('app.media.refresh'))
          .width(20)
          .height(20)
          .margin({ right: 20 })
          .onClick(() => this.refreshSentence())
      }
      .height('12%')
      .width('100%')

      // 暖心话语：绑定当前索引对应的句子
      Row() {
        Stack() {
          Row({ space: 12 }) {
            Column({ space: 4 }) {
              Text(this.warmSentences[this.currentSentenceIndex])
                .fontSize(24)
                .padding({ top: 28 })
                .textAlign(TextAlign.Center)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .height('100%')
            .borderRadius(25)
          }
          .width('100%')
          .padding({
            top: 10,
            bottom: 10,
            left: 20,
            right: 20
          })
        }
        .width('100%')
        .height('88%')
      }
    }
    .layoutWeight(1)
  }



  @Builder
  renderNavItem(item: NavItem) {
    Column({ space: 4 }) {
      Image(item.icon)
        .width(24).height(24)
        .objectFit(ImageFit.Contain)
      Text(item.text)
        .fontSize(14)
        .fontColor('#ff000000')
    }
    .margin({ top: 5 })
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
    .onClick(() => console.log(`点击了${item.text}`))
  }
}

// 歌单项组件
@Component
struct PlaylistItem {
  @Prop playlist: Playlist;

  build() {
    Column() {
      Image(this.playlist.cover)
        .width('100%')
        .objectFit(ImageFit.Cover)
        .height('75%')
        .backgroundColor('#F5F5F5')
        .borderRadius({ topLeft: 12, topRight: 12 })
      Column() {
        Text(this.playlist.title)
          .height(15)
          .width('100%')
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(500)
          .fontColor('#182431')
      }
      .padding({ left: 8, right: 8, top: 4 })
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width(110)
    .height(118)
    .borderRadius(12)
    .backgroundColor(Color.White)
    .shadow({
      radius: 6,
      color: 'rgba(0, 0, 0, 0.06)',
      offsetX: 0,
      offsetY: 3
    })
    .onClick(() => {
      console.log('点击了歌单:', this.playlist.title);
      router.pushUrl({ url: 'pages/Three_SongList', params: { playlistId: this.playlist.id } });
    })
  }
}
