// 发布记录接口定义，用于KVStore中存储的数据结构
export interface PublishRecord {
  timestamp: number;        // 时间戳
  title: string;           // 标题
  content: string;         // 内容
  images: string[];        // 图片URL数组
}