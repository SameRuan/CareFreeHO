// 歌曲结构
export interface Song {
  id: number
  songName: string
  author: string
  cover: Resource // 歌曲封面
  duration?: string // 歌曲时长
  url?: string// 添加歌曲URL字段（使用固定的测试音频）
}

// 歌单结构
export interface Playlist {
  id: number;
  cover: Resource; // 封面图片
  title: string;
  songList: Song[]; // 歌曲列表
}

// 歌单数据管理
export class PlaylistManager {
  // 所有歌单数据
  static getAllPlaylists(): Playlist[] {
    return [
      {
        id: 1,
        cover: $r('app.media.Song_10'),
        title: '影视',
        songList: [
          { id: 101, songName: '在加纳共和国离婚', author: '白鹿,曾舜晞', cover: $r('app.media.song_101'), duration: '4:12',
            url:'http://music.163.com/song/media/outer/url?id=2709086537.mp3'},
          { id: 102, songName: '临江仙', author: '白鹿', cover: $r('app.media.song_102'), duration: '3:34' ,
            url:'http://music.163.com/song/media/outer/url?id=2720684077.mp3'},
          { id: 103, songName: '星河叹', author: '黄龄', cover: $r('app.media.song_103'), duration: '4:24',
            url:'http://music.163.com/song/media/outer/url?id=2655537327.mp3'},
          { id: 104, songName: '唯一', author: '白鹿,曾舜晞', cover: $r('app.media.song_104'), duration: '3:35' ,
            url:'http://music.163.com/song/media/outer/url?id=2715260192.mp3'},
          { id: 105, songName: '星汉灿烂', author: '汐汉三', cover: $r('app.media.song_105'), duration: '3:46',
            url:'http://music.163.com/song/media/outer/url?id=1964893154.mp3'},
          { id: 106, songName: '雪落下的声音', author: '林俊杰', cover: $r('app.media.song_106'), duration: '3:35' ,
            url:'http://music.163.com/song/media/outer/url?id=1322228793.mp3'},
          { id: 107, songName: '九张机', author: '叶炫清', cover: $r('app.media.song_107'), duration: '3:35' ,
            url:'http://music.163.com/song/media/outer/url?id=2157969686.mp3'},
          { id: 108, songName: '爱殇', author: '董真', cover: $r('app.media.song_108'), duration: '3:35' ,
            url:'http://music.163.com/song/media/outer/url?id=1984804085.mp3'},
        ]
      },
      {
        id: 2,
        cover: $r('app.media.Song_20'),
        title: '流行',
        songList: [
          { id: 201, songName: '落空', author: '印子月', cover: $r('app.media.song_201'), duration: '05:13',
            url:'http://music.163.com/song/media/outer/url?id=548885986.mp3'},
          { id: 202, songName: '我们的明天', author: '鹿晗', cover: $r('app.media.song_202'), duration: '04:18',
            url:'http://music.163.com/song/media/outer/url?id=2738222757.mp3'},
          { id: 203, songName: '这，就是爱', author: '张杰', cover: $r('app.media.song_203'), duration: '04:46',
            url:'http://music.163.com/song/media/outer/url?id=191060.mp3'},
          { id: 204, songName: '过火', author: '张信哲', cover: $r('app.media.song_204'), duration: '04:52',
            url:'http://music.163.com/song/media/outer/url?id=423406145.mp3'},
          { id: 205, songName: '阿拉斯加海湾', author: '蓝心羽', cover: $r('app.media.song_205'), duration: '04:35',
            url:'http://music.163.com/song/media/outer/url?id=1500569811.mp3'},
          { id: 206, songName: '偏爱', author: '张芸京', cover: $r('app.media.song_206'), duration: '04:18',
            url:'http://music.163.com/song/media/outer/url?id=5238992.mp3'},
          { id: 207, songName: '戒烟', author: '李荣浩', cover: $r('app.media.song_207'), duration: '04:46',
            url:'http://music.163.com/song/media/outer/url?id=518686034.mp3'},
          { id: 208, songName: '烟火里的尘埃', author: '华晨宇', cover: $r('app.media.song_208'), duration: '04:52',
            url:'http://music.163.com/song/media/outer/url?id=29004400.mp3'},
        ]
      },
      {
        id: 3,
        cover: $r('app.media.Song_30'),
        title: '英文',
        songList: [
          { id: 301, songName: 'Cruel Summer', author: 'Taylor Swift', cover: $r('app.media.song_301'), duration: '03:28',
            url:'http://music.163.com/song/media/outer/url?id=2067348144.mp3'},
          { id: 302, songName: 'Poker Face', author: 'Lady Gaga', cover: $r('app.media.song_302'), duration: '04:46',
            url:'http://music.163.com/song/media/outer/url?id=2022861614.mp3'},
          { id: 303, songName: 'What Makes You Beautiful', author: 'One Direction', cover: $r('app.media.song_303'), duration: '04:23',
            url:'http://music.163.com/song/media/outer/url?id=27218979.mp3'},
          { id: 304, songName: 'Boyfriend', author: 'Justin Bieber', cover: $r('app.media.song_304'), duration: '04:32' ,
            url:'http://music.163.com/song/media/outer/url?id=26721789.mp3'},
          { id: 305, songName: 'Baby', author: 'Justin Bieber,Ludacris', cover: $r('app.media.song_305'), duration: '03:30' ,
            url:'http://music.163.com/song/media/outer/url?id=2140626391.mp3'},
        ]
      },
      {
        id: 4,
        cover: $r('app.media.Song_40'),
        title: '韩文',
        songList: [
          { id: 401, songName: 'Kill This Love', author: 'BLACKPINK', cover: $r('app.media.song_401'), duration: '04:40',
            url: 'http://music.163.com/song/media/outer/url?id=1397226690.mp3' },
          { id: 402, songName: 'Boy With Luv', author: 'BTS', cover: $r('app.media.song_402'), duration: '03:58',
            url: 'http://music.163.com/song/media/outer/url?id=1375569365.mp3' },
          { id: 403, songName: 'Bite Me', author: 'ENHYPEN', cover: $r('app.media.song_403'), duration: '03:38',
            url: 'http://music.163.com/song/media/outer/url?id=2079467701.mp3' },
          { id: 404, songName: 'Strategy', author: 'TWICE', cover: $r('app.media.song_404'), duration: '04:38',
            url: 'http://music.163.com/song/media/outer/url?id=2717862848.mp3' },
          { id: 405, songName: 'Dangerously', author: 'AHYEON of BABYMONSTER', cover: $r('app.media.song_405'), duration: '03:25',
            url: 'http://music.163.com/song/media/outer/url?id=2149490392.mp3' },
          { id: 406, songName: 'Gentleman', author: 'PSY', cover: $r('app.media.song_406'), duration: '03:19',
            url: 'http://music.163.com/song/media/outer/url?id=26244616.mp3' },
        ]
      },
      { id: 5,
        cover: $r('app.media.Song_50'),
        title: '日文',
        songList: [
          { id: 501, songName: '紅蓮華 (THE FIRST TAKE Studio Ver.)', author: 'LiSA', cover: $r('app.media.song_501'), duration: '04:06',
            url: 'http://music.163.com/song/media/outer/url?id=1459710910.mp3' },
          { id: 502, songName: '打上花火', author: 'Daoko,米津玄師', cover: $r('app.media.song_502'), duration: '04:29',
            url: 'http://music.163.com/song/media/outer/url?id=496869422.mp3' },
          { id: 503, songName: '極楽浄土', author: 'MARiA', cover: $r('app.media.song_503'), duration: '03:53',
            url: 'http://music.163.com/song/media/outer/url?id=413834590.mp3' },
          { id: 504, songName: '群青', author: 'KUKIKO', cover: $r('app.media.song_504'), duration: '04:32',
            url: 'http://music.163.com/song/media/outer/url?id=1482991790.mp3' },
          { id: 505, songName: '心做し', author: '双笙（陈元汐）', cover: $r('app.media.song_505'), duration: '04:18',
            url: 'http://music.163.com/song/media/outer/url?id=478303470.mp3' },
          { id: 506, songName: '恋愛サーキュレーション', author: '花澤香菜', cover: $r('app.media.song_506'), duration: '03:40',
            url: 'http://music.163.com/song/media/outer/url?id=579954.mp3' },
        ]
      },
      {
        id: 6,
        cover: $r('app.media.Song_60'),
        title: '说唱',
        songList: [
          { id: 601, songName: '别怕变老', author: '王以太,艾热 AIR', cover: $r('app.media.song_601'), duration: '04:15',
            url: 'http://music.163.com/song/media/outer/url?id=1876179147.mp3' },
          { id: 602, songName: '舟', author: '万妮达Vinida Weng', cover: $r('app.media.song_602'), duration: '03:48',
            url: 'http://music.163.com/song/media/outer/url?id=1974959291.mp3' },
          { id: 603, songName: '你也是个Rapper', author: '宝石Gem,派克特（PACT）', cover: $r('app.media.song_603'), duration: '03:52',
            url: 'http://music.163.com/song/media/outer/url?id=1964306225.mp3' },
          { id: 604, songName: '经济舱', author: 'KEY.L刘聪,KAFE_HU咖啡胡', cover: $r('app.media.song_604'), duration: '04:26',
            url: 'http://music.163.com/song/media/outer/url?id=1492049185.mp3' },
          { id: 605, songName: 'Hey KONG', author: 'KEY.L刘聪,c0de731', cover: $r('app.media.song_605'), duration: '04:38',
            url: 'http://music.163.com/song/media/outer/url?id=1383954630.mp3' },
          { id: 606, songName: '场上称霸', author: '万妮达Vinida Weng', cover: $r('app.media.song_606'), duration: '03:35',
            url: 'http://music.163.com/song/media/outer/url?id=507114512.mp3' }
        ]
      },
      {
        id: 7,
        cover: $r('app.media.Song_70'),
        title: '国风国朝',
        songList: [
          { id: 701, songName: '红昭愿', author: '鞠婧祎', cover: $r('app.media.song_701'), duration: '04:45',
            url: 'http://aqqmusic.tc.qq.com/C400003WQ9ul3NfIkf.m4a?guid=411662979&vkey=E22B2E8C8E03F8' +
              '88B5B8DF92E2A2835429EA4EAF24E01C0820E1AA43A0C029229CCE43AB783C400D' +
              '75B559789BE1E548C6142537B6F93B5F__v2b9ab294&uin=&fromtag=120032' },
          { id: 702, songName: '凝眸', author: '余一', cover: $r('app.media.song_702'), duration: '03:51',
            url: 'http://music.163.com/song/media/outer/url?id=2647591656.mp3' },
          { id: 703, songName: '琵琶行', author: '奇然,沈谧仁', cover: $r('app.media.song_703'), duration: '05:34',
            url: 'http://music.163.com/song/media/outer/url?id=476513774.mp3' },
          { id: 704, songName: '云水间', author: ' 少年霜,天音纪', cover: $r('app.media.song_704'), duration: '03:32',
            url: 'http://music.163.com/song/media/outer/url?id=1378533445.mp3' },
          { id: 705, songName: '虞叹息', author: '闻人听書', cover: $r('app.media.song_705'), duration: '03:40',
            url: 'http://music.163.com/song/media/outer/url?id=1888647804.mp3' },
          { id: 706, songName: '探故知', author: '萧默然', cover: $r('app.media.song_706'), duration: '03:58',
            url: 'http://music.163.com/song/media/outer/url?id=3322054568.mp3' },
        ]
      },
      {
        id: 8,
        cover: $r('app.media.Song_80'),
        title: '广场舞',
        songList: [
          { id: 801, songName: '最炫民族风(Live)', author: '凤凰传奇', cover: $r('app.media.song_801'), duration: '04:45',
            url: 'http://music.163.com/song/media/outer/url?id=29418062.mp3' },
          { id: 802, songName: '小鸡小鸡', author: '王蓉', cover: $r('app.media.song_802'), duration: '03:32',
            url: 'http://music.163.com/song/media/outer/url?id=29567381.mp3' },
          { id: 803, songName: '卡路里', author: '火箭少女101', cover: $r('app.media.song_803'), duration: '03:27',
            url: 'http://music.163.com/song/media/outer/url?id=1294924781.mp3' },
          { id: 804, songName: '美美哒', author: '王巧丽', cover: $r('app.media.song_804'), duration: '03:51',
            url: 'http://music.163.com/song/media/outer/url?id=1918958616.mp3' },
          { id: 805, songName: '老婆最大', author: '崔子格', cover: $r('app.media.song_805'), duration: '03:40',
            url: 'http://music.163.com/song/media/outer/url?id=25657293.mp3' },
          { id: 806, songName: '好运来', author: '祖海', cover: $r('app.media.song_806'), duration: '03:58',
            url: 'http://music.163.com/song/media/outer/url?id=333750.mp3' }
        ]
      }
    ];
  }

  // 根据ID获取歌单
  static getPlaylistById(id: number): Playlist | undefined {
    return PlaylistManager.getAllPlaylists().find(playlist => playlist.id === id);
  }

  // 获取默认歌单（第一个）
  static getDefaultPlaylist(): Playlist {
    return PlaylistManager.getAllPlaylists()[0];
  }
}
