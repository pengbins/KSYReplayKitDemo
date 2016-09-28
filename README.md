iOS 屏幕直播 (ReplayKit + KSYLive_iOS)

iOS 10 中新增了调用第三方的App扩展来直播屏幕内容的功能, 下面就简单介绍一下如何使用KSYLive_iOS制作一款屏幕直播App.

## 参考资料
关于ReplayKit直播的直观介绍大家可以看WWDC2016上的[视频和PPT](https://developer.apple.com/videos/play/wwdc2016/601/)

## 简单概括屏幕直播使用场景:
1. 在一款游戏中添加一个直播的入口. 
2. 玩家通过这个入口, 可以看到当前设备上已经安装的屏幕直播APP的列表.
3. 选中特定的直播APP后, 会出现配置界面.
4. 确认配置内容后, 回到游戏界面, 屏幕直播APP在后台将屏幕内容和声音直播出去.

从以上使用场景可以看出, 任何一款添加了直播入口的游戏都可以支持任意第三方直播App的直播, 
没有绑定的约束关系. 使用什么直播APP完全由玩家或者主播来选择.

另外在直播的过程中, 游戏的主窗口内的全部内容都会被直播出去.
因此如果游戏将摄像头的预览窗口叠加到游戏画面上, 也会被观众看到.

在直播过程游戏本身播放的声音, 和麦克采集的声音可以分别被采集.

## 基本概念
作为直播App的开发者, 基本不需要关心游戏部分的开发, 而只需要关心直播部分的开发. 没有了以前内置录屏的耦合关系.

WWDC的演示中使用的游戏Fox可以作为我们的被测对象, 代码已经放在 [github]( https://github.com/Mobcrush/ReplayKitDemo)上了. 

### [App扩展](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionOverview.html#//apple_ref/doc/uid/TP40014214-CH2-SW2)
前面说到ReplayKit的录屏是通过App扩展来实现的. 
App扩展跟普通的App不同, 它不能单独发布, 需要内置在一个普通App中, 称为容器App. 但是扩展的执行与容器App完全独立. 
扩展由宿主App发起请求来启动, 与宿主App进行交互.

总结来说以上提到了如下三个概念:
* 宿主App : 比如被录屏的游戏, 
* 容器App : 本身与录屏直播没有直接关系, 仅仅提供录屏App扩展的发布去掉
* 录屏App扩展 : 实现录屏和直播的主要功能

### 

### [KSYLive_iOS](https://github.com/ksvc/KSYLive_iOS)
KSYLive_iOS 是一个提供了直播相关的功能的SDK

