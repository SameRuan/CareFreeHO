/**
 * TopBack组件
 * 跳转后页面头部的统一配置
 */
@Component
export struct Top{
  @Prop title :string
  build() {
    Text(`${this.title}`)
      .fontSize(20)
      .fontWeight(700)
      .width('100%')
      .textAlign(TextAlign.Start)
      .padding({ top: 2, bottom: 12, left:20 })  // 增加上下padding
      .fontFamily('HarmonyOS Sans SC')
      .lineHeight(33)
      // .backgroundColor('#FFFFFF')  // 标题栏添加背景色
      .zIndex(1)  // 确保标题在最上层
  }

}