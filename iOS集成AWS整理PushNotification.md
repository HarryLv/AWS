#iOS集成AWS整理PushNotification	
##集成AWS
###[AWS官网连接](https://aws-amplify.github.io/docs/ios/push-notifications)
**案例中是Swift版本，Demo提供了OC版本的集成**
1.Profile 中配置AWS SDK

```
 platform :ios, '9.0'

 target :'YOUR-APP-NAME' do
   use_frameworks!

     pod  'AWSPinpoint', '~> 2.9.0'
     # other pods
     pod  'AWSMobileClient', '~> 2.9.0'
 end

```
运行

```
pod install --repo-update 
``` 

2.导入头文件在AppDelegate中:
```
 import AWSCore
 import AWSPinpoint
 import AWSMobileClient
```
3.初始化，连接AWS服务器，创建Pinpoint对象

```
lass AppDelegate: UIResponder, UIApplicationDelegate {

    /** start code copy **/
    var pinpoint: AWSPinpoint?
    /** end code copy **/

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

         // Other didFinishLaunching code...

         /** start code copy **/
         // Create AWSMobileClient to connect with AWS
     AWSMobileClient.sharedInstance().initialize { (userState, error) in
           if let error = error {
             print("Error initializing AWSMobileClient: \(error.localizedDescription)")
           } else if let userState = userState {
             print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
           }
         }
	    
     // Initialize Pinpoint
         let pinpointConfiguration = AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions)
         pinpoint = AWSPinpoint(configuration: pinpointConfiguration)
         /** end code copy **/
     return true
    }
 }

```
初始化会访问本地awsconfiguration.json文件，成功 userState 返回 guest。

###获取awsconfiguration.json
[amplify 集成](https://aws-amplify.github.io/docs/cli/init?sdk=ios)
执行命令

```
amplify init
amplify push
```
生成awsconfiguration.json放入项目中
###上传token
使用创建好的pinpoint上传token
```
func application(
         _ application: UIApplication,
         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

         pinpoint!.notificationManager.interceptDidRegisterForRemoteNotifications(
             withDeviceToken: deviceToken)
     }
```
AWS后台会通过device token生成Endpoint ID，功能相同


**AWSMobileClient库 部分代码使用Swift编写，如果是使用OC编写的项目，需要进行代码混编的集成**

![](https://img-blog.csdn.net/20180906114322953?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3Fpbl9zaGk=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![](https://upload-images.jianshu.io/upload_images/1709473-6eba1ace47db4161.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000)


