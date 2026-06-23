export class   CommentClass{
  id: string = '';//评论用户id
  userId?: string = '';//评论用户id
  commentUserName: string = '';//评论用户用户名
  content: string = '';//发表的评论
  imageSrc?: ResourceStr = '';//评论用户头像
  date?: string = '';
  constructor(commentUserName: string,content: string = '',id: string,imageSrc?: ResourceStr,userId?: string,date?: string) {
    this.id = id;
    this.userId = userId;
    this.commentUserName = commentUserName;
    this.content = content;
    this.imageSrc = imageSrc;
    this.date = date;
  }
}