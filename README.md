# LGActivityModule
活动组件
使用步骤:
一.Podfile 文件 加入下面代码:
pod 'LGActivityModule'

二.项目具体使用 1.导入 #import "LGOperationalActivityManager.h"头文件

2.调用方法 - (void)activityManagerWithParam:(NSDictionary *)param;
//Example:

```/*
*参数说明: 
@param BaseUrl : 根路径 (必传)
@param AdUrl :获取广告url (必传)
@param CloseAdUrl : 关闭广告url（可选）
*/

NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        [param setValue:@"rose/app/ad/ex/position.do" forKey:@"AdUrl"];             [param setValue:@"" forKey:@"CloseAdUrl"];
        [param setValue:@"" forKey:@"appId"];
        [param setValue:@"" forKey:@"position"];
        [param setValue:@"9" forKey:@"empNo"];

[[LGOperationalActivityManager shareInstance] activityManagerWithParam:param];
```

