import { router } from '@kit.ArkUI';
import { TopBack } from '../components/TopBack';
import {  Song, Playlist, PlaylistManager } from '../model/SongData';
// import { Song, Playlist, PlaylistManager } from './SongData';
import { AudioPlayerManager, PlayerState } from './AudioPlayerManager';
import { audioPlayerManager } from './AudioPlayerManager';

// 歌曲项组件
@Component
struct SongItem {
  @Prop song: Song;
  @Prop currentSongId: number; // 当前正在播放的歌曲ID，用于判断是否高亮
  @State isLiked: boolean = false; // 点赞状态，本地状态
  @Prop songIndex: number; // 歌曲在列表中的索引，用于播放时定位
  @Prop currentPlaylistId: number; // 当前歌单ID

  build() {
    Row() {
      // 左侧：歌曲封面图片
      Image(this.song.cover)
        .width(48)
        .height(48)
        .borderRadius(8)
        .margin({ right: 12 })

      // 中间：歌曲信息区域
      Column({ space: 4 }) {
        // 歌曲名称，当前播放的歌曲显示粉色，其他显示黑色
        Text(this.song.songName)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.currentSongId === this.song.id ? 0xFF4081 : Color.Black)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Start)

        // 歌手信息和时长
        Row() {
          Text(this.song.author)
            .fontSize(13)
            .fontColor(this.currentSongId === this.song.id ? 0xFF4081 : 0x666666)
          // 如果有时长信息则显示
          if (this.song.duration) {
            Text(' · ' + this.song.duration)
              .fontSize(13)
              .fontColor(0x888888)
          }
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      // 右侧：操作按钮区域
      Row({ space: 12 }) {
        // 点赞按钮 - 点击切换点赞状态
        Image(this.isLiked ? $r('app.media.GoodRed') : $r('app.media.Good'))
          .width(20)
          .height(20)
          .opacity(0.8)
          .onClick(() => {
            this.isLiked = !this.isLiked;
          })
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height(70)
    .padding({ left: 16, right: 16 })
    .borderRadius(8)
    .onClick(() => {
      // 点击歌曲时播放该歌曲
      audioPlayerManager.play(this.songIndex);
    })
  }
}

// 歌单页面主组件
@Entry
@Component
struct Three_SongList {
  @State currentPlaylist: Playlist | undefined = undefined; // 当前显示的歌单
  @State currentSong: Song | null = null; // 当前播放的歌曲
  @State playerState: PlayerState = PlayerState.IDLE; // 播放器状态 - 必须监听这个状态变化
  @State isPlayingAll: boolean = false; // 是否正在播放全部歌曲
  @State displaySongs: Song[] = []; // 当前页面显示的歌曲列表
  @State currentPlaylistId: number = 0; // 当前歌单ID
  private audioPlayer = AudioPlayerManager.getInstance();

  aboutToAppear() {
    // 获取路由参数中的歌单ID
    const params = router.getParams() as Record<string, number>;
    if (params && params['playlistId']) {
      const playlistId = params['playlistId'];
      this.currentPlaylistId = playlistId;
      this.loadPlaylist(playlistId);
    } else {
      // 默认显示第一个歌单
      this.loadPlaylist(1); // 第一个歌单ID是1
    }

    // 初始化当前歌曲和播放状态 - 从AudioPlayerManager获取最新状态
    this.currentSong = this.audioPlayer.getCurrentSong();
    this.playerState = this.audioPlayer.getPlayerState();

    // 监听歌曲变化事件 - 当歌曲切换时更新当前歌曲
    this.audioPlayer.onSongChange((song: Song | null) => {
      this.currentSong = song;
    });

    // 关键修复：监听播放器状态变化事件 - 这个必须有！当播放/暂停状态变化时更新UI
    this.audioPlayer.onStateChange((state: PlayerState) => {
      console.log('SongList: 状态变化', state);
      this.playerState = state; // 更新playerState状态，触发UI重新渲染
    });
  }

  // 加载歌单
  loadPlaylist(playlistId: number) {
    const playlist = PlaylistManager.getPlaylistById(playlistId);
    if (playlist) {
      this.currentPlaylist = playlist;

      // 更新显示列表
      this.displaySongs = [...playlist.songList];

      // 检查是否需要更新播放列表
      const currentSongId = this.audioPlayer.getCurrentSongId();
      const isCurrentSongInThisPlaylist = playlist.songList.some(song => song.id === currentSongId);

      // 如果当前播放的歌曲不在这个歌单中，才更新播放列表
      if (!isCurrentSongInThisPlaylist && playlist.songList.length > 0) {
        this.audioPlayer.songs = [...playlist.songList];
        this.audioPlayer.selectedIndex = -1; // 重置选中索引
      }
    }
  }

  build() {
    Column() {
      // 顶部：歌单头部信息
      this.buildPlaylistHeader()
      // 中间：歌曲列表和控制区域
      this.buildPlaybackControls()
      // 底部：迷你播放器 - 只在有歌曲时显示
      // 如果想一直显示（即使没有歌曲），去掉if条件判断，始终调用buildMiniPlayer()
      if (this.currentSong) {
        this.buildMiniPlayer()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFE0A4') // 页面背景色
  }

  // 构建歌单头部区域
  @Builder
  buildPlaylistHeader() {
    Column({ space: 10 }) {
      // 返回按钮和标题
      TopBack({title:`${this.currentPlaylist?.title }` || '歌单'})
      // 歌单封面图片
      Row() {
        Image(this.currentPlaylist?.cover)
          .width('100%')
          .height('25%')
          .borderRadius(12)
          .margin({ right: 15 })
          .objectFit(ImageFit.Cover) // 图片填充模式
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 5 })
      .borderRadius(15)
      .margin({ left: 16, right: 16 })
    }
    .padding({ bottom: 10 })
  }

  // 构建播放控制和歌曲列表区域
  @Builder
  buildPlaybackControls() {
    Column() {
      // 播放控制栏：播放全部按钮
      Row() {
        Image($r('app.media.PlaySong'))
          .height(28)
          .width(28)
          .onClick(() => {
            if (this.currentPlaylist) {
              this.isPlayingAll = true;
              // 播放前确保播放列表设置正确
              this.audioPlayer.songs = [...this.currentPlaylist.songList];
              this.audioPlayer.play(0); // 播放第一首
            }
          })
        Text('播放全部(' + (this.currentPlaylist?.songList.length || 0) + ')')
          .fontSize(17)
          .margin({ left: 10 })
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            if (this.currentPlaylist) {
              this.isPlayingAll = true;
              this.audioPlayer.songs = [...this.currentPlaylist.songList]; // 设置播放列表
              this.audioPlayer.play(0); // 播放第一首
            }
          })
        Blank()
      }
      .width('100%')
      .height(50)
      .padding({ left: 16, right: 16 })

      // 歌曲列表
      List({ space: 8 }) {
        ForEach(this.displaySongs, (song: Song, index?: number) => {
          ListItem() {
            // 渲染每个歌曲项
            SongItem({
              song: song,
              currentSongId: this.currentSong?.id || -1, // 传递当前播放歌曲ID
              songIndex: index || 0, // 传递歌曲索引
              currentPlaylistId: this.currentPlaylistId // 传递当前歌单ID
            })
          }
        }, (song: Song) => {
          // 使用歌单ID+歌曲ID作为唯一标识，避免不同歌单中相同ID的歌曲冲突
          return `${this.currentPlaylistId}-${song.id}`
        })
      }
      .layoutWeight(1)
      .width('100%')
    }
    .borderRadius({ topLeft: 20, topRight: 20 })
    .layoutWeight(1)
  }

  // 构建底部迷你播放器
  @Builder
  buildMiniPlayer() {
    Row() {
      // 歌曲封面
      Image(this.currentSong?.cover)
        .width(42)
        .height(42)
        .borderRadius(6)

      // 歌曲信息
      Column({ space: 3 }) {
        Text(this.currentSong?.songName || '暂无播放')
          .fontSize(15)
          .fontColor(Color.Black)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Start)
        Text(this.currentSong?.author || '')
          .fontSize(12)
          .fontColor(Color.Black)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .layoutWeight(1)
      .margin({ left: 10 })
      .justifyContent(FlexAlign.Center)

      // 播放控制按钮 - 关键修复：这个按钮会根据playerState状态变化
      Row({ space: 20 }) {
        // 根据播放状态显示播放或暂停图标
        // playerState === PlayerState.PLAYING 时显示暂停图标，其他状态显示播放图标
        Image(
          this.playerState === PlayerState.PLAYING ?
            $r('app.media.Pause') : $r('app.media.Playing')
        )
          .width(26)
          .height(26)
          .onClick(() => {
            console.log('点击播放/暂停按钮，当前状态:', this.playerState);
            this.audioPlayer.togglePlayPause() // 调用播放器管理器的切换方法
          })
      }
      .alignItems(VerticalAlign.Center)
    }
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFC759')
    .border({ width: { top: 1 }, color: '#E0E0E0' })
    .onClick(() => {
      // 点击迷你播放器跳转到歌曲详情页
      if (this.currentSong) {
        router.pushUrl({
          url: 'pages/Three_SongDetail'
        });
      }
    })
  }
}