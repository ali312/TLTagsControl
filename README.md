# TLTagsControl
A nice and simple tags input control for iOS.

You are able to easily setup different colors for control elements and set different displaying modes

#### Switching between displaying modes
You are able to switch between displyaing modes by setting the **mode** property
```
@property (nonatomic) TLTagsControlMode mode;
```

######TLTagsControl has two displaying modes:
```
TLTagsControlModeEdit,
```
This mode allows user to input new tags and delete tags that are already presented.

In this mode control will look like below:

![Screenshot](http://storage4.static.itmages.ru/i/15/0224/h_1424800428_8994378_a18f322acf.png)



```
TLTagsControlModeList,
```
This mode allows only listing of already presented tags

In this mode control will look like below:

![Screenshot](http://storage1.static.itmages.ru/i/15/0224/h_1424800653_7670716_ed0f35f421.png)

#### Setting different colors of control elements
You are able to change colors of different element by setting these prperties
```
@property (nonatomic, strong) UIColor *tagsBackgroungColor;
@property (nonatomic, strong) UIColor *tagsTextColor;
@property (nonatomic, strong) UIColor *tagsDeleteButtonColor;
```

#### Applying changes

To apply your changes you should call the method below

```
- (void)reloadTagSubviews;
```

######Example:

```
//assuming tagControl will be set initialized from stroryboard
@interface ViewController ()

@property (nonatomic, strong) IBOutlet TLTagsControl *tagControl;

@end

....

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIColor *blueBackgroundColor = [UIColor colorWithRed:75.0/255.0 green:186.0/255.0 blue:251.0/255.0 alpha:1];
  UIColor *whiteTextColor = [UIColor whiteColor];
  
  self.tagControl.tagsBackgroungColor = blueBackgroundColor;
  self.tagControl.tagsDeleteButtonColor = whiteTextColor;
  self.tagControl.tagsTextColor = whiteTextColor;
    
  self.tagControl.mode = TLTagsControlModeList;
  
  [self.tagControl reloadTagSubviews];
}

@end
```
![Screenshot](http://storage4.static.itmages.ru/i/15/0224/h_1424801491_9023273_164379e9bd.png)
