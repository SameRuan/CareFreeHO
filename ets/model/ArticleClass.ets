/**
 * ArticleClass定义发表的帖子属性
 */
export  class ArticleClass {
  timestamp?: number;
  id: string = '';//帖子id
  imageSrc: ResourceStr = ''; //发帖人必须上传至少一张图片-用作首页展示
  imageSrc1?: ResourceStr = '';
  imageSrc2?: ResourceStr = '';
  title: string = '';//帖子标题
  brief: string = '';//帖子详情
  constructor(id: string,  title: string, brief: string,imageSrc: ResourceStr,imageSrc1?: ResourceStr,imageSrc2?: ResourceStr,) {
    this.id = id;
    this.imageSrc = imageSrc;
    this.imageSrc1 = imageSrc1;
    this.imageSrc2 = imageSrc2;
    this.title = title;
    this.brief = brief;
  }
}

export  interface PublishData {
  title: string;
  content: string;
  publishType?: string;
  publishTime?: string;
  publishLocation?: string;
  images: string[];
  timestamp?: number;
}