import { router } from "@kit.ArkUI"
/**
 * TopBack组件
 * 跳转后页面头部的统一配置
 */
@Component
export struct TopBack{
@Prop title :string
 build() {
   // 顶部标题栏
   Row(){
     //图标
     Image($r('app.media.back'))
       .width('38')
       .height('38')
       .onClick(()=>{
         router.back()
       })
     Text(`${this.title}`)
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
 }

}