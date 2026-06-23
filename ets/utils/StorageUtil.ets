
export class StorageUtil {

  // 保存token
  static saveToken(token: string): void {
    try {
      // 使用AppStorage保存token
      AppStorage.setOrCreate('userToken', token);
      console.info('Token已保存:', token.substring(0, 10) + '...');
    } catch (error) {
      console.error('保存token失败:', error);
    }
  }

  // 获取token
  static getToken(): string {
    try {
      return AppStorage.get('userToken') || '';
    } catch (error) {
      console.error('获取token失败:', error);
      return '';
    }
  }

  // 保存用户ID
  static saveUserId(userId: string): void {
    try {
      AppStorage.setOrCreate('userId', userId);
    } catch (error) {
      console.error('保存用户ID失败:', error);
    }
  }

  // 获取用户ID
  static getUserId(): string {
    try {
      return AppStorage.get('userId') || '';
    } catch (error) {
      console.error('获取用户ID失败:', error);
      return '';
    }
  }

  // 清除登录信息
  static clearLoginInfo(): void {
    try {
      AppStorage.setOrCreate('userToken', '');
      AppStorage.setOrCreate('userId', '');
      console.info('登录信息已清除');
    } catch (error) {
      console.error('清除登录信息失败:', error);
    }
  }

  // 检查是否已登录
  // StorageUtil.ets - 修改 isLoggedIn 方法
  static isLoggedIn(): boolean {
    const token = StorageUtil.getToken();
    const userId = StorageUtil.getUserId();
    // 更严格的检查
    return token !== '' && token !== null && token !== undefined &&
      userId !== '' && userId !== null && userId !== undefined;
  }
}

