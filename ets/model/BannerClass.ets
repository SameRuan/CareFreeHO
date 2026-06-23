/**
 * BannerClass 定义轮播图属性
 */
export  class BannerClass {
  id: string = '';
  imageSrc: ResourceStr = '';

  constructor(id: string, imageSrc: ResourceStr) {
    this.id = id;
    this.imageSrc = imageSrc;
  }
}