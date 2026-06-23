import { router } from '@kit.ArkUI';
import { TopBack } from '../components/TopBack';
import { Song } from '../model/SongData';
import { AudioPlayerManager, PlayerState } from './AudioPlayerManager';
import { audioPlayerManager } from './AudioPlayerManager';

@Entry
@Component
export struct Three_SongDetail {
  @State currentSong: Song | null = null;
  @State playerState: PlayerState = PlayerState.IDLE;
  @State timeUpdate: number = 0;
  @State duration: number = 0;
  private audioPlayer = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    this.currentSong = this.audioPlayer.getCurrentSong();
    this.playerState = this.audioPlayer.getPlayerState();
    this.timeUpdate = this.audioPlayer.getTimeUpdate();
    this.duration = this.audioPlayer.getDuration();

    // 监听播放器状态变化
    this.audioPlayer.onSongChange((song) => {
      this.currentSong = song;
    });

    this.audioPlayer.onStateChange((state) => {
      this.playerState = state;
    });

    this.audioPlayer.onTimeUpdate((time, duration) => {
      this.timeUpdate = time;
      this.duration = duration;
    });
    // 监听当前播放音乐的进度和总时长，并记录
    audioPlayerManager.timeUpdated = (time, duration) => {
      this.timeUpdate = time
      this.duration = duration
    }

    this.timeUpdate = audioPlayerManager.timeUpdate
    this.duration = audioPlayerManager.duration
  }

  handleTime() {
    const currentSeconds = Math.floor(this.timeUpdate / 1000);
    const remainingSeconds = Math.floor((this.duration - this.timeUpdate) / 1000);

    const formatTime = (seconds: number) => {
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    };

    return [formatTime(currentSeconds), formatTime(remainingSeconds)];
  }

  build() {
    Column() {
      TopBack({title:'歌曲详情'})
      this.DetailsBuild()
      this.SongPlayingBuild()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFE0A4')
  }


  @Builder
  DetailsBuild() {
    Column({ space: 20 }) {
      Text(this.currentSong?.songName || '歌曲名')
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
        .padding({ top: 20 })

      Text(this.currentSong?.author || '歌手')
        .fontSize(20)
        .textAlign(TextAlign.Center)
        .width('100%')

      Image(this.currentSong?.cover)
        .width('80%')
        .height('70%')
        .borderRadius(10)
        .padding({ top: 10 })
        .objectFit(ImageFit.Cover)
    }
    .height('60%')
  }

  @Builder
  SongPlayingBuild() {
    Column() {
      // 进度条和时间显示
      Column({ space: 10 }) {
        Row() {
          Text(this.handleTime()[0])
            .fontSize(12)
            .fontColor(0x666666)
          Blank()
          Text('-' + this.handleTime()[1])
            .fontSize(12)
            .fontColor(0x666666)
        }
        .width('90%')

        Slider({
          min: 0,
          max: this.duration,
          value: this.timeUpdate,
          step: 1000,
          style: SliderStyle.OutSet
        })
          .width('90%')
          .onChange((value) => {
            this.audioPlayer.seek(value);
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)

      // 播放控制按钮
      Row({ space: 30 }) {
        Image($r('app.media.PreviousSong'))
          .width(50)
          .height(50)
          .onClick(() => {
            this.audioPlayer.previous();
          })

        Image(
          this.playerState === PlayerState.PLAYING ?
            $r('app.media.Pause') : $r('app.media.Playing')
        )
          .width(50)
          .height(50)
          .onClick(() => {
            console.log(PlayerState.PLAYING +'')
            console.log(this.playerState +'')
          let aaa:string  =  this.audioPlayer.togglePlayPause()
            console.log(aaa +'[a]')
          })

        Image($r('app.media.LastSong'))
          .width(50)
          .height(50)
          .onClick(() => {
            this.audioPlayer.next();
          })
      }
      .padding({ top: 30 })
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ bottom: 30 })
  }
}
