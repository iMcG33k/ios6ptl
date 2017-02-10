//
//  UIAlertView+Blocks.m
//  UIKitCategoryAdditions
//

#import "UIAlertView+Blocks.h"

//SW: 为块声明静态存储空间 (也可以通过)
static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

@implementation UIAlertView (Blocks)

+ (UIAlertView*) showAlertViewWithTitle:(NSString*) title                    
                                message:(NSString*) message 
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(DismissBlock) dismissed                   
                               onCancel:(CancelBlock) cancelled {
 
    //SW: 复制到静态存储空间
  _cancelBlock  = [cancelled copy];
  
  _dismissBlock  = [dismissed copy];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:[self self]
                                        cancelButtonTitle:cancelButtonTitle
                                        otherButtonTitles:nil];
  
  for(NSString *buttonTitle in otherButtons)
    [alert addButtonWithTitle:buttonTitle];
  
  [alert show];
  return alert;
}
//SW: 实现UIAlertViewDelegate方法
//Bug: 没有找到这个委托方法。。。  应该是clickedButtonAtIndex
+ (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
  
	if(buttonIndex == [alertView cancelButtonIndex])
	{
		_cancelBlock();
	}
  else
  {
    _dismissBlock(buttonIndex - 1); // cancel button is button 0
  }  
}


@end
