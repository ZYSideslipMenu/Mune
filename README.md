# ZYSideslipMenuView
侧拉菜单框架

1创建ZYTestViewController继承ZYSideslipMenuViewController 之后就能随便操作,
 
    
    ```objc
    //ZYTestViewController 继承ZYSideslipMenuViewController
    ZYTestViewController *vc =[ZYTestViewController shareController];
    ZYqqViewController *zvc = [[ZYqqViewController alloc]init];
    //菜单控制器
    vc.PIMController = zvc;
    //moveX侧滑距离
    vc.moveX = 300;

```
