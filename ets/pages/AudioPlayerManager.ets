import { media } from "@kit.MediaKit";
import { promptAction } from "@kit.ArkUI";
import { Song } from "../model/SongData";

// import { Song } from './SongData';

// 播放状态枚举 - 定义播放器的各种可能状态
export enum PlayerState {
  IDLE = 'idle', // 空闲状态：播放器未初始化或已重置
  PLAYING = 'playing', // 正在播放状态
  PAUSED = 'paused', // 已暂停状态
  STOPPED = 'stopped', // 已停止状态
  PREPARED = 'prepared', // 已准备就绪状态
  COMPLETED = 'completed', // 播放完成状态
  ERROR = 'error' // 错误状态
}

// 音频播放管理器类 - 采用单例模式确保全局只有一个播放器实例
export class AudioPlayerManager {
  private static instance: AudioPlayerManager; // 静态实例，单例模式核心
  private audioPlayer: media.AVPlayer | undefined = undefined; // 实际的音频播放器实例
  private _playerState: PlayerState = PlayerState.IDLE; // 当前播放器状态
  private _timeUpdate: number = 0; // 当前播放时间（毫秒）
  private _duration: number = 0; // 歌曲总时长（毫秒）
  duration: number = 0
  timeUpdate: number = 0
  //歌曲数据相关
  songs: Song[] = []; // 当前播放列表（公开属性，外部可设置）
  selectedIndex: number = -1; // 当前选中/播放的歌曲索引

  //事件监听器相关
  selectedIndexChanged = (index: number) => {
  }; // 选中索引变化回调
  timeUpdated = (time: number, duration: number) => {
  }; // 时间更新回调
  stateChanged = (state: string) => {
  }; // 状态变化回调

  private stateListeners: ((state: PlayerState) => void)[] = []; // 状态变化监听器数组
  private timeUpdateListeners: ((time: number, duration: number) => void)[] = []; // 时间更新监听器数组
  private songChangeListeners: ((song: Song | null) => void)[] = []; // 歌曲变化监听器数组
  private errorListeners: ((error: string) => void)[] = []; // 错误监听器数组

  // 私有构造函数 - 防止外部直接实例化，确保单例模式
  private constructor() {
  }

  // ============ 单例获取方法 ============
  static getInstance(): AudioPlayerManager {
    // 如果实例不存在，创建新实例
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager();
    }
    // 返回单例实例
    return AudioPlayerManager.instance;
  }

  // ============ 核心播放方法 ============
  // 根据索引播放音频（使用网络URL）
  async play(index: number = 0) {
    this._timeUpdate = 0; // 确保重置播放时间
    this._duration = 0; // 重置时长
    console.log('play 方法被调用，index:', index, '歌曲列表长度:', this.songs.length);
    // 在时间更新监听器中通知：
    this.notifyTimeUpdate(this._timeUpdate, this._duration);
    // 1. 参数校验：检查索引和歌曲列表的有效性
    if (this.songs.length === 0 || index < 0 || index >= this.songs.length) {
      promptAction.showToast({ message: '歌曲不存在' });
      console.warn('歌曲不存在或索引无效');
      return;
    }

    // 2. 获取目标歌曲并检查URL有效性
    const song = this.songs[index];
    console.log('准备播放歌曲:', song.songName, 'URL:', song.url);

    if (!song.url || song.url.trim() === '') {
      promptAction.showToast({ message: '歌曲链接无效' });
      console.error('歌曲URL无效:', song);
      return;
    }

    // 3. 检查是否已经在播放同一首歌曲
    if (this.selectedIndex === index && this.audioPlayer?.state === 'playing') {
      console.log('歌曲已在播放中');
      return;
    }

    // 4. 确保播放器已初始化
    if (!this.audioPlayer) {
      console.log('播放器未初始化，正在初始化...');
      await this.init(); // 初始化播放器
    }

    // 5. 执行播放操作
    if (this.audioPlayer) {
      try {
        // 停止当前播放（如果不是空闲状态）
        if (this.audioPlayer.state !== 'idle') {
          await this.audioPlayer.reset(); // 重置播放器
          console.log('播放器已重置');
        }

        // 设置播放URL
        console.log('设置播放URL:', song.url);
        this.audioPlayer.url = song.url;

        // 6. 更新内部状态
        this.selectedIndex = index; // 更新选中索引
        this._timeUpdate = 0; // 重置播放时间

        // 7. 通知所有监听器
        console.log('通知歌曲切换，索引:', index);

        // 通知选中索引变化（外部回调）
        if (this.selectedIndexChanged) {
          this.selectedIndexChanged(index);
        }

        // 通知歌曲变化（内部监听器）
        this.notifySongChange(song);

        // 更新并通知播放状态
        this._playerState = PlayerState.PREPARED;
        this.notifyStateChange(PlayerState.PREPARED);

        console.log('播放设置完成，当前索引:', this.selectedIndex);

      } catch (error) {
        // 错误处理
        console.error('播放设置失败:', error);
        promptAction.showToast({
          message: '播放失败: ' + (error.message || '未知错误')
        });
      }
    }
  }

  // ============ 播放器初始化 ============
  // 初始化音频播放器实例
  async init() {
    try {
      // 创建AVPlayer实例
      let audioPlayer = await media.createAVPlayer();
      this.audioPlayer = audioPlayer;
      console.log('AudioPlayerUtils-- ✔️ audioPlayer创建成功');

      // 添加事件监听
      this.addObserver();

    } catch (e) {
      // 初始化失败处理
      console.log('AudioPlayerUtils-- ❌ ', AudioPlayerManager.name, ' : ', JSON.stringify(e));
    }
  }

  // ============ 事件监听设置 ============
  // 设置播放器的各种事件监听
  addObserver() {
    if (this.audioPlayer) {
      // 监听状态变化事件
      this.audioPlayer.on('stateChange', (state, reason) => {
        console.log('播放器状态变化:', state, '原因:', reason);

        // 根据播放器状态执行相应操作
        switch (state) {
          case 'initialized': // 初始化完成
            this.audioPlayer?.prepare(); // 准备播放
            break;
          case 'prepared': // 准备完成
            this.audioPlayer?.play(); // 开始播放
            break;
          case 'playing': // 开始播放
            this._playerState = PlayerState.PLAYING;
            this.notifyStateChange(PlayerState.PLAYING);
            break;
          case 'paused': // 暂停
            this._playerState = PlayerState.PAUSED;
            this.notifyStateChange(PlayerState.PAUSED);
            break;
          case 'completed': // 播放完成
            this.next(); // 自动播放下一首
            this._playerState = PlayerState.COMPLETED;
            this.notifyStateChange(PlayerState.COMPLETED);
            break;
          case 'error': // 发生错误
            console.error('播放器错误:', reason);
            promptAction.showToast({ message: '播放失败，请检查网络或链接' });
            this._playerState = PlayerState.ERROR;
            this.notifyStateChange(PlayerState.ERROR);
            break;
        }

        // 调用外部状态变化回调
        this.stateChanged(state);
      });

      // 监听播放时间更新事件
      this.audioPlayer.on('timeUpdate', (value) => {
        this._timeUpdate = value; // 更新当前播放时间
        this.timeUpdated(value, this._duration); // 调用外部回调
      });

      // 监听歌曲时长更新事件
      this.audioPlayer.on('durationUpdate', (value) => {
        this._duration = value; // 更新歌曲总时长
      });
    }
  }

  // ============ 播放控制方法 ============
  // 播放/暂停切换
  togglePlayPause():string {
    console.log('暂停/继续，当前状态:', this.audioPlayer?.state);
    let a:string = this.audioPlayer?.state as string
    if (this.audioPlayer) {
      if (this.audioPlayer.state === 'playing') {
        this.audioPlayer.pause(); // 正在播放 -> 暂停
      } else if (this.audioPlayer.state === 'paused' || this.audioPlayer.state === 'completed') {
        this.audioPlayer.play(); // 已暂停或完成 -> 播放
      }
    }
    return a
  }

  // 下一首
  next() {
    console.log('下一曲，当前索引:', this.selectedIndex, '总歌曲数:', this.songs.length);
    if (this.songs.length === 0) {
      return;
    }

    // 循环播放逻辑：如果是最后一首，播放第一首
    if (this.selectedIndex === this.songs.length - 1) {
      this.play(0);
    } else {
      this.play(this.selectedIndex + 1);
    }
  }

  // 上一首
  previous() {
    console.log('上一曲，当前索引:', this.selectedIndex, '总歌曲数:', this.songs.length);
    if (this.songs.length === 0) {
      return;
    }

    // 循环播放逻辑：如果是第一首，播放最后一首
    if (this.selectedIndex === 0) {
      this.play(this.songs.length - 1);
    } else if (this.selectedIndex < 0) {
      this.play(0); // 索引无效，播放第一首
    } else {
      this.play(this.selectedIndex - 1);
    }
  }

  // 跳转到指定时间
  seek(time: number) {
    // 边界检查：确保时间在有效范围内
    if (time < 0) {
      time = 0;
    }
    if (time > this._duration) {
      time = this._duration;
    }

    this._timeUpdate = time; // 更新当前时间
    this.notifyTimeUpdate(this._timeUpdate, this._duration); // 通知时间更新
    if (this.audioPlayer && time >= 0 && time <= this._duration) {
      this.audioPlayer.seek(time)
    }

  }

  // ============ 数据获取方法 ============
  // 获取当前播放的歌曲
  getCurrentSong(): Song | null {
    // 检查索引是否有效
    if (this.selectedIndex >= 0 && this.selectedIndex < this.songs.length) {
      return this.songs[this.selectedIndex];
    }
    return null;
  }

  // 获取当前播放的歌曲ID
  getCurrentSongId(): number {
    const currentSong = this.getCurrentSong();
    return currentSong?.id || -1;
  }

  // 获取当前播放时间
  getTimeUpdate(): number {
    return this._timeUpdate;
  }

  // 获取歌曲总时长
  getDuration(): number {
    return this._duration;
  }

  // 获取播放器状态
  getPlayerState(): PlayerState {
    return this._playerState;
  }

  // 检查指定歌曲是否正在播放
  isSongPlaying(songId: number): boolean {
    const currentSong = this.getCurrentSong();
    return currentSong?.id === songId && this._playerState === PlayerState.PLAYING;
  }

  // ============ 事件监听注册方法 ============
  // 注册状态变化监听器
  onStateChange(listener: (state: PlayerState) => void) {
    this.stateListeners.push(listener);
  }

  // 注册时间更新监听器
  onTimeUpdate(listener: (time: number, duration: number) => void) {
    this.timeUpdateListeners.push(listener);
  }

  // 注册歌曲变化监听器
  onSongChange(listener: (song: Song | null) => void) {
    this.songChangeListeners.push(listener);
  }

  // 注册错误监听器
  onError(listener: (error: string) => void) {
    this.errorListeners.push(listener);
  }

  // ============ 内部通知方法 ============
  // 通知状态变化（调用所有注册的状态监听器）
  private notifyStateChange(state: PlayerState) {
    this.stateListeners.forEach(listener => listener(state));
  }

  // 通知时间更新（调用所有注册的时间更新监听器）
  private notifyTimeUpdate(time: number, duration: number) {
    this.timeUpdateListeners.forEach(listener => listener(time, duration));
  }

  // 通知歌曲变化（调用所有注册的歌曲变化监听器）
  private notifySongChange(song: Song | null) {
    this.songChangeListeners.forEach(listener => listener(song));
  }

  // 通知错误（调用所有注册的错误监听器）
  private notifyError(error: string) {
    this.errorListeners.forEach(listener => listener(error));
  }

  // ============ 调试方法 ============
  // 调试方法：打印当前播放信息
  debugCurrentSong() {
    console.log('=== 当前播放信息调试 ===');
    console.log('selectedIndex:', this.selectedIndex);
    console.log('songs长度:', this.songs.length);
    console.log('当前歌曲:', this.getCurrentSong());
    console.log('当前歌曲ID:', this.getCurrentSongId());
    console.log('当前状态:', this._playerState);
    console.log('=====================');
  }
}

// 创建并导出单例实例
const audioPlayerManager = AudioPlayerManager.getInstance();

// 导出单例实例
export {
  audioPlayerManager
};
